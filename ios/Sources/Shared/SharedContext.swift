import Foundation

// Compiled into the app AND the NoorWidget extension (see project.yml), so the
// writer and the readers of the App Group can never disagree about keys or shapes.

/// What the widgets and Live Activity need to compute prayer times on their own:
/// the coordinates, the calculation choices and the display language.
struct SharedPrayerContext: Codable, Equatable {
    var lat: Double
    var lng: Double
    var method: String
    var madhab: String
    var hour12: Bool
    var language: String
    var place: String
    /// Hijri day correction, so the widget agrees with the app about Ramadan.
    var hijriOffset: Int
    /// The user's per-prayer minute offsets (see PrayerTuning). Part of the context only so a
    /// change reloads the widget timelines; the calculator reads PrayerTuning itself.
    var offsets: [Int]? = nil

    private static let key = "noor.shared.prayerContext"

    static func load() -> SharedPrayerContext? {
        #if os(watchOS)
        // The watch app and its complications share a keychain group, not an App Group (WatchKeychain).
        guard let data = WatchKeychain.data(key) else { return nil }
        #else
        guard let data = UserDefaults(suiteName: WidgetContract.suiteName)?.data(forKey: key) else { return nil }
        #endif
        return try? JSONDecoder().decode(SharedPrayerContext.self, from: data)
    }

    /// Returns true when the stored value changed (so callers reload widgets only then).
    @discardableResult
    func save() -> Bool {
        guard Self.load() != self, let data = try? JSONEncoder().encode(self) else { return false }
        #if os(watchOS)
        WatchKeychain.set(data, Self.key)
        #else
        UserDefaults(suiteName: WidgetContract.suiteName)?.set(data, forKey: Self.key)
        #endif
        return true
    }
}

// MARK: - Tasbih

/// One dhikr the counter can count. Built-in only; the texts are the standard
/// post-prayer and daily adhkar (al-Bukhari, Muslim; see `reference`).
struct TasbihPreset: Identifiable, Hashable {
    let id: String
    let arabic: String
    let translit: String
    let en: String
    let fr: String
    /// 0 = free count, no target.
    let target: Int
    /// Preset that follows when the target is reached (the after-prayer set).
    let next: String?
    let reference: String

    func meaning(_ code: String) -> String { code == "fr" ? fr : en }

    static let all: [TasbihPreset] = [
        TasbihPreset(id: "subhanallah", arabic: "سُبْحَانَ اللَّهِ", translit: "Subḥān Allāh",
                     en: "Glory be to Allah", fr: "Gloire à Allah",
                     target: 33, next: "alhamdulillah", reference: "Muslim 597"),
        TasbihPreset(id: "alhamdulillah", arabic: "الْحَمْدُ لِلَّهِ", translit: "Al-ḥamdu lillāh",
                     en: "All praise is for Allah", fr: "Louange à Allah",
                     target: 33, next: "allahuakbar", reference: "Muslim 597"),
        TasbihPreset(id: "allahuakbar", arabic: "اللَّهُ أَكْبَرُ", translit: "Allāhu akbar",
                     en: "Allah is the Greatest", fr: "Allah est le plus Grand",
                     target: 34, next: nil, reference: "Muslim 596"),
        TasbihPreset(id: "istighfar", arabic: "أَسْتَغْفِرُ اللَّهَ", translit: "Astaghfiru llāh",
                     en: "I seek Allah's forgiveness", fr: "Je demande pardon à Allah",
                     target: 100, next: nil, reference: "Muslim 2702"),
        TasbihPreset(id: "salawat", arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ", translit: "Allāhumma ṣalli ʿalā Muḥammad",
                     en: "O Allah, send blessings upon Muhammad", fr: "Ô Allah, prie sur Muhammad",
                     target: 100, next: nil, reference: "Muslim 408"),
        TasbihPreset(id: "tahlil", arabic: "لَا إِلَٰهَ إِلَّا اللَّهُ", translit: "Lā ilāha illā llāh",
                     en: "There is no god but Allah", fr: "Il n'y a de divinité qu'Allah",
                     target: 100, next: nil, reference: "al-Bukhari 3293, Muslim 2691"),
        TasbihPreset(id: "subhanallahwabihamdihi", arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", translit: "Subḥān Allāhi wa bi-ḥamdih",
                     en: "Glory and praise be to Allah", fr: "Gloire et louange à Allah",
                     target: 100, next: nil, reference: "al-Bukhari 6405, Muslim 2691"),
        TasbihPreset(id: "free", arabic: "ذِكْر", translit: "Dhikr",
                     en: "Free count", fr: "Compteur libre",
                     target: 0, next: nil, reference: ""),
    ]

    static func find(_ id: String) -> TasbihPreset { all.first { $0.id == id } ?? all[0] }
}

/// The counter's state, shared by the app, the home-screen widget and the
/// Control Center / Action Button control.
struct TasbihState: Codable, Equatable {
    var presetID = "subhanallah"
    var count = 0
    var dayKey = ""
    var todayTotal = 0
    var lifetime = 0
    /// Completed rounds (target reached) today.
    var roundsToday = 0

    private static let key = "noor.shared.tasbih"

    var preset: TasbihPreset { TasbihPreset.find(presetID) }

    static func dayKey(for date: Date = Date()) -> String {
        let c = Calendar(identifier: .gregorian).dateComponents(in: .current, from: date)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }

    static func load() -> TasbihState {
        guard let data = UserDefaults(suiteName: WidgetContract.suiteName)?.data(forKey: key),
              var s = try? JSONDecoder().decode(TasbihState.self, from: data)
        else { return TasbihState(dayKey: dayKey()) }
        s.rollDay()
        return s
    }

    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        UserDefaults(suiteName: WidgetContract.suiteName)?.set(data, forKey: Self.key)
    }

    private mutating func rollDay() {
        let today = Self.dayKey()
        if dayKey != today {
            dayKey = today
            todayTotal = 0
            roundsToday = 0
        }
    }

    /// Counts one dhikr. Returns true when this tap completed the preset's target.
    @discardableResult
    mutating func increment(on date: Date = Date()) -> Bool {
        rollDay()
        count += 1
        todayTotal += 1
        lifetime += 1
        let target = preset.target
        guard target > 0, count >= target else { return false }
        roundsToday += 1
        if let next = preset.next {
            presetID = next
            count = 0
        } else {
            count = 0
        }
        return true
    }

    mutating func reset() { count = 0 }

    mutating func select(_ id: String) {
        guard id != presetID else { return }
        presetID = id
        count = 0
    }
}
