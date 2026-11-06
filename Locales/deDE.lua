-- German (deDE) for Locale.lua: the text the addon shows, by its
-- English. Shown in the Language list as Deutsch. In the words of the
-- game's own German client, saying "du" as its interface does: Abklingzeit
-- for a cooldown, bereit for ready, Zauber, Gegenstand, Schmuckstück,
-- Trank, Gesundheitsstein, Profil, Minikarte (the minimap button
-- Minikarten-Button), im Kampf, Gesamtlautstärke for Master volume and
-- Soundeffekte. The pulse is der Puls (to pulse, pulsieren), its two
-- styles Kurz and Lang, in a sentence im Stil "Kurz"; to tick is anhaken
-- (a tick, der Haken), the General page Allgemein, What's new
-- Neuigkeiten, the tour die Tour, Edit Bearbeiten, a sound der Klang,
-- Grows to Endgröße. Ctrl+C is Strg+C, as German keyboards and the game's
-- German client name the key.
-- Reset is Zentrieren, as Zurücksetzen has no room on its button, and
-- Skip tour Beenden, Skip Nein danke, for the same reason.
--
-- Keep as they are: every %s, %d, %g, %.1f and %%, the same number in
-- the same order (the words round them can move, they can not); |c...|r
-- colour codes; \n line breaks; /fecp, /fecp tour, /fecp new, /era and
-- /ccm; Esc and the x that deletes; the names Discord,
-- CurseForge, GitHub, Install (CurseForge's button), EraUI, Squirt, WoW
-- Forever, Forever Enhanced Cooldown Manager and Forever Enhanced
-- Cooldown Pulse; and Read Leyline (the old name the game renamed).
-- No em or en dashes. Numbers keep their decimal point here (%g, %.1f):
-- the addon writes it as a comma for German (1,5 min).
--
-- Room, in the game's units (about 7.5 a letter, 6.5 in the small
-- font): the page names on the left (Cooldown pulse, General, Language)
-- 130; the labels before a slider or choice (Edit, Size, Shows for,
-- Sound, See-through, Grows to, Border) 88; buttons Preview %s
-- ("Preview Quick") 106, Take the tour, What's new and Got it 96, Show me
-- what's new 116, Move, Reset, Open and Done 76, Close, Cancel, Delete,
-- Use on all, New, Copy and Rename 86, Next, Back and Done in the tour
-- 60, Skip tour and Skip 72, Open settings 150; Quick and Long 43 each
-- on every row of the list (75 under Edit); None, Thin and Thick 35
-- each; a sound's name 112; the list's right column (45s, 1,5 min, in
-- your bags, none left, trinket) 90; the Shadow tick's label 64; the
-- seconds on Shows for ("1.0s") about 5 letters; who uses a profile 90;
-- an addon's line in More from Squirt two lines of 330. Tools/TestLocale.lua
-- checks it all fits.
--
-- Context: %s right, left, up and down are "100 right" (game units from
-- the middle), joined in Moved %s and %s from the middle. you, you + %d,
-- all characters and unused say who uses a profile. %s on %s is "EraUI
-- on CurseForge", a link box's title. Made with %s by %s is a heart, then
-- Squirt. Switch to %s. and You're already using %s. take a profile's
-- name or a language's own name (Deutsch). " (experimental)" keeps its
-- space, added to a hover note. %d of %d is the tour's "2 of 5".
-- Profile names can be up to %d characters: the game counts bytes
-- (48), and a letter with an accent, or in Cyrillic, takes two. The
-- cooldown pulse couldn't follow... starts small: it follows the
-- addon's name and a colon in chat.
--
-- Grouped by the file that shows each, as in zhCN.lua.
local _, ns = ...

