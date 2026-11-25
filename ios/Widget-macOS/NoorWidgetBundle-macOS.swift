import SwiftUI
import WidgetKit

@main
struct NoorWidgetBundleMacOS: WidgetBundle {
    var body: some Widget {
        PrayerWidget()          // next prayer, countdown, today's times (small / medium / large)
        VerseWidgetMacOS()
    }
}
