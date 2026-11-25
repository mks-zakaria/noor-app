import CoreText
import SwiftUI
import WidgetKit
import XCTest

/// Renders the Lock Screen widgets and the Live Activity banner to transparent
/// PNGs at fixed, realistic moments, for store screenshots and ads.
/// `tools/make_lockscreen.py` composes them onto Lock Screen backgrounds.
///
///     TEST_RUNNER_NOOR_WIDGET_DIR=/abs/dir xcodebuild test -scheme Noor \
///       -destination 'id=<iPhone sim>' -only-testing:NoorWidgetRender
@MainActor
final class LockScreenRenderTests: XCTestCase {

    struct City {
        let lang: String
        let tz: String
        let lat: Double, lng: Double
        let method: MethodKey
        let hour12: Bool
        let place: String
    }

    static let cities = [
        City(lang: "en", tz: "Europe/London", lat: 51.5074, lng: -0.1278, method: .moonsightingCommittee, hour12: true, place: "London"),
        City(lang: "fr", tz: "Europe/Paris", lat: 48.8566, lng: 2.3522, method: .muslimWorldLeague, hour12: false, place: "Paris"),
        City(lang: "ar", tz: "Asia/Riyadh", lat: 24.7136, lng: 46.6753, method: .ummAlQura, hour12: true, place: "الرياض"),
    ]

    private var outDir: URL!

    override func setUpWithError() throws {
        let dir = ProcessInfo.processInfo.environment["NOOR_WIDGET_DIR"] ?? NSTemporaryDirectory() + "noor-widgets"
        outDir = URL(fileURLWithPath: dir)
        try FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)
        for name in ["Amiri-Regular", "Amiri-Bold"] {
            if let url = Bundle(for: Self.self).url(forResource: name, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }
        }
    }

    override func tearDown() {
        NSTimeZone.default = TimeZone.current
    }

    func testRenderLockScreenWidgets() throws {
        for city in Self.cities {
            let tz = TimeZone(identifier: city.tz)!
            NSTimeZone.default = tz
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = tz

            let ctx = SharedPrayerContext(lat: city.lat, lng: city.lng, method: city.method.rawValue,
                                          madhab: MadhabKey.shafi.rawValue, hour12: city.hour12,
                                          language: city.lang, place: city.place, hijriOffset: 0)
            let ramadan = try XCTUnwrap(RamadanService.info(year: 1448, offset: 0))
            let day12 = cal.date(byAdding: .day, value: 11, to: ramadan.start)!
            let moments: [(String, Date)] = [
                ("ramadan-day", cal.date(bySettingHour: 15, minute: 47, second: 12, of: day12)!),
                ("ramadan-night", cal.date(bySettingHour: 23, minute: 18, second: 40, of: day12)!),
                ("everyday", cal.date(from: DateComponents(year: 2027, month: 1, day: 20, hour: 13, minute: 22, second: 30))!),
            ]

            for (name, date) in moments {
                let snap = try XCTUnwrap(PrayerSnapshot.make(ctx, at: date), "\(city.lang) \(name)")
                let tag = "\(city.lang)-\(name)"
                save(NextPrayerView(snapshot: snap, family: .accessoryCircular), CGSize(width: 76, height: 76), "circular-next-\(tag)", city, date, circle: true)
                save(RamadanWidgetView(snapshot: snap, family: .accessoryCircular), CGSize(width: 76, height: 76), "circular-ramadan-\(tag)", city, date, circle: true)
                save(NextPrayerView(snapshot: snap, family: .accessoryRectangular), CGSize(width: 172, height: 76), "rect-next-\(tag)", city, date)
                save(RamadanWidgetView(snapshot: snap, family: .accessoryRectangular), CGSize(width: 172, height: 76), "rect-ramadan-\(tag)", city, date)
                save(TodayPrayersView(snapshot: snap), CGSize(width: 172, height: 76), "rect-today-\(tag)", city, date)
                save(NextPrayerView(snapshot: snap, family: .accessoryInline), CGSize(width: 260, height: 24), "inline-next-\(tag)", city, date)
                save(RamadanWidgetView(snapshot: snap, family: .accessoryInline), CGSize(width: 260, height: 24), "inline-ramadan-\(tag)", city, date)
                saveLiveActivity(snap, city, date, tag)
            }
        }
    }

    // MARK: Rendering

    private func save<V: View>(_ view: V, _ size: CGSize, _ name: String, _ city: City, _ date: Date, circle: Bool = false) {
        let content = ZStack {
            // The Lock Screen draws a translucent disc behind circular widgets.
            if circle { Circle().fill(.white.opacity(0.16)) }
            view
        }
        .frame(width: size.width, height: size.height)
        .foregroundStyle(.white)
        .tint(.white)
        .environment(\.colorScheme, .dark)
        .environment(\.frozenNow, date)
        .environment(\.layoutDirection, city.lang == "ar" ? .rightToLeft : .leftToRight)
        .environment(\.locale, Locale(identifier: city.lang))
        write(content, name)
    }

    private func saveLiveActivity(_ s: PrayerSnapshot, _ city: City, _ date: Date, _ tag: String) {
        let state: PrayerActivityAttributes.ContentState
        if let f = s.fasting {
            state = .init(title: s.t(f.isIftar ? "ramadan.iftar" : "ramadan.suhoorEnds"),
                          subtitle: f.isIftar ? "الإفطار" : "السحور", start: f.since, target: f.at,
                          symbol: f.isIftar ? "sunset.fill" : "moon.stars.fill",
                          lead: s.t("home.in"), time: s.clock(f.at))
        } else {
            state = .init(title: s.name(s.next.name), subtitle: s.next.name.ar, start: s.since, target: s.next.at,
                          symbol: s.next.name.systemImage, lead: s.t("home.in"), time: s.clock(s.next.at))
        }
        var shown = state
        if city.lang == "ar" { shown.subtitle = "" }   // the title is already Arabic
        let view = PrayerActivityLockView(state: shown, place: city.place)
            .frame(width: 408)
            .background(Color.noorDeep.opacity(0.92), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
            .environment(\.colorScheme, .dark)
            .environment(\.frozenNow, date)
            .environment(\.layoutDirection, city.lang == "ar" ? .rightToLeft : .leftToRight)
        write(view, "live-\(tag)")
    }

    private func write<V: View>(_ view: V, _ name: String) {
        let r = ImageRenderer(content: view)
        r.scale = 3
        r.isOpaque = false
        guard let image = r.uiImage, let png = image.pngData() else {
            XCTFail("render failed: \(name)")
            return
        }
        try? png.write(to: outDir.appendingPathComponent("\(name).png"))
        let a = XCTAttachment(image: image)
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}
