import SwiftUI

/// Adkar tab — a browsing home that presents:
///  • the curated daily fortress (morning / evening, fully translated),
///  • the complete Hisn al-Muslim library (132 chapters in 15 themed sections),
///  • curated themed du'ās (provision, need, distress).
/// Tapping any entry opens `DhikrReaderView`, the shared tap-to-count reader.
struct AdkarView: View {
    @Environment(LocalizationManager.self) private var loc

    private var daily: [AdkarCategory] {
        adkarCategories.filter { $0.key == "morning" || $0.key == "evening" }
    }
    private var quranSunnah: [AdkarCategory] {
        adkarCategories.filter { $0.key == "quran-dua" || $0.key == "sunnah-dua" }
    }
    private var themed: [AdkarCategory] {
        adkarCategories.filter { ["rizq", "hajah", "karb"].contains($0.key) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.three) {
                    groupHeader(loc.t("adkar.daily"), "sun.max.fill")
                    ForEach(daily) { cat in
                        NavigationLink {
                            DhikrReaderView(
                                navTitle: cat.displayTitle(loc.code),
                                arabicTitle: cat.titleAr,
                                subtitle: cat.displaySubtitle(loc.code),
                                items: cat.items
                            )
                        } label: {
                            curatedRow(title: cat.displayTitle(loc.code),
                                       arabic: cat.titleAr,
                                       subtitle: cat.displaySubtitle(loc.code),
                                       count: cat.items.count,
                                       icon: cat.key == "morning" ? "sunrise.fill" : "moon.stars.fill")
                        }
                        .buttonStyle(.plain)
                    }

                    groupHeader(loc.t("adkar.quranSunnah"), "text.book.closed.fill")
                    ForEach(quranSunnah) { cat in
                        NavigationLink {
                            DhikrReaderView(
                                navTitle: cat.displayTitle(loc.code),
                                arabicTitle: cat.titleAr,
                                subtitle: cat.displaySubtitle(loc.code),
                                items: cat.items
                            )
                        } label: {
                            curatedRow(title: cat.displayTitle(loc.code),
                                       arabic: cat.titleAr,
                                       subtitle: cat.displaySubtitle(loc.code),
                                       count: cat.items.count,
                                       icon: cat.key == "quran-dua" ? "book.fill" : "quote.bubble.fill")
                        }
                        .buttonStyle(.plain)
                    }

                    groupHeader(loc.t("adkar.hisn"), "book.closed.fill")
                    Text(loc.t("adkar.hisnSubtitle"))
                        .font(.footnote)
                        .foregroundStyle(Palette.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(hisnSections) { section in
                        NavigationLink { HisnSectionView(section: section) } label: {
                            sectionRow(section)
                        }
                        .buttonStyle(.plain)
                    }

                    groupHeader(loc.t("adkar.themed"), "sparkles")
                    ForEach(themed) { cat in
                        NavigationLink {
                            DhikrReaderView(
                                navTitle: cat.displayTitle(loc.code),
                                arabicTitle: cat.titleAr,
                                subtitle: cat.displaySubtitle(loc.code),
                                items: cat.items
                            )
                        } label: {
                            curatedRow(title: cat.displayTitle(loc.code),
                                       arabic: cat.titleAr,
                                       subtitle: cat.displaySubtitle(loc.code),
                                       count: cat.items.count,
                                       icon: "hands.and.sparkles.fill")
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.three)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .noorBackground()
            .navigationTitle(loc.t("adkar.title"))
        }
    }

    private func groupHeader(_ title: String, _ icon: String) -> some View {
        HStack(spacing: Spacing.two) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.accent)
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(Palette.text)
        }
        .padding(.top, Spacing.two)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func curatedRow(title: String, arabic: String, subtitle: String, count: Int, icon: String) -> some View {
        Card {
            HStack(spacing: Spacing.three) {
                iconBubble(icon)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundStyle(Palette.text)
                    Text(subtitle).font(.caption).foregroundStyle(Palette.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                countBadge(count)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    private func sectionRow(_ s: HisnSection) -> some View {
        Card {
            HStack(spacing: Spacing.three) {
                iconBubble(s.icon)
                VStack(alignment: .leading, spacing: 2) {
                    Text(s.title(loc.code)).font(.headline).foregroundStyle(Palette.text)
                    Text(s.subtitle(loc.code)).font(.caption).foregroundStyle(Palette.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                countBadge(s.chapters.count)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    private func iconBubble(_ icon: String) -> some View {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Palette.primary)
            .frame(width: 42, height: 42)
            .background(Palette.primarySoft)
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm, style: .continuous))
    }

    private func countBadge(_ n: Int) -> some View {
        Text("\(n)")
            .font(.subheadline.weight(.bold).monospacedDigit())
            .foregroundStyle(Palette.accent)
    }
}

// MARK: - Hisn section → chapter list

struct HisnSectionView: View {
    @Environment(LocalizationManager.self) private var loc
    let section: HisnSection

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.three) {
                VStack(spacing: Spacing.two) {
                    Image(systemName: section.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Palette.primary)
                        .frame(width: 60, height: 60)
                        .background(Palette.primarySoft)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
                    Text(section.titleAr)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Palette.text)
                        .environment(\.layoutDirection, .rightToLeft)
                    Text("\(section.title(loc.code)) · \(section.chapters.count) \(loc.t("hisn.chapters"))")
                        .font(.footnote)
                        .foregroundStyle(Palette.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.two)

                ForEach(section.chapters) { chapter in
                    NavigationLink { HisnChapterView(chapter: chapter) } label: {
                        chapterRow(chapter)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .noorBackground()
        .navigationTitle(section.title(loc.code))
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func chapterRow(_ c: HisnChapter) -> some View {
        Card {
            HStack(spacing: Spacing.three) {
                Text("\(c.number)")
                    .font(.subheadline.weight(.bold).monospacedDigit())
                    .foregroundStyle(Palette.primary)
                    .frame(width: 34, height: 34)
                    .background(Palette.primarySoft)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(c.titleAr)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Palette.text)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                    Text("\(c.title(loc.code)) · \(c.items.count) \(loc.t("hisn.duas"))")
                        .font(.caption)
                        .foregroundStyle(Palette.textSecondary)
                }
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }
}

// MARK: - Hisn chapter reader

struct HisnChapterView: View {
    @Environment(LocalizationManager.self) private var loc
    let chapter: HisnChapter

    var body: some View {
        DhikrReaderView(
            navTitle: chapter.title(loc.code),
            arabicTitle: chapter.titleAr,
            subtitle: "\(loc.t("hisn.chapter")) \(chapter.number)",
            items: chapter.items
        )
    }
}

// MARK: - Shared tap-to-count reader

/// Renders a list of du'ās as tap-to-count cards. Completing a card removes it
/// (sliding the next into place) and adds one to the global adkar total.
/// Shared by the curated categories and every Hisn al-Muslim chapter.
struct DhikrReaderView: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(AdkarProgressStore.self) private var progress

    let navTitle: String
    let arabicTitle: String
    let subtitle: String
    let items: [Dhikr]

    @State private var remaining: [String: Int] = [:]
    @State private var sharing: ShareCardContent?

    private func isDone(_ d: Dhikr) -> Bool { (remaining[d.id] ?? d.count) == 0 }
    private var visibleItems: [Dhikr] { items.filter { !isDone($0) } }
    private var completed: Int { items.filter(isDone).count }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.three) {
                VStack(spacing: Spacing.two) {
                    Text(arabicTitle)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Palette.text)
                        .multilineTextAlignment(.center)
                        .environment(\.layoutDirection, .rightToLeft)
                    HStack {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(Palette.textSecondary)
                        Spacer()
                        Text("\(completed)/\(items.count)")
                            .font(.subheadline.weight(.semibold).monospacedDigit())
                            .foregroundStyle(Palette.primary)
                    }
                }
                .frame(maxWidth: .infinity)

                if visibleItems.isEmpty {
                    allDoneCard
                } else {
                    ForEach(visibleItems) { dhikr in
                        dhikrCard(dhikr)
                            .transition(.asymmetric(
                                insertion: .identity,
                                removal: .scale(scale: 0.9).combined(with: .opacity)
                            ))
                    }
                }
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .noorBackground()
        .navigationTitle(navTitle)
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        for item in items { remaining[item.id] = item.count }
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        for item in items { remaining[item.id] = item.count }
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            #endif
        }
        .shareCardSheet($sharing)
    }

    private func dhikrCard(_ d: Dhikr) -> some View {
        let left = remaining[d.id] ?? d.count
        return Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Text(d.arabic)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Palette.text)
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .environment(\.layoutDirection, .rightToLeft)

                if d.showTranslit(loc.code) && !d.translit.isEmpty {
                    Text(d.translit)
                        .font(.callout.italic())
                        .foregroundStyle(Palette.textSecondary)
                }
                if !d.displayTranslation(loc.code).isEmpty {
                    Text(d.displayTranslation(loc.code))
                        .font(.callout)
                        .foregroundStyle(Palette.text)
                }

                HStack(spacing: Spacing.three) {
                    if !d.reference.isEmpty {
                        Text(d.reference)
                            .font(.caption)
                            .foregroundStyle(Palette.textSecondary)
                            .lineLimit(2)
                    }
                    Spacer()
                    Button {
                        bookmarks.toggleFavoriteDhikr(d.id)
                    } label: {
                        Image(systemName: bookmarks.isFavoriteDhikr(d.id) ? "heart.fill" : "heart")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(bookmarks.isFavoriteDhikr(d.id) ? Palette.danger : Palette.textSecondary)
                    }
                    .buttonStyle(.plain)
                    Button {
                        sharing = .dhikr(d, langCode: loc.code)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Palette.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(loc.t("share.title"))
                    countChip(left: left)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { count(d) }
        #if os(iOS)
        .sensoryFeedback(.increase, trigger: left)
        #endif
    }

    private func count(_ d: Dhikr) {
        let current = remaining[d.id] ?? d.count
        guard current > 0 else { return }
        let next = current - 1
        if next == 0 {
            progress.increment()
            withAnimation(.easeInOut(duration: 0.3)) { remaining[d.id] = 0 }
        } else {
            remaining[d.id] = next
        }
    }

    private var allDoneCard: some View {
        Card {
            VStack(spacing: Spacing.three) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(Palette.primary)
                Text(loc.t("adkar.allDone"))
                    .font(.headline)
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.center)
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        for item in items { remaining[item.id] = item.count }
                    }
                } label: {
                    Text(loc.t("adkar.reset"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Palette.primary)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.three)
        }
    }

    private func countChip(left: Int) -> some View {
        HStack(spacing: Spacing.one) {
            Image(systemName: left == 0 ? "checkmark.circle.fill" : "hand.tap")
            Text(left == 0 ? loc.t("adkar.done") : "\(left)×")
                .monospacedDigit()
        }
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, Spacing.three)
        .padding(.vertical, Spacing.two)
        .background(left == 0 ? Palette.primarySoft : Palette.accentSoft)
        .foregroundStyle(left == 0 ? Palette.primary : Palette.accent)
        .clipShape(Capsule())
    }
}
