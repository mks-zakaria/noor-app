import SwiftUI
import WidgetKit

// Prayer widgets for the Lock Screen (and Home Screen). They compute times
// themselves from the context the app publishes in the App Group, so they stay
// right all day, and during Ramadan they count down to suhoor and iftar.

// MARK: - Snapshot (pure, shared by every prayer widget)

struct PrayerSnapshot {
    struct Fasting {
        let isIftar: Bool
        let at: Date
        let since: Date
        let day: Int
        /// The other fasting time of the same day (suhoor end when counting to iftar, and vice versa).
        let other: Date?
    }

    let date: Date
    let ctx: SharedPrayerContext
    let times: DayTimes
    let next: (name: PrayerName, at: Date)
    /// Time of the prayer before `next` (yesterday's Isha just after midnight).
    let since: Date
    /// The prayer after `next`.
    let following: (name: PrayerName, at: Date)?
    let phase: RamadanPhase
    let ramadan: RamadanInfo?
    let fasting: Fasting?

    var lang: String { ctx.language }

    static func make(_ ctx: SharedPrayerContext, at date: Date) -> PrayerSnapshot? {
        guard let method = MethodKey(rawValue: ctx.method), let madhab = MadhabKey(rawValue: ctx.madhab),
              let times = PrayerService.computeTimes(lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, date: date),
              let next = PrayerService.nextPrayer(from: times, lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, now: date)
        else { return nil }
        let cal = Calendar.current
        let five = prayerOrder.filter(\.isPrayer)

        let yesterdayIsha = cal.date(byAdding: .day, value: -1, to: date)
            .flatMap { PrayerService.computeTimes(lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, date: $0)?[.isha] }
        let since = five.compactMap { times[$0] }.filter { $0 <= date }.max() ?? yesterdayIsha ?? date.addingTimeInterval(-3600)

        let following: (PrayerName, Date)? = {
            let after = next.at.addingTimeInterval(1)
            guard let t = PrayerService.computeTimes(lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, date: after),
                  let f = PrayerService.nextPrayer(from: t, lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, now: after)
            else { return nil }
            return (f.name, f.at)
        }()

        let phase = RamadanService.phase(now: date, offset: ctx.hijriOffset)
        let info = RamadanService.currentOrNext(now: date, offset: ctx.hijriOffset)
        var fasting: Fasting?
        if let info, let e = RamadanService.nextFastingEvent(now: date, info: info, lat: ctx.lat, lng: ctx.lng,
                                                              method: method, madhab: madhab),
           let day = info.day(of: e.at) {
            let eventDay = PrayerService.computeTimes(lat: ctx.lat, lng: ctx.lng, method: method, madhab: madhab, date: e.at)
            fasting = Fasting(isIftar: e.isIftar, at: e.at, since: e.since, day: day,
                              other: e.isIftar ? eventDay?[.fajr] : eventDay?[.maghrib])
        }
        return PrayerSnapshot(date: date, ctx: ctx, times: times, next: next, since: since,
                              following: following, phase: phase, ramadan: info, fasting: fasting)
    }

    func name(_ p: PrayerName) -> String { Strings.t("prayer.\(p.rawValue)", lang) }
    func t(_ key: String) -> String { Strings.t(key, lang) }
    func clock(_ d: Date) -> String { d.timeString(hour12: ctx.hour12) }
    /// "Mon 8 Feb" in the app language and the calendar's time zone.
    func dayLabel(_ d: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: lang)
        f.timeZone = Calendar.current.timeZone
        f.setLocalizedDateFormatFromTemplate("EEEdMMM")
        return f.string(from: d)
    }

    /// "15 Jumada II 1448 AH", with the user's Hijri correction; in Arabic the Maghreb month
    /// names the app uses (HomeView.arabicHijriMonths), not Apple's.
    var hijriLine: String {
        let h = RamadanService.hijriComponents(date, offset: ctx.hijriOffset)
        if lang == "ar" {
            let months = ["محرم", "صفر", "ربيع الأول", "ربيع الثاني", "جمادى الأولى", "جمادى الثانية",
                          "رجب", "شعبان", "رمضان", "شوال", "ذو القعدة", "ذو الحجة"]
            return "\(h.day) \(months[max(0, min(11, h.month - 1))])، \(h.year) هـ"
        }
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .islamicUmmAlQura)
        f.locale = Locale(identifier: lang)
        f.dateFormat = "d MMMM yyyy"
        let shifted = Calendar.current.date(byAdding: .day, value: ctx.hijriOffset, to: date) ?? date
        return f.string(from: shifted) + " AH"
    }

    /// One Ramadan line for the large widget: the next suhoor end or iftar during the month,
    /// otherwise the countdown to it; nothing in Shawwal.
    var ramadanLine: String? {
        if let f = fasting { return "\(t(f.isIftar ? "ramadan.iftar" : "ramadan.suhoorEnds")) \(clock(f.at))" }
        if case .before(let d) = phase {
            return d == 0 ? t("ramadan.startsTomorrow")
                : "\(String(format: t("ramadan.titleYear"), ramadan?.year ?? 0)) · \(String(format: t("ramadan.inDays"), d))"
        }
        return nil
    }

    /// "6:12" without AM/PM, for the tightest spots.
    func shortClock(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = ctx.hour12 ? "h:mm" : "HH:mm"
        return f.string(from: d)
    }
}

