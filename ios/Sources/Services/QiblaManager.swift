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

    /// How far the compass can be trusted right now. Wrong-Qibla complaints are common in
    /// prayer apps, and most come from an uncalibrated magnetometer, not from the bearing.
    enum Quality: Equatable {
        /// No reading yet.
        case unknown
        case good
        /// Off by more than `Quality.maxGoodError` degrees: calibrate before trusting it.
        case weak

        /// Above this error the needle can point at the wrong wall of a room.
        static let maxGoodError: Double = 15

        static func from(accuracy: Double) -> Quality {
            if accuracy < 0 { return .unknown }
            return accuracy <= maxGoodError ? .good : .weak
        }
    }

    var quality: Quality { .from(accuracy: accuracy) }

    func start() {
        guard isAvailable else { return }
        manager.startUpdatingHeading()
    }

    func stop() {
        #if os(iOS)
        manager.stopUpdatingHeading()
        #endif
    }

    func locationManager(_ m: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        accuracy = newHeading.headingAccuracy
    }
}
