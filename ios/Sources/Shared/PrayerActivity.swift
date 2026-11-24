#if os(iOS) && canImport(ActivityKit)
import ActivityKit
import Foundation

/// Lock Screen / Dynamic Island countdown to the next prayer, or to suhoor and
/// iftar during Ramadan. Started by the app only (no push server), so it shows
/// one event and ends itself when that event arrives.
struct PrayerActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// e.g. "Maghrib" or "Iftar".
        var title: String
        /// e.g. "المغرب" or the city.
        var subtitle: String
        var start: Date
        var target: Date
        var symbol: String
        /// Label before the countdown, e.g. "in" / "dans" / "بعد".
        var lead: String
        /// Pre-formatted clock time of the target ("6:12 PM").
        var time: String
    }

    var place: String
}
#endif
