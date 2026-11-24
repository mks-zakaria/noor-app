import SwiftUI
import WidgetKit
import XCTest

/// Store screenshots and ad creatives of the Lock Screen widgets: an iPhone
/// showing the real widget views (frozen at a chosen moment) under a headline.
///
///   1320×2868  App Store 6.9" screenshot   → store-<lang>-<n>.png
///   1080×1920  Stories / Reels / TikTok ad → story-<lang>-<n>.png
///   1080×1080  Feed ad                      → square-<lang>-<n>.png
///
///     TEST_RUNNER_NOOR_POSTER_DIR=/abs/dir xcodebuild test -scheme Noor \
///       -destination 'id=<iPhone sim>' -only-testing:NoorWidgetRender/LockScreenPosterTests
@MainActor
final class LockScreenPosterTests: XCTestCase {

    enum Scene: String, CaseIterable { case iftar, prayer, suhoor }

    struct Copy { let title: String; let subtitle: String }

    static let copy: [String: [Scene: Copy]] = [
        "en": [
            .iftar: Copy(title: "Iftar countdown on your Lock Screen", subtitle: "Suhoor and iftar times for your city, all Ramadan."),
            .prayer: Copy(title: "The next prayer at a glance", subtitle: "Lock Screen widgets. No ads, no account."),
            .suhoor: Copy(title: "Never miss suhoor", subtitle: "A live countdown to Fajr, right on your Lock Screen."),
        ],
        "fr": [
            .iftar: Copy(title: "L'iftar en compte à rebours sur l'écran verrouillé", subtitle: "Les heures du suhur et de l'iftar de votre ville, tout le Ramadan."),
            .prayer: Copy(title: "La prochaine prière d'un coup d'œil", subtitle: "Des widgets d'écran verrouillé. Sans pub, sans compte."),
            .suhoor: Copy(title: "Ne manquez plus le suhur", subtitle: "Un compte à rebours jusqu'au Fajr, sur l'écran verrouillé."),
        ],
        "ar": [
            .iftar: Copy(title: "العدّ التنازلي للإفطار على شاشة القفل", subtitle: "مواقيت السحور والإفطار لمدينتك طوال رمضان."),
            .prayer: Copy(title: "الصلاة القادمة بنظرة واحدة", subtitle: "ودجات لشاشة القفل، بلا إعلانات ولا حساب."),
            .suhoor: Copy(title: "لن يفوتك السحور", subtitle: "عدّ تنازلي حتى الفجر على شاشة القفل."),
        ],
    ]

    private var outDir: URL!

    override func setUpWithError() throws {
        let dir = ProcessInfo.processInfo.environment["NOOR_POSTER_DIR"] ?? NSTemporaryDirectory() + "noor-posters"
        outDir = URL(fileURLWithPath: dir)
        try FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)
        for name in ["Amiri-Regular", "Amiri-Bold"] {
            if let url = Bundle(for: Self.self).url(forResource: name, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }
        }
    }

    override func tearDown() { NSTimeZone.default = TimeZone.current }

    func testRenderPosters() throws {
        for city in LockScreenRenderTests.cities {
            let tz = TimeZone(identifier: city.tz)!
            NSTimeZone.default = tz
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = tz
            let ctx = SharedPrayerContext(lat: city.lat, lng: city.lng, method: city.method.rawValue,
                                          madhab: MadhabKey.shafi.rawValue, hour12: city.hour12,
                                          language: city.lang, place: city.place, hijriOffset: 0)
            let ramadan = try XCTUnwrap(RamadanService.info(year: 1448, offset: 0))
            let day12 = cal.date(byAdding: .day, value: 11, to: ramadan.start)!
            let moments: [Scene: Date] = [
                .iftar: cal.date(bySettingHour: 15, minute: 47, second: 12, of: day12)!,
                .suhoor: cal.date(bySettingHour: 23, minute: 18, second: 40, of: day12)!,
                .prayer: cal.date(from: DateComponents(year: 2027, month: 1, day: 20, hour: 13, minute: 22, second: 30))!,
            ]
            for (i, scene) in Scene.allCases.enumerated() {
                let date = moments[scene]!
                let snap = try XCTUnwrap(PrayerSnapshot.make(ctx, at: date))
                let copy = Self.copy[city.lang]![scene]!
                let n = i + 1
                render(Poster(scene: scene, snap: snap, city: city, now: date, copy: copy, layout: .store),
                       CGSize(width: 440, height: 956), "store-\(city.lang)-\(n)-\(scene.rawValue)")
                render(Poster(scene: scene, snap: snap, city: city, now: date, copy: copy, layout: .story),
                       CGSize(width: 360, height: 640), "story-\(city.lang)-\(n)-\(scene.rawValue)")
                render(Poster(scene: scene, snap: snap, city: city, now: date, copy: copy, layout: .square),
                       CGSize(width: 360, height: 360), "square-\(city.lang)-\(n)-\(scene.rawValue)")
            }
        }
    }

    /// Renders at 3× so 440 pt → 1320 px and 360 pt → 1080 px.
    private func render<V: View>(_ view: V, _ size: CGSize, _ name: String) {
        let r = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        r.scale = 3
        r.isOpaque = true
        guard let image = r.uiImage, let png = image.pngData() else { return XCTFail("render failed: \(name)") }
        try? png.write(to: outDir.appendingPathComponent("\(name).png"))
        let a = XCTAttachment(image: image)
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}

