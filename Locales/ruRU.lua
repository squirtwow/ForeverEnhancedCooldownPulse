-- Russian (ruRU) for Locale.lua: the text the addon shows, by its
-- English. Shown in the Language list as Русский. In the words of the
-- game's own Russian client: восстановление for a cooldown, заклинание,
-- предмет, аксессуар (trinket), зелье, камень здоровья, профиль, миникарта,
-- в бою, общая громкость (Master volume). The pulse is вспышка (it
-- вспыхивает), its two styles «Быстро» and «Долго», always in «» quotes in
-- a sentence; to tick is отметить (what's ticked: отметки), the General
-- page «Общие», What's new «Что нового», the tour обзор, Preview «Показ»,
-- Edit «Изменить». A number with %d sits after a colon or in brackets, so
-- no word has to agree with it; a spell's or item's name after a colon or
-- in «», as the game gives it. Cooldowns as the game's own tooltips write
-- them (30 сек, 6 мин, 1 ч). Short words where the room is tight:
-- Прозрачн. (See-through), Узк. and Шир. (Thin and Thick), перс.
-- Grouped by the file that shows each, as in zhCN.lua; the same English
-- always gets the same Russian. No em or en dashes.
local _, ns = ...

ns.LOCALES.ruRU = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "Профили нельзя менять в бою.",
    ["Your profile hasn't loaded yet."] = "Ваш профиль ещё не загружен.",
    ["Type a profile name first."] = "Сначала введите имя профиля.",
    ["Profile names can be up to %d characters."] = "Имя профиля: не длиннее %d байт (буква кириллицы занимает 2).",
    ["Profile names can't use the | character."] = "Имя профиля не может содержать символ |.",
    ['No profile is called "%s".'] = "Профиля «%s» нет.",
    ["You're already using %s."] = "Уже выбрано: %s.",
    ["Now using %s."] = "Выбран профиль %s.",
    ["%s already exists."] = "Профиль %s уже существует.",
    ["Copied your ticks to %s, and switched to it."] = "Ваши отметки скопированы в профиль %s, и он выбран.",
    ["Made %s, and switched to it."] = "Профиль %s создан и выбран.",
    ["All your characters use %s now, and new ones will too."] = "Теперь профиль %s используют все ваши персонажи, в том числе новые.",
    ["That's already its name."] = "Профиль уже так называется.",
    ["Renamed to %s."] = "Профиль переименован в %s.",
    ["Deleted %s. You're now on %s."] = "Профиль %s удалён. Теперь выбран %s.",
    ["Deleted %s."] = "Профиль %s удалён.",
    ["%s %s is out (you have %s). Update on CurseForge."] = "Вышла новая версия: %s %s (у вас %s). Обновите на CurseForge.",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "Большой значок в центре экрана в момент окончания восстановления. Чтобы открыть настройки, введите /fecp, нажмите кнопку у миникарты или кнопку ниже.",
    ["Open settings"] = "Открыть настройки",
    ["None"] = "Нет",
    ["Thin"] = "Узк.",
    ["Thick"] = "Шир.",
    ["Chime"] = "Перезвон",
    ["Bell"] = "Колокол",
    ["Bell trill"] = "Трель колокола",
    ["Shimmer bell"] = "Мерцающий звон",
    ["Magic chimes"] = "Волшебный звон",
    ["Shimmer"] = "Мерцание",
    ["Zippy magic"] = "Шустрая магия",
    ["Synth"] = "Синтезатор",
    ["Pitch pipe"] = "Камертон",
    ["Brass"] = "Медные трубы",
    ["War horn"] = "Боевой рог",
    ["Fanfare"] = "Фанфары",
    ["Gold"] = "Золото",
    ["Jackpot bell"] = "Звон джекпота",
    ["Anvil"] = "Наковальня",
    ["Quick"] = "Быстро",
    ["Long"] = "Долго",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."]
        = "Вспышка включена в %s. Отключите её там, чтобы пользоваться этой.",

    -- Theme.lua: the accents.
    ["Orange"] = "Оранжевый",
    ["Blue"] = "Синий",
    ["Teal"] = "Бирюзовый",
    ["Purple"] = "Фиолетовый",
    ["Green"] = "Зелёный",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "Предмет %d",
    ["Trinket %d: %s"] = "Аксессуар %d: %s",
    ["Healthstones"] = "Камни здоровья",
    ["Healing Potions"] = "Лечебные зелья",
    ["Mana Potions"] = "Зелья маны",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"]
        = "вспышке не удалось отследить восстановление. Пожалуйста, сообщите об этом: %s",
    ["Finish the fight first, then move it."] = "Сначала выйдите из боя, потом сдвигайте.",
    ["Cooldown pulse"] = "Вспышка",
    ["Done"] = "Готово",
    ["Drag the box, then click Done or right-click it."] = "Перетащите рамку, затем нажмите «Готово» или щёлкните по ней правой кнопкой мыши.",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%g сек",
    ["%g min"] = "%g мин",
    ["%g hour"] = "%g ч",
    ["%g hours"] = "%g ч",
    ["On your screen"] = "На экране",
    ["Up close"] = "Вблизи",
    ["Where it shows"] = "Где появляется",
    ["Move"] = "Сдвинуть",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "Показывает рамку размером со вспышку стиля, выбранного в строке «Изменить». Перетащите её туда, где нужна вспышка, и нажмите «Готово». Оба стиля появляются там.",
    ["Reset"] = "Сбросить",
    ["The pulse is back in the middle of your screen."] = "Вспышка снова в центре экрана.",
    ["Puts the pulse back in the middle of your screen."] = "Возвращает вспышку в центр экрана.",
    ["Pulse an icon when a cooldown is ready"] = "Вспышка значка по окончании восстановления",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "Большой значок в центре экрана в момент окончания восстановления, в том числе в бою. Он не перехватывает щелчки мыши.",
    ["%.1fs"] = "%.1f с",
    ["Edit"] = "Изменить",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "У «Быстро» и «Долго» свои размер, время и звук: выберите, какой стиль настроить ниже. «Показ» проигрывает его.",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = "Размер вспышки «%s» в единицах игры: 320 составляет примерно треть высоты экрана.",
    ["Size"] = "Размер",
    ["Shows for"] = "Время",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = "Сколько длится вспышка «Быстро», до 2 секунд: она появляется, задерживается на миг и гаснет.",
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = "Сколько длится вспышка «Долго», до 5 секунд: она появляется, задерживается на миг и гаснет.",
    ["Sound"] = "Звук",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = "Звук при каждой вспышке «%s». Стрелки перебирают звуки и проигрывают каждый; нажмите на название, чтобы услышать снова.",
    ["See-through"] = "Прозрачн.",
    ["How much of the game shows through the icon, in both styles. 0 is solid."]
        = "Насколько игра просвечивает сквозь значок, в обоих стилях. 0 означает непрозрачный.",
    ["Grows to"] = "Рост до",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "Насколько значок вырастает, пока гаснет, в процентах от размера, в обоих стилях. 100 оставляет размер прежним.",
    ["Border"] = "Рамка",
    ["A dark edge round the icon, in both styles: none, thin or thick."]
        = "Тёмная рамка вокруг значка, в обоих стилях: нет, узкая или широкая.",
    ["Shadow"] = "Тень",
    ["A soft shadow round the icon, in both styles, fading out from its edge."]
        = "Мягкая тень вокруг значка, в обоих стилях, угасающая от края.",
    ["Trinkets and potions too"] = "Также аксессуары и зелья",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "Ваши аксессуары, зелья, камни здоровья и другие используемые предметы в сумках. Вспыхивают только те, у которых есть восстановление.",
    ["Play at Master volume"] = "Звук на общей громкости",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "Проигрывает звук на общей громкости, чтобы его было слышно даже при тихих или выключенных звуковых эффектах. Ваши настройки звука не меняются.",
    ["Which cooldowns"] = "Что вспыхивает",
    ["tick the ones you want to pulse, then pick Quick or Long for each"]
        = "отметьте нужное, затем выберите для каждого «Быстро» или «Долго»",
    ["Untick to leave %s out."] = "Снимите отметку, чтобы убрать «%s».",
    ["Tick to pulse when %s is ready."] = "Отметьте для вспышки по готовности: %s.",
    [" (experimental)"] = " (экспериментально)",
    ["%s pulses %s."] = "%s: вспышка «%s».",
    ["Once ticked, %s pulses %s."] = "%s (после отметки): вспышка «%s».",
    ["Click for %s."] = "Нажмите, чтобы выбрать «%s».",
    ["Each style has its own size, time and sound, set under Edit above."]
        = "У каждого стиля свои размер, время и звук: они задаются в строке «Изменить» выше.",
    ["Spells"] = "Заклинания",
    ["Items"] = "Предметы",
    ["trinket"] = "аксессуар",
    ["none left"] = "закончились",
    ["in your bags"] = "в сумках",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "Пока ни у одного вашего заклинания нет своего восстановления. Новые появятся здесь, когда вы их выучите.",
    ["Preview"] = "Показ",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = "Сразу показывает вспышку «%s» с вашими настройками поверх окна, включена она или нет. Стиль выбирается в строке «Изменить».",
    ["Preview %s"] = "Показ «%s»",
    ["1 cooldown pulses when it's ready."] = "Отмечено для вспышки: 1.",
    ["%d cooldowns pulse when they're ready."] = "Отмечено для вспышки: %d.",
    ["Nothing to pulse yet: tick some below."] = "Пока ничего не вспыхивает: отметьте что-нибудь ниже.",
    ["Running in %s instead."] = "Работает в %s.",
    ["Off. Tick the box below to start."] = "Выключено. Поставьте отметку ниже, чтобы включить.",
    ["%s right"] = "%s вправо",
    ["%s left"] = "%s влево",
    ["%s up"] = "%s вверх",
    ["%s down"] = "%s вниз",
    ["Moved %s and %s from the middle."] = "Сдвинуто от центра: %s, %s.",
    ["Moved %s from the middle."] = "Сдвинуто от центра: %s.",
    ["In the middle of your screen."] = "В центре экрана.",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "все",
    ["you + %d"] = "вы + %d",
    ["you"] = "вы",
    ["unused"] = "никто",
    ["1 character"] = "1 персонаж",
    ["%d characters"] = "%d перс.",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = "Профиль этого персонажа: что отмечено для вспышки и для чего выбрано «Долго». Нажмите, чтобы увидеть все профили, сменить или создать новый.",
    ["Profiles"] = "Профили",
    ["You're using it, so you'll move to a new, empty profile of your own."]
        = "Вы используете его, поэтому получите новый пустой профиль.",
    ["Another character uses it, and loads %s at its next login."]
        = "Его использует другой персонаж: при следующем входе он загрузит %s.",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "Его использует другой персонаж: при следующем входе он получит новый пустой профиль.",
    ["%d other characters use it, and each loads %s at its next login."]
        = "Его используют другие персонажи (%d): при следующем входе каждый загрузит %s.",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "Его используют другие персонажи (%d): при следующем входе каждый получит новый пустой профиль.",
    ['Delete "%s"?'] = "Удалить «%s»?",
    ["This can't be undone."] = "Это нельзя отменить.",
    ["Delete"] = "Удалить",
    ["The profile you're on."] = "Текущий профиль.",
    ["Switch to %s."] = "Переключиться на %s.",
    ["Delete %s. It asks first."] = "Удалить %s (с подтверждением).",
    ["Profile name"] = "Имя профиля",
    ["A name for New, Copy or Rename."] = "Имя для кнопок «Создать», «Копировать» и «Сменить имя».",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "Нажмите на профиль, чтобы выбрать его, или на x, чтобы удалить. Введите имя, чтобы создать, скопировать или переименовать профиль. Профиль может быть общим для любых классов: каждый персонаж видит только свои заклинания.",
    ["Use on all characters"] = "Для всех персонажей",
    ["All your characters already use %s."] = "Все ваши персонажи уже используют %s.",
    ['Use "%s" on all characters?'] = "Использовать «%s» для всех персонажей?",
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "Его загрузят все персонажи, в том числе новые. Каждый видит только свои заклинания и предметы. Их прежние профили останутся в списке.",
    ["Use on all"] = "Для всех",
    ["All your characters use this profile, and new ones will too."]
        = "Этот профиль используют все ваши персонажи, в том числе новые.",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "Загружает текущий профиль для всех персонажей. Каждый видит только свои заклинания и предметы.",
    ["New"] = "Создать",
    ["Make a new, empty profile with the name typed above, and switch to it."]
        = "Создать новый пустой профиль с введённым выше именем и перейти на него.",
    ["Copy"] = "Копировать",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."]
        = "Скопировать ваши отметки в новый профиль с введённым выше именем и перейти на него.",
    ["Rename"] = "Сменить имя",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "Дать текущему профилю введённое выше имя. Оно сменится у всех персонажей с этим профилем.",
    ["Profile"] = "Профиль",
    ["loading..."] = "загрузка...",
    ["On all characters"] = "Уже у всех персонажей",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."]
        = "Перетащите, чтобы прокрутить список, или крутите над ним колесо мыши.",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "Нажмите Ctrl+C, чтобы скопировать, затем вставьте в браузер.",
    ["Close"] = "Закрыть",
    ["Join the Discord"] = "Вступить в Discord",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "Нашли ошибку или есть идея? Нажмите Ctrl+C, чтобы скопировать, затем вставьте в браузер.",
    ["Open"] = "Открыть",
    ["%s on %s"] = "%s на %s",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "Нажмите Ctrl+C, чтобы скопировать, затем вставьте в браузер. На CurseForge кнопка Install откроет приложение CurseForge.",
    ["%s on %s, as a link to copy."] = "%s на %s: ссылка для копирования.",
    ["Get it on CurseForge or GitHub: click one for its link."]
        = "Есть на CurseForge и GitHub: нажмите, чтобы получить ссылку.",
    ["Auto (game language)"] = "Авто (язык игры)",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish for Spain and Latin America; Traditional Chinese and any other game get English."]
        = "Язык этого окна, «Что нового» и сообщений аддона в чате. «Авто» использует язык игры, причём испанский один для Испании и Латинской Америки; в игре на традиционном китайском и других языках будет английский.",
    ["The language of this window, What's new and the addon's lines in chat."]
        = "Язык этого окна, «Что нового» и сообщений аддона в чате.",
    ["Help"] = "Справка",
    ["Take the tour"] = "Начать обзор",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."]
        = "Краткий обзор этого окна, страница за страницей. Его также запускает /fecp tour.",
    ["What's new"] = "Что нового",
    ["What changed in this version. /fecp new shows it too."] = "Изменения в этой версии. Их также показывает /fecp new.",
    ["Nothing yet: what changes in each update shows here."] = "Пока пусто: здесь будут изменения каждого обновления.",
    ["The Discord invite, ready to copy: bugs, ideas and help."]
        = "Приглашение в Discord для копирования: ошибки, идеи и помощь.",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "Обзор основ, изменения каждого обновления или Discord для ошибок, идей и помощи.",
    ["Minimap button"] = "Кнопка миникарты",
    ["Show the minimap button"] = "Показывать кнопку",
    ["A button on the minimap for these settings. Off, /fecp still opens them."]
        = "Кнопка у миникарты для этих настроек. Без неё настройки открывает /fecp.",
    ["Free-floating"] = "Свободное размещение",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "Кнопку можно перетащить в любое место экрана, а не только по краю миникарты. Она видна, даже если миникарта скрыта.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "Щелчок открывает эти настройки, правый щелчок открывает «Что нового». Перетаскивайте её по краю миникарты или куда угодно при свободном размещении.",
    ["Window accent"] = "Цвет окна",
    ["%s for this window's headings, ticks, sliders and highlights."]
        = "%s: цвет заголовков, отметок, ползунков и выделений этого окна.",
    ["Language"] = "Язык",
    ["About"] = "Об аддоне",
    ["Tell me when an update is out"] = "Сообщать о новой версии",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "Сообщение в чате (раз за сеанс), если вышла новая версия. Использует скрытый канал чата, который занимает одно из ваших мест для каналов.",
    ["More from Squirt"] = "Ещё от Squirt",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s, сборка прямо из исходников. Автор: Squirt. /fecp открывает это окно.",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."]
        = "%s, версия %s. Автор: Squirt. /fecp открывает это окно.",
    ["Cancel"] = "Отмена",
    ["Made with %s by %s"] = "С %s от %s",
    ["/fecp to open"] = "Открыть: /fecp",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "Профили: нажмите на профиль, чтобы выбрать его, или на x, чтобы удалить. Введите имя, чтобы создать, скопировать или переименовать профиль.",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "Здесь пока нечего показывать. Наведите курсор на что угодно, и эта строка расскажет, что это.",
    ["Page help"] = "Справка по странице",
    ["Walks you through this page, a step at a time."] = "Пошаговый обзор этой страницы.",
    ["New: click ? for help with any page"] = "Новое: нажмите ? для справки по любой странице",
    ["Put this note away. The ? stays, for help with any page."]
        = "Убрать подсказку. Кнопка ? останется для справки по любой странице.",
    ["Close the window. Escape closes it too, and /fecp opens it again."]
        = "Закрыть окно. Его также закрывает клавиша Esc, а /fecp открывает снова.",
    ["A big icon in the middle of your screen when a cooldown is ready."]
        = "Большой значок в центре экрана по окончании восстановления.",
    ["General"] = "Общие",
    ["The tour, What's new, the Discord, the minimap button, this window's accent, update notices and Squirt's other addons."]
        = "Обзор, «Что нового», Discord, кнопка миникарты, цвет окна, уведомления об обновлениях и другие аддоны Squirt.",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "Классический облик всего интерфейса WoW Forever и удобные настройки.",
    ["Installed. Type /era, or click Open."] = "Установлен. Введите /era или нажмите «Открыть».",
    ["Open EraUI's settings, as /era does."] = "Открыть настройки EraUI, как и /era.",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "Менеджер восстановления Blizzard в новом виде, плюс ваши полосы восстановления и эффектов.",
    ["Installed. Type /ccm, or click Open."] = "Установлен. Введите /ccm или нажмите «Открыть».",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."]
        = "Открыть настройки Forever Enhanced Cooldown Manager, как и /ccm.",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."]
        = "Это всё об этой странице. Нажмите ? в любой момент, чтобы посмотреть снова.",
    ["Click ? any time to see it again."] = "Нажмите ? в любой момент, чтобы посмотреть снова.",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "Это всё о новом. Посмотреть снова можно в любой момент через «Что нового» или командой /fecp new.",
    ["See it again any time from What's new, or with /fecp new."]
        = "Посмотреть снова можно в любой момент через «Что нового» или командой /fecp new.",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "Обзор окончен. Начать обзор можно в любой момент на странице «Общие» или командой /fecp tour.",
    ["Take the tour any time from the General page, or with /fecp tour."]
        = "Начать обзор можно в любой момент на странице «Общие» или командой /fecp tour.",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "Вспышка включена в %s, поэтому работает там, а эта отметка ждёт. Отключите её там, чтобы пользоваться этой.",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "Большой значок в центре экрана в момент окончания восстановления, в том числе в бою. Эта отметка включает и выключает вспышку.",
    ["Nothing to do here while it runs there."] = "Пока она работает там, здесь ничего делать не нужно.",
    ["It's already on."] = "Уже включено.",
    ["Next"] = "Далее",
    ["Back"] = "Назад",
    ["Skip tour"] = "Пропустить",
    ["%d of %d"] = "%d из %d",
    ["Welcome"] = "Добро пожаловать",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "Впервые пользуетесь %s? Краткий обзор покажет основы, страница за страницей. Это займёт около минуты.",
    ["Skip"] = "Пропустить",
    ["Turn it on"] = "Включите вспышку",
    ["Try it: tick it."] = "Попробуйте: поставьте отметку.",
    ["Pick your cooldowns"] = "Выберите, что вспыхивает",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "Все ваши заклинания с восстановлением, а также аксессуары и зелья. Отметьте нужное, затем выберите для каждого «Быстро» или «Долго».",
    ["Try it: tick one."] = "Попробуйте: отметьте что-нибудь.",
    ["You've ticked some already."] = "Вы уже кое-что отметили.",
    ["Quick and Long"] = "Быстро и Долго",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "У каждого стиля свои размер, время и звук. Выберите стиль в строке «Изменить»: «Размер», «Время» и «Звук» следуют за ним, а «Показ» проигрывает его.",
    ["Try it: pick Long, then Preview."] = "Попробуйте: выберите «Долго», затем нажмите «Показ».",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "«Сдвинуть» показывает рамку размером со вспышку: перетащите её, куда нужно, и нажмите «Готово». «Сбросить» вернёт её в центр.",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "Пройдите обзор снова, посмотрите «Что нового» или получите приглашение в Discord для помощи, ошибок и идей. Здесь же кнопка миникарты и цвет окна. /fecp открывает это окно.",
    ["Both styles"] = "Оба стиля",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "Прозрачность, рост, рамка и тень общие для «Быстро» и «Долго». Под ними: аксессуары и зелья в списке и звук на общей громкости.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "Щелчок открывает эти настройки, правый щелчок открывает «Что нового», а перетаскивание двигает её по краю миникарты. Снимите отметку, чтобы скрыть её: /fecp всё равно откроет настройки.",
    ["The colour of this window's headings, ticks, sliders and highlights."]
        = "Цвет заголовков, отметок, ползунков и выделений этого окна.",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "Язык этого окна, «Что нового» и сообщений аддона в чате. «Авто» использует язык игры. Меняется сразу.",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"]
        = "Щелчок: настройки\nПравый щелчок: «Что нового»\nПеретаскивание: куда угодно",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"]
        = "Щелчок: настройки\nПравый щелчок: «Что нового»\nПеретаскивание: по краю миникарты",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "В разработке",
    ["Version %s"] = "Версия %s",
    ["Found a bug or have an idea?"] = "Нашли ошибку? Есть идея?",
    ["/fecp new shows this again."] = "Открыть снова: /fecp new.",
    ["Got it"] = "Понятно",
    ["Show me what's new"] = "Показать новое",
    ["A quick tour of what's new, a page at a time."] = "Краткий обзор нового, страница за страницей.",
    ["Added"] = "Добавлено",
    ["Changed"] = "Изменено",
    ["Fixed"] = "Исправлено",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = "«Сообщать о новой версии» (страница «Общие»): сообщение в чате, когда выходит новая версия. Включено по умолчанию.",
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "Недостающие заклинания («Печать повиновения», «Шок небес», «Хладнокровие», «Озарение» и другие) теперь тоже вспыхивают.",
    ["Spell data updated for Forever's latest patch."] = "Данные заклинаний обновлены под последний патч Forever.",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "Кнопка у миникарты теперь появляется в новом месте, не мешая кнопкам других наших аддонов. Место, куда вы её перетащили, сохраняется.",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."]
        = "«Артишоковый чай» и ещё несколько видов еды и напитков с восстановлением теперь вспыхивают.",
    ["Read Leyline keeps its pulse tick after the game renamed it."]
        = "Read Leyline сохраняет отметку вспышки после того, как игра его переименовала.",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "Меньше нагрузки при изменении содержимого сумок, а данные заклинаний обновлены под последнюю сборку Forever.",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "Зелья переключаются на те, что у вас есть, а закончившийся предмет не вспыхивает.",
    ["Hover boxes widen to fit their title."] = "Всплывающие подсказки расширяются под свой заголовок.",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "Кнопку у миникарты можно разместить свободно: отметьте это на странице «Общие» и перетащите её куда угодно.",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "«Ещё от Squirt» на странице «Общие»: EraUI и Forever Enhanced Cooldown Manager.",
    ["Escape now closes the settings during a fight too."] = "Esc теперь закрывает настройки и в бою.",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "Настройки и «Что нового» закрываются вместе с другими окнами игры, например на экране загрузки.",
    ["The minimap button's tooltip now matches the addon's look."]
        = "Подсказка кнопки у миникарты теперь в стиле аддона.",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."]
        = "Большой значок в центре экрана, как только закончится отмеченное вами восстановление.",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "Стили «Быстро» и «Долго», у каждого свои размер, время и звук, а также 15 звуков и вариант с общей громкостью.",
    ["Trinkets, potions, healthstones and bag items can pulse too."]
        = "Вспыхивать могут и аксессуары, зелья, камни здоровья и предметы из сумок.",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "Работает вместе с Forever Enhanced Cooldown Manager: одновременно действует только одна вспышка.",
}
