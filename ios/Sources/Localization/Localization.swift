import Foundation
import Observation

enum AppLanguage: String, CaseIterable, Identifiable {
    case system, en, fr, ar
    var id: String { rawValue }
    /// Name shown in the language picker, in its own language.
    var nativeName: String {
        switch self {
        case .system: return ""   // resolved via Strings "lang.system"
        case .en: return "English"
        case .fr: return "Français"
        case .ar: return "العربية"
        }
    }
}

/// Holds the selected UI language and resolves localized strings.
@Observable
final class LocalizationManager {
    var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "noor.language") }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "noor.language") ?? "system"
        language = AppLanguage(rawValue: raw) ?? .system
    }

    /// Resolved language code: "en", "fr", or "ar".
    var code: String {
        guard language == .system else { return language.rawValue }
        let pref = Locale.preferredLanguages.first ?? "en"
        if pref.hasPrefix("ar") { return "ar" }
        if pref.hasPrefix("fr") { return "fr" }
        return "en"
    }

    var isRTL: Bool { code == "ar" }
    var locale: Locale { Locale(identifier: code) }

    /// Localized UI string for a key (falls back to English, then the key itself).
    func t(_ key: String) -> String {
        let row = Strings.table[key]
        return row?[code] ?? row?["en"] ?? key
    }
}

// MARK: - Localized accessors for data models

extension PrayerName {
    /// Localized display name.
    func label(_ code: String) -> String {
        Strings.table["prayer.\(rawValue)"]?[code] ?? en
    }
}

extension RevelationPlace {
    func label(_ code: String) -> String {
        let key = self == .meccan ? "place.meccan" : "place.medinan"
        return Strings.table[key]?[code] ?? rawValue
    }
}

extension Surah {
    /// Transliteration for en/fr, Arabic name for ar.
    func displayName(_ code: String) -> String { code == "ar" ? arabic : name }
    func displayMeaning(_ code: String) -> String { code == "fr" ? meaningFr : meaning }
}

extension AdkarCategory {
    func displayTitle(_ code: String) -> String {
        switch code {
        case "fr": return titleFr
        case "ar": return titleAr
        default: return title
        }
    }
    func displaySubtitle(_ code: String) -> String {
        switch code {
        case "fr": return subtitleFr
        case "ar": return subtitleAr
        default: return subtitle
        }
    }
}

extension Dhikr {
    /// English/French translation; empty for Arabic (the dhikr is already Arabic).
    func displayTranslation(_ code: String) -> String {
        switch code {
        case "fr": return translationFr
        case "ar": return ""
        default: return translation
        }
    }
    /// Transliteration is only useful for non-Arabic readers.
    func showTranslit(_ code: String) -> Bool { code != "ar" }
}
