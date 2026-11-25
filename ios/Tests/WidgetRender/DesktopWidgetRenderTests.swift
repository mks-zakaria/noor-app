import XCTest
import SwiftUI
import WidgetKit

/// Renders the prayer widget at Mac desktop sizes (small 170×170, medium 364×170, large 364×382 pt)
/// for London (en), Paris (fr) and Riyadh (ar) at a fixed moment, so the desktop layouts can be
/// checked without adding them to a desktop. PNGs go to $NOOR_DESKTOP_DIR.
final class DesktopWidgetRenderTests: XCTestCase {

    @MainActor
    func testRenderDesktopSizes() throws {
        let dir = ProcessInfo.processInfo.environment["NOOR_DESKTOP_DIR"] ?? NSTemporaryDirectory() + "noor-desktop"
        let out = URL(fileURLWithPath: dir)
        try FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
        defer { NSTimeZone.default = TimeZone.current }

        for city in LockScreenRenderTests.cities {
            let tz = TimeZone(identifier: city.tz)!
            NSTimeZone.default = tz
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = tz
            let ctx = SharedPrayerContext(lat: city.lat, lng: city.lng, method: city.method.rawValue,
                                          madhab: MadhabKey.shafi.rawValue, hour12: city.hour12,
                                          language: city.lang, place: city.place, hijriOffset: 0)
            let now = cal.date(from: DateComponents(year: 2027, month: 1, day: 20, hour: 13, minute: 22))!
            let snap = try XCTUnwrap(PrayerSnapshot.make(ctx, at: now))
            let sizes: [(WidgetFamily, CGSize, String)] = [
                (.systemSmall, CGSize(width: 170, height: 170), "small"),
                (.systemMedium, CGSize(width: 364, height: 170), "medium"),
                (.systemLarge, CGSize(width: 364, height: 382), "large"),
            ]
            for (family, size, name) in sizes {
                let view = NextPrayerView(snapshot: snap, family: family)
                    .environment(\.frozenNow, now)
                    .environment(\.layoutDirection, city.lang == "ar" ? .rightToLeft : .leftToRight)
                    .padding(16)
                    .frame(width: size.width, height: size.height)
                    // what containerBackground draws on the desktop (it does not render offscreen)
                    .background(LinearGradient(colors: [.noorDeep, .noorGreen], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .environment(\.colorScheme, .dark)
                let r = ImageRenderer(content: view)
                r.scale = Double(ProcessInfo.processInfo.environment["NOOR_DESKTOP_SCALE"] ?? "2") ?? 2
                guard let png = r.uiImage?.pngData() else { return XCTFail("render \(name) \(city.lang)") }
                try png.write(to: out.appendingPathComponent("\(city.lang)-\(name).png"))
            }
        }
    }
}
