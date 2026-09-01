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
