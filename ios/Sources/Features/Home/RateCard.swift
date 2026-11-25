import SwiftUI

/// A one-time, dismissible invitation to rate the app.
///
/// It exists because the Settings row is where people look for a rating only if
/// they already thought of rating. The card shows once, after the same usage
/// evidence the system prompt waits for, and retires the moment it is tapped or
/// closed — see `ReviewPrompt.showsRateCard`.
struct RateCard: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(\.openURL) private var openURL

    let onFinished: () -> Void

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                HStack(alignment: .top) {
                    Label {
                        Text(loc.t("rate.title"))
                            .font(.headline)
                            .foregroundStyle(Palette.text)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Palette.accent)
                    }
                    Spacer()
                    Button {
                        finish()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Palette.textSecondary)
                            .padding(Spacing.one)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(loc.t("rate.dismiss"))
                }

                Text(loc.t("rate.body"))
                    .font(.footnote)
                    .foregroundStyle(Palette.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    openURL(ReviewPrompt.writeReviewURL)
                    finish()
                } label: {
                    Text(loc.t("rate.action"))
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.one)
                }
                .buttonStyle(.borderedProminent)
                .tint(Palette.primary)
                .padding(.top, Spacing.one)
            }
        }
    }

    private func finish() {
        ReviewPrompt.retireRateCard()
        onFinished()
    }
}
