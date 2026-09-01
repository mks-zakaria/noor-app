import Foundation
import CoreLocation
import Observation

/// Streams the device compass heading for the Qibla screen.
@Observable
final class QiblaManager: NSObject, CLLocationManagerDelegate {
    /// Device heading in degrees, clockwise from north.
    var heading: Double = 0
    /// Heading accuracy in degrees (negative means unavailable/invalid).
    var accuracy: Double = -1

    @ObservationIgnored private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.headingFilter = 1
    }

    var isAvailable: Bool { CLLocationManager.headingAvailable() }

    func start() {
        guard isAvailable else { return }
        manager.startUpdatingHeading()
    }

    func stop() {
        manager.stopUpdatingHeading()
    }

    func locationManager(_ m: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        accuracy = newHeading.headingAccuracy
    }
}
