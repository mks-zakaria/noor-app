import SwiftUI

/// Shown before the system location prompt, on every screen that can trigger it.
///
/// Its job is to explain *why* the app asks — App Store Review asked for more
/// information up front under guideline 5.1.1(iv). Two rules hold here:
/// the button label stays neutral ("Continue", never "Enable Location"), and
/// nothing in this card is shown once the user has answered the prompt.
struct LocationIntroCard: View {
    @Environment(LocationManager.self) private var location
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        // Kept deliberately compact: on iPad (iPhone compatibility mode) and on
        // short iPhones a taller card pushed Continue underneath the tab bar,
        // hiding the only way to proceed.
        Card {
            VStack(spacing: Spacing.two) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Palette.primary)

                Text(loc.t("location.why.title"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: Spacing.one) {
                    reason("sun.horizon.fill", loc.t("location.why.prayer"))
                    reason("location.north.line.fill", loc.t("location.why.qibla"))
                }

                Text(loc.t("location.why.privacy"))
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
                    .multilineTextAlignment(.center)

                Text(loc.t("location.why.next"))
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.center)
                    .padding(.top, Spacing.one)

                Button(loc.t("common.continue")) { location.request() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func reason(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.two) {
            Image(systemName: icon)
                .foregroundStyle(Palette.primary)
                .frame(width: 22)
            Text(text)
                .font(.footnote)
                .foregroundStyle(Palette.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
