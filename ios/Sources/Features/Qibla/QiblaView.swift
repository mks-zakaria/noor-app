import SwiftUI

struct QiblaView: View {
    @Environment(LocationManager.self) private var location
    @Environment(LocalizationManager.self) private var loc
    @State private var compass = QiblaManager()

    private var qiblaBearing: Double? {
        guard let c = location.coordinate else { return nil }
        return PrayerService.qiblaBearing(lat: c.latitude, lng: c.longitude)
    }

    /// Angle (device-relative) at which the Kaaba sits: rotate the needle by this.
    private var relativeAngle: Double {
        guard let q = qiblaBearing else { return 0 }
        return (q - compass.heading)
    }

    private var isAligned: Bool {
        let diff = abs((relativeAngle.truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360))
        return diff < 5 || diff > 355
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.four) {
                if let q = qiblaBearing {
                    Text(loc.t("qibla.instruction"))
                        .font(.subheadline)
                        .foregroundStyle(Palette.textSecondary)
                        .multilineTextAlignment(.center)

                    compassDial

                    VStack(spacing: Spacing.one) {
                        Text("\(Int(q.rounded()))° \(loc.t("qibla.fromNorth"))")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(Palette.text)
                        Text(isAligned ? loc.t("qibla.aligned") : loc.t("qibla.turn"))
                            .font(.subheadline)
                            .foregroundStyle(isAligned ? Palette.primary : Palette.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    if !compass.isAvailable {
                        Text(loc.t("qibla.noCompass"))
                            .font(.footnote)
                            .foregroundStyle(Palette.danger)
                    }
                } else if location.isDenied {
                    // `actions:` keeps the button attached to the message. As a
                    // sibling view it drifted to the bottom of the screen, far
                    // from the text explaining what it is for.
                    ContentUnavailableView {
                        Label(loc.t("qibla.locationOff"), systemImage: "location.slash")
                    } description: {
                        Text(loc.t("qibla.locationOffDesc"))
                    } actions: {
                        Button(loc.t("common.openSettings")) { location.openSettings() }
                            .buttonStyle(.borderedProminent)
                    }
                } else if !location.isAuthorized {
                    LocationIntroCard()
                } else {
                    ProgressView()
                }
            }
            .padding(Spacing.four)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .noorBackground()
            .navigationTitle(loc.t("qibla.title"))
            // First prompt comes from Continue, not from appearing on screen.
            .onAppear { if location.isAuthorized { location.request() }; compass.start() }
            .onDisappear { compass.stop() }
        }
    }

    private var compassDial: some View {
        ZStack {
            Circle()
                .fill(Palette.card)
                .overlay(Circle().stroke(Palette.border, lineWidth: 2))

            // Cardinal ticks rotate opposite to the device heading.
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(Palette.border)
                    .frame(width: 2, height: i % 3 == 0 ? 16 : 8)
                    .offset(y: -130)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            .rotationEffect(.degrees(-compass.heading))

            Text("N")
                .font(.caption.weight(.bold))
                .foregroundStyle(Palette.textSecondary)
                .offset(y: -108)
                .rotationEffect(.degrees(-compass.heading))

            // Kaaba needle
            VStack(spacing: 4) {
                Image(systemName: "location.north.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(isAligned ? Palette.primary : Palette.accent)
                Image(systemName: "cube.fill")
                    .font(.title2)
                    .foregroundStyle(Palette.primary)
            }
            .offset(y: -30)
            .rotationEffect(.degrees(relativeAngle))
            .animation(.easeOut(duration: 0.15), value: relativeAngle)
        }
        .frame(width: 280, height: 280)
    }
}
