import Foundation
import Adhan

/// Computed prayer times for a single day at a location.
struct DayTimes {
    let times: [PrayerName: Date]
    let lastThird: Date?
    subscript(_ p: PrayerName) -> Date? { times[p] }
}

enum PrayerService {
    static func parameters(method: MethodKey, madhab: MadhabKey) -> CalculationParameters {
        var p = method.adhan.params
        p.madhab = madhab.adhan
        return p
    }

    static func computeTimes(
        lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey,
        date: Date = Date()
    ) -> DayTimes? {
        let coords = Coordinates(latitude: lat, longitude: lng)
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month, .day], from: date)
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
