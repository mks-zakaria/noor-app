import SwiftUI

/// Everything for the month of fasting: suhoor/iftar countdown, the 30-day
/// timetable, a fasting and Taraweeh log, Laylat al-Qadr, du'as and a Ramadan
/// khatmah. Reachable all year: before Ramadan it counts down and shows the
/// coming timetable; in Shawwal it tracks the six fasts.
struct RamadanView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(LocationManager.self) private var location
    @Environment(RamadanStore.self) private var store
    @Environment(KhatmahStore.self) private var khatmah
    @Environment(LocalizationManager.self) private var loc
    @State private var sharing: ShareCardContent?

    private var phase: RamadanPhase { RamadanService.phase(offset: settings.hijriOffset) }
    private var info: RamadanInfo? { RamadanService.currentOrNext(offset: settings.hijriOffset) }

    private var coordinate: (lat: Double, lng: Double)? {
        location.coordinate.map { ($0.latitude, $0.longitude) }
    }

    private var timetable: [RamadanDay] {
        guard let info, let c = coordinate else { return [] }
        return RamadanService.timetable(info, lat: c.lat, lng: c.lng, method: settings.method,
                                        madhab: settings.madhab, imsakMinutes: settings.imsakMinutes)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.three) {
                RamadanHeroCard(showsLink: false)
                if case .shawwal = phase, let prev = RamadanService.previous(offset: settings.hijriOffset) {
                    shawwalCard(prev.year)
                }
                if let info {
                    if case .during = phase { fastingTracker(info) }
                    khatmahCard(info)
                    if case .during(let day) = phase, day >= 20 { qadrCard(info, today: day) }
                }
                duas
                timetableCard
                settingsLink
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .noorBackground()
        .navigationTitle(loc.t("ramadan.title"))
        .shareCardSheet($sharing)
    }

    // MARK: Fasting & Taraweeh

    private func fastingTracker(_ info: RamadanInfo) -> some View {
        let today = info.day(of: Date()) ?? info.days
        return Card {
            VStack(alignment: .leading, spacing: Spacing.three) {
                HStack {
                    Text(loc.t("ramadan.fasts"))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Spacer()
                    Text("\(store.fastedCount(year: info.year))/\(info.days)")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(Palette.primary)
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 6), spacing: 6) {
                    ForEach(1...info.days, id: \.self) { day in
                        let status = store.fast(year: info.year, day: day)
                        Button {
                            store.cycleFast(year: info.year, day: day)
                        } label: {
                            VStack(spacing: 2) {
                                Text("\(day)")
                                    .font(.caption.weight(.semibold).monospacedDigit())
                                Image(systemName: status?.systemImage ?? "circle")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundStyle(color(for: status))
                            .background(day == today ? Palette.backgroundSelected : Palette.background)
                            .clipShape(RoundedRectangle(cornerRadius: Radius.sm, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .disabled(day > today)
                        .opacity(day > today ? 0.4 : 1)
                        .accessibilityLabel("\(loc.t("ramadan.day")) \(day)")
                        .accessibilityValue(status.map { loc.t("fast.\($0.rawValue)") } ?? "")
                    }
                }
                Text(loc.t("ramadan.fastsHint"))
                    .font(.caption)
                    .foregroundStyle(Palette.textSecondary)
                Divider().overlay(Palette.border)
                // Taraweeh of tonight: the night of day N is prayed on the evening before it.
                Button {
                    store.toggleTaraweeh(year: info.year, night: today)
                } label: {
                    HStack {
                        Image(systemName: store.prayedTaraweeh(year: info.year, night: today) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(Palette.primary)
                        Text(loc.t("ramadan.taraweeh"))
                            .foregroundStyle(Palette.text)
                        Spacer()
                        Text("\(store.taraweehCount(year: info.year))/\(info.days)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(Palette.textSecondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func color(for status: FastStatus?) -> Color {
        switch status {
        case .fasted: return Palette.primary
        case .missed: return Palette.danger
        case .excused: return Palette.accent
        case nil: return Palette.textSecondary
        }
    }

    private func shawwalCard(_ year: Int) -> some View {
        let n = store.shawwalFasts(year: year)
        return Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Text(loc.t("ramadan.shawwal"))
                    .font(.headline)
                    .foregroundStyle(Palette.text)
                Text(loc.t("ramadan.shawwalBody"))
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
                HStack(spacing: Spacing.two) {
                    ForEach(1...6, id: \.self) { i in
                        Button {
                            store.setShawwalFasts(n >= i ? i - 1 : i, year: year)
                        } label: {
                            Image(systemName: n >= i ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(Palette.primary)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(i)")
                    }
                }
                Text("Muslim 1164")
                    .font(.caption2)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    // MARK: Khatmah, Qadr, du'as

    @ViewBuilder
    private func khatmahCard(_ info: RamadanInfo) -> some View {
        if khatmah.plan?.kind == "ramadan", khatmah.todayRange() != nil {
            KhatmahTodayCard()
        } else {
            NavigationLink { KhatmahView() } label: {
                Card {
                    HStack(spacing: Spacing.three) {
                        Image(systemName: "book.closed.fill")
                            .font(.title2)
                            .foregroundStyle(Palette.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loc.t("ramadan.khatmah"))
                                .font(.headline)
                                .foregroundStyle(Palette.text)
                            Text(loc.t("ramadan.khatmahBody"))
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
    }

    private func qadrCard(_ info: RamadanInfo, today: Int) -> some View {
        // The odd nights of the last ten begin at maghrib of the day before:
        // night 21 is the evening of day 20.
        let nextOdd = [21, 23, 25, 27, 29].first { $0 > today } ?? 29
        return Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Label(loc.t("ramadan.qadr"), systemImage: "sparkles")
                    .font(.headline)
                    .foregroundStyle(Palette.accent)
                Text(String(format: loc.t("ramadan.qadrBody"), nextOdd))
                    .font(.subheadline)
                    .foregroundStyle(Palette.text)
                Text("al-Bukhari 2017")
                    .font(.caption2)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    private var duas: some View {
        VStack(alignment: .leading, spacing: Spacing.two) {
            SectionHeader(title: loc.t("ramadan.duas"), arabic: loc.code == "ar" ? nil : "أدعية رمضان")
            ForEach(ramadanDuas) { d in
                DuaCard(dhikr: d) { sharing = .dhikr(d, langCode: loc.code) }
            }
        }
    }

    // MARK: Timetable

    @ViewBuilder
    private var timetableCard: some View {
        if let info {
            VStack(alignment: .leading, spacing: Spacing.two) {
                SectionHeader(title: String(format: loc.t("ramadan.timetable"), info.year))
                if timetable.isEmpty {
                    Card {
                        Text(loc.t("ramadan.needsLocation"))
                            .font(.subheadline)
                            .foregroundStyle(Palette.textSecondary)
                    }
                } else {
                    Card(padding: Spacing.two) {
                        VStack(spacing: 0) {
                            timetableRow(day: loc.t("ramadan.day"), date: "", imsak: loc.t("ramadan.imsak"),
                                         fajr: PrayerName.fajr.label(loc.code), maghrib: loc.t("ramadan.iftar"),
                                         header: true, highlighted: false)
                            ForEach(timetable) { row in
                                Divider().overlay(Palette.border)
                                timetableRow(
                                    day: "\(row.day)",
                                    date: row.date.formatted(.dateTime.day().month(.abbreviated).locale(loc.locale)),
                                    imsak: row.imsak.timeString(hour12: settings.hour12),
                                    fajr: row.fajr.timeString(hour12: settings.hour12),
                                    maghrib: row.maghrib.timeString(hour12: settings.hour12),
                                    header: false,
                                    highlighted: Calendar.current.isDateInToday(row.date)
                                )
                            }
                        }
                    }
                    Text(String(format: loc.t("ramadan.timetableFooter"), settings.imsakMinutes))
                        .font(.caption)
                        .foregroundStyle(Palette.textSecondary)
                }
            }
        }
    }

    private func timetableRow(day: String, date: String, imsak: String, fajr: String, maghrib: String,
                              header: Bool, highlighted: Bool) -> some View {
        HStack(spacing: Spacing.two) {
            VStack(alignment: .leading, spacing: 0) {
                Text(day).font(header ? .caption.weight(.semibold) : .subheadline.weight(.semibold).monospacedDigit())
                if !date.isEmpty {
                    Text(date).font(.caption2).foregroundStyle(Palette.textSecondary)
                }
            }
            .frame(width: 58, alignment: .leading)
            Text(imsak).frame(maxWidth: .infinity, alignment: .trailing)
            Text(fajr).frame(maxWidth: .infinity, alignment: .trailing)
            Text(maghrib)
                .fontWeight(header ? .semibold : .bold)
                .foregroundStyle(header ? Palette.textSecondary : Palette.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(header ? .caption.weight(.semibold) : .subheadline.monospacedDigit())
        .foregroundStyle(header ? Palette.textSecondary : Palette.text)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding(.vertical, 6)
        .padding(.horizontal, Spacing.two)
        .background(highlighted ? Palette.backgroundSelected : .clear)
        .clipShape(RoundedRectangle(cornerRadius: Radius.sm, style: .continuous))
    }

    private var settingsLink: some View {
        NavigationLink { SettingsView() } label: {
            Label(loc.t("ramadan.settings"), systemImage: "bell.badge")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

/// The Ramadan card on Home (and the header of the Ramadan screen):
/// a countdown to Ramadan, or the live suhoor / iftar countdown during it.
struct RamadanHeroCard: View {
    var showsLink = true

    @Environment(SettingsStore.self) private var settings
    @Environment(LocationManager.self) private var location
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        if showsLink {
            NavigationLink { RamadanView() } label: { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let now = context.date
            let phase = RamadanService.phase(now: now, offset: settings.hijriOffset)
            let info = RamadanService.currentOrNext(now: now, offset: settings.hijriOffset)
            Card {
                VStack(alignment: .leading, spacing: Spacing.two) {
                    HStack {
                        Label(title(phase, info), systemImage: "moon.stars.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Palette.accent)
                        Spacer()
                        if showsLink {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(Palette.textSecondary)
                        }
                    }
                    detail(phase: phase, info: info, now: now)
                }
            }
        }
    }

    private func title(_ phase: RamadanPhase, _ info: RamadanInfo?) -> String {
        switch phase {
        case .during(let day): return String(format: loc.t("ramadan.dayOf"), day, info?.days ?? 30)
        case .before: return String(format: loc.t("ramadan.titleYear"), info?.year ?? 0)
        case .shawwal: return loc.t("ramadan.shawwal")
        }
    }

    @ViewBuilder
    private func detail(phase: RamadanPhase, info: RamadanInfo?, now: Date) -> some View {
        switch phase {
        case .before(let days):
            Text(days == 0 ? loc.t("ramadan.startsTomorrow") : String(format: loc.t("ramadan.inDays"), days))
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(Palette.primary)
            if let info {
                Text(String(format: loc.t("ramadan.expected"),
                            info.start.formatted(.dateTime.weekday(.wide).day().month(.wide).locale(loc.locale))))
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
            }
        case .during:
            if let info, let c = location.coordinate,
               let event = RamadanService.nextFastingEvent(now: now, info: info, lat: c.latitude, lng: c.longitude,
                                                            method: settings.method, madhab: settings.madhab) {
                HStack(alignment: .firstTextBaseline) {
                    Text(event.isIftar ? loc.t("ramadan.iftarIn") : loc.t("ramadan.suhoorEndsIn"))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Spacer()
                    Text(event.at.timeString(hour12: settings.hour12))
                        .font(.headline)
                        .foregroundStyle(Palette.textSecondary)
                }
                Text(formatCountdown(event.at.timeIntervalSince(now), langCode: loc.code))
                    .font(.system(size: 34, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundStyle(Palette.primary)
                ProgressView(value: min(1, max(0, now.timeIntervalSince(event.since) / event.at.timeIntervalSince(event.since))))
                    .tint(event.isIftar ? Palette.accent : Palette.primary)
            } else if location.coordinate == nil {
                Text(loc.t("ramadan.needsLocation"))
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
            } else {
                Text(loc.t("ramadan.eidMubarak"))
                    .font(.headline)
                    .foregroundStyle(Palette.primary)
            }
        case .shawwal:
            Text(loc.t("ramadan.shawwalShort"))
                .font(.subheadline)
                .foregroundStyle(Palette.textSecondary)
        }
    }
}

/// A du'a with its reference and a share button.
struct DuaCard: View {
    let dhikr: Dhikr
    var onShare: () -> Void

    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Text(dhikr.arabic)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.trailing)
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .environment(\.layoutDirection, .rightToLeft)
                if dhikr.showTranslit(loc.code) {
                    Text(dhikr.translit)
                        .font(.callout.italic())
                        .foregroundStyle(Palette.textSecondary)
                }
                let translation = dhikr.displayTranslation(loc.code)
                if !translation.isEmpty {
                    Text(translation)
                        .font(.callout)
                        .foregroundStyle(Palette.text)
                }
                HStack {
                    Text(dhikr.reference)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.primary)
                    Spacer()
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up").foregroundStyle(Palette.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(loc.t("share.title"))
                }
            }
        }
    }
}
