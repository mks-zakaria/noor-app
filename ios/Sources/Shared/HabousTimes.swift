import Foundation

/// Prayer times for Morocco computed the way the Ministry of Habous and Islamic Affairs computes its
/// official timetable (habous.gov.ma), so Noor shows the same minute as the ministry and the mosques.
///
/// What the ministry does, recovered from its published tables (190 cities, Oct–Nov 2026):
/// - Fajr at 19° and Isha at 17° below the horizon, Asr when the shadow equals the object + its noon shadow.
/// - Dhuhr 5 minutes after the sun's transit.
/// - Sunrise and Maghrib corrected for each city's horizon, east and west separately: mountain cities
///   see the sun longer, so their sunrise is earlier and Maghrib later (Midelt about 4 minutes more than
///   the coast). The coordinates and horizons of the ministry's 190 cities are in
///   `Resources/Morocco/habous-cities.json`, fitted on its own tables.
/// - Times are whole minutes in Moroccan legal time (GMT since 20 Sep 2026); here they are returned as
///   absolute dates, so they display correctly in whatever time zone the phone is set to.
///
/// Compiled into the app AND the widget extension.
enum HabousTimes {

    struct City: Codable {
        let c: Int          // ministry city code
        let n: String       // Arabic name, as the ministry writes it
        let lat: Double
        let lng: Double
        let hr: Double      // horizon depression at sunrise (east), degrees; 0.833 = flat sea horizon
        let hs: Double      // horizon depression at Maghrib (west), degrees
        let plat: Double    // where the town is (geocoded; = lat/lng when the geocoder was wrong),
        let plng: Double    // used only to pick the user's city. lat/lng are the ministry's own point.
    }

    /// Fitted on the ministry's tables (see `tools/habous/README.md`). With these, 11,590 city-days
    /// (190 cities, Oct–Nov 2026) match the ministry exactly 96–98% of the time per prayer, and
    /// always within 1 minute.
    static let rules = Rules.fitted
    struct Rules {
        let fajrAngle, ishaAngle: Double
        /// Minutes added before rounding to the nearest minute (fajr, sunrise, dhuhr, asr, maghrib, isha).
        /// Fajr −0.5 = the ministry truncates; Dhuhr +5 and Maghrib +1 are its precaution margins.
        let offsets: [Double]
        static let fitted = Rules(fajrAngle: 19, ishaAngle: 17, offsets: [-0.5, -0.24, 5.0, 0.2, 1.02, 0.0])
    }

    static let cities: [City] = {
        guard let url = Bundle.main.url(forResource: "habous-cities", withExtension: "json")
                ?? Bundle(for: BundleToken.self).url(forResource: "habous-cities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([City].self, from: data) else { return [] }
        return list
    }()
    private final class BundleToken {}

    /// The ministry city whose timetable applies at this point (the nearest one), within `maxKm`.
    static func nearestCity(lat: Double, lng: Double, maxKm: Double = 120) -> City? {
        var best: (City, Double)?
        for c in cities {
            let d = distanceKm(lat, lng, c.plat, c.plng)
            if d <= maxKm, d < (best?.1 ?? .infinity) { best = (c, d) }
        }
        return best?.0
    }

    /// Official-method times for the calendar day `y-m-d` (Moroccan date) at the nearest ministry
    /// city, as absolute dates. Order: fajr, sunrise, dhuhr, asr, maghrib, isha.
    static func times(lat: Double, lng: Double, year y: Int, month m: Int, day d: Int,
                      utcOffsetMinutes: Int) -> [Date]? {
        times(city: nearestCity(lat: lat, lng: lng), lat: lat, lng: lng, year: y, month: m, day: d,
              utcOffsetMinutes: utcOffsetMinutes)
    }

    /// Times for a given ministry city (or, when `city` is nil, for the point itself).
    static func times(city: City?, lat: Double = 0, lng: Double = 0, year y: Int, month m: Int, day d: Int,
                      utcOffsetMinutes: Int) -> [Date]? {
        // More than 120 km from every ministry city: own position, median horizon of the 190 cities.
        let la = city?.lat ?? lat, lo = city?.lng ?? lng, hr = city?.hr ?? 1.8, hs = city?.hs ?? 1.8
        let r = rules
        guard let fajr = Solar.atAltitude(y, m, d, la, lo, -r.fajrAngle, afterTransit: false),
              let rise = Solar.atAltitude(y, m, d, la, lo, -hr, afterTransit: false),
              let asr = Solar.atAltitude(y, m, d, la, lo, Solar.asrAltitude(y, m, d, la, lo), afterTransit: true),
              let set = Solar.atAltitude(y, m, d, la, lo, -hs, afterTransit: true),
              let isha = Solar.atAltitude(y, m, d, la, lo, -r.ishaAngle, afterTransit: true)
        else { return nil }
        let raw = [fajr, rise, Solar.transit(y, m, d, lo), asr, set, isha]   // minutes after 00:00 UTC
        var comps = DateComponents(); comps.year = y; comps.month = m; comps.day = d
        var utc = Calendar(identifier: .gregorian); utc.timeZone = TimeZone(identifier: "UTC")!
        guard let midnightUTC = utc.date(from: comps) else { return nil }
        // Round in Moroccan legal time (whole local minutes), then express as an absolute date.
        return zip(raw, r.offsets).map { t, o in
            let local = (t + o + Double(utcOffsetMinutes)).rounded(.toNearestOrAwayFromZero)
            return midnightUTC.addingTimeInterval((local - Double(utcOffsetMinutes)) * 60)
        }
    }

    static func distanceKm(_ la1: Double, _ lo1: Double, _ la2: Double, _ lo2: Double) -> Double {
        let r = Double.pi / 180
        let a = sin((la2 - la1) * r / 2) * sin((la2 - la1) * r / 2)
              + cos(la1 * r) * cos(la2 * r) * sin((lo2 - lo1) * r / 2) * sin((lo2 - lo1) * r / 2)
        return 6371 * 2 * atan2(sqrt(a), sqrt(1 - a))
    }
}

/// NOAA / Meeus low-precision solar position (accurate to a few seconds of time), enough for minute
/// rounding. Times are minutes after 00:00 UTC of the given Gregorian date.
enum Solar {
    private static let r = Double.pi / 180

