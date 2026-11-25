import Foundation

/// The user's own minute corrections per prayer ("match my mosque"), kept in the App Group so the
/// app, the notifications, the widgets and the Live Activity all compute exactly the same times.
/// Compiled into the app AND the widget extension.
enum PrayerTuning {
    /// Order: fajr, sunrise, dhuhr, asr, maghrib, isha.
    static let prayers: [PrayerName] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
    static let range = -30...30
    private static let key = "noor.shared.prayerOffsets"

    static func load() -> [Int] {
        #if os(watchOS)
        let raw = WatchKeychain.data(key).flatMap { try? JSONDecoder().decode([Int].self, from: $0) } ?? []
        #else
        let raw = UserDefaults(suiteName: WidgetContract.suiteName)?.array(forKey: key) as? [Int] ?? []
        #endif
        return raw.count == prayers.count ? raw.map { min(max($0, range.lowerBound), range.upperBound) }
                                          : Array(repeating: 0, count: prayers.count)
    }

    static func save(_ offsets: [Int]) {
        #if os(watchOS)
        if let data = try? JSONEncoder().encode(offsets) { WatchKeychain.set(data, key) }
        #else
        UserDefaults(suiteName: WidgetContract.suiteName)?.set(offsets, forKey: key)
        #endif
    }
}
