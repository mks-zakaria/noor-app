import XCTest
import SwiftUI
@testable import Noor

/// Renders the share card across its styles and its hardest content, so the
/// artwork can be looked at without hunting through the app, and so a passage
/// that overflows the card fails here rather than in someone's WhatsApp.
@MainActor
final class ShareCardRenderTests: XCTestCase {

    private static let shortAyah = ShareCardContent(
        arabic: "إِنَّ مَعَ الْعُسْرِ يُسْرًا",
        translation: "Indeed, with hardship comes ease.",
        reference: "Ash-Sharh · 94:6"
    )

    /// Ayat al-Kursi — the long end of what anyone actually shares.
    private static let longAyah = ShareCardContent(
        arabic: """
        اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ
        """,
        translation: "Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
        reference: "Al-Baqarah · 2:255"
    )

    private static let dua = ShareCardContent(
        arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
        transliteration: "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan waqina 'adhaban-nar",
        translation: "Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
        reference: "Al-Baqarah 2:201"
    )

    func testRendersEveryStyleAndLength() throws {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("noor-share-cards", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let cases: [(String, ShareCardContent)] = [
            ("short", Self.shortAyah), ("long", Self.longAyah), ("dua", Self.dua),
        ]

        for style in ShareCardStyle.all {
            for (label, content) in cases {
                let image = ShareCardRenderer.image(
                    content: content, style: style, includeTranslation: true
                )
                let card = try XCTUnwrap(image, "\(style.id)/\(label) failed to render")

                // 360×450pt at 3× — anything else means the layout escaped its frame.
                XCTAssertEqual(card.size.width, 360, accuracy: 0.5)
                XCTAssertEqual(card.size.height, 450, accuracy: 0.5)
                XCTAssertEqual(card.scale, 3)

                let png = try XCTUnwrap(card.pngData())
                try png.write(to: directory.appendingPathComponent("\(style.id)-\(label).png"))
            }
        }

        print("SHARE_CARDS_AT: \(directory.path)")
    }

    /// The watermark is the only attribution that survives a re-shared screenshot,
    /// so the printed link has to stay a real App Store address.
    func testWatermarkLinkPointsAtTheApp() {
        XCTAssertEqual(AppLink.displayText, "apps.apple.com/app/id6790552873")
        XCTAssertEqual(AppLink.url.absoluteString, "https://apps.apple.com/app/id6790552873")
    }
}
