import SwiftUI

/// Full-screen felicitation shown once per day on app open, celebrating the
/// running total of adkar the user has remembered.
struct AdkarCelebrationOverlay: View {
    @Environment(LocalizationManager.self) private var loc
    let count: Int
    let onDismiss: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: Spacing.four) {
                Image(systemName: "sparkles")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(Palette.accent)
                    #if os(iOS)
                    .symbolEffect(.pulse)
                    #endif

                Text(loc.t("adkar.celebrateTitle"))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.center)

                VStack(spacing: Spacing.one) {
                    Text("\(count)")
                        .font(.system(size: 64, weight: .bold, design: .rounded).monospacedDigit())
                        .foregroundStyle(Palette.primary)
                        .contentTransition(.numericText())
                    Text(loc.t("adkar.celebrateSubtitle"))
                        .font(.subheadline)
                        .foregroundStyle(Palette.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Button(action: onDismiss) {
                    Text(loc.t("adkar.celebrateDismiss"))
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.three)
                        .background(Palette.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(Spacing.five)
            .frame(maxWidth: 360)
            .background(Palette.card)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg, style: .continuous)
                    .stroke(Palette.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 24, y: 12)
            .padding(Spacing.four)
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) { appeared = true }
        }
    }
}
