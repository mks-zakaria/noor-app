import Foundation
import Observation

/// Persisted user preferences (calculation method, madhab, formatting, notifications).
@Observable
final class SettingsStore {
    var method: MethodKey { didSet { d.set(method.rawValue, forKey: Keys.method) } }
    var madhab: MadhabKey { didSet { d.set(madhab.rawValue, forKey: Keys.madhab) } }
    /// Use the official method (and Asr madhab) of the country the user is in. On by default for
    /// anyone who never picked a method; picking one by hand turns it off.
    var methodAuto: Bool { didSet { d.set(methodAuto, forKey: Keys.methodAuto) } }
    /// Minute corrections per prayer (fajr, sunrise, dhuhr, asr, maghrib, isha) to match the local mosque.
    var prayerOffsets: [Int] { didSet { PrayerTuning.save(prayerOffsets) } }
    var hour12: Bool { didSet { d.set(hour12, forKey: Keys.hour12) } }
    /// Light / dark / follow-system appearance.
    var theme: AppTheme { didSet { d.set(theme.rawValue, forKey: Keys.theme) } }
    /// Manual Hijri date correction in days (regional moon-sighting varies ±1–2).
    var hijriOffset: Int { didSet { d.set(hijriOffset, forKey: Keys.hijriOffset) } }
    var notificationsEnabled: Bool { didSet { d.set(notificationsEnabled, forKey: Keys.notifications) } }
    /// Send morning & evening adkar reminders; each fired reminder counts toward the adkar total.
    var adkarReminders: Bool { didSet { d.set(adkarReminders, forKey: Keys.adkarReminders) } }
    var adhanSound: Bool { didSet { d.set(adhanSound, forKey: Keys.adhanSound) } }
    /// Deliver the adhan as a Critical Alert (overrides silent/Focus). Needs the
    /// critical-alerts entitlement + user grant to actually bypass silent.
    var criticalAdhan: Bool { didSet { d.set(criticalAdhan, forKey: Keys.criticalAdhan) } }
    /// Multiplier for the Quran Arabic text size (0.8–1.8).
    var quranFontScale: Double { didSet { d.set(quranFontScale, forKey: Keys.quranFontScale) } }
    /// Auto-scroll pace while reading, in points per second.
    var quranAutoScrollSpeed: Double {
        didSet { d.set(quranAutoScrollSpeed, forKey: Keys.quranAutoScrollSpeed) }
    }
    /// Raw values of prayers that should notify.
    var enabledPrayers: Set<String> {
        didSet { d.set(Array(enabledPrayers), forKey: Keys.enabledPrayers) }
    }
    /// Whether the lock-screen verse widget shows content at all.
    var widgetEnabled: Bool {
        didSet {
            d.set(widgetEnabled, forKey: Keys.widgetEnabled)
            pushToWidget()
        }
    }
    /// Which texts the widget shows alongside (or instead of) the Arabic.
    var widgetDisplay: VerseDisplay {
        didSet {
            d.set(widgetDisplay.rawValue, forKey: Keys.widgetDisplay)
            pushToWidget()
        }
    }

    // Ramadan
    /// Minutes before Fajr that Imsak is shown in the timetable (0 = none).
    var imsakMinutes: Int { didSet { d.set(imsakMinutes, forKey: Keys.imsakMinutes) } }
    /// Notify before suhoor ends during Ramadan.
    var suhoorReminder: Bool { didSet { d.set(suhoorReminder, forKey: Keys.suhoorReminder) } }
    /// How many minutes before Fajr the suhoor reminder fires.
    var suhoorLeadMinutes: Int { didSet { d.set(suhoorLeadMinutes, forKey: Keys.suhoorLead) } }
    /// Maghrib alert worded as iftar, with the iftar du'a, during Ramadan.
    var iftarAlert: Bool { didSet { d.set(iftarAlert, forKey: Keys.iftarAlert) } }
    /// Reminder on the evenings that begin the odd nights of the last ten.
    var qadrReminders: Bool { didSet { d.set(qadrReminders, forKey: Keys.qadrReminders) } }
    /// Countdown to the next prayer (or suhoor / iftar) on the Lock Screen.
    var liveActivity: Bool { didSet { d.set(liveActivity, forKey: Keys.liveActivity) } }

    @ObservationIgnored private let d = UserDefaults.standard

