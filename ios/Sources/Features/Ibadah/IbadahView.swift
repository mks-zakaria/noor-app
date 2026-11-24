import SwiftUI

/// The worship tab: today's prayers, streak and week, Qada balance, and the
/// tools you come back to daily (Khatmah, Tasbih, Ramadan, Wird).
struct IbadahView: View {
    @Environment(PrayerLogStore.self) private var log
    @Environment(KhatmahStore.self) private var khatmah
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.three) {
                    PrayerTrackerCard()
                    weekCard
                    if khatmah.todayRange() != nil { KhatmahTodayCard() }
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.three), GridItem(.flexible())],
                              spacing: Spacing.three) {
                        tool(loc.t("khatmah.title"), "book.closed.fill", Palette.primary) { KhatmahView() }
                        tool(loc.t("tasbih.title"), "circle.dotted.circle", Palette.accent) { TasbihView() }
                        tool(loc.t("ramadan.title"), "moon.stars.fill", Palette.accent) { RamadanView() }
                        tool(loc.t("wird.title"), "checklist", Palette.primary) { WirdView() }
                    }
                    qadaCard
                }
                .padding(Spacing.three)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .noorBackground()
            .navigationTitle(loc.t("tab.ibadah"))
        }
    }

    // MARK: Week and streak

    private var weekCard: some View {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let days = (0..<7).compactMap { cal.date(byAdding: .day, value: $0 - 6, to: today) }
        let streak = log.streak()
        return Card {
            VStack(alignment: .leading, spacing: Spacing.three) {
                HStack {
                    Label(String(format: loc.t("tracker.streak"), streak), systemImage: "flame.fill")
                        .font(.headline)
                        .foregroundStyle(streak > 0 ? Palette.accent : Palette.textSecondary)
                    Spacer()
                    Text(loc.t("tracker.last7"))
                        .font(.caption)
                        .foregroundStyle(Palette.textSecondary)
                }
                HStack(spacing: Spacing.two) {
                    ForEach(days, id: \.self) { day in
                        let n = log.prayedCount(on: day)
                        VStack(spacing: Spacing.one) {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(n == 0 ? Palette.background : Palette.primary.opacity(0.25 + 0.15 * Double(n)))
                                .overlay(
                                    Text("\(n)")
                                        .font(.caption.weight(.bold).monospacedDigit())
                                        .foregroundStyle(n >= 3 ? .white : Palette.textSecondary)
                                )
                                .frame(height: 34)
                            Text(day.formatted(.dateTime.weekday(.narrow).locale(loc.locale)))
                                .font(.caption2)
                                .foregroundStyle(cal.isDateInToday(day) ? Palette.primary : Palette.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(day.formatted(.dateTime.weekday(.wide).locale(loc.locale))): \(n)/5")
                    }
                }
            }
        }
    }

    // MARK: Qada

    private var qadaCard: some View {
        NavigationLink { QadaView() } label: {
            Card {
                HStack(spacing: Spacing.three) {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Palette.primary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.t("qada.title"))
                            .font(.headline)
                            .foregroundStyle(Palette.text)
                        Text(String(format: loc.t("qada.summary"), log.qadaTotal, log.qadaFasts))
                            .font(.subheadline)
                            .foregroundStyle(Palette.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(Palette.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func tool<Dest: View>(_ title: String, _ icon: String, _ tint: Color,
                                  @ViewBuilder destination: @escaping () -> Dest) -> some View {
        NavigationLink(destination: destination) {
            Card {
                VStack(alignment: .leading, spacing: Spacing.two) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(tint)
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Palette.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("tool.\(icon)")
    }
}

/// Today's five prayers with one-tap logging; long-press (or the menu) for late / missed.
struct PrayerTrackerCard: View {
    @Environment(PrayerLogStore.self) private var log
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        Card(padding: Spacing.two) {
            VStack(spacing: 0) {
                HStack {
                    Text(loc.t("tracker.today"))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Spacer()
                    Text("\(log.prayedCount(on: Date()))/5")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(Palette.primary)
                }
                .padding(Spacing.two)
                ForEach(PrayerLogStore.fivePrayers) { p in
                    Divider().overlay(Palette.border)
                    row(p)
                }
                Text(loc.t("tracker.hint"))
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.two)
            }
        }
    }

    private func row(_ p: PrayerName) -> some View {
        let status = log.status(p)
        return HStack(spacing: Spacing.three) {
            Image(systemName: p.systemImage)
                .foregroundStyle(Palette.textSecondary)
                .frame(width: 26)
            Text(p.label(loc.code))
                .foregroundStyle(Palette.text)
            Spacer()
            if let status {
                Text(loc.t("tracker.\(status.rawValue)"))
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
            }
            PrayerCheckButton(prayer: p)
        }
        .padding(.vertical, Spacing.one)
        .padding(.horizontal, Spacing.two)
    }
}

/// The check circle used on Home and in the tracker. Tap = prayed on time;
/// the context menu offers late, missed and clear.
struct PrayerCheckButton: View {
    let prayer: PrayerName

    @Environment(PrayerLogStore.self) private var log
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        let status = log.status(prayer)
        Button {
            log.toggle(prayer)
        } label: {
            Image(systemName: status?.systemImage ?? "circle")
                .font(.title3)
                .foregroundStyle(color(status))
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: status)
        .contextMenu {
            ForEach(PrayerStatus.allCases, id: \.self) { s in
                Button { log.set(s, prayer) } label: {
                    Label(loc.t("tracker.\(s.rawValue)"), systemImage: s.systemImage)
                }
            }
            Button(role: .destructive) { log.set(nil, prayer) } label: {
                Label(loc.t("tracker.clear"), systemImage: "circle")
            }
        }
        .accessibilityLabel("\(prayer.label(loc.code)): \(status.map { loc.t("tracker.\($0.rawValue)") } ?? loc.t("tracker.notLogged"))")
    }

    private func color(_ s: PrayerStatus?) -> Color {
        switch s {
        case .onTime: return Palette.primary
        case .late: return Palette.accent
        case .missed: return Palette.danger
        case nil: return Palette.textSecondary
        }
    }
}

/// Make-up prayers and fasts still owed, adjusted by hand or by the trackers.
struct QadaView: View {
    @Environment(PrayerLogStore.self) private var log
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        Form {
            Section {
                ForEach(PrayerLogStore.fivePrayers) { p in
                    HStack {
                        Label(p.label(loc.code), systemImage: p.systemImage)
                        Spacer()
                        Text("\(log.qada(p))")
                            .font(.body.monospacedDigit().weight(.semibold))
                            .foregroundStyle(Palette.primary)
                            .frame(minWidth: 36)
                        Stepper("", onIncrement: { log.adjustQada(p, by: 1) },
                                onDecrement: { log.adjustQada(p, by: -1) })
                            .labelsHidden()
                    }
                }
            } header: {
                Text(loc.t("qada.prayers"))
            } footer: {
                Text(loc.t("qada.prayersFooter"))
            }
            Section {
                HStack {
                    Label(loc.t("qada.fasts"), systemImage: "moon.fill")
                    Spacer()
                    Text("\(log.qadaFasts)")
                        .font(.body.monospacedDigit().weight(.semibold))
                        .foregroundStyle(Palette.primary)
                        .frame(minWidth: 36)
                    Stepper("", onIncrement: { log.adjustQadaFasts(by: 1) },
                            onDecrement: { log.adjustQadaFasts(by: -1) })
                        .labelsHidden()
                }
            } footer: {
                Text(loc.t("qada.fastsFooter"))
            }
        }
        .scrollContentBackground(.hidden)
        .noorBackground()
        .navigationTitle(loc.t("qada.title"))
    }
}
