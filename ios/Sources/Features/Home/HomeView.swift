import SwiftUI

struct HomeView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(LocationManager.self) private var location
    @Environment(BookmarksStore.self) private var bookmarks
    @Environment(LocalizationManager.self) private var loc
    @State private var showRateCard = ReviewPrompt.showsRateCard

    private var coordinate: (lat: Double, lng: Double)? {
        guard let c = location.coordinate else { return nil }
        return (c.latitude, c.longitude)
    }

    private var today: DayTimes? {
        guard let c = coordinate else { return nil }
        return PrayerService.computeTimes(
            lat: c.lat, lng: c.lng, method: settings.method, madhab: settings.madhab
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.three) {
                    dateHeader
                    if let times = today, let c = coordinate {
                        nextPrayerHero(times: times, c: c)
                        prayerList(times)
                    } else if location.isDenied {
                        locationDeniedNotice
                    } else if !location.isAuthorized {
                        LocationIntroCard()
                    } else {
                        locatingPlaceholder
                    }
                    continueReadingCard
                    HStack(spacing: Spacing.three) {
                        learnCard
                        favouritesCard
                    }
                    if showRateCard {
                        RateCard {
                            withAnimation(.easeOut(duration: 0.25)) { showRateCard = false }
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    }
                }
                .padding(Spacing.three)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .noorBackground()
            .navigationTitle(loc.t("app.name"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { SettingsView() } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            // Only refresh an existing fix here. The first permission prompt is
            // triggered by the user tapping Continue, never automatically.
            .onAppear { if location.isAuthorized { location.request() } }
            .onChange(of: locationKey) { _, _ in
                NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
            }
        }
    }

    /// String proxy for the coordinate so onChange can observe it (CLLocationCoordinate2D isn't Equatable).
    private var locationKey: String {
        guard let c = coordinate else { return "" }
        return "\(c.lat),\(c.lng)"
    }

    // MARK: Sections

    private var dateHeader: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.one) {
                Text(hijriDate)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Palette.text)
                HStack(spacing: Spacing.two) {
                    Text(gregorianDate)
                    if !location.placeName.isEmpty {
                        Text("·")
                        Label(location.placeName, systemImage: "location.fill")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Palette.textSecondary)
            }
        }
    }

    private func nextPrayerHero(times: DayTimes, c: (lat: Double, lng: Double)) -> some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let next = PrayerService.nextPrayer(
                from: times, lat: c.lat, lng: c.lng,
                method: settings.method, madhab: settings.madhab, now: context.date
            )
            Card {
                VStack(alignment: .leading, spacing: Spacing.two) {
                    Text(loc.t("home.nextPrayer"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.textSecondary)
                    if let next {
                        HStack(alignment: .firstTextBaseline) {
                            Text(next.name.label(loc.code))
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(Palette.primary)
                            Spacer()
                            if loc.code != "ar" {
                                Text(next.name.ar)
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(Palette.primary)
                            }
                        }
                        HStack {
                            Text(next.at.timeString(hour12: settings.hour12))
                                .font(.headline)
                                .foregroundStyle(Palette.text)
                            Spacer()
                            Text("\(loc.t("home.in")) \(formatCountdown(next.at.timeIntervalSince(context.date), langCode: loc.code))")
                                .font(.headline.monospacedDigit())
                                .foregroundStyle(Palette.accent)
                        }
                    }
                }
            }
        }
    }

    private func prayerList(_ times: DayTimes) -> some View {
        let now = Date()
        let next = coordinate.flatMap {
            PrayerService.nextPrayer(from: times, lat: $0.lat, lng: $0.lng,
                                     method: settings.method, madhab: settings.madhab, now: now)
        }
        return Card(padding: Spacing.two) {
            VStack(spacing: 0) {
                ForEach(prayerOrder) { p in
                    let isNext = next?.name == p
                    HStack(spacing: Spacing.three) {
                        Image(systemName: p.systemImage)
                            .foregroundStyle(isNext ? Palette.primary : Palette.textSecondary)
                            .frame(width: 26)
                        Text(p.label(loc.code))
                            .foregroundStyle(Palette.text)
                            .fontWeight(isNext ? .semibold : .regular)
                        Spacer()
                        if loc.code != "ar" {
                            Text(p.ar)
                                .foregroundStyle(Palette.textSecondary)
                        }
                        if let at = times[p] {
                            Text(at.timeString(hour12: settings.hour12))
                                .font(.body.monospacedDigit())
                                .foregroundStyle(isNext ? Palette.primary : Palette.text)
                                .frame(width: 78, alignment: .trailing)
                        }
                    }
                    .padding(.vertical, Spacing.two)
                    .padding(.horizontal, Spacing.two)
                    .background(isNext ? Palette.backgroundSelected : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.sm, style: .continuous))
                    if p != prayerOrder.last {
                        Divider().overlay(Palette.border)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var continueReadingCard: some View {
        if let lr = bookmarks.lastRead, let s = allSurahs.first(where: { $0.number == lr.surah }) {
            NavigationLink {
                SurahView(surah: s)
            } label: {
                Card {
                    HStack(spacing: Spacing.three) {
                        Image(systemName: "book.fill")
                            .font(.title2)
                            .foregroundStyle(Palette.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loc.t("home.continueReading"))
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Palette.textSecondary)
                            Text(loc.code == "ar" ? s.arabic : "\(s.name) · \(s.arabic)")
                                .font(.headline)
                                .foregroundStyle(Palette.text)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Palette.textSecondary)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var learnCard: some View {
        NavigationLink { GuidesView() } label: {
            tile(icon: "graduationcap.fill", label: loc.t("home.learn"), tint: Palette.accent)
        }
        .buttonStyle(.plain)
    }

    private var favouritesCard: some View {
        NavigationLink { FavouritesView() } label: {
            tile(icon: "heart.fill", label: loc.t("home.favourites"), tint: Palette.danger)
        }
        .buttonStyle(.plain)
    }

    private func tile(icon: String, label: String, tint: Color) -> some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(tint)
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var locatingPlaceholder: some View {
        Card {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.four)
        }
    }

    private var locationDeniedNotice: some View {
        Card {
            VStack(spacing: Spacing.three) {
                Image(systemName: "location.slash")
                    .font(.largeTitle)
                    .foregroundStyle(Palette.textSecondary)
                Text(loc.t("home.locationDenied"))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
                Button(loc.t("common.openSettings")) { location.openSettings() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.three)
        }
    }

    // MARK: Formatting

    private var hijriDate: String {
        let cal = Calendar(identifier: .islamicUmmAlQura)
        let f = DateFormatter()
        f.calendar = cal
        f.locale = loc.locale
        f.dateFormat = "d MMMM, yyyy"
        let date = Calendar.current.date(byAdding: .day, value: settings.hijriOffset, to: Date()) ?? Date()
        return f.string(from: date) + (loc.code == "ar" ? " هـ" : " AH")
    }

    private var gregorianDate: String {
        let f = DateFormatter()
        f.locale = loc.locale
        f.dateFormat = "EEEE, d MMM"
        return f.string(from: Date())
    }
}