// MARK: - Timeline

struct PrayerEntry: TimelineEntry {
    let date: Date
    let snapshot: PrayerSnapshot?
}

struct PrayerProvider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry(date: Date(), snapshot: Self.sample(at: Date()))
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> Void) {
        let now = Date()
        let real = SharedPrayerContext.load().flatMap { PrayerSnapshot.make($0, at: now) }
        completion(PrayerEntry(date: now, snapshot: real ?? Self.sample(at: now)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        let now = Date()
        guard let ctx = SharedPrayerContext.load(), let first = PrayerSnapshot.make(ctx, at: now) else {
            completion(Timeline(entries: [PrayerEntry(date: now, snapshot: nil)], policy: .after(now.addingTimeInterval(3600))))
            return
        }
        // A new entry at every prayer (Fajr and Maghrib are also suhoor and
        // iftar) and at midnight (Ramadan day number), over the next day.
        var stops = Set<Date>()
        var cursor = first
        for _ in 0..<7 {
            stops.insert(cursor.next.at)
            guard let n = PrayerSnapshot.make(ctx, at: cursor.next.at.addingTimeInterval(1)) else { break }
            cursor = n
        }
        let midnight = Calendar.current.startOfDay(for: now.addingTimeInterval(86_400))
        stops.insert(midnight)

        var entries = [PrayerEntry(date: now, snapshot: first)]
        for stop in stops.sorted() where stop > now {
            let at = stop.addingTimeInterval(1)
            entries.append(PrayerEntry(date: at, snapshot: PrayerSnapshot.make(ctx, at: at)))
        }
        completion(Timeline(entries: entries, policy: .after(entries.last?.date ?? now.addingTimeInterval(6 * 3600))))
    }

    /// Shown in the widget gallery before the app has published a location.
    static func sample(at date: Date) -> PrayerSnapshot? {
        let ctx = SharedPrayerContext(lat: 21.4225, lng: 39.8262, method: MethodKey.ummAlQura.rawValue,
                                      madhab: MadhabKey.shafi.rawValue, hour12: true,
                                      language: widgetLanguage(), place: "Makkah", hijriOffset: 0)
        return PrayerSnapshot.make(ctx, at: date)
    }
}

/// The app's chosen language, for strings the widget gallery shows.
func widgetLanguage() -> String {
    #if os(watchOS)
    SharedPrayerContext.load()?.language ?? "en"
    #else
    UserDefaults(suiteName: WidgetContract.suiteName)?.string(forKey: WidgetContract.Keys.language) ?? "en"
    #endif
}

// MARK: - Live countdowns (frozen for marketing renders)

private struct FrozenNowKey: EnvironmentKey { static let defaultValue: Date? = nil }

extension EnvironmentValues {
    /// Set only by the screenshot renderer: draws countdowns at this instant
    /// instead of ticking with the real clock.
    var frozenNow: Date? {
        get { self[FrozenNowKey.self] }
        set { self[FrozenNowKey.self] = newValue }
    }
}

/// A live "2:13:05" countdown to `to`.
struct Countdown: View {
    let from: Date
    let to: Date
    @Environment(\.frozenNow) private var frozen

    var body: some View {
        if let frozen {
            Text(Self.format(to.timeIntervalSince(frozen)))
        } else {
            Text(timerInterval: from...max(from, to), countsDown: true)
        }
    }

    static func format(_ interval: TimeInterval) -> String {
        let t = max(0, Int(interval))
        let h = t / 3600, m = (t % 3600) / 60, s = t % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s) : String(format: "%d:%02d", m, s)
    }
}

