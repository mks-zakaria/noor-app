import Foundation

// Compiled into the app and the NoorWidget extension: the Lock Screen widgets
// show suhoor / iftar during Ramadan from the same calendar as the app.

/// The dates of one Ramadan, in the user's (Hijri-corrected) calendar.
struct RamadanInfo: Equatable {
    /// Hijri year, e.g. 1448.
    let year: Int
    /// Gregorian start of day of 1 Ramadan.
    let start: Date
    /// 29 or 30.
    let days: Int

    func date(ofDay day: Int, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .day, value: day - 1, to: start) ?? start
    }

    /// The day after the last day of Ramadan (1 Shawwal, Eid al-Fitr).
    func eid(calendar: Calendar = .current) -> Date { date(ofDay: days + 1, calendar: calendar) }

    /// Ramadan day number (1…days) for a date, or nil outside Ramadan.
    func day(of date: Date, calendar: Calendar = .current) -> Int? {
        let n = (calendar.dateComponents([.day], from: start, to: calendar.startOfDay(for: date)).day ?? -1) + 1
        return (1...days).contains(n) ? n : nil
    }
}

enum RamadanPhase: Equatable {
    /// Before Ramadan: days until 1 Ramadan.
    case before(days: Int)
    /// During Ramadan: today's day number.
    case during(day: Int)
    /// In Shawwal, after Eid: the six-fasts season.
    case shawwal
}

/// One row of the Ramadan timetable.
struct RamadanDay: Identifiable {
    let day: Int
    let date: Date
    let imsak: Date
    let fajr: Date
    let maghrib: Date
    let isha: Date
    var id: Int { day }
}

enum RamadanService {
    /// Umm al-Qura is the computed calendar the app already shows; users whose
    /// country sights the moon differently correct it with `hijriOffset`.
    static var hijri: Calendar {
        var c = Calendar(identifier: .islamicUmmAlQura)
        c.timeZone = Calendar.current.timeZone
        return c
    }

    /// Hijri (year, month, day) shown for `date` after the user's correction.
    static func hijriComponents(_ date: Date, offset: Int) -> (year: Int, month: Int, day: Int) {
        let shifted = Calendar.current.date(byAdding: .day, value: offset, to: date) ?? date
        let c = hijri.dateComponents([.year, .month, .day], from: shifted)
        return (c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }

    /// Ramadan of a given Hijri year.
    static func info(year: Int, offset: Int) -> RamadanInfo? {
        let h = hijri
        guard let uq = h.date(from: DateComponents(year: year, month: 9, day: 1)) else { return nil }
        let days = h.range(of: .day, in: .month, for: uq)?.count ?? 30
        // Displayed Hijri = Gregorian + offset, so the day shown as 1 Ramadan is uq − offset.
        let start = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -offset, to: uq) ?? uq)
        return RamadanInfo(year: year, start: start, days: days)
    }

    /// The Ramadan in progress, or the next one.
    static func currentOrNext(now: Date = Date(), offset: Int) -> RamadanInfo? {
        let today = hijriComponents(now, offset: offset)
        return info(year: today.month > 9 ? today.year + 1 : today.year, offset: offset)
    }

    /// The Ramadan that ended most recently (for the Shawwal screen).
    static func previous(now: Date = Date(), offset: Int) -> RamadanInfo? {
        let today = hijriComponents(now, offset: offset)
        return info(year: today.month >= 10 ? today.year : today.year - 1, offset: offset)
    }

    static func phase(now: Date = Date(), offset: Int) -> RamadanPhase {
        let today = hijriComponents(now, offset: offset)
        if today.month == 10 { return .shawwal }
        guard let info = currentOrNext(now: now, offset: offset) else { return .before(days: 0) }
        if let day = info.day(of: now) { return .during(day: day) }
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: now), to: info.start).day ?? 0
        return .before(days: max(0, days))
    }

    /// Fasting timetable for every day of a Ramadan at a location.
    static func timetable(
        _ info: RamadanInfo, lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey, imsakMinutes: Int
    ) -> [RamadanDay] {
        (1...info.days).compactMap { day in
            let date = info.date(ofDay: day)
            guard let t = PrayerService.computeTimes(lat: lat, lng: lng, method: method, madhab: madhab, date: date),
                  let fajr = t[.fajr], let maghrib = t[.maghrib], let isha = t[.isha]
            else { return nil }
            return RamadanDay(day: day, date: date,
                              imsak: fajr.addingTimeInterval(TimeInterval(-imsakMinutes * 60)),
                              fajr: fajr, maghrib: maghrib, isha: isha)
        }
    }

    /// The next fasting event to count down to: end of suhoor (Fajr) or iftar (Maghrib).
    /// Nil outside Ramadan or after the last iftar.
    static func nextFastingEvent(
        now: Date, info: RamadanInfo, lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey
    ) -> (isIftar: Bool, at: Date, since: Date)? {
        let cal = Calendar.current
        for offset in 0...1 {
            guard let date = cal.date(byAdding: .day, value: offset, to: now),
                  info.day(of: date) != nil,
                  let t = PrayerService.computeTimes(lat: lat, lng: lng, method: method, madhab: madhab, date: date),
                  let fajr = t[.fajr], let maghrib = t[.maghrib]
            else { continue }
            if now < fajr {
                // Counting the night: from yesterday's maghrib (or the start of day) to fajr.
                let prevMaghrib = cal.date(byAdding: .day, value: -1, to: date)
                    .flatMap { PrayerService.computeTimes(lat: lat, lng: lng, method: method, madhab: madhab, date: $0)?[.maghrib] }
                return (false, fajr, prevMaghrib ?? cal.startOfDay(for: date))
            }
            if now < maghrib { return (true, maghrib, fajr) }
        }
        return nil
    }
}
