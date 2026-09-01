import Foundation
import Observation

/// Persisted user preferences (calculation method, madhab, formatting, notifications).
@Observable
final class SettingsStore {
    var method: MethodKey { didSet { d.set(method.rawValue, forKey: Keys.method) } }
    var madhab: MadhabKey { didSet { d.set(madhab.rawValue, forKey: Keys.madhab) } }
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

    @ObservationIgnored private let d = UserDefaults.standard

    private enum Keys {
        static let method = "noor.method"
        static let madhab = "noor.madhab"
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
    }

    static let defaultPrayers: Set<String> = ["fajr", "dhuhr", "asr", "maghrib", "isha"]

    /// The five paces the reader can step through, in points per second. The
    /// middle one is roughly the speed of unhurried recitation at the default
    /// text size; the slowest suits tajwīd, the fastest suits review.
    static let autoScrollSpeeds: [Double] = [12, 20, 30, 45, 65]

    init() {
        method = MethodKey(rawValue: d.string(forKey: Keys.method) ?? "") ?? .muslimWorldLeague
        madhab = MadhabKey(rawValue: d.string(forKey: Keys.madhab) ?? "") ?? .shafi
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
    }

    /// Initial sync happens in the app's scene-phase handler, where the active
    /// language is known — the store alone can't see LocalizationManager.
    func pushToWidget(language: String? = nil) {
        WidgetSync.push(enabled: widgetEnabled, display: widgetDisplay, language: language ?? "")
    }
}
