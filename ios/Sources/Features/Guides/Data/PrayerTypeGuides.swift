import Foundation

let typeGuides: [Guide] = [
    Guide(
        id: "istikhara",
        section: "types",
        icon: "signpost.right.fill",
        title: L3(
            en: "Salat al-Istikhara",
            fr: "Salat al-Istikhara",
            ar: "صَلاةُ الاسْتِخارَة"
        ),
        summary: L3(
            en: "A prayer to seek Allah's guidance when facing any lawful decision. Pray it whenever you are undecided about a course of action, at any time except the forbidden times.",
            fr: "Une prière pour demander la guidance d'Allah face à toute décision licite. Accomplissez-la chaque fois que vous hésitez sur une action, à tout moment sauf aux heures interdites.",
            ar: "صَلاةٌ لِطَلَبِ الخِيَرَةِ مِنَ اللهِ عِنْدَ الإِقْدامِ عَلى أَمْرٍ مُباحٍ. تُصَلّى كُلَّما تَرَدَّدَ المَرْءُ في أَمْرٍ، في أَيِّ وَقْتٍ عَدا أَوْقاتِ النَّهْيِ."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Form a sincere intention",
                    fr: "Formez une intention sincère",
                    ar: "اعْقِدِ النِّيَّةَ الصّادِقَة"
                ),
                body: L3(
                    en: "Intend the Istikhara prayer for the specific matter weighing on you, resolving to accept whatever Allah facilitates.",
                    fr: "Ayez l'intention de la prière d'Istikhara pour l'affaire précise qui vous préoccupe, en vous résolvant à accepter ce qu'Allah facilitera.",
                    ar: "انْوِ صَلاةَ الاسْتِخارَةِ لِلأَمْرِ المُعَيَّنِ الَّذي يَشْغَلُكَ، عازِمًا عَلى قَبولِ ما يُيَسِّرُهُ اللهُ."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Pray two rak'ah",
                    fr: "Priez deux rak'ah",
                    ar: "صَلِّ رَكْعَتَيْن"
                ),
                body: L3(
                    en: "Perform two rak'ah of voluntary prayer (not an obligatory prayer), reciting al-Fatiha and a surah in each as usual.",
                    fr: "Accomplissez deux rak'ah de prière surérogatoire (non une prière obligatoire), en récitant al-Fatiha et une sourate dans chacune, comme d'habitude.",
                    ar: "صَلِّ رَكْعَتَيْنِ نافِلَةً مِنْ غَيْرِ الفَريضَةِ، تَقْرَأُ فيهِما الفاتِحَةَ وَسورَةً كَالمُعْتاد."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Recite the Istikhara du'a",
                    fr: "Récitez la du'a d'Istikhara",
                    ar: "ادْعُ بِدُعاءِ الاسْتِخارَة"
                ),
                body: L3(
                    en: "After the two rak'ah, praise Allah and send blessings on the Prophet, then supplicate: O Allah, I seek Your guidance by Your knowledge and Your power, and I ask You of Your immense bounty. For You are able while I am not, You know while I know not, and You are the Knower of the unseen. O Allah, if You know this matter to be good for me in my religion, my livelihood and the outcome of my affairs, then decree it for me, make it easy for me and bless it for me. But if You know this matter to be bad for me, then turn it away from me and turn me away from it, and decree for me the good wherever it may be, and make me content with it. (Name your need where indicated.)",
                    fr: "Après les deux rak'ah, louez Allah et priez sur le Prophète, puis invoquez : Ô Allah, je Te demande de choisir pour moi par Ta science et Ton pouvoir, et je Te demande de Ton immense faveur. Car Tu es capable et je ne le suis pas, Tu sais et je ne sais pas, et Tu es le Grand Connaisseur de l'invisible. Ô Allah, si Tu sais que cette affaire est un bien pour moi dans ma religion, ma vie et l'issue de mes affaires, alors décrète-la pour moi, facilite-la-moi et bénis-la-moi. Et si Tu sais que cette affaire est un mal pour moi, alors éloigne-la de moi et éloigne-moi d'elle, et décrète pour moi le bien où qu'il soit, puis rends-moi satisfait. (Nommez votre besoin à l'endroit indiqué.)",
                    ar: "بَعْدَ الرَّكْعَتَيْنِ، احْمَدِ اللهَ وَصَلِّ عَلى النَّبِيِّ، ثُمَّ ادْعُ بِهذا الدُّعاءِ، وَتُسَمّي حاجَتَكَ عِنْدَ قَوْلِكَ (هذا الأَمْرَ)."
                ),
                arabic: "اللّٰهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ، فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ، وَتَعْلَمُ وَلَا أَعْلَمُ، وَأَنْتَ عَلَّامُ الْغُيُوبِ. اللّٰهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ، وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ، وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ.",
                translit: "Allāhumma innī astakhīruka bi ʿilmika, wa astaqdiruka bi qudratika, wa asʾaluka min faḍlika al-ʿaẓīm. Fa innaka taqdiru wa lā aqdiru, wa taʿlamu wa lā aʿlamu, wa anta ʿallāmu al-ghuyūb. Allāhumma in kunta taʿlamu anna hādhā al-amra khayrun lī fī dīnī wa maʿāshī wa ʿāqibati amrī, faqdurhu lī wa yassirhu lī thumma bārik lī fīh. Wa in kunta taʿlamu anna hādhā al-amra sharrun lī fī dīnī wa maʿāshī wa ʿāqibati amrī, faṣrifhu ʿannī waṣrifnī ʿanhu, waqdur liya al-khayra ḥaythu kāna thumma arḍinī bih."
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Act and trust Allah",
                    fr: "Agissez et placez votre confiance en Allah",
                    ar: "امْضِ وَتَوَكَّلْ عَلى الله"
                ),
                body: L3(
                    en: "After the du'a, proceed with what your heart inclines toward and pursue the matter with trust in Allah. There is no obligation to see a dream; go forward with what unfolds and Allah will guide you to the good.",
                    fr: "Après l'invocation, poursuivez ce vers quoi votre cœur penche et engagez l'affaire en plaçant votre confiance en Allah. Il n'est pas nécessaire de voir un rêve ; avancez selon ce qui se présente et Allah vous guidera vers le bien.",
                    ar: "بَعْدَ الدُّعاءِ، امْضِ إِلى ما يَنْشَرِحُ لَهُ صَدْرُكَ وَباشِرِ الأَمْرَ مُتَوَكِّلًا عَلى اللهِ. وَلَيْسَ شَرْطًا رُؤْيَةُ مَنامٍ؛ فَامْضِ فيما يَتَيَسَّرُ وَاللهُ يَهْديكَ لِلْخَيْر."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "witr",
        section: "types",
        icon: "moon.fill",
        title: L3(
            en: "Salat al-Witr",
            fr: "Salat al-Witr",
            ar: "صَلاةُ الوِتْر"
        ),
        summary: L3(
            en: "An emphasized sunnah prayer of an odd number of rak'ah that concludes the night prayers. Its time runs from after Isha until dawn (Fajr).",
            fr: "Une prière sunnah fortement recommandée d'un nombre impair de rak'ah qui clôt les prières de la nuit. Son temps s'étend d'après l'Isha jusqu'à l'aube (Fajr).",
            ar: "سُنَّةٌ مُؤَكَّدَةٌ بِعَدَدٍ فَرْدِيٍّ مِنَ الرَّكَعاتِ تُخْتَمُ بِها صَلاةُ اللَّيْلِ. وَقْتُها مِنْ بَعْدِ العِشاءِ إِلى طُلوعِ الفَجْر."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Know its time and number",
                    fr: "Connaissez son temps et son nombre",
                    ar: "اعْرِفْ وَقْتَها وَعَدَدَها"
                ),
                body: L3(
                    en: "Witr is a minimum of one rak'ah and may be three, five, seven or more, always ending on an odd count. The most common is three. It is prayed after Isha; whoever fears not waking may pray it before sleeping.",
                    fr: "Le Witr est au minimum d'une rak'ah et peut être de trois, cinq, sept ou plus, se terminant toujours par un nombre impair. Le plus courant est trois. Il se prie après l'Isha ; qui craint de ne pas se réveiller peut le prier avant de dormir.",
                    ar: "الوِتْرُ أَقَلُّهُ رَكْعَةٌ واحِدَةٌ، وَقَدْ يَكونُ ثَلاثًا أَوْ خَمْسًا أَوْ سَبْعًا فَأَكْثَرَ، وَيَنْتَهي دائِمًا بِوَتْرٍ. وَأَشْهَرُهُ ثَلاثٌ. يُصَلّى بَعْدَ العِشاءِ، وَمَنْ خافَ أَلّا يَقومَ صَلّاهُ قَبْلَ النَّوْم."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Pray the rak'ah",
                    fr: "Priez les rak'ah",
                    ar: "صَلِّ الرَّكَعات"
                ),
                body: L3(
                    en: "A common way is to pray two rak'ah and give salam, then pray one final rak'ah alone. It may also be prayed as three continuous rak'ah. Recite al-Fatiha and a surah in each.",
                    fr: "Une manière courante est de prier deux rak'ah et de faire le salam, puis de prier une dernière rak'ah seule. On peut aussi le prier en trois rak'ah continues. Récitez al-Fatiha et une sourate dans chacune.",
                    ar: "مِنَ المَشْهورِ أَنْ تُصَلِّيَ رَكْعَتَيْنِ وَتُسَلِّمَ، ثُمَّ تُصَلِّيَ رَكْعَةً واحِدَةً مُنْفَرِدَةً. وَيَجوزُ صَلاتُها ثَلاثًا مُتَّصِلَةً. تَقْرَأُ الفاتِحَةَ وَسورَةً في كُلِّ رَكْعَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Recite the Qunut (optional)",
                    fr: "Récitez le Qunut (facultatif)",
                    ar: "اقْنُتْ (اخْتِيارِيّ)"
                ),
                body: L3(
                    en: "In the last rak'ah, before or after ruku', you may raise your hands and recite the du'a of Qunut, such as: O Allah, guide me among those You have guided...",
                    fr: "Dans la dernière rak'ah, avant ou après le ruku', vous pouvez lever les mains et réciter la du'a du Qunut, telle que : Ô Allah, guide-moi parmi ceux que Tu as guidés...",
                    ar: "في الرَّكْعَةِ الأَخيرَةِ، قَبْلَ الرُّكوعِ أَوْ بَعْدَهُ، يُمْكِنُكَ رَفْعُ اليَدَيْنِ وَقِراءَةُ دُعاءِ القُنوت."
                ),
                arabic: "اللّٰهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ، وَبَارِكْ لِي فِيمَا أَعْطَيْتَ.",
                translit: "Allāhumma-hdinī fī man hadayt, wa ʿāfinī fī man ʿāfayt, wa tawallanī fī man tawallayt, wa bārik lī fī mā aʿṭayt."
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Conclude with salam",
                    fr: "Terminez par le salam",
                    ar: "اخْتِمْ بِالسَّلام"
                ),
                body: L3(
                    en: "Complete the tashahhud and salam. It is sunnah afterward to say three times: Subhana al-Malik al-Quddus.",
                    fr: "Complétez le tashahhud et le salam. Il est sunnah de dire ensuite trois fois : Subhana al-Malik al-Quddus.",
                    ar: "أَتِمَّ التَّشَهُّدَ وَالسَّلامَ. وَمِنَ السُّنَّةِ أَنْ تَقولَ بَعْدَها ثَلاثًا: سُبْحانَ المَلِكِ القُدّوس."
                ),
                arabic: "سُبْحَانَ الْمَلِكِ الْقُدُّوسِ",
                translit: "Subḥāna al-Maliki al-Quddūs"
            )
        ]
    ),
    Guide(
        id: "duha",
        section: "types",
        icon: "sun.max.fill",
        title: L3(
            en: "Salat al-Duha",
            fr: "Salat al-Duha",
            ar: "صَلاةُ الضُّحى"
        ),
        summary: L3(
            en: "A voluntary forenoon prayer of two or more rak'ah. Its time is from about twenty minutes after sunrise until just before the sun reaches its zenith (before Dhuhr).",
            fr: "Une prière surérogatoire de la matinée, de deux rak'ah ou plus. Son temps s'étend d'environ vingt minutes après le lever du soleil jusqu'à juste avant que le soleil n'atteigne son zénith (avant Dhuhr).",
            ar: "صَلاةٌ نافِلَةٌ في الضُّحى، رَكْعَتانِ فَأَكْثَرُ. وَقْتُها مِنِ ارْتِفاعِ الشَّمْسِ (نَحْوَ رُبْعِ ساعَةٍ بَعْدَ الشُّروقِ) إِلى قُبَيْلِ الزَّوال."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Wait until the sun has risen",
                    fr: "Attendez que le soleil se soit élevé",
                    ar: "انْتَظِرِ ارْتِفاعَ الشَّمْس"
                ),
                body: L3(
                    en: "Begin after the sun has clearly risen (roughly fifteen to twenty minutes after sunrise), avoiding the moment of sunrise itself when prayer is disliked.",
                    fr: "Commencez après que le soleil se soit clairement élevé (environ quinze à vingt minutes après le lever), en évitant le moment même du lever où la prière est détestée.",
                    ar: "ابْدَأْ بَعْدَ ارْتِفاعِ الشَّمْسِ ارْتِفاعًا بَيِّنًا (نَحْوَ رُبْعِ ساعَةٍ بَعْدَ الشُّروقِ)، مُتَجَنِّبًا لَحْظَةَ الشُّروقِ الَّتي تُكْرَهُ فيها الصَّلاة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Pray in pairs of rak'ah",
                    fr: "Priez par paires de rak'ah",
                    ar: "صَلِّ مَثْنى مَثْنى"
                ),
                body: L3(
                    en: "Pray a minimum of two rak'ah, giving salam after each pair. Four, six or eight rak'ah are all reported; eight is often mentioned as a fuller amount.",
                    fr: "Priez au minimum deux rak'ah, en faisant le salam après chaque paire. Quatre, six ou huit rak'ah sont rapportées ; huit est souvent mentionné comme un nombre plus complet.",
                    ar: "صَلِّ رَكْعَتَيْنِ عَلى الأَقَلِّ، تُسَلِّمُ بَعْدَ كُلِّ رَكْعَتَيْنِ. وَقَدْ وَرَدَ أَرْبَعٌ وَسِتٌّ وَثَمانٍ، وَالثَّمانُ مِنْ أَكْمَلِ ما وَرَد."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Recite normally and complete each pair",
                    fr: "Récitez normalement et complétez chaque paire",
                    ar: "اقْرَأْ كَالمُعْتادِ وَأَتِمَّ كُلَّ رَكْعَتَيْن"
                ),
                body: L3(
                    en: "In each rak'ah recite al-Fatiha and a surah, then complete the ruku', sujud, tashahhud and salam as in any prayer. The Prophet described Duha as a charity for every joint of the body.",
                    fr: "Dans chaque rak'ah, récitez al-Fatiha et une sourate, puis complétez le ruku', le sujud, le tashahhud et le salam comme dans toute prière. Le Prophète a décrit le Duha comme une aumône pour chaque articulation du corps.",
                    ar: "في كُلِّ رَكْعَةٍ اقْرَأِ الفاتِحَةَ وَسورَةً، ثُمَّ أَتِمَّ الرُّكوعَ وَالسُّجودَ وَالتَّشَهُّدَ وَالسَّلامَ كَسائِرِ الصَّلاةِ. وَقَدْ وَصَفَ النَّبِيُّ الضُّحى بِأَنَّها صَدَقَةٌ عَنْ كُلِّ مَفْصِل."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "tahajjud",
        section: "types",
        icon: "moon.stars.fill",
        title: L3(
            en: "Tahajjud (Qiyam al-Layl)",
            fr: "Tahajjud (Qiyam al-Layl)",
            ar: "التَّهَجُّد (قِيامُ اللَّيْل)"
        ),
        summary: L3(
            en: "The voluntary night prayer, the most virtuous prayer after the obligatory ones. It is prayed after waking from sleep, with the last third of the night being the best time.",
            fr: "La prière nocturne surérogatoire, la plus méritoire après les prières obligatoires. Elle se prie après s'être réveillé, le dernier tiers de la nuit étant le meilleur moment.",
            ar: "صَلاةُ اللَّيْلِ النافِلَةُ، أَفْضَلُ الصَّلاةِ بَعْدَ الفَريضَةِ. تُصَلّى بَعْدَ الاسْتيقاظِ مِنَ النَّوْمِ، وَأَفْضَلُ وَقْتِها الثُّلُثُ الأَخيرُ مِنَ اللَّيْل."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Rise in the night with intention",
                    fr: "Levez-vous la nuit avec intention",
                    ar: "قُمْ مِنَ اللَّيْلِ بِنِيَّة"
                ),
                body: L3(
                    en: "Wake during the night, ideally in its last third, and intend to pray for Allah's sake. Begin with wudu and, if you wish, a light opening du'a upon waking.",
                    fr: "Réveillez-vous durant la nuit, idéalement dans son dernier tiers, et ayez l'intention de prier pour Allah. Commencez par les ablutions et, si vous le souhaitez, une brève invocation d'ouverture au réveil.",
                    ar: "اسْتَيْقِظْ في اللَّيْلِ، وَأَفْضَلُهُ ثُلُثُهُ الأَخيرُ، وَانْوِ الصَّلاةَ للهِ. ابْدَأْ بِالوُضوءِ، وَإِنْ شِئْتَ بِدُعاءِ الاسْتيقاظ."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Pray two rak'ah at a time",
                    fr: "Priez deux rak'ah à la fois",
                    ar: "صَلِّ رَكْعَتَيْنِ رَكْعَتَيْن"
                ),
                body: L3(
                    en: "The night prayer is prayed two rak'ah at a time, giving salam after each pair. Pray as many pairs as you are able; the Prophet often lengthened the recitation, ruku' and sujud.",
                    fr: "La prière nocturne se prie deux rak'ah à la fois, avec le salam après chaque paire. Priez autant de paires que vous le pouvez ; le Prophète prolongeait souvent la récitation, le ruku' et le sujud.",
                    ar: "صَلاةُ اللَّيْلِ مَثْنى مَثْنى، تُسَلِّمُ بَعْدَ كُلِّ رَكْعَتَيْنِ. صَلِّ ما تَيَسَّرَ مِنَ الرَّكَعاتِ، وَكانَ النَّبِيُّ يُطيلُ القِراءَةَ وَالرُّكوعَ وَالسُّجود."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Lengthen your standing and du'a",
                    fr: "Prolongez la station debout et l'invocation",
                    ar: "أَطِلِ القِيامَ وَالدُّعاء"
                ),
                body: L3(
                    en: "Draw out your recitation and supplication, humbling yourself before Allah in the quiet of the night, when du'a is closest to being answered.",
                    fr: "Prolongez votre récitation et votre invocation, en vous humiliant devant Allah dans le calme de la nuit, lorsque la du'a est la plus proche d'être exaucée.",
                    ar: "أَطِلْ قِراءَتَكَ وَدُعاءَكَ، مُتَذَلِّلًا بَيْنَ يَدَيِ اللهِ في سُكونِ اللَّيْلِ، حَيْثُ يَكونُ الدُّعاءُ أَقْرَبَ لِلإِجابَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Seal the night with Witr",
                    fr: "Scellez la nuit par le Witr",
                    ar: "اخْتِمِ اللَّيْلَ بِالوِتْر"
                ),
                body: L3(
                    en: "Make Witr the last prayer of your night. If you already prayed Witr after Isha and then rose for Tahajjud, do not repeat it, as there are no two Witr in one night.",
                    fr: "Faites du Witr la dernière prière de votre nuit. Si vous avez déjà prié le Witr après l'Isha puis vous êtes levé pour le Tahajjud, ne le répétez pas, car il n'y a pas deux Witr en une nuit.",
                    ar: "اجْعَلِ الوِتْرَ آخِرَ صَلاةِ لَيْلِكَ. وَإِنْ كُنْتَ أَوْتَرْتَ بَعْدَ العِشاءِ ثُمَّ قُمْتَ لِلتَّهَجُّدِ فَلا تُعِدْهُ، فَلا وِتْرانِ في لَيْلَة."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "janazah",
        section: "types",
        icon: "hands.and.sparkles.fill",
        title: L3(
            en: "Salat al-Janazah",
            fr: "Salat al-Janazah",
            ar: "صَلاةُ الجَنازَة"
        ),
        summary: L3(
            en: "The funeral prayer, a communal obligation (fard kifayah) offered for a deceased Muslim. It is performed standing, with four takbirs and no ruku' or sujud.",
            fr: "La prière funéraire, une obligation collective (fard kifayah) offerte pour un défunt musulman. Elle s'accomplit debout, avec quatre takbirs et sans ruku' ni sujud.",
            ar: "صَلاةٌ عَلى المَيِّتِ المُسْلِمِ، وَهِيَ فَرْضُ كِفايَةٍ. تُؤَدّى قِيامًا بِأَرْبَعِ تَكْبيراتٍ بِلا رُكوعٍ وَلا سُجود."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "First takbir and al-Fatiha",
                    fr: "Premier takbir et al-Fatiha",
                    ar: "التَّكْبيرَةُ الأولى وَالفاتِحَة"
                ),
                body: L3(
                    en: "Stand facing the qibla with the deceased before you. Make the opening takbir, then recite al-Fatiha silently.",
                    fr: "Tenez-vous debout face à la qibla, le défunt devant vous. Faites le takbir d'ouverture, puis récitez al-Fatiha à voix basse.",
                    ar: "قِفْ مُسْتَقْبِلَ القِبْلَةِ وَالمَيِّتُ أَمامَكَ. كَبِّرِ التَّكْبيرَةَ الأولى، ثُمَّ اقْرَأِ الفاتِحَةَ سِرًّا."
                ),
                arabic: "اللّٰهُ أَكْبَر",
                translit: "Allāhu akbar"
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Second takbir and salawat",
                    fr: "Deuxième takbir et salawat",
                    ar: "التَّكْبيرَةُ الثّانِيَةُ وَالصَّلاةُ عَلى النَّبِيّ"
                ),
                body: L3(
                    en: "Make the second takbir and send blessings on the Prophet, using the same words as in the tashahhud (the Ibrahimiyyah salawat).",
                    fr: "Faites le deuxième takbir et priez sur le Prophète, avec les mêmes paroles que dans le tashahhud (la salawat ibrahimiyyah).",
                    ar: "كَبِّرِ الثّانِيَةَ وَصَلِّ عَلى النَّبِيِّ بِمِثْلِ ما في التَّشَهُّدِ (الصَّلاةُ الإِبْراهيمِيَّة)."
                ),
                arabic: "اللّٰهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ.",
                translit: "Allāhumma ṣalli ʿalā Muḥammad wa ʿalā āli Muḥammad, kamā ṣallayta ʿalā Ibrāhīm wa ʿalā āli Ibrāhīm, innaka Ḥamīdun Majīd."
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Third takbir and du'a for the deceased",
                    fr: "Troisième takbir et du'a pour le défunt",
                    ar: "التَّكْبيرَةُ الثّالِثَةُ وَالدُّعاءُ لِلمَيِّت"
                ),
                body: L3(
                    en: "Make the third takbir and supplicate sincerely for the deceased, such as: O Allah, forgive him and have mercy on him, pardon him, honour his resting place... and cleanse him of his sins as a white garment is cleansed of dirt.",
                    fr: "Faites le troisième takbir et invoquez sincèrement pour le défunt, par exemple : Ô Allah, pardonne-lui et fais-lui miséricorde, épargne-le, honore sa demeure... et purifie-le de ses péchés comme est purifié un vêtement blanc de la saleté.",
                    ar: "كَبِّرِ الثّالِثَةَ وَادْعُ لِلمَيِّتِ بِإِخْلاصٍ، وَمِنْهُ: اللّٰهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ..."
                ),
                arabic: "اللّٰهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ، وَعَافِهِ وَاعْفُ عَنْهُ، وَأَكْرِمْ نُزُلَهُ، وَوَسِّعْ مُدْخَلَهُ، وَاغْسِلْهُ بِالْمَاءِ وَالثَّلْجِ وَالْبَرَدِ، وَنَقِّهِ مِنَ الْخَطَايَا كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ.",
                translit: "Allāhumma-ghfir lahu warḥamhu, wa ʿāfihi waʿfu ʿanhu, wa akrim nuzulahu, wa wassiʿ mudkhalahu, waghsilhu bil-māʾi wath-thalji wal-barad, wa naqqihi mina al-khaṭāyā kamā yunaqqā ath-thawbu al-abyaḍu mina ad-danas."
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Fourth takbir and salam",
                    fr: "Quatrième takbir et salam",
                    ar: "التَّكْبيرَةُ الرّابِعَةُ وَالسَّلام"
                ),
                body: L3(
                    en: "Make the fourth takbir, pause briefly (you may add a short du'a such as: O Allah, do not deprive us of his reward and do not test us after him), then give one or two salams to end the prayer.",
                    fr: "Faites le quatrième takbir, marquez une brève pause (vous pouvez ajouter une courte du'a comme : Ô Allah, ne nous prive pas de sa récompense et ne nous éprouve pas après lui), puis faites un ou deux salams pour terminer.",
                    ar: "كَبِّرِ الرّابِعَةَ، وَاسْكُتْ يَسيرًا (وَيُمْكِنُ أَنْ تَقولَ: اللّٰهُمَّ لا تَحْرِمْنا أَجْرَهُ وَلا تَفْتِنّا بَعْدَهُ)، ثُمَّ سَلِّمْ تَسْليمَةً أَوْ تَسْليمَتَيْن."
                ),
                arabic: "السَّلامُ عَلَيْكُمْ وَرَحْمَةُ اللهِ",
                translit: "As-salāmu ʿalaykum wa raḥmatu-llāh"
            )
        ]
    ),
    Guide(
        id: "tarawih",
        section: "types",
        icon: "star.fill",
        title: L3(
            en: "Salat at-Tarawih",
            fr: "Salat at-Tarawih",
            ar: "صَلاةُ التَّراويح"
        ),
        summary: L3(
            en: "The emphasized night prayer of Ramadan, prayed in congregation after Isha throughout the month. It is prayed in pairs of rak'ah and usually followed by Witr.",
            fr: "La prière nocturne fortement recommandée du Ramadan, priée en congrégation après l'Isha tout au long du mois. Elle se prie par paires de rak'ah et est généralement suivie du Witr.",
            ar: "قِيامُ رَمَضانَ المُؤَكَّدُ، يُصَلّى جَماعَةً بَعْدَ العِشاءِ طَوالَ الشَّهْرِ. يُصَلّى مَثْنى مَثْنى وَيُتْبَعُ عادَةً بِالوِتْر."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Pray after Isha in Ramadan",
                    fr: "Priez après l'Isha en Ramadan",
                    ar: "صَلِّ بَعْدَ العِشاءِ في رَمَضان"
                ),
                body: L3(
                    en: "Tarawih is prayed after the obligatory Isha prayer and its sunnah, on the nights of Ramadan. Praying it in congregation at the mosque is the established practice.",
                    fr: "Le Tarawih se prie après la prière obligatoire de l'Isha et sa sunnah, durant les nuits du Ramadan. Le prier en congrégation à la mosquée est la pratique établie.",
                    ar: "يُصَلّى التَّراويحُ بَعْدَ فَرْضِ العِشاءِ وَسُنَّتِها، في لَيالي رَمَضانَ. وَصَلاتُهُ جَماعَةً في المَسْجِدِ هِيَ السُّنَّةُ المُتَّبَعَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Pray in pairs of rak'ah",
                    fr: "Priez par paires de rak'ah",
                    ar: "صَلِّ مَثْنى مَثْنى"
                ),
                body: L3(
                    en: "Pray two rak'ah at a time, giving salam after each pair. It is commonly prayed as eight or twenty rak'ah; both are valid, as the number is not fixed and the quality of prayer matters most.",
                    fr: "Priez deux rak'ah à la fois, avec le salam après chaque paire. On le prie couramment en huit ou vingt rak'ah ; les deux sont valides, car le nombre n'est pas fixé et la qualité de la prière importe le plus.",
                    ar: "صَلِّ رَكْعَتَيْنِ رَكْعَتَيْنِ، تُسَلِّمُ بَعْدَ كُلِّ رَكْعَتَيْنِ. وَيُصَلّى عادَةً ثَمانِيًا أَوْ عِشْرينَ رَكْعَةً، وَكِلاهُما صَحيحٌ إِذْ لا حَدَّ لِلعَدَدِ وَالعِبْرَةُ بِالخُشوع."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Listen and follow the imam",
                    fr: "Écoutez et suivez l'imam",
                    ar: "أَنْصِتْ وَاتْبَعِ الإِمام"
                ),
                body: L3(
                    en: "In congregation, follow the imam who recites the Qur'an aloud, often completing much of the Qur'an across the month. Standing until the imam finishes counts as having prayed the whole night.",
                    fr: "En congrégation, suivez l'imam qui récite le Coran à voix haute, achevant souvent une grande partie du Coran durant le mois. Rester avec l'imam jusqu'à ce qu'il termine équivaut à avoir prié toute la nuit.",
                    ar: "في الجَماعَةِ، اتْبَعِ الإِمامَ الَّذي يَجْهَرُ بِالقِراءَةِ، وَكَثيرًا ما يَخْتِمُ القُرْآنَ في الشَّهْرِ. وَمَنْ قامَ مَعَ الإِمامِ حَتّى يَنْصَرِفَ كُتِبَ لَهُ قِيامُ لَيْلَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Conclude with Witr",
                    fr: "Terminez par le Witr",
                    ar: "اخْتِمْ بِالوِتْر"
                ),
                body: L3(
                    en: "Tarawih is usually followed by the Witr prayer led by the imam. If you intend to pray Tahajjud later in the night, you may delay your Witr to the end of the night.",
                    fr: "Le Tarawih est généralement suivi de la prière du Witr dirigée par l'imam. Si vous comptez prier le Tahajjud plus tard dans la nuit, vous pouvez retarder votre Witr jusqu'à la fin de la nuit.",
                    ar: "يُتْبَعُ التَّراويحُ عادَةً بِصَلاةِ الوِتْرِ خَلْفَ الإِمامِ. وَإِنْ عَزَمْتَ عَلى التَّهَجُّدِ آخِرَ اللَّيْلِ، فَلَكَ أَنْ تُؤَخِّرَ وِتْرَكَ إِلى آخِرِه."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "jumuah",
        section: "types",
        icon: "person.3.fill",
        title: L3(
            en: "Salat al-Jumu'ah",
            fr: "Salat al-Jumu'ah",
            ar: "صَلاةُ الجُمُعَة"
        ),
        summary: L3(
            en: "The obligatory Friday congregational prayer, which replaces Dhuhr for men. It consists of a khutbah (sermon) followed by two rak'ah prayed aloud behind the imam.",
            fr: "La prière obligatoire du vendredi en congrégation, qui remplace le Dhuhr pour les hommes. Elle consiste en un khutbah (sermon) suivi de deux rak'ah priées à voix haute derrière l'imam.",
            ar: "صَلاةٌ واجِبَةٌ يَوْمَ الجُمُعَةِ جَماعَةً، تَحُلُّ مَحَلَّ الظُّهْرِ لِلرِّجالِ. تَتَكَوَّنُ مِنْ خُطْبَةٍ ثُمَّ رَكْعَتَيْنِ جَهْرِيَّتَيْنِ خَلْفَ الإِمام."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Prepare and come early",
                    fr: "Préparez-vous et venez tôt",
                    ar: "تَهَيَّأْ وَبَكِّر"
                ),
                body: L3(
                    en: "It is sunnah to perform ghusl, wear clean clothes, apply perfume and go early to the mosque. On arriving, pray the tahiyyat al-masjid (greeting of the mosque) before sitting.",
                    fr: "Il est sunnah de faire le ghusl, de porter des vêtements propres, de se parfumer et d'aller tôt à la mosquée. En arrivant, priez le tahiyyat al-masjid (salutation de la mosquée) avant de vous asseoir.",
                    ar: "مِنَ السُّنَّةِ الاغْتِسالُ وَلُبْسُ الثِّيابِ النَّظيفَةِ وَالتَّطَيُّبُ وَالتَّبْكيرُ إِلى المَسْجِدِ. وَإِذا دَخَلْتَ فَصَلِّ تَحِيَّةَ المَسْجِدِ قَبْلَ الجُلوس."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Listen attentively to the khutbah",
                    fr: "Écoutez attentivement le khutbah",
                    ar: "أَنْصِتْ لِلخُطْبَة"
                ),
                body: L3(
                    en: "The imam delivers two sermons separated by a brief sitting. Listen in silence, for speaking during the khutbah is prohibited and diminishes the reward of your Jumu'ah.",
                    fr: "L'imam prononce deux sermons séparés par une brève assise. Écoutez en silence, car parler pendant le khutbah est interdit et diminue la récompense de votre Jumu'ah.",
                    ar: "يُلْقي الإِمامُ خُطْبَتَيْنِ يَفْصِلُ بَيْنَهُما بِجَلْسَةٍ يَسيرَةٍ. أَنْصِتْ صامِتًا، فَالكَلامُ أَثْناءَ الخُطْبَةِ مَنْهِيٌّ عَنْهُ وَيُنْقِصُ أَجْرَ جُمُعَتِك."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Pray two rak'ah behind the imam",
                    fr: "Priez deux rak'ah derrière l'imam",
                    ar: "صَلِّ رَكْعَتَيْنِ خَلْفَ الإِمام"
                ),
                body: L3(
                    en: "After the khutbah the iqamah is called and you pray two rak'ah aloud behind the imam. These two rak'ah replace the Dhuhr prayer; whoever misses the congregation prays Dhuhr as four rak'ah instead.",
                    fr: "Après le khutbah, l'iqamah est appelé et vous priez deux rak'ah à voix haute derrière l'imam. Ces deux rak'ah remplacent la prière du Dhuhr ; qui manque la congrégation prie le Dhuhr en quatre rak'ah à la place.",
                    ar: "بَعْدَ الخُطْبَةِ تُقامُ الصَّلاةُ فَتُصَلّي رَكْعَتَيْنِ جَهْرًا خَلْفَ الإِمامِ. وَهاتانِ الرَّكْعَتانِ تُغْنِيانِ عَنِ الظُّهْرِ، وَمَنْ فاتَتْهُ الجَماعَةُ صَلّى الظُّهْرَ أَرْبَعًا."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Pray the sunnah afterward",
                    fr: "Priez la sunnah ensuite",
                    ar: "صَلِّ السُّنَّةَ بَعْدَها"
                ),
                body: L3(
                    en: "After the obligatory prayer, pray the following sunnah of two or four rak'ah. Reciting Surat al-Kahf and sending abundant blessings on the Prophet on Friday are also recommended.",
                    fr: "Après la prière obligatoire, priez la sunnah suivante de deux ou quatre rak'ah. Réciter la sourate al-Kahf et prier abondamment sur le Prophète le vendredi sont également recommandés.",
                    ar: "بَعْدَ الفَرْضِ صَلِّ السُّنَّةَ البَعْدِيَّةَ رَكْعَتَيْنِ أَوْ أَرْبَعًا. وَيُسْتَحَبُّ قِراءَةُ سورَةِ الكَهْفِ وَالإِكْثارُ مِنَ الصَّلاةِ عَلى النَّبِيِّ يَوْمَ الجُمُعَة."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "eid",
        section: "types",
        icon: "party.popper.fill",
        title: L3(
            en: "Salat al-Eid",
            fr: "Salat al-Eid",
            ar: "صَلاةُ العيد"
        ),
        summary: L3(
            en: "The festival prayer of Eid al-Fitr and Eid al-Adha, prayed in congregation in the morning. It is two rak'ah with extra takbirs, followed by a khutbah.",
            fr: "La prière des fêtes de l'Aïd al-Fitr et de l'Aïd al-Adha, priée en congrégation le matin. Elle est de deux rak'ah avec des takbirs supplémentaires, suivie d'un khutbah.",
            ar: "صَلاةُ العيدَيْنِ (الفِطْرِ وَالأَضْحى)، تُصَلّى جَماعَةً في الصَّباحِ. وَهِيَ رَكْعَتانِ بِتَكْبيراتٍ زائِدَةٍ، يَتْبَعُها خُطْبَة."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Prepare for the Eid prayer",
                    fr: "Préparez-vous pour la prière de l'Aïd",
                    ar: "تَهَيَّأْ لِصَلاةِ العيد"
                ),
                body: L3(
                    en: "Perform ghusl, wear your best clothes and go to the prayer place. For Eid al-Fitr it is sunnah to eat before leaving; for Eid al-Adha, to delay eating until after the prayer. There is no adhan or iqamah.",
                    fr: "Faites le ghusl, portez vos plus beaux vêtements et rendez-vous au lieu de prière. Pour l'Aïd al-Fitr, il est sunnah de manger avant de partir ; pour l'Aïd al-Adha, de retarder le repas jusqu'après la prière. Il n'y a ni adhan ni iqamah.",
                    ar: "اغْتَسِلْ وَالْبَسْ أَحْسَنَ ثِيابِكَ وَاذْهَبْ إِلى المُصَلّى. وَفي الفِطْرِ يُسَنُّ الأَكْلُ قَبْلَ الخُروجِ، وَفي الأَضْحى تَأْخيرُهُ إِلى ما بَعْدَ الصَّلاةِ. وَلا أَذانَ وَلا إِقامَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "First rak'ah with extra takbirs",
                    fr: "Première rak'ah avec takbirs supplémentaires",
                    ar: "الرَّكْعَةُ الأولى بِالتَّكْبيراتِ الزّائِدَة"
                ),
                body: L3(
                    en: "After the opening takbir, say around seven takbirs (raising the hands each time) before al-Fatiha, then recite al-Fatiha and a surah aloud behind the imam.",
                    fr: "Après le takbir d'ouverture, dites environ sept takbirs (en levant les mains à chaque fois) avant al-Fatiha, puis récitez al-Fatiha et une sourate à voix haute derrière l'imam.",
                    ar: "بَعْدَ تَكْبيرَةِ الإِحْرامِ، كَبِّرْ نَحْوَ سَبْعِ تَكْبيراتٍ (تَرْفَعُ يَدَيْكَ مَعَ كُلِّ واحِدَةٍ) قَبْلَ الفاتِحَةِ، ثُمَّ اقْرَأِ الفاتِحَةَ وَسورَةً جَهْرًا خَلْفَ الإِمام."
                ),
                arabic: "اللّٰهُ أَكْبَر",
                translit: "Allāhu akbar"
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Second rak'ah with extra takbirs",
                    fr: "Deuxième rak'ah avec takbirs supplémentaires",
                    ar: "الرَّكْعَةُ الثّانِيَةُ بِالتَّكْبيراتِ الزّائِدَة"
                ),
                body: L3(
                    en: "Rising for the second rak'ah, say around five extra takbirs before al-Fatiha, then complete the recitation, ruku', sujud and tashahhud, ending with salam. (Takbir counts differ slightly between the schools.)",
                    fr: "En vous levant pour la deuxième rak'ah, dites environ cinq takbirs supplémentaires avant al-Fatiha, puis complétez la récitation, le ruku', le sujud et le tashahhud, en terminant par le salam. (Le nombre de takbirs varie légèrement entre les écoles.)",
                    ar: "عِنْدَ القِيامِ لِلرَّكْعَةِ الثّانِيَةِ، كَبِّرْ نَحْوَ خَمْسِ تَكْبيراتٍ قَبْلَ الفاتِحَةِ، ثُمَّ أَتِمَّ القِراءَةَ وَالرُّكوعَ وَالسُّجودَ وَالتَّشَهُّدَ وَالسَّلامَ. (وَيَخْتَلِفُ عَدَدُ التَّكْبيراتِ يَسيرًا بَيْنَ المَذاهِب.)"
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Listen to the khutbah",
                    fr: "Écoutez le khutbah",
                    ar: "اسْتَمِعْ لِلخُطْبَة"
                ),
                body: L3(
                    en: "Unlike Jumu'ah, the Eid khutbah comes after the prayer. It is recommended to stay and listen. Saying the takbir of Eid on the way and until the prayer is part of the sunnah.",
                    fr: "Contrairement à la Jumu'ah, le khutbah de l'Aïd vient après la prière. Il est recommandé de rester et d'écouter. Dire le takbir de l'Aïd en chemin et jusqu'à la prière fait partie de la sunnah.",
                    ar: "بِخِلافِ الجُمُعَةِ، تَأْتي خُطْبَةُ العيدِ بَعْدَ الصَّلاةِ، وَيُسْتَحَبُّ البَقاءُ لِسَماعِها. وَمِنَ السُّنَّةِ التَّكْبيرُ في الطَّريقِ وَحَتّى الصَّلاة."
                ),
                arabic: "اللّٰهُ أَكْبَرُ اللّٰهُ أَكْبَرُ لَا إِلٰهَ إِلَّا اللّٰهُ، وَاللّٰهُ أَكْبَرُ اللّٰهُ أَكْبَرُ وَلِلّٰهِ الْحَمْدُ",
                translit: "Allāhu akbar, Allāhu akbar, lā ilāha illā-llāh, wa-llāhu akbar, Allāhu akbar wa lillāhi al-ḥamd"
            )
        ]
    ),
    Guide(
        id: "hajah",
        section: "types",
        icon: "hands.sparkles.fill",
        title: L3(
            en: "Salat al-Hajah",
            fr: "Salat al-Hajah",
            ar: "صَلاةُ الحاجَة"
        ),
        summary: L3(
            en: "A voluntary prayer offered when one has a particular need, worldly or religious, and turns to Allah to ask for it. It may be prayed at any permitted time.",
            fr: "Une prière surérogatoire offerte lorsqu'on a un besoin particulier, mondain ou religieux, et qu'on se tourne vers Allah pour le demander. Elle peut être priée à tout moment permis.",
            ar: "صَلاةٌ نافِلَةٌ تُصَلّى عِنْدَ الحاجَةِ الدُّنْيَوِيَّةِ أَوِ الدّينِيَّةِ، يَتَوَجَّهُ بِها العَبْدُ إِلى اللهِ لِطَلَبِ حاجَتِهِ. تُصَلّى في أَيِّ وَقْتٍ مُباح."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Purify and pray two rak'ah",
                    fr: "Purifiez-vous et priez deux rak'ah",
                    ar: "تَطَهَّرْ وَصَلِّ رَكْعَتَيْن"
                ),
                body: L3(
                    en: "Perform a complete wudu, then pray two rak'ah of voluntary prayer with presence of heart, reciting al-Fatiha and a surah in each.",
                    fr: "Accomplissez des ablutions complètes, puis priez deux rak'ah surérogatoires avec recueillement, en récitant al-Fatiha et une sourate dans chacune.",
                    ar: "أَحْسِنِ الوُضوءَ، ثُمَّ صَلِّ رَكْعَتَيْنِ نافِلَةً بِحُضورِ قَلْبٍ، تَقْرَأُ الفاتِحَةَ وَسورَةً في كُلِّ رَكْعَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Praise Allah and send salawat",
                    fr: "Louez Allah et priez sur le Prophète",
                    ar: "احْمَدِ اللهَ وَصَلِّ عَلى النَّبِيّ"
                ),
                body: L3(
                    en: "After the prayer, begin by praising Allah abundantly and sending blessings upon the Prophet, as this is among the causes for du'a to be answered.",
                    fr: "Après la prière, commencez par louer Allah abondamment et prier sur le Prophète, car cela fait partie des causes de l'exaucement de la du'a.",
                    ar: "بَعْدَ الصَّلاةِ، ابْدَأْ بِحَمْدِ اللهِ وَالثَّناءِ عَلَيْهِ وَالصَّلاةِ عَلى النَّبِيِّ، فَذلِكَ مِنْ أَسْبابِ إِجابَةِ الدُّعاء."
                ),
                arabic: "لَا إِلٰهَ إِلَّا اللّٰهُ الْحَلِيمُ الْكَرِيمُ، سُبْحَانَ اللّٰهِ رَبِّ الْعَرْشِ الْعَظِيمِ، الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ.",
                translit: "Lā ilāha illā-llāhu al-Ḥalīmu al-Karīm, subḥāna-llāhi Rabbi al-ʿarshi al-ʿaẓīm, al-ḥamdu lillāhi Rabbi al-ʿālamīn."
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Ask Allah for your need",
                    fr: "Demandez à Allah votre besoin",
                    ar: "اسْأَلِ اللهَ حاجَتَك"
                ),
                body: L3(
                    en: "Then ask Allah clearly and earnestly for your specific need, with certainty that He hears and answers. You may repeat and insist in your supplication.",
                    fr: "Demandez ensuite à Allah clairement et avec ferveur votre besoin précis, avec la certitude qu'Il entend et exauce. Vous pouvez répéter et insister dans votre invocation.",
                    ar: "ثُمَّ اسْأَلِ اللهَ حاجَتَكَ المُعَيَّنَةَ بِوُضوحٍ وَإِلْحاحٍ، مُوقِنًا بِأَنَّهُ يَسْمَعُ وَيُجيبُ. وَلَكَ أَنْ تُكَرِّرَ وَتُلِحَّ في الدُّعاء."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Trust Allah and be patient",
                    fr: "Placez votre confiance en Allah et patientez",
                    ar: "تَوَكَّلْ وَاصْبِر"
                ),
                body: L3(
                    en: "Conclude with trust in Allah's wisdom, knowing He answers in the way that is best. Do not be hasty; persist in du'a and continue taking lawful means toward your need.",
                    fr: "Concluez en plaçant votre confiance dans la sagesse d'Allah, sachant qu'Il exauce de la meilleure manière. Ne soyez pas pressé ; persévérez dans la du'a et continuez à prendre les moyens licites vers votre besoin.",
                    ar: "اخْتِمْ بِالتَّوَكُّلِ عَلى حِكْمَةِ اللهِ، مُوقِنًا أَنَّهُ يُجيبُ بِما هُوَ خَيْرٌ. وَلا تَسْتَعْجِلْ؛ داوِمْ عَلى الدُّعاءِ وَاسْتَمِرَّ في الأَخْذِ بِالأَسْبابِ المَشْروعَة."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "qasr",
        section: "types",
        icon: "airplane",
        title: L3(
            en: "Qasr (Shortening while Traveling)",
            fr: "Qasr (Raccourcir en voyage)",
            ar: "القَصْر (قَصْرُ الصَّلاةِ في السَّفَر)"
        ),
        summary: L3(
            en: "A concession by which a traveler shortens the four-rak'ah prayers (Dhuhr, Asr, Isha) to two rak'ah. It applies once one has left one's town on a genuine journey.",
            fr: "Une facilité par laquelle le voyageur raccourcit les prières de quatre rak'ah (Dhuhr, Asr, Isha) à deux rak'ah. Elle s'applique dès qu'on a quitté sa ville pour un véritable voyage.",
            ar: "رُخْصَةٌ يَقْصُرُ بِها المُسافِرُ الصَّلَواتِ الرُّباعِيَّةَ (الظُّهْرَ وَالعَصْرَ وَالعِشاءَ) إِلى رَكْعَتَيْنِ. وَتَبْدَأُ بِمُفارَقَةِ عُمْرانِ بَلَدِهِ في سَفَرٍ حَقيقِيّ."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Confirm you are a traveler",
                    fr: "Confirmez que vous êtes voyageur",
                    ar: "تَحَقَّقْ مِنْ كَوْنِكَ مُسافِرًا"
                ),
                body: L3(
                    en: "Qasr begins once you leave the built-up area of your town on a real journey (the majority hold roughly 80 km or more). It continues as long as you are traveling and have not settled permanently.",
                    fr: "Le Qasr commence dès que vous quittez la zone urbanisée de votre ville pour un vrai voyage (la majorité retient environ 80 km ou plus). Il continue tant que vous voyagez et ne vous êtes pas établi de manière permanente.",
                    ar: "يَبْدَأُ القَصْرُ بِمُجَرَّدِ مُفارَقَتِكَ عُمْرانَ بَلَدِكَ في سَفَرٍ حَقيقِيٍّ (وَالجُمْهورُ عَلى نَحْوِ ٨٠ كم فَأَكْثَرَ). وَيَسْتَمِرُّ ما دُمْتَ مُسافِرًا لَمْ تُقِمْ إِقامَةً دائِمَة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Shorten the four-rak'ah prayers",
                    fr: "Raccourcissez les prières de quatre rak'ah",
                    ar: "اقْصُرِ الصَّلَواتِ الرُّباعِيَّة"
                ),
                body: L3(
                    en: "Pray Dhuhr, Asr and Isha as two rak'ah each instead of four. Fajr (two rak'ah) and Maghrib (three rak'ah) are never shortened and remain as they are.",
                    fr: "Priez le Dhuhr, l'Asr et l'Isha à deux rak'ah chacune au lieu de quatre. Le Fajr (deux rak'ah) et le Maghrib (trois rak'ah) ne sont jamais raccourcis et restent inchangés.",
                    ar: "صَلِّ الظُّهْرَ وَالعَصْرَ وَالعِشاءَ رَكْعَتَيْنِ بَدَلًا مِنْ أَرْبَعٍ. أَمّا الفَجْرُ (رَكْعَتانِ) وَالمَغْرِبُ (ثَلاثٌ) فَلا يُقْصَرانِ وَيَبْقَيانِ عَلى حالِهِما."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Combine prayers if needed",
                    fr: "Regroupez les prières si nécessaire",
                    ar: "اجْمَعْ عِنْدَ الحاجَة"
                ),
                body: L3(
                    en: "When traveling you may also combine Dhuhr with Asr, and Maghrib with Isha, at the time of either, which eases prayer while on the move. Combining is a separate concession from shortening.",
                    fr: "En voyage, vous pouvez aussi regrouper le Dhuhr avec l'Asr, et le Maghrib avec l'Isha, à l'heure de l'une des deux, ce qui facilite la prière en déplacement. Le regroupement est une facilité distincte du raccourcissement.",
                    ar: "لَكَ في السَّفَرِ أَيْضًا أَنْ تَجْمَعَ الظُّهْرَ مَعَ العَصْرِ، وَالمَغْرِبَ مَعَ العِشاءِ، في وَقْتِ إِحْداهُما، تَيْسيرًا حالَ التَّنَقُّلِ. وَالجَمْعُ رُخْصَةٌ مُسْتَقِلَّةٌ عَنِ القَصْر."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "When to pray in full",
                    fr: "Quand prier au complet",
                    ar: "مَتى تُتِمُّ الصَّلاة"
                ),
                body: L3(
                    en: "If you pray behind a resident imam, follow him and complete four rak'ah. Likewise, once you return home or settle, you resume praying in full.",
                    fr: "Si vous priez derrière un imam résident, suivez-le et complétez quatre rak'ah. De même, une fois rentré chez vous ou établi, vous reprenez la prière au complet.",
                    ar: "إِنْ صَلَّيْتَ خَلْفَ إِمامٍ مُقيمٍ فَاتْبَعْهُ وَأَتِمَّ أَرْبَعًا. وَكَذلِكَ إِذا رَجَعْتَ إِلى بَلَدِكَ أَوْ أَقَمْتَ، عُدْتَ إِلى الإِتْمام."
                ),
                arabic: "",
                translit: ""
            )
        ]
    )
]
