import Foundation

/// Du'as for fasting and Ramadan, each with its hadith reference. Same shape as
/// the adkar so the existing rows, favourites and share cards work on them.
let ramadanDuas: [Dhikr] = [
    Dhikr(
        id: "r-iftar",
        arabic: "ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ",
        translit: "Dhahaba ẓ-ẓamaʾu, wa-btallati l-ʿurūqu, wa thabata l-ajru in shāʾa llāh",
        translation: "The thirst has gone, the veins are moistened, and the reward is certain, if Allah wills. (Said when breaking the fast.)",
        translationFr: "La soif est partie, les veines sont humectées et la récompense est acquise, si Allah le veut. (À dire en rompant le jeûne.)",
        count: 1,
        reference: "Abu Dawud 2357"
    ),
    Dhikr(
        id: "r-qadr",
        arabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
        translit: "Allāhumma innaka ʿafuwwun tuḥibbu l-ʿafwa faʿfu ʿannī",
        translation: "O Allah, You are Pardoning and love to pardon, so pardon me. (Taught by the Prophet ﷺ for Laylat al-Qadr.)",
        translationFr: "Ô Allah, Tu es Celui qui pardonne et Tu aimes le pardon, alors pardonne-moi. (Enseignée par le Prophète ﷺ pour Laylat al-Qadr.)",
        count: 1,
        reference: "at-Tirmidhi 3513, Ibn Majah 3850"
    ),
    Dhikr(
        id: "r-hilal",
        arabic: "اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْيُمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، رَبِّي وَرَبُّكَ اللَّهُ",
        translit: "Allāhumma ahillahu ʿalaynā bil-yumni wal-īmān, was-salāmati wal-islām, rabbī wa rabbuka llāh",
        translation: "O Allah, bring this crescent over us with blessing and faith, safety and Islam. My Lord and your Lord is Allah. (On seeing the new moon.)",
        translationFr: "Ô Allah, fais apparaître ce croissant sur nous avec bénédiction et foi, sécurité et islam. Mon Seigneur et ton Seigneur est Allah. (En voyant le nouveau croissant.)",
        count: 1,
        reference: "at-Tirmidhi 3451"
    ),
    Dhikr(
        id: "r-host",
        arabic: "أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ، وَأَكَلَ طَعَامَكُمُ الْأَبْرَارُ، وَصَلَّتْ عَلَيْكُمُ الْمَلَائِكَةُ",
        translit: "Afṭara ʿindakumu ṣ-ṣāʾimūn, wa akala ṭaʿāmakumu l-abrār, wa ṣallat ʿalaykumu l-malāʾikah",
        translation: "May fasting people break their fast with you, the righteous eat your food, and the angels pray for you. (For a host who gives you iftar.)",
        translationFr: "Que des jeûneurs rompent le jeûne chez vous, que les pieux mangent votre nourriture et que les anges prient pour vous. (Pour celui qui vous offre l'iftar.)",
        count: 1,
        reference: "Abu Dawud 3854"
    ),
    Dhikr(
        id: "r-sa'im",
        arabic: "إِنِّي صَائِمٌ، إِنِّي صَائِمٌ",
        translit: "Innī ṣāʾim, innī ṣāʾim",
        translation: "I am fasting, I am fasting. (If someone insults or provokes you while you fast.)",
        translationFr: "Je jeûne, je jeûne. (Si quelqu'un t'insulte ou te provoque pendant le jeûne.)",
        count: 2,
        reference: "al-Bukhari 1894, Muslim 1151"
    ),
]
