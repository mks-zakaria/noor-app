import Foundation

let purificationGuides: [Guide] = [
    Guide(
        id: "wudu",
        section: "purification",
        icon: "drop.fill",
        title: L3(
            en: "Ablution (Wudu)",
            fr: "Les ablutions (Wudu)",
            ar: "الوضوء"
        ),
        summary: L3(
            en: "Wudu is the ritual washing required before prayer and touching the Qur'an. Wash the parts in order without long pauses. Wudu is invalidated by passing urine, stool or wind, deep sleep, loss of consciousness, and (for many scholars) direct contact with the private parts.",
            fr: "Le wudu est le lavage rituel requis avant la prière et avant de toucher le Coran. Lavez les parties dans l'ordre, sans longues pauses. Le wudu est annulé par l'urine, les selles ou les gaz, le sommeil profond, la perte de conscience, et (pour de nombreux savants) le contact direct avec les parties intimes.",
            ar: "الوضوء هو الطهارة المطلوبة قبل الصلاة وقبل مسّ المصحف. تُغسل الأعضاء بالترتيب ومن غير تأخير طويل. وينتقض الوضوء بخروج البول أو الغائط أو الريح، وبالنوم العميق، وبزوال العقل، وعند كثير من العلماء بمسّ الفرج مباشرة."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Intention and Bismillah",
                    fr: "Intention et Bismillah",
                    ar: "النية والتسمية"
                ),
                body: L3(
                    en: "Make the intention (niyyah) in your heart to purify yourself for worship, then say Bismillah. The intention is not spoken aloud.",
                    fr: "Formez l'intention (niyyah) dans votre cœur de vous purifier pour l'adoration, puis dites Bismillah. L'intention ne se prononce pas à voix haute.",
                    ar: "انوِ بقلبك الطهارة للعبادة، ثم قل بسم الله. والنية محلها القلب لا تُنطق باللسان."
                ),
                arabic: "بِسْمِ اللَّهِ",
                translit: "Bismillah"
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Wash the hands three times",
                    fr: "Laver les mains trois fois",
                    ar: "غسل اليدين ثلاثًا"
                ),
                body: L3(
                    en: "Wash both hands up to the wrists three times, making sure the water reaches between the fingers.",
                    fr: "Lavez les deux mains jusqu'aux poignets trois fois, en veillant à ce que l'eau passe entre les doigts.",
                    ar: "اغسل كفّيك إلى الرسغين ثلاث مرات، وأدخل الماء بين الأصابع."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Rinse the mouth three times",
                    fr: "Rincer la bouche trois fois",
                    ar: "المضمضة ثلاثًا"
                ),
                body: L3(
                    en: "Take water into the mouth with the right hand and rinse it around thoroughly, three times.",
                    fr: "Prenez de l'eau dans la bouche avec la main droite et rincez soigneusement, trois fois.",
                    ar: "خذ الماء بيدك اليمنى ومضمض به فمك جيدًا ثلاث مرات."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Sniff and blow the nose three times",
                    fr: "Aspirer et rejeter l'eau par le nez trois fois",
                    ar: "الاستنشاق والاستنثار ثلاثًا"
                ),
                body: L3(
                    en: "Draw water into the nostrils with the right hand, then blow it out with the left, three times.",
                    fr: "Aspirez de l'eau dans les narines avec la main droite, puis rejetez-la avec la main gauche, trois fois.",
                    ar: "استنشق الماء بيدك اليمنى ثم استنثره (أخرجه) بيدك اليسرى ثلاث مرات."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 5,
                title: L3(
                    en: "Wash the face three times",
                    fr: "Laver le visage trois fois",
                    ar: "غسل الوجه ثلاثًا"
                ),
                body: L3(
                    en: "Wash the entire face three times, from the hairline to the chin and from ear to ear. Men should let the water reach through the beard.",
                    fr: "Lavez tout le visage trois fois, de la racine des cheveux au menton et d'une oreille à l'autre. Les hommes doivent faire pénétrer l'eau dans la barbe.",
                    ar: "اغسل وجهك كله ثلاث مرات من منابت الشعر إلى الذقن ومن الأذن إلى الأذن، ويخلّل الرجل لحيته بالماء."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 6,
                title: L3(
                    en: "Wash the arms to the elbows three times",
                    fr: "Laver les bras jusqu'aux coudes trois fois",
                    ar: "غسل اليدين إلى المرفقين ثلاثًا"
                ),
                body: L3(
                    en: "Wash the right arm from the fingertips up to and including the elbow three times, then do the same with the left arm.",
                    fr: "Lavez le bras droit du bout des doigts jusqu'au coude inclus, trois fois, puis faites de même avec le bras gauche.",
                    ar: "اغسل ذراعك اليمنى من أطراف الأصابع إلى المرفق مع المرفق ثلاث مرات، ثم افعل مثل ذلك باليسرى."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 7,
                title: L3(
                    en: "Wipe the head once and wipe the ears",
                    fr: "Essuyer la tête une fois et essuyer les oreilles",
                    ar: "مسح الرأس مرة ومسح الأذنين"
                ),
                body: L3(
                    en: "With wet hands, wipe (masah) over the head once, from front to back and back again. Then wipe the inside of the ears with the index fingers and the outside with the thumbs.",
                    fr: "Avec les mains mouillées, essuyez (masah) la tête une fois, de l'avant vers l'arrière puis de nouveau vers l'avant. Essuyez ensuite l'intérieur des oreilles avec les index et l'extérieur avec les pouces.",
                    ar: "امسح رأسك بيدين مبلولتين مرة واحدة من مقدمته إلى مؤخرته ثم أعدهما، ثم امسح باطن أذنيك بالسبابتين وظاهرهما بالإبهامين."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 8,
                title: L3(
                    en: "Wash the feet to the ankles three times",
                    fr: "Laver les pieds jusqu'aux chevilles trois fois",
                    ar: "غسل القدمين إلى الكعبين ثلاثًا"
                ),
                body: L3(
                    en: "Wash the right foot up to and including the ankle three times, passing the fingers between the toes, then do the same with the left foot.",
                    fr: "Lavez le pied droit jusqu'à la cheville incluse, trois fois, en passant les doigts entre les orteils, puis faites de même avec le pied gauche.",
                    ar: "اغسل قدمك اليمنى إلى الكعبين مع الكعبين ثلاث مرات، وخلّل بين أصابعها، ثم افعل مثل ذلك باليسرى."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 9,
                title: L3(
                    en: "The supplication after Wudu",
                    fr: "L'invocation après le Wudu",
                    ar: "الدعاء بعد الوضوء"
                ),
                body: L3(
                    en: "Recommended (sunnah): while looking up, recite the testimony of faith. The Prophet (peace be upon him) said the eight gates of Paradise are opened for whoever says it after completing wudu well.",
                    fr: "Recommandé (sunnah) : en regardant vers le ciel, récitez l'attestation de foi. Le Prophète (paix sur lui) a dit que les huit portes du Paradis s'ouvrent pour celui qui la prononce après avoir bien accompli ses ablutions.",
                    ar: "من السنة أن ترفع نظرك إلى السماء وتقول الشهادة، فقد قال النبي صلى الله عليه وسلم إن من قالها بعد إتمام الوضوء فُتحت له أبواب الجنة الثمانية."
                ),
                arabic: "أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ",
                translit: "Ashhadu an la ilaha illa Allah, wahdahu la sharika lah, wa ashhadu anna Muhammadan 'abduhu wa rasuluh. Allahumma-j'alni mina at-tawwabina waj'alni mina al-mutatahhirin"
            )
        ]
    ),
    Guide(
        id: "ghusl",
        section: "purification",
        icon: "shower.fill",
        title: L3(
            en: "Ritual Bath (Ghusl)",
            fr: "Le bain rituel (Ghusl)",
            ar: "الغسل"
        ),
        summary: L3(
            en: "Ghusl is the full-body ritual washing required after major impurity (janabah), and for women after menstruation and post-natal bleeding. It also removes the state of minor impurity, so a separate wudu is not required for prayer afterward.",
            fr: "Le ghusl est le lavage rituel de tout le corps requis après l'impureté majeure (janaba), et pour les femmes après les menstrues et les lochies. Il lève aussi l'impureté mineure, de sorte qu'un wudu séparé n'est pas nécessaire ensuite pour la prière.",
            ar: "الغسل هو تطهير كامل للبدن يجب بعد الجنابة، وللمرأة بعد الحيض والنفاس. وهو يرفع الحدث الأصغر أيضًا، فلا يلزم وضوء مستقل للصلاة بعده."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Intention and Bismillah",
                    fr: "Intention et Bismillah",
                    ar: "النية والتسمية"
                ),
                body: L3(
                    en: "Make the intention in your heart to lift the state of major impurity, then say Bismillah.",
                    fr: "Formez l'intention dans votre cœur de lever l'état d'impureté majeure, puis dites Bismillah.",
                    ar: "انوِ بقلبك رفع الحدث الأكبر، ثم قل بسم الله."
                ),
                arabic: "بِسْمِ اللَّهِ",
                translit: "Bismillah"
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Wash the hands and private parts",
                    fr: "Laver les mains et les parties intimes",
                    ar: "غسل اليدين والفرج"
                ),
                body: L3(
                    en: "Wash both hands, then wash the private parts and remove any impurity from the body with the left hand.",
                    fr: "Lavez les deux mains, puis lavez les parties intimes et enlevez toute souillure du corps avec la main gauche.",
                    ar: "اغسل يديك، ثم اغسل فرجك وأزل ما على البدن من أذى بيدك اليسرى."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Perform Wudu",
                    fr: "Accomplir le Wudu",
                    ar: "الوضوء"
                ),
                body: L3(
                    en: "Perform a complete wudu as you would for prayer. You may delay washing the feet until the end of the bath.",
                    fr: "Accomplissez un wudu complet comme pour la prière. Vous pouvez reporter le lavage des pieds à la fin du bain.",
                    ar: "توضأ وضوءك للصلاة كاملاً، ويجوز تأخير غسل القدمين إلى آخر الغسل."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Pour water over the head three times",
                    fr: "Verser de l'eau sur la tête trois fois",
                    ar: "إفاضة الماء على الرأس ثلاثًا"
                ),
                body: L3(
                    en: "Pour water over the head three times, working it into the roots of the hair so the scalp is thoroughly wetted.",
                    fr: "Versez de l'eau sur la tête trois fois, en la faisant pénétrer jusqu'aux racines des cheveux pour bien mouiller le cuir chevelu.",
                    ar: "أفض الماء على رأسك ثلاث مرات، وأوصل الماء إلى أصول الشعر حتى يبتلّ البشرة."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 5,
                title: L3(
                    en: "Wash the whole body, right then left",
                    fr: "Laver tout le corps, la droite puis la gauche",
                    ar: "غسل سائر الجسد يمينًا ثم شمالًا"
                ),
                body: L3(
                    en: "Pour water over the entire body, starting with the right side then the left, making sure no part of the skin is left dry.",
                    fr: "Versez de l'eau sur tout le corps, en commençant par le côté droit puis le gauche, en veillant à ne laisser aucune partie de la peau sèche.",
                    ar: "أفض الماء على سائر جسدك مبتدئًا بشقك الأيمن ثم الأيسر، ولا تدع موضعًا من البشرة إلا أصابه الماء."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 6,
                title: L3(
                    en: "Wash the feet",
                    fr: "Laver les pieds",
                    ar: "غسل القدمين"
                ),
                body: L3(
                    en: "Move aside from the spot and wash both feet if you delayed them during the wudu, completing the bath.",
                    fr: "Déplacez-vous de l'endroit et lavez les deux pieds si vous les aviez reportés lors du wudu, achevant ainsi le bain.",
                    ar: "تنحَّ عن مكانك واغسل قدميك إن كنت أخّرتهما في الوضوء، فيتم بذلك الغسل."
                ),
                arabic: "",
                translit: ""
            )
        ]
    ),
    Guide(
        id: "tayammum",
        section: "purification",
        icon: "hand.raised.fill",
        title: L3(
            en: "Dry Ablution (Tayammum)",
            fr: "L'ablution sèche (Tayammum)",
            ar: "التيمم"
        ),
        summary: L3(
            en: "Tayammum is the permitted substitute for wudu or ghusl when water is unavailable, insufficient, or its use would cause harm (such as illness or severe cold). It uses clean earth or dust and replaces purification with water until water becomes available.",
            fr: "Le tayammum est le substitut autorisé au wudu ou au ghusl lorsque l'eau est absente, insuffisante, ou que son usage causerait un préjudice (maladie, froid intense). Il se fait avec de la terre ou de la poussière propre et remplace la purification à l'eau jusqu'à ce que l'eau soit disponible.",
            ar: "التيمم بدل مشروع عن الوضوء أو الغسل عند فقد الماء أو قلّته أو تعذّر استعماله للضرر كالمرض أو شدة البرد. يكون بالتراب أو الصعيد الطاهر وينوب عن الطهارة بالماء حتى يوجد الماء."
        ),
        steps: [
            GuideStep(
                id: 1,
                title: L3(
                    en: "Intention and Bismillah",
                    fr: "Intention et Bismillah",
                    ar: "النية والتسمية"
                ),
                body: L3(
                    en: "Make the intention in your heart to purify yourself for prayer by tayammum, then say Bismillah.",
                    fr: "Formez l'intention dans votre cœur de vous purifier pour la prière par le tayammum, puis dites Bismillah.",
                    ar: "انوِ بقلبك الطهارة للصلاة بالتيمم، ثم قل بسم الله."
                ),
                arabic: "بِسْمِ اللَّهِ",
                translit: "Bismillah"
            ),
            GuideStep(
                id: 2,
                title: L3(
                    en: "Strike the clean earth once",
                    fr: "Frapper la terre propre une fois",
                    ar: "ضرب الأرض الطاهرة مرة"
                ),
                body: L3(
                    en: "Strike both palms lightly upon clean ground, dust, sand, or stone a single time.",
                    fr: "Frappez légèrement les deux paumes sur une surface propre : terre, poussière, sable ou pierre, une seule fois.",
                    ar: "اضرب بكفّيك ضربة واحدة على الأرض الطاهرة أو التراب أو الرمل أو الحجر."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 3,
                title: L3(
                    en: "Wipe the face",
                    fr: "Essuyer le visage",
                    ar: "مسح الوجه"
                ),
                body: L3(
                    en: "Blow off any excess dust, then wipe your whole face once with both hands.",
                    fr: "Soufflez pour ôter l'excès de poussière, puis essuyez tout votre visage une fois avec les deux mains.",
                    ar: "انفخ ما زاد من التراب، ثم امسح وجهك كله مرة واحدة بكفّيك."
                ),
                arabic: "",
                translit: ""
            ),
            GuideStep(
                id: 4,
                title: L3(
                    en: "Wipe the hands",
                    fr: "Essuyer les mains",
                    ar: "مسح اليدين"
                ),
                body: L3(
                    en: "Wipe the back of the right hand with the left palm, then the back of the left hand with the right palm. Purification is complete.",
                    fr: "Essuyez le dos de la main droite avec la paume gauche, puis le dos de la main gauche avec la paume droite. La purification est achevée.",
                    ar: "امسح ظاهر يدك اليمنى بباطن اليسرى، ثم ظاهر اليسرى بباطن اليمنى، وبذلك تتم الطهارة."
                ),
                arabic: "",
                translit: ""
            )
        ]
    )
]
