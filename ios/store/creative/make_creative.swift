// App Store creative assets (iOS 27+): product page header (21:9) and search results image (3:2).
// Specs (App Store Connect › creative assets specifications):
//   header 3840×1646, art safe area 1646×661 at (1097, 493)
//   search 3840×2560, art safe area 2168×1030 at (836, 765)
//   no alpha, no logos, short localized text only, 4+ content.
//
//   swiftc -parse-as-library store/creative/make_creative.swift -o /tmp/noor-creative
//   /tmp/noor-creative Widget/Fonts/Amiri-Bold.ttf store/creative
import SwiftUI
import AppKit
import CoreText

struct Spec { let name: String; let size: CGSize; let safe: CGRect }
let header = Spec(name: "header", size: CGSize(width: 3840, height: 1646), safe: CGRect(x: 1097, y: 493, width: 1646, height: 661))
let search = Spec(name: "search", size: CGSize(width: 3840, height: 2560), safe: CGRect(x: 836, y: 765, width: 2168, height: 1030))

struct Copy { let code: String; let title: String; let line: String; let rtl: Bool }
let copies = [
    Copy(code: "en", title: "Never miss a prayer", line: "Prayer times · Quran · Adkar", rtl: false),
    Copy(code: "ar", title: "لا تفوّت صلاة", line: "مواقيت الصلاة · القرآن · الأذكار", rtl: true),
    Copy(code: "fr", title: "Ne manquez aucune prière", line: "Horaires · Coran · Adkar", rtl: false),
]

extension Color { init(_ hex: Int) { self.init(red: Double((hex >> 16) & 255) / 255, green: Double((hex >> 8) & 255) / 255, blue: Double(hex & 255) / 255) } }
let gold = Color(0xE0B85F), goldDeep = Color(0xC99A3B), ivory = Color(0xF6ECD4)

/// Eight-point star (two overlapping squares), the classic khatam.
struct Khatam: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: r.midX, y: r.midY), R = r.width / 2
        for k in 0..<16 {
            let a = Double(k) * .pi / 8 - .pi / 2
            let rad = k % 2 == 0 ? R : R * 0.72
            let pt = CGPoint(x: c.x + rad * cos(a), y: c.y + rad * sin(a))
            k == 0 ? p.move(to: pt) : p.addLine(to: pt)
        }
        p.closeSubpath(); return p
    }
}

