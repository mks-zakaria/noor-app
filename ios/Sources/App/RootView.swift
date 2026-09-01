import SwiftUI
import StoreKit

struct RootView: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(AdkarProgressStore.self) private var progress
    @Environment(SettingsStore.self) private var settings
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.requestReview) private var requestReview
    @State private var selection = 0
    @State private var celebrationCount: Int?

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tag(0)
                .tabItem { Label(loc.t("tab.prayer"), systemImage: "sun.horizon.fill") }

            QiblaView()
                .tag(1)
                .tabItem { Label(loc.t("tab.qibla"), systemImage: "location.north.line.fill") }

            QuranListView()
                .tag(2)
                .tabItem { Label(loc.t("tab.quran"), systemImage: "book.fill") }

            AdkarView()
                .tag(3)
                .tabItem { Label(loc.t("tab.adkar"), systemImage: "heart.text.square.fill") }

            WirdView()
                .tag(4)
                .tabItem { Label(loc.t("tab.wird"), systemImage: "checklist") }
        }
        .id(loc.code)   // rebuild the tab bar when language changes
        .overlay {
            if let count = celebrationCount {
                AdkarCelebrationOverlay(count: count) {
                    withAnimation(.easeOut(duration: 0.25)) { celebrationCount = nil }
                }
                .transition(.opacity)
            }
        }
        .onAppear(perform: maybeCelebrate)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                maybeCelebrate()
                ReviewPrompt.recordUsage()
                maybeAskForReview()
            }
        }
    }

    /// Ask for a rating only on a calm screen: never over the celebration
    /// overlay, never while the user is mid-task on another tab, and after a
    /// beat so the prompt doesn't collide with the app coming back to life.
    private func maybeAskForReview() {
        guard selection == 0, celebrationCount == nil else { return }
        Task {
            try? await Task.sleep(for: .seconds(2))
            guard selection == 0, celebrationCount == nil, ReviewPrompt.shouldAsk() else { return }
            requestReview()
        }
    }

    /// Fold in any adkar reminders that fired while closed, then felicitate the
    /// user with the running total — at most once per day.
    private func maybeCelebrate() {
        progress.reconcileFiredReminders(enabled: settings.notificationsEnabled && settings.adkarReminders)
        guard progress.globalCount > 0, progress.shouldCelebrateToday() else { return }
        withAnimation { celebrationCount = progress.globalCount }
    }
}
