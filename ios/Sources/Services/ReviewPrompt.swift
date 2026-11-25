import Foundation

/// Decides *when* to ask for an App Store rating — never what to show.
///
/// iOS caps `requestReview()` at three prompts per user per year and silently
/// swallows the rest, so a prompt spent on someone who opened the app once is
/// gone for good. The gate below only lets the ask through after the app has
/// actually been used across several separate days, and at most once per
/// released version.
enum ReviewPrompt {
    /// App Store ID assigned to Noor — used for the manual "write a review" link.
    static let appStoreID = "6790552873"

    /// Opens the App Store review sheet directly, for the Settings row where the
    /// user asked to rate rather than being asked.
    static let writeReviewURL = URL(
        string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review"
    )!

    /// Distinct days the app has been opened before we consider asking.
    private static let requiredUsageDays = 4
    /// Days since first launch, so a burst of curiosity in one week isn't enough.
    private static let requiredAgeInDays = 7

    private enum Keys {
        static let usageDays = "noor.review.usageDays"      // [String] of yyyy-MM-dd
        static let firstLaunch = "noor.review.firstLaunch"  // Date
        static let askedVersion = "noor.review.askedVersion" // String
        static let cardHandled = "noor.review.cardHandled"  // Bool
    }

    private static let d = UserDefaults.standard

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    /// Call every time the app becomes active. Cheap, idempotent within a day.
    static func recordUsage(now: Date = Date()) {
        if d.object(forKey: Keys.firstLaunch) == nil {
            d.set(now, forKey: Keys.firstLaunch)
        }
        let today = dayFormatter.string(from: now)
        var days = d.stringArray(forKey: Keys.usageDays) ?? []
        guard !days.contains(today) else { return }
        days.append(today)
        // Only the count matters; keep the tail bounded.
        d.set(Array(days.suffix(30)), forKey: Keys.usageDays)
    }

    /// True once the user has plausibly gotten value out of the app and we have
    /// not already asked on this version. Consumes the opportunity when it
    /// returns true, so call it immediately before presenting.
    static func shouldAsk(now: Date = Date()) -> Bool {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else { return false }
        guard d.string(forKey: Keys.askedVersion) != version else { return false }
        // The Home card and this prompt wait on the same evidence, so without
        // this guard they both come due on the very same day: the card appears
        // and the system sheet drops on top of it two seconds later. The card
        // goes first and the prompt waits until it has been tapped or dismissed.
        guard d.bool(forKey: Keys.cardHandled) else { return false }

        let days = d.stringArray(forKey: Keys.usageDays) ?? []
        guard days.count >= requiredUsageDays else { return false }

        guard let first = d.object(forKey: Keys.firstLaunch) as? Date,
              now.timeIntervalSince(first) >= Double(requiredAgeInDays) * 86_400
        else { return false }

        d.set(version, forKey: Keys.askedVersion)
        return true
    }

    /// Whether the user has used the app enough for an ask to be fair. Shared by
    /// the system prompt above and the Home card below, so both wait for the same
    /// evidence — the difference is that this one does not consume anything.
    static func hasEarnedAsk(now: Date = Date()) -> Bool {
        let days = d.stringArray(forKey: Keys.usageDays) ?? []
        guard days.count >= requiredUsageDays,
              let first = d.object(forKey: Keys.firstLaunch) as? Date,
              now.timeIntervalSince(first) >= Double(requiredAgeInDays) * 86_400
        else { return false }
        return true
    }

    /// The Home card is a one-time offer: tapping it or dismissing it retires it
    /// for good. Nobody should be asked to rate an app twice by the same card.
    static var showsRateCard: Bool {
        !d.bool(forKey: Keys.cardHandled) && hasEarnedAsk()
    }

    static func retireRateCard() {
        d.set(true, forKey: Keys.cardHandled)
    }
}
