import SwiftUI

struct QuranListView: View {
    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(LocalizationManager.self) private var loc
    @State private var query = ""

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
                Section(query.isEmpty ? loc.t("quran.surahs") : loc.t("quran.results")) {
                    ForEach(filtered) { surah in
                        NavigationLink { SurahView(surah: surah) } label: {
                            row(surah)
                        }
                        .listRowBackground(Palette.card)
                    }
                }
            }
            .listStyle(.automatic)
            .scrollContentBackground(.hidden)
            .noorBackground()
            .navigationTitle(loc.t("quran.title"))
            .searchable(text: $query, prompt: loc.t("quran.search"))
        }
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
