import SwiftUI
import WidgetKit

@main
struct NoorWidgetBundle: WidgetBundle {
    var body: some Widget {
        VerseWidget()
        PrayerWidget()
        RamadanWidget()
        TodayPrayersWidget()
        TasbihWidget()
        TasbihControl()
        PrayerLiveActivity()
    }
}
