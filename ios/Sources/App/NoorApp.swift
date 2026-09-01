import SwiftUI
import UserNotifications

@main
struct NoorApp: App {
    @State private var settings = SettingsStore()
    @State private var location = LocationManager()
    @State private var bookmarks = BookmarksStore()
    @State private var loc = LocalizationManager()
    @State private var adkarProgress = AdkarProgressStore()
    @Environment(\.scenePhase) private var scenePhase

    private let notifDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notifDelegate
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
                .environment(location)
                .environment(bookmarks)
                .environment(loc)
                .environment(adkarProgress)
                .environment(\.locale, loc.locale)
                .environment(\.layoutDirection, loc.isRTL ? .rightToLeft : .leftToRight)
                .tint(Palette.primary)
                .preferredColorScheme(settings.theme.colorScheme)
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        // Publishes current widget prefs + UI language into the
                        // App Group so the widget always matches the app.
                        settings.pushToWidget(language: loc.code)
                        NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
                    }
                }
        }
    }
}
