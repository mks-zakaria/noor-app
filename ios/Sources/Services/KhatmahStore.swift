import Foundation
import Observation

/// A plan to read the whole Quran (604 Madani pages) between two dates.
struct KhatmahPlan: Codable, Equatable {
    /// First day of the plan (start of day).
    var startDate: Date
    /// Last day of the plan, inclusive (start of day).
    var endDate: Date
    /// Pages finished so far, 0…604.
    var pagesRead: Int
    /// "ramadan" or "days".
    var kind: String
    /// Pages already read when today began; fixes today's portion for the whole day.
    var dayStartPages: Int
    var dayStartKey: String
}

/// The portion arithmetic, kept pure so it can be unit-tested.
enum KhatmahMath {
    static let totalPages = QuranIndex.pageCount

    static func days(from a: Date, to b: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.day], from: calendar.startOfDay(for: a), to: calendar.startOfDay(for: b)).day ?? 0
    }

    /// Days in the plan, counting both ends.
    static func totalDays(_ plan: KhatmahPlan, calendar: Calendar = .current) -> Int {
        max(1, days(from: plan.startDate, to: plan.endDate, calendar: calendar) + 1)
    }

    /// True while a plan made in advance (e.g. before Ramadan) has not begun.
    static func hasNotStarted(_ plan: KhatmahPlan, today: Date, calendar: Calendar = .current) -> Bool {
        calendar.startOfDay(for: today) < plan.startDate
    }

    /// Days left including today (at least 1, even when the end date has passed).
    static func remainingDays(_ plan: KhatmahPlan, today: Date, calendar: Calendar = .current) -> Int {
        let from = max(calendar.startOfDay(for: today), plan.startDate)
        return max(1, days(from: from, to: plan.endDate, calendar: calendar) + 1)
    }

    /// The last page today's portion ends on, based on where today started.
    static func todayEndPage(_ plan: KhatmahPlan, today: Date, calendar: Calendar = .current) -> Int {
        let start = plan.dayStartPages
        if hasNotStarted(plan, today: today, calendar: calendar) { return start }
        let left = totalPages - start
        guard left > 0 else { return totalPages }
        let perDay = Int((Double(left) / Double(remainingDays(plan, today: today, calendar: calendar))).rounded(.up))
        return min(totalPages, start + perDay)
    }

    /// Pages that should be finished by the end of yesterday on an even schedule.
    static func expectedByYesterday(_ plan: KhatmahPlan, today: Date, calendar: Calendar = .current) -> Int {
        let elapsed = max(0, days(from: plan.startDate, to: today, calendar: calendar))
        let total = totalDays(plan, calendar: calendar)
        return min(totalPages, Int((Double(totalPages) * Double(elapsed) / Double(total)).rounded(.up)))
    }

    /// Positive = pages ahead of schedule, negative = behind.
    static func scheduleDelta(_ plan: KhatmahPlan, today: Date, calendar: Calendar = .current) -> Int {
        plan.pagesRead - expectedByYesterday(plan, today: today, calendar: calendar)
    }
}

@Observable
final class KhatmahStore {
    private(set) var plan: KhatmahPlan?
    /// Dates on which a khatmah was completed, newest last.
    private(set) var completions: [Date]
    /// Daily reminder time (minutes after midnight), nil = no reminder.
    var reminderMinutes: Int? {
        didSet { d.set(reminderMinutes ?? -1, forKey: Keys.reminder) }
    }

    @ObservationIgnored private let d: UserDefaults
    @ObservationIgnored private let calendar: Calendar

