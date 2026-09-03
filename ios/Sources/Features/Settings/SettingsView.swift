import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(LocationManager.self) private var location
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        @Bindable var settings = settings
        @Bindable var loc = loc
        Form {
            Section {
                Picker(loc.t("settings.language"), selection: $loc.language) {
                    Text(loc.t("lang.system")).tag(AppLanguage.system)
                    Text("English").tag(AppLanguage.en)
                    Text("Français").tag(AppLanguage.fr)
                    Text("العربية").tag(AppLanguage.ar)
                }
            }

            locationSection

            Section(loc.t("settings.calculation")) {
                Picker(loc.t("settings.method"), selection: $settings.method) {
                    ForEach(MethodKey.allCases) { m in
                        Text(m.label).tag(m)
                    }
                }
                Picker(loc.t("settings.madhab"), selection: $settings.madhab) {
                    ForEach(MadhabKey.allCases) { m in
                        Text(loc.t(m == .hanafi ? "madhab.hanafi" : "madhab.other")).tag(m)
                    }
                }
                Picker(loc.t("settings.hijriAdjust"), selection: $settings.hijriOffset) {
                    ForEach(-2...2, id: \.self) { v in
                        Text(v > 0 ? "+\(v)" : "\(v)").tag(v)
                    }
                }
            }

            Section(loc.t("settings.display")) {
                Picker(loc.t("settings.theme"), selection: $settings.theme) {
                    Text(loc.t("theme.system")).tag(AppTheme.system)
                    Text(loc.t("theme.light")).tag(AppTheme.light)
                    Text(loc.t("theme.dark")).tag(AppTheme.dark)
                }
                Toggle(loc.t("settings.hour12"), isOn: $settings.hour12)
            }

            Section {
                Toggle(loc.t("settings.widget.show"), isOn: $settings.widgetEnabled)
                if settings.widgetEnabled {
                    Picker(loc.t("settings.widget.display"), selection: $settings.widgetDisplay) {
                        ForEach(VerseDisplay.allCases, id: \.self) { d in
                            Text(loc.t("widget.display.\(d.rawValue)")).tag(d)
                        }
                    }
                }
            } header: {
                Text(loc.t("settings.widget"))
            } footer: {
                Text(loc.t("settings.widget.footer"))
            }

            Section {
                Toggle(loc.t("settings.notifications"), isOn: $settings.notificationsEnabled)
                // Prayer times are derived from coordinates, so with no location
                // NotificationService.refresh() schedules nothing. Say so rather
                // than leaving the toggle looking active.
                if settings.notificationsEnabled, location.coordinate == nil {
                    Label {
                        Text(loc.t("settings.notifyNeedsLocation"))
                            .font(.footnote)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Palette.accent)
                    }
                    if location.isDenied {
                        Button(loc.t("common.openSettings")) { location.openSettings() }
                    }
                }
            } footer: {
                Text(loc.t("settings.notificationsFooter"))
            }

            if settings.notificationsEnabled {
                Section(loc.t("settings.notifyFor")) {
                    ForEach(prayerOrder.filter { $0.isPrayer }) { p in
                        Toggle(isOn: prayerBinding(p)) {
                            Label(p.label(loc.code), systemImage: p.systemImage)
                        }
                    }
                }
                Section {
                    Toggle(loc.t("settings.adhanSound"), isOn: $settings.adhanSound)
                    Button {
                        Task {
                            let granted = await NotificationService.requestAuthorization()
                            if granted {
                                NotificationService.sendTest(adhanSound: settings.adhanSound,
                                                             langCode: loc.code)
                            }
                        }
                    } label: {
                        Label(loc.t("settings.testAdhan"), systemImage: "bell.badge")
                    }
                } footer: {
                    Text(loc.t("settings.adhanFooter"))
                }
                Section {
                    Toggle(loc.t("settings.adkarReminders"), isOn: $settings.adkarReminders)
                } footer: {
                    Text(loc.t("settings.adkarRemindersFooter"))
                }
            }

            // Its own section rather than a line buried under the version number:
            // a rating is the one thing a user can give back, and it has to be
            // findable without hunting.
            Section {
                Link(destination: ReviewPrompt.writeReviewURL) {
                    Label {
                        Text(loc.t("settings.rate")).foregroundStyle(Palette.text)
                    } icon: {
                        Image(systemName: "star.fill").foregroundStyle(Palette.accent)
                    }
                }
                ShareLink(item: AppLink.url, message: Text(loc.t("settings.shareAppMessage"))) {
                    Label {
                        Text(loc.t("settings.shareApp")).foregroundStyle(Palette.text)
                    } icon: {
                        Image(systemName: "square.and.arrow.up").foregroundStyle(Palette.primary)
                    }
                }
            } footer: {
                Text(loc.t("settings.rateFooter"))
            }

            Section(loc.t("settings.about")) {
                LabeledContent(loc.t("settings.reciter"), value: QuranService.reciterName)
                LabeledContent(loc.t("settings.version"), value: appVersion)
            }
        }
        .navigationTitle(loc.t("settings.title"))
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onChange(of: settings.notificationsEnabled) { _, enabled in
            handleNotifications(enabled)
        }
        .onChange(of: settings.method) { _, _ in refresh() }
        .onChange(of: settings.madhab) { _, _ in refresh() }
        .onChange(of: settings.adhanSound) { _, _ in refresh() }
        .onChange(of: settings.enabledPrayers) { _, _ in refresh() }
        .onChange(of: settings.adkarReminders) { _, _ in refresh() }
        // Granting access here must start the notifications that were blocked.
        .onChange(of: location.status) { _, _ in refresh() }
    }

    /// Location status, and a way out of every state. When access is denied the
    /// only honest action is a link to iOS Settings — iOS will not re-prompt.
    @ViewBuilder
    private var locationSection: some View {
        Section(loc.t("settings.location")) {
            if location.isDenied {
                VStack(alignment: .leading, spacing: 4) {
                    Text(loc.t("settings.locationOff"))
                    Text(loc.t("settings.locationOffDesc"))
                        .font(.footnote)
                        .foregroundStyle(Palette.textSecondary)
                }
                Button(loc.t("common.openSettings")) { location.openSettings() }
            } else if !location.isAuthorized {
                Text(loc.t("settings.locationNotSet"))
                    .font(.footnote)
                    .foregroundStyle(Palette.textSecondary)
                Button(loc.t("common.continue")) { location.request() }
            } else {
                LabeledContent(
                    loc.t("settings.currentLocation"),
                    value: location.placeName.isEmpty ? loc.t("settings.locating") : location.placeName
                )
            }
        }
    }

    private func prayerBinding(_ p: PrayerName) -> Binding<Bool> {
        Binding(
            get: { settings.enabledPrayers.contains(p.rawValue) },
            set: { on in
                if on { settings.enabledPrayers.insert(p.rawValue) }
                else { settings.enabledPrayers.remove(p.rawValue) }
            }
        )
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private func handleNotifications(_ enabled: Bool) {
        guard enabled else {
            NotificationService.cancelAll()
            return
        }
        Task {
            let granted = await NotificationService.requestAuthorization()
            if granted {
                refresh()
            } else {
                settings.notificationsEnabled = false
            }
        }
    }

    private func refresh() {
        NotificationService.refresh(settings: settings, location: location, langCode: loc.code)
    }
}
