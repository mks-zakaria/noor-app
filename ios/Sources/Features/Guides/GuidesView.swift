import SwiftUI

struct GuidesView: View {
    @Environment(LocalizationManager.self) private var loc

    private let sections: [(key: String, titleKey: String)] = [
        ("purification", "guides.purification"),
        ("prayer", "guides.prayer"),
        ("types", "guides.types"),
    ]

    var body: some View {
        List {
            ForEach(sections, id: \.key) { section in
                let guides = allGuides.filter { $0.section == section.key }
                if !guides.isEmpty {
                    Section(loc.t(section.titleKey)) {
                        ForEach(guides) { g in
                            NavigationLink { GuideDetailView(guide: g) } label: {
                                row(g)
                            }
                            .listRowBackground(Palette.card)
                        }
                    }
                }
            }
        }
        .listStyle(.automatic)
        .scrollContentBackground(.hidden)
        .noorBackground()
        .navigationTitle(loc.t("guides.title"))
    }

    private func row(_ g: Guide) -> some View {
        HStack(spacing: Spacing.three) {
            Image(systemName: g.icon)
                .font(.title3)
                .foregroundStyle(Palette.primary)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(g.title.get(loc.code))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Palette.text)
                Text(g.summary.get(loc.code))
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
}
