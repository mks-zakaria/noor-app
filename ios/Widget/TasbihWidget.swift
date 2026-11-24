import AppIntents
import SwiftUI
import WidgetKit

// Count dhikr without opening the app: an interactive Home Screen widget and a
// Control Center / Lock Screen / Action Button control. Both run
// CountDhikrIntent, which writes the shared TasbihState in the App Group.

struct TasbihEntry: TimelineEntry {
    let date: Date
    let state: TasbihState
}

struct TasbihProvider: TimelineProvider {
    func placeholder(in context: Context) -> TasbihEntry { TasbihEntry(date: Date(), state: TasbihState()) }
    func getSnapshot(in context: Context, completion: @escaping (TasbihEntry) -> Void) {
        completion(TasbihEntry(date: Date(), state: TasbihState.load()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<TasbihEntry>) -> Void) {
        // Redrawn by the intent after every tap; refresh at midnight for "today".
        let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86_400))
        completion(Timeline(entries: [TasbihEntry(date: Date(), state: TasbihState.load())], policy: .after(midnight)))
    }
}

struct TasbihWidgetView: View {
    let entry: TasbihEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular: lockCircular
        case .accessoryRectangular: lockRectangular
        default: homeSmall
        }
    }

    private var progress: Double {
        let t = entry.state.preset.target
        return t > 0 ? min(1, Double(entry.state.count) / Double(t)) : 0
    }

    /// Lock Screen, round: ring = progress to the target, the count inside. Tap counts +1.
    private var lockCircular: some View {
        Button(intent: CountDhikrIntent()) {
            ZStack {
                AccessoryWidgetBackground()
                Circle().stroke(.secondary.opacity(0.35), lineWidth: 4).padding(3)
                Circle().trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90)).padding(3)
                VStack(spacing: 0) {
                    Text("\(entry.state.count)")
                        .font(.system(size: 20, weight: .bold, design: .rounded).monospacedDigit())
                        .contentTransition(.numericText())
                        .minimumScaleFactor(0.6)
                    Text(entry.state.preset.target > 0 ? "/\(entry.state.preset.target)" : "∞")
                        .font(.system(size: 9, weight: .semibold)).opacity(0.8)
                }
            }
        }
        .buttonStyle(.plain)
        .widgetAccentable()
        .containerBackground(for: .widget) { Color.clear }
    }

    /// Lock Screen, wide: the dhikr, the count against its target and a bar. Tap counts +1.
    private var lockRectangular: some View {
        let p = entry.state.preset
        return Button(intent: CountDhikrIntent()) {
            VStack(alignment: .leading, spacing: 2) {
                Text(p.arabic)
                    .font(amiri(15, bold: true))
                    .lineLimit(1).minimumScaleFactor(0.6)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(entry.state.count)")
                        .font(.system(size: 22, weight: .bold, design: .rounded).monospacedDigit())
                        .contentTransition(.numericText())
                    Text(p.target > 0 ? "/ \(p.target)" : "")
                        .font(.caption.weight(.semibold)).opacity(0.75)
                    Spacer(minLength: 0)
                    Image(systemName: "hand.tap.fill").font(.caption)
                }
                if p.target > 0 {
                    ProgressView(value: progress).tint(.primary)
                }
            }
        }
        .buttonStyle(.plain)
        .widgetAccentable()
        .containerBackground(for: .widget) { Color.clear }
    }

    private var homeSmall: some View {
        let p = entry.state.preset
        return Button(intent: CountDhikrIntent()) {
            VStack(spacing: 6) {
                Text(p.arabic)
                    .font(amiri(18, bold: true))
                    .foregroundStyle(Color.noorGold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text("\(entry.state.count)")
                    .font(.system(size: 40, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                Text(p.target > 0 ? "/ \(p.target)" : "∞")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .containerBackground(for: .widget) {
            LinearGradient(colors: [.noorDeep, .noorGreen], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct TasbihWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: TasbihKinds.widget, provider: TasbihProvider()) { entry in
            TasbihWidgetView(entry: entry)
        }
        .configurationDisplayName(Strings.t("widget.tasbihName", widgetLanguage()))
        .description(Strings.t("widget.tasbihDesc", widgetLanguage()))
        // Home Screen, and the Lock Screen widget area (iOS 17+ runs the button's intent from there too).
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
    }
}

struct TasbihControlValue: ControlValueProvider {
    var previewValue: Int { 33 }
    func currentValue() async throws -> Int { TasbihState.load().count }
}

struct TasbihControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: TasbihKinds.control, provider: TasbihControlValue()) { count in
            ControlWidgetButton(action: CountDhikrIntent()) {
                Label("\(count)", systemImage: "circle.dotted.circle")
            }
        }
        .displayName("Tasbih")
        .description("Count dhikr with Noor.")
    }
}
