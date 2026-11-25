import SwiftUI
import UserNotifications

@main
struct NoorApp: App {
    @State private var settings = SettingsStore()
    @State private var location = LocationManager()
    @State private var bookmarks = BookmarksStore()
    @State private var loc = LocalizationManager()
    @State private var adkarProgress = AdkarProgressStore()
    @State private var khatmah = KhatmahStore()
    @State private var prayerLog = PrayerLogStore.shared
    @State private var ramadan = RamadanStore()
    @Environment(\.scenePhase) private var scenePhase

    private let notifDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notifDelegate
        #if os(iOS) && canImport(WatchConnectivity)
        WatchBridge.shared.activate()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
                .environment(location)
                .environment(bookmarks)
                .environment(loc)
                .environment(adkarProgress)
                .environment(khatmah)
                .environment(prayerLog)
                .environment(ramadan)
                .environment(\.locale, loc.locale)
                .environment(\.layoutDirection, loc.isRTL ? .rightToLeft : .leftToRight)
                .tint(Palette.primary)
                .preferredColorScheme(settings.theme.colorScheme)
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        settings.applyCountry(location.countryCode)
                        // Publishes current widget prefs + UI language into the
                        // App Group so the widget always matches the app.
                        settings.pushToWidget(language: loc.code)
                        NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
                        LiveActivityService.refresh(settings: settings, location: location, langCode: loc.code)
                    }
                    #if os(iOS)
                    if phase == .background { BackgroundRefresh.submit() }
                    #endif
                }
                // Arriving in another country (or the first fix) switches to its official method.
                .onChange(of: location.countryCode) { _, code in
                    if settings.applyCountry(code) {
                        NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
                        LiveActivityService.refresh(settings: settings, location: location, langCode: loc.code)
                    }
                }
        }
        #if os(macOS)
        // A Mac window big enough for the prayer list and the Quran (it opened at 900x450).
        .defaultSize(width: 1280, height: 800)
        #endif
        #if os(iOS)
        // Keeps the adhan schedule rolling for people who rarely open the app
        // (the ~10-day window would otherwise run out). Queues the next run first.
        .backgroundTask(.appRefresh(BackgroundRefresh.taskID)) {
            BackgroundRefresh.submit()
            await MainActor.run { _ = NotificationService.refreshFromSavedContext() }
        }
        #endif
    }
}
