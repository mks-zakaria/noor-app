import SwiftUI
import WidgetKit

// Palette mirrors the app's Theme values so the widget reads as Noor at a glance.
extension Color {
    static let noorGreen = Color(red: 0x0E / 255, green: 0x7A / 255, blue: 0x5F / 255)
    static let noorDeep = Color(red: 0x06 / 255, green: 0x33 / 255, blue: 0x28 / 255)
    static let noorGold = Color(red: 0xE9 / 255, green: 0xC9 / 255, blue: 0x7A / 255)
}

func amiri(_ size: CGFloat, bold: Bool = false) -> Font {
    .custom(bold ? "Amiri-Bold" : "Amiri-Regular", size: size)
}

func serif(_ size: CGFloat) -> Font {
    .system(size: size, design: .serif)
}

/// The widget speaks the language the user chose in the app, not the device
/// language — the two can legitimately differ and the paused copy should
/// never feel foreign.
private func appLanguageCode() -> String {
    let defs = UserDefaults(suiteName: WidgetContract.suiteName)
    return defs?.string(forKey: WidgetContract.Keys.language) ?? "en"
}

private func pausedCopy() -> String {
    switch appLanguageCode() {
    case "fr": return "Versets en pause dans Noor"
    case "ar": return "الآيات متوقفة في نور"
    default: return "Verses paused in Noor"
    }
}

struct VerseEntry: TimelineEntry {
    let date: Date
    let verse: Verse
    let prefs: WidgetPreferences
}

struct VerseProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(date: Date(), verse: VerseStore.placeholder, prefs: WidgetPreferences.load())
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        completion(
            VerseEntry(
                date: Date(),
                verse: context.isPreview ? VerseStore.random(for: Date()) : VerseStore.placeholder,
                prefs: WidgetPreferences.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        // Anchored to the current time, NOT the start of day: every entry must
        // be dated around *now* or WidgetKit serves the last past-dated entry
        // forever and the verse appears frozen.
        let interval = 300.0   // 5 minutes — WidgetKit's practical floor
        let now = Date().timeIntervalSince1970
        let anchor = Date(timeIntervalSince1970: (now / interval).rounded(.down) * interval)
        var entries: [VerseEntry] = []
        // Twelve hours of precomputed entries, each rotating deterministically
        // through the verse set.
        for i in 0...144 {
            entries.append(
                VerseEntry(date: anchor.addingTimeInterval(interval * TimeInterval(i)),
                           verse: VerseStore.random(for: anchor.addingTimeInterval(interval * TimeInterval(i))),
                           prefs: WidgetPreferences.load()))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

private struct HomeBackdrop: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.noorDeep, .noorGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [Color.noorGold.opacity(0.28), .clear],
                center: .init(x: 1.05, y: -0.05),
                startRadius: 8,
                endRadius: 190
            )
            Text("\u{FD3F}")
                .font(amiri(150))
                .foregroundStyle(Color.white.opacity(0.06))
                .offset(x: -18, y: 46)
        }
    }
}

private struct Ornament: View {
    var body: some View {
        HStack(spacing: 7) {
            Capsule().fill(Color.noorGold.opacity(0.85)).frame(width: 26, height: 1)
            Text("\u{FD3E}")
                .font(amiri(13))
                .foregroundStyle(Color.noorGold)
            Capsule().fill(Color.noorGold.opacity(0.85)).frame(width: 26, height: 1)
        }
    }
}

struct VerseWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: VerseEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            RectangularContent(verse: entry.verse, prefs: entry.prefs)
                .containerBackground(for: .widget) { Color.clear }
        default:
            MediumContent(verse: entry.verse, prefs: entry.prefs)
                .containerBackground(for: .widget) { HomeBackdrop() }
        }
    }
}

private struct PausedHint: View {
    var compact = false

    var body: some View {
        VStack(spacing: compact ? 2 : 4) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: compact ? 13 : 15, weight: .medium))
                .opacity(0.8)
            Text(pausedCopy())
                .font(serif(compact ? 10 : 11).italic())
                .opacity(0.75)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Home-screen widget: spans all four columns. Centered composition —
/// Arabic calligraphy carries the design, translation breathes beneath it,
/// reference anchors the bottom edge.
private struct MediumContent: View {
    let verse: Verse
    let prefs: WidgetPreferences

    var body: some View {
        Group {
            if !prefs.enabled {
                PausedHint().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    Spacer(minLength: 4)
                    if prefs.display.showsArabic {
                        Text(verse.arabic)
                            .font(amiri(prefs.display == .arabic ? 37 : 33))
                            .lineSpacing(7)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.55)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                    }
                    Ornament()
                        .padding(.vertical, prefs.display == .both ? 9 : 12)
                    if prefs.display.showsEnglish {
                        Text("“\(verse.english)”")
                            .font(serif(15).italic())
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
                            .font(serif(11).weight(.semibold))
                            .tracking(1)
                    }
                    .foregroundStyle(Color.noorGold)
                }
            }
        }
    }
}

/// Lock-screen widget: one half-width slot below the clock (iOS caps all apps
/// there). Same centered composition as the home-screen version, scaled down;
/// the lock screen renders it in vibrant mode so opacity carries hierarchy.
private struct RectangularContent: View {
    let verse: Verse
    let prefs: WidgetPreferences

    var body: some View {
        if !prefs.enabled {
            PausedHint(compact: true).frame(maxHeight: .infinity)
        } else {
            VStack(spacing: 3) {
                if prefs.display.showsArabic {
                    Text(verse.arabic)
                        .font(amiri(prefs.display == .arabic ? 29 : 26))
                        .lineSpacing(3)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity)
                }
                if prefs.display.showsEnglish {
                    Text("“\(prefs.display == .english ? verse.english : verse.shortEnglish)”")
                        .font(serif(13.5).italic())
                        .opacity(0.88)
                        .multilineTextAlignment(.center)
                        .lineLimit(prefs.display == .english ? 2 : 1)
                        .minimumScaleFactor(0.72)
                }
                Spacer(minLength: 0)
                HStack(spacing: 4) {
                    Text(verse.name)
                        .font(serif(11.5).weight(.semibold))
                        .opacity(0.72)
                        .lineLimit(1)
                    Text("·")
                        .opacity(0.5)
                    Text("\(verse.surah):\(verse.ayah)")
                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                        .opacity(0.72)
                }
            }
        }
    }
}

struct VerseWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "NoorVerseWidget", provider: VerseProvider()) { entry in
            VerseWidgetView(entry: entry)
        }
        .configurationDisplayName("Noor Verses")
        .description("An uplifting Quranic verse that keeps rotating through your day.")
        .supportedFamilies([.systemMedium, .accessoryRectangular])
    }
}
