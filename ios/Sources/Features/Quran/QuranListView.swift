import SwiftUI

struct QuranListView: View {
    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(LocalizationManager.self) private var loc
    @State private var query = ""
    @State private var mode = 0   // 0 = surahs, 1 = juz
    @State private var hits: [AyahHit] = []

    private var filtered: [Surah] {
        guard !query.isEmpty else { return allSurahs }
        let q = query.lowercased()
        return allSurahs.filter {
            $0.name.lowercased().contains(q)
                || $0.meaning.lowercased().contains(q)
                || $0.arabic.contains(query)
                || String($0.number) == query
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if query.isEmpty {
                    Picker("", selection: $mode) {
                        Text(loc.t("quran.surahs")).tag(0)
                        Text(loc.t("quran.juzList")).tag(1)
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                if query.isEmpty && mode == 1 {
                    juzSection
                } else {
                if query.isEmpty && !bookmarks.bookmarks.isEmpty {
                    Section(loc.t("quran.bookmarks")) {
                        ForEach(bookmarks.bookmarks) { bm in
                            if let s = surah(for: bm.surah) {
                                NavigationLink { SurahView(surah: s) } label: {
                                    bookmarkRow(bm)
                                }
                                .listRowBackground(Palette.card)
                            }
                        }
                        .onDelete { idx in
                            for i in idx {
                                let bm = bookmarks.bookmarks[i]
                                bookmarks.remove(surah: bm.surah, ayah: bm.ayah)
                            }
                        }
                    }
                }
                if !filtered.isEmpty || query.isEmpty {
                    Section(query.isEmpty ? loc.t("quran.surahs") : loc.t("quran.results")) {
                        ForEach(filtered) { surah in
                            NavigationLink { SurahView(surah: surah) } label: {
                                row(surah)
                            }
                            .listRowBackground(Palette.card)
                        }
                    }
                }
                if !hits.isEmpty {
                    Section(String(format: loc.t("quran.ayahResults"), hits.count)) {
                        ForEach(hits) { hit in
                            if let s = surah(for: hit.surah) {
                                NavigationLink { SurahView(surah: s, startAyah: hit.ayah) } label: {
                                    hitRow(hit, surah: s)
                                }
                                .listRowBackground(Palette.card)
                            }
                        }
                    }
                }
                }
            }
            .listStyle(.automatic)
            .scrollContentBackground(.hidden)
            .noorBackground()
            .navigationTitle(loc.t("quran.title"))
            .searchable(text: $query, prompt: loc.t("quran.search"))
            // Full-text search over the bundled Quran, debounced and off the main thread.
            .task(id: query) {
                let q = query
                let lang = loc.code
                guard q.count >= 3 else { hits = []; return }
                try? await Task.sleep(for: .milliseconds(250))
                guard !Task.isCancelled else { return }
                let found = await Task.detached(priority: .userInitiated) {
                    QuranIndex.shared.search(q, language: lang)
                }.value
                if !Task.isCancelled { hits = found }
            }
        }
    }

    private var juzSection: some View {
        Section(loc.t("quran.juzList")) {
            ForEach(1...QuranIndex.juzCount, id: \.self) { juz in
                if let m = QuranIndex.shared.firstAyah(ofJuz: juz), let s = surah(for: m.surah) {
                    NavigationLink { SurahView(surah: s, startAyah: m.ayah) } label: {
                        HStack(spacing: Spacing.three) {
                            ZStack {
                                RoundedRectangle(cornerRadius: Radius.sm, style: .continuous)
                                    .fill(Palette.accentSoft)
                                    .frame(width: 40, height: 40)
                                Text("\(juz)")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(Palette.accent)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(loc.t("quran.juz")) \(juz)")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Palette.text)
                                Text("\(s.displayName(loc.code)) \(m.surah):\(m.ayah) · \(loc.t("quran.page")) \(m.page)")
                                    .font(.caption)
                                    .foregroundStyle(Palette.textSecondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Palette.card)
                }
            }
        }
    }

    private func hitRow(_ hit: AyahHit, surah s: Surah) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(s.displayName(loc.code)) · \(hit.surah):\(hit.ayah)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Palette.primary)
            Text(hit.text)
                .font(QuranIndex.containsArabic(hit.text) ? .system(size: 18) : .subheadline)
                .foregroundStyle(Palette.text)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: QuranIndex.containsArabic(hit.text) ? .trailing : .leading)
                .multilineTextAlignment(QuranIndex.containsArabic(hit.text) ? .trailing : .leading)
        }
        .padding(.vertical, 2)
    }

    private func surah(for number: Int) -> Surah? {
        allSurahs.first { $0.number == number }
    }

    private func bookmarkRow(_ bm: Bookmark) -> some View {
        HStack(spacing: Spacing.three) {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(Palette.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(bm.surahName) · \(bm.surah):\(bm.ayah)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.text)
                if !bm.preview.isEmpty {
                    Text(bm.preview)
                        .font(.caption)
                        .foregroundStyle(Palette.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 2)
    }

    private func row(_ s: Surah) -> some View {
        HStack(spacing: Spacing.three) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.sm, style: .continuous)
                    .fill(Palette.primarySoft)
                    .frame(width: 40, height: 40)
                Text("\(s.number)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Palette.primary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(s.displayName(loc.code))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Palette.text)
                Text("\(s.displayMeaning(loc.code)) · \(s.ayahs) \(loc.t("quran.ayahs")) · \(s.place.label(loc.code))")
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
            }
            Spacer()
            if loc.code != "ar" {
                Text(s.arabic)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Palette.primary)
            }
        }
        .padding(.vertical, 4)
    }
}
