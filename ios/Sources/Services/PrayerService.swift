import Foundation
import Adhan

/// Computed prayer times for a single day at a location.
struct DayTimes {
    let times: [PrayerName: Date]
    let lastThird: Date?
    subscript(_ p: PrayerName) -> Date? { times[p] }
}

enum PrayerService {
    static func parameters(method: MethodKey, madhab: MadhabKey,
                           offsets: [Int] = PrayerTuning.load()) -> CalculationParameters {
        var p = method.params
        p.madhab = madhab.adhan
        // Where twilight never reaches the Fajr/Isha angle (Europe in summer), adhan's default
        // "middle of the night" put Isha after Fajr in Paris (Isha 01:07, Fajr 01:52 on 21 June).
        // The twilight-angle rule is what api.aladhan.com and most apps use; it only changes
        // the times when the angle is not reached, so lower latitudes are unaffected.
        p.highLatitudeRule = .twilightAngle
        let user = offsets.count == 6 ? offsets : Array(repeating: 0, count: 6)
        let o = zip(user, method.officialMinutes).map { $0 + $1 }
        p.adjustments = PrayerAdjustments(fajr: o[0], sunrise: o[1], dhuhr: o[2], asr: o[3], maghrib: o[4], isha: o[5])
        return p
    }

    static func computeTimes(
        lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey,
        date: Date = Date()
    ) -> DayTimes? {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month, .day], from: date)
        if method == .morocco, let official = moroccoTimes(lat: lat, lng: lng, comps: comps, date: date) {
            return official
        }
        let coords = Coordinates(latitude: lat, longitude: lng)
        guard let pt = PrayerTimes(
            coordinates: coords, date: comps,
            calculationParameters: parameters(method: method, madhab: madhab)
        ) else { return nil }

        let sunnah = SunnahTimes(from: pt)
        return DayTimes(
            times: [
                .fajr: pt.fajr, .sunrise: pt.sunrise, .dhuhr: pt.dhuhr,
                .asr: pt.asr, .maghrib: pt.maghrib, .isha: pt.isha,
            ],
            lastThird: sunnah?.lastThirdOfTheNight
        )
    }

    /// Morocco: the ministry's own calculation at the nearest ministry city (see HabousTimes),
    /// plus the user's minute offsets. Asr is Maliki (the ministry's), whatever the madhab setting.
    private static func moroccoTimes(lat: Double, lng: Double, comps: DateComponents, date: Date) -> DayTimes? {
        guard let y = comps.year, let m = comps.month, let d = comps.day,
              let t = HabousTimes.times(lat: lat, lng: lng, year: y, month: m, day: d,
                                        utcOffsetMinutes: TimeZone.current.secondsFromGMT(for: date) / 60)
        else { return nil }
        let o = PrayerTuning.load()
        let order: [PrayerName] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
        var times: [PrayerName: Date] = [:]
        for (i, p) in order.enumerated() { times[p] = t[i].addingTimeInterval(Double(o[i]) * 60) }
        // Last third of the night: from Maghrib to the next day's Fajr.
        var lastThird: Date?
        if let next = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: date) {
            let nc = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: next)
            if let ny = nc.year, let nm = nc.month, let nd = nc.day,
               let nt = HabousTimes.times(lat: lat, lng: lng, year: ny, month: nm, day: nd,
                                          utcOffsetMinutes: TimeZone.current.secondsFromGMT(for: next) / 60),
               let maghrib = times[.maghrib] {
                let night = nt[0].timeIntervalSince(maghrib)
                lastThird = maghrib.addingTimeInterval(night * 2 / 3)
            }
        }
        return DayTimes(times: times, lastThird: lastThird)
    }

    /// Compass bearing (degrees, clockwise from true north) toward the Kaaba.
    static func qiblaBearing(lat: Double, lng: Double) -> Double {
        Qibla(coordinates: Coordinates(latitude: lat, longitude: lng)).direction
    }

    /// The next upcoming prayer (today, or Fajr tomorrow).
    static func nextPrayer(
        from times: DayTimes,
        lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey,
        now: Date = Date()
    ) -> (name: PrayerName, at: Date)? {
        for name in prayerOrder where name.isPrayer {
            if let at = times[name], at > now { return (name, at) }
        }
        // All of today's prayers have passed → Fajr tomorrow.
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now),
              let t = computeTimes(lat: lat, lng: lng, method: method, madhab: madhab, date: tomorrow),
              let fajr = t[.fajr]
        else { return nil }
        return (.fajr, fajr)
    }
}

extension Date {
    func timeString(hour12: Bool) -> String {
        let f = DateFormatter()
        f.dateFormat = hour12 ? "h:mm a" : "HH:mm"
        return f.string(from: self)
    }
}

/// Formats a countdown interval like "2h 05m" or "7m 12s".
///
/// The unit letters are localized: left in English they render as Latin "h"/"m"
/// inside an otherwise Arabic sentence ("بعد 2h 07m"), which is the one piece of
/// the home screen that stayed untranslated.
func formatCountdown(_ interval: TimeInterval, langCode: String = "en") -> String {
    let clamped = max(0, interval)
    let totalMin = Int(clamped) / 60
    let h = totalMin / 60
    let m = totalMin % 60
    let s = Int(clamped) % 60

    let (hU, mU, sU): (String, String, String)
    switch langCode {
    case "ar": (hU, mU, sU) = ("س", "د", "ث")     // ساعة / دقيقة / ثانية
    case "fr": (hU, mU, sU) = ("h", "min", "s")
    default:   (hU, mU, sU) = ("h", "m", "s")
    }

    if h > 0 { return "\(h)\(hU) \(String(format: "%02d", m))\(mU)" }
    return "\(m)\(mU) \(String(format: "%02d", s))\(sU)"
}
