import Foundation

/// Constants and types shared by the app target and the NoorWidget extension.
/// Both targets compile this single file so the app group contract can never
/// drift between the writer (app) and the reader (widget).
enum WidgetContract {
    /// App Group through which the app publishes widget preferences.
    static let suiteName = "group.com.zakaria.noor.shared"

    enum Keys {
        static let enabled = "noor.widget.enabled"
        static let display = "noor.widget.display"
        static let language = "noor.widget.language"
    }
}

/// Which texts the lock-screen widget shows alongside (or instead of) the Arabic.
enum VerseDisplay: String, CaseIterable, Codable {
    case both
    case arabic
    case english

    var showsArabic: Bool { self != .english }
    var showsEnglish: Bool { self != .arabic }
}

/// Reads the preferences the app last published into the shared container.
struct WidgetPreferences {
    var display: VerseDisplay = .both
    var enabled = true

    static func load() -> WidgetPreferences {
        let defs = UserDefaults(suiteName: WidgetContract.suiteName)
        let display = VerseDisplay(
            rawValue: defs?.string(forKey: WidgetContract.Keys.display) ?? ""
        ) ?? .both
        let enabled = defs?.object(forKey: WidgetContract.Keys.enabled) as? Bool ?? true
        return WidgetPreferences(display: display, enabled: enabled)
    }
}
