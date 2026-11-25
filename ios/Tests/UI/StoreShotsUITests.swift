import XCTest

/// Raw app screens for the App Store, in en / fr / ar, on whatever simulator runs it
/// (the 13" iPad Pro for the iPad set). Saved to $NOOR_SHOTS_DIR as <lang>-<n>-<screen>.png;
/// store/make_ipad.py frames them with the headlines.
final class StoreShotsUITests: XCTestCase {
    override func setUp() { continueAfterFailure = true }

    struct Tabs { let quran, adkar, ibadah, fajr: String }
    static let tabs: [String: Tabs] = [
        "en": Tabs(quran: "Quran", adkar: "Adkar", ibadah: "Ibadah", fajr: "Fajr"),
        "fr": Tabs(quran: "Coran", adkar: "Rappels", ibadah: "Ibadat", fajr: "Fajr"),
        "ar": Tabs(quran: "القرآن", adkar: "الأذكار", ibadah: "عبادات", fajr: "الفجر"),
    ]

    /// iPadOS 26+ can run apps in resizable windows; store shots need Full Screen Apps.
    /// Flips Settings › Multitasking & Gestures the way a user would. No-op on iPhone.
    func test0FullScreenApps() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settings.launch()
        let candidates = ["Multitasking & Gestures", "Multitasking"]
        var opened = false
        for _ in 0..<6 where !opened {
            for c in candidates {
                let cell = settings.staticTexts[c].firstMatch
                if cell.exists && cell.isHittable { cell.tap(); opened = true; break }
            }
            if !opened { settings.swipeUp() }
        }
        sleep(1)
        let full = settings.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Full Screen'")).firstMatch
        if full.waitForExistence(timeout: 3) { full.tap() } else { print("SETTINGS-TREE:\n\(settings.debugDescription)") }
        sleep(1)
        if let dir = ProcessInfo.processInfo.environment["NOOR_SHOTS_DIR"] {
            try? settings.screenshot().pngRepresentation.write(to: URL(fileURLWithPath: dir).appendingPathComponent("zz-settings.png"))
        }
        settings.terminate()
    }

    func testStoreShotsEnglish() { shots("en") }
    func testStoreShotsFrench() { shots("fr") }
    func testStoreShotsArabic() { shots("ar") }

    private func shots(_ lang: String) {
        let t = Self.tabs[lang]!
        let app = XCUIApplication()
        app.launchArguments += ["-noor.language", lang]
        app.launch()
        allowLocation(app)
        // Wait until the prayer times are on screen, not the loading spinner.
        _ = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", t.fajr)).firstMatch.waitForExistence(timeout: 15)
        sleep(2)
        shot(app, "\(lang)-1-home")

        tab(app, t.quran); sleep(2)
        shot(app, "\(lang)-2-quran")

        tab(app, t.adkar); sleep(2)
        shot(app, "\(lang)-3-adkar")

        tab(app, t.ibadah); sleep(1)
        // A believable day: the first three prayers logged.
        for p in ["fajr", "dhuhr", "asr"] {
            let b = app.buttons["check.\(p)"].firstMatch
            if b.waitForExistence(timeout: 2) { b.tap() }
        }
        sleep(1)
        shot(app, "\(lang)-4-ibadah")
        // Leave the log clean for the next language.
        for p in ["fajr", "dhuhr", "asr"] { app.buttons["check.\(p)"].firstMatch.tap() }
    }

    @discardableResult
    private func tab(_ app: XCUIApplication, _ label: String) -> Bool {
        let bar = app.tabBars.buttons[label]
        if bar.waitForExistence(timeout: 2) { bar.tap(); return true }
        let b = app.buttons[label].firstMatch
        guard b.waitForExistence(timeout: 3) else { return false }
        b.tap(); return true
    }

    private func allowLocation(_ app: XCUIApplication) {
        let cont = app.buttons.matching(NSPredicate(format: "label IN %@", ["Continue", "متابعة", "Continuer"])).firstMatch
        guard cont.waitForExistence(timeout: 3), cont.isHittable else { return }
        cont.tap()
        let allow = XCUIApplication(bundleIdentifier: "com.apple.springboard").buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 5) { allow.tap() }
    }

    private func shot(_ app: XCUIApplication, _ name: String) {
        let s = app.screenshot()
        let a = XCTAttachment(screenshot: s); a.name = name; a.lifetime = .keepAlways; add(a)
        if let dir = ProcessInfo.processInfo.environment["NOOR_SHOTS_DIR"] {
            try? s.pngRepresentation.write(to: URL(fileURLWithPath: dir).appendingPathComponent("\(name).png"))
        }
    }
}
