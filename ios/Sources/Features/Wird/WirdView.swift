import SwiftUI

/// A daily spiritual checklist (wird) whose progress resets each day.
struct WirdView: View {
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
    @State private var done: Set<String> = []

    private var dayKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return "noor.wird." + f.string(from: Date())
    }

    private var progress: Double {
        Self.tasks.isEmpty ? 0 : Double(done.count) / Double(Self.tasks.count)
    }

    var body: some View {
        NavigationStack {
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
        if done.contains(id) { done.remove(id) } else { done.insert(id) }
        UserDefaults.standard.set(Array(done), forKey: dayKey)
    }

    private func loadToday() {
        let saved = UserDefaults.standard.stringArray(forKey: dayKey) ?? []
        done = Set(saved)
    }
}
