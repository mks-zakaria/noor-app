import SwiftUI
import AVFoundation
#if os(iOS)
import UIKit
#endif

struct SurahView: View {
    let surah: Surah
    /// Ayah to open at (from Juz, search, or the Khatmah portion); nil = the top.
    var startAyah: Int? = nil

    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(SettingsStore.self) private var settings
    @Environment(LocalizationManager.self) private var loc
    @Environment(KhatmahStore.self) private var khatmah
    @State private var content: SurahContent?
    /// Furthest ayah seen on screen in this visit.
    @State private var furthestAyah = 0
    @State private var loadError: String?
    @State private var isLoading = false
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var sharing: ShareCardContent?

    @State private var scrollPosition = ScrollPosition(edge: .top)
    @State private var isAutoScrolling = false
    /// Live scroll offsets, deliberately held in a reference type: the scroll
    /// geometry changes on every frame, and routing that through `@State` would
    /// re-evaluate a body holding hundreds of ayah cards sixty times a second.
    @State private var scroll = ScrollTracker()

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.four) {
                header
                if let content {
                    ForEach(content.ayahs) { ayah in
                        ayahView(ayah)
                            .id(ayah.number)
                    }
                } else if isLoading {
                    ProgressView().padding(.top, Spacing.six)
                } else if let loadError {
                    errorView(loadError)
                }
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
            .scrollTargetLayout()
        }
        .scrollPosition($scrollPosition)
        // Reading progress: last read position and the khatmah advance as ayahs
        // pass through the screen, not merely when the surah is opened.
        .onScrollTargetVisibilityChange(idType: Int.self, threshold: 0.6) { visible in
            guard let last = visible.max(), last > furthestAyah else { return }
            recordProgress(upTo: last)
        }
        .onScrollGeometryChange(for: ScrollTracker.Snapshot.self) { geometry in
            ScrollTracker.Snapshot(
                offset: geometry.contentOffset.y,
                limit: max(0, geometry.contentSize.height - geometry.containerSize.height)
            )
        } action: { _, snapshot in
            scroll.snapshot = snapshot
        }
        // A drag interrupts the running animation; when the scroll settles again,
        // pick the glide back up from wherever the reader left it.
        .onScrollPhaseChange { _, phase in
            if isAutoScrolling, phase == .idle { driveAutoScroll() }
        }
        .noorBackground()
        .navigationTitle(surah.displayName(loc.code))
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) { autoScrollButton }
            ToolbarItem(placement: .topBarTrailing) { fontMenu }
            ToolbarItem(placement: .topBarTrailing) { audioButton }
            #else
            ToolbarItem(placement: .automatic) { autoScrollButton }
            ToolbarItem(placement: .automatic) { fontMenu }
            ToolbarItem(placement: .automatic) { audioButton }
            #endif
        }
        .safeAreaInset(edge: .bottom) {
            if isAutoScrolling { speedControls.transition(.move(edge: .bottom).combined(with: .opacity)) }
        }
        .shareCardSheet($sharing)
        .task { await load() }
        .onChange(of: loc.code) { _, _ in
            content = nil
            Task { await load() }
        }
        .onDisappear {
            player?.pause()
            setAutoScroll(false)
        }
    }

    private var header: some View {
        Card {
            VStack(spacing: Spacing.two) {
                Text(surah.arabic)
                    .font(.system(size: 30 * settings.quranFontScale, weight: .bold))
                    .foregroundStyle(Palette.primary)
                Text("\(surah.name) · \(surah.displayMeaning(loc.code))")
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
                if surah.number != 1 && surah.number != 9 {
                    Text(QuranService.bismillah)
                        .font(.system(size: 22 * settings.quranFontScale, weight: .semibold))
                        .foregroundStyle(Palette.text)
                        .padding(.top, Spacing.two)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func ayahView(_ ayah: Ayah) -> some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                HStack {
                    Spacer()
                    Text(ayah.arabic)
                        .font(.system(size: 24 * settings.quranFontScale, weight: .medium))
                        .foregroundStyle(Palette.text)
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(10 * settings.quranFontScale)
                        .environment(\.layoutDirection, .rightToLeft)
                }
                Text(ayah.english)
                    .font(.callout)
                    .foregroundStyle(Palette.textSecondary)
                HStack {
                    if let page = QuranIndex.shared.page(surah: surah.number, ayah: ayah.number) {
                        Text("\(loc.t("quran.page")) \(page)")
                            .font(.caption2)
                            .foregroundStyle(Palette.textSecondary)
                    }
                    Text("\(surah.number):\(ayah.number)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.primary)
                        .padding(.horizontal, Spacing.two)
                        .padding(.vertical, 2)
                        .background(Palette.primarySoft)
                        .clipShape(Capsule())
                    Spacer()
                    Button {
                        sharing = .ayah(ayah, surah: surah, langCode: loc.code)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Palette.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(loc.t("share.title"))
                    Button {
                        bookmarks.toggle(surah: surah.number, ayah: ayah.number,
                                         surahName: surah.name, preview: ayah.english)
                    } label: {
                        Image(systemName: bookmarks.isBookmarked(surah: surah.number, ayah: ayah.number)
                              ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(Palette.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var fontMenu: some View {
        Menu {
            Button {
                settings.quranFontScale = min(1.8, settings.quranFontScale + 0.1)
            } label: { Label(loc.t("quran.largerArabic"), systemImage: "textformat.size.larger") }
            Button {
                settings.quranFontScale = max(0.8, settings.quranFontScale - 0.1)
            } label: { Label(loc.t("quran.smallerArabic"), systemImage: "textformat.size.smaller") }
            Button {
                settings.quranFontScale = 1.0
            } label: { Label(loc.t("quran.resetSize"), systemImage: "arrow.counterclockwise") }
        } label: {
            Image(systemName: "textformat.size")
        }
    }

    private var audioButton: some View {
        Button {
            toggleAudio()
        } label: {
            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
        }
    }

    private var autoScrollButton: some View {
        Button {
            setAutoScroll(!isAutoScrolling)
        } label: {
            Image(systemName: isAutoScrolling
                  ? "arrow.down.circle.fill" : "arrow.down.circle")
                .foregroundStyle(isAutoScrolling ? Palette.primary : Palette.accent)
        }
        .accessibilityLabel(loc.t("quran.autoScroll"))
    }

    /// Floating pace control, shown only while the page is gliding.
    private var speedControls: some View {
        HStack(spacing: Spacing.three) {
            Button { adjustSpeed(by: -1) } label: {
                Image(systemName: "tortoise.fill")
            }
            .disabled(settings.quranAutoScrollSpeed <= SettingsStore.autoScrollSpeeds.first!)
            .accessibilityLabel(loc.t("quran.slower"))

            VStack(spacing: 1) {
                Text(loc.t("quran.autoScroll"))
                    .font(.caption2)
                    .foregroundStyle(Palette.textSecondary)
                Text("\(speedLevel)/\(SettingsStore.autoScrollSpeeds.count)")
                    .font(.subheadline.weight(.bold).monospacedDigit())
                    .foregroundStyle(Palette.text)
            }
            .frame(minWidth: 54)

            Button { adjustSpeed(by: 1) } label: {
                Image(systemName: "hare.fill")
            }
            .disabled(settings.quranAutoScrollSpeed >= SettingsStore.autoScrollSpeeds.last!)
            .accessibilityLabel(loc.t("quran.faster"))

            Divider().frame(height: 22)

            Button { setAutoScroll(false) } label: {
                Image(systemName: "stop.fill")
                    .foregroundStyle(Palette.danger)
            }
            .accessibilityLabel(loc.t("quran.stopScroll"))
        }
        .font(.title3)
        .foregroundStyle(Palette.primary)
        .padding(.horizontal, Spacing.four)
        .padding(.vertical, Spacing.two)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().stroke(Palette.border, lineWidth: 1))
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
        .padding(.bottom, Spacing.two)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: Spacing.three) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
            Button(loc.t("common.retry")) { Task { await load() } }
                .buttonStyle(.borderedProminent)
        }
        .padding(.top, Spacing.six)
    }

    // MARK: Auto-scroll

    private var speedLevel: Int {
        (SettingsStore.autoScrollSpeeds.firstIndex(of: settings.quranAutoScrollSpeed) ?? 2) + 1
    }

    private func setAutoScroll(_ on: Bool) {
        guard on != isAutoScrolling else { return }
        withAnimation(.easeOut(duration: 0.2)) { isAutoScrolling = on }
        // Reading hands-free is the whole point, so don't let the screen lock —
        // and always hand the idle timer back when the glide stops or the screen
        // goes away.
#if os(iOS)
        UIApplication.shared.isIdleTimerDisabled = on
#endif
        if on {
            driveAutoScroll()
        } else {
            stopGliding()
        }
    }

    /// Animates the remaining distance in one go: SwiftUI interpolates the scroll
    /// offset itself, so there is no per-frame state churn behind the movement.
    private func driveAutoScroll() {
        let snapshot = scroll.snapshot
        let remaining = snapshot.limit - snapshot.offset
        guard remaining > 1 else {
            setAutoScroll(false)
            return
        }
        withAnimation(.linear(duration: Double(remaining) / settings.quranAutoScrollSpeed)) {
            scrollPosition.scrollTo(y: snapshot.limit)
        }
    }

    /// Cancels the running animation by re-asserting the position the scroll view
    /// is at right now, without one.
    private func stopGliding() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            scrollPosition.scrollTo(y: scroll.snapshot.offset)
        }
    }

    private func adjustSpeed(by step: Int) {
        let speeds = SettingsStore.autoScrollSpeeds
        let current = speeds.firstIndex(of: settings.quranAutoScrollSpeed) ?? 2
        let next = min(speeds.count - 1, max(0, current + step))
        guard next != current else { return }
        settings.quranAutoScrollSpeed = speeds[next]
        // Restart from here so the new pace takes effect immediately.
        if isAutoScrolling {
            stopGliding()
            driveAutoScroll()
        }
    }

    // MARK: Actions

    private func load() async {
        guard content == nil else { return }
        isLoading = true
        loadError = nil
        do {
            let edition = QuranService.translationEdition(for: loc.code)
            content = try await QuranService.fetchSurah(surah.number, translation: edition)
            if let startAyah, startAyah > 1 {
                // Let the cards lay out before jumping to the requested ayah.
                try? await Task.sleep(for: .milliseconds(150))
                scrollPosition.scrollTo(id: startAyah, anchor: .top)
            } else {
                bookmarks.setLastRead(surah: surah.number, surahName: surah.name, ayah: 1)
            }
        } catch {
            loadError = loc.t("quran.loadError")
        }
        isLoading = false
    }

    private func recordProgress(upTo ayah: Int) {
        furthestAyah = ayah
        bookmarks.setLastRead(surah: surah.number, surahName: surah.name, ayah: ayah)
        if let pages = QuranIndex.shared.completedPages(throughSurah: surah.number, ayah: ayah) {
            khatmah.recordReading(completedPages: pages)
        }
    }

    private func toggleAudio() {
        if isPlaying {
            player?.pause()
            isPlaying = false
            return
        }
        if player == nil, let url = QuranService.audioURL(surah: surah.number) {
            player = AVPlayer(url: url)
        }
        player?.play()
        isPlaying = true
    }
}

/// Holds the newest scroll geometry without publishing it to SwiftUI.
@MainActor
final class ScrollTracker {
    struct Snapshot: Equatable {
        var offset: CGFloat = 0
        /// The largest offset the content can reach — content height minus the visible box.
        var limit: CGFloat = 0
    }

    var snapshot = Snapshot()
}
