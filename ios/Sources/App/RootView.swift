import SwiftUI
import StoreKit

struct RootView: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(AdkarProgressStore.self) private var progress
    @Environment(SettingsStore.self) private var settings
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.requestReview) private var requestReview
    @State private var selection = RootView.initialTab
    @State private var celebrationCount: Int?

    /// 0 in release. Debug builds accept `-tab <n>` so screenshots can open any tab.
    private static var initialTab: Int {
        #if DEBUG
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "-tab"), i + 1 < args.count, let n = Int(args[i + 1]) { return n }
        #endif
        return 0
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tag(0)
                .tabItem { Label(loc.t("tab.prayer"), systemImage: "sun.horizon.fill") }

#if !os(macOS)
            QiblaView()
                .tag(1)
                .tabItem { Label(loc.t("tab.qibla"), systemImage: "location.north.line.fill") }
#endif

            QuranListView()
                .tag(2)
                .tabItem { Label(loc.t("tab.quran"), systemImage: "book.fill") }

            AdkarView()
                .tag(3)
                .tabItem { Label(loc.t("tab.adkar"), systemImage: "heart.text.square.fill") }

            IbadahView()
                .tag(4)
                .tabItem { Label(loc.t("tab.ibadah"), systemImage: "checklist") }
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