    private enum Keys {
        static let plan = "noor.khatmah.plan"
        static let completions = "noor.khatmah.completions"
        static let reminder = "noor.khatmah.reminder"
    }

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        d = defaults
        self.calendar = calendar
        plan = (d.data(forKey: Keys.plan)).flatMap { try? JSONDecoder().decode(KhatmahPlan.self, from: $0) }
        completions = (d.data(forKey: Keys.completions)).flatMap { try? JSONDecoder().decode([Date].self, from: $0) } ?? []
        let r = d.object(forKey: Keys.reminder) as? Int ?? -1
        reminderMinutes = r >= 0 ? r : nil
        rollDay()
    }

    /// The reminder time when a plan is running, read straight from storage so the
    /// notification scheduler does not need the store.
    static func activeReminderMinutes(defaults: UserDefaults = .standard) -> Int? {
        let m = defaults.object(forKey: Keys.reminder) as? Int ?? -1
        guard m >= 0, let data = defaults.data(forKey: Keys.plan),
              let plan = try? JSONDecoder().decode(KhatmahPlan.self, from: data),
              plan.pagesRead < KhatmahMath.totalPages else { return nil }
        return m
    }

    // MARK: Plan lifecycle

    /// Starts a plan running from `startDate` (default today) to `endDate`, both inclusive.
    func start(until endDate: Date, kind: String, startDate: Date? = nil, fromPage pagesRead: Int = 0, today: Date = Date()) {
        let start = calendar.startOfDay(for: max(startDate ?? today, today))
        let end = max(start, calendar.startOfDay(for: endDate))
        let p = min(max(0, pagesRead), KhatmahMath.totalPages - 1)
        plan = KhatmahPlan(startDate: start, endDate: end, pagesRead: p, kind: kind,
                           dayStartPages: p, dayStartKey: TasbihState.dayKey(for: today))
        persist()
    }

    func start(days: Int, today: Date = Date()) {
        let end = calendar.date(byAdding: .day, value: max(1, days) - 1, to: calendar.startOfDay(for: today)) ?? today
        start(until: end, kind: "days", today: today)
    }

    func cancel() {
        plan = nil
        persist()
    }

    // MARK: Progress

    /// Called by the reader with the pages fully read up to the ayah on screen.
    /// Only counts reading that continues from where the plan is, so browsing a
    /// distant surah does not jump the plan forward.
    func recordReading(completedPages: Int, today: Date = Date()) {
        rollDay(today)
        guard var p = plan, completedPages > p.pagesRead, completedPages <= p.pagesRead + 40 else { return }
        p.pagesRead = min(KhatmahMath.totalPages, completedPages)
        plan = p
        finishIfDone(today)
        persist()
    }

    /// "I read today's portion" without using the in-app reader.
    func markTodayRead(today: Date = Date()) {
        rollDay(today)
        guard var p = plan else { return }
        p.pagesRead = max(p.pagesRead, KhatmahMath.todayEndPage(p, today: today, calendar: calendar))
        plan = p
        finishIfDone(today)
        persist()
    }

    /// Manually set the position (e.g. the user reads from a paper mushaf).
    func setPagesRead(_ pages: Int, today: Date = Date()) {
        guard var p = plan else { return }
        p.pagesRead = min(KhatmahMath.totalPages, max(0, pages))
        if p.pagesRead < p.dayStartPages { p.dayStartPages = p.pagesRead }
        plan = p
        finishIfDone(today)
        persist()
    }

    var isFinished: Bool { (plan?.pagesRead ?? 0) >= KhatmahMath.totalPages }

    /// Pages of today's portion as a closed range (first…last), nil when the plan
    /// is finished or has not started yet.
    func todayRange(today: Date = Date()) -> ClosedRange<Int>? {
        guard let p = plan, p.pagesRead < KhatmahMath.totalPages,
              !KhatmahMath.hasNotStarted(p, today: today, calendar: calendar) else { return nil }
        let start = p.dayStartPages + 1
        let end = KhatmahMath.todayEndPage(p, today: today, calendar: calendar)
        return start...max(start, end)
    }

    /// Days until a plan made in advance begins (0 once it is running).
    func daysUntilStart(today: Date = Date()) -> Int {
        guard let p = plan else { return 0 }
        return max(0, KhatmahMath.days(from: today, to: p.startDate, calendar: calendar))
    }

    func isTodayDone(today: Date = Date()) -> Bool {
        guard let p = plan, !KhatmahMath.hasNotStarted(p, today: today, calendar: calendar) else { return false }
        return p.pagesRead >= KhatmahMath.todayEndPage(p, today: today, calendar: calendar)
    }

    // MARK: Private

    private func finishIfDone(_ today: Date) {
        guard let p = plan, p.pagesRead >= KhatmahMath.totalPages else { return }
        if completions.last.map({ !calendar.isDate($0, inSameDayAs: today) }) ?? true {
            completions.append(today)
        }
    }

    /// Fixes the start of today's portion the first time the plan is touched each day.
    private func rollDay(_ today: Date = Date()) {
        guard var p = plan else { return }
        let key = TasbihState.dayKey(for: today)
        guard p.dayStartKey != key else { return }
        p.dayStartKey = key
        p.dayStartPages = p.pagesRead
        plan = p
        persist()
    }

    private func persist() {
        if let plan, let data = try? JSONEncoder().encode(plan) {
            d.set(data, forKey: Keys.plan)
        } else {
            d.removeObject(forKey: Keys.plan)
        }
        if let data = try? JSONEncoder().encode(completions) { d.set(data, forKey: Keys.completions) }
    }
}