// MARK: - Poster

private enum PosterLayout { case store, story, square }

private struct Poster: View {
    let scene: LockScreenPosterTests.Scene
    let snap: PrayerSnapshot
    let city: LockScreenRenderTests.City
    let now: Date
    let copy: LockScreenPosterTests.Copy
    let layout: PosterLayout

    private var rtl: Bool { city.lang == "ar" }

    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .top) {
                NightSky()
                VStack(spacing: 0) {
                    headline
                        .padding(.horizontal, layout == .square ? 22 : 28)
                        .padding(.top, layout == .store ? 70 : (layout == .story ? 34 : 22))
                    Spacer(minLength: 0)
                }
                // The phone sits below the headline; in the square it is cropped at the bottom.
                phone
                    .scaleEffect(phoneScale, anchor: .top)
                    .frame(width: 440 * phoneScale, height: 956 * phoneScale, alignment: .top)
                    .position(x: g.size.width / 2, y: phoneTop + 956 * phoneScale / 2)
            }
            .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
            .environment(\.locale, Locale(identifier: city.lang))
            .environment(\.colorScheme, .dark)
        }
    }

    private var phoneScale: CGFloat {
        switch layout {
        case .store: return 0.80
        case .story: return 0.50
        case .square: return 0.56
        }
    }

    private var phoneTop: CGFloat {
        switch layout {
        case .store: return 270
        case .story: return 162
        case .square: return 128
        }
    }

    private var headline: some View {
        VStack(spacing: layout == .square ? 6 : 10) {
            Text(copy.title)
                .font(rtl ? .custom("Amiri-Bold", size: titleSize * 1.05) : .system(size: titleSize, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(copy.subtitle)
                .font(.system(size: titleSize * 0.48, weight: .medium))
                .foregroundStyle(Color.noorGold)
        }
        .multilineTextAlignment(.center)
        .lineLimit(3)
        .minimumScaleFactor(0.5)
        // A fixed block above the phone: long titles (Arabic, French) shrink
        // to fit instead of running into the device.
        .frame(maxWidth: .infinity, maxHeight: headlineHeight, alignment: .center)
    }

    private var headlineHeight: CGFloat {
        switch layout {
        case .store: return 270 - 70 - 16
        case .story: return 162 - 34 - 12
        case .square: return 128 - 22 - 10
        }
    }

    private var titleSize: CGFloat {
        switch layout {
        case .store: return 38
        case .story: return 30
        case .square: return 24
        }
    }

    // MARK: Phone

    private var phone: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 68, style: .continuous).fill(.black)
            LockScreen(scene: scene, snap: snap, city: city, now: now)
                .frame(width: 440 - 24, height: 956 - 24)
                .clipShape(RoundedRectangle(cornerRadius: 58, style: .continuous))
            Capsule().fill(.black)
                .frame(width: 126, height: 37)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 24)
        }
        .frame(width: 440, height: 956)
        .shadow(color: .black.opacity(0.55), radius: 30, y: 18)
    }
}

/// The Lock Screen itself: date, inline widget, clock, widget row, Live Activity.
private struct LockScreen: View {
    let scene: LockScreenPosterTests.Scene
    let snap: PrayerSnapshot
    let city: LockScreenRenderTests.City
    let now: Date

    var body: some View {
        ZStack {
            NightSky(dense: true)
            VStack(spacing: 0) {
                statusBar
                inlineRow
                    .padding(.top, 34)
                Text(clock)
                    .font(.system(size: 104, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.95))
                    .environment(\.layoutDirection, .leftToRight)
                    .padding(.top, -6)
                widgetRow
                    .padding(.top, 8)
                Spacer()
                liveActivity
                    .padding(.horizontal, 12)
                bottomButtons
                    .padding(.top, 22)
                    .padding(.bottom, 26)
            }
        }
        .foregroundStyle(.white)
        .environment(\.frozenNow, now)
    }

    private var clock: String {
        let f = DateFormatter()
        f.dateFormat = city.hour12 ? "h:mm" : "HH:mm"
        return f.string(from: now)
    }

