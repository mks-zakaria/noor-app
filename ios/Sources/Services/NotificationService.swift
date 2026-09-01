import Foundation
import UserNotifications

/// Schedules local notifications for upcoming prayer times.
enum NotificationService {
    static let adhanSoundFile = "adhan_notif.wav"

    /// Local hours at which the daily adkar reminders fire (morning, evening).
    /// Kept in sync with `AdkarProgressStore` so fired reminders can be reconciled.
    static let adkarReminderHours = [7, 19]

    static func requestAuthorization(critical: Bool = false) async -> Bool {
        let center = UNUserNotificationCenter.current()
        var options: UNAuthorizationOptions = [.alert, .sound, .badge]
        if critical { options.insert(.criticalAlert) }
        return (try? await center.requestAuthorization(options: options)) ?? false
    }

    /// Builds the notification sound. `critical` requests bypass of silent/Focus
    /// (only effective with the critical-alerts entitlement + user grant).
    private static func sound(adhan: Bool, critical: Bool) -> UNNotificationSound {
        let name = UNNotificationSoundName(adhanSoundFile)
        if critical {
            return adhan ? .criticalSoundNamed(name, withAudioVolume: 1.0) : .defaultCritical
        }
        return adhan ? UNNotificationSound(named: name) : .default
    }

    static func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    /// Clears and reschedules prayer notifications for the next `days` days.
    static func reschedule(
        lat: Double, lng: Double,
        method: MethodKey, madhab: MadhabKey,
        hour12: Bool,
        enabled: Set<String>,
        adhanSound: Bool,
        critical: Bool,
        langCode: String = "en",
        days: Int = 10   // 5 prayers × 10 = 50 pending, under iOS's 64-notification limit
    ) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let cal = Calendar.current
        let now = Date()
        let sound = sound(adhan: adhanSound, critical: critical)

        for offset in 0..<days {
            guard let day = cal.date(byAdding: .day, value: offset, to: now),
                  let times = PrayerService.computeTimes(lat: lat, lng: lng, method: method, madhab: madhab, date: day)
            else { continue }

            for name in prayerOrder where name.isPrayer && enabled.contains(name.rawValue) {
                guard let at = times[name], at > now else { continue }

                let content = UNMutableNotificationContent()
                let localized = name.label(langCode)
                content.title = langCode == "ar" ? localized : "\(localized) — \(name.ar)"
                content.body = "\(Strings.t("notif.body", langCode)) \(localized). حَيَّ عَلَى الصَّلَاة"
                content.sound = sound
                if critical { content.interruptionLevel = .critical }

                let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: at)
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let id = "noor.\(name.rawValue).\(offset)"
                center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
            }
        }
    }

    /// Two repeating daily reminders (morning & evening) nudging the user to do adkar.
    /// Each uses one pending slot regardless of how far ahead it repeats.
    static func scheduleAdkarReminders(langCode: String = "en") {
        let center = UNUserNotificationCenter.current()
        let bodies = ["notif.adkarMorning", "notif.adkarEvening"]
        for (i, hour) in adkarReminderHours.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = Strings.t("notif.adkarTitle", langCode)
            content.body = Strings.t(bodies[min(i, bodies.count - 1)], langCode)
            content.sound = .default

            var comps = DateComponents()
            comps.hour = hour
            comps.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
            center.add(UNNotificationRequest(identifier: "noor.adkar.\(i)", content: content, trigger: trigger))
        }
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    /// Fires a one-off notification in ~5s so the user can confirm the adhan/sound works.
    static func sendTest(adhanSound: Bool, critical: Bool = false, langCode: String = "en") {
        let content = UNMutableNotificationContent()
        content.title = Strings.t("notif.testTitle", langCode)
        content.body = Strings.t("notif.testBody", langCode)
        content.sound = sound(adhan: adhanSound, critical: critical)
        if critical { content.interruptionLevel = .critical }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: "noor.test", content: content, trigger: trigger)
        )
    }

    /// Convenience: (re)schedule from current settings + location if enabled and authorized.
    static func refresh(settings: SettingsStore, location: LocationManager, langCode: String = "en") {
        guard settings.notificationsEnabled, let c = location.coordinate else { return }
        reschedule(
            lat: c.latitude, lng: c.longitude,
            method: settings.method, madhab: settings.madhab,
            hour12: settings.hour12,
            enabled: settings.enabledPrayers,
            adhanSound: settings.adhanSound,
            critical: settings.criticalAdhan,
            langCode: langCode
        )
        // reschedule() cleared all pending requests, so re-add the adkar reminders.
        if settings.adkarReminders {
            scheduleAdkarReminders(langCode: langCode)
        }
    }
}

/// Lets notifications present as banners while the app is in the foreground.
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}
