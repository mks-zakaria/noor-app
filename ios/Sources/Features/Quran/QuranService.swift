import Foundation

struct Ayah: Identifiable, Codable, Hashable {
    let number: Int
    let arabic: String
    let english: String
    var id: Int { number }
}

struct SurahContent: Codable, Hashable {
    let number: Int
    let ayahs: [Ayah]
}

enum QuranService {
    static let bismillah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    static let reciterName = "Mishary Rashid Alafasy"

    private static let arabicEdition = "quran-uthmani"

    /// AlQuran Cloud translation edition for each app language ("ar" → none).
    static func translationEdition(for code: String) -> String? {
        switch code {
        case "fr": return "fr.hamidullah"
        case "ar": return nil
        default: return "en.sahih"
        }
    }

    static func audioURL(surah n: Int) -> URL? {
        URL(string: "https://server8.mp3quran.net/afs/\(String(format: "%03d", n)).mp3")
    }

    /// Fetch a surah (Arabic + optional translation), caching to disk so re-reads work offline.
    static func fetchSurah(_ n: Int, translation: String?) async throws -> SurahContent {
        if let cached = loadCache(n, translation: translation) { return cached }

        let editionList = translation.map { "\(arabicEdition),\($0)" } ?? arabicEdition
        let url = URL(string: "https://api.alquran.cloud/v1/surah/\(n)/editions/\(editionList)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
        let editions = decoded.data
        guard let arabic = editions.first(where: { $0.edition.identifier == arabicEdition }) ?? editions.first else {
            throw URLError(.cannotParseResponse)
        }
        let translated = translation.flatMap { id in editions.first { $0.edition.identifier == id } }

        let ayahs: [Ayah] = arabic.ayahs.enumerated().map { i, a in
            Ayah(number: a.numberInSurah,
                 arabic: a.text,
                 english: (translated?.ayahs.indices.contains(i) ?? false) ? translated!.ayahs[i].text : "")
        }

        let content = SurahContent(number: n, ayahs: ayahs)
        saveCache(content, translation: translation)
        return content
    }

    // MARK: Disk cache

    private static func cacheURL(_ n: Int, translation: String?) -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("noor.surah.\(n).\(translation ?? "ar").json")
    }

    private static func loadCache(_ n: Int, translation: String?) -> SurahContent? {
        guard let data = try? Data(contentsOf: cacheURL(n, translation: translation)),
              let content = try? JSONDecoder().decode(SurahContent.self, from: data),
              !content.ayahs.isEmpty
        else { return nil }
        return content
    }

    private static func saveCache(_ content: SurahContent, translation: String?) {
        guard let data = try? JSONEncoder().encode(content) else { return }
        try? data.write(to: cacheURL(content.number, translation: translation))
    }

    // MARK: API response shapes

    private struct APIResponse: Codable { let data: [Edition] }
    private struct Edition: Codable {
        let ayahs: [APIAyah]
        let edition: EditionInfo
    }
    private struct EditionInfo: Codable { let identifier: String }
    private struct APIAyah: Codable {
        let text: String
        let numberInSurah: Int
    }
}
