import Foundation
import Observation

struct Bookmark: Identifiable, Codable, Hashable {
    let surah: Int
    let ayah: Int
    let surahName: String
    let preview: String
    let ts: Double
    var id: String { "\(surah):\(ayah)" }
}

struct LastRead: Codable, Hashable {
    let surah: Int
    let surahName: String
    let ayah: Int
    let ts: Double
}

/// Persisted Quran bookmarks and last-read position.
@Observable
final class BookmarksStore {
    private(set) var bookmarks: [Bookmark] = []
    private(set) var lastRead: LastRead?
    /// Favourited dhikr ids (ordered, most recent first).
    private(set) var favoriteAdkar: [String] = []

    @ObservationIgnored private let d = UserDefaults.standard
    private enum Keys {
        static let bookmarks = "noor.bookmarks.v1"
        static let lastRead = "noor.lastread.v1"
        static let favAdkar = "noor.favadkar.v1"
    }

    init() {
        if let data = d.data(forKey: Keys.bookmarks),
           let list = try? JSONDecoder().decode([Bookmark].self, from: data) {
            bookmarks = list
        }
        if let data = d.data(forKey: Keys.lastRead),
           let lr = try? JSONDecoder().decode(LastRead.self, from: data) {
            lastRead = lr
        }
        favoriteAdkar = d.stringArray(forKey: Keys.favAdkar) ?? []
    }

    // MARK: Adkar favourites

    func isFavoriteDhikr(_ id: String) -> Bool { favoriteAdkar.contains(id) }

    func toggleFavoriteDhikr(_ id: String) {
        if let idx = favoriteAdkar.firstIndex(of: id) {
            favoriteAdkar.remove(at: idx)
        } else {
            favoriteAdkar.insert(id, at: 0)
        }
        d.set(favoriteAdkar, forKey: Keys.favAdkar)
    }

    func isBookmarked(surah: Int, ayah: Int) -> Bool {
        bookmarks.contains { $0.surah == surah && $0.ayah == ayah }
    }

    func toggle(surah: Int, ayah: Int, surahName: String, preview: String) {
        if isBookmarked(surah: surah, ayah: ayah) {
            remove(surah: surah, ayah: ayah)
        } else {
            let bm = Bookmark(surah: surah, ayah: ayah, surahName: surahName,
                              preview: preview, ts: Date().timeIntervalSince1970)
            bookmarks.insert(bm, at: 0)
            persistBookmarks()
        }
    }

    func remove(surah: Int, ayah: Int) {
        bookmarks.removeAll { $0.surah == surah && $0.ayah == ayah }
        persistBookmarks()
    }

    func setLastRead(surah: Int, surahName: String, ayah: Int) {
        lastRead = LastRead(surah: surah, surahName: surahName, ayah: ayah,
                            ts: Date().timeIntervalSince1970)
        if let data = try? JSONEncoder().encode(lastRead) {
            d.set(data, forKey: Keys.lastRead)
        }
    }

    private func persistBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            d.set(data, forKey: Keys.bookmarks)
        }
    }
}
