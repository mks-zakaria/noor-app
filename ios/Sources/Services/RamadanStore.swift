import Foundation
import Observation

enum FastStatus: String, Codable, CaseIterable {
    case fasted, missed, excused

    var systemImage: String {
        switch self {
        case .fasted: return "checkmark.circle.fill"
        case .missed: return "xmark.circle.fill"
        case .excused: return "minus.circle.fill"
        }
    }
}

/// Per-Ramadan fasting and Taraweeh log, plus the six fasts of Shawwal.
@Observable
final class RamadanStore {
    /// "1448" → day → status.
    private(set) var fasts: [String: [Int: FastStatus]]
    /// "1448" → nights on which Taraweeh was prayed.
    private(set) var taraweeh: [String: Set<Int>]
    /// "1448" → number of Shawwal fasts done (0…6).
    private(set) var shawwal: [String: Int]

    @ObservationIgnored private let d: UserDefaults
    @ObservationIgnored private let prayerLog: PrayerLogStore

    private enum Keys {
        static let fasts = "noor.ramadan.fasts"
        static let taraweeh = "noor.ramadan.taraweeh"
        static let shawwal = "noor.ramadan.shawwal"
    }

    init(defaults: UserDefaults = .standard, prayerLog: PrayerLogStore = .shared) {
        d = defaults
        self.prayerLog = prayerLog
        fasts = d.data(forKey: Keys.fasts).flatMap { try? JSONDecoder().decode([String: [Int: FastStatus]].self, from: $0) } ?? [:]
        taraweeh = d.data(forKey: Keys.taraweeh).flatMap { try? JSONDecoder().decode([String: Set<Int>].self, from: $0) } ?? [:]
        shawwal = d.dictionary(forKey: Keys.shawwal) as? [String: Int] ?? [:]
    }

    func fast(year: Int, day: Int) -> FastStatus? { fasts[String(year)]?[day] }

    /// Sets a day's fast. A missed fast is owed later, so it adds to the Qada balance.
    func setFast(_ status: FastStatus?, year: Int, day: Int) {
        let y = String(year)
        let old = fasts[y]?[day]
        guard old != status else { return }
        var days = fasts[y] ?? [:]
        days[day] = status
        fasts[y] = days
        if old == .missed { prayerLog.adjustQadaFasts(by: -1) }
        if status == .missed { prayerLog.adjustQadaFasts(by: 1) }
        persist()
    }

    /// Cycles a day: unset → fasted → missed → excused → unset.
    func cycleFast(year: Int, day: Int) {
        let next: FastStatus?
        switch fast(year: year, day: day) {
        case nil: next = .fasted
        case .fasted: next = .missed
        case .missed: next = .excused
        case .excused: next = nil
        }
        setFast(next, year: year, day: day)
    }

    func fastedCount(year: Int) -> Int { fasts[String(year)]?.values.filter { $0 == .fasted }.count ?? 0 }

    func prayedTaraweeh(year: Int, night: Int) -> Bool { taraweeh[String(year)]?.contains(night) ?? false }

    func toggleTaraweeh(year: Int, night: Int) {
        var set = taraweeh[String(year)] ?? []
        if set.contains(night) { set.remove(night) } else { set.insert(night) }
        taraweeh[String(year)] = set
        persist()
    }

    func taraweehCount(year: Int) -> Int { taraweeh[String(year)]?.count ?? 0 }

    func shawwalFasts(year: Int) -> Int { shawwal[String(year)] ?? 0 }

    func setShawwalFasts(_ n: Int, year: Int) {
        shawwal[String(year)] = min(6, max(0, n))
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(fasts) { d.set(data, forKey: Keys.fasts) }
        if let data = try? JSONEncoder().encode(taraweeh) { d.set(data, forKey: Keys.taraweeh) }
        d.set(shawwal, forKey: Keys.shawwal)
    }
}
