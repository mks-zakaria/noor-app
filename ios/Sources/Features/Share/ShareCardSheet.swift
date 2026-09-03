import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Pick a paper, then share. The preview is the same view that gets rasterized,
/// so what the user approves is exactly what leaves the phone.
struct ShareCardSheet: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(\.dismiss) private var dismiss

    let content: ShareCardContent

    @AppStorage("noor.share.style") private var styleID = ShareCardStyle.emerald.id
    @State private var includeTranslation = true
    @State private var payload: SharePayload?
    @State private var didCopy = false

    private var style: ShareCardStyle {
        ShareCardStyle.all.first { $0.id == styleID } ?? .emerald
    }

    private var hasTranslation: Bool {
        !content.translation.isEmpty || !content.transliteration.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.four) {
                    preview
                    styles
                    if hasTranslation {
                        Toggle(loc.t("share.includeTranslation"), isOn: $includeTranslation)
                            .tint(Palette.primary)
                    }
                }
                .padding(Spacing.three)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
            // Pinned, never scrolled away. On iPad the app runs in iPhone
            // compatibility mode — a short, narrow window where the full-size card
            // preview pushed this button off the bottom entirely, leaving a screen
            // whose only action was invisible. Keep it out of the ScrollView.
            .safeAreaInset(edge: .bottom) {
                actions
                    .padding(.horizontal, Spacing.three)
                    .padding(.top, Spacing.two)
                    .padding(.bottom, Spacing.two)
                    .frame(maxWidth: 520)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
            }
            .noorBackground()
            .navigationTitle(loc.t("share.title"))
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button(loc.t("common.done")) { dismiss() }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button(loc.t("common.done")) { dismiss() }
                }
                #endif
            }
        }
#if os(iOS)
        .sheet(item: $payload) { ActivityView(items: $0.items) }
#endif
    }

    private var preview: some View {
        // The card is laid out at a fixed 360pt and scaled down to whatever width
        // the sheet actually has, rather than reflowed, so the preview cannot
        // disagree with the exported image. Height comes from the aspect ratio —
        // asking `UIScreen` would be wrong in iPhone compatibility mode on iPad,
        // where the window is narrower than the screen.
        Color.clear
            .aspectRatio(ShareCardView.size.width / ShareCardView.size.height,
                         contentMode: .fit)
            .overlay {
                GeometryReader { geo in
                    let scale = geo.size.width / ShareCardView.size.width
                    ShareCardView(content: content, style: style,
                                  includeTranslation: includeTranslation && hasTranslation)
                        .scaleEffect(scale, anchor: .topLeading)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var styles: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.two) {
                ForEach(ShareCardStyle.all) { option in
                    Button {
                        withAnimation(.easeOut(duration: 0.18)) { styleID = option.id }
                    } label: {
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .fill(LinearGradient(colors: option.backdrop,
                                                     startPoint: .topLeading,
                                                     endPoint: .bottomTrailing))
                                .frame(width: 46, height: 46)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .stroke(option.id == styleID ? Palette.primary : .clear,
                                                lineWidth: 2)
                                )
                            Text(loc.t(option.titleKey))
                                .font(.caption2.weight(option.id == styleID ? .bold : .regular))
                                .foregroundStyle(option.id == styleID ? Palette.primary : Palette.textSecondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private var actions: some View {
        VStack(spacing: Spacing.two) {
            Button { share() } label: {
                Label(loc.t("share.action"), systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.two)
            }
            .buttonStyle(.borderedProminent)
            .tint(Palette.primary)

            Button { copyText() } label: {
                Label(loc.t(didCopy ? "share.copied" : "share.copyText"),
                      systemImage: didCopy ? "checkmark" : "doc.on.doc")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.one)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Actions

    /// Shares the image *and* the App Store URL. Messaging apps attach both, so the
    /// recipient gets something tappable; apps that take only the image still carry
    /// the printed link in the watermark.
    private func share() {
        guard let image = ShareCardRenderer.image(
            content: content, style: style,
            includeTranslation: includeTranslation && hasTranslation
        ) else {
            shareText()
            return
        }
#if os(iOS)
        payload = SharePayload(items: [image, AppLink.url])
#else
        presentPicker([image, AppLink.url])
#endif
    }

    private func shareText() {
#if os(iOS)
        payload = SharePayload(items: [content.plainText(footer: loc.t("share.footer")),
                                       AppLink.url])
#else
        presentPicker([content.plainText(footer: loc.t("share.footer")), AppLink.url])
#endif
    }

#if os(macOS)
    /// Presents the AppKit sharing picker anchored to the current window.
    private func presentPicker(_ items: [Any]) {
        guard let window = NSApp.keyWindow else { return }
        let picker = NSSharingServicePicker(items: items)
        picker.show(relativeTo: NSRect(x: window.frame.midX, y: window.frame.midY, width: 1, height: 1),
                    of: window.contentView!, preferredEdge: .minY)
    }
#endif

    private func copyText() {
        let text = content.plainText(footer: loc.t("share.footer"))
#if os(iOS)
        UIPasteboard.general.string = text
#else
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
#endif
        withAnimation { didCopy = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { didCopy = false }
        }
    }
}

/// Wrapper so `.sheet(item:)` can carry a heterogeneous activity payload.
private struct SharePayload: Identifiable {
    let id = UUID()
    let items: [Any]
}

#if os(iOS)
/// `ShareLink` only carries one kind of item; sharing an image together with a URL
/// needs the UIKit sheet.
private struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // Neither makes sense for a verse card, and "Assign to Contact" drags the
        // contacts permission into an app that otherwise never touches them.
        controller.excludedActivityTypes = [.assignToContact, .addToReadingList]
        return controller
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
#endif

// MARK: - Entry point

extension View {
    /// Attaches the share sheet to a screen. `content` is nil when nothing is being
    /// shared, which is also what dismissing sets it back to.
    func shareCardSheet(_ content: Binding<ShareCardContent?>) -> some View {
        sheet(isPresented: Binding(
            get: { content.wrappedValue != nil },
            set: { if !$0 { content.wrappedValue = nil } }
        )) {
            if let value = content.wrappedValue {
                ShareCardSheet(content: value)
            }
        }
    }
}
