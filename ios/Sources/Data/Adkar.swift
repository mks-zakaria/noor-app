import Foundation

struct Dhikr: Identifiable, Hashable {
    let id: String
    let arabic: String
    let translit: String
    let translation: String
    let translationFr: String
    let count: Int
    let reference: String
}

struct AdkarCategory: Identifiable, Hashable {
    let key: String
    let title: String
    let titleFr: String
    let titleAr: String
    let subtitle: String
    let subtitleFr: String
    let subtitleAr: String
    let items: [Dhikr]
    var id: String { key }
}

let adkarCategories: [AdkarCategory] = [
    AdkarCategory(
        key: "morning",
        title: "Morning Adkar",
        titleFr: "Rappel du matin",
        titleAr: "أذكار الصباح",
        subtitle: "Recite after Fajr until sunrise",
        subtitleFr: "À réciter après le Fajr jusqu'au lever du soleil",
        subtitleAr: "تُقرأ بعد الفجر حتى شروق الشمس",
        items: [
            Dhikr(
                id: "m-ayatulkursi",
                arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                translit: "Allāhu lā ilāha illā huwa l-ḥayyu l-qayyūm…",
                translation: "Allah — there is no deity except Him, the Ever-Living, the Sustainer. (Ayat al-Kursi) Whoever recites it in the morning is protected until evening.",
                translationFr: "Allah — il n'y a de divinité que Lui, le Vivant, Celui qui subsiste par Lui-même. (Le Verset du Trône) Quiconque le récite le matin est protégé jusqu'au soir.",
                count: 1,
                reference: "Al-Baqarah 2:255 — al-Hakim"
            ),
            Dhikr(
                id: "m-ikhlas-muawwidhat",
                arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ … قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ … قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
                translit: "Qul huwa Allāhu aḥad / Qul aʿūdhu bi-rabbi l-falaq / Qul aʿūdhu bi-rabbi n-nās",
                translation: "Recite Surah al-Ikhlas, al-Falaq and an-Nas three times each — they suffice you against everything.",
                translationFr: "Récite les sourates al-Ikhlas, al-Falaq et an-Nas trois fois chacune — elles te suffisent contre toute chose.",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "m-asbahna",
                arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "Aṣbaḥnā wa aṣbaḥa l-mulku lillāh, wa-l-ḥamdu lillāh, lā ilāha illā Allāhu waḥdahu lā sharīka lah…",
                translation: "We have reached the morning and the dominion belongs to Allah. All praise is for Allah. None has the right to be worshipped but Allah alone, without partner.",
                translationFr: "Nous voici au matin et la royauté appartient à Allah. Toute louange est à Allah. Nul ne mérite d'être adoré si ce n'est Allah, l'Unique, sans associé.",
                count: 1,
                reference: "Muslim"
            ),
            Dhikr(
                id: "m-sayyid-istighfar",
                arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
                translit: "Allāhumma anta rabbī lā ilāha illā anta… (Sayyid al-Istighfar)",
                translation: "O Allah, You are my Lord; none has the right to be worshipped but You. You created me and I am Your servant… (The chief of seeking forgiveness)",
                translationFr: "Ô Allah, Tu es mon Seigneur ; nul ne mérite d'être adoré si ce n'est Toi. Tu m'as créé et je suis Ton serviteur… (Le maître des formules de demande de pardon)",
                count: 1,
                reference: "al-Bukhari"
            ),
            Dhikr(
                id: "m-afiyah",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي",
                translit: "Allāhumma innī as’aluka l-ʿafwa wa-l-ʿāfiyah fī d-dunyā wa-l-ākhirah…",
                translation: "O Allah, I ask You for pardon and well-being in this life and the next; in my religion, worldly affairs, family and wealth.",
                translationFr: "Ô Allah, je Te demande le pardon et le bien-être dans cette vie et dans l'au-delà ; dans ma religion, mes affaires d'ici-bas, ma famille et mes biens.",
                count: 1,
                reference: "Abu Dawud, Ibn Majah"
            ),
            Dhikr(
                id: "m-bismillah",
                arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
                translit: "Bismillāhi lladhī lā yaḍurru maʿa smihi shay’un fī l-arḍi wa-lā fī s-samā’…",
                translation: "In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing. (3×)",
                translationFr: "Au nom d'Allah, avec le nom de qui rien ne peut nuire ni sur la terre ni dans le ciel, et Il est Celui qui entend tout, l'Omniscient. (3×)",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "m-radina",
                arabic: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
                translit: "Raḍītu billāhi rabban, wa bi-l-islāmi dīnan, wa bi-Muḥammadin nabiyyā",
                translation: "I am pleased with Allah as my Lord, Islam as my religion, and Muhammad ﷺ as my Prophet. (3×)",
                translationFr: "Je suis satisfait d'Allah comme Seigneur, de l'Islam comme religion, et de Muhammad ﷺ comme Prophète. (3×)",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "m-yahayyu",
                arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
                translit: "Yā ḥayyu yā qayyūm bi-raḥmatika astaghīth…",
                translation: "O Ever-Living, O Sustainer, by Your mercy I seek relief. Rectify all my affairs and do not leave me to myself even for the blink of an eye.",
                translationFr: "Ô Vivant, ô Celui qui subsiste par Lui-même, par Ta miséricorde j'implore secours. Redresse toutes mes affaires et ne me laisse pas à moi-même l'espace d'un clin d'œil.",
                count: 1,
                reference: "al-Hakim, an-Nasa’i"
            ),
            Dhikr(
                id: "m-subhanallah",
                arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                translit: "Subḥāna llāhi wa biḥamdih",
                translation: "Glory and praise be to Allah. Whoever says it 100× in a day has their sins forgiven though they be as the foam of the sea. (100×)",
                translationFr: "Gloire et louange à Allah. Quiconque le dit 100× dans une journée voit ses péchés pardonnés, seraient-ils aussi nombreux que l'écume de la mer. (100×)",
                count: 100,
                reference: "al-Bukhari, Muslim"
            ),
            Dhikr(
                id: "m-tahlil",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "Lā ilāha illā llāhu waḥdahu lā sharīka lah, lahu l-mulku wa lahu l-ḥamd…",
                translation: "None has the right to be worshipped but Allah alone… equal to freeing slaves and a shield from Shaytan that day. (10× or 100×)",
                translationFr: "Nul ne mérite d'être adoré si ce n'est Allah, l'Unique… cela équivaut à affranchir des esclaves et sert de protection contre le Shaytan ce jour-là. (10× ou 100×)",
                count: 10,
                reference: "al-Bukhari, Muslim"
            ),
        ]
    ),
    AdkarCategory(
        key: "evening",
        title: "Evening Adkar",
        titleFr: "Rappel du soir",
        titleAr: "أذكار المساء",
        subtitle: "Recite after Asr until Maghrib",
        subtitleFr: "À réciter après le Asr jusqu'au Maghrib",
        subtitleAr: "تُقرأ بعد العصر حتى المغرب",
        items: [
            Dhikr(
                id: "e-ayatulkursi",
                arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ … وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                translit: "Allāhu lā ilāha illā huwa l-ḥayyu l-qayyūm… (Ayat al-Kursi)",
                translation: "Recite Ayat al-Kursi in the evening — a protector remains over you and no devil can approach until morning.",
                translationFr: "Récite le Verset du Trône le soir — un protecteur demeure sur toi et aucun démon ne peut t'approcher jusqu'au matin.",
                count: 1,
                reference: "Al-Baqarah 2:255 — al-Hakim"
            ),
            Dhikr(
                id: "e-ikhlas-muawwidhat",
                arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ … قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ … قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
                translit: "Qul huwa Allāhu aḥad / al-Falaq / an-Nās",
                translation: "Recite al-Ikhlas, al-Falaq and an-Nas three times each.",
                translationFr: "Récite al-Ikhlas, al-Falaq et an-Nas trois fois chacune.",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "e-amsayna",
                arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "Amsaynā wa amsā l-mulku lillāh, wa-l-ḥamdu lillāh…",
                translation: "We have reached the evening and the dominion belongs to Allah. All praise is for Allah. None has the right to be worshipped but Allah alone.",
                translationFr: "Nous voici au soir et la royauté appartient à Allah. Toute louange est à Allah. Nul ne mérite d'être adoré si ce n'est Allah, l'Unique.",
                count: 1,
                reference: "Muslim"
            ),
            Dhikr(
                id: "e-sayyid-istighfar",
                arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ … فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
                translit: "Allāhumma anta rabbī lā ilāha illā anta… (Sayyid al-Istighfar)",
                translation: "The chief of seeking forgiveness — said in the evening.",
                translationFr: "Le maître des formules de demande de pardon — à dire le soir.",
                count: 1,
                reference: "al-Bukhari"
            ),
            Dhikr(
                id: "e-bismillah",
                arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
                translit: "Bismillāhi lladhī lā yaḍurru maʿa smihi shay’…",
                translation: "In the name of Allah, with whose name nothing can cause harm in earth or heaven, the All-Hearing, the All-Knowing. (3×)",
                translationFr: "Au nom d'Allah, avec le nom de qui rien ne peut nuire sur la terre ni dans le ciel, Celui qui entend tout, l'Omniscient. (3×)",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "e-audhu-kalimat",
                arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
                translit: "Aʿūdhu bi-kalimāti llāhi t-tāmmāti min sharri mā khalaq",
                translation: "I seek refuge in the perfect words of Allah from the evil of what He created. Whoever says it thrice in the evening, no harm will befall him. (3×)",
                translationFr: "Je cherche refuge dans les paroles parfaites d'Allah contre le mal de ce qu'Il a créé. Quiconque le dit trois fois le soir, aucun mal ne l'atteindra. (3×)",
                count: 3,
                reference: "Muslim"
            ),
            Dhikr(
                id: "e-afiyah",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ",
                translit: "Allāhumma innī as’aluka l-ʿafwa wa-l-ʿāfiyah…",
                translation: "O Allah, I ask You for pardon and well-being in this world and the next.",
                translationFr: "Ô Allah, je Te demande le pardon et le bien-être dans ce monde et dans l'au-delà.",
                count: 1,
                reference: "Abu Dawud, Ibn Majah"
            ),
            Dhikr(
                id: "e-radina",
                arabic: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
                translit: "Raḍītu billāhi rabban, wa bi-l-islāmi dīnan, wa bi-Muḥammadin nabiyyā",
                translation: "I am pleased with Allah as Lord, Islam as religion, and Muhammad ﷺ as Prophet. (3×)",
                translationFr: "Je suis satisfait d'Allah comme Seigneur, de l'Islam comme religion, et de Muhammad ﷺ comme Prophète. (3×)",
                count: 3,
                reference: "Abu Dawud, at-Tirmidhi"
            ),
            Dhikr(
                id: "e-subhanallah",
                arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                translit: "Subḥāna llāhi wa biḥamdih",
                translation: "Glory and praise be to Allah. (100×)",
                translationFr: "Gloire et louange à Allah. (100×)",
                count: 100,
                reference: "al-Bukhari, Muslim"
            ),
            Dhikr(
                id: "e-salah-nabi",
                arabic: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
                translit: "Allāhumma ṣalli wa sallim ʿalā nabiyyinā Muḥammad",
                translation: "O Allah, send blessings and peace upon our Prophet Muhammad. Whoever sends blessings on me 10× morning and evening, my intercession reaches him. (10×)",
                translationFr: "Ô Allah, prie sur notre Prophète Muhammad et accorde-lui le salut. Quiconque prie sur moi 10× le matin et le soir, mon intercession lui parvient. (10×)",
                count: 10,
                reference: "at-Tabarani"
            ),
        ]
    ),
    AdkarCategory(
        key: "rizq",
        title: "Provision",
        titleFr: "Subsistance",
        titleAr: "أدعية سَعَة الرزق",
        subtitle: "Du'as for sustenance and provision",
        subtitleFr: "Invocations pour la subsistance et les biens",
        subtitleAr: "أدعية لسعة الرزق وطِيب المعيشة",
        items: [
            Dhikr(
                id: "rizq-kifaya",
                arabic: "اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ",
                translit: "Allāhumma-kfinī bi ḥalālika ʿan ḥarāmik, wa aghninī bi faḍlika ʿamman siwāk",
                translation: "O Allah, suffice me with what You have made lawful against what You have forbidden, and enrich me by Your bounty so I need none besides You.",
                translationFr: "Ô Allah, satisfais-moi de ce que Tu as rendu licite afin que je me passe de ce que Tu as interdit, et enrichis-moi de Ta grâce afin que je n'aie besoin de nul autre que Toi.",
                count: 1,
                reference: "Jāmiʿ at-Tirmidhī 3563 (hasan)"
            ),
            Dhikr(
                id: "rizq-faqir",
                arabic: "رَبِّ إِنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ",
                translit: "Rabbi innī limā anzalta ilayya min khayrin faqīr",
                translation: "My Lord, I am truly in need of whatever good You send down to me.",
                translationFr: "Mon Seigneur, je suis vraiment dans le besoin de tout bien que Tu fais descendre vers moi.",
                count: 1,
                reference: "Qur'an 28:24 (du'a of Musa)"
            ),
            Dhikr(
                id: "rizq-ilm-nafi",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا",
                translit: "Allāhumma innī as'aluka ʿilman nāfiʿan, wa rizqan ṭayyiban, wa ʿamalan mutaqabbalā",
                translation: "O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.",
                translationFr: "Ô Allah, je Te demande une science utile, une subsistance pure et licite, et des œuvres agréées.",
                count: 1,
                reference: "Sunan Ibn Mājah 925 (sahih; said after Fajr)"
            ),
            Dhikr(
                id: "rizq-barakah",
                arabic: "اللَّهُمَّ أَكْثِرْ مَالِي وَوَلَدِي، وَبَارِكْ لِي فِيمَا أَعْطَيْتَنِي",
                translit: "Allāhumma akthir mālī wa waladī, wa bārik lī fīmā aʿṭaytanī",
                translation: "O Allah, increase my wealth and children, and bless me in what You have given me.",
                translationFr: "Ô Allah, multiplie mes biens et mes enfants, et bénis-moi dans ce que Tu m'as accordé.",
                count: 1,
                reference: "Sahih al-Bukhari 6334"
            ),
            Dhikr(
                id: "rizq-maghfira",
                arabic: "اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي، وَارْزُقْنِي",
                translit: "Allāhumma-ghfir lī, wa-rḥamnī, wa-hdinī, wa ʿāfinī, wa-rzuqnī",
                translation: "O Allah, forgive me, have mercy on me, guide me, grant me well-being, and provide for me.",
                translationFr: "Ô Allah, pardonne-moi, fais-moi miséricorde, guide-moi, accorde-moi le bien-être et pourvois à ma subsistance.",
                count: 1,
                reference: "Sahih Muslim 2697"
            ),
        ]
    ),
    AdkarCategory(
        key: "hajah",
        title: "Fulfilling a Need",
        titleFr: "Exaucer un besoin",
        titleAr: "أدعية قضاء الحاجة",
        subtitle: "Du'as for having a need met",
        subtitleFr: "Invocations pour voir un besoin exaucé",
        subtitleAr: "أدعية لقضاء الحاجة وتيسير الأمور",
        items: [
            Dhikr(
                id: "hajah-salat",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ الْحَلِيمُ الْكَرِيمُ، سُبْحَانَ اللَّهِ رَبِّ الْعَرْشِ الْعَظِيمِ، الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ، أَسْأَلُكَ مُوجِبَاتِ رَحْمَتِكَ وَعَزَائِمَ مَغْفِرَتِكَ، وَالْغَنِيمَةَ مِنْ كُلِّ بِرٍّ وَالسَّلَامَةَ مِنْ كُلِّ إِثْمٍ",
                translit: "Lā ilāha illā-llāhu-l-Ḥalīmu-l-Karīm, subḥāna-llāhi Rabbi-l-ʿarshi-l-ʿaẓīm, al-ḥamdu lillāhi Rabbi-l-ʿālamīn, as'aluka mūjibāti raḥmatik, wa ʿazā'ima maghfiratik, wa-l-ghanīmata min kulli birr, wa-s-salāmata min kulli ithm",
                translation: "There is no god but Allah, the Forbearing, the Generous. Glory be to Allah, Lord of the Mighty Throne. Praise be to Allah, Lord of the worlds. I ask You for all that brings Your mercy, resolute forgiveness, a share of every good, and safety from every sin.",
                translationFr: "Il n'y a de dieu qu'Allah, le Longanime, le Généreux. Gloire à Allah, Seigneur du Trône immense. Louange à Allah, Seigneur des mondes. Je Te demande tout ce qui suscite Ta miséricorde, la fermeté de Ton pardon, une part de tout bien, et la préservation de tout péché.",
                count: 1,
                reference: "at-Tirmidhī 479 (Salat al-Hajah du'a; chain da'if — some act on it for virtue only)"
            ),
            Dhikr(
                id: "hajah-yunus",
                arabic: "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
                translit: "Lā ilāha illā anta subḥānaka innī kuntu mina-ẓ-ẓālimīn",
                translation: "There is no god but You, glory be to You; indeed I was among the wrongdoers.",
                translationFr: "Il n'y a de dieu que Toi, gloire à Toi ; en vérité, j'étais du nombre des injustes.",
                count: 1,
                reference: "Qur'an 21:87 (du'a of Yunus; cf. Tirmidhi 3505)"
            ),
            Dhikr(
                id: "hajah-hasbunallah",
                arabic: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
                translit: "Ḥasbunā-llāhu wa niʿma-l-wakīl",
                translation: "Allah is sufficient for us, and He is the best Disposer of affairs.",
                translationFr: "Allah nous suffit, et Il est le meilleur Garant.",
                count: 1,
                reference: "Qur'an 3:173 (cf. Bukhari 4563)"
            ),
            Dhikr(
                id: "hajah-hasbiyallah",
                arabic: "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
                translit: "Ḥasbiya-llāhu lā ilāha illā huwa ʿalayhi tawakkaltu wa huwa Rabbu-l-ʿarshi-l-ʿaẓīm",
                translation: "Allah is sufficient for me; there is no god but Him. In Him I put my trust, and He is Lord of the Mighty Throne.",
                translationFr: "Allah me suffit ; il n'y a de dieu que Lui. C'est en Lui que je place ma confiance, et Il est le Seigneur du Trône immense.",
                count: 7,
                reference: "Qur'an 9:129; Abu Dawud 5081 (7× morning & evening)"
            ),
            Dhikr(
                id: "hajah-la-sahla",
                arabic: "اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا",
                translit: "Allāhumma lā sahla illā mā jaʿaltahu sahlā, wa anta tajʿalu-l-ḥazna idhā shi'ta sahlā",
                translation: "O Allah, there is no ease except in what You make easy, and You make hardship, if You will, easy.",
                translationFr: "Ô Allah, il n'y a de facilité que dans ce que Tu rends facile, et Tu rends l'épreuve, si Tu le veux, facile.",
                count: 1,
                reference: "Ibn Hibban 974 (sahih)"
            ),
        ]
    ),
    AdkarCategory(
        key: "karb",
        title: "Distress & Anxiety",
        titleFr: "Détresse et angoisse",
        titleAr: "أدعية تفريج الكرب",
        subtitle: "Du'as for relief from distress and worry",
        subtitleFr: "Invocations pour être soulagé de la détresse et de l'inquiétude",
        subtitleAr: "أدعية لتفريج الكرب والهمّ",
        items: [
            Dhikr(
                id: "karb-azim-halim",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ",
                translit: "Lā ilāha illā-llāhu-l-ʿAẓīmu-l-Ḥalīm, lā ilāha illā-llāhu Rabbu-l-ʿarshi-l-ʿaẓīm, lā ilāha illā-llāhu Rabbu-s-samāwāti wa Rabbu-l-arḍi wa Rabbu-l-ʿarshi-l-karīm",
                translation: "There is no god but Allah, the Mighty, the Forbearing. There is no god but Allah, Lord of the Mighty Throne. There is no god but Allah, Lord of the heavens, the earth, and the Noble Throne.",
                translationFr: "Il n'y a de dieu qu'Allah, l'Immense, le Longanime. Il n'y a de dieu qu'Allah, Seigneur du Trône immense. Il n'y a de dieu qu'Allah, Seigneur des cieux, Seigneur de la terre et Seigneur du Trône noble.",
                count: 1,
                reference: "al-Bukhari 6346 & Muslim 2730"
            ),
            Dhikr(
                id: "karb-hamm-hazan",
                arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ",
                translit: "Allāhumma innī aʿūdhu bika mina-l-hammi wa-l-ḥazan, wa-l-ʿajzi wa-l-kasal, wa-l-bukhli wa-l-jubn, wa ḍalaʿi-d-dayni wa ghalabati-r-rijāl",
                translation: "O Allah, I seek refuge in You from worry and grief, from incapacity and laziness, from miserliness and cowardice, from the burden of debt and being overpowered by men.",
                translationFr: "Ô Allah, je cherche refuge auprès de Toi contre l'inquiétude et la tristesse, contre l'incapacité et la paresse, contre l'avarice et la lâcheté, contre le poids de la dette et la domination des hommes.",
                count: 1,
                reference: "Sahih al-Bukhari 6369"
            ),
            Dhikr(
                id: "karb-ya-hayy",
                arabic: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ",
                translit: "Yā Ḥayyu yā Qayyūm bi raḥmatika astaghīth",
                translation: "O Ever-Living, O Sustainer, by Your mercy I seek relief.",
                translationFr: "Ô Vivant, ô Celui qui subsiste par Lui-même, par Ta miséricorde j'implore secours.",
                count: 1,
                reference: "Jāmiʿ at-Tirmidhī 3524 (hasan)"
            ),
            Dhikr(
                id: "karb-rahmataka-arju",
                arabic: "اللَّهُمَّ رَحْمَتَكَ أَرْجُو فَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ، وَأَصْلِحْ لِي شَأْنِي كُلَّهُ، لَا إِلَهَ إِلَّا أَنْتَ",
                translit: "Allāhumma raḥmataka arjū fa-lā takilnī ilā nafsī ṭarfata ʿayn, wa aṣliḥ lī sha'nī kullah, lā ilāha illā anta",
                translation: "O Allah, it is Your mercy that I hope for, so do not leave me to myself even for the blink of an eye, and set right all my affairs. There is no god but You.",
                translationFr: "Ô Allah, c'est Ta miséricorde que j'espère, alors ne me laisse pas à moi-même l'espace d'un clin d'œil, et redresse toutes mes affaires. Il n'y a de dieu que Toi.",
                count: 1,
                reference: "Sunan Abi Dawud 5090 (hasan)"
            ),
        ]
    ),
    AdkarCategory(
        key: "quran-dua",
        title: "Du'ās from the Qur'an",
        titleFr: "Invocations du Coran",
        titleAr: "أدعية من القرآن",
        subtitle: "Supplications revealed in the Qur'an",
        subtitleFr: "Invocations révélées dans le Coran",
        subtitleAr: "أدعية وردت في القرآن الكريم",
        items: [
            Dhikr(
                id: "q-dunya-akhira",
                arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
                translit: "Rabbanā ātinā fi-d-dunyā ḥasanah, wa fi-l-ākhirati ḥasanah, wa qinā ʿadhāba-n-nār",
                translation: "Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
                translationFr: "Notre Seigneur, accorde-nous un bien dans ce monde et un bien dans l'au-delà, et protège-nous du châtiment du Feu.",
                count: 1,
                reference: "Al-Baqarah 2:201"
            ),
            Dhikr(
                id: "q-la-tuakhidhna",
                arabic: "رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا، رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا، رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ، وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا، أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ",
                translit: "Rabbanā lā tu'ākhidhnā in nasīnā aw akhṭa'nā… anta mawlānā fa-nṣurnā ʿala-l-qawmi-l-kāfirīn",
                translation: "Our Lord, do not take us to task if we forget or err… You are our Protector, so grant us victory over the disbelieving people.",
                translationFr: "Notre Seigneur, ne nous châtie pas si nous oublions ou commettons une erreur… Tu es notre Maître, accorde-nous donc la victoire sur les gens mécréants.",
                count: 1,
                reference: "Al-Baqarah 2:286"
            ),
            Dhikr(
                id: "q-yunus",
                arabic: "لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
                translit: "Lā ilāha illā anta subḥānaka innī kuntu mina-ẓ-ẓālimīn",
                translation: "There is no deity except You; glory be to You. Indeed, I have been among the wrongdoers. (The du'a of Yunus ﷺ)",
                translationFr: "Il n'y a de divinité que Toi ; gloire à Toi. En vérité, j'ai été du nombre des injustes. (L'invocation de Yunus ﷺ)",
                count: 1,
                reference: "Al-Anbiyā' 21:87"
            ),
            Dhikr(
                id: "q-ishrah-sadri",
                arabic: "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي",
                translit: "Rabbi-shraḥ lī ṣadrī, wa yassir lī amrī, wa-ḥlul ʿuqdatan min lisānī, yafqahū qawlī",
                translation: "My Lord, expand for me my chest, ease my task for me, and untie the knot from my tongue so they may understand my speech.",
                translationFr: "Mon Seigneur, ouvre-moi ma poitrine, facilite ma mission, et dénoue le nœud de ma langue afin qu'ils comprennent mes paroles.",
                count: 1,
                reference: "Ṭā-Hā 20:25–28"
            ),
            Dhikr(
                id: "q-zidni-ilma",
                arabic: "رَبِّ زِدْنِي عِلْمًا",
                translit: "Rabbi zidnī ʿilmā",
                translation: "My Lord, increase me in knowledge.",
                translationFr: "Mon Seigneur, accrois mon savoir.",
                count: 1,
                reference: "Ṭā-Hā 20:114"
            ),
            Dhikr(
                id: "q-qurrata-ayun",
                arabic: "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا",
                translit: "Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata aʿyunin wa-jʿalnā li-l-muttaqīna imāmā",
                translation: "Our Lord, grant us from among our spouses and offspring comfort to our eyes, and make us leaders for the righteous.",
                translationFr: "Notre Seigneur, accorde-nous, en nos épouses et nos descendants, la joie des yeux, et fais de nous des guides pour les pieux.",
                count: 1,
                reference: "Al-Furqān 25:74"
            ),
            Dhikr(
                id: "q-la-tuzigh",
                arabic: "رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ",
                translit: "Rabbanā lā tuzigh qulūbanā baʿda idh hadaytanā, wa hab lanā min ladunka raḥmah, innaka anta-l-Wahhāb",
                translation: "Our Lord, let not our hearts deviate after You have guided us, and grant us mercy from Yourself. Indeed, You are the Bestower.",
                translationFr: "Notre Seigneur, ne laisse pas dévier nos cœurs après que Tu nous as guidés, et accorde-nous de Ta part une miséricorde. C'est Toi le Grand Donateur.",
                count: 1,
                reference: "Āl ʿImrān 3:8"
            ),
            Dhikr(
                id: "q-afrigh-sabra",
                arabic: "رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ",
                translit: "Rabbanā afrigh ʿalaynā ṣabran wa thabbit aqdāmanā wa-nṣurnā ʿala-l-qawmi-l-kāfirīn",
                translation: "Our Lord, pour upon us patience, make firm our feet, and give us victory over the disbelieving people.",
                translationFr: "Notre Seigneur, déverse sur nous l'endurance, affermis nos pas et donne-nous la victoire sur les gens mécréants.",
                count: 1,
                reference: "Al-Baqarah 2:250"
            ),
            Dhikr(
                id: "q-awzini",
                arabic: "رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ",
                translit: "Rabbi awziʿnī an ashkura niʿmataka-llatī anʿamta ʿalayya wa ʿalā wālidayya wa an aʿmala ṣāliḥan tarḍāh, wa adkhilnī bi-raḥmatika fī ʿibādika-ṣ-ṣāliḥīn",
                translation: "My Lord, enable me to be grateful for Your favour upon me and my parents, and to do righteousness that pleases You, and admit me by Your mercy among Your righteous servants.",
                translationFr: "Mon Seigneur, permets-moi d'être reconnaissant du bienfait dont Tu m'as comblé ainsi que mes parents, et de faire une bonne œuvre que Tu agrées, et fais-moi entrer, par Ta miséricorde, parmi Tes serviteurs vertueux.",
                count: 1,
                reference: "An-Naml 27:19"
            ),
            Dhikr(
                id: "q-ayyub",
                arabic: "أَنِّي مَسَّنِيَ الضُّرُّ وَأَنْتَ أَرْحَمُ الرَّاحِمِينَ",
                translit: "Annī massaniya-ḍ-ḍurru wa anta arḥamu-r-rāḥimīn",
                translation: "Adversity has touched me, and You are the Most Merciful of the merciful. (The du'a of Ayyub ﷺ)",
                translationFr: "Le mal m'a touché, et Tu es le plus Miséricordieux des miséricordieux. (L'invocation d'Ayyub ﷺ)",
                count: 1,
                reference: "Al-Anbiyā' 21:83"
            ),
            Dhikr(
                id: "q-la-tadharni",
                arabic: "رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنْتَ خَيْرُ الْوَارِثِينَ",
                translit: "Rabbi lā tadharnī fardan wa anta khayru-l-wārithīn",
                translation: "My Lord, do not leave me alone, and You are the best of inheritors. (The du'a of Zakariyya ﷺ)",
                translationFr: "Mon Seigneur, ne me laisse pas seul, et Tu es le meilleur des héritiers. (L'invocation de Zakariyya ﷺ)",
                count: 1,
                reference: "Al-Anbiyā' 21:89"
            ),
            Dhikr(
                id: "q-taqabbal",
                arabic: "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ",
                translit: "Rabbanā taqabbal minnā innaka anta-s-Samīʿu-l-ʿAlīm",
                translation: "Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing. (The du'a of Ibrahim ﷺ)",
                translationFr: "Notre Seigneur, accepte de nous. C'est Toi l'Audient, l'Omniscient. (L'invocation d'Ibrahim ﷺ)",
                count: 1,
                reference: "Al-Baqarah 2:127"
            ),
            Dhikr(
                id: "q-muqima-salah",
                arabic: "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ",
                translit: "Rabbi-jʿalnī muqīma-ṣ-ṣalāti wa min dhurriyyatī, rabbanā wa taqabbal duʿā'",
                translation: "My Lord, make me an establisher of prayer, and from my descendants too. Our Lord, and accept my supplication.",
                translationFr: "Mon Seigneur, fais que j'accomplisse assidûment la prière, ainsi qu'une partie de ma descendance. Notre Seigneur, accepte mon invocation.",
                count: 1,
                reference: "Ibrāhīm 14:40"
            ),
            Dhikr(
                id: "q-amanna",
                arabic: "رَبَّنَا إِنَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ النَّارِ",
                translit: "Rabbanā innanā āmannā fa-ghfir lanā dhunūbanā wa qinā ʿadhāba-n-nār",
                translation: "Our Lord, indeed we have believed, so forgive us our sins and protect us from the punishment of the Fire.",
                translationFr: "Notre Seigneur, nous avons cru ; pardonne-nous donc nos péchés et protège-nous du châtiment du Feu.",
                count: 1,
                reference: "Āl ʿImrān 3:16"
            ),
            Dhikr(
                id: "q-hab-salihin",
                arabic: "رَبِّ هَبْ لِي مِنَ الصَّالِحِينَ",
                translit: "Rabbi hab lī mina-ṣ-ṣāliḥīn",
                translation: "My Lord, grant me a righteous child. (The du'a of Ibrahim ﷺ)",
                translationFr: "Mon Seigneur, accorde-moi une descendance vertueuse. (L'invocation d'Ibrahim ﷺ)",
                count: 1,
                reference: "Aṣ-Ṣāffāt 37:100"
            ),
        ]
    ),
    AdkarCategory(
        key: "sunnah-dua",
        title: "Du'ās from the Sunnah",
        titleFr: "Invocations de la Sunna",
        titleAr: "أدعية من السنة",
        subtitle: "Comprehensive supplications of the Prophet ﷺ",
        subtitleFr: "Invocations complètes du Prophète ﷺ",
        subtitleAr: "من جوامع دعاء النبي ﷺ",
        items: [
            Dhikr(
                id: "s-huda-tuqa",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَىٰ وَالتُّقَىٰ وَالْعَفَافَ وَالْغِنَىٰ",
                translit: "Allāhumma innī as'aluka-l-hudā wa-t-tuqā wa-l-ʿafāfa wa-l-ghinā",
                translation: "O Allah, I ask You for guidance, piety, chastity, and self-sufficiency.",
                translationFr: "Ô Allah, je Te demande la guidée, la piété, la chasteté et la richesse (du cœur).",
                count: 1,
                reference: "Sahih Muslim 2721"
            ),
            Dhikr(
                id: "s-ainni-dhikrika",
                arabic: "اللَّهُمَّ أَعِنِّي عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
                translit: "Allāhumma aʿinnī ʿalā dhikrika wa shukrika wa ḥusni ʿibādatik",
                translation: "O Allah, help me to remember You, to thank You, and to worship You in the best manner.",
                translationFr: "Ô Allah, aide-moi à T'évoquer, à Te remercier et à T'adorer de la meilleure façon.",
                count: 1,
                reference: "Sunan Abi Dawud 1522 (sahih)"
            ),
            Dhikr(
                id: "s-audhu-ilm",
                arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عِلْمٍ لَا يَنْفَعُ، وَمِنْ قَلْبٍ لَا يَخْشَعُ، وَمِنْ نَفْسٍ لَا تَشْبَعُ، وَمِنْ دَعْوَةٍ لَا يُسْتَجَابُ لَهَا",
                translit: "Allāhumma innī aʿūdhu bika min ʿilmin lā yanfaʿ, wa min qalbin lā yakhshaʿ, wa min nafsin lā tashbaʿ, wa min daʿwatin lā yustajābu lahā",
                translation: "O Allah, I seek refuge in You from knowledge that does not benefit, from a heart that does not humble itself, from a soul that is never satisfied, and from a supplication that is not answered.",
                translationFr: "Ô Allah, je cherche refuge auprès de Toi contre une science inutile, un cœur qui ne s'humilie pas, une âme jamais rassasiée, et une invocation qui n'est pas exaucée.",
                count: 1,
                reference: "Sahih Muslim 2722"
            ),
            Dhikr(
                id: "s-thabbit-qalbi",
                arabic: "يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَىٰ دِينِكَ",
                translit: "Yā muqalliba-l-qulūb thabbit qalbī ʿalā dīnik",
                translation: "O Turner of the hearts, make my heart firm upon Your religion.",
                translationFr: "Ô Toi qui fais tourner les cœurs, affermis mon cœur sur Ta religion.",
                count: 1,
                reference: "Jāmiʿ at-Tirmidhī 2140 (sahih)"
            ),
            Dhikr(
                id: "s-musarrifa-qulub",
                arabic: "اللَّهُمَّ مُصَرِّفَ الْقُلُوبِ صَرِّفْ قُلُوبَنَا عَلَىٰ طَاعَتِكَ",
                translit: "Allāhumma muṣarrifa-l-qulūb ṣarrif qulūbanā ʿalā ṭāʿatik",
                translation: "O Allah, Director of the hearts, direct our hearts to Your obedience.",
                translationFr: "Ô Allah, Toi qui diriges les cœurs, dirige nos cœurs vers Ton obéissance.",
                count: 1,
                reference: "Sahih Muslim 2654"
            ),
            Dhikr(
                id: "s-aslih-dini",
                arabic: "اللَّهُمَّ أَصْلِحْ لِي دِينِي الَّذِي هُوَ عِصْمَةُ أَمْرِي، وَأَصْلِحْ لِي دُنْيَايَ الَّتِي فِيهَا مَعَاشِي، وَأَصْلِحْ لِي آخِرَتِي الَّتِي فِيهَا مَعَادِي، وَاجْعَلِ الْحَيَاةَ زِيَادَةً لِي فِي كُلِّ خَيْرٍ، وَاجْعَلِ الْمَوْتَ رَاحَةً لِي مِنْ كُلِّ شَرٍّ",
                translit: "Allāhumma aṣliḥ lī dīnī-lladhī huwa ʿiṣmatu amrī, wa aṣliḥ lī dunyāya-llatī fīhā maʿāshī, wa aṣliḥ lī ākhiratī-llatī fīhā maʿādī…",
                translation: "O Allah, set right my religion which is the safeguard of my affairs; set right my worldly life in which is my livelihood; set right my Hereafter to which is my return; make life an increase for me in every good, and make death a rest for me from every evil.",
                translationFr: "Ô Allah, réforme ma religion qui est la sauvegarde de mes affaires ; réforme ma vie d'ici-bas dans laquelle est ma subsistance ; réforme mon au-delà vers lequel est mon retour ; fais de la vie un surcroît de tout bien pour moi, et de la mort un repos de tout mal.",
                count: 1,
                reference: "Sahih Muslim 2720"
            ),
            Dhikr(
                id: "s-jannah-nar",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ",
                translit: "Allāhumma innī as'aluka-l-jannah wa aʿūdhu bika mina-n-nār",
                translation: "O Allah, I ask You for Paradise and seek refuge in You from the Fire.",
                translationFr: "Ô Allah, je Te demande le Paradis et je cherche refuge auprès de Toi contre le Feu.",
                count: 1,
                reference: "Sunan Abi Dawud 792 (sahih)"
            ),
            Dhikr(
                id: "s-hubbaka",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ حُبَّكَ، وَحُبَّ مَنْ يُحِبُّكَ، وَحُبَّ عَمَلٍ يُقَرِّبُنِي إِلَىٰ حُبِّكَ",
                translit: "Allāhumma innī as'aluka ḥubbaka, wa ḥubba man yuḥibbuka, wa ḥubba ʿamalin yuqarribunī ilā ḥubbik",
                translation: "O Allah, I ask You for Your love, the love of those who love You, and the love of deeds that bring me closer to Your love.",
                translationFr: "Ô Allah, je Te demande Ton amour, l'amour de ceux qui T'aiment, et l'amour des œuvres qui me rapprochent de Ton amour.",
                count: 1,
                reference: "Jāmiʿ at-Tirmidhī 3235 (hasan)"
            ),
            Dhikr(
                id: "s-fila-khayrat",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ فِعْلَ الْخَيْرَاتِ، وَتَرْكَ الْمُنْكَرَاتِ، وَحُبَّ الْمَسَاكِينِ، وَأَنْ تَغْفِرَ لِي وَتَرْحَمَنِي، وَإِذَا أَرَدْتَ فِتْنَةَ قَوْمٍ فَتَوَفَّنِي غَيْرَ مَفْتُونٍ",
                translit: "Allāhumma innī as'aluka fiʿla-l-khayrāt, wa tarka-l-munkarāt, wa ḥubba-l-masākīn, wa an taghfira lī wa tarḥamanī…",
                translation: "O Allah, I ask You for the doing of good deeds, the avoidance of evil deeds, love of the poor, and that You forgive me and have mercy on me; and if You intend a trial for a people, then take me to You without being tried.",
                translationFr: "Ô Allah, je Te demande d'accomplir les bonnes actions, de délaisser les mauvaises, d'aimer les pauvres, de me pardonner et de me faire miséricorde ; et si Tu veux éprouver un peuple, reprends-moi sans que je sois éprouvé.",
                count: 1,
                reference: "Jāmiʿ at-Tirmidhī 3233 (sahih)"
            ),
            Dhikr(
                id: "s-zawali-nimah",
                arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ",
                translit: "Allāhumma innī aʿūdhu bika min zawāli niʿmatik, wa taḥawwuli ʿāfiyatik, wa fujā'ati niqmatik, wa jamīʿi sakhaṭik",
                translation: "O Allah, I seek refuge in You from the decline of Your favour, the change of Your protection, the suddenness of Your retribution, and all that displeases You.",
                translationFr: "Ô Allah, je cherche refuge auprès de Toi contre la disparition de Ton bienfait, le changement de Ta protection, la soudaineté de Ta vengeance et tout ce qui suscite Ton courroux.",
                count: 1,
                reference: "Sahih Muslim 2739"
            ),
            Dhikr(
                id: "s-khayr-kullihi",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنَ الْخَيْرِ كُلِّهِ عَاجِلِهِ وَآجِلِهِ مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ، وَأَعُوذُ بِكَ مِنَ الشَّرِّ كُلِّهِ عَاجِلِهِ وَآجِلِهِ مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ",
                translit: "Allāhumma innī as'aluka mina-l-khayri kullihi ʿājilihi wa ājilih, mā ʿalimtu minhu wa mā lam aʿlam, wa aʿūdhu bika mina-sh-sharri kullih…",
                translation: "O Allah, I ask You for all good, of it that is near and far, what I know of it and what I do not; and I seek refuge in You from all evil, of it that is near and far, what I know of it and what I do not.",
                translationFr: "Ô Allah, je Te demande tout bien, immédiat et différé, celui que je connais et celui que j'ignore ; et je cherche refuge auprès de Toi contre tout mal, immédiat et différé, celui que je connais et celui que j'ignore.",
                count: 1,
                reference: "Sunan Ibn Majah 3846 (sahih)"
            ),
            Dhikr(
                id: "s-husna-aqibah",
                arabic: "اللَّهُمَّ أَحْسِنْ عَاقِبَتَنَا فِي الْأُمُورِ كُلِّهَا، وَأَجِرْنَا مِنْ خِزْيِ الدُّنْيَا وَعَذَابِ الْآخِرَةِ",
                translit: "Allāhumma aḥsin ʿāqibatanā fi-l-umūri kullihā, wa ajirnā min khizyi-d-dunyā wa ʿadhābi-l-ākhirah",
                translation: "O Allah, make good our outcome in all affairs, and protect us from the disgrace of this world and the punishment of the Hereafter.",
                translationFr: "Ô Allah, rends bonne notre issue dans toutes les affaires, et préserve-nous de l'humiliation d'ici-bas et du châtiment de l'au-delà.",
                count: 1,
                reference: "Musnad Ahmad 17133 (sahih)"
            ),
        ]
    ),
]
// MARK: - Hisn al-Muslim (Fortress of the Muslim)
// GENERATED — 132 chapters / 279 duʿāʾ, transcribed from the printed
// fully-vocalized edition of حصن المسلم by Saʿīd al-Qaḥṭānī. Do not hand-edit.

