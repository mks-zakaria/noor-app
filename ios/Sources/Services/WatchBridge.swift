#if os(iOS) && canImport(WatchConnectivity)
import Foundation
import WatchConnectivity

/// Sends the prayer context to the Apple Watch app, which has no App Group with the phone.
/// Uses the application context: the system keeps only the latest and delivers it when the
/// watch is reachable, so sending on every refresh is cheap and never queues up.
final class WatchBridge: NSObject, WCSessionDelegate {
    static let shared = WatchBridge()
    private var pending: [String: Any]?

    func activate() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func send(_ ctx: SharedPrayerContext, offsets: [Int]) {
        guard WCSession.isSupported(), let data = try? JSONEncoder().encode(ctx) else { return }
        let payload: [String: Any] = ["ctx": data, "offsets": offsets]
        let s = WCSession.default
        guard s.activationState == .activated else { pending = payload; activate(); return }
        guard s.isPaired, s.isWatchAppInstalled else { return }
        try? s.updateApplicationContext(payload)
    }

    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if state == .activated, let p = pending, session.isPaired, session.isWatchAppInstalled {
            try? session.updateApplicationContext(p)
            pending = nil
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
}
#endif
