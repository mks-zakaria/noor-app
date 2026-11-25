import ActivityKit
import SwiftUI
import WidgetKit

/// Lock Screen and Dynamic Island countdown started by the app.
struct PrayerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PrayerActivityAttributes.self) { context in
            PrayerActivityLockView(state: context.state, place: context.attributes.place)
                .activityBackgroundTint(.noorDeep)
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let s = context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(s.title, systemImage: s.symbol)
                        .font(.headline)
                        .foregroundStyle(Color.noorGold)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(s.time).font(.headline).foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(timerInterval: s.start...max(s.start.addingTimeInterval(1), s.target), countsDown: false) {
                        EmptyView()
                    } currentValueLabel: {
                        EmptyView()
                    }
                    .tint(Color.noorGold)
                    HStack {
                        Text(s.subtitle).font(amiri(16)).foregroundStyle(.white.opacity(0.8))
                        Spacer()
                        Countdown(from: Date(), to: s.target)
                            .font(.title3.weight(.semibold).monospacedDigit())
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.trailing)
                    }
                }
            } compactLeading: {
                Image(systemName: s.symbol).foregroundStyle(Color.noorGold)
            } compactTrailing: {
                Text(timerInterval: Date()...max(Date(), s.target), countsDown: true)
                    .monospacedDigit()
                    .frame(maxWidth: 56)
                    .foregroundStyle(.white)
            } minimal: {
                Image(systemName: s.symbol).foregroundStyle(Color.noorGold)
            }
        }
    }
}

/// The Lock Screen banner of the Live Activity (also rendered for store screenshots).
struct PrayerActivityLockView: View {
    let state: PrayerActivityAttributes.ContentState
    let place: String
    @Environment(\.frozenNow) private var frozen

    var body: some View {
        let s = state
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(s.title, systemImage: s.symbol)
                    .font(.headline)
                    .foregroundStyle(Color.noorGold)
                if !s.subtitle.isEmpty {
                    Text(s.subtitle).font(amiri(16)).foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Text(s.time).font(.headline).foregroundStyle(.white)
            }
            HStack(alignment: .firstTextBaseline) {
                Text(s.lead).font(.subheadline).foregroundStyle(.white.opacity(0.75))
                Countdown(from: Date(), to: s.target)
                    .font(.system(size: 30, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundStyle(.white)
                Spacer()
                if !place.isEmpty {
                    Text(place).font(.caption).foregroundStyle(.white.opacity(0.7)).lineLimit(1)
                }
            }
            if let frozen {
                let fraction = min(1, max(0, frozen.timeIntervalSince(s.start) / max(60, s.target.timeIntervalSince(s.start))))
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.2))
                        Capsule().fill(Color.noorGold).frame(width: g.size.width * fraction)
                    }
                }
                .frame(height: 5)
            } else {
                ProgressView(timerInterval: s.start...max(s.start.addingTimeInterval(1), s.target), countsDown: false) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
                .tint(Color.noorGold)
            }
        }
        .padding(16)
    }
}
