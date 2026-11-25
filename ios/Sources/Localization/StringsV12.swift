import Foundation

/// Strings added in 1.2 (Ramadan, Khatmah, Tasbih, prayer tracker, Qada, Juz,
/// search, widgets). Merged into `Strings.table`; same shape and fallback rules.
/// `%d` / `%@` placeholders are filled with `String(format:)`.
extension Strings {
    static let v12: [String: [String: String]] = [
        // Common
        "common.cancel": ["en": "Cancel", "fr": "Annuler", "ar": "إلغاء"],
        "tab.ibadah": ["en": "Ibadah", "fr": "Ibadat", "ar": "عبادات"],

        // Quran: Juz, pages, search
        "quran.search": ["en": "Search surah or ayah", "fr": "Sourate ou verset", "ar": "ابحث عن سورة أو آية"],
        "quran.juz": ["en": "Juz", "fr": "Juz", "ar": "الجزء"],
        "quran.juzList": ["en": "Juz", "fr": "Juz", "ar": "الأجزاء"],
        "quran.page": ["en": "Page", "fr": "Page", "ar": "صفحة"],
        "quran.ayahResults": ["en": "Ayahs (%d)", "fr": "Versets (%d)", "ar": "الآيات (%d)"],

        // Khatmah
        "khatmah.title": ["en": "Khatmah", "fr": "Khatma", "ar": "الختمة"],
        "khatmah.plan": ["en": "Your khatmah plan", "fr": "Votre plan de khatma", "ar": "خطة الختمة"],
        "khatmah.ramadanPlan": ["en": "Ramadan khatmah", "fr": "Khatma du Ramadan", "ar": "ختمة رمضان"],
        "khatmah.pagesOf": ["en": "%d of %d pages", "fr": "%d pages sur %d", "ar": "%d من %d صفحة"],
        "khatmah.ends": ["en": "Ends %@", "fr": "Fin le %@", "ar": "تنتهي %@"],
        "khatmah.ahead": ["en": "%d pages ahead", "fr": "%d pages d'avance", "ar": "متقدّم بـ %d صفحة"],
        "khatmah.behind": ["en": "%d pages behind", "fr": "%d pages de retard", "ar": "متأخر بـ %d صفحة"],
        "khatmah.daysLeft": ["en": "%d days left", "fr": "%d jours restants", "ar": "باقٍ %d يوم"],
        "khatmah.today": ["en": "Today's portion", "fr": "Portion du jour", "ar": "ورد اليوم"],
        "khatmah.pages": ["en": "Pages %d–%d", "fr": "Pages %d à %d", "ar": "الصفحات %d–%d"],
        "khatmah.minutes": ["en": "≈ %d min", "fr": "≈ %d min", "ar": "≈ %d دقيقة"],
        "khatmah.read": ["en": "Read now", "fr": "Lire", "ar": "اقرأ الآن"],
        "khatmah.readMore": ["en": "Keep reading", "fr": "Continuer", "ar": "واصل القراءة"],
        "khatmah.markRead": ["en": "Mark read", "fr": "Marquer lu", "ar": "تمّت القراءة"],
        "khatmah.reminder": ["en": "Daily reminder", "fr": "Rappel quotidien", "ar": "تذكير يومي"],
        "khatmah.reminderTime": ["en": "Time", "fr": "Heure", "ar": "الوقت"],
        "khatmah.reminderNeedsNotifications": [
            "en": "Turn on notifications in Settings for the reminder to arrive.",
            "fr": "Activez les notifications dans Réglages pour recevoir le rappel.",
            "ar": "فعّل الإشعارات من الإعدادات ليصلك التذكير.",
        ],
        "khatmah.setPosition": ["en": "Set where I am", "fr": "Indiquer où j'en suis", "ar": "حدّد موضعي"],
        "khatmah.cancel": ["en": "End this plan", "fr": "Arrêter ce plan", "ar": "إنهاء هذه الخطة"],
        "khatmah.emptyTitle": ["en": "Complete the Quran", "fr": "Terminer le Coran", "ar": "اختم القرآن"],
        "khatmah.emptyBody": [
            "en": "Pick a deadline and Noor splits the 604 pages into a daily portion. Your progress moves on by itself as you read.",
            "fr": "Choisissez une échéance et Noor répartit les 604 pages en une portion quotidienne. Votre progression avance d'elle-même pendant la lecture.",
            "ar": "اختر موعدًا ويقسّم نور الصفحات الـ604 إلى ورد يومي، ويتقدّم تقدّمك تلقائيًا أثناء القراءة.",
        ],
        "khatmah.start": ["en": "Start a khatmah", "fr": "Commencer une khatma", "ar": "ابدأ ختمة"],
        "khatmah.startAnother": ["en": "Start another", "fr": "En commencer une autre", "ar": "ابدأ ختمة جديدة"],
        "khatmah.startsIn": ["en": "Starts in %d days (%@)", "fr": "Commence dans %d jours (%@)", "ar": "تبدأ بعد %d يوم (%@)"],
        "khatmah.finished": [
            "en": "Khatmah complete. May Allah accept it from you.",
            "fr": "Khatma terminée. Qu'Allah l'accepte de vous.",
            "ar": "تمّت الختمة، تقبّل الله منك.",
        ],
        "khatmah.completions": ["en": "Completed: %d", "fr": "Terminées : %d", "ar": "الختمات المكتملة: %d"],
        "khatmah.preset.ramadan": ["en": "During Ramadan %d", "fr": "Pendant le Ramadan %d", "ar": "خلال رمضان %d"],
        "khatmah.preset.ramadanFooter": [
            "en": "Finishes on the last day of Ramadan. Made before Ramadan, it waits for the 1st.",
            "fr": "Se termine le dernier jour du Ramadan. Créé avant, il commence le 1er.",
            "ar": "تنتهي في آخر يوم من رمضان، وإن أُنشئت قبله تبدأ في أوله.",
        ],
        "khatmah.preset.days": ["en": "By number of days", "fr": "En nombre de jours", "ar": "بعدد الأيام"],
        "khatmah.preset.inDays": ["en": "%d days · about %d pages a day", "fr": "%d jours · environ %d pages par jour", "ar": "%d يومًا · نحو %d صفحة يوميًا"],
        "khatmah.preset.custom": ["en": "Custom date", "fr": "Date personnalisée", "ar": "تاريخ مخصص"],
        "khatmah.preset.until": ["en": "Finish by", "fr": "Terminer le", "ar": "الانتهاء في"],

        // Ramadan
        "ramadan.title": ["en": "Ramadan", "fr": "Ramadan", "ar": "رمضان"],
        "ramadan.titleYear": ["en": "Ramadan %d", "fr": "Ramadan %d", "ar": "رمضان %d"],
        "ramadan.dayOf": ["en": "Ramadan · day %d of %d", "fr": "Ramadan · jour %d sur %d", "ar": "رمضان · اليوم %d من %d"],
        "ramadan.inDays": ["en": "In %d days", "fr": "Dans %d jours", "ar": "بعد %d يومًا"],
        "ramadan.startsTomorrow": ["en": "Starts tomorrow", "fr": "Commence demain", "ar": "يبدأ غدًا"],
        "ramadan.expected": [
            "en": "Expected %@. Adjust the Hijri day in Settings to match your country.",
            "fr": "Prévu le %@. Ajustez le jour hégirien dans Réglages selon votre pays.",
            "ar": "المتوقع %@. عدّل اليوم الهجري في الإعدادات حسب بلدك.",
        ],
        "ramadan.iftarIn": ["en": "Iftar in", "fr": "Iftar dans", "ar": "الإفطار بعد"],
        "ramadan.suhoorEndsIn": ["en": "Suhoor ends in", "fr": "Fin du suhur dans", "ar": "ينتهي السحور بعد"],
        "ramadan.iftar": ["en": "Iftar", "fr": "Iftar", "ar": "الإفطار"],
        "ramadan.suhoorEnds": ["en": "Suhoor ends", "fr": "Fin du suhur", "ar": "نهاية السحور"],
        "ramadan.imsak": ["en": "Imsak", "fr": "Imsak", "ar": "الإمساك"],
        "ramadan.day": ["en": "Day", "fr": "Jour", "ar": "اليوم"],
        "ramadan.fasts": ["en": "My fasts", "fr": "Mes jeûnes", "ar": "صيامي"],
        "ramadan.fastsHint": [
            "en": "Tap a day: fasted, missed (added to Qada), excused.",
            "fr": "Touchez un jour : jeûné, manqué (ajouté aux rattrapages), excusé.",
            "ar": "اضغط على اليوم: صمت، فاتني (يُضاف إلى القضاء)، معذور.",
        ],
        "ramadan.taraweeh": ["en": "Taraweeh tonight", "fr": "Tarawih ce soir", "ar": "التراويح الليلة"],
        "ramadan.khatmah": ["en": "Complete the Quran this Ramadan", "fr": "Terminer le Coran ce Ramadan", "ar": "اختم القرآن في رمضان"],
        "ramadan.khatmahBody": [
            "en": "A daily portion that ends with the month.",
            "fr": "Une portion par jour qui se termine avec le mois.",
            "ar": "ورد يومي ينتهي بانتهاء الشهر.",
        ],
        "ramadan.qadr": ["en": "Laylat al-Qadr", "fr": "Laylat al-Qadr", "ar": "ليلة القدر"],
        "ramadan.qadrBody": [
            "en": "Seek it in the odd nights of the last ten. Next: night %d, beginning at maghrib the evening before.",
            "fr": "Recherchez-la dans les nuits impaires des dix dernières. Prochaine : nuit %d, qui commence au maghrib la veille.",
            "ar": "تحرَّوها في الوتر من العشر الأواخر. القادمة: ليلة %d، وتبدأ من مغرب اليوم الذي قبلها.",
        ],
        "ramadan.duas": ["en": "Du'as for fasting", "fr": "Invocations du jeûne", "ar": "أدعية الصيام"],
        "ramadan.timetable": ["en": "Timetable · Ramadan %d", "fr": "Horaires · Ramadan %d", "ar": "إمساكية رمضان %d"],
        "ramadan.timetableFooter": [
            "en": "Imsak is shown %d min before Fajr. Fasting begins at Fajr; times follow your calculation method.",
            "fr": "L'imsak est affiché %d min avant le Fajr. Le jeûne commence au Fajr ; horaires selon votre méthode de calcul.",
            "ar": "الإمساك قبل الفجر بـ %d دقيقة، ويبدأ الصيام عند الفجر. الأوقات حسب طريقة الحساب المختارة.",
        ],
        "ramadan.needsLocation": [
            "en": "Add your location on the Prayer tab to see suhoor and iftar times.",
            "fr": "Ajoutez votre position dans l'onglet Prière pour voir les heures du suhur et de l'iftar.",
            "ar": "أضف موقعك من تبويب الصلاة لعرض أوقات السحور والإفطار.",
        ],
        "ramadan.settings": ["en": "Ramadan alerts and Imsak", "fr": "Alertes du Ramadan et imsak", "ar": "تنبيهات رمضان والإمساك"],
        "ramadan.shawwal": ["en": "Six days of Shawwal", "fr": "Six jours de Chawwal", "ar": "ستّ من شوال"],
        "ramadan.shawwalShort": [
            "en": "Track your six fasts of Shawwal.",
            "fr": "Suivez vos six jeûnes de Chawwal.",
            "ar": "تابع صيام الست من شوال.",
        ],
        "ramadan.shawwalBody": [
            "en": "Whoever fasts Ramadan then follows it with six days of Shawwal, it is as if they fasted the whole year.",
            "fr": "Celui qui jeûne le Ramadan puis le fait suivre de six jours de Chawwal, c'est comme s'il avait jeûné toute l'année.",
            "ar": "مَن صام رمضان ثم أتبعه ستًّا من شوال كان كصيام الدهر.",
        ],
        "ramadan.eidMubarak": ["en": "Eid Mubarak!", "fr": "Aïd Moubarak !", "ar": "عيد مبارك!"],
        "fast.fasted": ["en": "Fasted", "fr": "Jeûné", "ar": "صمت"],
        "fast.missed": ["en": "Missed", "fr": "Manqué", "ar": "فاتني"],
        "fast.excused": ["en": "Excused", "fr": "Excusé", "ar": "معذور"],

        // Prayer tracker and Qada
        "tracker.today": ["en": "Today's prayers", "fr": "Prières du jour", "ar": "صلوات اليوم"],
        "tracker.hint": [
            "en": "Tap to mark a prayer as prayed. Touch and hold for late or missed.",
            "fr": "Touchez pour marquer une prière comme faite. Maintenez pour « en retard » ou « manquée ».",
            "ar": "اضغط لتسجيل الصلاة، واضغط مطولًا لتسجيلها متأخرة أو فائتة.",
        ],
        "tracker.onTime": ["en": "On time", "fr": "À l'heure", "ar": "في وقتها"],
        "tracker.late": ["en": "Late", "fr": "En retard", "ar": "متأخرة"],
        "tracker.missed": ["en": "Missed", "fr": "Manquée", "ar": "فائتة"],
        "tracker.clear": ["en": "Clear", "fr": "Effacer", "ar": "مسح"],
        "tracker.notLogged": ["en": "not logged", "fr": "non notée", "ar": "غير مسجلة"],
        "tracker.streak": ["en": "%d-day streak", "fr": "Série de %d jours", "ar": "%d يوم متتالٍ"],
        "tracker.last7": ["en": "Last 7 days", "fr": "7 derniers jours", "ar": "آخر 7 أيام"],
        "qada.title": ["en": "Qada (make-up)", "fr": "Rattrapages (qada)", "ar": "القضاء"],
        "qada.summary": ["en": "%d prayers · %d fasts to make up", "fr": "%d prières · %d jeûnes à rattraper", "ar": "%d صلاة · %d يوم صيام للقضاء"],
        "qada.prayers": ["en": "Prayers owed", "fr": "Prières à rattraper", "ar": "صلوات للقضاء"],
        "qada.prayersFooter": [
            "en": "A prayer marked missed in the tracker is added here. Use − when you make one up.",
            "fr": "Une prière marquée manquée est ajoutée ici. Utilisez − quand vous la rattrapez.",
            "ar": "تُضاف هنا كل صلاة سُجّلت فائتة. اضغط − عند قضائها.",
        ],
        "qada.fasts": ["en": "Fasts owed", "fr": "Jeûnes à rattraper", "ar": "أيام صيام للقضاء"],
        "qada.fastsFooter": [
            "en": "Days marked missed in the Ramadan tracker are added here.",
            "fr": "Les jours marqués manqués dans le suivi du Ramadan sont ajoutés ici.",
            "ar": "تُضاف هنا الأيام المسجّلة «فاتني» في متابعة رمضان.",
        ],

        // Tasbih
        "tasbih.title": ["en": "Tasbih", "fr": "Tasbih", "ar": "المسبحة"],
        "tasbih.choose": ["en": "Choose a dhikr", "fr": "Choisir un dhikr", "ar": "اختر الذكر"],
        "tasbih.tap": ["en": "Tap anywhere on the circle", "fr": "Touchez le cercle", "ar": "اضغط على الدائرة"],
        "tasbih.count": ["en": "Count", "fr": "Compter", "ar": "عدّ"],
        "tasbih.free": ["en": "free count", "fr": "compteur libre", "ar": "عدّ حر"],
        "tasbih.reset": ["en": "Reset count", "fr": "Remettre à zéro", "ar": "تصفير العداد"],
        "tasbih.today": ["en": "Today", "fr": "Aujourd'hui", "ar": "اليوم"],
        "tasbih.rounds": ["en": "Rounds", "fr": "Tours", "ar": "الدورات"],
        "tasbih.lifetime": ["en": "All time", "fr": "Au total", "ar": "الإجمالي"],
        "tasbih.controlsHint": [
            "en": "Count without opening Noor: add the Tasbih control to Control Center or the Action Button, or the Tasbih widget to your Home Screen.",
            "fr": "Comptez sans ouvrir Noor : ajoutez la commande Tasbih au Centre de contrôle ou au bouton Action, ou le widget Tasbih à l'écran d'accueil.",
            "ar": "سبّح دون فتح نور: أضف أداة المسبحة إلى مركز التحكم أو زر الإجراء، أو ودجت المسبحة إلى الشاشة الرئيسية.",
        ],

        // Notifications
        "notif.prayedAction": ["en": "Prayed ✓", "fr": "Priée ✓", "ar": "صلّيت ✓"],
        "notif.iftarTitle": ["en": "Iftar time — Maghrib", "fr": "C'est l'heure de l'iftar — Maghrib", "ar": "حان وقت الإفطار — المغرب"],
        "notif.iftarBody": [
            "en": "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ — The thirst has gone, the veins are moistened, and the reward is certain, if Allah wills. (Abu Dawud)",
            "fr": "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ — La soif est partie, les veines sont humectées et la récompense est acquise, si Allah le veut. (Abu Dawud)",
            "ar": "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ (أبو داود)",
        ],
        "notif.suhoorTitle": ["en": "Suhoor 🌙", "fr": "Suhur 🌙", "ar": "السحور 🌙"],
        "notif.suhoorBody": [
            "en": "%d minutes until Fajr (%@). Eat suhoor: there is blessing in it.",
            "fr": "%d minutes avant le Fajr (%@). Prenez le suhur : il contient une bénédiction.",
            "ar": "باقٍ %d دقيقة على الفجر (%@). تسحّروا فإن في السحور بركة.",
        ],
        "notif.qadrTitle": ["en": "Tonight may be Laylat al-Qadr", "fr": "Cette nuit est peut-être Laylat al-Qadr", "ar": "لعلّ الليلة ليلة القدر"],
        "notif.qadrBody": [
            "en": "Night %d of Ramadan. اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
            "fr": "Nuit %d du Ramadan. اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
            "ar": "ليلة %d من رمضان. اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
        ],
        "notif.khatmahTitle": ["en": "Your khatmah 📖", "fr": "Votre khatma 📖", "ar": "ختمتك 📖"],
        "notif.khatmahBody": [
            "en": "Today's portion is waiting for you.",
            "fr": "La portion du jour vous attend.",
            "ar": "وِرد اليوم بانتظارك.",
        ],
        // Shown only when the scheduled alerts ran out (the app was not opened and iOS gave it
        // no background time). Neutral on purpose: no comment on the user's prayers.
        "notif.keepAliveTitle": ["en": "Keep your adhan alerts", "fr": "Gardez vos alertes d'adhan", "ar": "حافظ على تنبيهات الأذان"],
        "notif.keepAliveBody": [
            "en": "Open Noor once to schedule the next prayer alerts.",
            "fr": "Ouvrez Noor une fois pour programmer les prochaines alertes de prière.",
            "ar": "افتح نور مرة واحدة لجدولة تنبيهات الصلاة القادمة.",
        ],

        // Qibla: compass accuracy and the map fallback
        "qibla.calibrateTitle": [
            "en": "Compass needs calibrating",
            "fr": "La boussole doit être calibrée",
            "ar": "البوصلة تحتاج إلى معايرة",
        ],
        "qibla.calibrateBody": [
            "en": "It may be off by about %d°. Move your phone in a figure 8, away from metal, magnets and magnetic cases. Or check the direction on the map.",
            "fr": "Elle peut se tromper d'environ %d°. Faites un 8 avec votre téléphone, loin du métal, des aimants et des étuis magnétiques. Ou vérifiez la direction sur la carte.",
            "ar": "قد تنحرف بنحو %d°. حرّك هاتفك على شكل الرقم 8، بعيدًا عن المعادن والمغناطيس والأغطية المغناطيسية. أو تحقّق من الاتجاه على الخريطة.",
        ],
        "qibla.showMap": ["en": "Check on the map", "fr": "Vérifier sur la carte", "ar": "تحقّق على الخريطة"],
        "qibla.mapYou": ["en": "You", "fr": "Vous", "ar": "أنت"],
        "qibla.mapKaaba": ["en": "Kaaba", "fr": "Kaaba", "ar": "الكعبة"],
        "qibla.mapHint": [
            "en": "The Qibla is toward the top of the map. Use the streets and buildings around you to face it.",
            "fr": "La Qibla est vers le haut de la carte. Repérez-vous aux rues et aux bâtiments autour de vous.",
            "ar": "القبلة باتجاه أعلى الخريطة. استعن بالشوارع والمباني من حولك لتتجه إليها.",
        ],
        "qibla.mapDistance": [
            "en": "%d km to the Kaaba · %d° from North",
            "fr": "%d km jusqu'à la Kaaba · %d° depuis le Nord",
            "ar": "%d كم إلى الكعبة · %d° من الشمال",
        ],
        "qibla.mapRecenter": ["en": "Back to my position", "fr": "Revenir à ma position", "ar": "العودة إلى موقعي"],

        // Settings
        "settings.ramadanAlerts": ["en": "Ramadan alerts", "fr": "Alertes du Ramadan", "ar": "تنبيهات رمضان"],
        "settings.ramadanAlertsFooter": [
            "en": "Sent only on the days of Ramadan, at the times of your location.",
            "fr": "Envoyées uniquement pendant le Ramadan, aux horaires de votre position.",
            "ar": "تُرسل في أيام رمضان فقط، حسب أوقات موقعك.",
        ],
        "settings.suhoorReminder": ["en": "Suhoor reminder", "fr": "Rappel du suhur", "ar": "تذكير السحور"],
        "settings.suhoorLead": ["en": "Remind me", "fr": "Me prévenir", "ar": "ذكّرني"],
        "settings.minutesBefore": ["en": "%d min before Fajr", "fr": "%d min avant le Fajr", "ar": "قبل الفجر بـ %d دقيقة"],
        "settings.iftarAlert": ["en": "Iftar alert at Maghrib", "fr": "Alerte d'iftar au Maghrib", "ar": "تنبيه الإفطار عند المغرب"],
        "settings.qadrReminders": ["en": "Laylat al-Qadr reminders", "fr": "Rappels de Laylat al-Qadr", "ar": "تذكير ليلة القدر"],
        "settings.imsak": ["en": "Imsak", "fr": "Imsak", "ar": "الإمساك"],
        "settings.imsakNone": ["en": "Same as Fajr", "fr": "Identique au Fajr", "ar": "مع الفجر"],
        "settings.imsakFooter": [
            "en": "A precaution time shown before Fajr in the timetable. The fast itself begins at Fajr.",
            "fr": "Une marge de précaution affichée avant le Fajr dans les horaires. Le jeûne commence au Fajr.",
            "ar": "وقت احتياطي يظهر قبل الفجر في الإمساكية، ويبدأ الصيام عند الفجر.",
        ],
        "settings.liveActivity": ["en": "Countdown on Lock Screen", "fr": "Compte à rebours sur l'écran verrouillé", "ar": "العدّ التنازلي على شاشة القفل"],
        "settings.liveActivityFooter": [
            "en": "Shows the next prayer (suhoor and iftar in Ramadan) on the Lock Screen and in the Dynamic Island. It refreshes each time you open Noor.",
            "fr": "Affiche la prochaine prière (suhur et iftar pendant le Ramadan) sur l'écran verrouillé et dans la Dynamic Island. Mise à jour à chaque ouverture de Noor.",
            "ar": "يعرض الصلاة القادمة (والسحور والإفطار في رمضان) على شاشة القفل وفي الجزيرة الديناميكية، ويتجدد كلما فتحت نور.",
        ],

        // Widgets
        "widget.nextPrayer": ["en": "Next prayer", "fr": "Prochaine prière", "ar": "الصلاة القادمة"],
        // Apple Watch, before the iPhone has sent a location.
        "watch.openPhone": [
            "en": "Open Noor on your iPhone once to show prayer times here.",
            "fr": "Ouvrez Noor une fois sur votre iPhone pour afficher les horaires ici.",
            "ar": "افتح نور على iPhone مرة واحدة لعرض مواقيت الصلاة هنا.",
        ],
        "widget.openNoor": ["en": "Open Noor to set your location", "fr": "Ouvrez Noor pour définir votre position", "ar": "افتح نور لتحديد موقعك"],
        "widget.prayerName": ["en": "Prayer Times", "fr": "Heures de prière", "ar": "مواقيت الصلاة"],
        "widget.prayerDesc": ["en": "The next prayer and today's times.", "fr": "La prochaine prière et les horaires du jour.", "ar": "الصلاة القادمة ومواقيت اليوم."],
        "widget.tasbihName": ["en": "Tasbih", "fr": "Tasbih", "ar": "المسبحة"],
        "widget.ramadanName": ["en": "Suhoor & Iftar", "fr": "Suhur et iftar", "ar": "السحور والإفطار"],
        "widget.ramadanDesc": [
            "en": "Counts down to iftar and suhoor in Ramadan, and to Ramadan before it starts.",
            "fr": "Compte à rebours jusqu'à l'iftar et au suhur pendant le Ramadan, et jusqu'au Ramadan avant qu'il commence.",
            "ar": "عدّ تنازلي للإفطار والسحور في رمضان، ولرمضان قبل قدومه.",
        ],
        "widget.todayName": ["en": "Today's Prayers", "fr": "Prières du jour", "ar": "صلوات اليوم"],
        "widget.todayDesc": [
            "en": "All five prayer times on your Lock Screen.",
            "fr": "Les cinq heures de prière sur l'écran verrouillé.",
            "ar": "مواقيت الصلوات الخمس على شاشة القفل.",
        ],
        "widget.ramadanDay": ["en": "Day %d", "fr": "Jour %d", "ar": "اليوم %d"],
        "widget.days": ["en": "days", "fr": "jours", "ar": "يوم"],
        "widget.shawwalShort": ["en": "Shawwal", "fr": "Chawwal", "ar": "شوال"],
        // Prayer time accuracy (method by country, per-prayer offsets)
        "settings.methodAuto": ["en": "Official method for my country", "fr": "Méthode officielle de mon pays", "ar": "الطريقة الرسمية لبلدي"],
        "settings.methodAutoFooter": ["en": "Noor uses the method of your country's religious authority (Morocco: Habous, Saudi Arabia: Umm al-Qura, Egypt, Turkey: Diyanet…). Pick a method yourself if your mosque uses another.", "fr": "Noor utilise la méthode de l'autorité religieuse de votre pays (Maroc : Habous, Arabie saoudite : Umm al-Qura, Égypte, Turquie : Diyanet…). Choisissez vous-même une méthode si votre mosquée en suit une autre.", "ar": "يعتمد نور طريقة الجهة الدينية الرسمية في بلدك (المغرب: وزارة الأوقاف، السعودية: أم القرى، مصر، تركيا: الديانة…). اختر طريقة بنفسك إذا كان مسجدك يتبع غيرها."],
        "settings.habousCity": ["en": "Ministry of Habous timetable", "fr": "Horaires du ministère des Habous", "ar": "مواقيت وزارة الأوقاف"],
        "settings.adjustTimes": ["en": "Adjust times", "fr": "Ajuster les horaires", "ar": "تعديل المواقيت"],
        "settings.adjustFooter": ["en": "Add or remove minutes for each prayer so Noor matches your local mosque exactly. The adhan, widgets and Lock Screen use the adjusted times.", "fr": "Ajoutez ou retirez des minutes pour chaque prière afin que Noor corresponde exactement à votre mosquée. L'adhan, les widgets et l'écran verrouillé utilisent les horaires ajustés.", "ar": "أضف أو أنقص دقائق لكل صلاة ليطابق نور مسجدك تمامًا. يعتمد الأذان والودجات وشاشة القفل على المواقيت المعدّلة."],
        "settings.adjustReset": ["en": "Reset to 0", "fr": "Remettre à 0", "ar": "إعادة إلى 0"],
        "settings.minutesShort": ["en": "min", "fr": "min", "ar": "د"],
        "widget.tasbihDesc": ["en": "Tap to count dhikr.", "fr": "Touchez pour compter le dhikr.", "ar": "اضغط للتسبيح."],
    ]
}
