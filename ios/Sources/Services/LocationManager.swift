import Foundation
import CoreLocation
import Observation
import UIKit

/// Provides the user's coordinate and a human-readable place name.
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    var coordinate: CLLocationCoordinate2D?
    var placeName: String = ""
    var status: CLAuthorizationStatus = .notDetermined

    @ObservationIgnored private let manager = CLLocationManager()
    @ObservationIgnored private let geocoder = CLGeocoder()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        status = manager.authorizationStatus
    }

    var isAuthorized: Bool {
        status == .authorizedWhenInUse || status == .authorizedAlways
    }

    /// True once the user has actively declined. Only in this state may the app
    /// show an explanatory notice — anything shown before the system prompt has
    /// been answered would be a pre-permission prompt, which App Store Review
    /// rejects under guideline 5.1.1(iv).
    var isDenied: Bool {
        status == .denied || status == .restricted
    }

    func request() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }

    /// Sends the user to the app's own Settings page. Used only from the
    /// already-denied state, where iOS will not re-prompt.
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ m: CLLocationManager) {
        status = m.authorizationStatus
        if isAuthorized { m.requestLocation() }
    }

    func locationManager(_ m: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        coordinate = loc.coordinate
        geocoder.reverseGeocodeLocation(loc) { [weak self] placemarks, _ in
            guard let p = placemarks?.first else { return }
            let city = p.locality ?? p.administrativeArea ?? p.country ?? ""
            self?.placeName = city
        }
    }

    func locationManager(_ m: CLLocationManager, didFailWithError error: Error) {
        // Keep the last known coordinate; failures are transient.
    }
}
