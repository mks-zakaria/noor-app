import Foundation
import WidgetKit

/// Publishes widget preferences into the App Group container and asks the
/// system to redraw every Noor widget. Called from the settings store whenever
/// a widget-related preference changes.
enum WidgetSync {
    static func push(enabled: Bool, display: VerseDisplay, language: String) {
        let defs = UserDefaults(suiteName: WidgetContract.suiteName)
        defs?.set(display.rawValue, forKey: WidgetContract.Keys.display)
        defs?.set(enabled, forKey: WidgetContract.Keys.enabled)
        // Language arrives only from callers that know LocalizationManager's
        // state; preference-only pushes leave the last known value untouched.
        if !language.isEmpty {
            defs?.set(language, forKey: WidgetContract.Keys.language)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}

/// Publishes what the prayer widgets need to compute times on their own.
enum PrayerContextSync {
    /// Kinds of every widget that computes prayer times (see Widget/PrayerWidget.swift).
    static let prayerWidgetKinds = ["NoorPrayerWidget", "NoorRamadanWidget", "NoorTodayWidget"]

    static func push(settings: SettingsStore, location: LocationManager, langCode: String) {
        guard let c = location.coordinate else { return }
        let ctx = SharedPrayerContext(
            lat: c.latitude, lng: c.longitude,
            method: settings.method.rawValue, madhab: settings.madhab.rawValue,
            hour12: settings.hour12, language: langCode, place: location.placeName,
            hijriOffset: settings.hijriOffset,
            offsets: PrayerTuning.load()
        )
        if ctx.save() {
            for kind in prayerWidgetKinds { WidgetCenter.shared.reloadTimelines(ofKind: kind) }
        }
        #if os(iOS) && canImport(WatchConnectivity)
        // Every refresh, not only on change: the watch may have been paired or reinstalled since.
        WatchBridge.shared.send(ctx, offsets: PrayerTuning.load())
        #endif
    }
}
