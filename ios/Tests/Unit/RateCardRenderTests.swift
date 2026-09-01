import XCTest
import SwiftUI
@testable import Noor

/// The rate card only appears after several days of real use, which makes it the
/// hardest thing in the app to lay eyes on. Rendering it here means its copy and
/// layout can be reviewed in every language without waiting a week.
@MainActor
final class RateCardRenderTests: XCTestCase {

    /// Every key these tests write to. `LocalizationManager.language` and the
    /// review gate both persist on assignment, and the unit tests share a defaults
    /// store with the app the UI tests then drive — so anything touched here is
    /// snapshotted and put back, or the next suite runs against a different app.
    private static let touchedKeys = [
        "noor.language",
        "noor.review.usageDays",
        "noor.review.firstLaunch",
        "noor.review.cardHandled",
        "noor.review.askedVersion",
    ]

    private var saved: [String: Any] = [:]

    override func setUp() {
        super.setUp()
        saved = Self.touchedKeys.reduce(into: [:]) { store, key in
            store[key] = UserDefaults.standard.object(forKey: key)
        }
    }

    override func tearDown() {
        for key in Self.touchedKeys {
            if let value = saved[key] {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        super.tearDown()
    }

    func testRendersInEveryLanguage() throws {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("noor-rate-card", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        for language in [AppLanguage.en, .fr, .ar] {
            let localization = LocalizationManager()
            localization.language = language

            let card = RateCard(onFinished: {})
                .environment(localization)
                .environment(\.layoutDirection, language == .ar ? .rightToLeft : .leftToRight)
                .padding(16)
                .frame(width: 390)
                .background(Color(hex: 0xF7FAF8))

            let renderer = ImageRenderer(content: card)
            renderer.scale = 3
            let image = try XCTUnwrap(renderer.uiImage, "\(language.rawValue) failed to render")
            try XCTUnwrap(image.pngData())
                .write(to: directory.appendingPathComponent("rate-\(language.rawValue).png"))
        }

        print("RATE_CARDS_AT: \(directory.path)")
    }

    /// The card and the system prompt must agree on when an ask is fair; if the
    /// gate drifts apart, one of them starts pestering people on day one.
    func testCardWaitsForTheSameEvidenceAsTheSystemPrompt() {
        let defaults = UserDefaults.standard
        for key in ["noor.review.usageDays", "noor.review.firstLaunch", "noor.review.cardHandled"] {
            defaults.removeObject(forKey: key)
        }

        XCTAssertFalse(ReviewPrompt.hasEarnedAsk(), "a fresh install has earned nothing")
        XCTAssertFalse(ReviewPrompt.showsRateCard)

        // Four separate days of use, starting more than a week ago.
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let start = Date().addingTimeInterval(-10 * 86_400)
        defaults.set(start, forKey: "noor.review.firstLaunch")
        defaults.set((0..<4).map { formatter.string(from: start.addingTimeInterval(Double($0) * 86_400)) },
                     forKey: "noor.review.usageDays")

        XCTAssertTrue(ReviewPrompt.hasEarnedAsk())
        XCTAssertTrue(ReviewPrompt.showsRateCard)

        ReviewPrompt.retireRateCard()
        XCTAssertFalse(ReviewPrompt.showsRateCard, "a retired card must never come back")
    }

    /// Same evidence, so without sequencing both asks come due on the same day and
    /// the system sheet lands on top of the card the user is still reading.
    func testSystemPromptWaitsForTheCardToBeHandled() {
        let defaults = UserDefaults.standard
        for key in Self.touchedKeys where key != "noor.language" {
            defaults.removeObject(forKey: key)
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let start = Date().addingTimeInterval(-10 * 86_400)
        defaults.set(start, forKey: "noor.review.firstLaunch")
        defaults.set((0..<4).map { formatter.string(from: start.addingTimeInterval(Double($0) * 86_400)) },
                     forKey: "noor.review.usageDays")

        XCTAssertTrue(ReviewPrompt.showsRateCard, "the card is the first ask")
        XCTAssertFalse(ReviewPrompt.shouldAsk(), "the system prompt must not fire over a live card")

        ReviewPrompt.retireRateCard()
        XCTAssertTrue(ReviewPrompt.shouldAsk(), "once the card is handled the prompt is eligible")
        XCTAssertFalse(ReviewPrompt.shouldAsk(), "and it is spent for this version")
    }
}
