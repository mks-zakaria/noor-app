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

    @Environment(LocalizationManager.self) private var loc
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition

    static let kaaba = CLLocationCoordinate2D(latitude: 21.422487, longitude: 39.826206)

    init(origin: CLLocationCoordinate2D, bearing: Double) {
        self.origin = origin
        self.bearing = bearing
        _position = State(initialValue: .camera(Self.camera(origin: origin, bearing: bearing)))
    }

    /// Close enough to see the street, rotated so the Qibla is "up".
    static func camera(origin: CLLocationCoordinate2D, bearing: Double) -> MapCamera {
        MapCamera(centerCoordinate: origin, distance: 1200, heading: bearing, pitch: 0)
    }

    /// Great-circle distance to the Kaaba, in kilometres.
    static func distanceKm(from origin: CLLocationCoordinate2D) -> Double {
        CLLocation(latitude: origin.latitude, longitude: origin.longitude)
            .distance(from: CLLocation(latitude: kaaba.latitude, longitude: kaaba.longitude)) / 1000
    }

    var body: some View {
        NavigationStack {
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
                    Text(loc.t("qibla.mapHint"))
                        .font(.subheadline)
                        .foregroundStyle(Palette.text)
                        .multilineTextAlignment(.center)
                    Text(String(format: loc.t("qibla.mapDistance"),
                                Int(Self.distanceKm(from: origin).rounded()), Int(bearing.rounded())))
                        .font(.footnote.monospacedDigit())
                        .foregroundStyle(Palette.textSecondary)
                    Button(loc.t("qibla.mapRecenter")) {
                        withAnimation { position = .camera(Self.camera(origin: origin, bearing: bearing)) }
                    }
                    .font(.footnote)
                }
                .padding(Spacing.three)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
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
