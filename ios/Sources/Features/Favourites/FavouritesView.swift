import SwiftUI

struct FavouritesView: View {
    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(LocalizationManager.self) private var loc

    private var favDhikr: [Dhikr] {
        let all = adkarCategories.flatMap { $0.items }
        return bookmarks.favoriteAdkar.compactMap { id in all.first { $0.id == id } }
    }

    var body: some View {
        List {
            if bookmarks.bookmarks.isEmpty && favDhikr.isEmpty {
                ContentUnavailableView(
                    loc.t("favourites.empty"),
                    systemImage: "heart",
                    description: Text(loc.t("favourites.emptyDesc"))
                )
                .listRowBackground(Color.clear)
            }

            if !bookmarks.bookmarks.isEmpty {
                Section(loc.t("favourites.quran")) {
                    ForEach(bookmarks.bookmarks) { bm in
                        if let s = allSurahs.first(where: { $0.number == bm.surah }) {
                            NavigationLink { SurahView(surah: s) } label: { quranRow(bm) }
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

            if !favDhikr.isEmpty {
                Section(loc.t("favourites.adkar")) {
                    ForEach(favDhikr) { d in
                        dhikrRow(d).listRowBackground(Palette.card)
                    }
                    .onDelete { idx in
                        for i in idx { bookmarks.toggleFavoriteDhikr(favDhikr[i].id) }
                    }
                }
            }
        }
        .listStyle(.automatic)
        .scrollContentBackground(.hidden)
        .noorBackground()
        .navigationTitle(loc.t("favourites.title"))
    }

    private func quranRow(_ bm: Bookmark) -> some View {
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

    private func dhikrRow(_ d: Dhikr) -> some View {
        VStack(alignment: .leading, spacing: Spacing.two) {
            Text(d.arabic)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Palette.text)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            let translation = d.displayTranslation(loc.code).isEmpty ? d.translation : d.displayTranslation(loc.code)
            if !translation.isEmpty {
                Text(translation)
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}
