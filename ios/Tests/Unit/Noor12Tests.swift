import XCTest
import UserNotifications
@testable import Noor

/// Logic behind the 1.2 features: Quran index, Khatmah schedule, Ramadan dates,
/// notification budget, prayer log / Qada, tasbih. Every store gets its own
/// throwaway UserDefaults suite so nothing leaks into the app's real data.
final class Noor12Tests: XCTestCase {

    private func freshDefaults(_ name: String = #function) -> UserDefaults {
        let suite = "noor.tests.\(name)"
        UserDefaults().removePersistentDomain(forName: suite)
        return UserDefaults(suiteName: suite)!
    }

    private func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
        Calendar.current.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
    }

    // MARK: Quran index

    func testQuranIndexIsComplete() {
        let q = QuranIndex.shared
        XCTAssertTrue(q.isAvailable)
        XCTAssertEqual(q.meta.count, 6236)
        XCTAssertEqual(q.meta.map(\.page).max(), 604)
        XCTAssertEqual(q.meta.map(\.juz).max(), 30)
        XCTAssertEqual(q.firstAyah(ofJuz: 2).map { "\($0.surah):\($0.ayah)" }, "2:142")
        XCTAssertEqual(q.firstAyah(ofJuz: 30).map { "\($0.surah):\($0.ayah)" }, "78:1")
        XCTAssertEqual(q.page(surah: 1, ayah: 1), 1)
        XCTAssertEqual(q.page(surah: 114, ayah: 6), 604)
        XCTAssertEqual(q.completedPages(throughSurah: 114, ayah: 6), 604)
        XCTAssertEqual(q.completedPages(throughSurah: 1, ayah: 7), 1)
        XCTAssertEqual(q.completedPages(throughSurah: 1, ayah: 3), 0)
    }

    func testBundledSurahHasNoDuplicatedBasmala() throws {
        let baqarah = try XCTUnwrap(QuranService.bundledSurah(2, translation: "en.sahih"))
        XCTAssertEqual(baqarah.ayahs.count, 286)
        XCTAssertFalse(QuranIndex.normalizeArabic(baqarah.ayahs[0].arabic).contains("بسم"))
        XCTAssertFalse(baqarah.ayahs[0].english.isEmpty)
        let fatiha = try XCTUnwrap(QuranService.bundledSurah(1, translation: nil))
        XCTAssertTrue(QuranIndex.normalizeArabic(fatiha.ayahs[0].arabic).hasPrefix("بسم"))
        XCTAssertEqual(fatiha.ayahs[0].english, "")
    }

    func testArabicSearchIgnoresDiacritics() {
        let hits = QuranIndex.shared.search("الله لا اله الا هو الحي القيوم", language: "ar")
        XCTAssertTrue(hits.contains { $0.surah == 2 && $0.ayah == 255 }, "Ayat al-Kursi should match a plain-typed query")
        let fr = QuranIndex.shared.search("Trône", language: "fr")
        XCTAssertFalse(fr.isEmpty)
        XCTAssertTrue(QuranIndex.shared.search("x", language: "en").isEmpty)
    }

    // MARK: Khatmah

    func testKhatmahThirtyDayPlanSplitsEvenly() {
        let store = KhatmahStore(defaults: freshDefaults())
        let day1 = date(2027, 2, 8)
        store.start(days: 30, today: day1)
        XCTAssertEqual(store.todayRange(today: day1), 1...21)   // ceil(604 / 30)
        store.markTodayRead(today: day1)
        XCTAssertTrue(store.isTodayDone(today: day1))

        // Next day the portion is recomputed from where today began.
        let day2 = date(2027, 2, 9)
        store.recordReading(completedPages: 21, today: day2)   // no-op, already there
        XCTAssertEqual(store.todayRange(today: day2), 22...42)
    }

    func testKhatmahIgnoresJumpsWhileBrowsing() {
        let store = KhatmahStore(defaults: freshDefaults())
        let today = date(2027, 2, 8)
        store.start(days: 30, today: today)
        store.recordReading(completedPages: 300, today: today)
        XCTAssertEqual(store.plan?.pagesRead, 0, "Opening a far-away surah must not advance the plan")
        store.recordReading(completedPages: 5, today: today)
        XCTAssertEqual(store.plan?.pagesRead, 5)
    }

    func testKhatmahBehindScheduleAndCatchUp() {
        let store = KhatmahStore(defaults: freshDefaults())
        store.start(days: 30, today: date(2027, 2, 8))
        let day11 = date(2027, 2, 18)
        let plan = try! XCTUnwrap(store.plan)
        XCTAssertLessThan(KhatmahMath.scheduleDelta(plan, today: day11), 0)
        // 604 pages over the 20 remaining days → 31 a day.
        XCTAssertEqual(store.todayRange(today: day11), 1...31)
    }

    func testKhatmahPlannedAheadWaitsForStart() {
        let store = KhatmahStore(defaults: freshDefaults())
        let today = date(2027, 1, 20)
        store.start(until: date(2027, 3, 8), kind: "ramadan", startDate: date(2027, 2, 8), today: today)
        XCTAssertNil(store.todayRange(today: today))
        XCTAssertEqual(store.daysUntilStart(today: today), 19)
        XCTAssertNotNil(store.todayRange(today: date(2027, 2, 8)))
    }

    func testKhatmahCompletionIsRecorded() {
        let store = KhatmahStore(defaults: freshDefaults())
        let today = date(2027, 2, 8)
        store.start(days: 1, today: today)
        store.markTodayRead(today: today)
        XCTAssertTrue(store.isFinished)
        XCTAssertEqual(store.completions.count, 1)
    }

    // MARK: Ramadan

    func testRamadan1448Dates() throws {
        let info = try XCTUnwrap(RamadanService.info(year: 1448, offset: 0))
        let c = Calendar.current.dateComponents([.year, .month], from: info.start)
        XCTAssertEqual(c.year, 2027)
        XCTAssertEqual(c.month, 2)
        XCTAssertTrue((29...30).contains(info.days))
        // A +1 correction makes the displayed date one day ahead, so 1 Ramadan comes a day earlier.
        let shifted = try XCTUnwrap(RamadanService.info(year: 1448, offset: 1))
        XCTAssertEqual(Calendar.current.dateComponents([.day], from: shifted.start, to: info.start).day, 1)
    }

    func testRamadanPhases() throws {
        let info = try XCTUnwrap(RamadanService.info(year: 1448, offset: 0))
        if case .before(let days) = RamadanService.phase(now: date(2027, 1, 10), offset: 0) {
            XCTAssertGreaterThan(days, 20)
        } else { XCTFail("January 2027 is before Ramadan 1448") }
        XCTAssertEqual(RamadanService.phase(now: info.date(ofDay: 3).addingTimeInterval(3600 * 12), offset: 0), .during(day: 3))
        XCTAssertEqual(RamadanService.phase(now: info.eid().addingTimeInterval(86_400 * 3), offset: 0), .shawwal)
    }

    func testRamadanTimetableAndFastingEvents() throws {
        let info = try XCTUnwrap(RamadanService.info(year: 1448, offset: 0))
        // Riyadh, Umm al-Qura.
        let rows = RamadanService.timetable(info, lat: 24.7136, lng: 46.6753, method: .ummAlQura, madhab: .shafi, imsakMinutes: 10)
        XCTAssertEqual(rows.count, info.days)
        let first = try XCTUnwrap(rows.first)
        XCTAssertEqual(first.fajr.timeIntervalSince(first.imsak), 600, accuracy: 1)
        XCTAssertLessThan(first.fajr, first.maghrib)

        let noon = first.fajr.addingTimeInterval(4 * 3600)
        let iftar = try XCTUnwrap(RamadanService.nextFastingEvent(now: noon, info: info, lat: 24.7136, lng: 46.6753,
                                                                   method: .ummAlQura, madhab: .shafi))
        XCTAssertTrue(iftar.isIftar)
        XCTAssertEqual(iftar.at, first.maghrib)

        let evening = first.maghrib.addingTimeInterval(3600)
        let suhoor = try XCTUnwrap(RamadanService.nextFastingEvent(now: evening, info: info, lat: 24.7136, lng: 46.6753,
                                                                    method: .ummAlQura, madhab: .shafi))
        XCTAssertFalse(suhoor.isIftar)
        XCTAssertEqual(suhoor.at, rows[1].fajr)
    }

    func testMissedFastGoesToQada() {
        let log = PrayerLogStore(defaults: freshDefaults("qadaFast.log"))
        let store = RamadanStore(defaults: freshDefaults("qadaFast.ramadan"), prayerLog: log)
        store.setFast(.missed, year: 1448, day: 3)
        XCTAssertEqual(log.qadaFasts, 1)
        store.cycleFast(year: 1448, day: 3)   // missed → excused
        XCTAssertEqual(log.qadaFasts, 0)
        store.setFast(.fasted, year: 1448, day: 4)
        XCTAssertEqual(store.fastedCount(year: 1448), 1)
    }

    // MARK: Notifications

    func testPlannerKeepsNearestWithinLimit() {
        let now = Date()
        let candidates = (0..<100).map { i in
            NotificationPlanner.Candidate(id: "c\(i)", date: now.addingTimeInterval(TimeInterval(100 - i) * 3600),
                                          priority: 0, content: UNNotificationContent())
        }
        let picked = NotificationPlanner.select(candidates, limit: NotificationPlanner.limit - 3)
        XCTAssertEqual(picked.count, 57)
        XCTAssertEqual(picked.first?.id, "c99", "The soonest alert must be kept")
        XCTAssertTrue(zip(picked, picked.dropFirst()).allSatisfy { $0.date <= $1.date })
    }

    func testKeepAliveFollowsTheLastScheduledAlert() {
        let now = Date()
        let picked = (0..<5).map { i in
            NotificationPlanner.Candidate(id: "c\(i)", date: now.addingTimeInterval(TimeInterval(i) * 3600),
                                          priority: 0, content: UNNotificationContent())
        }
        let at = NotificationPlanner.keepAliveDate(after: picked.shuffled())
        XCTAssertEqual(at, now.addingTimeInterval(4 * 3600 + 600), "10 minutes after the latest alert")
        XCTAssertNil(NotificationPlanner.keepAliveDate(after: []), "Nothing scheduled, no notice")
    }

    func testKeepAliveStringsExistInEveryLanguage() {
        for lang in ["en", "fr", "ar"] {
            for key in ["notif.keepAliveTitle", "notif.keepAliveBody"] {
                XCTAssertNotNil(Strings.table[key]?[lang], "\(key) missing in \(lang)")
            }
        }
    }

    // MARK: Prayer log

    func testPrayerLogStreakAndQada() {
        let log = PrayerLogStore(defaults: freshDefaults())
        let today = date(2027, 2, 10)
        for back in 1...3 {
            let d = Calendar.current.date(byAdding: .day, value: -back, to: today)!
            for p in PrayerLogStore.fivePrayers { log.set(.onTime, p, on: d) }
        }
        XCTAssertEqual(log.streak(today: today), 3, "Today still in progress does not break the streak")
        log.set(.missed, .fajr, on: today)
        XCTAssertEqual(log.qada(.fajr), 1)
        log.set(.late, .fajr, on: today)
        XCTAssertEqual(log.qada(.fajr), 0)
        log.toggle(.dhuhr, on: today)
        XCTAssertEqual(log.prayedCount(on: today), 2)
    }

    // MARK: Tasbih

    func testTasbihAfterPrayerSequenceAdvances() {
        var s = TasbihState(dayKey: TasbihState.dayKey())
        for _ in 0..<32 { XCTAssertFalse(s.increment()) }
        XCTAssertTrue(s.increment())
        XCTAssertEqual(s.presetID, "alhamdulillah")
        XCTAssertEqual(s.count, 0)
        XCTAssertEqual(s.todayTotal, 33)
        XCTAssertEqual(s.roundsToday, 1)
        s.select("free")
        for _ in 0..<500 { XCTAssertFalse(s.increment()) }
        XCTAssertEqual(s.count, 500)
    }
}
