import Foundation
#if os(iOS) && canImport(ActivityKit)
import ActivityKit
#endif

/// Starts, updates or ends the Lock Screen countdown. Local only: it is
/// refreshed whenever the app comes to the foreground, and each activity ends
/// itself when its prayer (or suhoor / iftar) arrives.
enum LiveActivityService {
    static func refresh(settings: SettingsStore, location: LocationManager, langCode: String, now: Date = Date()) {
#if os(iOS) && canImport(ActivityKit)
        guard settings.liveActivity, let c = location.coordinate,
              ActivityAuthorizationInfo().areActivitiesEnabled,
              let event = nextEvent(settings: settings, lat: c.latitude, lng: c.longitude, langCode: langCode, now: now)
        else {
            endAll()
            return
        }
        let state = PrayerActivityAttributes.ContentState(
            title: event.title, subtitle: langCode == "ar" ? "" : event.subtitle, start: event.since, target: event.at,
            symbol: event.symbol, lead: Strings.t("home.in", langCode),
            time: event.at.timeString(hour12: settings.hour12)
        )
        let content = ActivityContent(state: state, staleDate: event.at)
        let running = Activity<PrayerActivityAttributes>.activities
        if let current = running.first {
            guard current.content.state != state else { return }
            Task { await current.update(content) }
            for extra in running.dropFirst() { Task { await extra.end(nil, dismissalPolicy: .immediate) } }
        } else {
            _ = try? Activity.request(attributes: PrayerActivityAttributes(place: location.placeName),
                                      content: content, pushType: nil)
        }
#endif
    }

    static func endAll() {
#if os(iOS) && canImport(ActivityKit)
        for a in Activity<PrayerActivityAttributes>.activities {
            Task { await a.end(nil, dismissalPolicy: .immediate) }
        }
#endif
    }

    /// Suhoor / iftar during Ramadan, otherwise the next prayer.
    static func nextEvent(settings: SettingsStore, lat: Double, lng: Double, langCode: String, now: Date)
        -> (title: String, subtitle: String, at: Date, since: Date, symbol: String)? {
        if let info = RamadanService.currentOrNext(now: now, offset: settings.hijriOffset),
           let e = RamadanService.nextFastingEvent(now: now, info: info, lat: lat, lng: lng,
                                                   method: settings.method, madhab: settings.madhab) {
            return (Strings.t(e.isIftar ? "ramadan.iftar" : "ramadan.suhoorEnds", langCode),
                    e.isIftar ? "الإفطار" : "السحور", e.at, e.since, e.isIftar ? "sunset.fill" : "moon.stars.fill")
        }
        guard let times = PrayerService.computeTimes(lat: lat, lng: lng, method: settings.method, madhab: settings.madhab, date: now),
              let next = PrayerService.nextPrayer(from: times, lat: lat, lng: lng, method: settings.method,
                                                  madhab: settings.madhab, now: now)
        else { return nil }
        // Count from the previous prayer so the progress bar means something.
        let previous = prayerOrder.filter(\.isPrayer).compactMap { times[$0] }.filter { $0 <= now }.max()
            ?? now.addingTimeInterval(-3600)
        return (next.name.label(langCode), next.name.ar, next.at, previous, next.name.systemImage)
    }
}
