import Foundation

struct Verse: Identifiable, Hashable {
    let surah: Int
    let ayah: Int
    let name: String
    let arabic: String
    let english: String

    var id: String { "\(surah):\(ayah)" }
    var reference: String { "\(name) \(surah):\(ayah)" }

    var shortEnglish: String {
        guard english.count > 34 else { return english }
        let words = english.split(separator: " ")
        var line = ""
        for w in words {
            if line.count + w.count + 1 > 30 { break }
            line = line.isEmpty ? String(w) : line + " " + w
        }
        return line + "…"
    }
}

/// A hand-picked set of uplifting verses — hope, ease after hardship,
/// trust in Allah — never fear or punishment. The lock screen is a place
/// people glance at in vulnerable moments; only comfort belongs here.
enum VerseStore {
    static let placeholder = all[0]

    static let all: [Verse] = [
        Verse(surah: 94, ayah: 6, name: "Ash-Sharh", arabic: "إِنَّ مَعَ الْعُسْرِ يُسْرًا", english: "Indeed, with hardship comes ease."),
        Verse(surah: 13, ayah: 28, name: "Ar-Ra'd", arabic: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ", english: "In the remembrance of Allah hearts find rest."),
        Verse(surah: 39, ayah: 53, name: "Az-Zumar", arabic: "لَا تَقْنَطُوا مِنْ رَحْمَةِ اللَّهِ", english: "Do not despair of the mercy of Allah."),
        Verse(surah: 2, ayah: 286, name: "Al-Baqarah", arabic: "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا", english: "Allah does not burden a soul beyond its capacity."),
        Verse(surah: 65, ayah: 3, name: "At-Talaq", arabic: "وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ", english: "Whoever trusts in Allah, He is sufficient for him."),
        Verse(surah: 65, ayah: 2, name: "At-Talaq", arabic: "وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا", english: "Whoever is mindful of Allah, He makes a way out for him."),
        Verse(surah: 3, ayah: 139, name: "Aal-E-Imran", arabic: "وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنْتُمُ الْأَعْلَوْنَ", english: "Do not weaken and do not grieve; you will prevail."),
        Verse(surah: 93, ayah: 5, name: "Ad-Duha", arabic: "وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ", english: "Your Lord will give you so much that you will be pleased."),
        Verse(surah: 14, ayah: 7, name: "Ibrahim", arabic: "لَئِنْ شَكَرْتُمْ لَأَزِيدَنَّكُمْ", english: "If you are grateful, I will surely increase you."),
        Verse(surah: 2, ayah: 152, name: "Al-Baqarah", arabic: "فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي", english: "Remember Me, and I will remember you; be grateful to Me."),
        Verse(surah: 40, ayah: 60, name: "Ghafir", arabic: "ادْعُونِي أَسْتَجِيبَ لَكُمْ", english: "Call upon Me; I will answer you."),
        Verse(surah: 50, ayah: 16, name: "Qaf", arabic: "وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ", english: "We are closer to him than his jugular vein."),
        Verse(surah: 24, ayah: 35, name: "An-Nur", arabic: "اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ", english: "Allah is the Light of the heavens and the earth."),
        Verse(surah: 2, ayah: 153, name: "Al-Baqarah", arabic: "اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ", english: "Seek help through patience and prayer; Allah is with the patient."),
        Verse(surah: 12, ayah: 87, name: "Yusuf", arabic: "وَلَا تَيْأَسُوا مِنْ رَوْحِ اللَّهِ", english: "Never despair of the reviving mercy of Allah."),
        Verse(surah: 16, ayah: 97, name: "An-Nahl", arabic: "مَنْ عَمِلَ صَالِحًا فَلَنُحْيِيَنَّهُ حَيَاةً طَيِّبَةً", english: "Whoever does righteousness, We will grant him a good life."),
        Verse(surah: 29, ayah: 69, name: "Al-Ankabut", arabic: "وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا", english: "Those who strive for Us, We will guide them to Our ways."),
        Verse(surah: 57, ayah: 4, name: "Al-Hadid", arabic: "وَهُوَ مَعَكُمْ أَيْنَ مَا كُنْتُمْ", english: "And He is with you wherever you are."),
        Verse(surah: 10, ayah: 62, name: "Yunus", arabic: "أَلَا إِنَّ أَوْلِيَاءَ اللَّهِ لَا خَوْفٌ عَلَيْهِمْ وَلَا هُمْ يَحْزَنُونَ", english: "No fear comes upon the allies of Allah, nor shall they grieve."),
        Verse(surah: 89, ayah: 28, name: "Al-Fajr", arabic: "يَا أَيَّتُهَا النَّفْسُ الْمُطْمَئِنَّةُ ارْجِعِي إِلَىٰ رَبِّكِ رَاضِيَةً مَرْضِيَّةً", english: "O tranquil soul, return to your Lord, pleased and pleasing."),
        Verse(surah: 13, ayah: 11, name: "Ar-Ra'd", arabic: "إِنَّ اللَّهَ لَا يُغَيِّرُ مَا بِقَوْمٍ حَتَّىٰ يُغَيِّرُوا مَا بِأَنْفُسِهِمْ", english: "Allah does not change a people until they change themselves."),
        Verse(surah: 3, ayah: 173, name: "Aal-E-Imran", arabic: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ", english: "Allah is sufficient for us; He is the best Disposer of affairs."),
        Verse(surah: 2, ayah: 186, name: "Al-Baqarah", arabic: "وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ", english: "When My servants ask about Me, I am truly near."),
        Verse(surah: 36, ayah: 58, name: "Ya-Sin", arabic: "سَلَامٌ قَوْلًا مِنْ رَبٍّ رَحِيمٍ", english: "Peace — a word from a Merciful Lord."),
        Verse(surah: 2, ayah: 216, name: "Al-Baqarah", arabic: "وَعَسَىٰ أَنْ تَكْرَهُوا شَيْئًا وَهُوَ خَيْرٌ لَكُمْ", english: "Perhaps you dislike a thing, and it is good for you."),
        Verse(surah: 94, ayah: 8, name: "Ash-Sharh", arabic: "وَإِلَىٰ رَبِّكَ فَارْغَب", english: "Turn all your longing to your Lord."),
    ]

    /// Deterministic pseudo-random pick rotating every 5 minutes — the
    /// fastest cadence WidgetKit honors (shorter entries get coalesced by
    /// the system). Same slot always yields the same verse, so concurrent
    /// renders never flicker.
    static func random(for date: Date) -> Verse {
        let slot = Int64(date.timeIntervalSince1970) / 300
        var h = slot &* 2_654_435_761 &+ 0x9E37_79B9
        h = h ^ (h >> 17)
        let count = Int64(all.count)
        let idx = ((h % count) + count) % count
        return all[Int(idx)]
    }
}
