import SwiftUI

/// A daily spiritual checklist (wird) whose progress resets each day.
/// Pushed from the Ibadah tab. Its prayer rows are the prayer tracker's entries,
/// so a prayer is never ticked in two places.
struct WirdView: View {
    /// Wird rows that mirror a prayer in `PrayerLogStore`.
    static let prayerRows: [String: PrayerName] = [
        "fajr_sunnah": .fajr, "dhuhr": .dhuhr, "asr": .asr, "maghrib": .maghrib, "isha": .isha,
    ]

    private static let tasks: [(id: String, title: String, arabic: String, systemImage: String)] = [
        ("fajr_sunnah", "Fajr Sunnah & Prayer", "الفجر", "sunrise"),
        ("morning_adkar", "Morning Adkar", "أذكار الصباح", "sun.max"),
        ("quran", "Read Quran", "قراءة القرآن", "book"),
        ("dhuhr", "Dhuhr Prayer", "الظهر", "sun.max.fill"),
        ("asr", "Asr Prayer", "العصر", "cloud.sun"),
        ("evening_adkar", "Evening Adkar", "أذكار المساء", "moon"),
        ("maghrib", "Maghrib Prayer", "المغرب", "sunset"),
        ("isha", "Isha Prayer", "العشاء", "moon.stars"),
        ("istighfar", "100× Istighfar", "الاستغفار", "heart"),
        ("salawat", "Salawat on the Prophet ﷺ", "الصلاة على النبي", "star"),
    ]

    @Environment(LocalizationManager.self) private var loc
    @Environment(PrayerLogStore.self) private var prayerLog
    @State private var ownDone: Set<String> = []

    /// Rows ticked today: the wird's own items plus prayers logged in the tracker.
    private var done: Set<String> {
        var s = ownDone
        for (id, prayer) in Self.prayerRows where prayerLog.status(prayer)?.counts == true { s.insert(id) }
        return s
    }

    private var dayKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return "noor.wird." + f.string(from: Date())
    }

    private var progress: Double {
        Self.tasks.isEmpty ? 0 : Double(done.count) / Double(Self.tasks.count)
    }

    var body: some View {
            ScrollView {
                VStack(spacing: Spacing.three) {
                    progressCard
                    Card(padding: Spacing.two) {
                        VStack(spacing: 0) {
                            ForEach(Array(Self.tasks.enumerated()), id: \.element.id) { i, task in
                                row(task)
                                if i != Self.tasks.count - 1 {
                                    Divider().overlay(Palette.border)
                                }
                            }
                        }
                    }
                }
                .padding(Spacing.three)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .noorBackground()
            .navigationTitle(loc.t("wird.title"))
            .onAppear(perform: loadToday)
    }

    private var progressCard: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.two) {
                HStack {
                    Text(loc.t("wird.today"))
                        .font(.headline)
                        .foregroundStyle(Palette.text)
                    Spacer()
                    Text("\(done.count)/\(Self.tasks.count)")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(Palette.primary)
                }
                ProgressView(value: progress)
                    .tint(Palette.primary)
            }
        }
    }

    private func row(_ task: (id: String, title: String, arabic: String, systemImage: String)) -> some View {
        let isDone = done.contains(task.id)
        return Button {
            toggle(task.id)
        } label: {
            HStack(spacing: Spacing.three) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isDone ? Palette.primary : Palette.textSecondary)
                    .font(.title3)
                Image(systemName: task.systemImage)
                    .foregroundStyle(Palette.textSecondary)
                    .frame(width: 24)
                Text(loc.t("wird.\(task.id)"))
                    .foregroundStyle(Palette.text)
                    .strikethrough(isDone, color: Palette.textSecondary)
                Spacer()
                if loc.code != "ar" {
                    Text(task.arabic)
                        .foregroundStyle(Palette.textSecondary)
                }
            }
            .padding(.vertical, Spacing.two)
            .padding(.horizontal, Spacing.two)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: Persistence

    private func toggle(_ id: String) {
        if let prayer = Self.prayerRows[id] {
            prayerLog.toggle(prayer)
            return
        }
        if ownDone.contains(id) { ownDone.remove(id) } else { ownDone.insert(id) }
        UserDefaults.standard.set(Array(ownDone), forKey: dayKey)
    }

    private func loadToday() {
        let saved = UserDefaults.standard.stringArray(forKey: dayKey) ?? []
        ownDone = Set(saved).subtracting(Self.prayerRows.keys)
    }
}
