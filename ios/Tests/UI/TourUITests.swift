import XCTest

/// Walks through every 1.2 screen and saves a screenshot of each, in English
/// and Arabic, so layout and RTL can be reviewed (and store shots captured)
/// without tapping by hand. Screenshots land in $NOOR_SHOTS_DIR when set
/// (simulator only), and are always attached to the test result.
final class TourUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
    }

    func testTourEnglish() { tour(language: "en", labels: Labels.en) }
    func testTourArabic() { tour(language: "ar", labels: Labels.ar) }
    func testPrayerSettingsEnglish() { prayerSettings(language: "en", adjust: "Adjust times") }
    func testPrayerSettingsArabic() { prayerSettings(language: "ar", adjust: "تعديل المواقيت") }

    /// Settings → calculation section (automatic official method) → per-prayer minute offsets.
    private func prayerSettings(language: String, adjust: String) {
        let app = XCUIApplication()
        app.launchArguments += ["-noor.language", language]
        app.launch()
        sleep(2)
        let gear = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'gear' OR label CONTAINS[c] 'setting' OR label CONTAINS[c] 'réglage' OR label CONTAINS 'الإعدادات'")).firstMatch
        XCTAssertTrue(tap(gear), "settings button")
        let cell = app.staticTexts[adjust]
        for _ in 0..<6 where !(cell.exists && cell.isHittable) { app.swipeUp() }
        app.swipeDown()
        shot(app, "\(language)-20-settings-calculation")
        for _ in 0..<6 where !(cell.exists && cell.isHittable) { app.swipeUp() }
        XCTAssertTrue(tap(cell), "adjust times cell")
        sleep(1)
        let plus = app.steppers.firstMatch.buttons.element(boundBy: 1)
        if plus.waitForExistence(timeout: 2) { plus.tap(); plus.tap() }
        shot(app, "\(language)-21-adjust-times")
        // Leave the simulator with no offsets, so later tours and widget renders use plain times.
        let reset = app.buttons[language == "ar" ? "إعادة إلى 0" : "Reset to 0"]
        if reset.waitForExistence(timeout: 2) { reset.tap() }
    }

    struct Labels {
        let ibadah, quran, khatmah, tasbih, ramadan, juz, prayer: String
        static let en = Labels(ibadah: "Ibadah", quran: "Quran", khatmah: "Khatmah", tasbih: "Tasbih",
                               ramadan: "Ramadan", juz: "Juz", prayer: "Prayer")
        static let ar = Labels(ibadah: "عبادات", quran: "القرآن", khatmah: "الختمة", tasbih: "المسبحة",
                               ramadan: "رمضان", juz: "الأجزاء", prayer: "الصلاة")
    }

    private func tour(language: String, labels: Labels) {
        let app = XCUIApplication()
        app.launchArguments += ["-noor.language", language]
        app.launch()
        sleep(2)
        shot(app, "\(language)-01-home")

        app.swipeUp()
        shot(app, "\(language)-02-home-scrolled")

        // Ramadan hub from the Home card.
        app.swipeDown()
        if tap(app.buttons.containing(NSPredicate(format: "label CONTAINS %@", labels.ramadan)).firstMatch) {
            sleep(1)
            shot(app, "\(language)-03-ramadan")
            app.swipeUp()
            shot(app, "\(language)-04-ramadan-duas")
            app.swipeUp(); app.swipeUp()
            shot(app, "\(language)-05-ramadan-timetable")
            back(app)
        }

        // Ibadah tab and its tools.
        app.tabBars.buttons[labels.ibadah].tap()
        sleep(1)
        shot(app, "\(language)-06-ibadah")
        if tap(app.buttons["tool.book.closed.fill"]) {
            sleep(1)
            shot(app, "\(language)-07-khatmah")
            back(app)
        }
        if tap(app.buttons["tool.circle.dotted.circle"]) {
            sleep(1)
            let counter = app.buttons["tasbih.counter"]
            for _ in 0..<7 where counter.exists { counter.tap() }
            shot(app, "\(language)-08-tasbih")
            back(app)
        }

        // Quran: Juz list and full-text search.
        app.tabBars.buttons[labels.quran].tap()
        sleep(1)
        if tap(app.buttons[labels.juz]) {
            shot(app, "\(language)-09-quran-juz")
        }
        let search = app.searchFields.firstMatch
        if search.waitForExistence(timeout: 2) {
            search.tap()
            search.typeText(language == "ar" ? "الرحمن الرحيم" : "mercy")
            sleep(2)
            shot(app, "\(language)-10-quran-search")
        }
    }

    private func back(_ app: XCUIApplication) {
        let b = app.navigationBars.buttons.element(boundBy: 0)
        if b.waitForExistence(timeout: 2) { b.tap() }
    }

    @discardableResult
    private func tap(_ element: XCUIElement) -> Bool {
        guard element.waitForExistence(timeout: 3), element.isHittable else { return false }
        element.tap()
        return true
    }

    private func shot(_ app: XCUIApplication, _ name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        if let dir = ProcessInfo.processInfo.environment["NOOR_SHOTS_DIR"] {
            try? screenshot.pngRepresentation.write(to: URL(fileURLWithPath: dir).appendingPathComponent("\(name).png"))
        }
    }
}