ns.LOCALES.deDE = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "Profile können im Kampf nicht gewechselt werden.",
    ["Your profile hasn't loaded yet."] = "Dein Profil ist noch nicht geladen.",
    ["Type a profile name first."] = "Gib zuerst einen Profilnamen ein.",
    ["Profile names can be up to %d characters."] = "Profilnamen dürfen höchstens %d Zeichen haben (ä, ö, ü und ß zählen doppelt).",
    ["Profile names can't use the | character."] = "Profilnamen dürfen das Zeichen | nicht enthalten.",
    ['No profile is called "%s".'] = 'Es gibt kein Profil namens "%s".',
    ["You're already using %s."] = "Du verwendest bereits %s.",
    ["Now using %s."] = "Du verwendest jetzt %s.",
    ["%s already exists."] = "%s gibt es bereits.",
    ["Copied your ticks to %s, and switched to it."] = "Deine Haken in %s kopiert und dorthin gewechselt.",
    ["Made %s, and switched to it."] = "%s erstellt und dorthin gewechselt.",
    ["All your characters use %s now, and new ones will too."] = "Alle deine Charaktere verwenden jetzt %s, neue ebenso.",
    ["That's already its name."] = "So heißt es bereits.",
    ["Renamed to %s."] = "Umbenannt in %s.",
    ["Deleted %s. You're now on %s."] = "%s gelöscht. Du verwendest jetzt %s.",
    ["Deleted %s."] = "%s gelöscht.",
    ["%s %s is out (you have %s). Update on CurseForge."] = "%s %s ist erschienen (du hast %s). Aktualisiere über CurseForge.",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "Ein großes Symbol mitten auf deinem Bildschirm, sobald eine Abklingzeit bereit ist. Für die Einstellungen gib /fecp ein, klicke auf den Minikarten-Button oder unten.",
    ["Open settings"] = "Einstellungen öffnen",
    ["None"] = "Kein",
    ["Thin"] = "Dünn",
    ["Thick"] = "Dick",
    ["Chime"] = "Klangspiel",
    ["Bell"] = "Glocke",
    ["Bell trill"] = "Glockentriller",
    ["Shimmer bell"] = "Schimmerglocke",
    ["Magic chimes"] = "Zauberklänge",
    ["Shimmer"] = "Schimmer",
    ["Zippy magic"] = "Flinke Magie",
    ["Synth"] = "Synthesizer",
    ["Pitch pipe"] = "Stimmpfeife",
    ["Brass"] = "Blechbläser",
    ["War horn"] = "Kriegshorn",
    ["Fanfare"] = "Fanfare",
    ["Gold"] = "Gold",
    ["Jackpot bell"] = "Jackpot-Glocke",
    ["Anvil"] = "Amboss",
    ["Quick"] = "Kurz",
    ["Long"] = "Lang",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."]
        = "Der Abklingzeit-Puls ist in %s aktiv. Schalte ihn dort aus, um diesen hier zu nutzen.",

    -- Theme.lua: the accents.
    ["Orange"] = "Orange",
    ["Blue"] = "Blau",
    ["Teal"] = "Türkis",
    ["Purple"] = "Lila",
    ["Green"] = "Grün",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "Gegenstand %d",
    ["Trinket %d: %s"] = "Schmuckstück %d: %s",
    ["Healthstones"] = "Gesundheitssteine",
    ["Healing Potions"] = "Heiltränke",
    ["Mana Potions"] = "Manatränke",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"]
        = "der Abklingzeit-Puls konnte eine Abklingzeit nicht verfolgen. Bitte melde das: %s",
    ["Finish the fight first, then move it."] = "Beende erst den Kampf, dann verschiebe ihn.",
    ["Cooldown pulse"] = "Abklingzeit-Puls",
    ["Done"] = "Fertig",
    ["Drag the box, then click Done or right-click it."] = "Ziehe den Rahmen und klicke dann auf Fertig oder mache einen Rechtsklick darauf.",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%gs",
    ["%g min"] = "%g min",
    ["%g hour"] = "%g Stunde",
    ["%g hours"] = "%g Stunden",
    ["On your screen"] = "Auf dem Bildschirm",
    ["Up close"] = "Nahansicht",
    ["Where it shows"] = "Position",
    ["Move"] = "Verschieben",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "Zeigt einen Rahmen in der Größe des unter Bearbeiten gewählten Stils. Ziehe ihn dorthin, wo der Puls erscheinen soll, und klicke dann auf Fertig. Beide Stile erscheinen dort.",
    ["Reset"] = "Zentrieren",
    ["The pulse is back in the middle of your screen."] = "Der Puls ist wieder in der Mitte deines Bildschirms.",
    ["Puts the pulse back in the middle of your screen."] = "Setzt den Puls zurück in die Mitte deines Bildschirms.",
    ["Pulse an icon when a cooldown is ready"] = "Symbol pulsieren lassen, wenn eine Abklingzeit bereit ist",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "Ein großes Symbol mitten auf deinem Bildschirm, sobald eine Abklingzeit bereit ist, auch im Kampf. Es fängt nie Mausklicks ab.",
    ["%.1fs"] = "%.1fs",
    ["Edit"] = "Bearbeiten",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "Kurz und Lang haben jeweils eigene Werte für Größe, Dauer und Klang: Wähle hier, welchen Stil du unten einstellst. Vorschau spielt ihn ab.",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = 'Wie groß ein Puls im Stil "%s" ist, in Spieleinheiten: 320 ist etwa ein Drittel deiner Bildschirmhöhe.',
    ["Size"] = "Größe",
    ["Shows for"] = "Dauer",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = 'Wie lange ein Puls im Stil "Kurz" dauert, bis zu 2 Sekunden: Er taucht auf, bleibt einen Moment und blendet dann aus.',
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = 'Wie lange ein Puls im Stil "Lang" dauert, bis zu 5 Sekunden: Er taucht auf, bleibt einen Moment und blendet dann aus.',
    ["Sound"] = "Klang",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = 'Ein Klang zu jedem Puls im Stil "%s". Die Pfeile blättern durch die Klänge und spielen jeden ab; klicke auf den Namen, um ihn noch einmal zu hören.',
    ["See-through"] = "Transparenz",
    ["How much of the game shows through the icon, in both styles. 0 is solid."]
        = "Wie viel vom Spiel durch das Symbol scheint, in beiden Stilen. 0 ist deckend.",
    ["Grows to"] = "Endgröße",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "Wie groß das Symbol beim Ausblenden wird, in Prozent seiner Größe, in beiden Stilen. Bei 100 bleibt es gleich groß.",
    ["Border"] = "Rand",
    ["A dark edge round the icon, in both styles: none, thin or thick."]
        = "Ein dunkler Rand um das Symbol, in beiden Stilen: kein, dünn oder dick.",
    ["Shadow"] = "Schatten",
    ["A soft shadow round the icon, in both styles, fading out from its edge."]
        = "Ein weicher Schatten um das Symbol, der von seinem Rand aus verblasst, in beiden Stilen.",
    ["Trinkets and potions too"] = "Auch Schmuckstücke und Tränke",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "Deine Schmuckstücke, Tränke, Gesundheitssteine und andere benutzbare Gegenstände in deinen Taschen. Nur solche mit Abklingzeit pulsieren.",
    ["Play at Master volume"] = "Mit Gesamtlautstärke abspielen",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "Spielt den Klang mit deiner Gesamtlautstärke ab, damit du ihn auch bei leisen oder ausgeschalteten Soundeffekten hörst. Deine Soundeinstellungen bleiben unverändert.",
    ["Which cooldowns"] = "Welche Abklingzeiten",
    ["tick the ones you want to pulse, then pick Quick or Long for each"]
        = "hake an, was pulsieren soll, und wähle dann jeweils Kurz oder Lang",
    ["Untick to leave %s out."] = "Haken entfernen, um %s auszulassen.",
    ["Tick to pulse when %s is ready."] = "Anhaken, damit %s pulsiert, sobald bereit.",
    [" (experimental)"] = " (experimentell)",
    ["%s pulses %s."] = '%s pulsiert im Stil "%s".',
    ["Once ticked, %s pulses %s."] = 'Angehakt pulsiert %s im Stil "%s".',
    ["Click for %s."] = 'Klicke, um zum Stil "%s" zu wechseln.',
    ["Each style has its own size, time and sound, set under Edit above."]
        = "Jeder Stil hat eigene Werte für Größe, Dauer und Klang, einstellbar oben unter Bearbeiten.",
    ["Spells"] = "Zauber",
    ["Items"] = "Gegenstände",
    ["trinket"] = "Schmuckstück",
    ["none left"] = "keine mehr",
    ["in your bags"] = "in der Tasche",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "Noch hat keiner deiner Zauber eine eigene Abklingzeit. Neue erscheinen hier, sobald du sie lernst.",
    ["Preview"] = "Vorschau",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = 'Zeigt jetzt einen Puls im Stil "%s" mit deinen Einstellungen über diesem Fenster, auch wenn er aus ist. Bearbeiten wählt den Stil.',
    ["Preview %s"] = "Vorschau: %s",
    ["1 cooldown pulses when it's ready."] = "1 Abklingzeit pulsiert, wenn sie bereit ist.",
    ["%d cooldowns pulse when they're ready."] = "%d Abklingzeiten pulsieren, wenn sie bereit sind.",
    ["Nothing to pulse yet: tick some below."] = "Noch nichts zum Pulsieren: Hake unten welche an.",
    ["Running in %s instead."] = "Läuft stattdessen in %s.",
    ["Off. Tick the box below to start."] = "Aus. Setze unten den Haken, um zu starten.",
    ["%s right"] = "%s nach rechts",
    ["%s left"] = "%s nach links",
    ["%s up"] = "%s nach oben",
    ["%s down"] = "%s nach unten",
    ["Moved %s and %s from the middle."] = "Um %s und %s aus der Mitte verschoben.",
    ["Moved %s from the middle."] = "Um %s aus der Mitte verschoben.",
    ["In the middle of your screen."] = "In der Mitte deines Bildschirms.",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "alle",
    ["you + %d"] = "du + %d",
    ["you"] = "du",
    ["unused"] = "ungenutzt",
    ["1 character"] = "1 Charakter",
    ["%d characters"] = "%d Charaktere",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = 'Das Profil dieses Charakters: was zum Pulsieren angehakt ist und was im Stil "Lang" pulsiert. Klicke, um alle Profile zu sehen, zu wechseln oder eins zu erstellen.',
    ["Profiles"] = "Profile",
    ["You're using it, so you'll move to a new, empty profile of your own."]
        = "Du verwendest es, also wechselst du zu einem neuen, leeren eigenen Profil.",
    ["Another character uses it, and loads %s at its next login."]
        = "Ein anderer Charakter verwendet es und lädt beim nächsten Einloggen %s.",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "Ein anderer Charakter verwendet es und bekommt beim nächsten Einloggen ein neues, leeres eigenes Profil.",
    ["%d other characters use it, and each loads %s at its next login."]
        = "%d andere Charaktere verwenden es, und jeder lädt beim nächsten Einloggen %s.",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "%d andere Charaktere verwenden es, und jeder bekommt beim nächsten Einloggen ein neues, leeres eigenes Profil.",
    ['Delete "%s"?'] = '"%s" löschen?',
    ["This can't be undone."] = "Das lässt sich nicht rückgängig machen.",
    ["Delete"] = "Löschen",
    ["The profile you're on."] = "Das Profil, das du verwendest.",
    ["Switch to %s."] = "Zu %s wechseln.",
    ["Delete %s. It asks first."] = "%s löschen. Vorher wird nachgefragt.",
    ["Profile name"] = "Profilname",
    ["A name for New, Copy or Rename."] = "Ein Name für Neu, Kopieren oder Umbenennen.",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "Klicke auf ein Profil, um es zu verwenden, oder auf x, um es zu löschen. Gib einen Namen ein, um eins zu erstellen, zu kopieren oder umzubenennen. Alle Klassen können ein Profil teilen: Jeder Charakter listet nur seine eigenen Zauber.",
    ["Use on all characters"] = "Für alle Charaktere verwenden",
    ["All your characters already use %s."] = "Alle deine Charaktere verwenden bereits %s.",
    ['Use "%s" on all characters?'] = '"%s" für alle Charaktere verwenden?',
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "Jeder Charakter, auch jeder später erstellte, lädt es. Jeder listet nur seine eigenen Zauber und Gegenstände. Ihre eigenen Profile bleiben in dieser Liste.",
    ["Use on all"] = "Für alle",
    ["All your characters use this profile, and new ones will too."]
        = "Alle deine Charaktere verwenden dieses Profil, neue ebenso.",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "Lädt dein aktuelles Profil für jeden Charakter. Jeder listet nur seine eigenen Zauber und Gegenstände.",
    ["New"] = "Neu",
    ["Make a new, empty profile with the name typed above, and switch to it."]
        = "Erstellt ein neues, leeres Profil mit dem oben eingegebenen Namen und wechselt dorthin.",
    ["Copy"] = "Kopieren",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."]
        = "Kopiert deine Haken in ein neues Profil mit dem oben eingegebenen Namen und wechselt dorthin.",
    ["Rename"] = "Umbenennen",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "Gibt deinem aktuellen Profil den oben eingegebenen Namen, für jeden Charakter, der es verwendet.",
    ["Profile"] = "Profil",
    ["loading..."] = "lädt...",
    ["On all characters"] = "Für alle Charaktere aktiv",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."]
        = "Ziehe, um durch die Liste zu blättern, oder drehe darüber das Mausrad.",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "Drücke Strg+C zum Kopieren und füge den Link dann in deinen Browser ein.",
    ["Close"] = "Schließen",
    ["Join the Discord"] = "Discord beitreten",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "Fehler gefunden? Eine Idee? Drücke Strg+C zum Kopieren und füge den Link dann in deinen Browser ein.",
    ["Open"] = "Öffnen",
    ["%s on %s"] = "%s auf %s",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "Drücke Strg+C zum Kopieren und füge den Link dann in deinen Browser ein. Auf CurseForge öffnet Install die CurseForge-App.",
    ["%s on %s, as a link to copy."] = "%s auf %s, als Link zum Kopieren.",
    ["Get it on CurseForge or GitHub: click one for its link."]
        = "Erhältlich auf CurseForge oder GitHub: Klicke für den Link.",
    ["Auto (game language)"] = "Auto (Spielsprache)",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish for Spain and Latin America; Traditional Chinese and any other game get English."]
        = "Die Sprache dieses Fensters, der Neuigkeiten und der Chatzeilen des Addons. Auto folgt der Sprache deines Spiels, mit einem gemeinsamen Spanisch für Spanien und Lateinamerika; bei traditionellem Chinesisch und allen anderen Sprachen erscheint Englisch.",
    ["The language of this window, What's new and the addon's lines in chat."]
        = "Die Sprache dieses Fensters, der Neuigkeiten und der Chatzeilen des Addons.",
    ["Help"] = "Hilfe",
    ["Take the tour"] = "Tour starten",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."]
        = "Eine kurze Tour durch dieses Fenster, Seite für Seite. /fecp tour startet sie auch.",
    ["What's new"] = "Neuigkeiten",
    ["What changed in this version. /fecp new shows it too."] = "Was sich in dieser Version geändert hat. /fecp new zeigt es auch.",
    ["Nothing yet: what changes in each update shows here."] = "Noch nichts: Was sich mit jedem Update ändert, steht hier.",
    ["The Discord invite, ready to copy: bugs, ideas and help."]
        = "Die Discord-Einladung zum Kopieren: Fehler, Ideen und Hilfe.",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "Eine Tour durch die Grundlagen, was sich mit jedem Update geändert hat, oder der Discord für Fehler, Ideen und Hilfe.",
    ["Minimap button"] = "Minikarten-Button",
    ["Show the minimap button"] = "Minikarten-Button anzeigen",
    ["A button on the minimap for these settings. Off, /fecp still opens them."]
        = "Ein Button an der Minikarte für diese Einstellungen. Ist er aus, öffnet /fecp sie trotzdem.",
    ["Free-floating"] = "Frei platzierbar",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "Ziehe den Button an jede Stelle des Bildschirms, nicht nur um die Minikarte. Er erscheint auch bei ausgeblendeter Minikarte.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "Linksklick öffnet diese Einstellungen, Rechtsklick die Neuigkeiten. Ziehe ihn um die Minikarte oder, wenn er frei platzierbar ist, an jede Stelle.",
    ["Window accent"] = "Akzentfarbe",
    ["%s for this window's headings, ticks, sliders and highlights."]
        = "%s für Überschriften, Haken, Schieberegler und Hervorhebungen dieses Fensters.",
    ["Language"] = "Sprache",
    ["About"] = "Info",
    ["Tell me when an update is out"] = "Über Updates informieren",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "Eine Chatzeile, einmal pro Sitzung, wenn eine neuere Version erschienen ist. Dafür wird ein versteckter Chatkanal genutzt, der einen deiner Chatkanal-Plätze belegt.",
    ["More from Squirt"] = "Mehr von Squirt",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s, eine Kopie direkt aus dem Quellcode. Erstellt von Squirt. /fecp öffnet dieses Fenster.",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."]
        = "%s Version %s. Erstellt von Squirt. /fecp öffnet dieses Fenster.",
    ["Cancel"] = "Abbrechen",
    ["Made with %s by %s"] = "Mit %s gemacht von %s",
    ["/fecp to open"] = "/fecp zum Öffnen",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "Profile: Klicke eins an, um es zu verwenden, oder x, um es zu löschen. Gib einen Namen ein, um eins zu erstellen, zu kopieren oder umzubenennen.",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "Hier gibt es noch nichts zu zeigen. Fahre mit der Maus über etwas, und diese Zeile sagt, was es tut.",
    ["Page help"] = "Seitenhilfe",
    ["Walks you through this page, a step at a time."] = "Führt dich Schritt für Schritt durch diese Seite.",
    ["New: click ? for help with any page"] = "Neu: Klicke auf ? für Hilfe zu jeder Seite",
    ["Put this note away. The ? stays, for help with any page."]
        = "Diesen Hinweis ausblenden. Das ? bleibt, für Hilfe zu jeder Seite.",
    ["Close the window. Escape closes it too, and /fecp opens it again."]
        = "Schließt das Fenster. Esc schließt es auch, und /fecp öffnet es wieder.",
    ["A big icon in the middle of your screen when a cooldown is ready."]
        = "Ein großes Symbol mitten auf deinem Bildschirm, wenn eine Abklingzeit bereit ist.",
    ["General"] = "Allgemein",
    ["The tour, What's new, the Discord, the minimap button, this window's accent, update notices and Squirt's other addons."]
        = "Die Tour, Neuigkeiten, der Discord, der Minikarten-Button, die Akzentfarbe, Update-Hinweise und Squirts andere Addons.",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "Der Classic-Look für die ganze Oberfläche von WoW Forever, mit Komfortfunktionen.",
    ["Installed. Type /era, or click Open."] = "Installiert. Gib /era ein oder klicke auf Öffnen.",
    ["Open EraUI's settings, as /era does."] = "Öffnet die Einstellungen von EraUI, wie /era.",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "Blizzards Abklingzeitmanager im neuen Stil, dazu eigene Abklingzeit-, Buff- und Zauberleisten.",
    ["Installed. Type /ccm, or click Open."] = "Installiert. Gib /ccm ein oder klicke auf Öffnen.",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."]
        = "Öffnet die Einstellungen von Forever Enhanced Cooldown Manager, wie /ccm.",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."] = "Das war diese Seite. Klicke jederzeit auf ?, um das noch einmal zu sehen.",
    ["Click ? any time to see it again."] = "Klicke jederzeit auf ?, um das noch einmal zu sehen.",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "Das waren die Neuigkeiten. Sieh sie dir jederzeit wieder über Neuigkeiten oder mit /fecp new an.",
    ["See it again any time from What's new, or with /fecp new."]
        = "Sieh sie dir jederzeit wieder über Neuigkeiten oder mit /fecp new an.",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "Das war die Tour. Starte sie jederzeit auf der Seite Allgemein oder mit /fecp tour.",
    ["Take the tour any time from the General page, or with /fecp tour."]
        = "Starte die Tour jederzeit auf der Seite Allgemein oder mit /fecp tour.",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "Der Abklingzeit-Puls ist in %s aktiv, er läuft also dort, und dieser Haken wartet. Schalte ihn dort aus, um diesen hier zu nutzen.",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "Ein großes Symbol mitten auf deinem Bildschirm, sobald eine Abklingzeit bereit ist, auch im Kampf. Dieser Haken schaltet es ein oder aus.",
    ["Nothing to do here while it runs there."] = "Hier ist nichts zu tun, solange er dort läuft.",
    ["It's already on."] = "Bereits eingeschaltet.",
    ["Next"] = "Weiter",
    ["Back"] = "Zurück",
    ["Skip tour"] = "Beenden",
    ["%d of %d"] = "%d von %d",
    ["Welcome"] = "Willkommen",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "Neu bei %s? Eine kurze Tour zeigt dir die Grundlagen, Seite für Seite. Sie dauert etwa eine Minute.",
    ["Skip"] = "Nein danke",
    ["Turn it on"] = "Einschalten",
    ["Try it: tick it."] = "Probier es aus: Setze den Haken.",
    ["Pick your cooldowns"] = "Abklingzeiten wählen",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "Jeder Zauber mit Abklingzeit, den du kennst, dazu deine Schmuckstücke und Tränke. Hake an, was pulsieren soll, und wähle dann jeweils Kurz oder Lang.",
    ["Try it: tick one."] = "Probier es aus: Hake eine Abklingzeit an.",
    ["You've ticked some already."] = "Du hast schon welche angehakt.",
    ["Quick and Long"] = "Kurz und Lang",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "Jeder Stil hat eigene Werte für Größe, Dauer und Klang. Wähle einen unter Bearbeiten: Größe, Dauer und Klang folgen ihm, und Vorschau spielt ihn ab.",
    ["Try it: pick Long, then Preview."] = "Probier es aus: Wähle Lang, dann Vorschau.",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "Verschieben zeigt einen Rahmen so groß wie der Puls: Ziehe ihn an die gewünschte Stelle und klicke dann auf Fertig. Zentrieren setzt ihn zurück in die Mitte.",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "Starte diese Tour erneut, sieh dir die Neuigkeiten an oder hol dir die Discord-Einladung für Hilfe, Fehler und Ideen. Der Minikarten-Button und die Akzentfarbe sind auch hier. /fecp öffnet dieses Fenster.",
    ["Both styles"] = "Beide Stile",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "Transparenz, Endgröße, Rand und Schatten gelten für Kurz und Lang gleichermaßen. Darunter: deine Schmuckstücke und Tränke in der Liste und der Klang mit Gesamtlautstärke.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "Linksklick öffnet diese Einstellungen, Rechtsklick die Neuigkeiten. Ziehe ihn um die Minikarte. Entferne den Haken, um ihn auszublenden: /fecp öffnet sie trotzdem.",
    ["The colour of this window's headings, ticks, sliders and highlights."]
        = "Die Farbe der Überschriften, Haken, Schieberegler und Hervorhebungen dieses Fensters.",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "Die Sprache dieses Fensters, der Neuigkeiten und der Chatzeilen des Addons. Auto folgt der Sprache deines Spiels. Der Wechsel gilt sofort.",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"]
        = "Klick: Einstellungen\nRechtsklick: Neuigkeiten\nZiehen: beliebig verschieben",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"]
        = "Klick: Einstellungen\nRechtsklick: Neuigkeiten\nZiehen: um die Minikarte verschieben",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "Unveröffentlicht",
    ["Version %s"] = "Version %s",
    ["Found a bug or have an idea?"] = "Fehler gefunden? Eine Idee?",
    ["/fecp new shows this again."] = "/fecp new zeigt das erneut.",
    ["Got it"] = "Verstanden",
    ["Show me what's new"] = "Neues zeigen",
    ["A quick tour of what's new, a page at a time."] = "Eine kurze Tour durch das Neue, Seite für Seite.",
    ["Added"] = "Neu",
    ["Changed"] = "Geändert",
    ["Fixed"] = "Behoben",
    ["Spell data updated for this week's Forever patch, like Shank and Reckless Swings."]
        = "Zauberdaten für den Forever-Patch dieser Woche aktualisiert, etwa Shank und Reckless Swings.",
    ["The pulse no longer goes off in a fight for a spell that's already ready, for players still seeing it after 1.0.7."]
        = "Der Puls geht im Kampf nicht mehr für einen Zauber los, der schon bereit ist, auch für alle, die das nach 1.0.7 noch sahen.",
    ["The pulse no longer goes off again and again in a fight for a spell that's already ready."]
        = "Der Puls geht im Kampf nicht mehr immer wieder für einen Zauber los, der schon bereit ist.",
    ["Spell data updated for launch."]
        = "Zauberdaten für den Launch aktualisiert.",
    ["The list shows Slam at 15 sec, Stormstrike 6, Riptide 12 and Totemic Call 30."]
        = "Die Liste zeigt Zerschmettern mit 15 Sek., Sturmschlag 6, Springflut 12 und Totemruf 30.",
    ["Ice Lance can be pulsed at every rank (8 sec), not just rank 1."]
        = "Eislanze kann auf jedem Rang pulsieren (8 Sek.), nicht nur auf Rang 1.",
    ["Elemental Mastery and Totemic Projection keep their tick when the game renames them."]
        = "Elementarbeherrschung und Totemprojektion bleiben angehakt, wenn das Spiel sie umbenennt.",
    ["Simplified Chinese, German, French, Spanish, Brazilian Portuguese and Russian: pick one on the Language page under General. Auto follows your game's language."]
        = "Vereinfachtes Chinesisch, Deutsch, Französisch, Spanisch, brasilianisches Portugiesisch und Russisch: Wähle eine Sprache auf der Seite Sprache unter Allgemein. Auto folgt der Sprache deines Spiels.",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = '"Über Updates informieren" (Seite Allgemein): eine Chatzeile, sobald eine neuere Version erschienen ist. Standardmäßig an.',
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "Fehlende Zauber (Siegel des Befehls, Heiliger Schock, Kaltblütigkeit, Anregen und mehr) können jetzt pulsieren.",
    ["Spell data updated for Forever's latest patch."] = "Zauberdaten für den neuesten Patch von Forever aktualisiert.",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "Der Minikarten-Button startet an einer neuen Stelle, abseits der Buttons unserer anderen Addons. Hast du ihn verschoben, bleibt er dort.",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."]
        = "Disteltee und die wenigen anderen Speisen und Getränke mit Abklingzeit pulsieren jetzt.",
    ["Read Leyline keeps its pulse tick after the game renamed it."]
        = "Read Leyline behält seinen Haken, auch nachdem das Spiel den Zauber umbenannt hat.",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "Weniger Rechenaufwand, wenn sich deine Taschen ändern, und Zauberdaten für den neuesten Build von Forever aktualisiert.",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "Tränke wechseln zu dem Trank, den du dabeihast, und ein aufgebrauchter Gegenstand pulsiert nicht.",
    ["Hover boxes widen to fit their title."] = "Tooltips werden breiter, damit ihr Titel hineinpasst.",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "Der Minikarten-Button lässt sich frei platzieren: Setze den Haken auf der Seite Allgemein und ziehe ihn dann an jede Stelle.",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "Mehr von Squirt auf der Seite Allgemein: EraUI und Forever Enhanced Cooldown Manager.",
    ["Escape now closes the settings during a fight too."] = "Esc schließt die Einstellungen jetzt auch im Kampf.",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "Die Einstellungen und die Neuigkeiten schließen sich zusammen mit den anderen Fenstern des Spiels, zum Beispiel bei einem Ladebildschirm.",
    ["The minimap button's tooltip now matches the addon's look."]
        = "Der Tooltip des Minikarten-Buttons passt jetzt zum Look des Addons.",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."]
        = "Ein großes Symbol mitten auf deinem Bildschirm, sobald eine angehakte Abklingzeit bereit ist.",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "Die Stile Kurz und Lang, jeder mit eigener Größe, Dauer und eigenem Klang, dazu 15 Klänge und eine Option für die Gesamtlautstärke.",
    ["Trinkets, potions, healthstones and bag items can pulse too."]
        = "Auch Schmuckstücke, Tränke, Gesundheitssteine und Gegenstände aus den Taschen können pulsieren.",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "Funktioniert zusammen mit Forever Enhanced Cooldown Manager: Es läuft immer nur ein Puls.",
}
