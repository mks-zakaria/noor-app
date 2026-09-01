import SwiftUI
import UIKit

/// Where to send someone who receives a shared card.
///
/// The card carries the link as *text* because an image gets re-saved and
/// re-forwarded far past the original share sheet, and by then the tappable URL
/// in the message is long gone. Swap `displayText` for a short custom domain the
/// day one exists — it is the only place the printed link is spelled out.
enum AppLink {
    static let appStoreID = ReviewPrompt.appStoreID
    static let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)")!
    static let displayText = "apps.apple.com/app/id\(appStoreID)"
}

// MARK: - Content

/// One shareable passage, whatever screen it came from.
struct ShareCardContent: Equatable {
    let arabic: String
    let transliteration: String
    let translation: String
    /// Shown small above the passage — "Al-Baqarah · 2:255", or a hadith source.
    let reference: String

    init(arabic: String, transliteration: String = "", translation: String = "", reference: String) {
        self.arabic = arabic
        self.transliteration = transliteration
        self.translation = translation
        self.reference = reference
    }

    static func ayah(_ ayah: Ayah, surah: Surah, langCode: String) -> ShareCardContent {
        ShareCardContent(
            arabic: ayah.arabic,
            translation: ayah.english,
            reference: "\(surah.displayName(langCode)) · \(surah.number):\(ayah.number)"
        )
    }

    static func dhikr(_ d: Dhikr, langCode: String) -> ShareCardContent {
        let translated = d.displayTranslation(langCode)
        return ShareCardContent(
            arabic: d.arabic,
            transliteration: d.translit,
            translation: translated.isEmpty ? d.translation : translated,
            reference: d.reference
        )
    }

    /// Plain-text form, for the "copy" action and as the message body beside the image.
    func plainText(footer: String) -> String {
        var parts = [arabic]
        if !transliteration.isEmpty { parts.append(transliteration) }
        if !translation.isEmpty { parts.append(translation) }
        if !reference.isEmpty { parts.append("— \(reference)") }
        parts.append(footer)
        return parts.joined(separator: "\n\n")
    }
}

// MARK: - Styles

/// A card's paper. Colors are fixed rather than drawn from `Palette` — the image
/// travels to people whose phones are in the opposite appearance to the sender's,
/// so it has to look the same everywhere.
struct ShareCardStyle: Identifiable, Equatable {
    let id: String
    let titleKey: String
    let backdrop: [Color]
    let surface: Color
    let text: Color
    let secondary: Color
    let accent: Color
    let onBackdrop: Color

    static let all: [ShareCardStyle] = [emerald, night, sand, ink]

    static let emerald = ShareCardStyle(
        id: "emerald",
        titleKey: "share.style.emerald",
        backdrop: [Color(hex: 0x0E7A5F), Color(hex: 0x0A4A4E)],
        surface: Color(hex: 0xFBFDFC),
        text: Color(hex: 0x0B1F1A),
        secondary: Color(hex: 0x4B6157),
        accent: Color(hex: 0x0E7A5F),
        onBackdrop: Color(hex: 0xD7EFE6)
    )

    static let night = ShareCardStyle(
        id: "night",
        titleKey: "share.style.night",
        backdrop: [Color(hex: 0x102A24), Color(hex: 0x04100D)],
        surface: Color(hex: 0x0F211C),
        text: Color(hex: 0xECF4F0),
        secondary: Color(hex: 0x9FB3AB),
        accent: Color(hex: 0x34C99A),
        onBackdrop: Color(hex: 0x2A5147)
    )

    static let sand = ShareCardStyle(
        id: "sand",
        titleKey: "share.style.sand",
        backdrop: [Color(hex: 0xC99A3B), Color(hex: 0x8A5A2B)],
        surface: Color(hex: 0xFDF8EE),
        text: Color(hex: 0x2A1F10),
        secondary: Color(hex: 0x6B573A),
        accent: Color(hex: 0xA97A28),
        onBackdrop: Color(hex: 0xF6ECD4)
    )