/// Faint tiled pattern across the full bleed.
struct Pattern: View {
    let size: CGSize
    var body: some View {
        Canvas { ctx, s in
            let cell: CGFloat = 220
            var y: CGFloat = -cell / 2, row = 0
            while y < s.height + cell {
                var x: CGFloat = (row % 2 == 0 ? 0 : cell / 2) - cell / 2
                while x < s.width + cell {
                    let r = CGRect(x: x - cell * 0.32, y: y - cell * 0.32, width: cell * 0.64, height: cell * 0.64)
                    ctx.stroke(Khatam().path(in: r), with: .color(gold.opacity(0.10)), lineWidth: 3)
                    x += cell
                }
                y += cell * 0.5; row += 1
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

/// Pointed mihrab arch outline.
struct Arch: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let shoulder = r.minY + r.height * 0.42
        p.move(to: CGPoint(x: r.minX, y: r.maxY))
        p.addLine(to: CGPoint(x: r.minX, y: shoulder))
        p.addQuadCurve(to: CGPoint(x: r.midX, y: r.minY), control: CGPoint(x: r.minX, y: r.minY + r.height * 0.08))
        p.addQuadCurve(to: CGPoint(x: r.maxX, y: shoulder), control: CGPoint(x: r.maxX, y: r.minY + r.height * 0.08))
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        return p
    }
}

/// Gold crescent inside an arch — the emblem, not the app icon.
struct Emblem: View {
    let h: CGFloat
    var body: some View {
        let w = h * 0.68
        ZStack {
            Arch().fill(LinearGradient(colors: [Color(0x1B8A6B).opacity(0.55), Color(0x0A3D30).opacity(0.35)], startPoint: .top, endPoint: .bottom))
            Arch().stroke(LinearGradient(colors: [gold, goldDeep], startPoint: .top, endPoint: .bottom), lineWidth: h * 0.022)
            Arch().stroke(gold.opacity(0.35), lineWidth: h * 0.008).padding(h * 0.05)
            // crescent: disc minus offset disc
            Circle().fill(LinearGradient(colors: [ivory, gold], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: w * 0.46, height: w * 0.46)
                .mask(Canvas { ctx, s in
                    ctx.fill(Path(ellipseIn: CGRect(origin: .zero, size: s)), with: .color(.white))
                    ctx.blendMode = .destinationOut
                    ctx.fill(Path(ellipseIn: CGRect(x: s.width * 0.28, y: -s.height * 0.08, width: s.width, height: s.height)), with: .color(.white))
                })
                .shadow(color: gold.opacity(0.6), radius: h * 0.05)
                .offset(x: -w * 0.03, y: -h * 0.06)
            Khatam().fill(gold).frame(width: w * 0.12, height: w * 0.12).offset(x: w * 0.17, y: -h * 0.17)
        }
        .frame(width: w, height: h)
    }
}

struct KeyArt: View {
    let copy: Copy; let box: CGSize
    var body: some View {
        let h = box.height * 0.92
        let titleSize = min(box.height * 0.17, box.width * 0.062)
        HStack(spacing: box.width * 0.05) {
            Emblem(h: h)
            VStack(alignment: .leading, spacing: titleSize * 0.35) {
                Text(copy.title)
                    .font(copy.rtl ? .custom("Amiri-Bold", size: titleSize * 1.25) : .system(size: titleSize, weight: .bold))
                    .foregroundStyle(.white)
                Capsule().fill(gold).frame(width: titleSize * 1.6, height: titleSize * 0.09)
                Text(copy.line)
                    .font(copy.rtl ? .custom("Amiri-Bold", size: titleSize * 0.62) : .system(size: titleSize * 0.5, weight: .medium))
                    .foregroundStyle(ivory.opacity(0.92))
            }
            .lineLimit(1).minimumScaleFactor(0.5)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: box.width * 0.62, alignment: .leading)
            .shadow(color: .black.opacity(0.3), radius: titleSize * 0.1, y: titleSize * 0.04)
        }
        .environment(\.layoutDirection, copy.rtl ? .rightToLeft : .leftToRight)
        .frame(width: box.width, height: box.height)
    }
}

struct Asset: View {
    let spec: Spec; let copy: Copy; let showSafe: Bool
    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(colors: [Color(0x2F8F72), Color(0x0F6B53), Color(0x08392D)], startPoint: .top, endPoint: .bottom)
                .frame(width: spec.size.width, height: spec.size.height)
            Pattern(size: spec.size)
            // soft light behind the emblem, dark falloff at the edges
            RadialGradient(colors: [gold.opacity(0.16), .clear], center: UnitPoint(x: spec.safe.midX / spec.size.width, y: spec.safe.midY / spec.size.height),
                           startRadius: 0, endRadius: spec.safe.width * 0.7)
            RadialGradient(colors: [.clear, .black.opacity(0.32)], center: .center, startRadius: spec.safe.width * 0.55, endRadius: spec.size.width * 0.62)
            KeyArt(copy: copy, box: spec.safe.size).offset(x: spec.safe.minX, y: spec.safe.minY)
            if showSafe {
                Rectangle().stroke(Color.red, lineWidth: 8)
                    .frame(width: spec.safe.width, height: spec.safe.height)
                    .offset(x: spec.safe.minX, y: spec.safe.minY)
            }
        }
        .frame(width: spec.size.width, height: spec.size.height, alignment: .topLeading)
        .clipped()
        .environment(\.layoutDirection, .leftToRight)
    }
}

/// Flatten onto an opaque RGB bitmap — Apple rejects alpha.
func opaquePNG(_ cg: CGImage) -> Data {
    let ctx = CGContext(data: nil, width: cg.width, height: cg.height, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    ctx.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
    return NSBitmapImageRep(cgImage: ctx.makeImage()!).representation(using: .png, properties: [:])!
}

@main
struct MakeCreative {
    @MainActor static func main() {
        let a = CommandLine.arguments
        CTFontManagerRegisterFontsForURL(URL(fileURLWithPath: a[1]) as CFURL, .process, nil)
        try? FileManager.default.createDirectory(atPath: a[2] + "/preview", withIntermediateDirectories: true)
        for spec in [header, search] {
            for copy in copies {
                for safe in [false, true] {
                    let r = ImageRenderer(content: Asset(spec: spec, copy: copy, showSafe: safe))
                    r.scale = 1
                    guard let cg = r.cgImage else { print("render failed"); exit(1) }
                    let out = safe ? "\(a[2])/preview/\(spec.name)-\(copy.code)-safe.png" : "\(a[2])/\(spec.name)-\(copy.code).png"
                    try! opaquePNG(cg).write(to: URL(fileURLWithPath: out))
                    print(out, cg.width, cg.height)
                }
            }
        }
    }
}
