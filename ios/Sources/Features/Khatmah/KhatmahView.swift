import SwiftUI

/// Plan and follow a full reading of the Quran: today's pages, progress, and
/// whether you are ahead or behind. Progress advances by itself while reading.
struct KhatmahView: View {
    @Environment(KhatmahStore.self) private var khatmah
    @Environment(SettingsStore.self) private var settings
    @Environment(LocationManager.self) private var location
    @Environment(LocalizationManager.self) private var loc
    @State private var showSetup = false
    @State private var showPosition = false
    @State private var positionPage = 1

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.three) {
                if let plan = khatmah.plan {
                    progressCard(plan)
                    if khatmah.isFinished {
                        finishedCard
                    } else if khatmah.daysUntilStart() > 0 {
                        notStartedCard(plan)
                    } else {
                        KhatmahTodayCard()
                        scheduleCard(plan)
                    }
                    reminderCard
                    actions
                } else {
                    emptyCard
                }
                if !khatmah.completions.isEmpty { historyCard }
            }
            .padding(Spacing.three)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .noorBackground()
        .navigationTitle(loc.t("khatmah.title"))
        .sheet(isPresented: $showSetup) { KhatmahSetupSheet() }
        .sheet(isPresented: $showPosition) { positionSheet }
    }

    private func progressCard(_ plan: KhatmahPlan) -> some View {
        let fraction = Double(plan.pagesRead) / Double(KhatmahMath.totalPages)
        return Card {
            HStack(spacing: Spacing.four) {
                ZStack {
                    Circle().stroke(Palette.primarySoft, lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: fraction)
                        .stroke(Palette.primary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int((fraction * 100).rounded()))%")
                        .font(.title3.weight(.bold).monospacedDigit())
                        .foregroundStyle(Palette.primary)
                }
                .frame(width: 88, height: 88)
                VStack(alignment: .leading, spacing: Spacing.one) {
                    Text(plan.kind == "ramadan" ? loc.t("khatmah.ramadanPlan") : loc.t("khatmah.plan"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.textSecondary)
                    Text(String(format: loc.t("khatmah.pagesOf"), plan.pagesRead, KhatmahMath.totalPages))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Text(String(format: loc.t("khatmah.ends"), plan.endDate.formatted(.dateTime.day().month(.abbreviated).locale(loc.locale))))
                        .font(.subheadline)
                        .foregroundStyle(Palette.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private func scheduleCard(_ plan: KhatmahPlan) -> some View {
        let delta = KhatmahMath.scheduleDelta(plan, today: Date())
        let left = KhatmahMath.remainingDays(plan, today: Date())
        return Card {
            HStack {
                Label {
                    Text(delta >= 0
                         ? String(format: loc.t("khatmah.ahead"), delta)
                         : String(format: loc.t("khatmah.behind"), -delta))
                } icon: {
                    Image(systemName: delta >= 0 ? "checkmark.seal.fill" : "exclamationmark.circle.fill")
                        .foregroundStyle(delta >= 0 ? Palette.primary : Palette.accent)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.text)
                Spacer()
                Text(String(format: loc.t("khatmah.daysLeft"), left))
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    private func notStartedCard(_ plan: KhatmahPlan) -> some View {
        Card {
            Label(String(format: loc.t("khatmah.startsIn"), khatmah.daysUntilStart(),
                         plan.startDate.formatted(.dateTime.day().month(.wide).locale(loc.locale))),
                  systemImage: "calendar")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.text)
        }
    }

    private var finishedCard: some View {
        Card {
            VStack(spacing: Spacing.two) {
                Image(systemName: "sparkles")
                    .font(.largeTitle)
                    .foregroundStyle(Palette.accent)
                Text(loc.t("khatmah.finished"))
                    .font(.headline)
                    .foregroundStyle(Palette.text)
                    .multilineTextAlignment(.center)
                Button(loc.t("khatmah.startAnother")) { showSetup = true }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var reminderCard: some View {
        @Bindable var khatmah = khatmah
        let on = Binding<Bool>(
            get: { khatmah.reminderMinutes != nil },
            set: { khatmah.reminderMinutes = $0 ? (khatmah.reminderMinutes ?? 21 * 60) : nil; refreshNotifications() }
        )
        let time = Binding<Date>(
            get: {
                let m = khatmah.reminderMinutes ?? 21 * 60
                return Calendar.current.date(bySettingHour: m / 60, minute: m % 60, second: 0, of: Date()) ?? Date()
            },
            set: {
                let c = Calendar.current.dateComponents([.hour, .minute], from: $0)
                khatmah.reminderMinutes = (c.hour ?? 21) * 60 + (c.minute ?? 0)
                refreshNotifications()
            }
        )
        return Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Toggle(loc.t("khatmah.reminder"), isOn: on)
                if khatmah.reminderMinutes != nil {
                    DatePicker(loc.t("khatmah.reminderTime"), selection: time, displayedComponents: .hourAndMinute)
                    if !settings.notificationsEnabled {
                        Text(loc.t("khatmah.reminderNeedsNotifications"))
                            .font(.footnote)
                            .foregroundStyle(Palette.textSecondary)
                    }
                }
            }
            .tint(Palette.primary)
        }
    }

    private var actions: some View {
        VStack(spacing: Spacing.two) {
            Button {
                positionPage = max(1, khatmah.plan?.pagesRead ?? 1)
                showPosition = true
            } label: {
                Label(loc.t("khatmah.setPosition"), systemImage: "bookmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            Button(role: .destructive) {
                khatmah.cancel()
                refreshNotifications()
            } label: {
                Text(loc.t("khatmah.cancel")).frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private var emptyCard: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.three) {
                Image(systemName: "book.closed.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Palette.primary)
                Text(loc.t("khatmah.emptyTitle"))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Palette.text)
                Text(loc.t("khatmah.emptyBody"))
                    .foregroundStyle(Palette.textSecondary)
                Button {
                    showSetup = true
                } label: {
                    Text(loc.t("khatmah.start")).frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var historyCard: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Text(String(format: loc.t("khatmah.completions"), khatmah.completions.count))
                    .font(.headline)
                    .foregroundStyle(Palette.text)
                ForEach(khatmah.completions.reversed(), id: \.self) { d in
                    Label(d.formatted(.dateTime.day().month().year().locale(loc.locale)), systemImage: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundStyle(Palette.textSecondary)
                }
            }
        }
    }

    private var positionSheet: some View {
        NavigationStack {
            Form {
                Stepper(value: $positionPage, in: 0...KhatmahMath.totalPages) {
                    Text(String(format: loc.t("khatmah.pagesOf"), positionPage, KhatmahMath.totalPages))
                }
                if let m = QuranIndex.shared.firstAyah(ofPage: max(1, positionPage)),
                   let s = allSurahs.first(where: { $0.number == m.surah }) {
                    Text("\(s.displayName(loc.code)) \(m.surah):\(m.ayah) · \(loc.t("quran.juz")) \(m.juz)")
                        .foregroundStyle(Palette.textSecondary)
                }
            }
            .navigationTitle(loc.t("khatmah.setPosition"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(loc.t("common.done")) {
                        khatmah.setPagesRead(positionPage)
                        showPosition = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func refreshNotifications() {
        NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
    }
}

/// Today's portion with a button straight into the reader at the right page.
/// Shown on Home, in the Ibadah tab and on the Khatmah screen.
struct KhatmahTodayCard: View {
    @Environment(KhatmahStore.self) private var khatmah
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        if let range = khatmah.todayRange(), let first = QuranIndex.shared.firstAyah(ofPage: min(range.upperBound, max(range.lowerBound, (khatmah.plan?.pagesRead ?? 0) + 1))),
           let surah = allSurahs.first(where: { $0.number == first.surah }) {
            let done = khatmah.isTodayDone()
            Card {
                VStack(alignment: .leading, spacing: Spacing.two) {
                    HStack {
                        Label(loc.t("khatmah.today"), systemImage: done ? "checkmark.circle.fill" : "book.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(done ? Palette.primary : Palette.textSecondary)
                        Spacer()
                        Text(String(format: loc.t("khatmah.minutes"), max(2, range.count * 2)))
                            .font(.caption)
                            .foregroundStyle(Palette.textSecondary)
                    }
                    Text(String(format: loc.t("khatmah.pages"), range.lowerBound, range.upperBound))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Text("\(surah.displayName(loc.code)) \(first.surah):\(first.ayah) · \(loc.t("quran.juz")) \(first.juz)")
                        .font(.subheadline)
                        .foregroundStyle(Palette.textSecondary)
                    HStack(spacing: Spacing.two) {
                        NavigationLink {
                            SurahView(surah: surah, startAyah: first.ayah)
                        } label: {
                            Text(done ? loc.t("khatmah.readMore") : loc.t("khatmah.read"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        if !done {
                            Button(loc.t("khatmah.markRead")) { khatmah.markTodayRead() }
                                .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
    }
}

/// Choose how long the khatmah should take.
struct KhatmahSetupSheet: View {
    @Environment(KhatmahStore.self) private var khatmah
    @Environment(SettingsStore.self) private var settings
    @Environment(LocalizationManager.self) private var loc
    @Environment(\.dismiss) private var dismiss
    @State private var customEnd = Calendar.current.date(byAdding: .day, value: 29, to: Date()) ?? Date()

    private var ramadan: RamadanInfo? { RamadanService.currentOrNext(offset: settings.hijriOffset) }

    var body: some View {
        NavigationStack {
            Form {
                if let r = ramadan {
                    Section {
                        Button {
                            // Before Ramadan the plan waits for 1 Ramadan; during it, it starts today.
                            khatmah.start(until: r.date(ofDay: r.days), kind: "ramadan", startDate: r.start)
                            dismiss()
                        } label: {
                            Label(String(format: loc.t("khatmah.preset.ramadan"), r.year), systemImage: "moon.stars.fill")
                        }
                    } footer: {
                        Text(loc.t("khatmah.preset.ramadanFooter"))
                    }
                }
                Section(loc.t("khatmah.preset.days")) {
                    ForEach([30, 60, 90, 365], id: \.self) { days in
                        Button {
                            khatmah.start(days: days)
                            dismiss()
                        } label: {
                            Text(String(format: loc.t("khatmah.preset.inDays"), days, Int((Double(KhatmahMath.totalPages) / Double(days)).rounded(.up))))
                        }
                    }
                }
                Section(loc.t("khatmah.preset.custom")) {
                    DatePicker(loc.t("khatmah.preset.until"), selection: $customEnd, in: Date()..., displayedComponents: .date)
                    Button(loc.t("khatmah.start")) {
                        khatmah.start(until: customEnd, kind: "days")
                        dismiss()
                    }
                }
            }
            .navigationTitle(loc.t("khatmah.start"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(loc.t("common.cancel")) { dismiss() }
                }
            }
        }
    }
}
