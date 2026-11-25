import SwiftUI
import WidgetKit
import WatchConnectivity

@main
struct NoorWatchApp: App {
    @State private var sync = WatchSync.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NextPrayerScreen(ctx: sync.context)
            }
            .onAppear { sync.activate() }
        }
    }
}

/// Receives the prayer context from the iPhone (WatchBridge on the phone side) and keeps it
/// where the complications can read it.
@Observable
final class WatchSync: NSObject, WCSessionDelegate {
    static let shared = WatchSync()
    private(set) var context: SharedPrayerContext? = SharedPrayerContext.load()

    func activate() {
        #if DEBUG
        // Screenshots and simulator checks only: a simulator watch has no paired iPhone to send
        // a context. Compiled out of release builds.
        if ProcessInfo.processInfo.arguments.contains("-demoContext") {
            let lang = ProcessInfo.processInfo.arguments.drop { $0 != "-lang" }.dropFirst().first ?? "en"
            apply(["ctx": try! JSONEncoder().encode(SharedPrayerContext(
                lat: 33.5731, lng: -7.5898, method: MethodKey.morocco.rawValue, madhab: MadhabKey.shafi.rawValue,
                hour12: lang == "en", language: lang, place: "Casablanca", hijriOffset: 0))])
        }
        #endif
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        if WCSession.default.activationState != .activated { WCSession.default.activate() }
        apply(WCSession.default.receivedApplicationContext)
    }

    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        apply(session.receivedApplicationContext)
    }

    func session(_ session: WCSession, didReceiveApplicationContext ctx: [String: Any]) {
        apply(ctx)
    }

    /// Payload: "ctx" = SharedPrayerContext JSON, "offsets" = per-prayer minute offsets.
    private func apply(_ payload: [String: Any]) {
        guard let data = payload["ctx"] as? Data,
              let ctx = try? JSONDecoder().decode(SharedPrayerContext.self, from: data) else { return }
        if let offsets = payload["offsets"] as? [Int] { PrayerTuning.save(offsets) }
        ctx.save()
        DispatchQueue.main.async {
            self.context = ctx
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

/// The watch face of the app: the next prayer with a live countdown, then today's five prayers.
struct NextPrayerScreen: View {
    let ctx: SharedPrayerContext?

    var body: some View {
        if let ctx {
            TimelineView(.everyMinute) { tl in
                if let s = PrayerSnapshot.make(ctx, at: tl.date) {
                    content(s)
                } else {
                    waiting
                }
            }
        } else {
            waiting
        }
    }

    private func content(_ s: PrayerSnapshot) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(s.t("widget.nextPrayer").uppercased())
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(s.name(s.next.name))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.noorGold)
                HStack(alignment: .firstTextBaseline) {
                    Text(s.clock(s.next.at)).font(.headline)
                    Spacer()
                    Text(s.next.at, style: .timer)
                        .font(.footnote.monospacedDigit())
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
                Divider().padding(.vertical, 2)
                ForEach(prayerOrder.filter(\.isPrayer), id: \.self) { p in
                    if let at = s.times[p] {
                        HStack {
                            Text(s.name(p))
                            Spacer()
                            Text(s.clock(at)).monospacedDigit()
                        }
                        .font(.footnote.weight(p == s.next.name ? .bold : .regular))
                        .foregroundStyle(p == s.next.name ? Color.noorGold : .primary)
                    }
                }
                if !s.ctx.place.isEmpty {
                    Label(s.ctx.place, systemImage: "location.fill")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 4)
        }
        .environment(\.layoutDirection, s.lang == "ar" ? .rightToLeft : .leftToRight)
        .containerBackground(Color.noorDeep.gradient, for: .navigation)
    }

    /// Before the iPhone has sent a location: say where to look, nothing else.
    private var waiting: some View {
        VStack(spacing: 8) {
            Image(systemName: "iphone").font(.title2).foregroundStyle(Color.noorGold)
            Text(Strings.t("watch.openPhone", WatchSync.languageGuess))
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

extension WatchSync {
    /// Before any context arrives: the watch's own language, if Noor supports it.
    static var languageGuess: String {
        let pref = Locale.preferredLanguages.first ?? "en"
        return pref.hasPrefix("ar") ? "ar" : pref.hasPrefix("fr") ? "fr" : "en"
    }
}
