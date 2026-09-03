import SwiftUI
import WidgetKit

// macOS widget. Reuses the shared Verse data + WidgetPreferences contract, but
// ships its own configuration: macOS supports systemSmall/Medium/Large but NOT
// the lock-screen accessory families, so we offer a medium (with small/large)
// instead of the iOS widget's medium + accessoryRectangular combo.

extension Color {
    static let noorGreenMac = Color(red: 0x0E / 255, green: 0x7A / 255, blue: 0x5F / 255)
    static let noorDeepMac = Color(red: 0x06 / 255, green: 0x33 / 255, blue: 0x28 / 255)
    static let noorGoldMac = Color(red: 0xE9 / 255, green: 0xC9 / 255, blue: 0x7A / 255)
}

private func amiriMac(_ size: CGFloat, bold: Bool = false) -> Font {
    .custom(bold ? "Amiri-Bold" : "Amiri-Regular", size: size)
}

private func serifMac(_ size: CGFloat) -> Font {
    .system(size: size, design: .serif)
}

private func appLanguageCodeMac() -> String {
    UserDefaults(suiteName: WidgetContract.suiteName)?.string(forKey: WidgetContract.Keys.language) ?? "en"
}

private func pausedCopyMac() -> String {
    switch appLanguageCodeMac() {
    case "fr": return "Versets en pause dans Noor"
    case "ar": return "الآيات متوقفة في نور"
    default: return "Verses paused in Noor"
    }
}

struct VerseEntryMac: TimelineEntry {
    let date: Date
    let verse: Verse
    let prefs: WidgetPreferences
}

struct VerseProviderMac: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntryMac {
        VerseEntryMac(date: Date(), verse: VerseStore.placeholder, prefs: WidgetPreferences.load())
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntryMac) -> Void) {
        completion(
            VerseEntryMac(
                date: Date(),
                verse: context.isPreview ? VerseStore.random(for: Date()) : VerseStore.placeholder,
                prefs: WidgetPreferences.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntryMac>) -> Void) {
        let interval = 300.0
        let now = Date().timeIntervalSince1970
        let anchor = Date(timeIntervalSince1970: (now / interval).rounded(.down) * interval)
        var entries: [VerseEntryMac] = []
        for i in 0...144 {
            entries.append(
                VerseEntryMac(
                    date: anchor.addingTimeInterval(interval * TimeInterval(i)),
                    verse: VerseStore.random(for: anchor.addingTimeInterval(interval * TimeInterval(i))),
                    prefs: WidgetPreferences.load()))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

private struct BackdropMac: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.noorDeepMac, .noorGreenMac],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [Color.noorGoldMac.opacity(0.28), .clear],
                center: .init(x: 1.05, y: -0.05),
                startRadius: 8,
                endRadius: 190
            )
            Text("\u{FD3F}")
                .font(amiriMac(150))
                .foregroundStyle(Color.white.opacity(0.06))
                .offset(x: -18, y: 46)
        }
    }
}

private struct OrnamentMac: View {
    var body: some View {
        HStack(spacing: 7) {
            Capsule().fill(Color.noorGoldMac.opacity(0.85)).frame(width: 26, height: 1)
            Text("\u{FD3E}")
                .font(amiriMac(13))
                .foregroundStyle(Color.noorGoldMac)
            Capsule().fill(Color.noorGoldMac.opacity(0.85)).frame(width: 26, height: 1)
        }
    }
}

struct VerseWidgetViewMac: View {
    @Environment(\.widgetFamily) private var family
    let entry: VerseEntryMac

    var body: some View {
        MediumContentMac(verse: entry.verse, prefs: entry.prefs)
            .containerBackground(for: .widget) { BackdropMac() }
    }
}

private struct PausedHintMac: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 15, weight: .medium))
                .opacity(0.8)
            Text(pausedCopyMac())
                .font(serifMac(11).italic())
                .opacity(0.75)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MediumContentMac: View {
    let verse: Verse
    let prefs: WidgetPreferences

    var body: some View {
        Group {
            if !prefs.enabled {
                PausedHintMac().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    Spacer(minLength: 4)
                    if prefs.display.showsArabic {
                        Text(verse.arabic)
                            .font(amiriMac(prefs.display == .arabic ? 34 : 30))
                            .lineSpacing(7)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.55)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                    }
                    OrnamentMac()
                        .padding(.vertical, prefs.display == .both ? 9 : 12)
                    if prefs.display.showsEnglish {
                        Text("“\(verse.english)”")
                            .font(serifMac(14).italic())
                            .foregroundStyle(.white.opacity(0.93))
                            .multilineTextAlignment(.center)
                            .lineLimit(prefs.display == .english ? 3 : 2)
                            .minimumScaleFactor(0.72)
                            .padding(.horizontal, 18)
                    }
                    Spacer(minLength: 4)
                    HStack(spacing: 5) {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 10.5))
                        Text(verse.reference.uppercased())
                            .font(serifMac(11).weight(.semibold))
                            .tracking(1)
                    }
                    .foregroundStyle(Color.noorGoldMac)
                }
            }
        }
    }
}

struct VerseWidgetMacOS: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "NoorVerseWidgetMacOS", provider: VerseProviderMac()) { entry in
            VerseWidgetViewMac(entry: entry)
        }
        .configurationDisplayName("Noor Verses")
        .description("An uplifting Quranic verse that keeps rotating through your day.")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}