    private enum Keys {
        static let method = "noor.method"
        static let madhab = "noor.madhab"
        static let methodAuto = "noor.methodAuto"
        static let hour12 = "noor.hour12"
        static let theme = "noor.theme"
        static let hijriOffset = "noor.hijriOffset"
        static let notifications = "noor.notifications"
        static let adkarReminders = "noor.adkarReminders"
        static let adhanSound = "noor.adhanSound"
        static let criticalAdhan = "noor.criticalAdhan"
        static let enabledPrayers = "noor.enabledPrayers"
        static let quranFontScale = "noor.quranFontScale"
        static let quranAutoScrollSpeed = "noor.quranAutoScrollSpeed"
        static let widgetEnabled = "noor.widgetEnabled"
        static let widgetDisplay = "noor.widgetDisplay"
        static let imsakMinutes = "noor.ramadan.imsakMinutes"
        static let suhoorReminder = "noor.ramadan.suhoorReminder"
        static let suhoorLead = "noor.ramadan.suhoorLead"
        static let iftarAlert = "noor.ramadan.iftarAlert"
        static let qadrReminders = "noor.ramadan.qadrReminders"
        static let liveActivity = "noor.liveActivity"
    }

    /// While Automatic is on, switch to the official method of `countryCode`.
    /// Returns true when the method or madhab changed (callers then reschedule).
    @discardableResult
    func applyCountry(_ countryCode: String) -> Bool {
        guard methodAuto, !countryCode.isEmpty else { return false }
        let pick = MethodKey.forCountry(countryCode)
        guard pick.method != method || pick.madhab != madhab else { return false }
        method = pick.method
        madhab = pick.madhab
        return true
    }

    static let defaultPrayers: Set<String> = ["fajr", "dhuhr", "asr", "maghrib", "isha"]

    /// The five paces the reader can step through, in points per second. The
    /// middle one is roughly the speed of unhurried recitation at the default
    /// text size; the slowest suits tajwīd, the fastest suits review.
    static let autoScrollSpeeds: [Double] = [12, 20, 30, 45, 65]

    init() {
        method = MethodKey(rawValue: d.string(forKey: Keys.method) ?? "") ?? .muslimWorldLeague
        madhab = MadhabKey(rawValue: d.string(forKey: Keys.madhab) ?? "") ?? .shafi
        // Someone who already chose a method in an earlier version keeps it.
        methodAuto = d.object(forKey: Keys.methodAuto) as? Bool ?? (d.string(forKey: Keys.method) == nil)
        prayerOffsets = PrayerTuning.load()
        hour12 = d.object(forKey: Keys.hour12) as? Bool ?? true
        theme = AppTheme(rawValue: d.string(forKey: Keys.theme) ?? "") ?? .system
        hijriOffset = d.object(forKey: Keys.hijriOffset) as? Int ?? 0
        notificationsEnabled = d.object(forKey: Keys.notifications) as? Bool ?? false
        adkarReminders = d.object(forKey: Keys.adkarReminders) as? Bool ?? true
        adhanSound = d.object(forKey: Keys.adhanSound) as? Bool ?? true
        criticalAdhan = d.object(forKey: Keys.criticalAdhan) as? Bool ?? false
        quranFontScale = d.object(forKey: Keys.quranFontScale) as? Double ?? 1.0
        let savedSpeed = d.object(forKey: Keys.quranAutoScrollSpeed) as? Double
        quranAutoScrollSpeed = Self.autoScrollSpeeds.contains(savedSpeed ?? 0)
            ? savedSpeed! : Self.autoScrollSpeeds[2]
        if let saved = d.stringArray(forKey: Keys.enabledPrayers) {
            enabledPrayers = Set(saved)
        } else {
            enabledPrayers = Self.defaultPrayers
        }
        widgetEnabled = d.object(forKey: Keys.widgetEnabled) as? Bool ?? true
        widgetDisplay = VerseDisplay(rawValue: d.string(forKey: Keys.widgetDisplay) ?? "") ?? .both
        imsakMinutes = d.object(forKey: Keys.imsakMinutes) as? Int ?? 10
        suhoorReminder = d.object(forKey: Keys.suhoorReminder) as? Bool ?? true
        suhoorLeadMinutes = d.object(forKey: Keys.suhoorLead) as? Int ?? 30
        iftarAlert = d.object(forKey: Keys.iftarAlert) as? Bool ?? true
        qadrReminders = d.object(forKey: Keys.qadrReminders) as? Bool ?? true
        liveActivity = d.object(forKey: Keys.liveActivity) as? Bool ?? false
    }

    /// Initial sync happens in the app's scene-phase handler, where the active
    /// language is known — the store alone can't see LocalizationManager.
    func pushToWidget(language: String? = nil) {
        WidgetSync.push(enabled: widgetEnabled, display: widgetDisplay, language: language ?? "")
    }
}
