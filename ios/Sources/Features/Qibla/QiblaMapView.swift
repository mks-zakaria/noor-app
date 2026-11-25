import SwiftUI
import MapKit

/// Qibla without the compass: the great-circle line from the user to the Kaaba, drawn on
/// a map turned so the Qibla points to the top of the screen. Streets and buildings then
/// show the direction, which still works when the magnetometer is off (metal, magnets,
/// a phone case) or missing.
struct QiblaMapView: View {
    let origin: CLLocationCoordinate2D
    /// Bearing to the Kaaba in degrees from true north (PrayerService.qiblaBearing).
    let bearing: Double
    /// true on the Mac, where the map is the Qibla tab itself (no compass): no sheet chrome.
    var embedded = false

    @Environment(LocalizationManager.self) private var loc
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition

    static let kaaba = CLLocationCoordinate2D(latitude: 21.422487, longitude: 39.826206)

    init(origin: CLLocationCoordinate2D, bearing: Double, embedded: Bool = false) {
        self.origin = origin
        self.bearing = bearing
        self.embedded = embedded
        _position = State(initialValue: .camera(Self.camera(origin: origin, bearing: bearing)))
    }

    /// Close enough to see the street, rotated so the Qibla is "up".
    /// On the Mac (no compass, nothing to turn) the map stays north-up, a little wider, and the
    /// line carries the direction.
    static func camera(origin: CLLocationCoordinate2D, bearing: Double) -> MapCamera {
        #if os(macOS)
        MapCamera(centerCoordinate: origin, distance: 3000, heading: 0, pitch: 0)
        #else
        MapCamera(centerCoordinate: origin, distance: 1200, heading: bearing, pitch: 0)
        #endif
    }

    #if os(macOS)
    static let hintKey = "qibla.mapHintMac"
    #else
    static let hintKey = "qibla.mapHint"
    #endif

    /// Great-circle distance to the Kaaba, in kilometres.
    static func distanceKm(from origin: CLLocationCoordinate2D) -> Double {
        CLLocation(latitude: origin.latitude, longitude: origin.longitude)
            .distance(from: CLLocation(latitude: kaaba.latitude, longitude: kaaba.longitude)) / 1000
    }

    var body: some View {
        if embedded {
            map.navigationTitle(loc.t("qibla.title"))
        } else {
            NavigationStack {
                map
                    .navigationTitle(loc.t("qibla.title"))
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(loc.t("common.done")) { dismiss() }
                        }
                    }
            }
        }
    }

    private var map: some View {
            Map(position: $position) {
                MapPolyline(coordinates: [origin, Self.kaaba], contourStyle: .geodesic)
                    .stroke(Palette.primary, lineWidth: 5)
                Marker(loc.t("qibla.mapYou"), systemImage: "person.fill", coordinate: origin)
                    .tint(Palette.accent)
                Marker(loc.t("qibla.mapKaaba"), systemImage: "cube.fill", coordinate: Self.kaaba)
                    .tint(Palette.primary)
            }
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: Spacing.one) {
                    Text(loc.t(Self.hintKey))
                        .font(.subheadline)
                        .foregroundStyle(Palette.text)
                        .multilineTextAlignment(.center)
                    Text(String(format: loc.t("qibla.mapDistance"),
                                Int(Self.distanceKm(from: origin).rounded()), Int(bearing.rounded())))
                        .font(.footnote.monospacedDigit())
                        .foregroundStyle(Palette.textSecondary)
                    HStack(spacing: Spacing.four) {
                        Button(loc.t("qibla.mapRecenter")) {
                            withAnimation { position = .camera(Self.camera(origin: origin, bearing: bearing)) }
                        }
                        Button(loc.t("qibla.mapRoute")) {
                            withAnimation { position = .automatic }   // frames you, the line and the Kaaba
                        }
                    }
                    .font(.footnote)
                }
                .padding(Spacing.three)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
    }
}