/// A ring filling from `since` to `until`, with a label inside.
struct TimedRing<Label: View>: View {
    let since: Date
    let until: Date
    @ViewBuilder let label: () -> Label
    @Environment(\.frozenNow) private var frozen

    var body: some View {
        if let frozen {
            let span = max(60, until.timeIntervalSince(since))
            Gauge(value: min(1, max(0, frozen.timeIntervalSince(since) / span))) {
                EmptyView()
            } currentValueLabel: {
                label()
            }
            #if os(macOS)
            .gaugeStyle(.linearCapacity)        // Lock Screen ring styles do not exist on the Mac
            #else
            .gaugeStyle(.accessoryCircularCapacity)
            #endif
        } else {
            ProgressView(timerInterval: since...max(since.addingTimeInterval(60), until), countsDown: false) {
                EmptyView()
            } currentValueLabel: {
                label()
            }
            .progressViewStyle(.circular)
        }
    }
}

// MARK: - Next prayer

struct NextPrayerView: View {
    let snapshot: PrayerSnapshot?
    let family: WidgetFamily

    var body: some View {
        if let s = snapshot {
            switch family {
            #if !os(macOS)
            case .accessoryCircular: circular(s)
            case .accessoryRectangular: rectangular(s)
            case .accessoryInline: inline(s)
            #endif
            case .systemMedium: medium(s)
            case .systemLarge: large(s)
            default: small(s)
            }
        } else {
            NeedsLocationView(family: family)
        }
    }