struct HisnChapter: Identifiable, Hashable {
    let id: String
    let number: Int
    let titleEn: String
    let titleFr: String
    let titleAr: String
    let items: [Dhikr]
    func title(_ code: String) -> String { code == "ar" ? titleAr : code == "fr" ? titleFr : titleEn }
}

struct HisnSection: Identifiable, Hashable {
    let key: String
    let icon: String
    let titleEn: String
    let titleFr: String
    let titleAr: String
    let subtitleEn: String
    let subtitleFr: String
    let subtitleAr: String
    let chapters: [HisnChapter]
    var id: String { key }
    func title(_ code: String) -> String { code == "ar" ? titleAr : code == "fr" ? titleFr : titleEn }
    func subtitle(_ code: String) -> String { code == "ar" ? subtitleAr : code == "fr" ? subtitleFr : subtitleEn }
    var duaCount: Int { chapters.reduce(0) { $0 + $1.items.count } }
}

let hisnSections: [HisnSection] = [
    HisnSection(key: "waking", icon: "sunrise.fill",
        titleEn: "Waking, Dress & Home", titleFr: "Réveil, habit et maison", titleAr: "الاستيقاظ واللباس والمنزل",
        subtitleEn: "Starting the day", subtitleFr: "Commencer la journée", subtitleAr: "بداية اليوم",
        chapters: [
            HisnChapter(id: "h-1", number: 1, titleEn: "Waking from sleep", titleFr: "Au réveil", titleAr: "أذكار الاستيقاظ من النوم", items: [
                Dhikr(id: "h-1-1", arabic: "«الْحَمْدُ لِلهِ الَّذِي أَحْيَانَا بَعْدَمَا أَمَاتَنَا، وَإِلَيْهِ النُّشُورُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٦٣١٤، ومسلم، برقم ٢٧١١"),
                Dhikr(id: "h-1-2", arabic: "«لَا إِلَهَ إِلَّا اللهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ، سُبْحَانَ اللهِ، وَالْحَمْدُ لِلهِ، وَلَا إِلَهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ الْعَلِيِّ الْعَظِيمِ، رَبِّ اغْفِرْ لِي».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٣٩/٣، برقم ١١٥٤، وغيره، واللفظ لابن ماجه؛ انظر: صحيح ابن ماجه، ٢/ ٣٣٥"),
                Dhikr(id: "h-1-3", arabic: "«الْحَمْدُ لِلهِ الَّذِي عَافَانِي فِي جَسَدِي، وَرَدَّ عَلَيَّ رُوحِي، وَأَذِنَ لِي بِذِكْرِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي ٥/ ٤٧٣، برقم ٣٤٠١، وانظر: صحيح الترمذي ٣/ ١٤٤"),
                Dhikr(id: "h-1-4", arabic: "﴿إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ لَآيَاتٍ لِأُولِي الْأَلْبَابِ ۝ الَّذِينَ يَذْكُرُونَ اللَّهَ قِيَامًا وَقُعُودًا وَعَلَىٰ جُنُوبِهِمْ وَيَتَفَكَّرُونَ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ رَبَّنَا مَا خَلَقْتَ هَٰذَا بَاطِلًا سُبْحَانَكَ فَقِنَا عَذَابَ النَّارِ ۝ رَبَّنَا إِنَّكَ مَنْ تُدْخِلِ النَّارَ فَقَدْ أَخْزَيْتَهُ وَمَا لِلظَّالِمِينَ مِنْ أَنْصَارٍ ۝ رَبَّنَا إِنَّنَا سَمِعْنَا مُنَادِيًا يُنَادِي لِلْإِيمَانِ أَنْ آمِنُوا بِرَبِّكُمْ فَآمَنَّا رَبَّنَا فَاغْفِرْ لَنَا ذُنُوبَنَا وَكَفِّرْ عَنَّا سَيِّئَاتِنَا وَتَوَفَّنَا مَعَ الْأَبْرَارِ ۝ رَبَّنَا وَآتِنَا مَا وَعَدْتَنَا عَلَىٰ رُسُلِكَ وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ ۝ فَاسْتَجَابَ لَهُمْ رَبُّهُمْ أَنِّي لَا أُضِيعُ عَمَلَ عَامِلٍ مِنْكُمْ مِنْ ذَكَرٍ أَوْ أُنْثَىٰ بَعْضُكُمْ مِنْ بَعْضٍ فَالَّذِينَ هَاجَرُوا وَأُخْرِجُوا مِنْ دِيَارِهِمْ وَأُوذُوا فِي سَبِيلِي وَقَاتَلُوا وَقُتِلُوا لَأُكَفِّرَنَّ عَنْهُمْ سَيِّئَاتِهِمْ وَلَأُدْخِلَنَّهُمْ جَنَّاتٍ تَجْرِي مِنْ تَحْتِهَا الْأَنْهَارُ ثَوَابًا مِنْ عِنْدِ اللَّهِ وَاللَّهُ عِنْدَهُ حُسْنُ الثَّوَابِ ۝ لَا يَغُرَّنَّكَ تَقَلُّبُ الَّذِينَ كَفَرُوا فِي الْبِلَادِ ۝ مَتَاعٌ قَلِيلٌ ثُمَّ مَأْوَاهُمْ جَهَنَّمُ وَبِئْسَ الْمِهَادُ ۝ لَٰكِنِ الَّذِينَ اتَّقَوْا رَبَّهُمْ لَهُمْ جَنَّاتٌ تَجْرِي مِنْ تَحْتِهَا الْأَنْهَارُ خَالِدِينَ فِيهَا نُزُلًا مِنْ عِنْدِ اللَّهِ وَمَا عِنْدَ اللَّهِ خَيْرٌ لِلْأَبْرَارِ ۝ وَإِنَّ مِنْ أَهْلِ الْكِتَابِ لَمَنْ يُؤْمِنُ بِاللَّهِ وَمَا أُنْزِلَ إِلَيْكُمْ وَمَا أُنْزِلَ إِلَيْهِمْ خَاشِعِينَ لِلَّهِ لَا يَشْتَرُونَ بِآيَاتِ اللَّهِ ثَمَنًا قَلِيلًا أُولَٰئِكَ لَهُمْ أَجْرُهُمْ عِنْدَ رَبِّهِمْ إِنَّ اللَّهَ سَرِيعُ الْحِسَابِ ۝ يَا أَيُّهَا الَّذِينَ آمَنُوا اصْبِرُوا وَصَابِرُوا وَرَابِطُوا وَاتَّقُوا اللَّهَ لَعَلَّكُمْ تُفْلِحُونَ ۝﴾.", translit: "", translation: "", translationFr: "", count: 1, reference: "الآيات من سورة آل عمران ١٩٠-٢٠٠، البخاري مع الفتح، ٣٣٧/٨، برقم ٤٥٦٩، ومسلم، ١/ ٥٣٠، برقم ٢٥٦"),
            ]),
            HisnChapter(id: "h-2", number: 2, titleEn: "Getting dressed", titleFr: "S'habiller", titleAr: "دعاء لبس الثوب", items: [
                Dhikr(id: "h-2-1", arabic: "«الْحَمْدُ لِلهِ الَّذِي كَسَانِي هَذَا (الثَّوْبَ) وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ...».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أهل السنن إلا النسائي: أبو داود، برقم ٤٠٢٣، والترمذي، برقم ٣٤٥٨، وابن ماجه، برقم ٣٢٨٥، وحسنه الألباني في: إرواء الغليل، ٧/ ٤٧"),
            ]),
            HisnChapter(id: "h-3", number: 3, titleEn: "Wearing a new garment", titleFr: "Porter un vêtement neuf", titleAr: "دعاء لبس الثوب الجديد", items: [
                Dhikr(id: "h-3-1", arabic: "«اللَّهُمَّ لَكَ الْحَمْدُ، أَنْتَ كَسَوْتَنِيهِ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٤٠٢٠، والترمذي، برقم ١٧٦٧، والبغوي، ١٢/ ٤٠، وانظر: مختصر شمائل الترمذي للألباني، ص٤٧"),
            ]),
            HisnChapter(id: "h-4", number: 4, titleEn: "For someone wearing new clothes", titleFr: "Pour qui porte un habit neuf", titleAr: "الدعاء لمن لبس ثوبا جديدا", items: [
                Dhikr(id: "h-4-1", arabic: "«تُبْلِي، وَيُخْلِفُ اللهُ تَعَالَى».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، برقم ٤٠٢٠، وانظر: صحيح أبي داود ٢/٧٦٠."),
                Dhikr(id: "h-4-2", arabic: "«الْبَسْ جَدِيدًا، وَعِشْ حَمِيدًا، وَمُتْ شَهِيدًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "ابن ماجه، ٢/١١٧٨، برقم ٣٥٥٨، والبغوي، ١٢/٤١، وانظر: صحيح ابن ماجه، ٢/٢٧٥."),
            ]),
            HisnChapter(id: "h-5", number: 5, titleEn: "Taking off the garment", titleFr: "Ôter son vêtement", titleAr: "ما يقول إذا وضع ثوبه", items: [
                Dhikr(id: "h-5-1", arabic: "«بِسْمِ اللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٢/٥٠٥، برقم ٦٠٦، وغيره، وانظر: إرواء الغليل، برقم ٥٠، وصحيح الجامع، ٣/٢٠٣."),
            ]),
            HisnChapter(id: "h-10", number: 10, titleEn: "Leaving the home", titleFr: "Sortir de la maison", titleAr: "الذكر عند الخروج من المنزل", items: [
                Dhikr(id: "h-10-1", arabic: "«بِسْمِ اللهِ، تَوَكَّلْتُ عَلَى اللهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود ٥٠٩٥، والترمذي ٣٤٢٦، وانظر: صحيح الترمذي ٣/١٥١."),
                Dhikr(id: "h-10-2", arabic: "«اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ، أَوْ أُضَلَّ، أَوْ أَزِلَّ، أَوْ أُزَلَّ، أَوْ أَظْلِمَ، أَوْ أُظْلَمَ، أَوْ أَجْهَلَ، أَوْ يُجْهَلَ عَلَيَّ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أهل السنن: أبو داود، برقم ٥٠٩٤، والترمذي، برقم ٣٤٢٧، والنسائي، برقم ٥٥٠١، وابن ماجه برقم ٣٨٨٤، وانظر: صحيح الترمذي، ٣/١٥٢، وصحيح ابن ماجه، ٢/٣٣٦."),
            ]),
            HisnChapter(id: "h-11", number: 11, titleEn: "Entering the home", titleFr: "Entrer dans la maison", titleAr: "الذكر عند دخول المنزل", items: [
                Dhikr(id: "h-11-1", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ، بِسْمِ اللهِ وَلَجْنَا، وَبِسْمِ اللهِ خَرَجْنَا، وَعَلَى اللهِ رَبِّنَا تَوَكَّلْنَا. ثُمَّ لِيُسَلِّمْ عَلَى أَهْلِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود ٤/٣٢٥، برقم ٥٠٩٦، وحسّن إسناده العلامة ابن باز في تحفة الأخيار، ص٢٨. ومسلم، برقم ٢٠١٨."),
            ]),
        ]),
    HisnSection(key: "purification", icon: "drop.fill",
        titleEn: "Restroom & Wuḍūʾ", titleFr: "Toilettes et ablutions", titleAr: "الخلاء والوضوء",
        subtitleEn: "Purification", subtitleFr: "La purification", subtitleAr: "الطهارة",
        chapters: [
            HisnChapter(id: "h-6", number: 6, titleEn: "Entering the restroom", titleFr: "Entrer aux toilettes", titleAr: "دعاء دخول الخلاء", items: [
                Dhikr(id: "h-6-1", arabic: "«[بِسْمِ اللهِ]، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه البخاري، برقم ١٤٢، ومسلم، برقم ٣٧٥، وزيادة: «بسم الله» في أوله أخرجها سعيد بن منصور. انظر فتح الباري ١/٢٤٤."),
            ]),
            HisnChapter(id: "h-7", number: 7, titleEn: "Leaving the restroom", titleFr: "Sortir des toilettes", titleAr: "دعاء الخروج من الخلاء", items: [
                Dhikr(id: "h-7-1", arabic: "«غُفْرَانَكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أصحاب السنن إلا النسائي، فأخرجه في عمل اليوم والليلة، برقم ٧٩، أبو داود، برقم ٣٠، والترمذي، برقم ٧، وابن ماجه، برقم ٣٠٠، وصححه الألباني في صحيح سنن أبي داود، ١/١٩."),
            ]),
            HisnChapter(id: "h-8", number: 8, titleEn: "Before ablution", titleFr: "Avant les ablutions", titleAr: "الذكر قبل الوضوء", items: [
                Dhikr(id: "h-8-1", arabic: "«بِسْمِ اللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ١٠١، وابن ماجه، برقم ٣٩٧، وأحمد، برقم ٩٤١٨، وانظر إرواء الغليل ١/١٢٢."),
            ]),
            HisnChapter(id: "h-9", number: 9, titleEn: "After ablution", titleFr: "Après les ablutions", titleAr: "الذكر بعد الفراغ من الوضوء", items: [
                Dhikr(id: "h-9-1", arabic: "«أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ..».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/٢٠٩، برقم ٢٣٤."),
                Dhikr(id: "h-9-2", arabic: "«اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ، وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ١/٧٨، برقم ٥٥، وانظر: صحيح الترمذي، ١/١٨."),
                Dhikr(id: "h-9-3", arabic: "«سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "النسائي في عمل اليوم والليلة، ص١٧٣، وصححه الألباني في سلسلة الأحاديث الصحيحة، ٥/٤٤٠، وانظر: إرواء الغليل ١/١٣٥، و٣/٩٤."),
            ]),
        ]),
    HisnSection(key: "mosque", icon: "building.columns.fill",
        titleEn: "Mosque & Adhān", titleFr: "Mosquée et adhan", titleAr: "المسجد والأذان",
        subtitleEn: "The house of Allah", subtitleFr: "La maison d’Allah", subtitleAr: "بيت الله",
        chapters: [
            HisnChapter(id: "h-12", number: 12, titleEn: "Going to the mosque", titleFr: "Aller à la mosquée", titleAr: "دعاء الذهاب إلى المسجد", items: [
                Dhikr(id: "h-12-1", arabic: "«اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي لِسَانِي نُورًا، وَفِي سَمْعِي نُورًا، وَفِي بَصَرِي نُورًا، وَمِنْ فَوْقِي نُورًا، وَمِنْ تَحْتِي نُورًا، وَعَنْ يَمِينِي نُورًا، وَعَنْ شِمَالِي نُورًا، وَمِنْ أَمَامِي نُورًا، وَمِنْ خَلْفِي نُورًا، وَاجْعَلْ فِي نَفْسِي نُورًا، وَأَعْظِمْ لِي نُورًا، وَعَظِّمْ لِي نُورًا، وَاجْعَلْ لِي نُورًا، وَاجْعَلْنِي نُورًا، اللَّهُمَّ أَعْطِنِي نُورًا، وَاجْعَلْ فِي عَصَبِي نُورًا، وَفِي لَحْمِي نُورًا، وَفِي دَمِي نُورًا، وَفِي شَعْرِي نُورًا، وَفِي بَشَرِي نُورًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "انظر جميع هذه الألفاظ في البخاري مع الفتح، ١١/١١٦، برقم ٦٣١٦، ومسلم، ١/٥٢٦، و٥٢٩، و٥٣٠، برقم ٧٦٣."),
                Dhikr(id: "h-12-2", arabic: "«اللَّهُمَّ اجْعَلْ لِي نُورًا فِي قَبْرِي... وَنُورًا فِي عِظَامِي»، [«وَزِدْنِي نُورًا، وَزِدْنِي نُورًا، وَزِدْنِي نُورًا»]، [«وَهَبْ لِي نُورًا عَلَى نُورٍ»].", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٥/٤٨٣، برقم ٣٤١٩. وأخرجه البخاري في الأدب المفرد، برقم ٦٩٥، ص ٢٥٨، وصحح إسناده الألباني في صحيح الأدب المفرد، برقم ٥٣٦. ذكره ابن حجر في فتح الباري، وعزاه إلى ابن أبي عاصم في كتاب الدعاء، انظر: الفتح ١١/١١٨."),
            ]),
            HisnChapter(id: "h-13", number: 13, titleEn: "Entering the mosque", titleFr: "Entrer à la mosquée", titleAr: "دعاء دخول المسجد", items: [
                Dhikr(id: "h-13-1", arabic: "«يَبْدَأُ بِرِجْلِهِ الْيُمْنَى»، وَيَقُولُ: «أَعُوذُ بِاللهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ»، [بِسْمِ اللهِ، وَالصَّلَاةُ] [وَالسَّلَامُ عَلَى رَسُولِ اللهِ]، «اللَّهُمَّ [اغْفِرْ لِي ذُنُوبِي وَ] افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "لقول أنس بن مالك ﷺ: «من السنة إذا دخلت المسجد أن تَبدأ برجلك اليمنى، وإذا خرجت أن تبدأ برجلك اليسرى» أخرجه الحاكم ١/٢١٨، وصححه على شرط مسلم، ووافقه الذهبي، وأخرجه البيهقي ٢/٤٤٢، وحسنه الألباني في سلسلة الأحاديث الصحيحة، ٥/٦٢٤، برقم ٢٤٧٨. أبو داود، برقم ٤٦٦، وانظر: صحيح الجامع، برقم ٤٥٩١. رواه ابن السني، ٨٨، وحسنه الألباني في الثمر المستطاب، ص ٦٠٧. أبو داود ١/١٢٦، برقم ٤٦٥، وانظر: صحيح الجامع، ٥٢٨/١. ابن ماجه برقم ٧٧١، وصححه الألباني في صحيح ابن ماجه ١/١٢٨. مسلم، برقم ٧١٣، وفي سنن ابن ماجه من حديث فاطمة ﷺ: «اللهم اغفر لي ذنوبي، وافتح لي أبواب رحمتك». وصححه الألباني لشواهده. انظر: صحيح ابن ماجه، ١/١٢٨-١٢٩."),
            ]),
            HisnChapter(id: "h-14", number: 14, titleEn: "Leaving the mosque", titleFr: "Sortir de la mosquée", titleAr: "دعاء الخروج من المسجد", items: [
                Dhikr(id: "h-14-1", arabic: "«يَبْدَأُ بِرِجْلِهِ الْيُسْرَى»، وَيَقُولُ: «بِسْمِ اللهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللهِ، [اللَّهُمَّ اغْفِرْ لِي ذُنُوبِي]، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الحاكم ١/٢١٨، والبيهقي ٢/٤٤٢، وحسنه الألباني في سلسلة الأحاديث الصحيحة ٥/٦٢٤، برقم ٢٤٧٨. ابن ماجه برقم ٧٧١، وصححه الألباني في صحيح ابن ماجه ١/١٢٨. انظر تخريج روايات الحديث السابق في دعاء دخول المسجد، رقم ٢٠، وزيادة: «اللهم اعصمني من الشيطان الرجيم» لابن ماجه. انظر: صحيح ابن ماجه، ١/١٢٩."),
            ]),
            HisnChapter(id: "h-15", number: 15, titleEn: "The call to prayer (adhān)", titleFr: "L'appel à la prière", titleAr: "أذكار الأذان", items: [
                Dhikr(id: "h-15-1", arabic: "يَقُولُ مِثْلَ مَا يَقُولُ الْمُؤَذِّنُ، إِلَّا فِي «حَيَّ عَلَى الصَّلَاةِ، وَحَيَّ عَلَى الْفَلَاحِ»؛ فَيَقُولُ: «لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٦١١، ورقم ٦١٣، ومسلم، برقم ٣٨٣."),
                Dhikr(id: "h-15-2", arabic: "يَقُولُ: «وَأَنَا أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، رَضِيتُ بِاللهِ رَبًّا، وَبِمُحَمَّدٍ رَسُولًا، وَبِالْإِسْلَامِ دِينًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/٢٩٠، برقم ٣٨٦."),
                Dhikr(id: "h-15-3", arabic: "«يُصَلِّي عَلَى النَّبِيِّ ﷺ بَعْدَ فَرَاغِهِ مِنْ إِجَابَةِ الْمُؤَذِّنِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/٢٨٨، برقم ٣٨٤."),
                Dhikr(id: "h-15-4", arabic: "يَقُولُ: «اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ، [إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ]».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٦١٤، وما بين المعقوفين للبيهقي، ١/٤١٠، وحسّن إسناده العلامة عبد العزيز بن باز في تحفة الأخيار، ص٣٨."),
                Dhikr(id: "h-15-5", arabic: "«يَدْعُو لِنَفْسِهِ بَيْنَ الْأَذَانِ وَالْإِقَامَةِ، فَإِنَّ الدُّعَاءَ حِينَئِذٍ لَا يُرَدُّ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٣٥٩٤، ٣٥٩٥، وأبو داود ٥٢٥، وأحمد، ١٢٢٠٠، وصححه الألباني في صحيح الترمذي برقم ٣٥٩٤، وانظر: إرواء الغليل ١/٢٦٢."),
            ]),
        ]),
    HisnSection(key: "prayer", icon: "hands.and.sparkles.fill",
        titleEn: "The Prayer", titleFr: "La prière", titleAr: "الصلاة",
        subtitleEn: "Within & after ṣalāh", subtitleFr: "Pendant et après la prière", subtitleAr: "في الصلاة وبعدها",
        chapters: [
            HisnChapter(id: "h-16", number: 16, titleEn: "Opening supplication in prayer", titleFr: "Invocation d'ouverture", titleAr: "دعاء الاستفتاح", items: [
                Dhikr(id: "h-16-1", arabic: "«اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ، اللَّهُمَّ نَقِّنِي مِنْ خَطَايَايَ كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ، اللَّهُمَّ اغْسِلْنِي مِنْ خَطَايَايَ، بِالثَّلْجِ وَالْمَاءِ وَالْبَرَدِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/١٨١، برقم ٧٤٤، ومسلم، ١/٤١٩، برقم ٥٩٨."),
                Dhikr(id: "h-16-2", arabic: "«سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَهَ غَيْرُكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، برقم ٣٩٩، وأصحاب السنن الأربعة: أبو داود، برقم ٧٧٥، والترمذي، برقم ٢٤٣، وابن ماجه، برقم ٨٠٦، والنسائي، برقم ٨٩٩، وانظر: صحيح الترمذي، ١/٧٧، وصحيح ابن ماجه، ١/١٣٥."),
                Dhikr(id: "h-16-3", arabic: "«وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ السَّمَوَاتِ وَالْأَرْضَ حَنِيفًا وَمَا أَنَا مِنَ الْمُشْرِكِينَ، إِنَّ صَلَاتِي، وَنُسُكِي، وَمَحْيَايَ، وَمَمَاتِي لِلَّهِ رَبِّ الْعَالَمِينَ، لَا شَرِيكَ لَهُ، وَبِذَلِكَ أُمِرْتُ، وَأَنَا مِنَ الْمُسْلِمِينَ. اللَّهُمَّ أَنْتَ الْمَلِكُ، لَا إِلَهَ إِلَّا أَنْتَ، أَنْتَ رَبِّي، وَأَنَا عَبْدُكَ، ظَلَمْتُ نَفْسِي، وَاعْتَرَفْتُ بِذَنْبِي، فَاغْفِرْ لِي ذُنُوبِي جَمِيعًا، إِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ. وَاهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ لَا يَهْدِي لِأَحْسَنِهَا إِلَّا أَنْتَ، وَاصْرِفْ عَنِّي سَيِّئَهَا، لَا يَصْرِفُ عَنِّي سَيِّئَهَا إِلَّا أَنْتَ، لَبَّيْكَ وَسَعْدَيْكَ، وَالْخَيْرُ كُلُّهُ بِيَدَيْكَ، وَالشَّرُّ لَيْسَ إِلَيْكَ، أَنَا بِكَ وَإِلَيْكَ، تَبَارَكْتَ وَتَعَالَيْتَ، أَسْتَغْفِرُكَ، وَأَتُوبُ إِلَيْكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه مسلم، ١/٥٣٤، برقم ٧٧١."),
                Dhikr(id: "h-16-4", arabic: "«اللَّهُمَّ رَبَّ جِبْرَائِيلَ وَمِيكَائِيلَ وَإِسْرَافِيلَ، فَاطِرَ السَّمَوَاتِ وَالْأَرْضِ، عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، أَنْتَ تَحْكُمُ بَيْنَ عِبَادِكَ فِيمَا كَانُوا فِيهِ يَخْتَلِفُونَ، اهْدِنِي لِمَا اخْتُلِفَ فِيهِ مِنَ الْحَقِّ بِإِذْنِكَ، إِنَّكَ", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
                Dhikr(id: "h-16-5", arabic: "تَهْدِي مَنْ تَشَاءُ إِلَى صِرَاطٍ مُسْتَقِيمٍ", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه مسلم، ١/ ٥٣٤، برقم ٧٧٠"),
                Dhikr(id: "h-16-6", arabic: "اللهُ أَكْبَرُ كَبِيرًا، اللهُ أَكْبَرُ كَبِيرًا، اللهُ أَكْبَرُ كَبِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيلًا (ثَلَاثًا)، أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ: مِنْ نَفْخِهِ، وَنَفْثِهِ، وَهَمْزِهِ", translit: "", translation: "", translationFr: "", count: 3, reference: "أخرجه أبو داود، برقم ٧٦٤، وابن ماجه، برقم ٨٠٧، وأحمد، برقم ١٦٧٣٩، وقال شعيب الأرناؤوط في تحقيقه للمسند: «حسن لغيره»، وقال عبد القادر الأرناؤوط في تخريجه للكلم الطيب لابن تيمية، برقم ٧٨: «وهو حديث صحيح بشواهده»، وذكره الألباني في صحيح الكلم الطيب، برقم ٦٢، وأخرجه مسلم عن ابن عمر رضي الله عنهما بنحوه، وفيه قصة، ١/ ٤٢٠، برقم ٦٠١"),
                Dhikr(id: "h-16-7", arabic: "اللَّهُمَّ لَكَ الْحَمْدُ، أَنْتَ نُورُ السَّمَوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ، أَنْتَ قَيِّمُ السَّمَوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، [وَلَكَ الْحَمْدُ، أَنْتَ رَبُّ السَّمَوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ]، [وَلَكَ الْحَمْدُ، لَكَ مُلْكُ السَّمَوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ]، [وَلَكَ الْحَمْدُ، أَنْتَ مَلِكُ السَّمَوَاتِ وَالْأَرْضِ]، [وَلَكَ الْحَمْدُ]، [أَنْتَ الْحَقُّ، وَوَعْدُكَ الْحَقُّ، وَقَوْلُكَ الْحَقُّ، وَلِقَاؤُكَ الْحَقُّ، وَالْجَنَّةُ حَقٌّ، وَالنَّارُ حَقٌّ، وَالنَّبِيُّونَ حَقٌّ، وَمُحَمَّدٌ ﷺ حَقٌّ، وَالسَّاعَةُ حَقٌّ، [اللَّهُمَّ لَكَ أَسْلَمْتُ، وَعَلَيْكَ تَوَكَّلْتُ، وَبِكَ آمَنْتُ، وَإِلَيْكَ أَنَبْتُ، وَبِكَ خَاصَمْتُ، وَإِلَيْكَ حَاكَمْتُ. فَاغْفِرْ لِي مَا قَدَّمْتُ، وَمَا أَخَّرْتُ، وَمَا أَسْرَرْتُ، وَمَا أَعْلَنْتُ [وَمَا أَنْتَ أَعْلَمُ بِهِ مِنِّي]، [أَنْتَ الْمُقَدِّمُ، وَأَنْتَ الْمُؤَخِّرُ، لَا إِلَهَ إِلَّا أَنْتَ]، [أَنْتَ إِلَهِي، لَا إِلَهَ إِلَّا أَنْتَ]", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، برقم ١١٢٠، ورقم ٦٣١٧، ورقم ٧٣٨٥، ورقم ٧٤٤٢، ورقم ٧٤٩٩، ومسلم مختصرًا بنحوه، برقم ٧٦٩"),
            ]),
            HisnChapter(id: "h-17", number: 17, titleEn: "In bowing (rukūʿ)", titleFr: "Dans l’inclinaison", titleAr: "دُعَاءُ الرُّكُوعِ", items: [
                Dhikr(id: "h-17-1", arabic: "سُبْحَانَ رَبِّيَ الْعَظِيمِ (ثَلَاثَ مَرَّاتٍ)", translit: "", translation: "", translationFr: "", count: 3, reference: "أخرجه أهل السنن، وأحمد: أبو داود، برقم ٨٧٠، والترمذي، برقم ٢٦٢، والنسائي، برقم ١٠٠٧، وابن ماجه، برقم ٨٩٧، وأحمد، برقم ٣٥١٤، وانظر: صحيح الترمذي، ١/ ٨٣"),
                Dhikr(id: "h-17-2", arabic: "سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغْفِرْ لِي", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/ ٩٩، برقم ٧٩٤، ومسلم، ١/ ٣٥٠، برقم ٤٨٤"),
                Dhikr(id: "h-17-3", arabic: "سُبُّوحٌ، قُدُّوسٌ، رَبُّ الْمَلَائِكَةِ وَالرُّوحِ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٣٥٣، برقم ٤٨٧، وأبو داود، ١/ ٢٣٠، برقم ٨٧٢"),
                Dhikr(id: "h-17-4", arabic: "اللَّهُمَّ لَكَ رَكَعْتُ، وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ، خَشَعَ لَكَ سَمْعِي، وَبَصَرِي، وَمُخِّي، وَعَظْمِي، وَعَصَبِي، [وَمَا اسْتَقَلَّتْ بِهِ قَدَمِي]", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، برقم ٧٧١، والأربعة إلا ابن ماجه: أبو داود، برقم ٧٦٠، ورقم ٧٦١، والترمذي، برقم ٣٤٢١، والنسائي، برقم ١٠٤٩، وما بين المعقوفين لفظ ابن خزيمة، برقم ٦٠٧، وابن حبان، برقم ١٩٠١"),
                Dhikr(id: "h-17-5", arabic: "سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاءِ، وَالْعَظَمَةِ", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ١/ ٢٣٠، برقم ٨٧٣، والنسائي، برقم ١١٣١، وأحمد، برقم ٢٣٩٨٠، وإسناده حسن"),
            ]),
            HisnChapter(id: "h-18", number: 18, titleEn: "Rising from bowing", titleFr: "En se relevant", titleAr: "دُعَاءُ الرَّفْعِ مِنَ الرُّكُوعِ", items: [
                Dhikr(id: "h-18-1", arabic: "سَمِعَ اللهُ لِمَنْ حَمِدَهُ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٢/ ٢٨٢، برقم ٧٩٦"),
                Dhikr(id: "h-18-2", arabic: "رَبَّنَا وَلَكَ الْحَمْدُ، حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٢/ ٢٨٤، برقم ٧٩٦"),
                Dhikr(id: "h-18-3", arabic: "مِلْءَ السَّمَوَاتِ، وَمِلْءَ الْأَرْضِ، وَمَا بَيْنَهُمَا، وَمِلْءَ مَا شِئْتَ مِنْ شَيْءٍ بَعْدُ. أَهْلَ الثَّنَاءِ وَالْمَجْدِ، أَحَقُّ مَا قَالَ الْعَبْدُ، وَكُلُّنَا لَكَ عَبْدٌ. اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٣٤٦، برقم ٤٧٧"),
            ]),
            HisnChapter(id: "h-19", number: 19, titleEn: "In prostration (sujūd)", titleFr: "Dans la prosternation", titleAr: "دُعَاءُ السُّجُودِ", items: [
                Dhikr(id: "h-19-1", arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى (ثَلَاثَ مَرَّاتٍ)", translit: "", translation: "", translationFr: "", count: 3, reference: "أخرجه أهل السنن، وأحمد: أبو داود، برقم ٨٧٠، والترمذي، برقم ٢٦٢، والنسائي، برقم ١٠٠٧، وابن ماجه، برقم ٨٩٧، وأحمد، برقم ٣٥١٤، وانظر: صحيح الترمذي، ١/ ٨٣"),
                Dhikr(id: "h-19-2", arabic: "سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغْفِرْ لِي", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٧٩٤، ومسلم، برقم ٤٨٤، وتقدم برقم ٣٤"),
                Dhikr(id: "h-19-3", arabic: "سُبُّوحٌ، قُدُّوسٌ، رَبُّ الْمَلَائِكَةِ وَالرُّوحِ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، برقم ٤٨٧، وأبو داود، برقم ٨٧٢، وتقدم برقم ٣٥"),
                Dhikr(id: "h-19-4", arabic: "اللَّهُمَّ لَكَ سَجَدْتُ، وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ، سَجَدَ وَجْهِي لِلَّذِي خَلَقَهُ، وَصَوَّرَهُ، وَشَقَّ سَمْعَهُ وَبَصَرَهُ، تَبَارَكَ اللهُ أَحْسَنُ الْخَالِقِينَ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٥٣٤، برقم ٧٧١، وغيره"),
                Dhikr(id: "h-19-5", arabic: "سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاءِ، وَالْعَظَمَةِ", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ١/ ٢٣٠، برقم ٨٧٣، والنسائي، برقم ١١٣١، وأحمد، برقم ٢٣٩٨٠، وصححه الألباني في صحيح أبي داود، ١/ ١٦٦، وتقدم تخريجه برقم ٣٧"),
                Dhikr(id: "h-19-6", arabic: "اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ: دِقَّهُ وَجِلَّهُ، وَأَوَّلَهُ وَآخِرَهُ، وَعَلَانِيَتَهُ وَسِرَّهُ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٣٥٠، برقم ٤٨٣"),
                Dhikr(id: "h-19-7", arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ، وَبِمُعَافَاتِكَ مِنْ عُقُوبَتِكَ، وَأَعُوذُ بِكَ مِنْكَ، لَا أُحْصِي ثَنَاءً عَلَيْكَ، أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٣٥٢، برقم ٤٨٦"),
            ]),
            HisnChapter(id: "h-20", number: 20, titleEn: "Sitting between prostrations", titleFr: "Assis entre deux prosternations", titleAr: "دُعَاءُ الْجَلْسَةِ بَيْنَ السَّجْدَتَيْنِ", items: [
                Dhikr(id: "h-20-1", arabic: "رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ١/ ٢٣١، برقم ٨٧٤، وابن ماجه، برقم ٨٩٧، وانظر: صحيح ابن ماجه، ١/ ١٤٨"),
                Dhikr(id: "h-20-2", arabic: "اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَاجْبُرْنِي، وَعَافِنِي، وَارْزُقْنِي، وَارْفَعْنِي", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أصحاب السنن إلا النسائي: أبو داود، ١/ ٢٣١، برقم ٨٥٠، والترمذي، برقم ٢٨٤، و٢٨٥، وابن ماجه، برقم ٨٩٨، وانظر: صحيح الترمذي، ١/ ٩٠، وصحيح ابن ماجه، ١/ ١٤٨"),
            ]),
            HisnChapter(id: "h-21", number: 21, titleEn: "Prostration of recitation", titleFr: "Prosternation de récitation", titleAr: "دُعَاءُ سُجُودِ التِّلَاوَةِ", items: [
                Dhikr(id: "h-21-1", arabic: "سَجَدَ وَجْهِي لِلَّذِي خَلَقَهُ، وَشَقَّ سَمْعَهُ وَبَصَرَهُ بِحَوْلِهِ وَقُوَّتِهِ، فَتَبَارَكَ اللهُ أَحْسَنُ الْخَالِقِينَ", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٢/ ٤٧٤، برقم ٣٤٢٥، وأحمد، ٦/ ٣٠، برقم ٢٤٠٢٢، والحاكم، وصححه، ووافقه الذهبي، ١/ ٢٢٠ والزيادة له، والآية رقم ١٤ من سورة المؤمنون"),
                Dhikr(id: "h-21-2", arabic: "اللَّهُمَّ اكْتُبْ لِي بِهَا عِنْدَكَ أَجْرًا، وَضَعْ عَنِّي بِهَا وِزْرًا، وَاجْعَلْهَا لِي عِنْدَكَ ذُخْرًا، وَتَقَبَّلْهَا مِنِّي كَمَا تَقَبَّلْتَهَا مِنْ عَبْدِكَ دَاوُدَ", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٢/ ٤٧٣، برقم ٥٧٩، والحاكم وصححه، ووافقه الذهبي، ١/ ٢١٩"),
            ]),
            HisnChapter(id: "h-22", number: 22, titleEn: "The tashahhud", titleFr: "Le tashahhud", titleAr: "التَّشَهُّدُ", items: [
                Dhikr(id: "h-22-1", arabic: "التَّحِيَّاتُ لِلَّهِ، وَالصَّلَوَاتُ، وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللهِ الصَّالِحِينَ. أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٨٣١، ومسلم، برقم ٤٠٢"),
            ]),
            HisnChapter(id: "h-23", number: 23, titleEn: "Blessings on the Prophet ﷺ", titleFr: "Prière sur le Prophète ﷺ", titleAr: "الصَّلَاةُ عَلَى النَّبِيِّ ﷺ بَعْدَ التَّشَهُّدِ", items: [
                Dhikr(id: "h-23-1", arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ، وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ، اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٦/ ٤٠٨، برقم ٣٣٧٠، ومسلم، برقم ٤٠٦"),
                Dhikr(id: "h-23-2", arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى أَزْوَاجِهِ وَذُرِّيَّتِهِ، كَمَا صَلَّيْتَ عَلَى آلِ إِبْرَاهِيمَ، وَبَارِكْ عَلَى مُحَمَّدٍ وَعَلَى أَزْوَاجِهِ وَذُرِّيَّتِهِ، كَمَا بَارَكْتَ عَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٣٣٦٩، ومسلم، ١/ ٣٠٦، برقم ٤٠٧، واللفظ له"),
            ]),
            HisnChapter(id: "h-24", number: 24, titleEn: "Before the final salām", titleFr: "Avant le salut final", titleAr: "الدُّعَاءُ بَعْدَ التَّشَهُّدِ الْأَخِيرِ قَبْلَ السَّلَامِ", items: [
                Dhikr(id: "h-24-1", arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَمِنْ عَذَابِ جَهَنَّمَ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ١٣٧٧، ومسلم، برقم ٥٨٨، واللفظ لمسلم"),
                Dhikr(id: "h-24-2", arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْمَأْثَمِ وَالْمَغْرَمِ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/ ٢٠٢، برقم ٨٣٢، ومسلم، ١/ ٤١٢، برقم ٥٨٧"),
                Dhikr(id: "h-24-3", arabic: "اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا، وَلَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ، فَاغْفِرْ لِي مَغْفِرَةً مِنْ عِنْدِكَ، وَارْحَمْنِي، إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٨/ ١٦٨، برقم ٨٣٤، ومسلم، ٤/ ٢٠٧٨، برقم ٢٧٠٥"),
                Dhikr(id: "h-24-4", arabic: "اللَّهُمَّ اغْفِرْ لِي مَا قَدَّمْتُ، وَمَا أَخَّرْتُ، وَمَا أَسْرَرْتُ، وَمَا أَعْلَنْتُ، وَمَا أَسْرَفْتُ، وَمَا أَنْتَ أَعْلَمُ بِهِ مِنِّي. أَنْتَ الْمُقَدِّمُ، وَأَنْتَ الْمُؤَخِّرُ، لَا إِلَهَ إِلَّا أَنْتَ", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٥٣٤، برقم ٧٧١"),
                Dhikr(id: "h-24-5", arabic: "اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ،", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
            ]),
            HisnChapter(id: "h-25", number: 25, titleEn: "After the salām of prayer", titleFr: "Après le salut de la prière", titleAr: "الأذكار بعد السلام من الصلاة", items: [
                Dhikr(id: "h-25-1", arabic: "«أَسْتَغْفِرُ اللَّهَ» (ثَلَاثًا)، «اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ»", translit: "", translation: "", translationFr: "", count: 3, reference: "مسلم، ١/ ٤١٤، رقم ٥٩١."),
                Dhikr(id: "h-25-2", arabic: "«لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ (ثَلَاثًا)، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ»", translit: "", translation: "", translationFr: "", count: 3, reference: "البخاري، ١/ ٢٥٥، برقم ٨٤٤، ومسلم، ١/ ٤١٤، برقم ٥٩٣، وما بين المعقوفين زيادة من البخاري، برقم ٦٤٧٣."),
                Dhikr(id: "h-25-3", arabic: "«لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ. لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ، وَلَا نَعْبُدُ إِلَّا إِيَّاهُ، لَهُ النِّعْمَةُ وَلَهُ الْفَضْلُ وَلَهُ الثَّنَاءُ الْحَسَنُ، لَا إِلَٰهَ إِلَّا اللَّهُ مُخْلِصِينَ لَهُ الدِّينَ، وَلَوْ كَرِهَ الْكَافِرُونَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٤١٥، برقم ٥٩٤."),
                Dhikr(id: "h-25-4", arabic: "«سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ (ثَلَاثًا وَثَلَاثِينَ)، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ»", translit: "", translation: "", translationFr: "", count: 33, reference: "مسلم، ١/ ٤١٨، برقم ٥٩٧، وفيه: «من قال ذلك دبر كل صلاة؛ غُفرت خطاياه، وإن كانت مثل زبد البحر»."),
                Dhikr(id: "h-25-5", arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ﴾ ، بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ﴾ ، بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ﴾ ؛ بَعْدَ كُلِّ صَلَاةٍ", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ٨٦، برقم ١٥٢٣، والترمذي، برقم ٢٩٠٣، والنسائي، ٣/ ٦٨، برقم ١٣٣٥، وانظر: صحيح الترمذي، ٢/ ٨. والسور الثلاث يقال لها: المعوذات. انظر: فتح الباري، ٩/ ٦٢."),
                Dhikr(id: "h-25-6", arabic: "﴿اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ﴾ ؛ عَقِبَ كُلِّ صَلَاةٍ", translit: "", translation: "", translationFr: "", count: 1, reference: "«من قرأها دبر كل صلاة لم يمنعه من دخول الجنة إلا أن يموت». النسائي في عمل اليوم والليلة، برقم ١٠٠، وابن السني، برقم ١٢١، وصححه الألباني في صحيح الجامع، ٥/ ٣٣٩، وسلسلة الأحاديث الصحيحة، ٢/ ٦٩٧، برقم ٩٧٢، والآية رقم ٢٥٥ من سورة البقرة."),
                Dhikr(id: "h-25-7", arabic: "«لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ». عَشْرَ مَرَّاتٍ بَعْدَ صَلَاةِ الْمَغْرِبِ وَالصُّبْحِ", translit: "", translation: "", translationFr: "", count: 10, reference: "رواه الترمذي، ٣٤٧٤، وأحمد، ١٧٩٩٠، وحسنه لغيره محققو المسند، ٢٩/ ٥١٢، وانظر تخريجه في: زاد المعاد ١/ ٣٠٠ ."),
                Dhikr(id: "h-25-8", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا». بَعْدَ السَّلَامِ مِنْ صَلَاةِ الْفَجْرِ", translit: "", translation: "", translationFr: "", count: 1, reference: "ابن ماجه، برقم ٩٢٥، والنسائي في عمل اليوم والليلة، برقم ١٠٢، وانظر: صحيح ابن ماجه، ١/ ١٥٢، ومجمع الزوائد، ١٠/ ١١١، وسيأتي برقم ٩٥."),
                Dhikr(id: "h-25-9", arabic: "«لَا إِلَهَ إِلَّا اللهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللهُ رَبُّ السَّمَوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٦٣٤٥، ومسلم، ٤/ ٢٠٩٢، برقم ٢٧٣٠."),
                Dhikr(id: "h-25-10", arabic: "«اللَّهُمَّ رَحْمَتَكَ أَرْجُو، فَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ، وَأَصْلِحْ لِي شَأْنِي كُلَّهُ، لَا إِلَهَ إِلَّا أَنْتَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٤/ ٣٢٤، برقم ٥٠٩٠، وأحمد، ٤٢/ ٥، برقم ٢٠٤٣٠، وحسّنه الألباني في صحيح أبي داود، ٣/ ٩٥٩."),
                Dhikr(id: "h-25-11", arabic: "«لَا إِلَهَ إِلَّا أَنْتَ، سُبْحَانَكَ، إِنِّي كُنْتُ مِنَ الظَّالِمِينَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٥/ ٥٢٩، برقم ٣٥٠٥، والحاكم وصححه ووافقه الذهبي، ١/ ٥٠٥، وانظر: صحيح الترمذي، ٣/ ١٦٨."),
                Dhikr(id: "h-25-12", arabic: "«اللهُ اللهُ رَبِّي، لَا أُشْرِكُ بِهِ شَيْئًا»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، ٢/ ٨٧، برقم ١٥٢٥، وابن ماجه، برقم ٣٨٨٢، وانظر: صحيح ابن ماجه، ٢/ ٣٣٥."),
            ]),
            HisnChapter(id: "h-26", number: 26, titleEn: "The istikhāra prayer", titleFr: "La prière de consultation", titleAr: "دعاء صلاة الاستخارة", items: [
                Dhikr(id: "h-26-1", arabic: "قَالَ جَابِرُ بْنُ عَبْدِ اللَّهِ ﵄: كَانَ رَسُولُ اللَّهِ ﷺ يُعَلِّمُنَا الِاسْتِخَارَةَ فِي الْأُمُورِ كُلِّهَا كَمَا يُعَلِّمُنَا السُّورَةَ مِنَ الْقُرْآنِ، يَقُولُ: «إِذَا هَمَّ أَحَدُكُمْ بِالْأَمْرِ؛ فَلْيَرْكَعْ رَكْعَتَيْنِ مِنْ غَيْرِ الْفَرِيضَةِ، ثُمَّ لِيَقُلْ: اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ؛ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ، وَتَعْلَمُ وَلَا أَعْلَمُ، وَأَنْتَ عَلَّامُ الْغُيُوبِ، اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَٰذَا الْأَمْرَ - وَيُسَمِّي حَاجَتَهُ - خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي - أَوْ قَالَ: عَاجِلِهِ وَآجِلِهِ - فَاقْدُرْهُ لِي، وَيَسِّرْهُ لِي، ثُمَّ بَارِكْ لِي فِيهِ، وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَٰذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي - أَوْ قَالَ: عَاجِلِهِ وَآجِلِهِ - فَاصْرِفْهُ عَنِّي، وَاصْرِفْنِي عَنْهُ، وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ، ثُمَّ أَرْضِنِي بِهِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٧/ ١٦٢، برقم ١١٦٢."),
                Dhikr(id: "h-26-2", arabic: "وَمَا نَدِمَ مَنِ اسْتَخَارَ الْخَالِقَ، وَشَاوَرَ الْمَخْلُوقِينَ الْمُؤْمِنِينَ، وَتَثَبَّتَ فِي أَمْرِهِ، فَقَدْ قَالَ اللَّهُ سُبْحَانَهُ وَتَعَالَىٰ: ﴿وَشَاوِرْهُمْ فِي الْأَمْرِ فَإِذَا عَزَمْتَ فَتَوَكَّلْ عَلَى اللَّهِ﴾", translit: "", translation: "", translationFr: "", count: 1, reference: "سورة آل عمران، الآية: ١٥٩ ."),
            ]),
            HisnChapter(id: "h-32", number: 32, titleEn: "Qunūt of witr", titleFr: "Qunūt du witr", titleAr: "دعاء قنوت الوتر", items: [
                Dhikr(id: "h-32-1", arabic: "«اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ، وَبَارِكْ لِي فِيمَا أَعْطَيْتَ، وَقِنِي شَرَّ مَا قَضَيْتَ؛ فَإِنَّكَ تَقْضِي وَلَا يُقْضَى عَلَيْكَ، إِنَّهُ لَا يَذِلُّ مَنْ وَالَيْتَ، [وَلَا يَعِزُّ مَنْ عَادَيْتَ]، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أصحاب السنن الأربعة، وأحمد، والدارمي، والبيهقي: أبو داود، برقم ١٤٢٥، والترمذي، برقم ٤٦٤، والنسائي، برقم ١٧٤٤، وابن ماجه، برقم ١١٧٨، وأحمد، برقم ١٧١٨، والدارمي، ١٥٩٢، والحاكم، ٣/ ١٧٢، والبيهقي، ٢/ ٢٠٩، وما بين المعقوفين للبيهقي، وانظر: صحيح الترمذي ١/ ١٤٤، وصحيح ابن ماجه، ١/ ١٩٤، وإرواء الغليل للألباني، ٢/ ١٧٢."),
                Dhikr(id: "h-32-2", arabic: "«اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ، وَبِمُعَافَاتِكَ مِنْ عُقُوبَتِكَ، وَأَعُوذُ بِكَ مِنْكَ، لَا أُحْصِي ثَنَاءً عَلَيْكَ، أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أصحاب السنن الأربعة، وأحمد: أبو داود، برقم ١٤٢٧، والترمذي، برقم ٣٥٦٦، والنسائي، برقم ١٧٤٦، وابن ماجه، برقم ١١٧٩، وأحمد، برقم ٧٥١. انظر: صحيح الترمذي ٣/ ١٨٠، وصحيح ابن ماجه، ١/ ١٩٤، والإرواء، ٢/ ١٧٥."),
                Dhikr(id: "h-32-3", arabic: "«اللَّهُمَّ إِيَّاكَ نَعْبُدُ، وَلَكَ نُصَلِّي وَنَسْجُدُ، وَإِلَيْكَ نَسْعَى وَنَحْفِدُ، نَرْجُو رَحْمَتَكَ، وَنَخْشَى عَذَابَكَ، إِنَّ عَذَابَكَ بِالْكَافِرِينَ مُلْحَقٌّ. اللَّهُمَّ إِنَّا نَسْتَعِينُكَ، وَنَسْتَغْفِرُكَ، وَنُثْنِي عَلَيْكَ الْخَيْرَ، وَلَا نَكْفُرُكَ، وَنُؤْمِنُ بِكَ، وَنَخْضَعُ لَكَ، وَنَخْلَعُ مَنْ يَكْفُرُكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه البيهقي في السنن الكبرى، وصحّح إسناده ٢/ ٢١١، وقال الشيخ الألباني في إرواء الغليل: «وهذا إسناد صحيح»، ٢/ ١٧٠. وهو موقوف على عمر."),
            ]),
            HisnChapter(id: "h-33", number: 33, titleEn: "After the witr salām", titleFr: "Après le salut du witr", titleAr: "الذكر عقب السلام من الوتر", items: [
                Dhikr(id: "h-33-1", arabic: "«سُبْحَانَ الْمَلِكِ الْقُدُّوسِ» (ثَلَاثَ مَرَّاتٍ)، وَالثَّالِثَةُ يَجْهَرُ بِهَا، وَيَمُدُّ بِهَا صَوْتَهُ، يَقُولُ: [رَبِّ الْمَلَائِكَةِ وَالرُّوحِ]».", translit: "", translation: "", translationFr: "", count: 3, reference: "رواه النسائي ٣/ ٢٤٤، برقم ١٧٣٤، والدارقطني ٢/ ٣١، وغيرهما، وما بين المعقوفين زيادة للدارقطني ٢/ ٣١، برقم ٢، وإسناده صحيح. انظر: زاد المعاد، بتحقيق: شعيب الأرناؤوط وعبد القادر الأرناؤوط ١/ ٣٣٧."),
            ]),
        ]),
    HisnSection(key: "morning-evening", icon: "sun.and.horizon.fill",
        titleEn: "Morning, Evening & Sleep", titleFr: "Matin, soir et sommeil", titleAr: "الصباح والمساء والنوم",
        subtitleEn: "Daily fortress", subtitleFr: "La forteresse quotidienne", subtitleAr: "الحصن اليومي",
        chapters: [
            HisnChapter(id: "h-27", number: 27, titleEn: "Morning & evening", titleFr: "Matin et soir", titleAr: "أَذْكَارُ الصَّبَاحِ وَالْمَسَاءِ", items: [
                Dhikr(id: "h-27-1", arabic: "الْحَمْدُ لِلَّهِ وَحْدَهُ، وَالصَّلَاةُ وَالسَّلَامُ عَلَىٰ مَنْ لَا نَبِيَّ بَعْدَهُ", translit: "", translation: "", translationFr: "", count: 1, reference: "عن أنس يرفعه: «لَأَنْ أَقْعُدَ مَعَ قَوْمٍ يَذْكُرُونَ اللَّهَ تَعَالَى مِنْ صَلَاةِ الْغَدَاةِ حَتَّى تَطْلُعَ الشَّمْسُ؛ أَحَبُّ إِلَيَّ مِنْ أَنْ أُعْتِقَ أَرْبَعَةً مِنْ وَلَدِ إِسْمَاعِيلَ، وَلَأَنْ أَقْعُدَ مَعَ قَوْمٍ يَذْكُرُونَ اللَّهَ مِنْ صَلَاةِ الْعَصْرِ إِلَى أَنْ تَغْرُبَ الشَّمْسُ؛ أَحَبُّ إِلَيَّ مِنْ أَنْ أُعْتِقَ أَرْبَعَةً». أبو داود، برقم ٣٦٦٧، وحسنه الألباني في صحيح أبي داود، ٢/ ٦٩٨ ."),
                Dhikr(id: "h-27-2", arabic: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ، ﴿اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ﴾", translit: "", translation: "", translationFr: "", count: 1, reference: "سورة البقرة، الآية: ٢٥٥. «من قالها حين يصبح؛ أجير من الجن حتى يمسي، ومن قالها حين يمسي؛ أجير منهم حتى يصبح». أخرجه الحاكم، ١/ ٥٦٢، وصححه الألباني في صحيح الترغيب والترهيب، ١/ ٢٧٣، وعزاه إلى النسائي والطبراني، وقال: «إسناد الطبراني جيد»."),
                Dhikr(id: "h-27-3", arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ﴾ ، بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ﴾ ، بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
                Dhikr(id: "h-27-4", arabic: "يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ ۝ (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "«من قالها ثلاث مرات حين يصبح وحين يمسي؛ كفته من كل شيء». أخرجه أبو داود ٢/ ٤٢٢، برقم ٥٠٨٢، والترمذي ٥/ ٥٦٧، برقم ٣٥٧٥، وانظر: صحيح الترمذي ٣/ ١٨٢."),
                Dhikr(id: "h-27-5", arabic: "«أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/ ٢٠٨٨، برقم ٢٧٢٣."),
                Dhikr(id: "h-27-6", arabic: "«اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٣٩١، وانظر: صحيح الترمذي ٣/ ١٤٢."),
                Dhikr(id: "h-27-7", arabic: "«اللَّهُمَّ أَنْتَ رَبِّي، لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "«من قالها موقنًا بها حين يمسي فمات من ليلته دخل الجنة، وكذلك إذا أصبح». أخرجه البخاري، ٧/ ١٥٠، برقم ٦٣٠٦."),
                Dhikr(id: "h-27-8", arabic: "«اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ؛ أَنَّكَ أَنْتَ اللهُ لَا إِلَهَ إِلَّا أَنْتَ، وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ» (أَرْبَعَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 4, reference: "أخرجه أبو داود ٤/ ٣١٧، برقم ٥٠٧١، والبخاري في الأدب المفرد، برقم ١٢٠١، والنسائي في عمل اليوم والليلة، برقم ٩، وابن السني، برقم ٧٠، وحسّن إسناد النسائي وأبي داود ابن باز في تحفة الأخيار، ص٢٣."),
                Dhikr(id: "h-27-9", arabic: "«اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ؛ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ، وَلَكَ الشُّكْرُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود ٤، برقم ٥٠٧٥، والنسائي في عمل اليوم والليلة، برقم ٧، وابن السني، برقم ٤١، وابن حبان (موارد) برقم ٢٣٦١، وحسّن ابن باز إسناده في تحفة الأخيار، ص٢٤."),
                Dhikr(id: "h-27-10", arabic: "«اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ» (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "أبو داود ٤/ ٣٢٤، برقم ٥٠٩٢، وأحمد ٥/ ٤٢، برقم ٢٠٤٣٠، والنسائي في عمل اليوم والليلة، برقم ٢٢، وابن السني، برقم ٦٩، والبخاري في الأدب المفرد، برقم ٧٠١، وحسّن ابن باز إسناده في تحفة الأخيار، ص٢٦."),
                Dhikr(id: "h-27-11", arabic: "«حَسْبِيَ اللَّهُ، لَا إِلَهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ» (سَبْعَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 7, reference: "«من قالها حين يصبح ويمسي سبع مرات؛ كفاه الله ما أهمه من أمر الدنيا والآخرة». أخرجه ابن السني، برقم ٧١ مرفوعًا، وأبو داود موقوفًا ٤/ ٣٢١، برقم ٥٠٨١، وصحح إسناده شعيب وعبد القادر الأرناؤوط. انظر: زاد المعاد ٢/ ٣٧٦."),
                Dhikr(id: "h-27-12", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ: فِي دِينِي، وَدُنْيَايَ، وَأَهْلِي، وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٥٠٧٤، وابن ماجه، برقم ٣٨٧١، وانظر: صحيح ابن ماجه ٢/ ٣٣٢."),
                Dhikr(id: "h-27-13", arabic: "«اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٣٩٢، وأبو داود، برقم ٥٠٦٧، وانظر: صحيح الترمذي ٣/ ١٤٢."),
                Dhikr(id: "h-27-14", arabic: "«بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ، وَهُوَ السَّمِيعُ الْعَلِيمُ» (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "«من قالها ثلاثًا إذا أصبح، وثلاثًا إذا أمسى؛ لم يضره شيء». أخرجه أبو داود ٥٠٨٨، والترمذي ٣٣٨٨، وابن ماجه، برقم ٣٨٦٩، وأحمد، برقم ٤٤٦، وانظر: صحيح ابن ماجه ٢/ ٣٣٢، وحسّن إسناده ابن باز في تحفة الأخيار، ص٣٩."),
                Dhikr(id: "h-27-15", arabic: "«رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ ﷺ نَبِيًّا» (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "«من قالها ثلاثًا حين يصبح وثلاثًا حين يمسي؛ كان حقًّا على الله أن يرضيه يوم القيامة». أحمد ٤/ ٣٣٧، برقم ١٨٩٦٧، والنسائي في عمل اليوم والليلة، برقم ٤، وابن السني، برقم ٦٨، وأبو داود ٤/ ٣١٨، برقم ١٥٣١، والترمذي ٥/ ٤٦٥، برقم ٣٣٨٩، وحسّنه ابن باز في تحفة الأخيار، ص٣٩."),
                Dhikr(id: "h-27-16", arabic: "«يَا حَيُّ يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الحاكم وصححه، ووافقه الذهبي ١/ ٥٤٥، وانظر: صحيح الترغيب والترهيب ١/ ٢٧٣."),
                Dhikr(id: "h-27-17", arabic: "«أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ رَبِّ الْعَالَمِينَ، اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذَا الْيَوْمِ: فَتْحَهُ، وَنَصْرَهُ، وَنُورَهُ، وَبَرَكَتَهُ، وَهُدَاهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِيهِ وَشَرِّ مَا بَعْدَهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود ٤/ ٣٢٢، برقم ٥٠٨٤، وحسّن إسناده شعيب وعبد القادر الأرناؤوط في تحقيق زاد المعاد ٢/ ٣٧٣."),
                Dhikr(id: "h-27-18", arabic: "«أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ ﷺ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ، حَنِيفًا مُسْلِمًا، وَمَا كَانَ مِنَ الْمُشْرِكِينَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد ٣/ ٤٠٦، و٤٠٧، وبرقم ١٥٣٦٠، ورقم ١٥٥٦٣، وابن السني في عمل اليوم والليلة، برقم ٣٤، وانظر: صحيح الجامع ٤/ ٢٠٩."),
                Dhikr(id: "h-27-19", arabic: "«سُبْحَانَ اللهِ وَبِحَمْدِهِ» (مِائَةَ مَرَّةٍ).", translit: "", translation: "", translationFr: "", count: 100, reference: "«من قالها مائة مرة حين يصبح وحين يمسي؛ لم يأت أحد يوم القيامة بأفضل مما جاء به، إلا أحد قال مثل ما قال أو زاد عليه». مسلم، ٤/ ٢٠٧١ برقم ٢٦٩٢."),
                Dhikr(id: "h-27-20", arabic: "«لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ» (عَشْرَ مَرَّاتٍ)، أَوْ (مَرَّةً وَاحِدَةً عِنْدَ الْكَسَلِ).", translit: "", translation: "", translationFr: "", count: 10, reference: "النسائي في عمل اليوم والليلة، برقم ٢٤، وانظر: صحيح الترغيب والترهيب ١/ ٢٧٢، وتحفة الأخيار لابن باز، ص٤٤، وانظر فضلها في ص١١٠، حديث، رقم ٢٥٥."),
                Dhikr(id: "h-27-21", arabic: "«لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ» (مِائَةَ مَرَّةٍ إِذَا أَصْبَحَ).", translit: "", translation: "", translationFr: "", count: 100, reference: "«من قالها مائة مرة في يوم كانت له عدل عشر رقاب، وكُتِبَ له مائة حسنة، ومُحيت عنه مائة سيئة، وكانت له حرزًا من الشيطان يومه ذلك حتى يمسي، ولم يأت أحد بأفضل مما جاء به إلا أحد عمل أكثر من ذلك». البخاري، ٣٢٩٣، ومسلم، برقم ٢٦٩١."),
                Dhikr(id: "h-27-22", arabic: "«سُبْحَانَ اللهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ» (ثَلَاثَ مَرَّاتٍ إِذَا أَصْبَحَ).", translit: "", translation: "", translationFr: "", count: 3, reference: "مسلم، ٤/ ٢٠٩٠، برقم ٢٧٢٦."),
                Dhikr(id: "h-27-23", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا» (إِذَا أَصْبَحَ).", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه ابن السني في عمل اليوم والليلة، برقم ٥٤، وابن ماجه، برقم ٩٢٥، وحسّن إسناده عبد القادر وشعيب الأرناؤوط في تحقيق زاد المعاد ٢/ ٣٧٥، وتقدم برقم ٧٣."),
                Dhikr(id: "h-27-24", arabic: "«أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ» (مِائَةَ مَرَّةٍ فِي الْيَوْمِ).", translit: "", translation: "", translationFr: "", count: 100, reference: "البخاري برقم ٦٣٠٧، ومسلم ٤/ ٢٠٧٥، برقم ٢٧٠٢."),
                Dhikr(id: "h-27-25", arabic: "«أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ» (ثَلَاثَ مَرَّاتٍ إِذَا أَمْسَى).", translit: "", translation: "", translationFr: "", count: 3, reference: "«من قالها حين يمسي ثلاث مرات لم تضره حُمَة تلك الليلة». أخرجه أحمد ٢/ ٢٩٠، برقم ٧٨٩٨، والنسائي في عمل اليوم والليلة، برقم ٥٩٠، وابن السني، برقم ٦٨، وانظر: صحيح الترمذي ٣/ ١٨٧، وصحيح ابن ماجه ٢/ ٢٦٦، وتحفة الأخيار لابن باز، ص٤٥."),
                Dhikr(id: "h-27-26", arabic: "«اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ» (عَشْرَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 10, reference: "«من صلى عليّ حين يصبح عشرًا، وحين يمسي عشرًا؛ أدركته شفاعتي يوم القيامة». أخرجه الطبراني بإسنادين، أحدهما جيد، انظر: مجمع الزوائد ١٠/ ١٢٠، وصحيح الترغيب والترهيب ١/ ٢٧٣."),
            ]),
            HisnChapter(id: "h-28", number: 28, titleEn: "Before sleeping", titleFr: "Avant de dormir", titleAr: "أَذْكَارُ النَّوْمِ", items: [
                Dhikr(id: "h-28-1", arabic: "«يَجْمَعُ كَفَّيْهِ، ثُمَّ يَنْفُثُ فِيهِمَا، فَيَقْرَأُ فِيهِمَا: بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ ﴿قُلْ هُوَ اللهُ أَحَدٌ ۝ اللهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ ۝﴾ بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ ۝﴾ بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ ﴿قُلْ أَعُوذُ بِرَبِّ...", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
                Dhikr(id: "h-28-2", arabic: "النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾» ثُمَّ يَمْسَحُ بِهِمَا مَا اسْتَطَاعَ مِنْ جَسَدِهِ، يَبْدَأُ بِهِمَا عَلَى رَأْسِهِ وَوَجْهِهِ وَمَا أَقْبَلَ مِنْ جَسَدِهِ (يَفْعَلُ ذَلِكَ ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "البخاري مع الفتح ٩/ ٦٢، برقم ٥٠١٧، ومسلم، برقم ٢١٩٢."),
                Dhikr(id: "h-28-3", arabic: "«اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ﴿٢٥٥﴾».", translit: "", translation: "", translationFr: "", count: 1, reference: "سورة البقرة، الآية: ٢٥٥. «من قرأها إذا أوى إلى فراشه؛ فإنه لن يزال عليه من الله حافظ، ولا يقربه شيطان حتى يصبح». البخاري مع الفتح ٤/ ٤٨٧، برقم ٢٣١١."),
                Dhikr(id: "h-28-4", arabic: "«آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ وَقَالُوا سَمِعْنَا وَأَطَعْنَا غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ﴿٢٨٥﴾ لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ ﴿٢٨٦﴾».", translit: "", translation: "", translationFr: "", count: 1, reference: "«من قرأهما في ليلة؛ كفتاه». البخاري مع الفتح ٩/ ٩٤، برقم ٤٠٠٨، ومسلم ١/ ٥٥٤، برقم ٨٠٧، والآيتان من سورة البقرة ٢٨٥-٢٨٦."),
                Dhikr(id: "h-28-5", arabic: "«بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا، بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٦٣٢٠، ومسلم ٤/ ٢٠٨٤، برقم ٢٧١٤."),
                Dhikr(id: "h-28-6", arabic: "«اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي، وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا. اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه مسلم، برقم ٢٧١٢، وأحمد بلفظه ٢/ ٧٩، برقم ٥٥٠٢."),
                Dhikr(id: "h-28-7", arabic: "«اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ» (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "أبو داود بلفظه ٤/ ٣١١، برقم ٥٠٤٥، والترمذي، برقم ٣٣٩٨، وصححه لغيره محقق المسند، ٤٤/ ٦٥، برقم ٢٦٤٦٤، وانظر: صحيح الترمذي ٣/ ١٤٣، وصحيح أبي داود ٣/ ٢٤٠."),
                Dhikr(id: "h-28-8", arabic: "«بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٦٣٢٤، ومسلم ٤/ ٢٠٨٣، برقم ٢٧١١."),
                Dhikr(id: "h-28-9", arabic: "«سُبْحَانَ اللهِ (ثَلَاثًا وَثَلَاثِينَ)، وَالْحَمْدُ لِلَّهِ (ثَلَاثًا وَثَلَاثِينَ)، وَاللهُ أَكْبَرُ (أَرْبَعًا وَثَلَاثِينَ)».", translit: "", translation: "", translationFr: "", count: 1, reference: "«من قال ذلك عندما يأوي إلى فراشه كان خيراً له من خادم». البخاري مع الفتح ٧/ ٧١، برقم ٣٧٠٥، ومسلم ٤/ ٢٠٩١، برقم ٢٧٢٦."),
                Dhikr(id: "h-28-10", arabic: "«اللَّهُمَّ رَبَّ السَّمَوَاتِ السَّبْعِ وَرَبَّ الْأَرْضِ، وَرَبَّ الْعَرْشِ الْعَظِيمِ، رَبَّنَا وَرَبَّ كُلِّ شَيْءٍ، فَالِقَ الْحَبِّ وَالنَّوَى، وَمُنْزِلَ التَّوْرَاةِ وَالْإِنْجِيلِ وَالْفُرْقَانِ، أَعُوذُ بِكَ مِنْ شَرِّ كُلِّ شَيْءٍ أَنْتَ آخِذٌ بِنَاصِيَتِهِ. اللَّهُمَّ أَنْتَ الْأَوَّلُ فَلَيْسَ قَبْلَكَ شَيْءٌ، وَأَنْتَ الْآخِرُ فَلَيْسَ بَعْدَكَ شَيْءٌ، وَأَنْتَ الظَّاهِرُ فَلَيْسَ فَوْقَكَ شَيْءٌ، وَأَنْتَ الْبَاطِنُ فَلَيْسَ دُونَكَ شَيْءٌ، اقْضِ عَنَّا الدَّيْنَ، وَأَغْنِنَا مِنَ الْفَقْرِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم ٤/ ٢٠٨٤، برقم ٢٧١٣."),
                Dhikr(id: "h-28-11", arabic: "«الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا، وَسَقَانَا، وَكَفَانَا، وَآوَانَا، فَكَمْ مِمَّنْ لَا كَافِيَ لَهُ وَلَا مُؤْوِيَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم ٤/ ٢٠٨٥، برقم ٢٧١٥."),
                Dhikr(id: "h-28-12", arabic: "«اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، فَاطِرَ السَّمَوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود ٤/ ٣١٧، برقم ٥٠٦٧، والترمذي، برقم ٣٦٢٩، وانظر: صحيح الترمذي ٣/ ١٤٢."),
                Dhikr(id: "h-28-13", arabic: "«يَقْرَأُ ﴿الم﴾ تَنْزِيلَ السَّجْدَةِ، وَتَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٤٠٤، والنسائي في عمل اليوم والليلة، برقم ٧٠٧، وانظر: صحيح الجامع ٤/ ٢٥٥."),
                Dhikr(id: "h-28-14", arabic: "«اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "«فإن مُتَّ، مُتَّ على الفطرة». البخاري مع الفتح ١١/ ١١٣، برقم ٦٣١٣، ومسلم، برقم ٢٧١٠."),
            ]),
            HisnChapter(id: "h-29", number: 29, titleEn: "Turning over at night", titleFr: "En se retournant la nuit", titleAr: "الدعاء إذا تقلب ليلاً", items: [
                Dhikr(id: "h-29-1", arabic: "«لَا إِلَٰهَ إِلَّا اللَّهُ الْوَاحِدُ الْقَهَّارُ، رَبُّ السَّمَوَاتِ وَالْأَرْضِ وَمَا بَيْنَهُمَا الْعَزِيزُ الْغَفَّارُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "يقول ذلك من تقلب من جنب إلى جنب في الليل. أخرجه الحاكم، وصححه، ووافقه الذهبي، ١/ ٥٤٠، والنسائي في عمل اليوم والليلة، برقم ٢٠٢، وابن السني، برقم ٧٥٧، وانظر: صحيح الجامع ٤/ ٢١٣."),
            ]),
            HisnChapter(id: "h-30", number: 30, titleEn: "Fright & loneliness at night", titleFr: "Frayeur et solitude nocturne", titleAr: "دعاء الفزع في النوم، ومن بلي بالوحشة", items: [
                Dhikr(id: "h-30-1", arabic: "«أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ، وَأَنْ يَحْضُرُونِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود ٤/ ١٢، برقم ٣٨٩٣، والترمذي، برقم ٣٥٢٨، وانظر: صحيح الترمذي ٣/ ١٧١."),
            ]),
            HisnChapter(id: "h-31", number: 31, titleEn: "Upon a dream or nightmare", titleFr: "Après un rêve", titleAr: "ما يفعل من رأى الرؤيا أو الحلم", items: [
                Dhikr(id: "h-31-1", arabic: "«يَنْفُثُ عَنْ يَسَارِهِ» (ثَلَاثًا).", translit: "", translation: "", translationFr: "", count: 3, reference: "مسلم ٤/ ١٧٧٢، برقم ٢٢٦١."),
                Dhikr(id: "h-31-2", arabic: "«يَسْتَعِيذُ بِاللهِ مِنَ الشَّيْطَانِ، وَمِنْ شَرِّ مَا رَأَى» (ثَلَاثَ مَرَّاتٍ).", translit: "", translation: "", translationFr: "", count: 3, reference: "مسلم ٤/ ١٧٧٢، ١٧٧٣، برقم ٢٢٦١، ورقم ٢٢٦٢."),
                Dhikr(id: "h-31-3", arabic: "«لَا يُحَدِّثْ بِهَا أَحَدًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم ٤/ ١٧٧٢، برقم ٢٢٦١، ورقم ٢٢٦٣."),
                Dhikr(id: "h-31-4", arabic: "«يَتَحَوَّلُ عَنْ جَنْبِهِ الَّذِي كَانَ عَلَيْهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم ٤/ ١٧٧٣، برقم ٢٢٦١."),
                Dhikr(id: "h-31-5", arabic: "«يَقُومُ يُصَلِّي؛ إِنْ أَرَادَ ذَلِكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم ٤/ ١٧٧٣، برقم ٢٢٦٣."),
            ]),
        ]),
    HisnSection(key: "distress", icon: "cloud.bolt.rain.fill",
        titleEn: "Worry, Distress & Hardship", titleFr: "Souci, détresse et épreuve", titleAr: "الهمّ والكرب والشدائد",
        subtitleEn: "In difficulty", subtitleFr: "Dans la difficulté", subtitleAr: "عند الشدة",
        chapters: [
            HisnChapter(id: "h-34", number: 34, titleEn: "Anxiety & sorrow", titleFr: "Angoisse et tristesse", titleAr: "دعاء الهم والحزن", items: [
                Dhikr(id: "h-34-1", arabic: "اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ؛ أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه أحمد، وصححه الألباني"),
                Dhikr(id: "h-34-2", arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ، وَغَلَبَةِ الرِّجَالِ", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه البخاري"),
            ]),
            HisnChapter(id: "h-35", number: 35, titleEn: "Distress (karb)", titleFr: "La détresse", titleAr: "دعاء الكرب", items: [
                Dhikr(id: "h-35-1", arabic: "لَا إِلَٰهَ إِلَّا اللهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَٰهَ إِلَّا اللهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَٰهَ إِلَّا اللهُ رَبُّ السَّمَٰوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ", translit: "", translation: "", translationFr: "", count: 1, reference: "متفق عليه (البخاري ومسلم)"),
                Dhikr(id: "h-35-2", arabic: "اللَّهُمَّ رَحْمَتَكَ أَرْجُو، فَلَا تَكِلْنِي إِلَىٰ نَفْسِي طَرْفَةَ عَيْنٍ، وَأَصْلِحْ لِي شَأْنِي كُلَّهُ، لَا إِلَٰهَ إِلَّا أَنْتَ", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه أبو داود، وأحمد"),
                Dhikr(id: "h-35-3", arabic: "لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه الترمذي، والحاكم"),
                Dhikr(id: "h-35-4", arabic: "اللهُ اللهُ رَبِّي، لَا أُشْرِكُ بِهِ شَيْئًا", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه أبو داود، وابن ماجه"),
            ]),
            HisnChapter(id: "h-36", number: 36, titleEn: "Meeting an enemy or ruler", titleFr: "Rencontrer un ennemi ou un chef", titleAr: "دعاء لقاء العدو وذي السلطان", items: [
                Dhikr(id: "h-36-1", arabic: "«اللَّهُمَّ إِنَّا نَجْعَلُكَ فِي نُحُورِهِمْ، وَنَعُوذُ بِكَ مِنْ شُرُورِهِمْ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ١٥٣٧، وصححه الحاكم، ووافقه الذهبي، ٢/ ١٤٢."),
                Dhikr(id: "h-36-2", arabic: "«اللَّهُمَّ أَنْتَ عَضُدِي، وَأَنْتَ نَصِيرِي، بِكَ أَحُولُ، وَبِكَ أَصُولُ، وَبِكَ أُقَاتِلُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢٦٣٢، والترمذي، ٣٥٨٤، وانظر: صحيح الترمذي، ٣/ ١٨٣."),
                Dhikr(id: "h-36-3", arabic: "«حَسْبُنَا اللهُ وَنِعْمَ الْوَكِيلُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٥/ ١٧٢، برقم ٤٥٦٣."),
            ]),
            HisnChapter(id: "h-37", number: 37, titleEn: "A ruler's injustice", titleFr: "L'injustice d'un dirigeant", titleAr: "دعاء من خاف ظلم السلطان", items: [
                Dhikr(id: "h-37-1", arabic: "«اللَّهُمَّ رَبَّ السَّمَوَاتِ السَّبْعِ، وَرَبَّ الْعَرْشِ الْعَظِيمِ، كُنْ لِي جَارًا مِنْ فُلَانِ بْنِ فُلَانٍ، وَأَحْزَابِهِ مِنْ خَلَائِقِكَ، أَنْ يَفْرُطَ عَلَيَّ أَحَدٌ مِنْهُمْ أَوْ يَطْغَى، عَزَّ جَارُكَ، وَجَلَّ ثَنَاؤُكَ، وَلَا إِلَهَ إِلَّا أَنْتَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري في الأدب المفرد، برقم ٧٠٧، وصححه الألباني في صحيح الأدب المفرد، برقم ٥٤٥."),
                Dhikr(id: "h-37-2", arabic: "«اللهُ أَكْبَرُ، اللهُ أَعَزُّ مِنْ خَلْقِهِ جَمِيعًا، اللهُ أَعَزُّ مِمَّا أَخَافُ وَأَحْذَرُ، أَعُوذُ بِاللهِ الَّذِي لَا إِلَهَ إِلَّا هُوَ، الْمُمْسِكِ السَّمَوَاتِ السَّبْعِ أَنْ يَقَعْنَ عَلَى الْأَرْضِ إِلَّا بِإِذْنِهِ، مِنْ شَرِّ عَبْدِكَ فُلَانٍ، وَجُنُودِهِ وَأَتْبَاعِهِ وَأَشْيَاعِهِ، مِنَ الْجِنِّ وَالْإِنْسِ، اللَّهُمَّ كُنْ لِي جَارًا مِنْ شَرِّهِمْ، جَلَّ ثَنَاؤُكَ، وَعَزَّ جَارُكَ، وَتَبَارَكَ اسْمُكَ، وَلَا إِلَهَ غَيْرُكَ» (ثَلَاثَ مَرَّاتٍ)", translit: "", translation: "", translationFr: "", count: 3, reference: "البخاري في الأدب المفرد برقم ٧٠٨، وصححه الألباني في صحيح الأدب المفرد، برقم ٥٤٦."),
            ]),
            HisnChapter(id: "h-38", number: 38, titleEn: "Against an enemy", titleFr: "Contre un ennemi", titleAr: "الدعاء على العدو", items: [
                Dhikr(id: "h-38-1", arabic: "«اللَّهُمَّ مُنْزِلَ الْكِتَابِ، سَرِيعَ الْحِسَابِ، اهْزِمِ الْأَحْزَابَ، اللَّهُمَّ اهْزِمْهُمْ وَزَلْزِلْهُمْ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٣/ ١٣٦٢، برقم ١٧٤٢."),
            ]),
            HisnChapter(id: "h-39", number: 39, titleEn: "Fear of a people", titleFr: "La peur d'un peuple", titleAr: "ما يقول من خاف قوماً", items: [
                Dhikr(id: "h-39-1", arabic: "«اللَّهُمَّ اكْفِنِيهِمْ بِمَا شِئْتَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/ ٢٣٠٠، برقم ٣٠٠٥."),
            ]),
            HisnChapter(id: "h-40", number: 40, titleEn: "Whispers in faith", titleFr: "Les insufflations dans la foi", titleAr: "دعاء من أصابه وسوسة في الإيمان", items: [
                Dhikr(id: "h-40-1", arabic: "«يَسْتَعِيذُ بِاللهِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٦/ ٣٣٦، برقم ٣٢٧٦، ومسلم، برقم ١٣٤."),
                Dhikr(id: "h-40-2", arabic: "«يَنْتَهِي عَمَّا وَسْوَسَ فِيهِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٦/ ٣٣٦، برقم ٣٢٧٦، ومسلم، برقم ١٣٤."),
                Dhikr(id: "h-40-3", arabic: "يَقُولُ: «آمَنْتُ بِاللهِ وَرُسُلِهِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ١١٩- ١٢٠، برقم ١٣٤."),
                Dhikr(id: "h-40-4", arabic: "يَقْرَأُ قَوْلَهُ تَعَالَى: ﴿هُوَ الْأَوَّلُ وَالْآخِرُ وَالظَّاهِرُ وَالْبَاطِنُ وَهُوَ بِكُلِّ شَيْءٍ عَلِيمٌ﴾", translit: "", translation: "", translationFr: "", count: 1, reference: "سورة الحديد، الآية: ٣. أبو داود، ٤/ ٣٢٩، برقم ٥١١٠، وحسنه الألباني في صحيح أبي داود، ٣/ ٩٦٢."),
            ]),
            HisnChapter(id: "h-41", number: 41, titleEn: "Settling a debt", titleFr: "S'acquitter d'une dette", titleAr: "دعاء قضاء الدين", items: [
                Dhikr(id: "h-41-1", arabic: "«اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٥٦٣، وانظر: صحيح الترمذي، ٣/ ١٨٠."),
                Dhikr(id: "h-41-2", arabic: "«اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ، وَغَلَبَةِ الرِّجَالِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٧/ ١٥٨، برقم ٢٨٩٣، وتقدم ص ٦٣، برقم ١٢١."),
            ]),
            HisnChapter(id: "h-42", number: 42, titleEn: "Whispers in prayer", titleFr: "Insufflations dans la prière", titleAr: "دعاء الوسوسة في الصلاة والقراءة", items: [
                Dhikr(id: "h-42-1", arabic: "«أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ، وَاتْفُلْ عَلَى يَسَارِكَ (ثَلَاثًا)»", translit: "", translation: "", translationFr: "", count: 3, reference: "مسلم، ٤/ ١٧٢٩، برقم ٢٢٠٣، من حديث عثمان بن أبي العاص ﷺ، وفيه: ففعلت ذلك، فأذهبه الله عني."),
            ]),
            HisnChapter(id: "h-43", number: 43, titleEn: "A difficult matter", titleFr: "Une affaire difficile", titleAr: "دعاء من استصعب عليه أمر", items: [
                Dhikr(id: "h-43-1", arabic: "«اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزَنَ إِذَا شِئْتَ سَهْلًا»", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه ابن حبان في صحيحه، برقم ٢٤٢٧ (موارد)، وابن السني، برقم ٣٥١، وقال الحافظ: «هذا حديث صحيح»، وصححه عبد القادر الأرناؤوط في تخريج الأذكار للنووي، ص ١٠٦."),
            ]),
            HisnChapter(id: "h-44", number: 44, titleEn: "After a sin", titleFr: "Après un péché", titleAr: "ما يقول ويفعل من أذنب ذنباً", items: [
                Dhikr(id: "h-44-1", arabic: "«مَا مِنْ عَبْدٍ يُذْنِبُ ذَنْبًا، فَيُحْسِنُ الطُّهُورَ، ثُمَّ يَقُومُ، فَيُصَلِّي رَكْعَتَيْنِ، ثُمَّ يَسْتَغْفِرُ اللهَ؛ إِلَّا غَفَرَ اللهُ لَهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ٨٦، برقم ١٥٢١، والترمذي، ٢/ ٢٥٧، برقم ٤٠٦، وصححه الألباني في صحيح أبي داود، ١/ ٢٨٣."),
            ]),
            HisnChapter(id: "h-45", number: 45, titleEn: "Repelling Satan's whispers", titleFr: "Repousser le diable", titleAr: "دعاء طرد الشيطان ووساوسه", items: [
                Dhikr(id: "h-45-1", arabic: "«الِاسْتِعَاذَةُ بِاللهِ مِنْهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٧٦٤، وابن ماجه، برقم ٨٠٧، وتقدم تخريجه برقم ٣١، وانظر: سورة المؤمنون، الآيتان: ٩٧-٩٨."),
                Dhikr(id: "h-45-2", arabic: "«الْأَذَانُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٢٩١، برقم ٣٨٩، والبخاري، ١/ ١٥١، برقم ٦٠٨."),
                Dhikr(id: "h-45-3", arabic: "«الْأَذْكَارُ، وَقِرَاءَةُ الْقُرْآنِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "«لا تجعلوا بيوتكم مقابر، إن الشيطان ينفر من البيت الذي تُقرأ فيه سورة البقرة». رواه مسلم، ١/ ٥٣٩، برقم ٧٨٠."),
            ]),
            HisnChapter(id: "h-46", number: 46, titleEn: "When displeased", titleFr: "Quand survient un déplaisir", titleAr: "الدعاء حينما يقع ما لا يرضاه أو غلب على أمره", items: [
                Dhikr(id: "h-46-1", arabic: "«قَدَّرَ اللهُ، وَمَا شَاءَ فَعَلَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "«المؤمن القوي خير وأحب إلى الله من المؤمن الضعيف، وفي كلٍّ خير، احرص على ما ينفعك، واستعن بالله ولا تعجز، وإن أصابك شيء فلا تقل: لو أني فعلت كان كذا وكذا، ولكن قل: قَدَرُ الله، وما شاء فعل، فإنَّ لو تفتح عمل الشيطان». مسلم، برقم ٢٦٦٤."),
            ]),
            HisnChapter(id: "h-82", number: 82, titleEn: "Anger", titleFr: "La colère", titleAr: "دعاء الغضب", items: [
                Dhikr(id: "h-82-1", arabic: "«أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٧/ ٩٩، برقم ٣٢٨٢، ومسلم، ٤/ ٢٠١٥، برقم ٢٦١٠."),
            ]),
        ]),
    HisnSection(key: "health", icon: "cross.case.fill",
        titleEn: "Sickness, Death & Grief", titleFr: "Maladie, mort et deuil", titleAr: "المرض والموت والتعزية",
        subtitleEn: "Trials & farewells", subtitleFr: "Épreuves et adieux", subtitleAr: "الابتلاء والوداع",
        chapters: [
            HisnChapter(id: "h-49", number: 49, titleEn: "Visiting the sick", titleFr: "Visiter un malade", titleAr: "الدعاء للمريض في عيادته", items: [
                Dhikr(id: "h-49-1", arabic: "«لَا بَأْسَ، طَهُورٌ إِنْ شَاءَ اللهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١٠/ ١١٨، برقم ٣٦١٦."),
                Dhikr(id: "h-49-2", arabic: "«أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ» (سَبْعَ مَرَّاتٍ)", translit: "", translation: "", translationFr: "", count: 7, reference: "«ما من عبد مسلم يعُود مريضًا لم يحضر أجله، فيقول سبع مرات.. إلا عوفي» الحديث. أخرجه الترمذي، برقم ٢٠٨٣، وأبو داود، برقم ٣١٠٦، وانظر: صحيح الترمذي، ٢/ ٢١٠، وصحيح الجامع، ٥/ ١٨٠."),
            ]),
            HisnChapter(id: "h-50", number: 50, titleEn: "Virtue of visiting the sick", titleFr: "Mérite de visiter un malade", titleAr: "فضل عيادة المريض", items: [
                Dhikr(id: "h-50-1", arabic: "قَالَ النَّبِيُّ ﷺ: «إِذَا عَادَ الرَّجُلُ أَخَاهُ الْمُسْلِمَ؛ مَشَى فِي خِرَافَةِ الْجَنَّةِ حَتَّى يَجْلِسَ، فَإِذَا جَلَسَ غَمَرَتْهُ الرَّحْمَةُ، فَإِنْ كَانَ غُدْوَةً صَلَّى عَلَيْهِ سَبْعُونَ أَلْفَ مَلَكٍ حَتَّى يُمْسِيَ، وَإِنْ كَانَ مَسَاءً صَلَّى عَلَيْهِ سَبْعُونَ أَلْفَ مَلَكٍ حَتَّى يُصْبِحَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه الترمذي، برقم ٩٦٩، وابن ماجه، برقم ١٤٤٢، وأحمد، برقم ٩٧٥، وانظر: صحيح ابن ماجه، ١/ ٢٤٤ وصحيح الترمذي، ١/ ٢٨٦، وصححه أيضًا أحمد شاكر."),
            ]),
            HisnChapter(id: "h-51", number: 51, titleEn: "A patient who despairs", titleFr: "Un malade désespéré", titleAr: "دعاء المريض الذي يئس من حياته", items: [
                Dhikr(id: "h-51-1", arabic: "«اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَأَلْحِقْنِي بِالرَّفِيقِ الْأَعْلَى»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٤٤٣٥، ومسلم، ٤/ ١٨٩٣، برقم ٢٤٤٤."),
                Dhikr(id: "h-51-2", arabic: "«جَعَلَ النَّبِيُّ ﷺ عِنْدَ مَوْتِهِ يُدْخِلُ يَدَيْهِ فِي الْمَاءِ، فَيَمْسَحُ بِهِمَا وَجْهَهُ، وَيَقُولُ: لَا إِلَهَ إِلَّا اللهُ، إِنَّ لِلْمَوْتِ سَكَرَاتٍ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٨/ ١٤٤، برقم ٤٤٤٩، وفي الحديث: ذكر السواك."),
            ]),
            HisnChapter(id: "h-52", number: 52, titleEn: "Prompting the dying", titleFr: "Suggérer au mourant", titleAr: "تَلْقِينُ الْمُحْتَضَرِ", items: [
                Dhikr(id: "h-52-1", arabic: "«مَنْ كَانَ آخِرَ كَلَامِهِ: لَا إِلَهَ إِلَّا اللهُ؛ دَخَلَ الْجَنَّةَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٣١١٦، وانظر: صحيح الجامع، ٥/ ٤٣٢."),
            ]),
            HisnChapter(id: "h-53", number: 53, titleEn: "When struck by calamity", titleFr: "Frappé d'un malheur", titleAr: "دُعَاءُ مَنْ أُصِيبَ بِمُصِيبَةٍ", items: [
                Dhikr(id: "h-53-1", arabic: "«إِنَّا لِلَّهِ، وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي، وَأَخْلِفْ لِي خَيْرًا مِنْهَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٦٣٢، برقم ٩١٨."),
            ]),
            HisnChapter(id: "h-54", number: 54, titleEn: "Closing the eyes of the dead", titleFr: "Fermer les yeux du défunt", titleAr: "الدُّعَاءُ عِنْدَ إِغْمَاضِ الْمَيِّتِ", items: [
                Dhikr(id: "h-54-1", arabic: "«اللَّهُمَّ اغْفِرْ لِفُلَانٍ (بِاسْمِهِ)، وَارْفَعْ دَرَجَتَهُ فِي الْمَهْدِيِّينَ، وَاخْلُفْهُ فِي عَقِبِهِ فِي الْغَابِرِينَ، وَاغْفِرْ لَنَا وَلَهُ، يَا رَبَّ الْعَالَمِينَ، وَافْسَحْ لَهُ فِي قَبْرِهِ، وَنَوِّرْ لَهُ فِيهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٦٣٤، برقم ٩٢٠."),
            ]),
            HisnChapter(id: "h-55", number: 55, titleEn: "For the deceased in prayer", titleFr: "Pour le défunt en prière", titleAr: "الدُّعَاءُ لِلْمَيِّتِ فِي الصَّلَاةِ عَلَيْهِ", items: [
                Dhikr(id: "h-55-1", arabic: "«اللَّهُمَّ اغْفِرْ لَهُ، وَارْحَمْهُ، وَعَافِهِ، وَاعْفُ عَنْهُ، وَأَكْرِمْ نُزُلَهُ، وَوَسِّعْ مُدْخَلَهُ، وَاغْسِلْهُ بِالْمَاءِ وَالثَّلْجِ وَالْبَرَدِ، وَنَقِّهِ مِنَ الْخَطَايَا كَمَا نَقَّيْتَ الثَّوْبَ الْأَبْيَضَ مِنَ الدَّنَسِ، وَأَبْدِلْهُ دَارًا خَيْرًا مِنْ دَارِهِ، وَأَهْلًا خَيْرًا مِنْ أَهْلِهِ، وَزَوْجًا خَيْرًا مِنْ زَوْجِهِ، وَأَدْخِلْهُ الْجَنَّةَ، وَأَعِذْهُ مِنْ عَذَابِ الْقَبْرِ [وَعَذَابِ النَّارِ]».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٦٦٣، برقم ٩٦٣."),
                Dhikr(id: "h-55-2", arabic: "«اللَّهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا، وَشَاهِدِنَا وَغَائِبِنَا، وَصَغِيرِنَا وَكَبِيرِنَا، وَذَكَرِنَا وَأُنْثَانَا. اللَّهُمَّ مَنْ أَحْيَيْتَهُ مِنَّا فَأَحْيِهِ عَلَى الْإِسْلَامِ، وَمَنْ تَوَفَّيْتَهُ مِنَّا فَتَوَفَّهُ عَلَى الْإِيمَانِ، اللَّهُمَّ لَا تَحْرِمْنَا أَجْرَهُ، وَلَا تُضِلَّنَا بَعْدَهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٣٢٠١، والترمذي، برقم ١٠٢٤، والنسائي، برقم ١٩٨٥، وابن ماجه، برقم ١٤٩٨، وأحمد، ٢/ ٣٦٨، برقم ٨٨٠٩، وانظر: صحيح ابن ماجه، ١/ ٢٥١."),
                Dhikr(id: "h-55-3", arabic: "«اللَّهُمَّ إِنَّ فُلَانَ بْنَ فُلَانٍ فِي ذِمَّتِكَ، وَحَبْلِ جِوَارِكَ، فَقِهِ مِنْ فِتْنَةِ الْقَبْرِ، وَعَذَابِ النَّارِ، وَأَنْتَ أَهْلُ الْوَفَاءِ وَالْحَقِّ، فَاغْفِرْ لَهُ، وَارْحَمْهُ، إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه ابن ماجه، برقم ١٤٩٩، انظر: صحيح ابن ماجه، ١/ ٢٥١، ورواه أبو داود، ٣/ ٢١١، برقم ٣٢٠٢."),
                Dhikr(id: "h-55-4", arabic: "«اللَّهُمَّ عَبْدُكَ وَابْنُ أَمَتِكَ، احْتَاجَ إِلَى رَحْمَتِكَ، وَأَنْتَ غَنِيٌّ عَنْ عَذَابِهِ، إِنْ كَانَ مُحْسِنًا فَزِدْ فِي حَسَنَاتِهِ، وَإِنْ كَانَ مُسِيئًا فَتَجَاوَزْ عَنْهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه الحاكم وصححه، ووافقه الذهبي، ١/ ٣٥٩، وانظر: أحكام الجنائز للألباني، ص١٢٥."),
            ]),
            HisnChapter(id: "h-56", number: 56, titleEn: "For a deceased child", titleFr: "Pour un enfant défunt", titleAr: "الدُّعَاءُ لِلْفَرَطِ فِي الصَّلَاةِ عَلَيْهِ", items: [
                Dhikr(id: "h-56-1", arabic: "«اللَّهُمَّ أَعِذْهُ مِنْ عَذَابِ الْقَبْرِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "قال سعيد بن المسيب: صلَّيْتُ وراء أبي هريرة على صبي لم يعمل خطيئة قطُّ، فسمعته يقول.. الحديث. أخرجه مالك في الموطأ، ١/ ٢٨٨، وابن أبي شيبة في المصنف، ٣/ ٢١٧، والبيهقي، ٤/ ٩، وصحح إسناده شعيب الأرناؤوط في تحقيقه لشرح السنة للبغوي، ٥/ ٣٥٧."),
                Dhikr(id: "h-56-2", arabic: "وَإِنْ قَالَ: «اللَّهُمَّ اجْعَلْهُ فَرَطًا وَذُخْرًا لِوَالِدَيْهِ، وَشَفِيعًا مُجَابًا، اللَّهُمَّ ثَقِّلْ بِهِ مَوَازِينَهُمَا، وَأَعْظِمْ بِهِ أُجُورَهُمَا، وَأَلْحِقْهُ بِصَالِحِ الْمُؤْمِنِينَ، وَاجْعَلْهُ فِي كَفَالَةِ إِبْرَاهِيمَ، وَقِهِ بِرَحْمَتِكَ عَذَابَ الْجَحِيمِ، وَأَبْدِلْهُ دَارًا خَيْرًا مِنْ دَارِهِ، وَأَهْلًا خَيْرًا مِنْ أَهْلِهِ، اللَّهُمَّ اغْفِرْ لِأَسْلَافِنَا، وَأَفْرَاطِنَا، وَمَنْ سَبَقَنَا بِالْإِيمَانِ»؛ فَحَسَنٌ.", translit: "", translation: "", translationFr: "", count: 1, reference: "انظر: المغني لابن قدامة، ٣/ ٤١٦، والدروس المهمة لعامة الأمة، للشيخ عبد العزيز بن عبد الله بن باز رحمه الله، ص١٥."),
                Dhikr(id: "h-56-3", arabic: "«اللَّهُمَّ اجْعَلْهُ لَنَا فَرَطًا، وَسَلَفًا، وَأَجْرًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "كان الحسن يقرأ على الطفل بفاتحة الكتاب، ويقول... الحديث. أخرجه البغوي في شرح السنة، ٥/ ٣٥٧، وعبد الرزاق، برقم ٦٥٨٨، وعلقه البخاري في كتاب الجنائز، ٦٥ باب قراءة فاتحة الكتاب على الجنازة، ٢/ ١١٣، قبل الحديث رقم ١٣٣٥."),
            ]),
            HisnChapter(id: "h-57", number: 57, titleEn: "Condolence", titleFr: "Les condoléances", titleAr: "دُعَاءُ التَّعْزِيَةِ", items: [
                Dhikr(id: "h-57-1", arabic: "«إِنَّ لِلَّهِ مَا أَخَذَ، وَلَهُ مَا أَعْطَى، وَكُلُّ شَيْءٍ عِنْدَهُ بِأَجَلٍ مُسَمًّى... فَلْتَصْبِرْ وَلْتَحْتَسِبْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٢/ ٨٠، برقم ١٢٨٤، ومسلم، ٢/ ٦٣٦، برقم ٩٢٣."),
                Dhikr(id: "h-57-2", arabic: "وَإِنْ قَالَ: «أَعْظَمَ اللهُ أَجْرَكَ، وَأَحْسَنَ عَزَاءَكَ، وَغَفَرَ لِمَيِّتِكَ»؛ فَحَسَنٌ.", translit: "", translation: "", translationFr: "", count: 1, reference: "الأذكار للنووي، ص١٢٦."),
            ]),
            HisnChapter(id: "h-58", number: 58, titleEn: "Placing the dead in the grave", titleFr: "Descendre le défunt en tombe", titleAr: "الدُّعَاءُ عِنْدَ إِدْخَالِ الْمَيِّتِ الْقَبْرَ", items: [
                Dhikr(id: "h-58-1", arabic: "«بِسْمِ اللهِ، وَعَلَى سُنَّةِ رَسُولِ اللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٣٢١٥، بسند صحيح، وأحمد، برقم ٥٢٣٤، ورقم ٤٤١٢، بلفظ: «بِسْمِ اللهِ، وَعَلَى مِلَّةِ رَسُولِ اللهِ». وسنده صحيح."),
            ]),
            HisnChapter(id: "h-59", number: 59, titleEn: "After burial", titleFr: "Après l'enterrement", titleAr: "الدُّعَاءُ بَعْدَ دَفْنِ الْمَيِّتِ", items: [
                Dhikr(id: "h-59-1", arabic: "«اللَّهُمَّ اغْفِرْ لَهُ، اللَّهُمَّ ثَبِّتْهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "كان النبي ﷺ إذا فرغ من دفن الميت وقف عليه وقال: «اسْتَغْفِرُوا لِأَخِيكُمْ، وَسَلُوا لَهُ التَّثْبِيتَ؛ فَإِنَّهُ الْآنَ يُسْأَلُ». أبو داود، ٣/ ٣١٥، برقم ٣٢٢٣، والحاكم وصححه، ووافقه الذهبي، ١/ ٣٧٠."),
            ]),
            HisnChapter(id: "h-60", number: 60, titleEn: "Visiting graves", titleFr: "Visiter les tombes", titleAr: "دُعَاءُ زِيَارَةِ الْقُبُورِ", items: [
                Dhikr(id: "h-60-1", arabic: "«السَّلَامُ عَلَيْكُمْ أَهْلَ الدِّيَارِ، مِنَ الْمُؤْمِنِينَ وَالْمُسْلِمِينَ، وَإِنَّا -إِنْ شَاءَ اللهُ- بِكُمْ لَاحِقُونَ، [وَيَرْحَمُ اللهُ الْمُسْتَقْدِمِينَ مِنَّا وَالْمُسْتَأْخِرِينَ]، أَسْأَلُ اللهَ لَنَا وَلَكُمُ الْعَافِيَةَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٦٧١، برقم ٩٧٥، وابن ماجه، ١/ ٤٩٤، واللفظ له، برقم ١٥٤٧ عن بريدة رضي الله عنه، وما بين المعقوفين من حديث عائشة رضي الله عنها عند مسلم، ٢/ ٦٧١، برقم ٩٧٥."),
            ]),
            HisnChapter(id: "h-124", number: 124, titleEn: "Pain in the body", titleFr: "Douleur dans le corps", titleAr: "ما يفعل ويقول من أحس وجعا في جسده", items: [
                Dhikr(id: "h-124-1", arabic: "«ضَعْ يَدَكَ عَلَى الَّذِي تَأَلَّمَ مِنْ جَسَدِكَ، وَقُلْ: بِسْمِ اللهِ، ثَلَاثًا، وَقُلْ سَبْعَ مَرَّاتٍ: أَعُوذُ بِاللهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ».", translit: "", translation: "", translationFr: "", count: 7, reference: "مسلم، ٤/ ١٧٢٨، برقم ٢٢٠٢."),
            ]),
        ]),
    HisnSection(key: "weather", icon: "cloud.sun.fill",
        titleEn: "Weather & Nature", titleFr: "Météo et nature", titleAr: "الطقس والطبيعة",
        subtitleEn: "Signs in creation", subtitleFr: "Les signes de la création", subtitleAr: "آيات الكون",
        chapters: [
            HisnChapter(id: "h-61", number: 61, titleEn: "The wind", titleFr: "Le vent", titleAr: "دُعَاءُ الرِّيحِ", items: [
                Dhikr(id: "h-61-1", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّهَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، ٤/ ٣٢٦، برقم ٥٠٩٩، وابن ماجه، ٢/ ١٢٢٨، برقم ٣٧٢٧، وانظر: صحيح ابن ماجه، ٢/ ٣٠٥."),
                Dhikr(id: "h-61-2", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَخَيْرَ مَا فِيهَا، وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا، وَشَرِّ مَا فِيهَا، وَشَرِّ مَا أُرْسِلَتْ بِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، واللفظ له، ٢/ ٦٦٦، برقم ٨٩٩، والبخاري، ٤/ ٧٦ برقم ٣٢٠٦، ورقم ٤٨٢٩."),
            ]),
            HisnChapter(id: "h-62", number: 62, titleEn: "The thunder", titleFr: "Le tonnerre", titleAr: "دُعَاءُ الرَّعْدِ", items: [
                Dhikr(id: "h-62-1", arabic: "«سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "كان عبد الله بن الزبير رضي الله عنهما إذا سمع الرعد ترك الحديث، وقال:... الحديث. الموطأ، ٢/ ٩٩٢، وقال الألباني في صحيح الكلم الطيب، ١٥٧: «صحيح الإسناد موقوفا»."),
            ]),
            HisnChapter(id: "h-63", number: 63, titleEn: "Seeking rain", titleFr: "Demander la pluie", titleAr: "مِنْ أَدْعِيَةِ الِاسْتِسْقَاءِ", items: [
                Dhikr(id: "h-63-1", arabic: "«اللَّهُمَّ اسْقِنَا غَيْثًا مُغِيثًا مَرِيئًا مَرِيعًا، نَافِعًا غَيْرَ ضَارٍّ، عَاجِلًا غَيْرَ آجِلٍ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ١١٧١، وصححه الألباني في صحيح أبي داود، ١/ ٢١٦."),
                Dhikr(id: "h-63-2", arabic: "«اللَّهُمَّ أَغِثْنَا، اللَّهُمَّ أَغِثْنَا، اللَّهُمَّ أَغِثْنَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/ ٢٢٤، برقم ١٠١٤، ومسلم، ٢/ ٦١٣، برقم ٨٩٧."),
                Dhikr(id: "h-63-3", arabic: "«اللَّهُمَّ اسْقِ عِبَادَكَ، وَبَهَائِمَكَ، وَانْشُرْ رَحْمَتَكَ، وَأَحْيِ بَلَدَكَ الْمَيِّتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ١١٧٨، وحسنه الألباني في صحيح أبي داود، ١/ ٢١٨."),
            ]),
            HisnChapter(id: "h-64", number: 64, titleEn: "When it rains", titleFr: "Quand il pleut", titleAr: "الدُّعَاءُ إِذَا رَأَى الْمَطَرَ", items: [
                Dhikr(id: "h-64-1", arabic: "«اللَّهُمَّ صَيِّبًا نَافِعًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٢/ ٥١٨، برقم ١٠٣٢."),
            ]),
            HisnChapter(id: "h-65", number: 65, titleEn: "After rainfall", titleFr: "Après la pluie", titleAr: "الذِّكْرُ بَعْدَ نُزُولِ الْمَطَرِ", items: [
                Dhikr(id: "h-65-1", arabic: "«مُطِرْنَا بِفَضْلِ اللهِ وَرَحْمَتِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/ ٢٠٥، برقم ٨٤٦، ومسلم، ١/ ٨٣، برقم ٧١."),
            ]),
            HisnChapter(id: "h-66", number: 66, titleEn: "Seeking clear skies", titleFr: "Demander l’éclaircie", titleAr: "مِنْ أَدْعِيَةِ الِاسْتِصْحَاءِ", items: [
                Dhikr(id: "h-66-1", arabic: "«اللَّهُمَّ حَوَالَيْنَا، وَلَا عَلَيْنَا، اللَّهُمَّ عَلَى الْآكَامِ وَالظِّرَابِ، وَبُطُونِ الْأَوْدِيَةِ، وَمَنَابِتِ الشَّجَرِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ١/ ٢٢٤، برقم ٩٣٣، ومسلم، ٢/ ٦١٤، برقم ٨٩٧."),
            ]),
            HisnChapter(id: "h-67", number: 67, titleEn: "Sighting the new moon", titleFr: "Voir le croissant", titleAr: "دُعَاءُ رُؤْيَةِ الْهِلَالِ", items: [
                Dhikr(id: "h-67-1", arabic: "«اللهُ أَكْبَرُ، اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، وَالتَّوْفِيقِ لِمَا تُحِبُّ رَبَّنَا وَتَرْضَى، رَبُّنَا وَرَبُّكَ اللهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٥/ ٥٠٤، برقم ٣٤٥١، والدارمي بلفظه، ١/ ٣٣٦، وانظر: صحيح الترمذي، ٣/ ١٥٧."),
            ]),
            HisnChapter(id: "h-110", number: 110, titleEn: "Rooster or donkey", titleFr: "Le coq ou l’âne", titleAr: "الدعاء عند سماع صياح الديك ونهيق الحمار", items: [
                Dhikr(id: "h-110-1", arabic: "«إِذَا سَمِعْتُمْ صِيَاحَ الدِّيَكَةِ؛ فَاسْأَلُوا اللهَ مِنْ فَضْلِهِ؛ فَإِنَّهَا رَأَتْ مَلَكًا، وَإِذَا سَمِعْتُمْ نَهِيقَ الْحِمَارِ؛ فَتَعَوَّذُوا بِاللهِ مِنَ الشَّيْطَانِ؛ فَإِنَّهُ رَأَى شَيْطَانًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٣٣٠٣، ومسلم، ٤/ ٢٠٩٢، برقم ٢٧٢٩."),
            ]),
            HisnChapter(id: "h-111", number: 111, titleEn: "Dogs barking at night", titleFr: "Les chiens la nuit", titleAr: "الدعاء عند سماع نباح الكلاب بالليل", items: [
                Dhikr(id: "h-111-1", arabic: "«إِذَا سَمِعْتُمْ نُبَاحَ الْكِلَابِ وَنَهِيقَ الْحَمِيرِ بِاللَّيْلِ فَتَعَوَّذُوا بِاللهِ مِنَ الشَّيْطَانِ؛ فَإِنَّهُنَّ يَرَيْنَ مَا لَا تَرَوْنَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٤/ ٣٢٧، برقم ٥١٠٥، وأحمد، ٣/ ٣٠٦، برقم ١٤٢٨٣، وصححه الألباني في صحيح أبي داود، ٣/ ٩٦١."),
            ]),
        ]),
    HisnSection(key: "food", icon: "fork.knife",
        titleEn: "Food & Drink", titleFr: "Nourriture et boisson", titleAr: "الطعام والشراب",
        subtitleEn: "At the table", subtitleFr: "À table", subtitleAr: "على المائدة",
        chapters: [
            HisnChapter(id: "h-68", number: 68, titleEn: "Breaking the fast", titleFr: "Rompre le jeûne", titleAr: "الدُّعَاءُ عِنْدَ إِفْطَارِ الصَّائِمِ", items: [
                Dhikr(id: "h-68-1", arabic: "«ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، ٢/ ٣٠٦، برقم ٢٣٥٩، وغيره. وانظر: صحيح الجامع، ٤/ ٢٠٩."),
                Dhikr(id: "h-68-2", arabic: "«اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ؛ أَنْ تَغْفِرَ لِي».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه ابن ماجه، ١٧٥٣ من دعاء عبد الله بن عمرو رضي الله عنهما، وحسنه الحافظ في تخريج الأذكار. انظر: شرح الأذكار، ٤/ ٣٤٢."),
            ]),
            HisnChapter(id: "h-69", number: 69, titleEn: "Before eating", titleFr: "Avant de manger", titleAr: "الدُّعَاءُ قَبْلَ الطَّعَامِ", items: [
                Dhikr(id: "h-69-1", arabic: "«إِذَا أَكَلَ أَحَدُكُمْ طَعَامًا فَلْيَقُلْ: بِسْمِ اللهِ، فَإِنْ نَسِيَ فِي أَوَّلِهِ فَلْيَقُلْ: بِسْمِ اللهِ فِي أَوَّلِهِ وَآخِرِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، ٣/ ٣٤٧، برقم ٣٧٦٧، والترمذي، ٤/ ٢٨٨، برقم ١٨٥٨، وانظر: صحيح الترمذي، ٢/ ١٦٧."),
                Dhikr(id: "h-69-2", arabic: "«مَنْ أَطْعَمَهُ اللهُ الطَّعَامَ، فَلْيَقُلْ: اللَّهُمَّ بَارِكْ لَنَا فِيهِ، وَأَطْعِمْنَا خَيْرًا مِنْهُ، وَمَنْ سَقَاهُ اللهُ لَبَنًا فَلْيَقُلْ: اللَّهُمَّ بَارِكْ لَنَا فِيهِ، وَزِدْنَا مِنْهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٤٥٥، وانظر: صحيح الترمذي، ٣/ ١٥٨."),
            ]),
            HisnChapter(id: "h-70", number: 70, titleEn: "After the meal", titleFr: "Après le repas", titleAr: "الدُّعَاءُ عِنْدَ الْفَرَاغِ مِنَ الطَّعَامِ", items: [
                Dhikr(id: "h-70-1", arabic: "«الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا،", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
            ]),
            HisnChapter(id: "h-71", number: 71, titleEn: "A guest for the host", titleFr: "L'invité pour son hôte", titleAr: "دعاء الضيف لصاحب الطعام", items: [
                Dhikr(id: "h-71-1", arabic: "«اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ، وَاغْفِرْ لَهُمْ، وَارْحَمْهُمْ»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٣/ ١٦١٥، برقم ٢٠٤٢."),
            ]),
            HisnChapter(id: "h-72", number: 72, titleEn: "Hinting for food or drink", titleFr: "Suggérer nourriture ou boisson", titleAr: "التعريض بالدعاء لطلب الطعام أو الشراب", items: [
                Dhikr(id: "h-72-1", arabic: "«اللَّهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِي، وَاسْقِ مَنْ سَقَانِي»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٣/ ١٦٢٦، برقم ٢٠٥٥."),
            ]),
            HisnChapter(id: "h-73", number: 73, titleEn: "Breaking fast at another's home", titleFr: "Rompre le jeûne chez autrui", titleAr: "الدعاء إذا أفطر عند أهل بيت", items: [
                Dhikr(id: "h-73-1", arabic: "«أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ، وَأَكَلَ طَعَامَكُمُ الْأَبْرَارُ، وَصَلَّتْ عَلَيْكُمُ الْمَلَائِكَةُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "سنن أبي داود، ٣/ ٣٦٧، برقم ٣٨٥٦، وابن ماجه، ١/ ٥٥٦، برقم ١٧٤٧، والنسائي في عمل اليوم والليلة، برقم ٢٩٦-٢٩٨، ونص على أنه ﷺ يقوله إذا أفطر عند أهل بيت. وصححه الألباني في صحيح أبي داود، ٢/ ٧٣٠."),
            ]),
            HisnChapter(id: "h-74", number: 74, titleEn: "A faster offered food", titleFr: "Un jeûneur invité à manger", titleAr: "دعاء الصائم إذا حضر الطعام ولم يفطر", items: [
                Dhikr(id: "h-74-1", arabic: "«إِذَا دُعِيَ أَحَدُكُمْ فَلْيُجِبْ، فَإِنْ كَانَ صَائِمًا فَلْيُصَلِّ، وَإِنْ كَانَ مُفْطِرًا فَلْيَطْعَمْ». وَمَعْنَى: «فَلْيُصَلِّ» أَيْ: فَلْيَدْعُ.", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ١٠٥٤، برقم ١١٥٠."),
            ]),
            HisnChapter(id: "h-75", number: 75, titleEn: "A faster who is insulted", titleFr: "Un jeûneur insulté", titleAr: "ما يقول الصائم إذا سابه أحد", items: [
                Dhikr(id: "h-75-1", arabic: "«إِنِّي صَائِمٌ، إِنِّي صَائِمٌ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ١٨٩٤، ومسلم، ٢/ ٨٠٦، برقم ١١٥١."),
            ]),
            HisnChapter(id: "h-76", number: 76, titleEn: "Seeing the first fruit", titleFr: "Voir les premiers fruits", titleAr: "الدعاء عند رؤية باكورة الثمر", items: [
                Dhikr(id: "h-76-1", arabic: "«اللَّهُمَّ بَارِكْ لَنَا فِي ثَمَرِنَا، وَبَارِكْ لَنَا فِي مَدِينَتِنَا، وَبَارِكْ لَنَا فِي صَاعِنَا، وَبَارِكْ لَنَا فِي مُدِّنَا»", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ١٠٠٠، برقم ١٣٧٣."),
            ]),
            HisnChapter(id: "h-127", number: 127, titleEn: "When slaughtering", titleFr: "L'immolation", titleAr: "ما يقول عند الذبح أو النحر", items: [
                Dhikr(id: "h-127-1", arabic: "«بِسْمِ اللهِ، وَاللهُ أَكْبَرُ، [اللَّهُمَّ مِنْكَ وَلَكَ]، اللَّهُمَّ تَقَبَّلْ مِنِّي».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، برقم ١٩٦٧، والبيهقي، ٩/ ٢٨٧، وما بين المعقوفين للبيهقي، ٩/ ٢٨٧ وغيره، والجملة الأخيرة سقتها بالمعنى من رواية مسلم."),
            ]),
        ]),
    HisnSection(key: "travel", icon: "airplane",
        titleEn: "Travel & Riding", titleFr: "Voyage et monture", titleAr: "السفر والركوب",
        subtitleEn: "On the journey", subtitleFr: "En chemin", subtitleAr: "في الطريق",
        chapters: [
            HisnChapter(id: "h-95", number: 95, titleEn: "Riding a mount", titleFr: "Monter une monture", titleAr: "دعاء الركوب", items: [
                Dhikr(id: "h-95-1", arabic: "«بِسْمِ اللَّهِ، وَالْحَمْدُ لِلَّهِ، ﴿سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ ۝ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ ۝﴾، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَكَ اللَّهُمَّ، إِنِّي ظَلَمْتُ نَفْسِي، فَاغْفِرْ لِي؛ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٢٦٠٢، والترمذي، برقم ٣٤٤٦، وانظر: صحيح الترمذي، ٣/ ١٥٦، الآيتان من سورة الزخرف: ١٣ - ١٤."),
            ]),
            HisnChapter(id: "h-96", number: 96, titleEn: "Travel", titleFr: "Le voyage", titleAr: "دعاء السفر", items: [
                Dhikr(id: "h-96-1", arabic: "اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، ﴿سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ ۝ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ ۝﴾، «اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا، وَاطْوِ عَنَّا بُعْدَهُ، اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ، وَالْخَلِيفَةُ فِي الْأَهْلِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ، وَكَآبَةِ الْمَنْظَرِ، وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ»", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
                Dhikr(id: "h-96-2", arabic: "وَإِذَا رَجَعَ قَالَهُنَّ، وَزَادَ فِيهِنَّ: «آيِبُونَ، تَائِبُونَ، عَابِدُونَ، لِرَبِّنَا حَامِدُونَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٩٧٨، برقم ١٣٤٢."),
            ]),
            HisnChapter(id: "h-97", number: 97, titleEn: "Entering a town", titleFr: "Entrer dans une cité", titleAr: "دعاء دخول القرية أو البلدة", items: [
                Dhikr(id: "h-97-1", arabic: "«اللَّهُمَّ رَبَّ السَّمَوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ، وَرَبَّ الْأَرَضِينَ السَّبْعِ وَمَا أَقْلَلْنَ، وَرَبَّ الشَّيَاطِينِ وَمَا أَضْلَلْنَ، وَرَبَّ الرِّيَاحِ وَمَا ذَرَيْنَ، أَسْأَلُكَ خَيْرَ هَذِهِ الْقَرْيَةِ، وَخَيْرَ أَهْلِهَا، وَخَيْرَ مَا فِيهَا، وَأَعُوذُ بِكَ مِنْ شَرِّهَا، وَشَرِّ أَهْلِهَا، وَشَرِّ مَا فِيهَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "الحاكم وصححه، ووافقه الذهبي، ٢/ ١٠٠. وابن السني، برقم ٥٢٤، وحسنه الحافظ في تخريج الأذكار، ٥/ ١٥٤، قال العلامة ابن باز رحمه الله: «ورواه النسائي بإسناد حسن». انظر: تحفة الأخيار، ص٣٧."),
            ]),
            HisnChapter(id: "h-98", number: 98, titleEn: "Entering the market", titleFr: "Entrer au marché", titleAr: "دعاء دخول السوق", items: [
                Dhikr(id: "h-98-1", arabic: "«لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ حَيٌّ لَا يَمُوتُ، بِيَدِهِ الْخَيْرُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٤٢٨، وابن ماجه، ٥/ ٢٩١، برقم ٣٨٦٠، والحاكم، ١/ ٥٣٨، وحسنه الألباني في صحيح ابن ماجه، ٢/ ٢١، وفي صحيح الترمذي، ٣/ ١٥٢."),
            ]),
            HisnChapter(id: "h-99", number: 99, titleEn: "When the mount stumbles", titleFr: "Quand la monture trébuche", titleAr: "الدعاء إذا تعس المركوب", items: [
                Dhikr(id: "h-99-1", arabic: "«بِسْمِ اللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٤٩٨٢، وصححه الألباني في صحيح أبي داود، ٣/ ٩٤١."),
            ]),
            HisnChapter(id: "h-100", number: 100, titleEn: "A traveler bidding farewell", titleFr: "Le voyageur fait ses adieux", titleAr: "دعاء المسافر للمقيم", items: [
                Dhikr(id: "h-100-1", arabic: "«أَسْتَوْدِعُكُمُ اللهَ الَّذِي لَا تَضِيعُ وَدَائِعُهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٢/ ٤٠٣، برقم ٩٢٣٠، وابن ماجه، ٢/ ٩٤٣، برقم ٢٨٢٥، وانظر: صحيح ابن ماجه، ٢/ ١٣٣."),
            ]),
            HisnChapter(id: "h-101", number: 101, titleEn: "Bidding a traveler farewell", titleFr: "Faire ses adieux au voyageur", titleAr: "دعاء المقيم للمسافر", items: [
                Dhikr(id: "h-101-1", arabic: "أَسْتَوْدِعُ اللَّهَ دِينَكَ، وَأَمَانَتَكَ، وَخَوَاتِيمَ عَمَلِكَ.", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٢/ ٧، برقم ٤٥٢٤، والترمذي، ٥/ ٤٩٩، برقم ٣٤٤٣، وصححه الألباني في صحيح سنن الترمذي، ٣/ ٤١٩."),
                Dhikr(id: "h-101-2", arabic: "«زَوَّدَكَ اللَّهُ التَّقْوَى، وَغَفَرَ ذَنْبَكَ، وَيَسَّرَ لَكَ الْخَيْرَ حَيْثُ مَا كُنْتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٤٤٤، وانظر: صحيح الترمذي، ٣/ ١٥٥."),
            ]),
            HisnChapter(id: "h-102", number: 102, titleEn: "Takbīr & tasbīḥ travelling", titleFr: "Takbīr et tasbīḥ en voyage", titleAr: "التكبير والتسبيح في سير السفر", items: [
                Dhikr(id: "h-102-1", arabic: "قَالَ جَابِرٌ رضي الله عنه: «كُنَّا إِذَا صَعِدْنَا كَبَّرْنَا، وَإِذَا نَزَلْنَا سَبَّحْنَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٦/ ١٣٥، برقم ٢٩٩٣."),
            ]),
            HisnChapter(id: "h-103", number: 103, titleEn: "The traveler at dawn", titleFr: "Le voyageur à l’aube", titleAr: "دعاء المسافر إذا أسحر", items: [
                Dhikr(id: "h-103-1", arabic: "«سَمِعَ سَامِعٌ بِحَمْدِ اللهِ، وَحُسْنِ بَلَائِهِ عَلَيْنَا، رَبَّنَا صَاحِبْنَا، وَأَفْضِلْ عَلَيْنَا، عَائِذًا بِاللهِ مِنَ النَّارِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/ ٢٠٨٦، برقم ٢٧١٨، ومعنى: سَمِعَ سَامِعٌ أَي: شهد شاهد على حمدنا لله تعالى على نعمه، وحسن بلائه. ومعنى سَمَعَ سامعٌ: بلغ سامع قولي هذا لغيره، وقال مثله على التنبيه على الذكر في السحر والدعاء. شرح النووي على صحيح مسلم، ١٧/ ٣٩."),
            ]),
            HisnChapter(id: "h-104", number: 104, titleEn: "Stopping at a place", titleFr: "S'arrêter en un lieu", titleAr: "الدعاء إذا نزل منزلا في سفر أو غيره", items: [
                Dhikr(id: "h-104-1", arabic: "«أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/ ٢٠٨٠، برقم ٢٧٠٩."),
            ]),
            HisnChapter(id: "h-105", number: 105, titleEn: "Returning from travel", titleFr: "Le retour de voyage", titleAr: "ذكر الرجوع من السفر", items: [
                Dhikr(id: "h-105-1", arabic: "«يُكَبِّرُ عَلَى كُلِّ شَرَفٍ ثَلَاثَ تَكْبِيرَاتٍ، ثُمَّ يَقُولُ: لَا إِلَهَ إِلَّا اللهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، آيِبُونَ، تَائِبُونَ، عَابِدُونَ، لِرَبِّنَا حَامِدُونَ، صَدَقَ اللهُ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "كان النبي ﷺ يقوله إذا قَفَلَ من غزو أو حجٍّ. البخاري، ٧/ ١٦٣، برقم ١٧٩٧، ومسلم، ٢/ ٩٨٠، برقم ١٣٤٤."),
            ]),
        ]),
    HisnSection(key: "hajj", icon: "signpost.right.fill",
        titleEn: "Hajj & ʿUmrah", titleFr: "Hajj et ʿUmrah", titleAr: "الحج والعمرة",
        subtitleEn: "The sacred rites", subtitleFr: "Les rites sacrés", subtitleAr: "المناسك",
        chapters: [
            HisnChapter(id: "h-115", number: 115, titleEn: "The talbiyah", titleFr: "La talbiyah", titleAr: "كيف يلبي المحرم في الحج أو العمرة", items: [
                Dhikr(id: "h-115-1", arabic: "«لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٣/ ٤٠٨، برقم ١٥٤٩، ومسلم، برقم ١١٨٤."),
            ]),
            HisnChapter(id: "h-116", number: 116, titleEn: "Takbīr at the Black Stone", titleFr: "Takbīr à la Pierre noire", titleAr: "التكبير إذا أتى الحجر الأسود", items: [
                Dhikr(id: "h-116-1", arabic: "«طَافَ النَّبِيُّ ﷺ بِالْبَيْتِ عَلَى بَعِيرٍ، كُلَّمَا أَتَى الرُّكْنَ؛ أَشَارَ إِلَيْهِ بِشَيْءٍ عِنْدَهُ، وَكَبَّرَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٣/ ٤٧٦، برقم ١٦١٣، والمراد بالشيء: المحجن. انظر: البخاري مع الفتح، ٣/ ٤٧٢."),
            ]),
            HisnChapter(id: "h-117", number: 117, titleEn: "Between the two corners", titleFr: "Entre les deux coins", titleAr: "الدعاء بين الركن اليماني والحجر الأسود", items: [
                Dhikr(id: "h-117-1", arabic: "﴿رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ ۝﴾.", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ١٧٩، برقم ١٨٩٢، وأحمد، ٣/ ٤١١، برقم ١٥٣٩٨، والبغوي في شرح السنة، ٧/ ١٢٨، وحسنه الألباني في صحيح أبي داود، ١/ ٣٥٤، والآية من سورة البقرة: ٢٠١."),
            ]),
            HisnChapter(id: "h-118", number: 118, titleEn: "At Ṣafā & Marwah", titleFr: "À Ṣafā et Marwah", titleAr: "دعاء الوقوف على الصفا والمروة", items: [
                Dhikr(id: "h-118-1", arabic: "«لَمَّا دَنَا النَّبِيُّ ﷺ مِنَ الصَّفَا؛ قَرَأَ: ﴿إِنَّ ٱلصَّفَا وَٱلْمَرْوَةَ مِن شَعَائِرِ ٱللهِ﴾، أَبْدَأُ بِمَا بَدَأَ اللهُ بِهِ». فَبَدَأَ بِالصَّفَا، فَرَقِيَ عَلَيْهِ حَتَّى رَأَى الْبَيْتَ، فَاسْتَقْبَلَ الْقِبْلَةَ، فَوَحَّدَ اللهَ، وَكَبَّرَهُ، وَقَالَ: «لَا إِلَهَ إِلَّا اللهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ، أَنْجَزَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ. ثُمَّ دَعَا بَيْنَ ذَلِكَ. قَالَ مِثْلَ هَذَا ثَلَاثَ مَرَّاتٍ» الْحَدِيثَ. وَفِيهِ: «فَفَعَلَ عَلَى الْمَرْوَةِ كَمَا فَعَلَ عَلَى الصَّفَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٨٨٨، برقم ١٢١٨، والآية من سورة البقرة، رقم ١٥٨."),
            ]),
            HisnChapter(id: "h-119", number: 119, titleEn: "The Day of ʿArafah", titleFr: "Le jour de ʿArafah", titleAr: "الدعاء يوم عرفة", items: [
                Dhikr(id: "h-119-1", arabic: "قَالَ النَّبِيُّ ﷺ: «خَيْرُ الدُّعَاءِ دُعَاءُ يَوْمِ عَرَفَة، وَخَيْرُ مَا قُلْتُ أَنَا وَالنَّبِيُّونَ مِنْ قَبْلِي: لَا إِلَهَ إِلَّا اللهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٥٨٥، وحسنه الألباني في صحيح الترمذي، ٣/ ١٨٤، وفي سلسلة الأحاديث الصحيحة، ٤/ ٦."),
            ]),
            HisnChapter(id: "h-120", number: 120, titleEn: "At al-Mashʿar al-Ḥarām", titleFr: "À al-Mashʿar al-Ḥarām", titleAr: "الذكر عند المشعر الحرام", items: [
                Dhikr(id: "h-120-1", arabic: "«رَكِبَ النَّبِيُّ ﷺ الْقَصْوَاءَ، حَتَّى أَتَى الْمَشْعَرَ الْحَرَامَ، فَاسْتَقْبَلَ الْقِبْلَةَ، (فَدَعَاهُ، وَكَبَّرَهُ، وَهَلَّلَهُ، وَوَحَّدَهُ)، فَلَمْ يَزَلْ وَاقِفًا حَتَّى أَسْفَرَ جِدًّا، فَدَفَعَ قَبْلَ أَنْ تَطْلُعَ الشَّمْسُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٢/ ٨٩١، برقم ١٢١٨."),
            ]),
            HisnChapter(id: "h-121", number: 121, titleEn: "Stoning the Jamarāt", titleFr: "Lapider les stèles", titleAr: "التكبير عند رمي الجمار مع كل حصاة", items: [
                Dhikr(id: "h-121-1", arabic: "«يُكَبِّرُ كُلَّمَا رَمَى بِحَصَاةٍ عِنْدَ الْجِمَارِ الثَّلَاثِ، ثُمَّ يَتَقَدَّمُ، وَيَقِفُ يَدْعُو مُسْتَقْبِلَ الْقِبْلَةِ، رَافِعًا يَدَيْهِ بَعْدَ الْجَمْرَةِ الْأُولَى وَالثَّانِيَةِ. أَمَّا جَمْرَةُ الْعَقَبَةِ؛ فَيَرْمِيهَا، وَيُكَبِّرُ عِنْدَ كُلِّ حَصَاةٍ، وَيَنْصَرِفُ، وَلَا يَقِفُ عِنْدَهَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٣/ ٥٨٣، برقم ١٧٥١، وانظر لفظه هناك. والبخاري مع الفتح، ٣/ ٥٨٣، و٣/ ٥٨٤، و٣/ ٥٨١، برقم ١٧٥٣، ورواه مسلم أيضًا، برقم ١٢١٨."),
            ]),
        ]),
    HisnSection(key: "family", icon: "person.2.fill",
        titleEn: "Family & Occasions", titleFr: "Famille et occasions", titleAr: "الأسرة والمناسبات",
        subtitleEn: "Home & milestones", subtitleFr: "Foyer et étapes", subtitleAr: "البيت والمناسبات",
        chapters: [
            HisnChapter(id: "h-47", number: 47, titleEn: "Congratulating a newborn", titleFr: "Féliciter un nouveau-né", titleAr: "تهنئة المولود له، وجوابه", items: [
                Dhikr(id: "h-47-1", arabic: "«بَارَكَ اللَّهُ لَكَ فِي الْمَوْهُوبِ لَكَ، وَشَكَرْتَ الْوَاهِبَ، وَبَلَغَ أَشُدَّهُ، وَرُزِقْتَ بِرَّهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "ذُكِرَ من كلام الحسن البصري. انظر: تحفة المودود لابن القيم، ص ٢٠، وعزاه لابن المنذر في الأوسط."),
                Dhikr(id: "h-47-2", arabic: "وَيَرُدُّ عَلَيْهِ الْمُهَنَّأُ، فَيَقُولُ: «بَارَكَ اللهُ لَكَ، وَبَارَكَ عَلَيْكَ، وَجَزَاكَ اللهُ خَيْرًا، وَرَزَقَكَ اللهُ مِثْلَهُ، وَأَجْزَلَ ثَوَابَكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "قاله النووي في الأذكار، ص٣٤٩، وانظر: صحيح الأذكار للنووي، لسليم الهلالي، ٧١٣/٢، وتمام التخريج في: الذكر والدعاء والعلاج بالرقى، للمؤلف، ٤١٦/١."),
            ]),
            HisnChapter(id: "h-48", number: 48, titleEn: "Protecting children", titleFr: "Protéger les enfants", titleAr: "ما يعوذ به الأولاد", items: [
                Dhikr(id: "h-48-1", arabic: "كَانَ رَسُولُ اللهِ ﷺ يُعَوِّذُ الْحَسَنَ وَالْحُسَيْنَ رَضِيَ اللهُ عَنْهُمَا: «أُعِيذُكُمَا بِكَلِمَاتِ اللهِ التَّامَّةِ، مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٤/ ١١٩، برقم ٣٣٧١، من حديث ابن عباس رضي الله عنهما."),
            ]),
            HisnChapter(id: "h-79", number: 79, titleEn: "For the newly married", titleFr: "Pour les nouveaux mariés", titleAr: "الدعاء للمتزوج", items: [
                Dhikr(id: "h-79-1", arabic: "«بَارَكَ اللَّهُ لَكَ، وَبَارَكَ عَلَيْكَ، وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أصحاب السنن إلا النسائي: أبو داود، برقم ٢١٣٠، والترمذي، برقم ١٠٩١، وابن ماجه، برقم ١٩٠٥، والنسائي في عمل اليوم والليلة، برقم ٢٥٩، وانظر: صحيح الترمذي، ١/ ٣١٦."),
            ]),
            HisnChapter(id: "h-80", number: 80, titleEn: "The groom & a new mount", titleFr: "Le marié et une monture", titleAr: "دعاء المتزوج، وشراء الدابة", items: [
                Dhikr(id: "h-80-1", arabic: "إِذَا تَزَوَّجَ أَحَدُكُمُ امْرَأَةً، أَوْ إِذَا اشْتَرَى خَادِمًا فَلْيَقُلْ: «اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَخَيْرَ مَا جَبَلْتَهَا عَلَيْهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا، وَشَرِّ مَا جَبَلْتَهَا عَلَيْهِ، وَإِذَا اشْتَرَى بَعِيرًا فَلْيَأْخُذْ بِذِرْوَةِ سَنَامِهِ، وَلْيَقُلْ مِثْلَ ذَلِكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ٢٤٨، برقم ٢١٦٠، وابن ماجه، ١/ ٦١٧، برقم ١٩١٨، وانظر: صحيح ابن ماجه، ١/ ٣٢٤."),
            ]),
            HisnChapter(id: "h-81", number: 81, titleEn: "Before intimacy", titleFr: "Avant les rapports", titleAr: "الدعاء قبل إتيان الزوجة", items: [
                Dhikr(id: "h-81-1", arabic: "«بِسْمِ اللَّهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٦/ ١٤١، برقم ١٤١، ومسلم، ٢/ ١٠٢٨، برقم ١٤٣٤."),
            ]),
        ]),
    HisnSection(key: "social", icon: "bubble.left.and.bubble.right.fill",
        titleEn: "Manners & Company", titleFr: "Convenances et compagnie", titleAr: "الآداب والمجالس",
        subtitleEn: "Among people", subtitleFr: "Parmi les gens", subtitleAr: "بين الناس",
        chapters: [
            HisnChapter(id: "h-77", number: 77, titleEn: "Sneezing", titleFr: "L’éternuement", titleAr: "دعاء العطاس", items: [
                Dhikr(id: "h-77-1", arabic: "«إِذَا عَطَسَ أَحَدُكُمْ، فَلْيَقُلْ: الْحَمْدُ لِلَّهِ، وَلْيَقُلْ لَهُ أَخُوهُ أَوْ صَاحِبُهُ: يَرْحَمُكَ اللَّهُ، فَإِذَا قَالَ لَهُ: يَرْحَمُكَ اللَّهُ، فَلْيَقُلْ: يَهْدِيكُمُ اللَّهُ، وَيُصْلِحُ بَالَكُمْ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٧/ ١٢٥، برقم ٥٨٧٠."),
            ]),
            HisnChapter(id: "h-78", number: 78, titleEn: "A disbeliever who praises Allah", titleFr: "Un mécréant qui loue Allah", titleAr: "ما يقال للكافر إذا عطس فحمد الله", items: [
                Dhikr(id: "h-78-1", arabic: "«يَهْدِيكُمُ اللَّهُ، وَيُصْلِحُ بَالَكُمْ»", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٥/ ٨٢، برقم ٢٧٤١، وأحمد، ٤/ ٤٠٠، برقم ١٩٥٨٦، وأبو داود، ٤/ ٣٠٨، برقم ٥٠٤٠، وانظر: صحيح الترمذي، ٢/ ٣٥٤."),
            ]),
            HisnChapter(id: "h-83", number: 83, titleEn: "Seeing someone afflicted", titleFr: "Voir une personne éprouvée", titleAr: "دعاء من رأى مبتلى", items: [
                Dhikr(id: "h-83-1", arabic: "«الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ، وَفَضَّلَنِي عَلَى كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا»", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٤٣٢، وانظر: صحيح الترمذي، ٣/ ١٥٣."),
            ]),
            HisnChapter(id: "h-84", number: 84, titleEn: "In a gathering", titleFr: "Dans une assemblée", titleAr: "ما يقال في المجلس", items: [
                Dhikr(id: "h-84-1", arabic: "عَنِ ابْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: كَانَ يُعَدُّ لِرَسُولِ اللَّهِ ﷺ فِي الْمَجْلِسِ الْوَاحِدِ مِائَةَ مَرَّةٍ مِنْ قَبْلِ أَنْ يَقُومَ: «رَبِّ اغْفِرْ لِي، وَتُبْ عَلَيَّ، إِنَّكَ أَنْتَ التَّوَّابُ الْغَفُورُ»", translit: "", translation: "", translationFr: "", count: 100, reference: "الترمذي، برقم ٣٤٣٤، وابن ماجه، برقم ٣٨١٤، وانظر: صحيح الترمذي، ٣/ ١٥٣، وصحيح ابن ماجه، ٢/ ٣٢١، ولفظه للترمذي."),
            ]),
            HisnChapter(id: "h-85", number: 85, titleEn: "Expiation of a gathering", titleFr: "Expiation de l'assemblée", titleAr: "كفارة المجلس", items: [
                Dhikr(id: "h-85-1", arabic: "«سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ، وَأَتُوبُ إِلَيْكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أصحاب السنن: أبو داود، برقم ٤٨٥٨، والترمذي، برقم ٣٤٣٣، والنسائي، برقم ١٣٤٤، وانظر صحيح الترمذي، ٣/ ١٥٣، وقد ثبت أن عائشة رضي الله عنها قالت: «ما جلس رسول الله ﷺ مجلسًا، ولا تلا قرآنًا، ولا صلّى صلاةً؛ إلا ختم ذلك بكلمات...» الحديث، أخرجه النسائي في عمل اليوم والليلة، برقم ٣٠٨، وأحمد، ٦/ ٧٧، برقم ٢٤٤٨٦، وصححه الدكتور فاروق حمادة في تحقيقه لعمل اليوم والليلة للنسائي، ص٢٧٣."),
            ]),
            HisnChapter(id: "h-86", number: 86, titleEn: "For one who forgives you", titleFr: "Pour qui te pardonne", titleAr: "الدعاء لمن قال: (غفر الله لك)", items: [
                Dhikr(id: "h-86-1", arabic: "«وَلَكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٥/ ٨٢، برقم ٢٠٧٧٨، والنسائي في عمل اليوم والليلة، ص٢١٨، برقم ٤٢١، تحقيق: الدكتور فاروق حمادة."),
            ]),
            HisnChapter(id: "h-87", number: 87, titleEn: "For one who does you good", titleFr: "Pour qui te fait du bien", titleAr: "الدعاء لمن صنع إليك معروفا", items: [
                Dhikr(id: "h-87-1", arabic: "«جَزَاكَ اللَّهُ خَيْرًا»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه الترمذي، برقم ٢٠٣٥، وانظر: صحيح الجامع، ٦٢٤٤ وصحيح الترمذي، ٢/ ٢٠٠."),
            ]),
            HisnChapter(id: "h-89", number: 89, titleEn: "For one who loves you for Allah", titleFr: "Pour qui t'aime en Allah", titleAr: "الدعاء لمن قال: (إني أحبك في الله)", items: [
                Dhikr(id: "h-89-1", arabic: "«أَحَبَّكَ الَّذِي أَحْبَبْتَنِي لَهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود، ٤/ ٣٣٣، برقم ٥١٢٥، وحسّنه الألباني في صحيح سنن أبي داود، ٣/ ٩٦٥."),
            ]),
            HisnChapter(id: "h-90", number: 90, titleEn: "For one who offers you wealth", titleFr: "Pour qui t’offre ses biens", titleAr: "الدعاء لمن عرض عليك ماله", items: [
                Dhikr(id: "h-90-1", arabic: "«بَارَكَ اللَّهُ لَكَ فِي أَهْلِكَ وَمَالِكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ٤/ ٢٨٨، برقم ٢٠٤٩."),
            ]),
            HisnChapter(id: "h-91", number: 91, titleEn: "For a lender at repayment", titleFr: "Pour un prêteur remboursé", titleAr: "الدعاء لمن أقرض؛ عند القضاء", items: [
                Dhikr(id: "h-91-1", arabic: "«بَارَكَ اللَّهُ لَكَ فِي أَهْلِكَ وَمَالِكَ، إِنَّمَا جَزَاءُ السَّلَفِ: الْحَمْدُ وَالْأَدَاءُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه النسائي في عمل اليوم والليلة، ص٣٠٠، وابن ماجه، ٢/ ٨٠٩، برقم ٢٤٢٤، وانظر: صحيح ابن ماجه، ٢/ ٥٥."),
            ]),
            HisnChapter(id: "h-93", number: 93, titleEn: "For one who blesses you", titleFr: "Pour qui te bénit", titleAr: "الدعاء لمن قال: (بارك الله فيك)", items: [
                Dhikr(id: "h-93-1", arabic: "«وَفِيكَ بَارَكَ اللَّهُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه ابن السني، ص١٣٨، برقم ٢٧٨، وانظر: الوابل الصيب لابن القيم، ص٣٠٤، تحقيق بشير محمد عيون."),
            ]),
            HisnChapter(id: "h-106", number: 106, titleEn: "Pleasing or displeasing news", titleFr: "Nouvelle agréable ou non", titleAr: "ما يقول من أتاه أمر يسره أو يكرهه", items: [
                Dhikr(id: "h-106-1", arabic: "كَانَ النَّبِيُّ ﷺ إِذَا أَتَاهُ الْأَمْرُ يَسُرُّهُ قَالَ: «الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ». وَإِذَا أَتَاهُ الْأَمْرُ يَكْرَهُهُ قَالَ: «الْحَمْدُ لِلَّهِ عَلَى كُلِّ حَالٍ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه ابن السني في عمل اليوم والليلة، برقم ٣٧٧، والحاكم وصححه، ١/ ٤٩٩، وصححه الألباني في صحيح الجامع، ٤/ ٢٠١."),
            ]),
            HisnChapter(id: "h-108", number: 108, titleEn: "Spreading the salām", titleFr: "Répandre le salām", titleAr: "إفشاء السلام", items: [
                Dhikr(id: "h-108-1", arabic: "قَالَ رَسُولُ اللَّهِ ﷺ: «لَا تَدْخُلُوا الْجَنَّةَ حَتَّى تُؤْمِنُوا، وَلَا تُؤْمِنُوا حَتَّى تَحَابُّوا، أَوَلَا أَدُلُّكُمْ عَلَى شَيْءٍ إِذَا فَعَلْتُمُوهُ تَحَابَبْتُمْ؛ أَفْشُوا السَّلَامَ بَيْنَكُمْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٧٤، برقم ٥٤، وأحمد، واللفظ له، ولفظ مسلم: «لا تدخلون...»."),
                Dhikr(id: "h-108-2", arabic: "«ثَلَاثٌ مَنْ جَمَعَهُنَّ فَقَدْ جَمَعَ الْإِيمَانَ: الْإِنْصَافُ مِنْ نَفْسِكَ، وَبَذْلُ السَّلَامِ لِلْعَالَمِ، وَالْإِنْفَاقُ مِنَ الْإِقْتَارِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١/ ٨٢، برقم ٢٨، عن عمار ﷺ موقوفا معلقا."),
                Dhikr(id: "h-108-3", arabic: "وَعَنْ عَبْدِ اللهِ بْنِ عُمَرَ رضي الله عنهما: أَنَّ رَجُلًا سَأَلَ النَّبِيَّ ﷺ: أَيُّ الْإِسْلَامِ خَيْرٌ؟ قَالَ: «تُطْعِمُ الطَّعَامَ، وَتَقْرَأُ السَّلَامَ عَلَى مَنْ عَرَفْتَ وَمَنْ لَمْ تَعْرِفْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١/ ٥٥، برقم ١٢، ومسلم، ١/ ٦٥، برقم ٣٩."),
            ]),
            HisnChapter(id: "h-109", number: 109, titleEn: "A disbeliever's greeting", titleFr: "Répondre à un mécréant", titleAr: "كيف يرد السلام على الكافر إذا سلم", items: [
                Dhikr(id: "h-109-1", arabic: "«إِذَا سَلَّمَ عَلَيْكُمْ أَهْلُ الْكِتَابِ فَقُولُوا: وَعَلَيْكُمْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٦٢٥٨، ومسلم، ٤/ ١٧٠٥، برقم ٢١٦٣."),
            ]),
            HisnChapter(id: "h-112", number: 112, titleEn: "One you wrongly insulted", titleFr: "Qui tu as injustement insulté", titleAr: "الدعاء لمن سبته", items: [
                Dhikr(id: "h-112-1", arabic: "قَالَ النَّبِيُّ ﷺ: «اللَّهُمَّ فَأَيُّمَا مُؤْمِنٍ سَبَبْتُهُ، فَاجْعَلْ ذَلِكَ لَهُ قُرْبَةً إِلَيْكَ يَوْمَ الْقِيَامَةِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٦٣٦١، ومسلم، ٢٦٠٦، ولفظه: «فاجعلها له زكاةً ورحمةً»."),
            ]),
            HisnChapter(id: "h-113", number: 113, titleEn: "When a Muslim is praised", titleFr: "Quand un musulman est loué", titleAr: "ما يقول المسلم إذا مدح المسلم", items: [
                Dhikr(id: "h-113-1", arabic: "قَالَ النَّبِيُّ ﷺ: «إِذَا كَانَ أَحَدُكُمْ مَادِحًا صَاحِبَهُ لَا مَحَالَةَ، فَلْيَقُلْ: أَحْسِبُ فُلَانًا، وَاللهُ حَسِيبُهُ، وَلَا أُزَكِّي عَلَى اللهِ أَحَدًا، أَحْسِبُهُ – إِنْ كَانَ يَعْلَمُ ذَاكَ – كَذَا وَكَذَا».", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه مسلم، ٤/ ٢٢٩٦، برقم ٣٠٠٠."),
            ]),
            HisnChapter(id: "h-114", number: 114, titleEn: "When one is praised", titleFr: "Quand on est loué", titleAr: "ما يقول المسلم إذا زكي", items: [
                Dhikr(id: "h-114-1", arabic: "«اللَّهُمَّ لَا تُؤَاخِذْنِي بِمَا يَقُولُونَ، وَاغْفِرْ لِي مَا لَا يَعْلَمُونَ، [وَاجْعَلْنِي خَيْرًا مِمَّا يَظُنُّونَ]».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري في الأدب المفرد، ٧٦١، وصحح إسناده الألباني في صحيح الأدب المفرد، برقم ٥٨٥، وما بين المعقوفين زيادة للبيهقي في شعب الإيمان، ٤/ ٢٢٨ من طريق آخر."),
            ]),
            HisnChapter(id: "h-122", number: 122, titleEn: "Wonder & delight", titleFr: "Émerveillement et joie", titleAr: "دعاء التعجب والأمر السار", items: [
                Dhikr(id: "h-122-1", arabic: "«سُبْحَانَ اللهِ!».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١/ ٢١٠، و٣٩٠، و٤١٤، برقم ١١٥، ورقم ٣٥٩٩، ورقم ٦٢١٨، ومسلم، ٤/ ١٨٥٧، برقم ١٦٧٤."),
                Dhikr(id: "h-122-2", arabic: "«اللهُ أَكْبَرُ!».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري برقم ٤٧٤١، وبرقم ٣٠٦٢، والترمذي، برقم ٢١٨٠، والنسائي في الكبرى، برقم ١١١٨٥، وانظر: صحيح الترمذي، ٢/ ١٠٣، و٢/ ٢٣٥، ومسند أحمد، ٥/ ٢١٨، برقم ٢١٩٠٠."),
            ]),
            HisnChapter(id: "h-123", number: 123, titleEn: "Pleasing news", titleFr: "Une nouvelle réjouissante", titleAr: "ما يفعل من أتاه أمر يسره", items: [
                Dhikr(id: "h-123-1", arabic: "«كَانَ النَّبِيُّ ﷺ إِذَا أَتَاهُ أَمْرٌ يَسُرُّهُ أَوْ يُسَرُّ بِهِ؛ خَرَّ سَاجِدًا، شُكْرًا لِلَّهِ تَبَارَكَ وَتَعَالَى».", translit: "", translation: "", translationFr: "", count: 1, reference: "رواه أهل السنن إلا النسائي: أبو داود، برقم ٢٧٧٤، والترمذي، برقم ١٥٧٨، وابن ماجه، برقم ١٣٩٤. انظر صحيح ابن ماجه، ١/ ٢٣٣، وإرواء الغليل، ٢/ ٢٢٦."),
            ]),
        ]),
    HisnSection(key: "protection", icon: "shield.lefthalf.filled",
        titleEn: "Faith & Protection", titleFr: "Foi et protection", titleAr: "الإيمان والحماية",
        subtitleEn: "Refuge & safety", subtitleFr: "Refuge et sûreté", subtitleAr: "الحماية والعوذ",
        chapters: [
            HisnChapter(id: "h-88", number: 88, titleEn: "Protection from the Dajjāl", titleFr: "Protection du Dajjāl", titleAr: "ما يعصم الله به من الدجال", items: [
                Dhikr(id: "h-88-1", arabic: "«مَنْ حَفِظَ عَشْرَ آيَاتٍ مِنْ أَوَّلِ سُورَةِ الْكَهْفِ؛ عُصِمَ مِنَ الدَّجَّالِ». وَالِاسْتِعَاذَةُ بِاللَّهِ مِنْ فِتْنَتِهِ عَقِبَ التَّشَهُّدِ الْأَخِيرِ مِنْ كُلِّ صَلَاةٍ.", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٥٥٥، برقم ٨٠٩، وفي رواية: من آخر الكهف، ١/ ٥٥٦، برقم ٨٠٩. انظر: حديث رقم ٥٥، وحديث ٥٦، ص ٣١ من هذا الكتاب."),
            ]),
            HisnChapter(id: "h-92", number: 92, titleEn: "Fear of shirk", titleFr: "La crainte du shirk", titleAr: "دعاء الخوف من الشرك", items: [
                Dhikr(id: "h-92-1", arabic: "«اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أُشْرِكَ بِكَ وَأَنَا أَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٤/ ٤٠٣، برقم ١٩٦٠٦، والأدب المفرد للبخاري، برقم ٧١٦، وانظر: صحيح الجامع، ٣/ ٢٣٣، وصحيح الترغيب والترهيب للألباني، ١/ ١٩."),
            ]),
            HisnChapter(id: "h-94", number: 94, titleEn: "Dispelling bad omens", titleFr: "Écarter le mauvais présage", titleAr: "دعاء كراهية الطيرة", items: [
                Dhikr(id: "h-94-1", arabic: "«اللَّهُمَّ لَا طَيْرَ إِلَّا طَيْرُكَ، وَلَا خَيْرَ إِلَّا خَيْرُكَ، وَلَا إِلَهَ غَيْرُكَ»", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٢/ ٢٢٠، برقم ٧٠٤٥، وابن السني، برقم ٢٩٢، وصححه الألباني في سلسلة الأحاديث الصحيحة، ٣/ ٥٤، برقم ١٠٦٥."),
            ]),
            HisnChapter(id: "h-125", number: 125, titleEn: "Fear of the evil eye", titleFr: "Crainte du mauvais œil", titleAr: "دعاء من خشي أن يصيب شيئا بعينه", items: [
                Dhikr(id: "h-125-1", arabic: "«إِذَا رَأَى أَحَدُكُمْ مِنْ أَخِيهِ، أَوْ مِنْ نَفْسِهِ، أَوْ مِنْ مَالِهِ مَا يُعْجِبُهُ؛ [فَلْيَدْعُ لَهُ بِالْبَرَكَةِ]، فَإِنَّ الْعَيْنَ حَقٌّ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسند أحمد، ٤/ ٤٤٧، برقم ١٥٧٠٠، وابن ماجه، برقم ٣٥٠٨، ومالك، ١١٨/٣-١١٩، وصححه الألباني في صحيح الجامع، ١/ ٢١٢، وانظر تحقيق زاد المعاد للأرناؤوط، ٤/ ١٧٠."),
            ]),
            HisnChapter(id: "h-126", number: 126, titleEn: "Times of alarm", titleFr: "Moments d'effroi", titleAr: "ما يقال عند الفزع", items: [
                Dhikr(id: "h-126-1", arabic: "«لَا إِلَهَ إِلَّا اللهُ!».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، برقم ٣٣٤٦، ومسلم، ٤/ ٢٢٠٨، برقم ٢٨٨٠."),
            ]),
            HisnChapter(id: "h-128", number: 128, titleEn: "Repelling the devils", titleFr: "Repousser les démons", titleAr: "ما يقول لرد كيد مردة الشياطين", items: [
                Dhikr(id: "h-128-1", arabic: "«أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ الَّتِي لَا يُجَاوِزُهُنَّ بَرٌّ وَلَا فَاجِرٌ: مِنْ شَرِّ مَا خَلَقَ، وَبَرَأَ وَذَرَأَ، وَمِنْ شَرِّ مَا يَنْزِلُ مِنَ السَّمَاءِ، وَمِنْ شَرِّ مَا يَعْرُجُ فِيهَا، وَمِنْ شَرِّ مَا ذَرَأَ فِي الْأَرْضِ، وَمِنْ شَرِّ مَا يَخْرُجُ مِنْهَا، وَمِنْ شَرِّ فِتَنِ اللَّيْلِ وَالنَّهَارِ، وَمِنْ شَرِّ كُلِّ طَارِقٍ إِلَّا طَارِقًا يَطْرُقُ بِخَيْرٍ يَا رَحْمَنُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، ٣/ ٤١٩، برقم ١٥٤٦١، بإسناد صحيح، وابن السني، برقم ٦٣٧، وصحح إسناده الأرناؤوط في تخريجه للطحاوية، ص١٣٣، وانظر: مجمع الزوائد، ١٠/ ١٢٧."),
            ]),
        ]),
    HisnSection(key: "remembrance", icon: "sparkles",
        titleEn: "Forgiveness & Praise", titleFr: "Pardon et louange", titleAr: "الاستغفار والتسبيح",
        subtitleEn: "Constant dhikr", subtitleFr: "Le rappel constant", subtitleAr: "دوام الذكر",
        chapters: [
            HisnChapter(id: "h-107", number: 107, titleEn: "Blessings on the Prophet ﷺ", titleFr: "Prière sur le Prophète ﷺ", titleAr: "فضل الصلاة على النبي ﷺ", items: [
                Dhikr(id: "h-107-1", arabic: "قَالَ النَّبِيُّ ﷺ: «مَنْ صَلَّى عَلَيَّ صَلَاةً؛ صَلَّى اللهُ عَلَيْهِ بِهَا عَشْرًا».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه مسلم، ١/ ٢٨٨، برقم ٣٨٤."),
                Dhikr(id: "h-107-2", arabic: "وَقَالَ ﷺ: «لَا تَجْعَلُوا قَبْرِي عِيدًا، وَصَلُّوا عَلَيَّ؛ فَإِنَّ صَلَاتَكُمْ تَبْلُغُنِي حَيْثُ كُنْتُمْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ٢١٨، برقم ٢٠٤٤، وأحمد، ٢/ ٣٦٧، برقم ٨٨٠٤، وصححه الألباني في صحيح أبي داود، ٢/ ٣٨٣."),
                Dhikr(id: "h-107-3", arabic: "وَقَالَ ﷺ: «الْبَخِيلُ مَنْ ذُكِرْتُ عِنْدَهُ؛ فَلَمْ يُصَلِّ عَلَيَّ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، ٥/ ٥٥١، برقم ٣٥٤٦، وغيره، وانظر: صحيح الجامع، ٣/ ٢٥، وصحيح الترمذي، ٣/ ١٧٧."),
                Dhikr(id: "h-107-4", arabic: "وَقَالَ ﷺ: «إِنَّ لِلَّهِ مَلَائِكَةً سَيَّاحِينَ فِي الْأَرْضِ، يُبَلِّغُونِي مِنْ أُمَّتِي السَّلَامَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "النسائي، ٣/ ٤٣، برقم ١٢٨٢، والحاكم، ٢/ ٤٢١، وصححه الألباني في صحيح النسائي، ١/ ٢٧٤."),
                Dhikr(id: "h-107-5", arabic: "وَقَالَ ﷺ: «مَا مِنْ أَحَدٍ يُسَلِّمُ عَلَيَّ؛ إِلَّا رَدَّ اللهُ عَلَيَّ رُوحِي، حَتَّى أَرُدَّ عَلَيْهِ السَّلَامَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، برقم ٢٠٤١، وحسنه الألباني في صحيح أبي داود، ١/ ٣٨٣."),
            ]),
            HisnChapter(id: "h-129", number: 129, titleEn: "Seeking forgiveness", titleFr: "Demander pardon", titleAr: "الاستغفار والتوبة", items: [
                Dhikr(id: "h-129-1", arabic: "قَالَ رَسُولُ اللهِ ﷺ: «وَاللهِ إِنِّي لَأَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ فِي الْيَوْمِ أَكْثَرَ مِنْ سَبْعِينَ مَرَّةً».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١١/ ١٠١، برقم ٦٣٠٧."),
                Dhikr(id: "h-129-2", arabic: "وَقَالَ ﷺ: «يَا أَيُّهَا النَّاسُ! تُوبُوا إِلَى اللهِ، فَإِنِّي أَتُوبُ فِي الْيَوْمِ إِلَيْهِ مِائَةَ مَرَّةٍ».", translit: "", translation: "", translationFr: "", count: 100, reference: "مسلم، ٤/ ٢٠٧٦، برقم ٢٧٠٢."),
                Dhikr(id: "h-129-3", arabic: "وَقَالَ ﷺ: «مَنْ قَالَ: أَسْتَغْفِرُ اللهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ، وَأَتُوبُ إِلَيْهِ؛ غَفَرَ اللهُ لَهُ، وَإِنْ كَانَ فَرَّ مِنَ الزَّحْفِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أبو داود، ٢/ ٨٥، برقم ١٥١٧، والترمذي، ٥/ ٥٦٩، برقم ٣٥٧٧، والحاكم وصححه، ووافقه الذهبي، ١/ ٥١١، وصححه الألباني، انظر: صحيح الترمذي، ٣/ ١٨٢، وجامع الأصول لأحاديث الرسول ﷺ، ٤/ ٣٨٩-٣٩٠ بتحقيق الأرناؤوط."),
                Dhikr(id: "h-129-4", arabic: "وَقَالَ ﷺ: «أَقْرَبُ مَا يَكُونُ الرَّبُّ مِنَ الْعَبْدِ فِي جَوْفِ اللَّيْلِ الْآخِرِ، فَإِنِ اسْتَطَعْتَ أَنْ تَكُونَ مِمَّنْ يَذْكُرُ اللهَ فِي تِلْكَ السَّاعَةِ؛ فَكُنْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٥٧٩، والنسائي، برقم ٥٧٢، والحاكم، ١/ ٣٠٩، وانظر: صحيح الترمذي، ٣/ ١٨٣، وجامع الأصول بتحقيق الأرناؤوط، ٤/ ١٤٤."),
                Dhikr(id: "h-129-5", arabic: "وَقَالَ ﷺ: «أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ، فَأَكْثِرُوا الدُّعَاءَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ١/ ٣٥٠، برقم ٤٨٢."),
                Dhikr(id: "h-129-6", arabic: "وَقَالَ ﷺ: «إِنَّهُ لَيُغَانُ عَلَى قَلْبِي، وَإِنِّي لَأَسْتَغْفِرُ اللهَ فِي الْيَوْمِ مِائَةَ مَرَّةٍ».", translit: "", translation: "", translationFr: "", count: 100, reference: "أخرجه مسلم، ٤/ ٢٠٧٥، برقم ٢٧٠٢."),
            ]),
            HisnChapter(id: "h-130", number: 130, titleEn: "Tasbīḥ, taḥmīd & takbīr", titleFr: "Tasbīḥ, taḥmīd et takbīr", titleAr: "فَضْلُ التَّسْبِيحِ وَالتَّحْمِيدِ وَالتَّهْلِيلِ وَالتَّكْبِيرِ", items: [
                Dhikr(id: "h-130-1", arabic: "قَالَ ﷺ: «مَنْ قَالَ: سُبْحَانَ اللهِ وَبِحَمْدِهِ) فِي يَوْمٍ مِائَةَ مَرَّةٍ؛ حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ».", translit: "", translation: "", translationFr: "", count: 100, reference: "البخاري، برقم ٦٤٠٥، ومسلم، برقم ٢٦٩١، وانظر: فضل من قالها مائة مرة إذا أصبح وإذا أمسى، ص ٤٩ من هذا الكتاب."),
                Dhikr(id: "h-130-2", arabic: "وَقَالَ ﷺ: «مَنْ قَالَ: لَا إِلَهَ إِلَّا اللهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ؛ عَشْرَ مِرَارٍ؛ كَانَ كَمَنْ أَعْتَقَ أَرْبَعَةَ أَنْفُسٍ مِنْ وَلَدِ إِسْمَاعِيلَ».", translit: "", translation: "", translationFr: "", count: 10, reference: "البخاري، ٧/ ٦٧، برقم ٦٤٠٤، ومسلم بلفظه، ٤/ ٢٠٧١، برقم ٢٦٩٣، وانظر: فضل من قالها في اليوم مائة مرة: الدعاء رقم ٩٣، ص ٥٠ من هذا الكتاب."),
                Dhikr(id: "h-130-3", arabic: "وَقَالَ ﷺ: «كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ، ثَقِيلَتَانِ فِي الْمِيزَانِ، حَبِيبَتَانِ إِلَى الرَّحْمَنِ: سُبْحَانَ اللهِ وَبِحَمْدِهِ، سُبْحَانَ اللهِ الْعَظِيمِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري، ٧/ ١٦٨، برقم ٦٤٠٤، ومسلم، ٤/ ٢٠٧٢، برقم ٢٦٩٤."),
                Dhikr(id: "h-130-4", arabic: "وَقَالَ ﷺ: «لَأَنْ أَقُولَ: سُبْحَانَ اللهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ؛ أَحَبُّ إِلَيَّ مِمَّا طَلَعَتْ عَلَيْهِ الشَّمْسُ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/ ٢٠٧٢، برقم ٢٦٩٥."),
                Dhikr(id: "h-130-5", arabic: "وَقَالَ ﷺ: «أَيَعْجِزُ أَحَدُكُمْ أَنْ يَكْسِبَ كُلَّ يَوْمٍ أَلْفَ حَسَنَةٍ». فَسَأَلَهُ سَائِلٌ مِنْ جُلَسَائِهِ: كَيْفَ يَكْسِبُ أَحَدُنَا أَلْفَ حَسَنَةٍ؟ قَالَ: «يُسَبِّحُ مِائَةَ تَسْبِيحَةٍ، فَيُكْتَبُ لَهُ أَلْفُ حَسَنَةٍ، أَوْ يُحَطُّ عَنْهُ أَلْفُ خَطِيئَةٍ».", translit: "", translation: "", translationFr: "", count: 100, reference: "مسلم، ٤/ ٢٠٧٣، برقم ٢٦٩٨."),
                Dhikr(id: "h-130-6", arabic: "«مَنْ قَالَ: سُبْحَانَ اللهِ الْعَظِيمِ وَبِحَمْدِهِ؛ غُرِسَتْ لَهُ نَخْلَةٌ فِي الْجَنَّةِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه الترمذي، ٥/ ٥١١، برقم ٣٤٦٤، والحاكم، ١/ ٥٠١، وصححه، ووافقه الذهبي، وانظر: صحيح الجامع، ٥/ ٥٣١، وصحيح الترمذي، ٣/ ١٦٠."),
                Dhikr(id: "h-130-7", arabic: "وَقَالَ ﷺ: «يَا عَبْدَ اللهِ بْنَ قَيْسٍ، أَلَا أَدُلُّكَ عَلَى كَنْزٍ مِنْ كُنُوزِ الْجَنَّةِ؟» فَقُلْتُ: بَلَى يَا رَسُولَ اللهِ. قَالَ: «قُلْ: لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١١/ ٢١٣، برقم ٤٢٠٦، ومسلم، برقم ٢٧٠٤."),
                Dhikr(id: "h-130-8", arabic: "وَقَالَ ﷺ: «أَحَبُّ الْكَلَامِ إِلَى اللهِ أَرْبَعٌ: سُبْحَانَ اللهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ، لَا يَضُرُّكَ بِأَيِّهِنَّ بَدَأْتَ».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٣/ ١٦٨٥، برقم ٢١٣٧."),
                Dhikr(id: "h-130-9", arabic: "جَاءَ أَعْرَابِيٌّ إِلَى رَسُولِ اللهِ ﷺ، فَقَالَ: عَلِّمْنِي كَلَامًا أَقُولُهُ. قَالَ: «قُلْ: لَا إِلَهَ ...", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
                Dhikr(id: "h-130-10", arabic: "إِلاَّ اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، اللهُ أَكْبَرُ كَبِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، سُبْحَانَ اللهِ رَبِّ الْعَالَمِينَ، لَا حَوْلَ وَلَا قُوَّةَ إِلاَّ بِاللَّهِ الْعَزِيزِ الْحَكِيمِ». قَالَ: فَهَؤُلَاءِ لِرَبِّي، فَمَا لِي؟ قَالَ: «قُلِ: اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَارْزُقْنِي».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/٢٠٧٢، برقم ٢٦٩٦، وزاد أبو داود، ١/٢٢٠، برقم ٨٣٢: فلما ولَّى الأعرابي قال النبي ﷺ: «لقد ملأ يده من الخير»."),
                Dhikr(id: "h-130-11", arabic: "كَانَ الرَّجُلُ إِذَا أَسْلَمَ؛ عَلَّمَهُ النَّبِيُّ ﷺ الصَّلَاةَ، ثُمَّ أَمَرَهُ أَنْ يَدْعُوَ بِهَؤُلَاءِ الْكَلِمَاتِ: «اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي وَارْزُقْنِي».", translit: "", translation: "", translationFr: "", count: 1, reference: "مسلم، ٤/٢٠٧٣، برقم ٢٦٩٧، وفي رواية له أيضًا: «فإن هؤلاء تجمع لك دنياك وآخرتك»."),
                Dhikr(id: "h-130-12", arabic: "«أَفْضَلُ الذِّكْرِ: لَا إِلَهَ إِلاَّ اللَّهُ، وَأَفْضَلُ الدُّعَاءِ: الْحَمْدُ لِلَّهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "الترمذي، برقم ٣٣٨٣، وابن ماجه، برقم ٣٨٠٠، والحاكم، ١/٥٠٣، وصححه، ووافقه الذهبي، وانظر: صحيح الجامع، ١/٣٦٢."),
                Dhikr(id: "h-130-13", arabic: "«الْبَاقِيَاتُ الصَّالِحَاتُ: سُبْحَانَ اللهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلاَّ اللَّهُ، وَاللَّهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلاَّ بِاللهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أحمد، برقم ٥١٣، بترتيب أحمد شاكر، وانظر: مجمع الزوائد، ١/٢٩٧، وعزاه ابن حجر في بلوغ المرام من رواية أبي سعيد إلى النسائي [في الكبرى]، برقم ١٠٦١٧، وقال: صححه ابن حبان، [برقم ٨٤٠]، والحاكم [١/٥٤١]."),
            ]),
            HisnChapter(id: "h-131", number: 131, titleEn: "How the Prophet ﷺ made tasbīḥ", titleFr: "Le tasbīḥ du Prophète ﷺ", titleAr: "كَيْفَ كَانَ النَّبِيُّ ﷺ يُسَبِّحُ؟", items: [
                Dhikr(id: "h-131-1", arabic: "عَنْ عَبْدِ اللهِ بْنِ عَمْرٍو رضي الله عنهما قَالَ: «رَأَيْتُ النَّبِيَّ ﷺ يَعْقِدُ التَّسْبِيحَ». وَفِي زِيَادَةٍ: «بِيَمِينِهِ».", translit: "", translation: "", translationFr: "", count: 1, reference: "أخرجه أبو داود بلفظه، ٢/٨١، برقم ١٥٠٢، والترمذي، ٥/٥٢١، برقم ٣٤٨٦، وانظر: صحيح الجامع، ٤/٢٧١، برقم ٤٨٦٥، وصححه الألباني في صحيح سنن أبي داود ١/٤١١."),
            ]),
            HisnChapter(id: "h-132", number: 132, titleEn: "Comprehensive good deeds", titleFr: "Les bonnes œuvres complètes", titleAr: "مِنْ أَنْوَاعِ الْخَيْرِ وَالْآدَابِ الْجَامِعَةِ", items: [
                Dhikr(id: "h-132-1", arabic: "قَالَ النَّبِيُّ ﷺ: «إِذَا كَانَ جُنْحُ اللَّيْلِ – أَوْ أَمْسَيْتُمْ –؛ فَكُفُّوا صِبْيَانَكُمْ، فَإِنَّ الشَّيَاطِينَ تَنْتَشِرُ حِينَئِذٍ، فَإِذَا ذَهَبَ سَاعَةٌ مِنَ اللَّيْلِ؛ فَخَلُّوهُمْ، وَأَغْلِقُوا الْأَبْوَابَ، وَاذْكُرُوا اسْمَ اللَّهِ، فَإِنَّ الشَّيْطَانَ لَا يَفْتَحُ بَابًا مُغْلَقًا، وَأَوْكُوا قِرَبَكُمْ، وَاذْكُرُوا اسْمَ اللهِ، وَخَمِّرُوا آنِيَتَكُمْ، وَاذْكُرُوا اسْمَ اللهِ، وَلَوْ أَنْ تَعْرُضُوا عَلَيْهَا شَيْئًا، وَأَطْفِئُوا مَصَابِيحَكُمْ».", translit: "", translation: "", translationFr: "", count: 1, reference: "البخاري مع الفتح، ١٠/٨٨، برقم ٥٦٢٣، ومسلم، ٣/١٥٩٥، برقم ٢٠١٢."),
                Dhikr(id: "h-132-2", arabic: "وَصَلَّى اللهُ وَسَلَّمَ وَبَارَكَ عَلَى نَبِيِّنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ أَجْمَعِينَ.", translit: "", translation: "", translationFr: "", count: 1, reference: ""),
            ]),
        ]),
]