    private var dateLine: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: city.lang)
        f.setLocalizedDateFormatFromTemplate("EEEEdMMMM")
        return f.string(from: now)
    }

    private var statusBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "cellularbars")
                Image(systemName: "wifi")
                Image(systemName: "battery.100percent")
            }
            .font(.system(size: 14, weight: .semibold))
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .environment(\.layoutDirection, .leftToRight)
    }

    /// iOS puts the inline widget beside the date, above the clock.
    private var inlineRow: some View {
        HStack(spacing: 8) {
            Text(dateLine)
            Text("·").opacity(0.6)
            Group {
                if scene == .prayer {
                    NextPrayerView(snapshot: snap, family: .accessoryInline)
                } else {
                    RamadanWidgetView(snapshot: snap, family: .accessoryInline)
                }
            }
            .labelStyle(.titleAndIcon)
        }
        .font(.system(size: 18, weight: .semibold))
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var widgetRow: some View {
        HStack(spacing: 10) {
            switch scene {
            case .iftar:
                rect(RamadanWidgetView(snapshot: snap, family: .accessoryRectangular))
                rect(TodayPrayersView(snapshot: snap))
            case .suhoor:
                rect(RamadanWidgetView(snapshot: snap, family: .accessoryRectangular))
                circle(NextPrayerView(snapshot: snap, family: .accessoryCircular))
                circle(RamadanWidgetView(snapshot: snap, family: .accessoryCircular))
            case .prayer:
                circle(NextPrayerView(snapshot: snap, family: .accessoryCircular))
                circle(RamadanWidgetView(snapshot: snap, family: .accessoryCircular))
                rect(TodayPrayersView(snapshot: snap))
            }
        }
        .padding(.horizontal, 20)
    }

    private func rect<V: View>(_ v: V) -> some View {
        v.frame(width: 172, height: 76)
    }

    private func circle<V: View>(_ v: V) -> some View {
        ZStack {
            Circle().fill(.white.opacity(0.16))
            v
        }
        .frame(width: 76, height: 76)
    }

    private var liveActivity: some View {
        let state: PrayerActivityAttributes.ContentState
        if let f = snap.fasting, scene != .prayer {
            state = .init(title: snap.t(f.isIftar ? "ramadan.iftar" : "ramadan.suhoorEnds"),
                          subtitle: city.lang == "ar" ? "" : (f.isIftar ? "الإفطار" : "السحور"),
                          start: f.since, target: f.at,
                          symbol: f.isIftar ? "sunset.fill" : "moon.stars.fill",
                          lead: snap.t("home.in"), time: snap.clock(f.at))
        } else {
            state = .init(title: snap.name(snap.next.name), subtitle: city.lang == "ar" ? "" : snap.next.name.ar,
                          start: snap.since, target: snap.next.at, symbol: snap.next.name.systemImage,
                          lead: snap.t("home.in"), time: snap.clock(snap.next.at))
        }
        return PrayerActivityLockView(state: state, place: city.place)
            .background(Color.noorDeep.opacity(0.88), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    private var bottomButtons: some View {
        HStack {
            button("flashlight.off.fill")
            Spacer()
            button("camera.fill")
        }
        .padding(.horizontal, 46)
        .environment(\.layoutDirection, .leftToRight)
    }

    private func button(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 20, weight: .semibold))
            .frame(width: 50, height: 50)
            .background(Circle().fill(.white.opacity(0.18)))
    }
}

/// A night sky with a crescent: dark navy into dusk, deterministic stars.
private struct NightSky: View {
    var dense = false

    var body: some View {
        GeometryReader { g in
            ZStack {
                LinearGradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.14),
                                        Color(red: 0.08, green: 0.10, blue: 0.26),
                                        Color(red: 0.30, green: 0.17, blue: 0.28),
                                        Color(red: 0.62, green: 0.34, blue: 0.22)],
                               startPoint: .top, endPoint: .bottom)
                Canvas { ctx, size in
                    var seed: UInt64 = dense ? 7 : 3
                    func next() -> Double {
                        seed = seed &* 6364136223846793005 &+ 1442695040888963407
                        return Double(seed >> 33) / Double(UInt32.max)
                    }
                    for _ in 0..<(dense ? 140 : 90) {
                        let x = next() * size.width
                        let y = next() * size.height * 0.75
                        let r = 0.4 + next() * 1.3
                        ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                                 with: .color(.white.opacity(0.35 + next() * 0.6)))
                    }
                }
                if dense {
                Crescent()
                    .fill(Color(red: 1, green: 0.93, blue: 0.75))
                    .frame(width: g.size.width * 0.16, height: g.size.width * 0.16)
                    .shadow(color: Color(red: 1, green: 0.85, blue: 0.5).opacity(0.6), radius: 18)
                    .position(x: g.size.width * (dense ? 0.78 : 0.85), y: g.size.height * (dense ? 0.56 : 0.2))
                    .opacity(0.9)
                }
            }
        }
    }
}

private struct Crescent: Shape {
    func path(in rect: CGRect) -> Path {
        let outer = Path(ellipseIn: rect)
        let inner = Path(ellipseIn: rect.offsetBy(dx: rect.width * 0.32, dy: -rect.height * 0.12))
        return outer.subtracting(inner)
    }
}
