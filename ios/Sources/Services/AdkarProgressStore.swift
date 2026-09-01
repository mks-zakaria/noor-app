import Foundation
import Observation

/// Lifetime counter of adkar completed — both those tapped through in-app and the
/// scheduled reminders that fired while the app was closed. Also gates the
/// once-per-day felicitation overlay shown on app open.
@Observable
final class AdkarProgressStore {
    private(set) var globalCount: Int

    @ObservationIgnored private let d = UserDefaults.standard
    private enum Keys {
        static let count = "noor.adkar.globalCount.v1"
        static let lastReconcile = "noor.adkar.lastReconcile.v1"
        static let lastCelebration = "noor.adkar.lastCelebration.v1"
    }

    init() {
        globalCount = d.integer(forKey: Keys.count)
    }

    /// Count one dhikr the user just completed in-app.
    func increment() {
        globalCount += 1
        d.set(globalCount, forKey: Keys.count)
    }

    // MARK: - Notification reconciliation

    /// Adds any adkar reminders that fired since the last check to the global count.
    /// Returns how many were newly added. On the very first launch there is no
    /// baseline, so we just anchor the timestamp and add nothing.
    @discardableResult
    func reconcileFiredReminders(enabled: Bool, now: Date = Date()) -> Int {
        guard let last = d.object(forKey: Keys.lastReconcile) as? Date else {
            d.set(now, forKey: Keys.lastReconcile)
            return 0
        }
        d.set(now, forKey: Keys.lastReconcile)
        guard enabled else { return 0 }

        let fired = Self.reminderFireCount(from: last, to: now)
        if fired > 0 {
            globalCount += fired
            d.set(globalCount, forKey: Keys.count)
        }
        return fired
    }

    /// Number of daily-reminder fire times falling within `(start, end]`.
    static func reminderFireCount(from start: Date, to end: Date, calendar: Calendar = .current) -> Int {
        guard end > start else { return 0 }
        var count = 0
        var day = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        while day <= endDay {
            for hour in NotificationService.adkarReminderHours {
                if let fire = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day),
                   fire > start, fire <= end {
                    count += 1
                }
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return count
    }

    // MARK: - Daily celebration

    /// True at most once per calendar day. Marks today as celebrated when it returns true.
    func shouldCelebrateToday(now: Date = Date(), calendar: Calendar = .current) -> Bool {
        if let last = d.object(forKey: Keys.lastCelebration) as? Date,
           calendar.isDate(last, inSameDayAs: now) {
            return false
        }
        d.set(calendar.startOfDay(for: now), forKey: Keys.lastCelebration)
        return true
    }
}
