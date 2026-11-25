import XCTest
import Adhan
@testable import Noor

/// Prayer times against each country's official method. Reference values are from
/// api.aladhan.com (methods 21 Morocco, 18 Tunisia, 23 Jordan, 4 Umm al-Qura, 12 France, 3 MWL),
/// fetched on 2026-11-22. Allowed difference: 1 minute (rounding).
final class PrayerAccuracyTests: XCTestCase {

    private let zero = [0, 0, 0, 0, 0, 0]

    private func times(_ lat: Double, _ lng: Double, _ tz: String, _ y: Int, _ m: Int, _ d: Int,
                       _ method: MethodKey, offsets: [Int]? = nil) -> [String] {
        var c = DateComponents(); c.year = y; c.month = m; c.day = d
        let p = PrayerService.parameters(method: method, madhab: .shafi, offsets: offsets ?? zero)
        let pt = PrayerTimes(coordinates: Coordinates(latitude: lat, longitude: lng), date: c, calculationParameters: p)!
        let f = DateFormatter(); f.dateFormat = "HH:mm"; f.timeZone = TimeZone(identifier: tz)
        return [pt.fajr, pt.sunrise, pt.dhuhr, pt.asr, pt.maghrib, pt.isha].map { f.string(from: $0) }
    }

    private func assertClose(_ got: [String], _ want: [String], file: StaticString = #filePath, line: UInt = #line) {
        func mins(_ s: String) -> Int { let p = s.split(separator: ":").map { Int($0)! }; return p[0] * 60 + p[1] }
        for (i, (g, w)) in zip(got, want).enumerated() {
            var d = abs(mins(g) - mins(w)); if d > 720 { d = 1440 - d }
            XCTAssertLessThanOrEqual(d, 1, "\(["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"][i]): got \(g), official \(w)", file: file, line: line)
        }
    }

