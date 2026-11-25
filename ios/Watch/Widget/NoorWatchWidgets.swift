import SwiftUI
import WidgetKit

/// Watch complications: the same prayer widgets as the iPhone Lock Screen (accessory families),
/// computing times on the watch from the context the iPhone sends (see WatchSync).
@main
struct NoorWatchWidgets: WidgetBundle {
    var body: some Widget {
        PrayerWidget()
        RamadanWidget()
        TodayPrayersWidget()
    }
}
