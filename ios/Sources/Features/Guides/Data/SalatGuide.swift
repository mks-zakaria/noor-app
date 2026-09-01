import Foundation
let salatGuides: [Guide] = [
    Guide(
        id: "how-to-pray",
        section: "prayer",
        icon: "figure.stand",
        title: L3(
            en: "How to Pray (Salah)",
            fr: "Comment prier (Salât)",
            ar: "كيفية أداء الصلاة"
        ),
        summary: L3(
            en: "A step-by-step walkthrough of one unit (rak'ah) and how to complete a two-rak'ah prayer, with the Arabic recitations and their meanings.",
            fr: "Un guide étape par étape d'une unité (rak'ah) et de la manière d'accomplir une prière de deux rak'ahs, avec les récitations arabes et leur signification.",
            ar: "شرح خطوة بخطوة لركعة واحدة وكيفية إتمام صلاة من ركعتين، مع الأذكار العربية ومعانيها."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Intention (Niyyah) and facing the Qibla",
                    fr: "L'intention (Niyyah) et l'orientation vers la Qibla",
                    ar: "النية واستقبال القبلة"
                ),
                body: L3(
                    en: "Ensure you are in a state of ablution (wudu), stand facing the Qibla (the direction of the Ka'bah in Makkah), and form the intention in your heart for the prayer you are about to perform. The intention is a resolve of the heart and is not spoken aloud.",
                    fr: "Assurez-vous d'être en état d'ablution (woudou), tenez-vous face à la Qibla (la direction de la Ka'ba à La Mecque), et formez dans votre cœur l'intention de la prière que vous allez accomplir. L'intention est une résolution du cœur et ne se prononce pas à voix haute.",
                    ar: "تأكد من أنك على وضوء، وقف مستقبلاً القبلة (جهة الكعبة في مكة)، واعقد النية في قلبك للصلاة التي تريد أداءها. والنية محلها القلب ولا تُلفظ باللسان."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Opening Takbir (Takbirat al-Ihram)",
                    fr: "Le Takbir d'ouverture (Takbîrat al-Ihrâm)",
                    ar: "تكبيرة الإحرام"
                ),
                body: L3(
                    en: "Raise both hands to the level of your shoulders or ears and say \"Allāhu akbar\" (Allah is the Greatest). This begins the prayer. Then place your right hand over your left upon your chest.",
                    fr: "Levez les deux mains au niveau des épaules ou des oreilles et dites \"Allâhou akbar\" (Allah est le plus Grand). Cela commence la prière. Placez ensuite la main droite sur la gauche sur la poitrine.",
                    ar: "ارفع يديك إلى مستوى منكبيك أو أذنيك وقل \"اللَّهُ أَكْبَر\" (الله أكبر). بهذا تبدأ الصلاة. ثم ضع يدك اليمنى على اليسرى على صدرك."
                ),
                arabic: "اللَّهُ أَكْبَر",
                translit: "Allāhu akbar"
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Opening supplication (Du'a al-Istiftah)",
                    fr: "L'invocation d'ouverture (Du'â al-Istiftâh)",
                    ar: "دعاء الاستفتاح"
                ),
                body: L3(
                    en: "Recite the opening supplication quietly: \"How perfect You are O Allah, and I praise You. Blessed is Your Name, and exalted is Your Majesty. There is no god worthy of worship except You.\"",
                    fr: "Récitez à voix basse l'invocation d'ouverture : \"Gloire et pureté à Toi, ô Allah, et à Toi la louange. Béni soit Ton Nom, et exaltée soit Ta Majesté. Il n'y a de divinité digne d'adoration que Toi.\"",
                    ar: "اقرأ دعاء الاستفتاح سرًّا: \"سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَٰهَ غَيْرُكَ\"."
                ),
                arabic: "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَٰهَ غَيْرُكَ",
                translit: "Subḥānaka-llāhumma wa bi-ḥamdika, wa tabāraka-smuka, wa taʿālā jadduka, wa lā ilāha ghayruk"
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Recite Surah al-Fatiha",
                    fr: "Réciter la sourate al-Fâtiha",
                    ar: "قراءة سورة الفاتحة"
                ),
                body: L3(
                    en: "Seek refuge in Allah, then recite Surah al-Fatiha, the opening chapter of the Qur'an. It is an essential pillar recited in every rak'ah. Its meaning: \"In the name of Allah, the Most Gracious, the Most Merciful. All praise is due to Allah, Lord of all the worlds...\"",
                    fr: "Cherchez refuge auprès d'Allah, puis récitez la sourate al-Fâtiha, le chapitre d'ouverture du Coran. C'est un pilier essentiel récité dans chaque rak'ah. Sa signification : \"Au nom d'Allah, le Tout Miséricordieux, le Très Miséricordieux. Louange à Allah, Seigneur de l'univers...\"",
                    ar: "استعذ بالله ثم اقرأ سورة الفاتحة، وهي فاتحة القرآن، وركن لا تصح الصلاة إلا بها في كل ركعة."
                ),
                arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ۝ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمَٰنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
                translit: "Bismi-llāhi-r-raḥmāni-r-raḥīm. Al-ḥamdu lillāhi rabbi-l-ʿālamīn. Ar-raḥmāni-r-raḥīm. Māliki yawmi-d-dīn. Iyyāka naʿbudu wa iyyāka nastaʿīn. Ihdinā-ṣ-ṣirāṭa-l-mustaqīm. Ṣirāṭa-lladhīna anʿamta ʿalayhim ghayri-l-maghḍūbi ʿalayhim wa lā-ḍ-ḍāllīn"
            ),
            GuideStep(
                id: 5,
                title: L3(
                    en: "Recite another Surah",
                    fr: "Réciter une autre sourate",
                    ar: "قراءة سورة أخرى"
                ),
                body: L3(
                    en: "After al-Fatiha, recite another surah or some verses of the Qur'an. A short one such as Surah al-Ikhlas is commonly recited: \"Say, He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born, nor is there to Him any equivalent.\"",
                    fr: "Après al-Fâtiha, récitez une autre sourate ou quelques versets du Coran. Une courte comme la sourate al-Ikhlâs est souvent récitée : \"Dis : Il est Allah, l'Unique. Allah, le Seul à être imploré. Il n'a jamais engendré, n'a pas été engendré, et nul n'est égal à Lui.\"",
                    ar: "بعد الفاتحة اقرأ سورة أخرى أو بعض الآيات. ومن أيسر ذلك قراءة سورة الإخلاص."
                ),
                arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
                translit: "Qul huwa-llāhu aḥad. Allāhu-ṣ-ṣamad. Lam yalid wa lam yūlad. Wa lam yakun lahu kufuwan aḥad"
            ),
            GuideStep(
                id: 6,
                title: L3(
                    en: "Bowing (Ruku)",
                    fr: "L'inclinaison (Roukou')",
                    ar: "الركوع"
                ),
                body: L3(
                    en: "Say \"Allāhu akbar\" and bow, placing your hands on your knees with your back straight and level. In this position say three times: \"Glory be to my Lord, the Most Great.\"",
                    fr: "Dites \"Allâhou akbar\" et inclinez-vous, en posant les mains sur les genoux, le dos droit et à l'horizontale. Dans cette position, dites trois fois : \"Gloire à mon Seigneur, le Très Grand.\"",
                    ar: "قل \"اللَّهُ أَكْبَر\" واركع واضعًا يديك على ركبتيك مع تسوية ظهرك، وقل في ركوعك ثلاثًا: \"سُبْحَانَ رَبِّيَ الْعَظِيم\"."
                ),
                arabic: "سُبْحَانَ رَبِّيَ الْعَظِيم",
                translit: "Subḥāna rabbiya-l-ʿaẓīm"
            ),
            GuideStep(
                id: 7,
                title: L3(
                    en: "Rising from Ruku",
                    fr: "Se relever du Roukou'",
                    ar: "الرفع من الركوع"
                ),
                body: L3(
                    en: "Rise from bowing to stand upright saying \"Allah hears the one who praises Him,\" and once standing say \"Our Lord, and to You belongs all praise.\"",
                    fr: "Relevez-vous de l'inclinaison en vous tenant droit en disant \"Allah entend celui qui Le loue\", puis une fois debout dites \"Notre Seigneur, à Toi la louange.\"",
                    ar: "ارفع رأسك من الركوع قائمًا معتدلاً قائلاً \"سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ\"، وإذا استويت قائمًا قل \"رَبَّنَا وَلَكَ الْحَمْد\"."
                ),
                arabic: "سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ، رَبَّنَا وَلَكَ الْحَمْد",
                translit: "Samiʿa-llāhu liman ḥamidah, Rabbanā wa laka-l-ḥamd"
            ),
            GuideStep(
                id: 8,
                title: L3(
                    en: "First Prostration (Sujud)",
                    fr: "La première prosternation (Soujoud)",
                    ar: "السجود الأول"
                ),
                body: L3(
                    en: "Say \"Allāhu akbar\" and prostrate with seven limbs touching the ground: the forehead and nose, both palms, both knees, and the toes of both feet. In this position say three times: \"Glory be to my Lord, the Most High.\"",
                    fr: "Dites \"Allâhou akbar\" et prosternez-vous avec sept membres touchant le sol : le front et le nez, les deux paumes, les deux genoux et les orteils des deux pieds. Dans cette position, dites trois fois : \"Gloire à mon Seigneur, le Très-Haut.\"",
                    ar: "قل \"اللَّهُ أَكْبَر\" واسجد على سبعة أعضاء: الجبهة والأنف، والكفين، والركبتين، وأطراف القدمين، وقل في سجودك ثلاثًا: \"سُبْحَانَ رَبِّيَ الْأَعْلَى\"."
                ),
                arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى",
                translit: "Subḥāna rabbiya-l-aʿlā"
            ),
            GuideStep(
                id: 9,
                title: L3(
                    en: "Sitting between the two prostrations",
                    fr: "S'asseoir entre les deux prosternations",
                    ar: "الجلوس بين السجدتين"
                ),
                body: L3(
                    en: "Say \"Allāhu akbar,\" rise and sit calmly, then say: \"My Lord, forgive me.\" It is good to say it more than once.",
                    fr: "Dites \"Allâhou akbar\", relevez-vous et asseyez-vous calmement, puis dites : \"Mon Seigneur, pardonne-moi.\" Il est bon de le répéter plus d'une fois.",
                    ar: "قل \"اللَّهُ أَكْبَر\" وارفع رأسك واجلس مطمئنًّا، وقل: \"رَبِّ اغْفِرْ لِي\"، ويُستحب تكرارها."
                ),
                arabic: "رَبِّ اغْفِرْ لِي",
                translit: "Rabbi-ghfir lī"
            ),
            GuideStep(
                id: 10,
                title: L3(
                    en: "Second Prostration (Sujud)",
                    fr: "La seconde prosternation (Soujoud)",
                    ar: "السجود الثاني"
                ),
                body: L3(
                    en: "Say \"Allāhu akbar\" and prostrate a second time exactly as before, saying three times: \"Glory be to my Lord, the Most High.\" This completes one rak'ah. Rise saying \"Allāhu akbar\" to perform the second rak'ah the same way (Fatiha, a surah, ruku, and two prostrations).",
                    fr: "Dites \"Allâhou akbar\" et prosternez-vous une seconde fois exactement comme avant, en disant trois fois : \"Gloire à mon Seigneur, le Très-Haut.\" Cela achève une rak'ah. Relevez-vous en disant \"Allâhou akbar\" pour accomplir la seconde rak'ah de la même façon (Fâtiha, une sourate, roukou' et deux prosternations).",
                    ar: "قل \"اللَّهُ أَكْبَر\" واسجد السجدة الثانية كالأولى قائلاً ثلاثًا: \"سُبْحَانَ رَبِّيَ الْأَعْلَى\". بهذا تتم ركعة واحدة. ثم قم قائلاً \"اللَّهُ أَكْبَر\" لتؤدي الركعة الثانية بمثلها (الفاتحة وسورة وركوع وسجدتين)."
                ),
                arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى",
                translit: "Subḥāna rabbiya-l-aʿlā"
            ),
            GuideStep(
                id: 11,
                title: L3(
                    en: "Tashahhud and Salawat",
                    fr: "Le Tashahhud et la Salât sur le Prophète",
                    ar: "التشهد والصلاة على النبي"
                ),
                body: L3(
                    en: "After the second prostration of the final rak'ah, sit and recite the Tashahhud: \"All greetings, prayers and good things are for Allah. Peace be upon you O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no god but Allah, and I bear witness that Muhammad is His servant and Messenger.\" Then send blessings upon the Prophet (Salawat): \"O Allah, send Your grace upon Muhammad and the family of Muhammad, as You sent it upon Ibrahim and the family of Ibrahim; You are Praiseworthy, Most Glorious...\"",
                    fr: "Après la seconde prosternation de la dernière rak'ah, asseyez-vous et récitez le Tashahhud : \"Les salutations, les prières et les bonnes choses sont à Allah. Que la paix soit sur toi, ô Prophète, ainsi que la miséricorde d'Allah et Ses bénédictions. Que la paix soit sur nous et sur les serviteurs vertueux d'Allah. J'atteste qu'il n'y a de divinité qu'Allah, et j'atteste que Muhammad est Son serviteur et Son Messager.\" Puis priez sur le Prophète (Salât) : \"Ô Allah, prie sur Muhammad et sur la famille de Muhammad, comme Tu as prié sur Ibrahim et sur la famille d'Ibrahim ; Tu es digne de louange et de gloire...\"",
                    ar: "بعد السجدة الثانية من الركعة الأخيرة، اجلس واقرأ التشهد، ثم صلِّ على النبي صلى الله عليه وسلم بالصلاة الإبراهيمية."
                ),
                arabic: "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ، أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ، وَبَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ",
                translit: "At-taḥiyyātu lillāhi wa-ṣ-ṣalawātu wa-ṭ-ṭayyibāt, as-salāmu ʿalayka ayyuha-n-nabiyyu wa raḥmatu-llāhi wa barakātuh, as-salāmu ʿalaynā wa ʿalā ʿibādi-llāhi-ṣ-ṣāliḥīn, ash-hadu an lā ilāha illa-llāh wa ash-hadu anna Muḥammadan ʿabduhu wa rasūluh. Allāhumma ṣalli ʿalā Muḥammad wa ʿalā āli Muḥammad kamā ṣallayta ʿalā Ibrāhīm wa ʿalā āli Ibrāhīm innaka ḥamīdun majīd, wa bārik ʿalā Muḥammad wa ʿalā āli Muḥammad kamā bārakta ʿalā Ibrāhīm wa ʿalā āli Ibrāhīm innaka ḥamīdun majīd"
            ),
            GuideStep(
                id: 12,
                title: L3(
                    en: "Concluding Salutation (Taslim)",
                    fr: "La salutation finale (Taslîm)",
                    ar: "التسليم"
                ),
                body: L3(
                    en: "End the prayer by turning your face to the right saying \"Peace and the mercy of Allah be upon you,\" then to the left saying the same. This completes the prayer.",
                    fr: "Terminez la prière en tournant le visage vers la droite en disant \"Que la paix et la miséricorde d'Allah soient sur vous\", puis vers la gauche en disant la même chose. Cela achève la prière.",
                    ar: "اختم الصلاة بالتسليم عن يمينك قائلاً \"السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ\"، ثم عن يسارك بمثلها. بهذا تتم الصلاة."
                ),
                arabic: "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ",
                translit: "As-salāmu ʿalaykum wa raḥmatu-llāh"
            )
        ]
    ),
    Guide(
        id: "rakah-counts",
        section: "prayer",
        icon: "list.number",
        title: L3(
            en: "Units (Rak'ahs) of each prayer",
            fr: "Les unités (Rak'ahs) de chaque prière",
            ar: "عدد ركعات كل صلاة"
        ),
        summary: L3(
            en: "The number of obligatory (fard) units in each of the five daily prayers, with a note on the confirmed sunnah units associated with them.",
            fr: "Le nombre d'unités obligatoires (fard) dans chacune des cinq prières quotidiennes, avec une note sur les unités surérogatoires confirmées (sunnah) qui les accompagnent.",
            ar: "عدد الركعات المفروضة في كل صلاة من الصلوات الخمس، مع الإشارة إلى السنن الرواتب المؤكدة المرتبطة بها."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Fajr (Dawn) — 2 fard",
                    fr: "Fajr (Aube) — 2 fard",
                    ar: "الفجر — ركعتان فرض"
                ),
                body: L3(
                    en: "The dawn prayer is two obligatory rak'ahs, recited aloud. There is a strongly confirmed sunnah of two rak'ahs prayed before the fard, which the Prophet never abandoned.",
                    fr: "La prière de l'aube compte deux rak'ahs obligatoires, récitées à voix haute. Elle est précédée d'une sunnah fortement confirmée de deux rak'ahs, que le Prophète n'abandonnait jamais.",
                    ar: "صلاة الفجر ركعتان فرض يُجهر فيهما بالقراءة، ويُسن قبلها ركعتان راتبة مؤكدة كان النبي صلى الله عليه وسلم يحافظ عليها."
                ),
                arabic: "الفَجْر",
                translit: "Al-Fajr"
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Dhuhr (Noon) — 4 fard",
                    fr: "Dhuhr (Midi) — 4 fard",
                    ar: "الظهر — أربع ركعات فرض"
                ),
                body: L3(
                    en: "The noon prayer is four obligatory rak'ahs, recited quietly. Its confirmed sunnah is four rak'ahs before it (in sets of two) and two after it.",
                    fr: "La prière de midi compte quatre rak'ahs obligatoires, récitées à voix basse. Sa sunnah confirmée est de quatre rak'ahs avant (par groupes de deux) et deux après.",
                    ar: "صلاة الظهر أربع ركعات فرض يُسر فيها بالقراءة، وسنتها الراتبة أربع ركعات قبلها وركعتان بعدها."
                ),
                arabic: "الظُّهْر",
                translit: "Aẓ-Ẓuhr"
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Asr (Afternoon) — 4 fard",
                    fr: "Asr (Après-midi) — 4 fard",
                    ar: "العصر — أربع ركعات فرض"
                ),
                body: L3(
                    en: "The afternoon prayer is four obligatory rak'ahs, recited quietly. It has no confirmed sunnah rak'ahs attached to it, though voluntary prayer beforehand is encouraged.",
                    fr: "La prière de l'après-midi compte quatre rak'ahs obligatoires, récitées à voix basse. Elle n'a pas de sunnah confirmée, bien qu'une prière surérogatoire avant soit encouragée.",
                    ar: "صلاة العصر أربع ركعات فرض يُسر فيها بالقراءة، وليس لها سنة راتبة مؤكدة، وإن استُحب التنفل قبلها."
                ),
                arabic: "العَصْر",
                translit: "Al-ʿAṣr"
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Maghrib (Sunset) — 3 fard",
                    fr: "Maghrib (Coucher du soleil) — 3 fard",
                    ar: "المغرب — ثلاث ركعات فرض"
                ),
                body: L3(
                    en: "The sunset prayer is three obligatory rak'ahs; the first two are recited aloud and the third quietly. Its confirmed sunnah is two rak'ahs prayed after it.",
                    fr: "La prière du coucher du soleil compte trois rak'ahs obligatoires ; les deux premières sont récitées à voix haute et la troisième à voix basse. Sa sunnah confirmée est de deux rak'ahs après elle.",
                    ar: "صلاة المغرب ثلاث ركعات فرض، يُجهر في الأوليين ويُسر في الثالثة، وسنتها الراتبة ركعتان بعدها."
                ),
                arabic: "المَغْرِب",
                translit: "Al-Maghrib"
            ),
            GuideStep(
                id: 5,
                title: L3(
                    en: "Isha (Night) — 4 fard",
                    fr: "Isha (Nuit) — 4 fard",
                    ar: "العشاء — أربع ركعات فرض"
                ),
                body: L3(
                    en: "The night prayer is four obligatory rak'ahs; the first two are recited aloud and the last two quietly. Its confirmed sunnah is two rak'ahs prayed after it.",
                    fr: "La prière de la nuit compte quatre rak'ahs obligatoires ; les deux premières sont récitées à voix haute et les deux dernières à voix basse. Sa sunnah confirmée est de deux rak'ahs après elle.",
                    ar: "صلاة العشاء أربع ركعات فرض، يُجهر في الأوليين ويُسر في الأخريين، وسنتها الراتبة ركعتان بعدها."
                ),
                arabic: "العِشَاء",
                translit: "Al-ʿIshāʾ"
            ),
            GuideStep(
                id: 6,
                title: L3(
                    en: "Witr after Isha",
                    fr: "Le Witr après Isha",
                    ar: "الوتر بعد العشاء"
                ),
                body: L3(
                    en: "After Isha, it is strongly recommended to pray Witr, an odd number of rak'ahs (one, three, or more) that concludes the night prayers. The minimum is a single rak'ah, and it is the last prayer prayed at night.",
                    fr: "Après Isha, il est fortement recommandé de prier le Witr, un nombre impair de rak'ahs (une, trois ou plus) qui conclut les prières de la nuit. Le minimum est d'une seule rak'ah, et c'est la dernière prière de la nuit.",
                    ar: "بعد العشاء يُسن تأكيدًا صلاة الوتر، وهي عدد فردي من الركعات (واحدة أو ثلاث أو أكثر) تختم بها صلاة الليل، وأقلها ركعة واحدة، وهي آخر صلاة الليل."
                ),
                arabic: "الوِتْر",
                translit: "Al-Witr"
            )
        ]
    )
]
