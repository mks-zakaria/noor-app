import Foundation

/// A string localized to the three app languages.
struct L3: Hashable {
    let en: String
    let fr: String
    let ar: String
    func get(_ code: String) -> String {
        switch code {
        case "fr": return fr
        case "ar": return ar
        default: return en
        }
    }
}

struct GuideStep: Identifiable, Hashable {
    let id: Int
    let title: L3
    let body: L3
    let arabic: String      // Arabic recited in this step, or ""
    let translit: String    // Latin transliteration of `arabic`, or ""
}

struct Guide: Identifiable, Hashable {
    let id: String
    let section: String     // "purification" | "prayer" | "types"
    let icon: String        // SF Symbol
    let title: L3
    let summary: L3
    let steps: [GuideStep]
}

/// All guides, ordered: purification → the prayer → prayer types.
/// (Section arrays live in Guides/Data/*.swift.)
let allGuides: [Guide] = purificationGuides + salatGuides + typeGuides