    static func julianDay(_ y0: Int, _ m0: Int, _ d: Int) -> Double {
        var y = y0, m = m0
        if m <= 2 { y -= 1; m += 12 }
        let a = y / 100, b = 2 - a + a / 4
        return Double(Int(365.25 * Double(y + 4716))) + Double(Int(30.6001 * Double(m + 1))) + Double(d + b) - 1524.5
    }

    /// Declination (degrees) and equation of time (minutes).
    static func sun(_ jd: Double) -> (dec: Double, eot: Double) {
        let t = (jd - 2451545.0) / 36525
        let l0 = (280.46646 + t * (36000.76983 + 0.0003032 * t)).truncatingRemainder(dividingBy: 360)
        let mA = 357.52911 + t * (35999.05029 - 0.0001537 * t)
        let e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t)
        let c = sin(mA * r) * (1.914602 - t * (0.004817 + 0.000014 * t)) + sin(2 * mA * r) * (0.019993 - 0.000101 * t)
              + sin(3 * mA * r) * 0.000289
        let om = 125.04 - 1934.136 * t
        let lam = l0 + c - 0.00569 - 0.00478 * sin(om * r)
        let eps = 23 + (26 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60) / 60 + 0.00256 * cos(om * r)
        let dec = asin(sin(eps * r) * sin(lam * r)) / r
        let yv = pow(tan(eps * r / 2), 2)
        let eot = 4 / r * (yv * sin(2 * l0 * r) - 2 * e * sin(mA * r) + 4 * e * yv * sin(mA * r) * cos(2 * l0 * r)
                           - 0.5 * yv * yv * sin(4 * l0 * r) - 1.25 * e * e * sin(2 * mA * r))
        return (dec, eot)
    }

    static func transit(_ y: Int, _ m: Int, _ d: Int, _ lng: Double) -> Double {
        let j0 = julianDay(y, m, d)
        var tt = 720 - 4 * lng
        for _ in 0..<3 { tt = 720 - 4 * lng - sun(j0 + tt / 1440).eot }
        return tt
    }

    /// When the sun's centre is at `alt` degrees; nil if it never gets there that day.
    static func atAltitude(_ y: Int, _ m: Int, _ d: Int, _ lat: Double, _ lng: Double, _ alt: Double,
                           afterTransit: Bool) -> Double? {
        let j0 = julianDay(y, m, d)
        var ev = transit(y, m, d, lng) + (afterTransit ? 360 : -360)
        for _ in 0..<4 {
            let s = sun(j0 + ev / 1440)
            let cosH = (sin(alt * r) - sin(lat * r) * sin(s.dec * r)) / (cos(lat * r) * cos(s.dec * r))
            guard cosH >= -1, cosH <= 1 else { return nil }
            let h = acos(cosH) / r
            ev = 720 - 4 * lng - s.eot + (afterTransit ? 4 * h : -4 * h)
        }
        return ev
    }

    /// Sun altitude at Asr (shadow = object length + noon shadow; Maliki / Shafi).
    static func asrAltitude(_ y: Int, _ m: Int, _ d: Int, _ lat: Double, _ lng: Double) -> Double {
        let dec = sun(julianDay(y, m, d) + transit(y, m, d, lng) / 1440).dec
        return atan(1 / (1 + tan(abs(lat - dec) * r))) / r
    }
}
