import Foundation
import UserNotifications
#if os(iOS)
import BackgroundTasks
#endif

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

    /// Everything the scheduler needs, gathered from the stores in `refresh`.
    struct Inputs {
        var lat: Double
        var lng: Double
        var method: MethodKey
        var madhab: MadhabKey
        var hour12: Bool
        var enabledPrayers: Set<String>
        var adhanSound: Bool
        var critical: Bool
        var langCode: String
        var hijriOffset: Int
        var suhoorReminder: Bool
        var suhoorLeadMinutes: Int
        var iftarAlert: Bool
        var qadrReminders: Bool
    }

    /// Category of prayer alerts; carries the "Prayed ✓" action.
    static let prayerCategory = "noor.prayer"
    static let prayedAction = "noor.prayed"

    /// Clears and reschedules every one-shot alert (prayers, suhoor, iftar,
    /// Laylat al-Qadr) for the coming days, keeping the nearest ones within
    /// iOS's 64-pending limit via `NotificationPlanner`.
    static func reschedule(_ input: Inputs, repeatingSlots: Int, now: Date = Date(), days: Int = 10) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        registerCategories(langCode: input.langCode)

        let lang = input.langCode
        let cal = Calendar.current
        let prayerSound = sound(adhan: input.adhanSound, critical: input.critical)
        let ramadan = RamadanService.currentOrNext(now: now, offset: input.hijriOffset)
        var candidates: [NotificationPlanner.Candidate] = []

        for offset in 0..<days {
            guard let day = cal.date(byAdding: .day, value: offset, to: now),
                  let times = PrayerService.computeTimes(lat: input.lat, lng: input.lng,
                                                         method: input.method, madhab: input.madhab, date: day)
            else { continue }
            let ramadanDay = ramadan?.day(of: day)
            let dayKey = PrayerLogStore.key(day)

            for name in prayerOrder where name.isPrayer && input.enabledPrayers.contains(name.rawValue) {
                guard let at = times[name], at > now else { continue }
                let content = UNMutableNotificationContent()
                let localized = name.label(lang)
                if name == .maghrib, ramadanDay != nil, input.iftarAlert {
                    content.title = Strings.t("notif.iftarTitle", lang)
                    content.body = Strings.t("notif.iftarBody", lang)
                } else {
                    content.title = lang == "ar" ? localized : "\(localized) — \(name.ar)"
                    content.body = "\(Strings.t("notif.body", lang)) \(localized). حَيَّ عَلَى الصَّلَاة"
                }
                content.sound = prayerSound
                if input.critical { content.interruptionLevel = .critical }
                content.categoryIdentifier = prayerCategory
                content.userInfo = ["prayer": name.rawValue, "day": dayKey]
                candidates.append(.init(id: "noor.\(name.rawValue).\(offset)", date: at,
                                        priority: 0, content: content))
            }

            guard let rd = ramadanDay else { continue }
            if input.suhoorReminder, let fajr = times[.fajr] {
                let at = fajr.addingTimeInterval(TimeInterval(-input.suhoorLeadMinutes * 60))
                if at > now {
                    let content = UNMutableNotificationContent()
                    content.title = Strings.t("notif.suhoorTitle", lang)
                    content.body = String(format: Strings.t("notif.suhoorBody", lang), input.suhoorLeadMinutes,
                                          fajr.timeString(hour12: input.hour12))
                    content.sound = .default
                    candidates.append(.init(id: "noor.suhoor.\(offset)", date: at, priority: 1, content: content))
                }
            }
            // The odd nights of the last ten begin at maghrib of days 20, 22, 24, 26, 28.
            if input.qadrReminders, [20, 22, 24, 26, 28].contains(rd), let isha = times[.isha], isha > now {
                let content = UNMutableNotificationContent()
                content.title = Strings.t("notif.qadrTitle", lang)
                content.body = String(format: Strings.t("notif.qadrBody", lang), rd + 1)
                content.sound = .default
                candidates.append(.init(id: "noor.qadr.\(rd)", date: isha.addingTimeInterval(30 * 60),
                                        priority: 2, content: content))
            }
        }

        // One slot is kept for the "open Noor" alert that follows the last scheduled one.
        let selected = NotificationPlanner.select(candidates, limit: NotificationPlanner.limit - repeatingSlots - 1)
        for c in selected {
            let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: c.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            center.add(UNNotificationRequest(identifier: c.id, content: c.content, trigger: trigger))
        }
        if let at = NotificationPlanner.keepAliveDate(after: selected) {
            let content = UNMutableNotificationContent()
            content.title = Strings.t("notif.keepAliveTitle", lang)
            content.body = Strings.t("notif.keepAliveBody", lang)
            content.sound = .default
            let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: at)
            center.add(UNNotificationRequest(identifier: NotificationPlanner.keepAliveID, content: content,
                                             trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)))
        }
    }

    /// The "Prayed ✓" action on prayer alerts. Runs in the background: no app launch.
    static func registerCategories(langCode: String) {
        let prayed = UNNotificationAction(identifier: prayedAction,
                                          title: Strings.t("notif.prayedAction", langCode),
                                          options: [])
        let category = UNNotificationCategory(identifier: prayerCategory, actions: [prayed],
                                              intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    /// A repeating daily reminder for the khatmah portion (one pending slot).
    static func scheduleKhatmahReminder(minutes: Int, langCode: String) {
        let content = UNMutableNotificationContent()
        content.title = Strings.t("notif.khatmahTitle", langCode)
        content.body = Strings.t("notif.khatmahBody", langCode)
        content.sound = .default
        var comps = DateComponents()
        comps.hour = minutes / 60
        comps.minute = minutes % 60
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: "noor.khatmah", content: content, trigger: trigger))
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
    /// Also publishes the prayer context the widgets compute from.
    static func refresh(settings: SettingsStore, location: LocationManager, langCode: String = "en") {
        PrayerContextSync.push(settings: settings, location: location, langCode: langCode)
        guard let c = location.coordinate else { return }
        refresh(settings: settings, lat: c.latitude, lng: c.longitude, langCode: langCode)
    }

    /// Background App Refresh entry point. There is no GPS fix in the background, so it
    /// uses the last coordinate the app saved for the widgets. Without it, alerts would
    /// stop once the ~10-day window runs out for anyone who never opens the app.
    /// Returns false when there is nothing saved yet.
    @discardableResult
    static func refreshFromSavedContext() -> Bool {
        guard let ctx = SharedPrayerContext.load() else { return false }
        refresh(settings: SettingsStore(), lat: ctx.lat, lng: ctx.lng, langCode: LocalizationManager().code)
        return true
    }

    private static func refresh(settings: SettingsStore, lat: Double, lng: Double, langCode: String) {
        guard settings.notificationsEnabled else { return }
        let khatmahMinutes = KhatmahStore.activeReminderMinutes()
        let repeating = (settings.adkarReminders ? adkarReminderHours.count : 0) + (khatmahMinutes == nil ? 0 : 1)
        reschedule(
            Inputs(
                lat: lat, lng: lng,
                method: settings.method, madhab: settings.madhab,
                hour12: settings.hour12,
                enabledPrayers: settings.enabledPrayers,
                adhanSound: settings.adhanSound,
                critical: settings.criticalAdhan,
                langCode: langCode,
                hijriOffset: settings.hijriOffset,
                suhoorReminder: settings.suhoorReminder,
                suhoorLeadMinutes: settings.suhoorLeadMinutes,
                iftarAlert: settings.iftarAlert,
                qadrReminders: settings.qadrReminders
            ),
            repeatingSlots: repeating
        )
        // reschedule() cleared all pending requests, so re-add the repeating reminders.
        if settings.adkarReminders {
            scheduleAdkarReminders(langCode: langCode)
        }
        if let m = khatmahMinutes {
            scheduleKhatmahReminder(minutes: m, langCode: langCode)
        }
    }
}

