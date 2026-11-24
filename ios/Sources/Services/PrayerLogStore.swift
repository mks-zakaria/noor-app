import Foundation
import Observation

enum PrayerStatus: String, Codable, CaseIterable {
    case onTime, late, missed

    var counts: Bool { self != .missed }

    var systemImage: String {
        switch self {
        case .onTime: return "checkmark.circle.fill"
        case .late: return "clock.badge.checkmark.fill"
        case .missed: return "xmark.circle.fill"
        }
    }
}

/// Which of the five prayers were prayed each day, plus the Qada (make-up) balance.
/// A shared instance, because a "Prayed ✓" notification action can log a prayer
/// while no view is on screen.
@Observable
final class PrayerLogStore {
    static let shared = PrayerLogStore()

    static let fivePrayers: [PrayerName] = [.fajr, .dhuhr, .asr, .maghrib, .isha]

    /// "yyyy-MM-dd" → prayer raw value → status.
    private(set) var log: [String: [String: PrayerStatus]]
    /// Prayers owed, by prayer raw value.
    private(set) var qadaPrayers: [String: Int]
    /// Fasts owed.
    private(set) var qadaFasts: Int

    @ObservationIgnored private let d: UserDefaults

    private enum Keys {
        static let log = "noor.prayerLog"
        static let qada = "noor.qada.prayers"
        static let qadaFasts = "noor.qada.fasts"
    }

    init(defaults: UserDefaults = .standard) {
        d = defaults
        log = d.data(forKey: Keys.log).flatMap { try? JSONDecoder().decode([String: [String: PrayerStatus]].self, from: $0) } ?? [:]
        qadaPrayers = d.dictionary(forKey: Keys.qada) as? [String: Int] ?? [:]
        qadaFasts = d.integer(forKey: Keys.qadaFasts)
    }

    static func key(_ date: Date) -> String { TasbihState.dayKey(for: date) }

    func status(_ prayer: PrayerName, on date: Date = Date()) -> PrayerStatus? {
        log[Self.key(date)]?[prayer.rawValue]
    }

    /// Sets (or clears, with nil) a prayer's status. Marking "missed" adds one to
    /// the Qada balance; changing it away from "missed" takes that one back.
    func set(_ status: PrayerStatus?, _ prayer: PrayerName, on date: Date = Date()) {
        let k = Self.key(date)
        let old = log[k]?[prayer.rawValue]
        guard old != status else { return }
        var day = log[k] ?? [:]
        day[prayer.rawValue] = status
        log[k] = day.isEmpty ? nil : day
        if old == .missed { adjustQada(prayer, by: -1) }
        if status == .missed { adjustQada(prayer, by: 1) }
        persist()
    }

    /// One tap: unlogged → prayed on time → unlogged.
    func toggle(_ prayer: PrayerName, on date: Date = Date()) {
        set(status(prayer, on: date) == nil ? .onTime : nil, prayer, on: date)
    }

    func prayedCount(on date: Date) -> Int {
        Self.fivePrayers.filter { status($0, on: date)?.counts == true }.count
    }

    /// Consecutive days with all five prayers logged as prayed, ending today
    /// (or yesterday, while today is still in progress).
    func streak(today: Date = Date(), calendar: Calendar = .current) -> Int {
        var day = calendar.startOfDay(for: today)
        if prayedCount(on: day) < 5 {
            day = calendar.date(byAdding: .day, value: -1, to: day) ?? day
        }
        var n = 0
        while prayedCount(on: day) == 5 {
            n += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return n
    }

    // MARK: Qada

    var qadaTotal: Int { qadaPrayers.values.reduce(0, +) }

    func qada(_ prayer: PrayerName) -> Int { qadaPrayers[prayer.rawValue] ?? 0 }

    func adjustQada(_ prayer: PrayerName, by delta: Int) {
        qadaPrayers[prayer.rawValue] = max(0, qada(prayer) + delta)
        persist()
    }

    func adjustQadaFasts(by delta: Int) {
        qadaFasts = max(0, qadaFasts + delta)
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(log) { d.set(data, forKey: Keys.log) }
        d.set(qadaPrayers, forKey: Keys.qada)
        d.set(qadaFasts, forKey: Keys.qadaFasts)
    }
}