    /// The app's Moroccan calculator against the ministry's own November 2026 table (habous.gov.ma),
    /// all 190 cities × 30 days: ≥ 95% to the minute per prayer, never more than 1 minute off.
    func testHabousOfficialTable() throws {
        struct Month: Decodable { let annee: Int; let mois: Int; let villes: [Ville] }
        struct Ville: Decodable { let c: Int; let n: String; let h: [[String]] }
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "habous-2026-11", withExtension: "json"))
        let month = try JSONDecoder().decode(Month.self, from: Data(contentsOf: url))
        XCTAssertEqual(HabousTimes.cities.count, 190)
        let f = DateFormatter(); f.dateFormat = "HH:mm"; f.timeZone = TimeZone(identifier: "UTC")
        var exact = [Int](repeating: 0, count: 6), n = 0, worst = 0
        for v in month.villes {
            let city = try XCTUnwrap(HabousTimes.cities.first { $0.c == v.c }, v.n)
            for (i, row) in v.h.enumerated() {
                let t = try XCTUnwrap(HabousTimes.times(city: city, year: month.annee,
                                                        month: month.mois, day: i + 1, utcOffsetMinutes: 0))
                n += 1
                for k in 0..<6 {
                    let got = f.string(from: t[k]).split(separator: ":").map { Int($0)! }
                    let want = row[k].split(separator: ":").map { Int($0)! }
                    let d = abs((got[0] * 60 + got[1]) - (want[0] * 60 + want[1]))
                    if d == 0 { exact[k] += 1 }
                    worst = max(worst, d)
                }
            }
        }
        for k in 0..<6 { XCTAssertGreaterThanOrEqual(Double(exact[k]) / Double(n), 0.95, "prayer \(k)") }
        XCTAssertLessThanOrEqual(worst, 1)
    }

    /// End to end: PrayerService with the Morocco method gives the ministry's Casablanca times
    /// for a point in central Casablanca (ministry table, 22 Nov 2026: 05:36 07:05 12:22 15:05 17:29 18:47).
    func testPrayerServiceMoroccoCasablanca() throws {
        let saved = PrayerTuning.load(); PrayerTuning.save([0, 0, 0, 0, 0, 0])
        defer { PrayerTuning.save(saved) }
        var cal = Calendar(identifier: .gregorian); cal.timeZone = .current
        let date = try XCTUnwrap(cal.date(from: DateComponents(year: 2026, month: 11, day: 22, hour: 12)))
        let t = try XCTUnwrap(PrayerService.computeTimes(lat: 33.5731, lng: -7.5898, method: .morocco, madhab: .shafi, date: date))
        let f = DateFormatter(); f.dateFormat = "HH:mm"; f.timeZone = TimeZone(secondsFromGMT: 0)
        let got = [PrayerName.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha].map { f.string(from: t[$0]!) }
        XCTAssertEqual(got, ["05:36", "07:05", "12:22", "15:05", "17:29", "18:47"])
        XCTAssertEqual(HabousTimes.nearestCity(lat: 33.5731, lng: -7.5898)?.c, 58)   // الدار البيضاء
    }

    /// The general adhan-based fallback with Morocco's angles (used only if the city table is missing).
    func testMoroccoMatchesHabous() {
        assertClose(times(33.5731, -7.5898, "Africa/Casablanca", 2026, 11, 22, .morocco),
                    ["05:37", "07:08", "12:21", "15:05", "17:29", "18:46"])
        assertClose(times(33.5731, -7.5898, "Africa/Casablanca", 2027, 6, 21, .morocco),
                    ["03:30", "05:21", "12:37", "16:16", "19:49", "21:21"])
    }

    func testTunisiaJordanSaudiFrance() {
        assertClose(times(36.8065, 10.1815, "Africa/Tunis", 2026, 11, 22, .tunisia),
                    ["05:34", "07:04", "12:05", "14:47", "17:06", "18:37"])
        assertClose(times(31.9454, 35.9284, "Asia/Amman", 2026, 11, 22, .jordan),
                    ["05:46", "07:11", "12:22", "15:15", "17:39", "18:59"])
        assertClose(times(24.7136, 46.6753, "Asia/Riyadh", 2026, 11, 22, .ummAlQura),
                    ["04:52", "06:14", "11:39", "14:44", "17:04", "18:34"])
        assertClose(times(48.8566, 2.3522, "Europe/Paris", 2026, 11, 22, .franceUOIF),
                    ["06:56", "08:10", "12:37", "14:43", "17:03", "18:17"])
    }

    /// Paris in June: twilight never reaches 18°. Before the fix Isha came out at 01:07 and Fajr at 01:52.
    func testHighLatitudeSummer() {
        let paris = times(48.8566, 2.3522, "Europe/Paris", 2027, 6, 21, .muslimWorldLeague)
        assertClose([paris[0], paris[5]], ["03:26", "00:11"])
        let brussels = times(50.8503, 4.3517, "Europe/Brussels", 2027, 6, 21, .muslimWorldLeague)
        assertClose([brussels[0], brussels[5]], ["03:14", "00:07"])
    }

    func testUserOffsetsShiftOnlyTheirPrayer() {
        let base = times(33.5731, -7.5898, "Africa/Casablanca", 2026, 11, 22, .morocco)
        let tuned = times(33.5731, -7.5898, "Africa/Casablanca", 2026, 11, 22, .morocco, offsets: [2, 0, 0, 0, -3, 0])
        XCTAssertEqual(tuned[0], "05:39"); XCTAssertEqual(tuned[4], "17:26")
        XCTAssertEqual(Array(tuned[1...3]), Array(base[1...3])); XCTAssertEqual(tuned[5], base[5])
    }

    /// "Official method for my country": arriving in Morocco switches to the ministry's method;
    /// once the user picks a method by hand, a country change no longer overrides it.
    func testAutomaticMethodFollowsCountry() {
        let s = SettingsStore()
        let saved = (s.method, s.madhab, s.methodAuto)
        defer { s.method = saved.0; s.madhab = saved.1; s.methodAuto = saved.2 }
        s.methodAuto = true; s.method = .muslimWorldLeague
        XCTAssertTrue(s.applyCountry("MA"))
        XCTAssertEqual(s.method, .morocco)
        XCTAssertFalse(s.applyCountry("MA"))            // nothing to change
        s.methodAuto = false
        XCTAssertFalse(s.applyCountry("FR"))
        XCTAssertEqual(s.method, .morocco)
    }

    func testCountryPicksOfficialMethod() {
        XCTAssertEqual(MethodKey.forCountry("MA").method, .morocco)
        XCTAssertEqual(MethodKey.forCountry("sa").method, .ummAlQura)
        XCTAssertEqual(MethodKey.forCountry("FR").method, .franceUOIF)
        XCTAssertEqual(MethodKey.forCountry("PK").madhab, .hanafi)
        XCTAssertEqual(MethodKey.forCountry("ZZ").method, .muslimWorldLeague)
    }
}
