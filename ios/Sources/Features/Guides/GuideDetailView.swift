import SwiftUI

struct GuideDetailView: View {
    let guide: Guide
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.three) {
                Card {
                    Text(guide.summary.get(loc.code))
                        .font(.callout)
                        .foregroundStyle(Palette.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ForEach(guide.steps) { step in
                    stepCard(step)
                }
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .noorBackground()
        .navigationTitle(guide.title.get(loc.code))
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func stepCard(_ s: GuideStep) -> some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                HStack(alignment: .top, spacing: Spacing.three) {
                    Text("\(s.id)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Palette.primary)
                        .frame(width: 28, height: 28)
                        .background(Palette.primarySoft)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: Spacing.one) {
                        Text(s.title.get(loc.code))
                            .font(.headline)
                            .foregroundStyle(Palette.text)
                        Text(s.body.get(loc.code))
                            .font(.callout)
                            .foregroundStyle(Palette.textSecondary)
                    }
                }
                if !s.arabic.isEmpty {
                    Divider().overlay(Palette.border)
                    Text(s.arabic)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Palette.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                    if !s.translit.isEmpty && loc.code != "ar" {
                        Text(s.translit)
                            .font(.caption.italic())
                            .foregroundStyle(Palette.textSecondary)
                    }
                }
            }
        }
    }
}
