import AppIntents

/// Makes the tasbih counter available to Siri, Spotlight, the Shortcuts app and
/// the Action Button (Settings › Action Button › Shortcut › Noor).
struct NoorShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CountDhikrIntent(),
            phrases: ["Count dhikr in \(.applicationName)", "Tasbih in \(.applicationName)"],
            shortTitle: "Count dhikr",
            systemImageName: "circle.dotted.circle"
        )
        AppShortcut(
            intent: ResetDhikrIntent(),
            phrases: ["Reset tasbih in \(.applicationName)"],
            shortTitle: "Reset tasbih",
            systemImageName: "arrow.counterclockwise"
        )
    }
}
