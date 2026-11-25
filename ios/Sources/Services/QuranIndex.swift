import Foundation

/// Position of one ayah in the Madani mushaf (604 pages, 30 juz).
struct AyahMeta: Hashable {
    let surah: Int
    let ayah: Int
    let juz: Int
    let page: Int
    let hizbQuarter: Int
}

/// A search hit: which ayah matched and the text it matched in.
struct AyahHit: Identifiable, Hashable {
    let surah: Int
    let ayah: Int
    let text: String
    var id: String { "\(surah):\(ayah)" }
}

/// The whole Quran bundled with the app (`Resources/Quran/quran-*.json`, written by
/// `tools/fetch_quran.py` from AlQuran Cloud: Tanzil Uthmani text, Saheeh
/// International, Hamidullah). Reading, Juz browsing, search and the Khatmah
/// planner all work offline from this one index.
final class QuranIndex: @unchecked Sendable {
    static let shared = QuranIndex()

    static let pageCount = 604
    static let juzCount = 30

    /// Every ayah in mushaf order (6236 rows).
    let meta: [AyahMeta]
    /// Index in `meta` of ayah 1 of each surah (index 0 = surah 1).
    private let surahStart: [Int]

    private let lock = NSLock()
    private var texts: [String: [[String]]] = [:]
    private var normalizedArabic: [[String]]?

    private init(bundle: Bundle = .main) {
        var rows: [AyahMeta] = []
        if let url = bundle.url(forResource: "quran-meta", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let raw = try? JSONDecoder().decode([[Int]].self, from: data) {
            rows = raw.map { AyahMeta(surah: $0[0], ayah: $0[1], juz: $0[2], page: $0[3], hizbQuarter: $0[4]) }
        }
        meta = rows
        var starts: [Int] = []
        for (i, m) in rows.enumerated() where m.ayah == 1 { starts.append(i) }
        surahStart = starts
    }

    var isAvailable: Bool { meta.count == 6236 && surahStart.count == 114 }

    // MARK: Text

    /// Ayah texts of one surah for "ar", "en" or "fr", or nil when not bundled.
    func texts(surah: Int, language: String) -> [String]? {
        guard let all = allTexts(language), all.indices.contains(surah - 1) else { return nil }
        return all[surah - 1]
    }

    private func allTexts(_ language: String) -> [[String]]? {
        lock.lock(); defer { lock.unlock() }
        if let cached = texts[language] { return cached }
        guard let url = Bundle.main.url(forResource: "quran-\(language)", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([[String]].self, from: data),
              decoded.count == 114
        else { return nil }
        texts[language] = decoded
        return decoded
    }

    // MARK: Positions

    func meta(surah: Int, ayah: Int) -> AyahMeta? {
        guard surahStart.indices.contains(surah - 1) else { return nil }
        let i = surahStart[surah - 1] + ayah - 1
        guard meta.indices.contains(i), meta[i].surah == surah else { return nil }
        return meta[i]
    }

    func page(surah: Int, ayah: Int) -> Int? { meta(surah: surah, ayah: ayah)?.page }

    /// First ayah printed on a mushaf page.
    func firstAyah(ofPage page: Int) -> AyahMeta? { meta.first { $0.page == page } }

    /// First ayah of a juz.
    func firstAyah(ofJuz juz: Int) -> AyahMeta? { meta.first { $0.juz == juz } }

    /// True when this ayah is the last one printed on its page.
    func isLastOnPage(surah: Int, ayah: Int) -> Bool {
        guard let m = meta(surah: surah, ayah: ayah) else { return false }
        let i = surahStart[surah - 1] + ayah - 1
        return i == meta.count - 1 || meta[i + 1].page != m.page
    }

    /// Pages fully read once the reader has reached the end of this ayah.
    func completedPages(throughSurah surah: Int, ayah: Int) -> Int? {
        guard let m = meta(surah: surah, ayah: ayah) else { return nil }
        return isLastOnPage(surah: surah, ayah: ayah) ? m.page : m.page - 1
    }

    // MARK: Search

    /// Finds ayahs containing `query`. Arabic queries ignore tashkeel and
    /// alif/hamza/ya/ta-marbuta spelling variants; other queries search the
    /// translation in `language`, case- and accent-insensitively.
    func search(_ query: String, language: String, limit: Int = 100) -> [AyahHit] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return [] }
        var hits: [AyahHit] = []

        if Self.containsArabic(trimmed) {
            let needle = Self.normalizeArabic(trimmed)
            guard !needle.isEmpty, let norm = normalizedArabicTexts(),
                  let ar = allTexts("ar") else { return [] }
            outer: for (s, ayahs) in norm.enumerated() {
                for (a, text) in ayahs.enumerated() where text.contains(needle) {
                    hits.append(AyahHit(surah: s + 1, ayah: a + 1, text: ar[s][a]))
                    if hits.count >= limit { break outer }
                }
            }
        } else {
            let lang = language == "fr" ? "fr" : "en"
            guard let all = allTexts(lang) else { return [] }
            outer: for (s, ayahs) in all.enumerated() {
                for (a, text) in ayahs.enumerated()
                where text.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
                    hits.append(AyahHit(surah: s + 1, ayah: a + 1, text: text))
                    if hits.count >= limit { break outer }
                }
            }
        }
        return hits
    }

    private func normalizedArabicTexts() -> [[String]]? {
        lock.lock()
        if let n = normalizedArabic { lock.unlock(); return n }
        lock.unlock()
        guard let ar = allTexts("ar") else { return nil }
        let n = ar.map { $0.map(Self.normalizeArabic) }
        lock.lock(); normalizedArabic = n; lock.unlock()
        return n
    }

    static func containsArabic(_ s: String) -> Bool {
        s.unicodeScalars.contains { (0x0600...0x06FF).contains($0.value) }
    }

    /// Letters only, with spelling variants folded together so a plainly typed
    /// query ("الرحمن") matches the Uthmani script ("ٱلرَّحْمَٰنِ").
    static func normalizeArabic(_ s: String) -> String {
        var out = String.UnicodeScalarView()
        for scalar in s.unicodeScalars {
            let v = scalar.value
            // Tashkeel, Quranic annotation marks, dagger alif, tatweel.
            if (0x064B...0x065F).contains(v) || v == 0x0670 || v == 0x0640
                || (0x06D6...0x06ED).contains(v) { continue }
            switch v {
            case 0x0622, 0x0623, 0x0625, 0x0671: out.append(UnicodeScalar(0x0627)!)  // آ أ إ ٱ → ا
            case 0x0649: out.append(UnicodeScalar(0x064A)!)                          // ى → ي
            case 0x0629: out.append(UnicodeScalar(0x0647)!)                          // ة → ه
            case 0x0624: out.append(UnicodeScalar(0x0648)!)                          // ؤ → و
            case 0x0626: out.append(UnicodeScalar(0x064A)!)                          // ئ → ي
            default: out.append(scalar)
            }
        }
        return String(out)
    }
}
