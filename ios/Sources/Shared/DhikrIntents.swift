import AppIntents
import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

// Compiled into the app and the NoorWidget extension: the Control Center
// control and the interactive widget run these intents inside the extension,
// Siri / Shortcuts / the Action Button run them in the app.

enum TasbihKinds {
    static let widget = "NoorTasbihWidget"
    static let control = "com.zakaria.noor.tasbih.control"
}

/// Redraws every surface that shows the tasbih count.
func reloadTasbihSurfaces() {
#if canImport(WidgetKit)
    WidgetCenter.shared.reloadTimelines(ofKind: TasbihKinds.widget)
#if os(iOS)
    if #available(iOS 18.0, *) {
        ControlCenter.shared.reloadControls(ofKind: TasbihKinds.control)
    }
#endif
#endif
}

struct CountDhikrIntent: AppIntent {
    static let title: LocalizedStringResource = "Count dhikr"
    static let description = IntentDescription("Adds one to the Noor tasbih counter.")
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        var state = TasbihState.load()
        state.increment()
        state.save()
        reloadTasbihSurfaces()
        return .result(value: state.count)
    }
}

struct ResetDhikrIntent: AppIntent {
    static let title: LocalizedStringResource = "Reset tasbih"
    static let description = IntentDescription("Sets the current Noor tasbih count back to zero.")
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        var state = TasbihState.load()
        state.reset()
        state.save()
        reloadTasbihSurfaces()
        return .result()
    }
}
