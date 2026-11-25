import XCTest

/// Uses Noor like a person would while `tools/promo/record.sh` records the simulator screen, and logs where
/// each segment starts and ends so `tools/promo/make_videos.py` can cut it into short videos.
/// Skipped in normal runs. Env (set with the TEST_RUNNER_ prefix): PROMO_LOG=<file>, PROMO_SCENARIO=
/// home|adkar|quran|tasbih|ramadan|khatmah, PROMO_LANG=ar|fr, PROMO_TAG=<free text, e.g. the city>.
/// Log lines: `<epoch s> <START|END> <segment> | <detail>`.
final class PromoRecording: XCTestCase {

    private var logURL: URL!
    private var env: [String: String] { ProcessInfo.processInfo.environment }

    override func setUpWithError() throws {
        try XCTSkipUnless(env["PROMO_LOG"] != nil, "promo recording only")
        logURL = URL(fileURLWithPath: env["PROMO_LOG"]!)
        continueAfterFailure = true
    }

    private func log(_ kind: String, _ segment: String, _ detail: String = "") {
        let line = String(format: "%.3f", Date().timeIntervalSince1970) + " \(kind) \(segment) | \(detail)\n"
        if let h = try? FileHandle(forWritingTo: logURL) { h.seekToEndOfFile(); h.write(line.data(using: .utf8)!); try? h.close() }
        else { try? line.write(to: logURL, atomically: true, encoding: .utf8) }
    }

    struct L { let adkar, quran, ibadah, morning, evening, ramadan: String }
    private var lang: String { env["PROMO_LANG"] ?? "ar" }
    private var labels: L {
        switch lang {
        case "fr": return L(adkar: "Rappels", quran: "Coran", ibadah: "Ibadat", morning: "Rappel du matin", evening: "Rappel du soir", ramadan: "Ramadan")
        case "en": return L(adkar: "Adkar", quran: "Quran", ibadah: "Ibadah", morning: "Morning Adkar", evening: "Evening Adkar", ramadan: "Ramadan")
        default: return L(adkar: "الأذكار", quran: "القرآن", ibadah: "عبادات", morning: "أذكار الصباح", evening: "أذكار المساء", ramadan: "رمضان")
        }
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-noor.language", lang]
        app.launch()
        sleep(3)
        return app
    }

    @discardableResult
    private func tap(_ e: XCUIElement, _ timeout: TimeInterval = 4) -> Bool {
        guard e.waitForExistence(timeout: timeout), e.isHittable else { return false }
        e.tap(); return true
    }

    private func back(_ app: XCUIApplication) {
        let b = app.navigationBars.buttons.element(boundBy: 0)
        if b.waitForExistence(timeout: 2) { b.tap() }
        sleep(1)
    }

    func testRecord() {
        let app = launch()
        switch env["PROMO_SCENARIO"] ?? "home" {
        case "home": home(app)
        case "adkar": adkar(app)
        case "quran": quran(app)
        case "tasbih": tasbih(app)
        case "ramadan": ramadan(app)
        case "khatmah": khatmah(app)
        default: XCTFail("unknown scenario")
        }
    }

    /// Prayer times for the simulated city: next prayer + countdown, then the day's list.
    private func home(_ app: XCUIApplication) {
        let tag = env["PROMO_TAG"] ?? ""
        sleep(2)
        log("START", "home", tag)
        sleep(5)
        app.swipeUp(velocity: .slow)
        sleep(4)
        log("END", "home", tag)
    }