/// Lets notifications present as banners while the app is in the foreground,
/// and handles the "Prayed ✓" action.
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }

    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        guard response.actionIdentifier == NotificationService.prayedAction else { return }
        let info = response.notification.request.content.userInfo
        guard let raw = info["prayer"] as? String, let prayer = PrayerName(rawValue: raw) else { return }
        PrayerLogStore.shared.set(.onTime, prayer, on: response.notification.date)
    }
}

/// Picks which one-shot alerts fit in iOS's pending-notification limit.
enum NotificationPlanner {
    /// iOS keeps at most 64 pending requests; leave a little headroom.
    static let limit = 60

    struct Candidate {
        let id: String
        let date: Date
        /// Lower wins on a tie: prayers (0) before suhoor (1) before reminders (2).
        let priority: Int
        let content: UNNotificationContent
    }

    /// The nearest `limit` candidates, so the rolling window stays full and the
    /// soonest alerts are never the ones dropped.
    static func select(_ candidates: [Candidate], limit: Int) -> [Candidate] {
        Array(candidates.sorted { ($0.date, $0.priority) < ($1.date, $1.priority) }.prefix(max(0, limit)))
    }

    static let keepAliveID = "noor.keepalive"

    /// When the "open Noor to keep your adhan alerts" notice fires: shortly after the last
    /// alert that was scheduled. Every reschedule (opening the app, Background App Refresh)
    /// replaces it with a later one, so it only appears if the schedule really ran out.
    /// Neutral wording by design: it never comments on whether the user prayed.
    static func keepAliveDate(after selected: [Candidate]) -> Date? {
        selected.map(\.date).max()?.addingTimeInterval(10 * 60)
    }
}

/// Reschedules prayer alerts from Background App Refresh, so they keep coming for
/// people who use the widgets and rarely open the app.
enum BackgroundRefresh {
    static let taskID = "com.zakaria.noor.reschedule"
    /// Ask for a run about twice a day; iOS decides the actual time.
    static let interval: TimeInterval = 12 * 60 * 60

    #if os(iOS)
    static func submit(now: Date = Date()) {
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = now.addingTimeInterval(interval)
        try? BGTaskScheduler.shared.submit(request)
    }
    #endif
}