    static let ink = ShareCardStyle(
        id: "ink",
        titleKey: "share.style.ink",
        backdrop: [Color(hex: 0x2B2F31), Color(hex: 0x101314)],
        surface: Color(hex: 0xF7F7F5),
        text: Color(hex: 0x14181A),
        secondary: Color(hex: 0x5C6467),
        accent: Color(hex: 0x14181A),
        onBackdrop: Color(hex: 0xBFC6C8)
    )
}

// MARK: - The card

/// The rendered artwork. Laid out at 360×450 points and rendered at 3× for a
/// 1080×1350 image — the portrait shape that survives Instagram, WhatsApp status
/// and iMessage without being re-cropped.
struct ShareCardView: View {
    let content: ShareCardContent
    let style: ShareCardStyle
    var includeTranslation: Bool = true

    static let size = CGSize(width: 360, height: 450)

    var body: some View {
        ZStack {
            LinearGradient(colors: style.backdrop, startPoint: .topLeading, endPoint: .bottomTrailing)

            VStack(spacing: 0) {
                reference
                Spacer(minLength: 12)
                passage
                Spacer(minLength: 12)
                watermark
            }
            .padding(22)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(style.surface)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(style.accent.opacity(0.14), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)
            .padding(20)
        }
        .frame(width: Self.size.width, height: Self.size.height)
    }

    private var reference: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(style.accent.opacity(0.5))
                .frame(width: 14, height: 1)
            Text(content.reference.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .tracking(1.1)
                .foregroundStyle(style.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
    }

    private var passage: some View {
        VStack(spacing: 14) {
            Text(content.arabic)
                .font(.system(size: arabicSize, weight: .medium))
                .foregroundStyle(style.text)
                .lineSpacing(arabicSize * 0.5)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .environment(\.layoutDirection, .rightToLeft)

            if includeTranslation, !secondaryText.isEmpty {
                Rectangle()
                    .fill(style.accent.opacity(0.22))
                    .frame(width: 34, height: 1)

                Text(secondaryText)
                    .font(.system(size: translationSize, weight: .regular, design: .serif))
                    .foregroundStyle(style.secondary)
                    .lineSpacing(translationSize * 0.28)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
            }
        }
    }

    private var watermark: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(style.accent)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Noor")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(style.text)
                    Text(AppLink.displayText)
                        .font(.system(size: 7.5, weight: .medium))
                        .foregroundStyle(style.secondary.opacity(0.85))
                }
            }
        }
    }

    /// Translation is the point of the card for most readers; transliteration only
    /// earns its space on a short du'ā that still has room underneath.
    private var secondaryText: String {
        if !content.translation.isEmpty { return content.translation }
        return content.transliteration
    }

    /// Arabic passages run from four words to a full page, and an image cannot
    /// scroll — so the type size steps down with length, with `minimumScaleFactor`
    /// underneath as the last resort for the extremes.
    private var arabicSize: CGFloat {
        switch content.arabic.count {
        case ..<50: return 32
        case ..<110: return 27
        case ..<200: return 22
        case ..<340: return 18
        case ..<520: return 15
        default: return 13
        }
    }

    private var translationSize: CGFloat {
        switch secondaryText.count {
        case ..<120: return 13
        case ..<260: return 11.5
        case ..<420: return 10
        default: return 9
        }
    }
}

// MARK: - Rendering

@MainActor
enum ShareCardRenderer {
    /// Renders the card to a PNG-ready image. Returns nil only if SwiftUI fails to
    /// rasterize, which callers treat as "fall back to sharing plain text".
    static func image(content: ShareCardContent,
                      style: ShareCardStyle,
                      includeTranslation: Bool) -> UIImage? {
        let renderer = ImageRenderer(
            content: ShareCardView(content: content, style: style,
                                   includeTranslation: includeTranslation)
        )
        renderer.scale = 3
        renderer.isOpaque = true
        return renderer.uiImage
    }
}

extension Color {
    init(hex: Int) {
        self.init(uiColor: UIColor(hex: hex))
    }
}
