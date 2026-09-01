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
         kuwait, moonsightingCommittee, northAmerica, singapore, turkey, tehran
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
        case .singapore: return "Singapore"
        case .turkey: return "Diyanet (Turkey)"
        case .tehran: return "Tehran"
        }
    }

    var adhan: CalculationMethod {
        switch self {
        case .muslimWorldLeague: return .muslimWorldLeague
        case .egyptian: return .egyptian
        case .karachi: return .karachi
        case .ummAlQura: return .ummAlQura
        case .dubai: return .dubai
        case .qatar: return .qatar
        case .kuwait: return .kuwait
        case .moonsightingCommittee: return .moonsightingCommittee
        case .northAmerica: return .northAmerica
        case .singapore: return .singapore
        case .turkey: return .turkey
        case .tehran: return .tehran
        }
    }
}
