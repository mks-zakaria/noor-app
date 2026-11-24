import Foundation
import Adhan

enum PrayerName: String, CaseIterable, Identifiable {
    case fajr, sunrise, dhuhr, asr, maghrib, isha
    var id: String { rawValue }

    /// Sunrise is informational, not one of the five obligatory prayers.
    var isPrayer: Bool { self != .sunrise }

    var en: String {
        switch self {
        case .fajr: return "Fajr"
        case .sunrise: return "Sunrise"
        case .dhuhr: return "Dhuhr"
        case .asr: return "Asr"
        case .maghrib: return "Maghrib"
        case .isha: return "Isha"
        }
    }

    var ar: String {
        switch self {
        case .fajr: return "الفجر"
        case .sunrise: return "الشروق"
        case .dhuhr: return "الظهر"
        case .asr: return "العصر"
        case .maghrib: return "المغرب"
        case .isha: return "العشاء"
        }
    }

    var systemImage: String {
        switch self {
        case .fajr: return "sunrise"
        case .sunrise: return "sun.max"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "cloud.sun"
        case .maghrib: return "sunset"
        case .isha: return "moon.stars"
        }
    }
}

let prayerOrder: [PrayerName] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]

enum MadhabKey: String, CaseIterable, Identifiable {
    case shafi, hanafi
    var id: String { rawValue }
    var label: String { self == .hanafi ? "Hanafi" : "Shafi / Maliki / Hanbali" }
    var adhan: Madhab { self == .hanafi ? .hanafi : .shafi }
}

enum MethodKey: String, CaseIterable, Identifiable {
    case muslimWorldLeague, egyptian, karachi, ummAlQura, dubai, qatar,
         kuwait, moonsightingCommittee, northAmerica, singapore, turkey, tehran,
         // Official national methods missing from adhan-swift (angles and minute offsets as
         // published by each authority; same values as api.aladhan.com methods 12, 18, 19, 21, 23).
         morocco, algeria, tunisia, franceUOIF, france15, jordan
    var id: String { rawValue }

    var label: String {
        switch self {
        case .muslimWorldLeague: return "Muslim World League"
        case .egyptian: return "Egyptian General Authority"
        case .karachi: return "Univ. of Islamic Sciences, Karachi"
        case .ummAlQura: return "Umm al-Qura, Makkah"
        case .dubai: return "Dubai"
        case .qatar: return "Qatar"
        case .kuwait: return "Kuwait"
        case .moonsightingCommittee: return "Moonsighting Committee"
        case .northAmerica: return "ISNA (North America)"
        case .singapore: return "Singapore / Malaysia / Indonesia"
        case .turkey: return "Diyanet (Turkey)"
        case .tehran: return "Tehran"
        case .morocco: return "Morocco (Habous)"
        case .algeria: return "Algeria"
        case .tunisia: return "Tunisia"
        case .franceUOIF: return "France (UOIF, 12°)"
        case .france15: return "France (15°)"
        case .jordan: return "Jordan"
        }
    }

    /// Calculation parameters, without madhab, high-latitude rule or minute offsets
    /// (PrayerService adds those, including `officialMinutes`).
    var params: CalculationParameters {
        func custom(_ fajr: Double, _ isha: Double) -> CalculationParameters {
            var p = CalculationMethod.other.params
            p.fajrAngle = fajr
            p.ishaAngle = isha
            return p
        }
        switch self {
        case .muslimWorldLeague: return CalculationMethod.muslimWorldLeague.params
        case .egyptian: return CalculationMethod.egyptian.params
        case .karachi: return CalculationMethod.karachi.params
        case .ummAlQura: return CalculationMethod.ummAlQura.params
        case .dubai: return CalculationMethod.dubai.params
        case .qatar: return CalculationMethod.qatar.params
        case .kuwait: return CalculationMethod.kuwait.params
        case .moonsightingCommittee: return CalculationMethod.moonsightingCommittee.params
        case .northAmerica: return CalculationMethod.northAmerica.params
        case .singapore: return CalculationMethod.singapore.params
        case .turkey: return CalculationMethod.turkey.params
        case .tehran: return CalculationMethod.tehran.params
        // Ministry of Habous: the app uses HabousTimes (the ministry's own calculation, per city);
        // these parameters are only the fallback outside the ministry's cities.
        case .morocco: return custom(19, 17)
        case .algeria: return custom(18, 17)
        case .tunisia: return custom(18, 18)
        case .franceUOIF: return custom(12, 12)
        case .france15: return custom(15, 15)
        case .jordan: return custom(18, 18)       // Ministry of Awqaf
        }
    }

    /// Fixed minutes the authority adds (fajr, sunrise, dhuhr, asr, maghrib, isha). adhan-swift keeps
    /// its own methods' adjustments internal, so these apply only to the methods added here.
    var officialMinutes: [Int] {
        switch self {
        case .morocco: return [0, 0, 5, 0, 5, 0]   // Dhuhr +5, Maghrib +5
        case .jordan: return [0, 0, 0, 0, 5, 0]    // Maghrib +5
        default: return [0, 0, 0, 0, 0, 0]
        }
    }

    /// The method used by the official authority of a country (ISO 3166 code), and the
    /// madhab when the country's Asr is Hanafi. Used while "Automatic" is on.
    static func forCountry(_ code: String) -> (method: MethodKey, madhab: MadhabKey) {
        switch code.uppercased() {
        case "MA", "EH": return (.morocco, .shafi)
        case "DZ": return (.algeria, .shafi)
        case "TN": return (.tunisia, .shafi)
        case "FR", "MC": return (.franceUOIF, .shafi)
        case "SA", "YE": return (.ummAlQura, .shafi)
        case "EG", "SD", "LY", "SY", "LB", "IQ", "PS": return (.egyptian, .shafi)
        case "AE": return (.dubai, .shafi)
        case "QA", "BH", "OM": return (.qatar, .shafi)
        case "KW": return (.kuwait, .shafi)
        case "JO": return (.jordan, .shafi)
        case "TR": return (.turkey, .shafi)
        case "IR": return (.tehran, .shafi)
        case "PK", "IN", "BD", "AF": return (.karachi, .hanafi)
        case "SG", "MY", "ID", "BN": return (.singapore, .shafi)
        case "US", "CA": return (.northAmerica, .shafi)
        case "GB", "IE": return (.moonsightingCommittee, .shafi)
        default: return (.muslimWorldLeague, .shafi)
        }
    }
}
