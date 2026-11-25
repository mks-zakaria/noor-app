import SwiftUI
import WidgetKit

/// Full-screen tasbih counter. The count lives in the App Group, so the
/// home-screen widget, the Control Center control and the Action Button all
/// add to the same number.
struct TasbihView: View {
    @Environment(LocalizationManager.self) private var loc
    @Environment(\.scenePhase) private var scenePhase
    @State private var state = TasbihState.load()
    @State private var tick = 0
    @State private var roundDone = 0
    @State private var showPresets = false

    private var preset: TasbihPreset { state.preset }

    var body: some View {
        VStack(spacing: Spacing.three) {
            presetHeader
            Spacer(minLength: 0)
            counter
            Spacer(minLength: 0)
            stats
            controlsHint
        }
        .padding(Spacing.three)
        .frame(maxWidth: 700)
        .frame(maxWidth: .infinity)
        .noorBackground()
        .navigationTitle(loc.t("tasbih.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    state.reset()
                    state.save()
                    reloadTasbihSurfaces()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .accessibilityLabel(loc.t("tasbih.reset"))
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: tick)
        .sensoryFeedback(.success, trigger: roundDone)
        .sheet(isPresented: $showPresets) { presetPicker }
        // The widget or control may have counted while this screen was away.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { state = TasbihState.load() }
        }
        .onAppear { state = TasbihState.load() }
    }

    private var presetHeader: some View {
        Button { showPresets = true } label: {
            Card {
                HStack(spacing: Spacing.three) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(preset.arabic)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Palette.primary)
                        if loc.code != "ar" {
                            Text("\(preset.translit) · \(preset.meaning(loc.code))")
                                .font(.caption)
                                .foregroundStyle(Palette.textSecondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(Palette.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(loc.t("tasbih.choose"))
    }

    /// The whole circle is the button: a big target that works without looking.
    private var counter: some View {
        Button(action: count) {
            ZStack {
                Circle()
                    .stroke(Palette.primarySoft, lineWidth: 14)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Palette.primary, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.15), value: state.count)
                VStack(spacing: Spacing.one) {
                    Text("\(state.count)")
                        .font(.system(size: 76, weight: .bold, design: .rounded).monospacedDigit())
                        .foregroundStyle(Palette.text)
                        .contentTransition(.numericText())
                    Text(preset.target > 0 ? "/ \(preset.target)" : loc.t("tasbih.free"))
                        .font(.headline)
                        .foregroundStyle(Palette.textSecondary)
                    Text(loc.t("tasbih.tap"))
                        .font(.caption)
                        .foregroundStyle(Palette.textSecondary)
                        .padding(.top, Spacing.two)
                }
            }
            .frame(maxWidth: 300, maxHeight: 300)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(loc.t("tasbih.count"))
        .accessibilityIdentifier("tasbih.counter")
        .accessibilityValue("\(state.count)")
    }

    private var stats: some View {
        HStack(spacing: Spacing.three) {
            stat(loc.t("tasbih.today"), state.todayTotal)
            stat(loc.t("tasbih.rounds"), state.roundsToday)
            stat(loc.t("tasbih.lifetime"), state.lifetime)
        }
    }

    private func stat(_ label: String, _ value: Int) -> some View {
        Card(padding: Spacing.two) {
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(Palette.primary)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(Palette.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
    }

    #if os(iOS)
    private var controlsHint: some View {
        Label(loc.t("tasbih.controlsHint"), systemImage: "switch.2")
            .font(.footnote)
            .foregroundStyle(Palette.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    #else
    private var controlsHint: some View { EmptyView() }
    #endif

    private var presetPicker: some View {
        NavigationStack {
            List(TasbihPreset.all) { p in
                Button {
                    state.select(p.id)
                    state.save()
                    reloadTasbihSurfaces()
                    showPresets = false
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(p.arabic)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Palette.text)
                            if loc.code != "ar" {
                                Text(p.meaning(loc.code))
                                    .font(.caption)
                                    .foregroundStyle(Palette.textSecondary)
                            }
                            if !p.reference.isEmpty {
                                Text(p.reference)
                                    .font(.caption2)
                                    .foregroundStyle(Palette.textSecondary)
                            }
                        }
                        Spacer()
                        Text(p.target > 0 ? "\(p.target)×" : "∞")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(Palette.primary)
                        if p.id == state.presetID {
                            Image(systemName: "checkmark").foregroundStyle(Palette.primary)
                        }
                    }
                }
                .listRowBackground(Palette.card)
            }
            .scrollContentBackground(.hidden)
            .noorBackground()
            .navigationTitle(loc.t("tasbih.choose"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(loc.t("common.done")) { showPresets = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var progress: Double {
        guard preset.target > 0 else { return 0 }
        return min(1, Double(state.count) / Double(preset.target))
    }

    private func count() {
        // Re-read first: the control may have counted since this screen loaded.
        var s = TasbihState.load()
        let completed = s.increment()
        s.save()
        withAnimation(.snappy(duration: 0.15)) { state = s }
        tick += 1
        if completed { roundDone += 1 }
        reloadTasbihSurfaces()
    }
}
