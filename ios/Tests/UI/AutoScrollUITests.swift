import XCTest

/// Auto-scroll is driven by a single long `withAnimation` over `ScrollPosition`
/// rather than a per-frame timer, which is cheap but depends on SwiftUI actually
/// interpolating the scroll offset. That is not something a compile can prove, so
/// it is asserted here: the page must move on its own, and must stop when asked.
final class AutoScrollUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// Opens Al-Baqarah — long enough that there is always somewhere to scroll to,
    /// and near enough the top of the lazy list to be on screen without scrolling.
    /// Returns the first ayah's number chip, used as the landmark to measure by.
    private func openLongSurah(_ app: XCUIApplication) -> XCUIElement {
        // Pin the in-app language via the argument domain, which outranks the
        // stored preference. Without it these tests look for "Quran" on a phone
        // whose owner reads the app in Arabic, and find "القرآن".
        app.launchArguments += ["-noor.language", "en"]
        app.launch()

        // The tab bar is not up the instant `launch()` returns, and an unlabelled
        // tap would fail before the first frame is rendered.
        let quranTab = app.tabBars.buttons["Quran"]
        XCTAssertTrue(quranTab.waitForExistence(timeout: 30), "tab bar never appeared")
        quranTab.tap()

        let row = app.staticTexts["Al-Baqarah"]
        XCTAssertTrue(row.waitForExistence(timeout: 10), "surah list never appeared")
        row.tap()

        let firstAyah = app.staticTexts["2:1"]
        XCTAssertTrue(firstAyah.waitForExistence(timeout: 60),
                      "surah content never loaded — is the simulator online?")
        return firstAyah
    }

    func testAutoScrollMovesThePageOnItsOwn() {
        let app = XCUIApplication()
        let landmark = openLongSurah(app)

        let before = landmark.frame.origin.y
        app.buttons["Auto-scroll"].tap()
        Thread.sleep(forTimeInterval: 4)
        let after = landmark.frame.origin.y

        // Middle speed is 30pt/s, so four seconds should carry the page ~120pt.
        // Assert on a fraction of that to stay clear of timing jitter.
        XCTAssertLessThan(after, before - 40,
                          "page did not scroll on its own (moved \(before - after)pt in 4s)")
    }

    /// The card artwork is covered by the render tests; what those cannot reach is
    /// whether tapping share on a real ayah actually gets you there.
    func testSharingAnAyahOpensTheCardSheet() {
        let app = XCUIApplication()
        _ = openLongSurah(app)

        app.buttons["Share"].firstMatch.tap()

        XCTAssertTrue(app.buttons["Share card"].waitForExistence(timeout: 5),
                      "share sheet did not open")
        XCTAssertTrue(app.buttons["Copy as text"].exists)
        XCTAssertTrue(app.switches["Include translation"].exists,
                      "an ayah with a translation should offer the toggle")
    }

    func testStoppingHoldsThePageStill() {
        let app = XCUIApplication()
        let landmark = openLongSurah(app)

        app.buttons["Auto-scroll"].tap()
        Thread.sleep(forTimeInterval: 2)

        app.buttons["Stop scrolling"].tap()
        Thread.sleep(forTimeInterval: 0.5)
        let atStop = landmark.frame.origin.y
        Thread.sleep(forTimeInterval: 2.5)

        XCTAssertEqual(landmark.frame.origin.y, atStop, accuracy: 4,
                       "page kept moving after stop")
    }
}
