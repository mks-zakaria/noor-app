import SwiftUI

/// A rounded surface card matching the Noor design language.
struct Card<Content: View>: View {
    var padding: CGFloat = Spacing.three
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Palette.card)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                    .stroke(Palette.border, lineWidth: 1)
            )
    }
}

/// Section header used across screens.
struct SectionHeader: View {
    let title: String
    var arabic: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Palette.text)
            Spacer()
            if let arabic {
                Text(arabic)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }
}

extension View {
    /// Standard screen background.
    func noorBackground() -> some View {
        background(Palette.background.ignoresSafeArea())
    }
}
