import Foundation
import CoreLocation
import Observation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Provides the user's coordinate and a human-readable place name.
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    var coordinate: CLLocationCoordinate2D?
    var placeName: String = ""
    /// ISO country code of the current place (kept between launches), used to pick the
    /// official calculation method.
    var countryCode: String = UserDefaults.standard.string(forKey: "noor.countryCode") ?? "" {
        didSet { UserDefaults.standard.set(countryCode, forKey: "noor.countryCode") }
    }
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
        #if os(iOS)
        status == .authorizedWhenInUse || status == .authorizedAlways
        #else
        status == .authorized || status == .authorizedAlways
        #endif
    }

    /// True once the user has actively declined. Only in this state may the app
    /// show an explanatory notice — anything shown before the system prompt has
    /// been answered would be a pre-permission prompt, which App Store Review
    /// rejects under guideline 5.1.1(iv).
    var isDenied: Bool {
        status == .denied || status == .restricted
    }

    func request() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            #if os(iOS)
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            }
            #else
            if status == .authorized || status == .authorizedAlways {
                manager.requestLocation()
            }
            #endif
        }
    }

    /// Sends the user to the app's own Settings page. Used only from the
    /// already-denied state, where iOS will not re-prompt.
    func openSettings() {
#if os(iOS)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
#else
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices") {
            NSWorkspace.shared.open(url)
        }
#endif
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
            if let cc = p.isoCountryCode, !cc.isEmpty { self?.countryCode = cc }
        }
    }

    func locationManager(_ m: CLLocationManager, didFailWithError error: Error) {
        // Keep the last known coordinate; failures are transient.
    }
}