    /// The whole day (Mac desktop, iPad): the next prayer with its countdown and the time after
    /// it, every time of the day including sunrise, then the Hijri date and the Ramadan line.
    private func large(_ s: PrayerSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(s.t("widget.nextPrayer").uppercased())
                        .font(.caption2.weight(.semibold)).foregroundStyle(.white.opacity(0.75))
                    Text(s.name(s.next.name))
                        .font(.system(size: 28, weight: .bold)).foregroundStyle(.white)
                        .minimumScaleFactor(0.7).lineLimit(1)
                }
                Spacer()
                if s.lang != "ar" {
                    Text(s.next.name.ar).font(.system(size: 26, weight: .semibold)).foregroundStyle(Color.noorGold)
                }
            }
            HStack(alignment: .firstTextBaseline) {
                Text(s.clock(s.next.at)).font(.title3.weight(.semibold)).foregroundStyle(Color.noorGold)
                Spacer()
                Countdown(from: s.date, to: s.next.at)
                    .font(.title3.weight(.semibold).monospacedDigit()).foregroundStyle(.white)
            }
            Divider().overlay(Color.white.opacity(0.2))
            VStack(spacing: 3) {
                ForEach(prayerOrder) { p in
                    let isNext = s.next.name == p && Calendar.current.isDate(s.next.at, inSameDayAs: s.date)
                    HStack {
                        Text(s.name(p)).font(.callout.weight(isNext ? .bold : .regular))
                        Spacer()
                        if let at = s.times[p] {
                            Text(s.clock(at)).font(.callout.monospacedDigit().weight(isNext ? .bold : .regular))
                        }
                    }
                    .foregroundStyle(isNext ? Color.noorGold : (p.isPrayer ? .white : .white.opacity(0.6)))
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .background(isNext ? Color.white.opacity(0.10) : .clear, in: RoundedRectangle(cornerRadius: 6))
                }
            }
            Spacer(minLength: 0)
            HStack {
                Text(s.hijriLine).font(.caption.weight(.semibold)).foregroundStyle(.white.opacity(0.85))
                Spacer()
                if !s.ctx.place.isEmpty {
                    Label(s.ctx.place, systemImage: "location.fill").font(.caption).foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            if let line = s.ramadanLine {
                Text(line).font(.caption.weight(.semibold)).foregroundStyle(Color.noorGold).lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    /// Ring filling from the previous prayer to the next, with the next prayer's time inside.
    private func circular(_ s: PrayerSnapshot) -> some View {
        ZStack {
            AccessoryWidgetBackground()
            TimedRing(since: s.since, until: s.next.at) {
                VStack(spacing: 0) {
                    Image(systemName: s.next.name.systemImage)
                        .font(.system(size: 13, weight: .semibold))
                        .widgetAccentable()
                    Text(s.shortClock(s.next.at))
                        .font(.system(size: 14, weight: .bold, design: .rounded).monospacedDigit())
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
            }
            .widgetAccentable()
        }
        .accessibilityLabel("\(s.name(s.next.name)) \(s.clock(s.next.at))")
    }

    private func rectangular(_ s: PrayerSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: s.next.name.systemImage)
                Text(s.name(s.next.name))
                    .fontWeight(.bold)
                    .widgetAccentable()
                Spacer(minLength: 2)
                Text(s.clock(s.next.at))
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            HStack(spacing: 4) {
                Text(s.t("home.in"))
                Countdown(from: s.date, to: s.next.at)
                    .monospacedDigit()
            }
            .font(.system(.title3, design: .rounded).weight(.semibold))
            .lineLimit(1)
            if let f = s.following {
                Text("\(s.name(f.name)) \(s.clock(f.at))")
                    .font(.caption)
                    .opacity(0.75)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func inline(_ s: PrayerSnapshot) -> some View {
        Label("\(s.name(s.next.name)) \(s.clock(s.next.at))", systemImage: s.next.name.systemImage)
    }

    private func small(_ s: PrayerSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(s.t("widget.nextPrayer"))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.75))
            Text(s.name(s.next.name))
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(s.clock(s.next.at))
                .font(.headline)
                .foregroundStyle(Color.noorGold)
            Spacer(minLength: 0)
            Countdown(from: s.date, to: s.next.at)
                .font(.title3.weight(.semibold).monospacedDigit())
                .foregroundStyle(.white)
            if !s.ctx.place.isEmpty {
                Text(s.ctx.place)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func medium(_ s: PrayerSnapshot) -> some View {
        HStack(spacing: 12) {
            small(s)
            VStack(spacing: 3) {
                ForEach(prayerOrder.filter(\.isPrayer)) { p in
                    let isNext = s.next.name == p && Calendar.current.isDate(s.next.at, inSameDayAs: s.date)
                    HStack {
                        Text(s.name(p)).font(.caption.weight(isNext ? .bold : .regular))
                        Spacer()
                        if let at = s.times[p] {
                            Text(s.clock(at)).font(.caption.monospacedDigit().weight(isNext ? .bold : .regular))
                        }
                    }
                    .foregroundStyle(isNext ? Color.noorGold : .white)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Ramadan (suhoor / iftar, or the countdown to Ramadan)

struct RamadanWidgetView: View {
    let snapshot: PrayerSnapshot?
    let family: WidgetFamily

    var body: some View {
        if let s = snapshot {
            if let f = s.fasting {
                switch family {
                #if !os(macOS)
                case .accessoryCircular: fastingCircular(s, f)
                case .accessoryInline: Label("\(eventName(s, f)) \(s.clock(f.at))", systemImage: icon(f))
                #endif
                default: fastingRectangular(s, f)
                }
            } else {
                switch family {
                #if !os(macOS)
                case .accessoryCircular: countdownCircular(s)
                case .accessoryInline: Label(headline(s), systemImage: "moon.stars.fill")
                #endif
                default: countdownRectangular(s)
                }
            }
        } else {
            NeedsLocationView(family: family)
        }
    }

    private func icon(_ f: PrayerSnapshot.Fasting) -> String { f.isIftar ? "sunset.fill" : "moon.stars.fill" }

    private func eventName(_ s: PrayerSnapshot, _ f: PrayerSnapshot.Fasting) -> String {
        s.t(f.isIftar ? "ramadan.iftar" : "ramadan.suhoorEnds")
    }

    /// Ring through the fast (or the night) with the event time inside.
    private func fastingCircular(_ s: PrayerSnapshot, _ f: PrayerSnapshot.Fasting) -> some View {
        ZStack {
            AccessoryWidgetBackground()
            TimedRing(since: f.since, until: f.at) {
                VStack(spacing: 0) {
                    Image(systemName: icon(f))
                        .font(.system(size: 13, weight: .semibold))
                        .widgetAccentable()
                    Text(s.shortClock(f.at))
                        .font(.system(size: 14, weight: .bold, design: .rounded).monospacedDigit())
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
            }
            .widgetAccentable()
        }
        .accessibilityLabel("\(eventName(s, f)) \(s.clock(f.at))")
    }

    private func fastingRectangular(_ s: PrayerSnapshot, _ f: PrayerSnapshot.Fasting) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: icon(f))
                Text(eventName(s, f))
                    .fontWeight(.bold)
                    .widgetAccentable()
                Spacer(minLength: 2)
                Text(s.clock(f.at)).fontWeight(.semibold)
            }
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            Countdown(from: s.date, to: f.at)
                .font(.system(.title3, design: .rounded).weight(.semibold).monospacedDigit())
                .lineLimit(1)
            Group {
                if let other = f.other {
                    Text("\(String(format: s.t("widget.ramadanDay"), f.day)) · \(s.t(f.isIftar ? "ramadan.suhoorEnds" : "ramadan.iftar")) \(s.clock(other))")
                } else {
                    Text(String(format: s.t("widget.ramadanDay"), f.day))
                }
            }
            .font(.caption)
            .opacity(0.75)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func daysToRamadan(_ s: PrayerSnapshot) -> Int? {
        if case .before(let d) = s.phase { return d }
        return nil
    }

    private func headline(_ s: PrayerSnapshot) -> String {
        switch s.phase {
        case .before(let d): return d == 0 ? s.t("ramadan.startsTomorrow") : "\(String(format: s.t("ramadan.titleYear"), s.ramadan?.year ?? 0)) · \(String(format: s.t("ramadan.inDays"), d))"
        case .during: return s.t("ramadan.eidMubarak")
        case .shawwal: return s.t("ramadan.shawwal")
        }
    }

    private func countdownCircular(_ s: PrayerSnapshot) -> some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .widgetAccentable()
                if let d = daysToRamadan(s) {
                    Text("\(d)")
                        .font(.system(size: 20, weight: .bold, design: .rounded).monospacedDigit())
                        .minimumScaleFactor(0.6)
                    Text(s.t("widget.days"))
                        .font(.system(size: 9, weight: .semibold))
                        .textCase(.uppercase)
                } else {
                    Text("6").font(.system(size: 20, weight: .bold, design: .rounded))
                    Text(s.t("widget.shawwalShort")).font(.system(size: 9, weight: .semibold))
                }
            }
        }
        .accessibilityLabel(headline(s))
    }

    private func countdownRectangular(_ s: PrayerSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: 4) {
                Image(systemName: "moon.stars.fill")
                Text(String(format: s.t("ramadan.titleYear"), s.ramadan?.year ?? 0))
                    .fontWeight(.bold)
                    .widgetAccentable()
            }
            .font(.headline)
            .lineLimit(1)
            if let d = daysToRamadan(s) {
                Text(d == 0 ? s.t("ramadan.startsTomorrow") : String(format: s.t("ramadan.inDays"), d))
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                if let r = s.ramadan {
                    Text(s.dayLabel(r.start))
                        .font(.caption)
                        .opacity(0.75)
                }
            } else {
                Text(headline(s))
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Today's five prayers (Lock Screen rectangular)

struct TodayPrayersView: View {
    let snapshot: PrayerSnapshot?

    var body: some View {
        if let s = snapshot {
            let five = prayerOrder.filter(\.isPrayer)
            let nextToday = Calendar.current.isDate(s.next.at, inSameDayAs: s.date) ? s.next.name : nil
            Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 1) {
                ForEach(0..<3, id: \.self) { row in
                    GridRow {
                        cell(s, five[row], isNext: five[row] == nextToday)
                        if row + 3 < five.count {
                            cell(s, five[row + 3], isNext: five[row + 3] == nextToday)
                        } else if !s.ctx.place.isEmpty {
                            Label(s.ctx.place, systemImage: "location.fill")
                                .font(.system(size: 11, weight: .medium))
                                .opacity(0.7)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            NeedsLocationView(family: .compactListFamily)
        }
    }

    private func cell(_ s: PrayerSnapshot, _ p: PrayerName, isNext: Bool) -> some View {
        HStack(spacing: 4) {
            Text(s.name(p))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Spacer(minLength: 2)
            Text(s.shortClock(s.times[p] ?? s.date))
                .monospacedDigit()
                .fixedSize()
                .layoutPriority(1)
        }
        .font(.system(size: 12.5, weight: isNext ? .heavy : .medium))
        .opacity(isNext ? 1 : 0.8)
        .modifier(AccentIf(isNext))
    }
}

private struct AccentIf: ViewModifier {
    let on: Bool
    init(_ on: Bool) { self.on = on }
    func body(content: Content) -> some View {
        if on { content.widgetAccentable() } else { content }
    }
}

struct NeedsLocationView: View {
    let family: WidgetFamily

    var body: some View {
        let lang = widgetLanguage()
        switch family {
        #if !os(macOS)
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "location.slash").font(.title3)
            }
        case .accessoryInline:
            Label(Strings.t("widget.openNoor", lang), systemImage: "location.slash")
        #endif
        default:
            Label(Strings.t("widget.openNoor", lang), systemImage: "location.slash")
                .font(.caption)
        }
    }
}

// MARK: - Widgets

/// Reads the family from the environment and hands it to the testable views.
private struct FamilyReader<Content: View>: View {
    @Environment(\.widgetFamily) private var family
    let content: (WidgetFamily) -> Content
    var body: some View { content(family) }
}

private extension View {
    /// Noor's green on the Home Screen; clear on the Lock Screen, where the system draws the material.
    func noorWidgetBackground(_ family: WidgetFamily, rtl: Bool) -> some View {
        self
            .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
            .containerBackground(for: .widget) {
                if family.isHomeScreen {
                    LinearGradient(colors: [.noorDeep, .noorGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
                } else {
                    Color.clear
                }
            }
    }
}

enum PrayerWidgetKinds {
    static let next = "NoorPrayerWidget"
    static let ramadan = "NoorRamadanWidget"
    static let today = "NoorTodayWidget"
}

struct PrayerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: PrayerWidgetKinds.next, provider: PrayerProvider()) { entry in
            FamilyReader { family in
                NextPrayerView(snapshot: entry.snapshot, family: family)
                    .noorWidgetBackground(family, rtl: entry.snapshot?.lang == "ar")
            }
        }
        .configurationDisplayName(Strings.t("widget.prayerName", widgetLanguage()))
        .description(Strings.t("widget.prayerDesc", widgetLanguage()))
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
        #elseif os(macOS)
        // Mac desktop and Notification Center: no Lock Screen families on the Mac.
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        #else
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium])
        #endif
    }
}

#if !os(macOS)
struct RamadanWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: PrayerWidgetKinds.ramadan, provider: PrayerProvider()) { entry in
            FamilyReader { family in
                RamadanWidgetView(snapshot: entry.snapshot, family: family)
                    .noorWidgetBackground(family, rtl: entry.snapshot?.lang == "ar")
            }
        }
        .configurationDisplayName(Strings.t("widget.ramadanName", widgetLanguage()))
        .description(Strings.t("widget.ramadanDesc", widgetLanguage()))
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
#endif

#if !os(macOS)
struct TodayPrayersWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: PrayerWidgetKinds.today, provider: PrayerProvider()) { entry in
            TodayPrayersView(snapshot: entry.snapshot)
                .noorWidgetBackground(.accessoryRectangular, rtl: entry.snapshot?.lang == "ar")
        }
        .configurationDisplayName(Strings.t("widget.todayName", widgetLanguage()))
        .description(Strings.t("widget.todayDesc", widgetLanguage()))
        .supportedFamilies([.accessoryRectangular])
    }
}
#endif

extension WidgetFamily {
    /// Home Screen sizes get the green background; accessory (Lock Screen, watch) sizes stay clear.
    var isHomeScreen: Bool {
        #if os(watchOS)
        false
        #elseif os(macOS)
        true
        #else
        self == .systemSmall || self == .systemMedium || self == .systemLarge
        #endif
    }
}

extension WidgetFamily {
    /// The family TodayPrayersView draws its empty state in: rectangular on the Lock Screen,
    /// medium on the Mac desktop (no Lock Screen families there).
    static var compactListFamily: WidgetFamily {
        #if os(macOS)
        .systemMedium
        #else
        .accessoryRectangular
        #endif
    }
}