    /// Morning then evening adkar: each dhikr counted by tapping its card at a calm pace.
    private func adkar(_ app: XCUIApplication) {
        app.tabBars.buttons[labels.adkar].tap(); sleep(1)
        let only = env["PROMO_TAG"] ?? ""                            // "morning" / "evening" / both when empty
        for (cat, title) in [("morning", labels.morning), ("evening", labels.evening)] where only.isEmpty || only == cat {
            guard tap(app.staticTexts[title]) else { XCTFail("no \(title)"); continue }
            sleep(2)
            var done = 0
            while done < 6 {
                let card = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH 'dhikr.'")).firstMatch
                guard card.waitForExistence(timeout: 3) else { break }
                let parts = card.identifier.split(separator: ".")
                let n = Int(parts.last ?? "1") ?? 1
                let id = parts.dropFirst().dropLast().joined(separator: ".")
                if n > 10 { break }                                  // 100× dhikrs make long, flat videos
                log("START", "dhikr", "\(cat) \(id) \(n)")
                sleep(3)                                             // time to read it (and for the recorder to start)
                for _ in 0..<n { if card.exists && card.isHittable { card.tap() }; usleep(700_000) }
                sleep(1)
                log("END", "dhikr", "\(cat) \(id) \(n)")
                done += 1
            }
            back(app)
        }
    }

    /// Surahs and well-known ayahs, opened from search and read by scrolling slowly.
    private func quran(_ first: XCUIApplication) {
        let items: [(String, String)] = [("الكهف", "kahf"), ("الملك", "mulk"), ("يس", "yasin"), ("الرحمن", "rahman"),
                                         ("الواقعة", "waqia"), ("الفاتحة", "fatiha")]
        var app = first
        for (i, (name, key)) in items.enumerated() {
            if i > 0 { app.terminate(); app = launch() }             // a fresh search field each time
            app.tabBars.buttons[labels.quran].tap(); sleep(1)
            let field = app.searchFields.firstMatch
            if !field.exists { app.swipeDown(); sleep(1) }           // iOS hides the search bar until pulled down
            guard tap(field) else { XCTFail("no search field"); continue }
            field.typeText(name); sleep(2)
            let row = app.buttons.containing(NSPredicate(format: "label CONTAINS %@", name)).firstMatch
            guard tap(row) else { XCTFail("no row \(name)"); continue }
            sleep(3)
            log("START", "surah", key)
            sleep(2)
            for _ in 0..<3 { app.swipeUp(velocity: .slow); sleep(2) }
            log("END", "surah", key)
        }
    }

    /// The after-prayer tasbih: 33 + 33 + 34 on the full-screen counter (1.2).
    private func tasbih(_ app: XCUIApplication) {
        app.tabBars.buttons[labels.ibadah].tap(); sleep(1)
        guard tap(app.buttons["tool.circle.dotted.circle"]) else { return XCTFail("no tasbih tool") }
        sleep(2)
        let counter = app.descendants(matching: .any)["tasbih.counter"]
        guard counter.waitForExistence(timeout: 4) else { return XCTFail("no counter") }
        log("START", "tasbih", "after-prayer")
        sleep(2)
        for _ in 0..<100 { counter.tap(); usleep(120_000) }
        sleep(3)
        log("END", "tasbih", "after-prayer")
    }

    /// The Ramadan hub from the Home card (1.2).
    private func ramadan(_ app: XCUIApplication) {
        guard tap(app.buttons.containing(NSPredicate(format: "label CONTAINS %@", labels.ramadan)).firstMatch) else {
            return XCTFail("no Ramadan card")
        }
        sleep(2)
        log("START", "ramadan", "hub")
        sleep(4)
        for _ in 0..<4 { app.swipeUp(velocity: .slow); sleep(2) }
        log("END", "ramadan", "hub")
    }

    /// The khatmah planner (1.2).
    private func khatmah(_ app: XCUIApplication) {
        app.tabBars.buttons[labels.ibadah].tap(); sleep(1)
        guard tap(app.buttons["tool.book.closed.fill"]) else { return XCTFail("no khatmah tool") }
        sleep(2)
        log("START", "khatmah", "plan")
        sleep(3)
        app.swipeUp(velocity: .slow); sleep(3)
        log("END", "khatmah", "plan")
    }
}
