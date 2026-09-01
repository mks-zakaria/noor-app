import SwiftUI
import UIKit

/// Noor color tokens — deep emerald/teal primary with a warm gold accent.
/// Each token resolves automatically for light/dark via a dynamic UIColor.
enum Palette {
    static let text            = dynamic(light: 0x0B1F1A, dark: 0xECF4F0)
    static let textSecondary   = dynamic(light: 0x4B6157, dark: 0x9FB3AB)
    static let background       = dynamic(light: 0xF7FAF8, dark: 0x0A1512)
    static let backgroundElement = dynamic(light: 0xFFFFFF, dark: 0x10211C)
    static let backgroundSelected = dynamic(light: 0xE3F0EA, dark: 0x173029)
    static let card             = dynamic(light: 0xFFFFFF, dark: 0x10211C)
    static let border           = dynamic(light: 0xE2EAE6, dark: 0x1F3A32)
    static let primary          = dynamic(light: 0x0E7A5F, dark: 0x34C99A)
    static let primarySoft      = dynamic(light: 0xD7EFE6, dark: 0x13352C)
    static let accent           = dynamic(light: 0xC99A3B, dark: 0xE0B85F)
    static let accentSoft       = dynamic(light: 0xF6ECD4, dark: 0x2B2516)
    static let danger           = dynamic(light: 0xC0392B, dark: 0xE57368)

    private static func dynamic(light: Int, dark: Int) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

/// User appearance preference. `system` follows the device setting.
enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
    /// The scheme to force, or nil to follow the system.
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum Spacing {
    static let half: CGFloat = 2
    static let one: CGFloat = 4
    static let two: CGFloat = 8
    static let three: CGFloat = 16
    static let four: CGFloat = 24
    static let five: CGFloat = 32
    static let six: CGFloat = 64
}

enum Radius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let pill: CGFloat = 999
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
