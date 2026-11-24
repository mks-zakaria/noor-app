import Foundation

/// UI string table keyed by string id → [language code: text].
/// Codes: "en", "fr", "ar". Missing entries fall back to English.
enum Strings {
    /// Direct lookup used outside of SwiftUI (e.g. notification scheduling).
    static func t(_ key: String, _ code: String) -> String {
        let row = table[key]
        return row?[code] ?? row?["en"] ?? key
    }

    /// The full table: 1.0–1.1 strings plus `v12`, which wins on a shared key.
    static let table: [String: [String: String]] = base.merging(v12) { _, new in new }

    static let base: [String: [String: String]] = [
        // Notifications
        "notif.body": ["en": "It's time for", "fr": "C'est l'heure de la prière —", "ar": "حان وقت صلاة"],
        "notif.testTitle": ["en": "Adhan test", "fr": "Test de l'adhan", "ar": "اختبار الأذان"],
        "notif.adkarTitle": ["en": "Time for adkar 🤍", "fr": "L'heure des rappels 🤍", "ar": "حان وقت الأذكار 🤍"],
        "notif.adkarMorning": [
            "en": "Start your morning with the morning adkar.",
            "fr": "Commencez votre matinée par les rappels du matin.",
            "ar": "ابدأ صباحك بأذكار الصباح.",
        ],
        "notif.adkarEvening": [
            "en": "Take a moment for the evening adkar.",
            "fr": "Prenez un instant pour les rappels du soir.",
            "ar": "خذ لحظة لأذكار المساء.",
        ],
        "notif.testBody": [
            "en": "If you hear the adhan, notifications are working.",
            "fr": "Si vous entendez l'adhan, les notifications fonctionnent.",
            "ar": "إذا سمعت الأذان فإن الإشعارات تعمل.",
        ],

        // Tabs
        "tab.prayer": ["en": "Prayer", "fr": "Prière", "ar": "الصلاة"],
        "tab.qibla": ["en": "Qibla", "fr": "Qibla", "ar": "القبلة"],
        "tab.quran": ["en": "Quran", "fr": "Coran", "ar": "القرآن"],
        "tab.adkar": ["en": "Adkar", "fr": "Rappels", "ar": "الأذكار"],
        "tab.wird": ["en": "Wird", "fr": "Wird", "ar": "الورد"],

        // Common
        "app.name": ["en": "Noor", "fr": "Noor", "ar": "نور"],
        "common.openSettings": ["en": "Open Settings", "fr": "Ouvrir Réglages", "ar": "فتح الإعدادات"],
        "common.retry": ["en": "Retry", "fr": "Réessayer", "ar": "إعادة المحاولة"],
        // Neutral wording is mandatory here: this button precedes the system
        // location prompt, and App Store Review rejects labels that direct the
        // user to grant access ("Enable Location") under guideline 5.1.1(iv).
        "common.continue": ["en": "Continue", "fr": "Continuer", "ar": "متابعة"],
        "common.done": ["en": "Done", "fr": "Terminé", "ar": "تم"],
        // Explains *why* location is requested, before the system prompt. App Store
        // Review asked for more information up front here (guideline 5.1.1(iv)).
        "location.why.title": [
            "en": "Why Noor asks for your location",
            "fr": "Pourquoi Noor demande votre position",
            "ar": "لماذا يطلب نور موقعك",
        ],
        // Kept short on purpose. These lines plus the lead-in and the button have
        // to fit above the tab bar on iPad (iPhone compatibility mode), where the
        // window is narrow and text wraps hard. Longer copy hid the button.
        "location.why.prayer": [
            "en": "Prayer times are calculated from your coordinates — they differ from one city to the next.",
            "fr": "Les horaires de prière sont calculés à partir de vos coordonnées — ils varient d'une ville à l'autre.",
            "ar": "تُحسب أوقات الصلاة من إحداثيات موقعك — وهي تختلف من مدينة إلى أخرى.",
        ],
        "location.why.qibla": [
            "en": "The Qibla compass needs your position to find the direction of the Kaaba.",
            "fr": "La boussole Qibla a besoin de votre position pour trouver la direction de la Kaaba.",
            "ar": "تحتاج بوصلة القبلة إلى موقعك لتحديد اتجاه الكعبة.",
        ],
        "location.why.privacy": [
            "en": "Noor has no account and no tracking.",
            "fr": "Noor n'a ni compte ni suivi.",
            "ar": "لا يحتوي نور على حساب ولا تتبّع.",
        ],
        // Leads into the Continue button so the button completes a sentence.
        //
        // NOTE: this wording was chosen deliberately by the app owner. Be aware
        // that "enable the location" directs the user toward granting the
        // permission, which is the pattern App Store Review cited in the
        // 1.0 (2) rejection (guideline 5.1.1(iv)) against the old
        // "Enable Location" button. If a further rejection cites the same
        // guideline, this line is the first thing to change — describe the
        // outcome ("Continue to set up prayer times for your city") instead of
        // the permission grant.
        "location.why.next": [
            "en": "Click Continue to enable the location.",
            "fr": "Cliquez sur Continuer pour activer la localisation.",
            "ar": "اضغط على متابعة لتفعيل الموقع.",
        ],

        // Home
        "home.nextPrayer": ["en": "NEXT PRAYER", "fr": "PROCHAINE PRIÈRE", "ar": "الصلاة القادمة"],
        "home.in": ["en": "in", "fr": "dans", "ar": "بعد"],
        "home.continueReading": ["en": "CONTINUE READING", "fr": "REPRENDRE LA LECTURE", "ar": "متابعة القراءة"],
        "home.learn": ["en": "Learn to pray", "fr": "Apprendre à prier", "ar": "تعلّم الصلاة"],
        "home.favourites": ["en": "Favourites", "fr": "Favoris", "ar": "المفضلة"],
        "favourites.title": ["en": "Favourites", "fr": "Favoris", "ar": "المفضلة"],
        "favourites.quran": ["en": "Quran verses", "fr": "Versets du Coran", "ar": "آيات القرآن"],
        "favourites.adkar": ["en": "Adkar", "fr": "Rappels", "ar": "الأذكار"],
        "favourites.empty": ["en": "No favourites yet", "fr": "Aucun favori", "ar": "لا توجد مفضلة بعد"],
        "favourites.emptyDesc": [
            "en": "Tap the heart on a dhikr, or the bookmark on a verse, to save it here.",
            "fr": "Touchez le cœur d'un dhikr, ou le marque-page d'un verset, pour l'enregistrer ici.",
            "ar": "اضغط على القلب في الذكر أو على العلامة في الآية لحفظها هنا.",
        ],
        "guides.title": ["en": "Learn", "fr": "Apprendre", "ar": "التعلّم"],
        "guides.purification": ["en": "Purification", "fr": "Purification", "ar": "الطهارة"],
        "guides.prayer": ["en": "The Prayer", "fr": "La prière", "ar": "الصلاة"],
        "guides.types": ["en": "Types of Prayer", "fr": "Types de prière", "ar": "أنواع الصلاة"],
        // Shown only after location access has already been declined — never before
        // the system prompt (App Store Review guideline 5.1.1(iv)).
        "home.locationDenied": [
            "en": "Location access is off, so prayer times can't be calculated for where you are. You can change this for Noor in Settings.",
            "fr": "L'accès à la localisation est désactivé, les horaires de prière ne peuvent donc pas être calculés pour votre position. Vous pouvez le modifier pour Noor dans Réglages.",
            "ar": "الوصول إلى الموقع معطّل، لذا لا يمكن حساب أوقات الصلاة لموقعك. يمكنك تغيير ذلك لتطبيق نور من الإعدادات.",
        ],

        // Qibla
        "qibla.title": ["en": "Qibla", "fr": "Qibla", "ar": "القبلة"],
        "qibla.instruction": [
            "en": "Face the arrow to pray toward the Kaaba",
            "fr": "Suivez la flèche pour prier en direction de la Kaaba",
            "ar": "اتبع السهم للصلاة باتجاه الكعبة",
        ],
        "qibla.fromNorth": ["en": "from North", "fr": "depuis le Nord", "ar": "من الشمال"],
        "qibla.aligned": [
            "en": "Aligned — you're facing the Qibla",
            "fr": "Aligné — vous faites face à la Qibla",
            "ar": "أنت الآن باتجاه القبلة",
        ],
        "qibla.turn": [
            "en": "Turn until the arrow points up",
            "fr": "Tournez jusqu'à ce que la flèche pointe vers le haut",
            "ar": "أدر الجهاز حتى يشير السهم للأعلى",
        ],
        "qibla.noCompass": [
            "en": "Compass not available on this device.",
            "fr": "Boussole non disponible sur cet appareil.",
            "ar": "البوصلة غير متوفرة على هذا الجهاز.",
        ],
        "qibla.locationOff": ["en": "Location access is off", "fr": "Localisation désactivée", "ar": "الوصول إلى الموقع معطّل"],
        "qibla.locationOffDesc": [
            "en": "The Qibla direction can't be calculated without your location. You can change this for Noor in Settings.",
            "fr": "La direction de la Qibla ne peut pas être calculée sans votre position. Vous pouvez le modifier pour Noor dans Réglages.",
            "ar": "لا يمكن تحديد اتجاه القبلة بدون موقعك. يمكنك تغيير ذلك لتطبيق نور من الإعدادات.",
        ],

        // Quran
        "quran.title": ["en": "Quran", "fr": "Coran", "ar": "القرآن"],
        "quran.search": ["en": "Search surah", "fr": "Rechercher une sourate", "ar": "ابحث عن سورة"],
        "quran.bookmarks": ["en": "Bookmarks", "fr": "Favoris", "ar": "المحفوظات"],
        "quran.surahs": ["en": "Surahs", "fr": "Sourates", "ar": "السور"],
        "quran.results": ["en": "Results", "fr": "Résultats", "ar": "النتائج"],
        "quran.ayahs": ["en": "ayahs", "fr": "versets", "ar": "آيات"],
        "quran.loadError": [
            "en": "Couldn't load this surah. Check your connection and try again.",
            "fr": "Impossible de charger cette sourate. Vérifiez votre connexion et réessayez.",
            "ar": "تعذّر تحميل السورة. تحقق من اتصالك وحاول مجددًا.",
        ],
        "quran.largerArabic": ["en": "Larger Arabic", "fr": "Agrandir l'arabe", "ar": "تكبير الخط"],
        "quran.smallerArabic": ["en": "Smaller Arabic", "fr": "Réduire l'arabe", "ar": "تصغير الخط"],
        "quran.resetSize": ["en": "Reset size", "fr": "Réinitialiser la taille", "ar": "إعادة الحجم"],
        "quran.autoScroll": ["en": "Auto-scroll", "fr": "Défilement", "ar": "تمرير تلقائي"],
        "quran.stopScroll": ["en": "Stop scrolling", "fr": "Arrêter le défilement", "ar": "إيقاف التمرير"],
        "quran.slower": ["en": "Slower", "fr": "Plus lent", "ar": "أبطأ"],
        "quran.faster": ["en": "Faster", "fr": "Plus rapide", "ar": "أسرع"],

        // Revelation place
        "place.meccan": ["en": "Meccan", "fr": "Mecquoise", "ar": "مكية"],
        "place.medinan": ["en": "Medinan", "fr": "Médinoise", "ar": "مدنية"],

        // Adkar
        "adkar.title": ["en": "Adkar", "fr": "Rappels", "ar": "الأذكار"],
        "adkar.done": ["en": "Done", "fr": "Fait", "ar": "تم"],
        "adkar.allDone": [
            "en": "MashaAllah — you've completed them all.",
            "fr": "MachaAllah — vous les avez tous accomplis.",
            "ar": "ما شاء الله — أتممتَ جميع الأذكار.",
        ],
        "adkar.reset": ["en": "Start again", "fr": "Recommencer", "ar": "ابدأ من جديد"],
        "adkar.daily": ["en": "Daily fortress", "fr": "Forteresse du jour", "ar": "الحصن اليومي"],
        "adkar.hisn": ["en": "Hisn al-Muslim", "fr": "Hisn al-Muslim", "ar": "حصن المسلم"],
        "adkar.hisnSubtitle": [
            "en": "The Fortress of the Muslim — 132 chapters of authentic du'ās from the Qur'an & Sunnah.",
            "fr": "La Citadelle du musulman — 132 chapitres d'invocations authentiques du Coran et de la Sunna.",
            "ar": "حصن المسلم — ١٣٢ بابًا من أذكار الكتاب والسنة.",
        ],
        "adkar.themed": ["en": "Themed du'ās", "fr": "Invocations par thème", "ar": "أدعية مختارة"],
        "adkar.quranSunnah": ["en": "From the Qur'ān & Sunnah", "fr": "Du Coran et de la Sunna", "ar": "من القرآن والسنة"],
        "hisn.chapters": ["en": "chapters", "fr": "chapitres", "ar": "بابًا"],
        "hisn.duas": ["en": "du'ā", "fr": "invocations", "ar": "دعاء"],
        "hisn.chapter": ["en": "Chapter", "fr": "Chapitre", "ar": "باب"],
        "adkar.celebrateTitle": [
            "en": "May Allah accept 🤍",
            "fr": "Qu'Allah les accepte 🤍",
            "ar": "تقبّل الله منك 🤍",
        ],
        "adkar.celebrateSubtitle": [
            "en": "Adkar remembered so far",
            "fr": "Rappels accomplis jusqu'ici",
            "ar": "الأذكار التي ذكرتها حتى الآن",
        ],
        "adkar.celebrateDismiss": ["en": "Continue", "fr": "Continuer", "ar": "متابعة"],
        "share.footer": ["en": "— shared from Noor 🌙", "fr": "— partagé depuis Noor 🌙", "ar": "— من تطبيق نور 🌙"],

        // Share card
        "share.title": ["en": "Share", "fr": "Partager", "ar": "مشاركة"],
        "share.action": ["en": "Share card", "fr": "Partager la carte", "ar": "شارك البطاقة"],
        "share.copyText": ["en": "Copy as text", "fr": "Copier le texte", "ar": "نسخ النص"],
        "share.copied": ["en": "Copied", "fr": "Copié", "ar": "تم النسخ"],
        "share.includeTranslation": [
            "en": "Include translation",
            "fr": "Inclure la traduction",
            "ar": "إظهار الترجمة",
        ],
        "share.style.emerald": ["en": "Emerald", "fr": "Émeraude", "ar": "زمردي"],
        "share.style.night": ["en": "Night", "fr": "Nuit", "ar": "ليلي"],
        "share.style.sand": ["en": "Sand", "fr": "Sable", "ar": "رملي"],
        "share.style.ink": ["en": "Ink", "fr": "Encre", "ar": "حبري"],

        // Rating
        "rate.title": ["en": "Enjoying Noor?", "fr": "Noor vous plaît ?", "ar": "هل أعجبك نور؟"],
        "rate.body": [
            "en": "A rating helps other Muslims find the app. It takes ten seconds.",
            "fr": "Une note aide d'autres musulmans à découvrir l'application. Cela prend dix secondes.",
            "ar": "تقييمك يساعد مسلمين آخرين على العثور على التطبيق. لن يستغرق سوى عشر ثوانٍ.",
        ],
        "rate.action": ["en": "Rate Noor", "fr": "Noter Noor", "ar": "قيِّم نور"],
        "rate.dismiss": ["en": "Not now", "fr": "Plus tard", "ar": "ليس الآن"],

        // Wird
        "wird.title": ["en": "Wird", "fr": "Wird", "ar": "الورد"],
        "wird.today": ["en": "Today's Wird", "fr": "Wird du jour", "ar": "ورد اليوم"],
        "wird.fajr_sunnah": ["en": "Fajr Sunnah & Prayer", "fr": "Sunna et prière du Fajr", "ar": "سنة وصلاة الفجر"],
        "wird.morning_adkar": ["en": "Morning Adkar", "fr": "Rappels du matin", "ar": "أذكار الصباح"],
        "wird.quran": ["en": "Read Quran", "fr": "Lire le Coran", "ar": "قراءة القرآن"],
        "wird.dhuhr": ["en": "Dhuhr Prayer", "fr": "Prière du Dhuhr", "ar": "صلاة الظهر"],
        "wird.asr": ["en": "Asr Prayer", "fr": "Prière de l'Asr", "ar": "صلاة العصر"],
        "wird.evening_adkar": ["en": "Evening Adkar", "fr": "Rappels du soir", "ar": "أذكار المساء"],
        "wird.maghrib": ["en": "Maghrib Prayer", "fr": "Prière du Maghrib", "ar": "صلاة المغرب"],
        "wird.isha": ["en": "Isha Prayer", "fr": "Prière de l'Isha", "ar": "صلاة العشاء"],
        "wird.istighfar": ["en": "100× Istighfar", "fr": "100× Istighfâr", "ar": "الاستغفار ١٠٠×"],
        "wird.salawat": ["en": "Salawat on the Prophet ﷺ", "fr": "Salawât sur le Prophète ﷺ", "ar": "الصلاة على النبي ﷺ"],

        // Settings
        "settings.title": ["en": "Settings", "fr": "Réglages", "ar": "الإعدادات"],
        "settings.location": ["en": "Location", "fr": "Position", "ar": "الموقع"],
        "settings.currentLocation": ["en": "Current location", "fr": "Position actuelle", "ar": "الموقع الحالي"],
        "settings.locating": ["en": "Locating…", "fr": "Localisation…", "ar": "جارٍ التحديد…"],
        "settings.locationOff": [
            "en": "Location access is off",
            "fr": "L'accès à la localisation est désactivé",
            "ar": "الوصول إلى الموقع معطّل",
        ],
        // Names every feature that stops working, then links to Settings — the
        // remedy App Store Review suggested for features that need location.
        "settings.locationOffDesc": [
            "en": "Prayer times, the Qibla compass and prayer notifications all depend on your location and cannot be calculated without it.",
            "fr": "Les horaires de prière, la boussole Qibla et les notifications de prière dépendent tous de votre position et ne peuvent pas être calculés sans elle.",
            "ar": "تعتمد أوقات الصلاة وبوصلة القبلة وإشعارات الصلاة كلها على موقعك ولا يمكن حسابها بدونه.",
        ],
        "settings.locationNotSet": [
            "en": "Noor needs your location to calculate prayer times and the Qibla direction.",
            "fr": "Noor a besoin de votre position pour calculer les horaires de prière et la direction de la Qibla.",
            "ar": "يحتاج نور إلى موقعك لحساب أوقات الصلاة واتجاه القبلة.",
        ],
        // Shown when prayer notifications are on but no location is available —
        // without this the toggle looks active while no adhan can ever fire.
        "settings.notifyNeedsLocation": [
            "en": "Prayer notifications cannot be scheduled without your location, because prayer times depend on it. They will start automatically once location access is on.",
            "fr": "Les notifications de prière ne peuvent pas être programmées sans votre position, car les horaires en dépendent. Elles démarreront automatiquement dès que l'accès à la localisation sera activé.",
            "ar": "لا يمكن جدولة إشعارات الصلاة بدون موقعك، لأن أوقات الصلاة تعتمد عليه. ستبدأ تلقائيًا بمجرد تشغيل الوصول إلى الموقع.",
        ],
        "settings.calculation": ["en": "Calculation", "fr": "Calcul", "ar": "الحساب"],
        "settings.method": ["en": "Method", "fr": "Méthode", "ar": "طريقة الحساب"],
        "settings.madhab": ["en": "Asr (Madhab)", "fr": "Asr (Madhhab)", "ar": "العصر (المذهب)"],
        "settings.display": ["en": "Display", "fr": "Affichage", "ar": "العرض"],
        "settings.theme": ["en": "Appearance", "fr": "Apparence", "ar": "المظهر"],
        "theme.system": ["en": "System", "fr": "Système", "ar": "النظام"],
        "theme.light": ["en": "Light", "fr": "Clair", "ar": "فاتح"],
        "theme.dark": ["en": "Dark", "fr": "Sombre", "ar": "داكن"],
        "settings.hour12": ["en": "12-hour time", "fr": "Format 12 heures", "ar": "نظام ١٢ ساعة"],
        "settings.hijriAdjust": ["en": "Hijri day adjustment", "fr": "Ajustement du jour hégirien", "ar": "تعديل اليوم الهجري"],
        "settings.language": ["en": "Language", "fr": "Langue", "ar": "اللغة"],
        "settings.notifications": ["en": "Prayer notifications", "fr": "Notifications de prière", "ar": "إشعارات الصلاة"],
        "settings.notificationsFooter": [
            "en": "Notifies you at each prayer time for the next few days.",
            "fr": "Vous avertit à chaque heure de prière pour les prochains jours.",
            "ar": "ينبّهك عند كل وقت صلاة للأيام القادمة.",
        ],
        "settings.notifyFor": ["en": "Notify me for", "fr": "M'avertir pour", "ar": "نبّهني لِـ"],
        "settings.adkarReminders": ["en": "Adkar reminders", "fr": "Rappels d'adkar", "ar": "تذكير بالأذكار"],
        "settings.adkarRemindersFooter": [
            "en": "A gentle nudge morning and evening. Each reminder counts toward your adkar total.",
            "fr": "Un petit rappel matin et soir. Chaque rappel compte dans votre total de rappels.",
            "ar": "تنبيه لطيف صباحًا ومساءً. كل تذكير يُحتسب ضمن مجموع أذكارك.",
        ],
        "settings.adhanSound": ["en": "Play adhan sound", "fr": "Jouer l'adhan", "ar": "تشغيل صوت الأذان"],
        "settings.testAdhan": ["en": "Test adhan (fires in 5s)", "fr": "Tester l'adhan (dans 5 s)", "ar": "اختبار الأذان (بعد ٥ ث)"],
        "settings.adhanFooter": [
            "en": "When on, the call to prayer plays as the notification sound. It follows your ringer/silent switch.",
            "fr": "Lorsqu'il est activé, l'appel à la prière est joué comme son de notification. Il suit l'interrupteur sonnerie/silencieux.",
            "ar": "عند التفعيل، يُشغَّل الأذان كصوت للإشعار، ويتبع مفتاح الرنين/الصامت.",
        ],
        "settings.about": ["en": "About", "fr": "À propos", "ar": "حول"],
        "settings.rate": ["en": "Rate Noor", "fr": "Noter Noor", "ar": "قيِّم نور"],
        "settings.shareApp": ["en": "Share Noor", "fr": "Partager Noor", "ar": "شارك نور"],
        "settings.shareAppMessage": [
            "en": "Noor — prayer times, Qibla, Quran and adkar, with no tracking.",
            "fr": "Noor — heures de prière, Qibla, Coran et adkar, sans aucun suivi.",
            "ar": "نور — مواقيت الصلاة والقبلة والقرآن والأذكار، بلا تتبع.",
        ],
        "settings.rateFooter": [
            "en": "Noor is free and collects nothing. A rating is the only thing it ever asks for.",
            "fr": "Noor est gratuite et ne collecte rien. Une note est la seule chose qu'elle demande.",
            "ar": "نور مجاني ولا يجمع أي بيانات. التقييم هو الشيء الوحيد الذي نطلبه.",
        ],
        "settings.reciter": ["en": "Reciter", "fr": "Récitateur", "ar": "القارئ"],
        "settings.version": ["en": "Version", "fr": "Version", "ar": "الإصدار"],

        // Lock-screen widget
        "settings.widget": ["en": "Lock Screen Widget", "fr": "Widget d'écran verrouillé", "ar": "ودجت شاشة القفل"],
        "settings.widget.show": ["en": "Show verses", "fr": "Afficher les versets", "ar": "إظهار الآيات"],
        "settings.widget.display": ["en": "Verse display", "fr": "Affichage des versets", "ar": "عرض الآية"],
        "widget.display.both": ["en": "Arabic & English", "fr": "Arabe et anglais", "ar": "عربي وإنجليزي"],
        "widget.display.arabic": ["en": "Arabic only", "fr": "Arabe seul", "ar": "عربي فقط"],
        "widget.display.english": ["en": "English only", "fr": "Anglais seul", "ar": "إنجليزي فقط"],
        "settings.widget.footer": [
            "en": "An uplifting verse keeps rotating on your lock screen. Add the widget by long-pressing it.",
            "fr": "Un verset inspirant défile régulièrement sur votre écran verrouillé. Ajoutez le widget en le maintenant enfoncé.",
            "ar": "تتبدل آية مبهجة بانتظام على شاشة القفل. أضف الودجت بالضغط المطوّل عليها.",
        ],
        "lang.system": ["en": "System", "fr": "Système", "ar": "تلقائي (النظام)"],

        // Madhab
        "madhab.hanafi": ["en": "Hanafi", "fr": "Hanafite", "ar": "الحنفي"],
        "madhab.other": ["en": "Shafi / Maliki / Hanbali", "fr": "Shafi'i / Malikite / Hanbalite", "ar": "الشافعي / المالكي / الحنبلي"],

        // Prayer names
        "prayer.fajr": ["en": "Fajr", "fr": "Fajr", "ar": "الفجر"],
        "prayer.sunrise": ["en": "Sunrise", "fr": "Lever du soleil", "ar": "الشروق"],
        "prayer.dhuhr": ["en": "Dhuhr", "fr": "Dhuhr", "ar": "الظهر"],
        "prayer.asr": ["en": "Asr", "fr": "Asr", "ar": "العصر"],
        "prayer.maghrib": ["en": "Maghrib", "fr": "Maghrib", "ar": "المغرب"],
        "prayer.isha": ["en": "Isha", "fr": "Isha", "ar": "العشاء"],
    ]
}
