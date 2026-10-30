-- French (frFR) for Locale.lua: the text the addon shows, by its English.
-- Shown in the Language list as Français. In the words of the game's own
-- French client, with "vous": temps de recharge for a cooldown, prêt for
-- ready, sort, objet, bijou, potion, pierre de soins, profil, minicarte, en
-- combat, options for the settings, Échap, infobulle, volume principal. The
-- pulse is la pulsation (Pulsation, the page), its two styles Rapide and
-- Longue (the style is masculine: le style Longue); to pulse is signaler; to
-- tick is cocher (what's ticked: les cases cochées); the General page
-- Général, What's new Nouveautés, the tour la visite (Visite guidée). The
-- border's choices are masculine (le contour): Aucun, Fin, Épais. Spells
-- in the notes have the French client's names. A plain space before : ; ! ?
-- and inside « », everywhere (safe in any of the game's fonts). Cooldowns in
-- the list as 45 s, 1,5 min, 2 h (the addon writes the decimal comma).
-- Titles of the tour's steps in the infinitive or as a noun, as the game's
-- own French windows have them.
--
-- Room, in the game's units (about 7.5 a letter, 6.5 in the small font):
-- the page names on the left 130; the labels before a slider or choice
-- (Modifier, Taille, Durée, Son, Transparent, Grandit à, Contour) 88, so
-- Transparence doesn't fit; Aperçu (%s) 106; Visite guidée, Nouveautés and
-- Compris 96; Montrez-moi 116; Déplacer, Recentrer, Ouvrir and Terminé 76;
-- Fermer, Annuler, Supprimer, Utiliser, Nouveau, Copier and Renommer 86;
-- Suivant, Retour and Terminé in the tour 60; Quitter and Passer 72; Ouvrir
-- les options 150; Rapide and Longue 43 each on every row of the list;
-- Aucun, Fin and Épais 35 each (so Bordure, whose Aucune is too wide, isn't
-- used); a sound's name 112; the list's right column 90; who uses a profile
-- 90 (so tous, not tous les personnages). Tools/TestLocale.lua checks it
-- all fits. The same English always gets the same French. Grouped by the
-- file that shows each, as in zhCN.lua.
local _, ns = ...

ns.LOCALES.frFR = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "Impossible de changer de profil en combat.",
    ["Your profile hasn't loaded yet."] = "Votre profil n'est pas encore chargé.",
    ["Type a profile name first."] = "Saisissez d'abord un nom de profil.",
    ["Profile names can be up to %d characters."] = "Un nom de profil ne peut pas dépasser %d caractères (une lettre accentuée compte double).",
    ["Profile names can't use the | character."] = "Un nom de profil ne peut pas contenir le caractère |.",
    ['No profile is called "%s".'] = "Aucun profil ne s'appelle « %s ».",
    ["You're already using %s."] = "Vous utilisez déjà %s.",
    ["Now using %s."] = "Vous utilisez maintenant %s.",
    ["%s already exists."] = "%s existe déjà.",
    ["Copied your ticks to %s, and switched to it."] = "Vos cases cochées sont copiées dans %s, que vous utilisez maintenant.",
    ["Made %s, and switched to it."] = "%s créé. Vous l'utilisez maintenant.",
    ["All your characters use %s now, and new ones will too."] = "Tous vos personnages utilisent maintenant %s, et les nouveaux aussi.",
    ["That's already its name."] = "C'est déjà son nom.",
    ["Renamed to %s."] = "Renommé en %s.",
    ["Deleted %s. You're now on %s."] = "%s supprimé. Vous utilisez maintenant %s.",
    ["Deleted %s."] = "%s supprimé.",
    ["%s %s is out (you have %s). Update on CurseForge."] = "%s %s est disponible (vous avez la %s). Mettez à jour sur CurseForge.",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "Une grande icône au centre de votre écran dès qu'un temps de recharge est prêt. Pour les options, tapez /fecp, cliquez sur le bouton de la minicarte ou cliquez ci-dessous.",
    ["Open settings"] = "Ouvrir les options",
    ["None"] = "Aucun",
    ["Thin"] = "Fin",
    ["Thick"] = "Épais",
    ["Chime"] = "Carillon",
    ["Bell"] = "Cloche",
    ["Bell trill"] = "Trille de cloche",
    ["Shimmer bell"] = "Cloche chatoyante",
    ["Magic chimes"] = "Carillon magique",
    ["Shimmer"] = "Chatoiement",
    ["Zippy magic"] = "Magie pétillante",
    ["Synth"] = "Synthé",
    ["Pitch pipe"] = "Diapason",
    ["Brass"] = "Cuivres",
    ["War horn"] = "Cor de guerre",
    ["Fanfare"] = "Fanfare",
    ["Gold"] = "Pièces d'or",
    ["Jackpot bell"] = "Cloche du jackpot",
    ["Anvil"] = "Enclume",
    ["Quick"] = "Rapide",
    ["Long"] = "Longue",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."]
        = "La pulsation de recharge est activée dans %s. Désactivez-la là-bas pour utiliser celle-ci.",

    -- Theme.lua: the accents.
    ["Orange"] = "Orange",
    ["Blue"] = "Bleu",
    ["Teal"] = "Turquoise",
    ["Purple"] = "Violet",
    ["Green"] = "Vert",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "Objet %d",
    ["Trinket %d: %s"] = "Bijou %d : %s",
    ["Healthstones"] = "Pierres de soins",
    ["Healing Potions"] = "Potions de soins",
    ["Mana Potions"] = "Potions de mana",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"]
        = "la pulsation n'a pas pu suivre un temps de recharge. Merci de nous le signaler : %s",
    ["Finish the fight first, then move it."] = "Terminez d'abord le combat, puis déplacez-la.",
    ["Cooldown pulse"] = "Pulsation",
    ["Done"] = "Terminé",
    ["Drag the box, then click Done or right-click it."] = "Faites glisser le cadre, puis cliquez sur Terminé ou faites un clic droit dessus.",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%g s",
    ["%g min"] = "%g min",
    ["%g hour"] = "%g h",
    ["%g hours"] = "%g h",
    ["On your screen"] = "Sur votre écran",
    ["Up close"] = "Gros plan",
    ["Where it shows"] = "Emplacement",
    ["Move"] = "Déplacer",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "Affiche un cadre de la taille du style choisi sous Modifier. Placez-le à l'endroit voulu, puis cliquez sur Terminé. Les deux styles s'y affichent.",
    ["Reset"] = "Recentrer",
    ["The pulse is back in the middle of your screen."] = "La pulsation est revenue au centre de votre écran.",
    ["Puts the pulse back in the middle of your screen."] = "Remet la pulsation au centre de votre écran.",
    ["Pulse an icon when a cooldown is ready"] = "Afficher une icône dès qu'un temps de recharge est prêt",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "Une grande icône au centre de votre écran dès qu'un temps de recharge est prêt, même en combat. Elle ne bloque jamais la souris.",
    ["%.1fs"] = "%.1f s",
    ["Edit"] = "Modifier",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "Les styles Rapide et Longue ont chacun leur taille, leur durée et leur son : choisissez lequel régler ci-dessous. Aperçu le lance.",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = "Taille d'une pulsation %s, en unités du jeu : 320 fait environ un tiers de la hauteur de votre écran.",
    ["Size"] = "Taille",
    ["Shows for"] = "Durée",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = "Durée d'une pulsation Rapide, jusqu'à 2 secondes : elle apparaît, reste un instant, puis s'estompe.",
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = "Durée d'une pulsation Longue, jusqu'à 5 secondes : elle apparaît, reste un instant, puis s'estompe.",
    ["Sound"] = "Son",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = "Un son à chaque pulsation %s. Les flèches passent d'un son à l'autre et le jouent ; cliquez sur son nom pour le réentendre.",
    ["See-through"] = "Transparent",
    ["How much of the game shows through the icon, in both styles. 0 is solid."]
        = "La transparence de l'icône, pour les deux styles. À 0, elle est opaque.",
    ["Grows to"] = "Grandit à",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "La taille qu'elle atteint en s'estompant, en pourcentage de sa taille, pour les deux styles. À 100, elle ne grandit pas.",
    ["Border"] = "Contour",
    ["A dark edge round the icon, in both styles: none, thin or thick."]
        = "Un contour sombre autour de l'icône, pour les deux styles : aucun, fin ou épais.",
    ["Shadow"] = "Ombre",
    ["A soft shadow round the icon, in both styles, fading out from its edge."]
        = "Une ombre douce autour de l'icône, pour les deux styles, qui s'estompe depuis son bord.",
    ["Trinkets and potions too"] = "Bijoux et potions aussi",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "Vos bijoux, potions, pierres de soins et autres objets utilisables dans vos sacs. Seuls ceux avec un temps de recharge sont signalés.",
    ["Play at Master volume"] = "Jouer au volume principal",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "Joue le son au volume principal, pour l'entendre même avec les effets sonores baissés ou coupés. Vos réglages de son ne changent pas.",
    ["Which cooldowns"] = "Quels temps de recharge",
    ["tick the ones you want to pulse, then pick Quick or Long for each"]
        = "cochez ceux à signaler, puis choisissez Rapide ou Longue",
    ["Untick to leave %s out."] = "Décochez pour ne plus signaler %s.",
    ["Tick to pulse when %s is ready."] = "Cochez pour être averti quand %s est disponible.",
    [" (experimental)"] = " (expérimental)",
    ["%s pulses %s."] = "%s : pulsation %s.",
    ["Once ticked, %s pulses %s."] = "Une fois la case cochée, %s aura une pulsation %s.",
    ["Click for %s."] = "Cliquez pour passer en %s.",
    ["Each style has its own size, time and sound, set under Edit above."]
        = "Chaque style a ses propres taille, durée et son, réglés sous Modifier plus haut.",
    ["Spells"] = "Sorts",
    ["Items"] = "Objets",
    ["trinket"] = "bijou",
    ["none left"] = "épuisé",
    ["in your bags"] = "dans vos sacs",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "Aucun de vos sorts n'a encore son propre temps de recharge. Les nouveaux s'afficheront ici quand vous les apprendrez.",
    ["Preview"] = "Aperçu",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = "Affiche tout de suite une pulsation %s avec vos choix, par-dessus cette fenêtre, activée ou non. Modifier choisit le style.",
    ["Preview %s"] = "Aperçu (%s)",
    ["1 cooldown pulses when it's ready."] = "1 temps de recharge signalé quand il est prêt.",
    ["%d cooldowns pulse when they're ready."] = "%d temps de recharge signalés quand ils sont prêts.",
    ["Nothing to pulse yet: tick some below."] = "Rien à signaler pour l'instant : cochez-en ci-dessous.",
    ["Running in %s instead."] = "Active dans %s à la place.",
    ["Off. Tick the box below to start."] = "Désactivée. Cochez la case ci-dessous pour commencer.",
    ["%s right"] = "%s à droite",
    ["%s left"] = "%s à gauche",
    ["%s up"] = "%s vers le haut",
    ["%s down"] = "%s vers le bas",
    ["Moved %s and %s from the middle."] = "Décalage depuis le centre : %s et %s.",
    ["Moved %s from the middle."] = "Décalage depuis le centre : %s.",
    ["In the middle of your screen."] = "Au centre de votre écran.",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "tous",
    ["you + %d"] = "vous + %d",
    ["you"] = "vous",
    ["unused"] = "inutilisé",
    ["1 character"] = "1 personnage",
    ["%d characters"] = "%d personnages",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = "Le profil de ce personnage : ce qui est signalé, et ce qui est en Longue. Cliquez pour voir tous les profils, en changer ou en créer un.",
    ["Profiles"] = "Profils",
    ["You're using it, so you'll move to a new, empty profile of your own."]
        = "Vous l'utilisez : vous passerez à un nouveau profil vide, rien qu'à vous.",
    ["Another character uses it, and loads %s at its next login."]
        = "Un autre personnage l'utilise et chargera %s à sa prochaine connexion.",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "Un autre personnage l'utilise et recevra son propre profil vide à sa prochaine connexion.",
    ["%d other characters use it, and each loads %s at its next login."]
        = "%d autres personnages l'utilisent, et chacun chargera %s à sa prochaine connexion.",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "%d autres personnages l'utilisent, et chacun recevra son propre profil vide à sa prochaine connexion.",
    ['Delete "%s"?'] = "Supprimer « %s » ?",
    ["This can't be undone."] = "Cette action est irréversible.",
    ["Delete"] = "Supprimer",
    ["The profile you're on."] = "Le profil que vous utilisez.",
    ["Switch to %s."] = "Passer à %s.",
    ["Delete %s. It asks first."] = "Supprimer %s. Une confirmation est demandée.",
    ["Profile name"] = "Nom du profil",
    ["A name for New, Copy or Rename."] = "Un nom pour Nouveau, Copier ou Renommer.",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "Cliquez sur un profil pour l'utiliser, ou sur x pour le supprimer. Saisissez un nom pour en créer, copier ou renommer un. Toutes les classes peuvent partager un profil : chaque personnage ne liste que ses propres sorts.",
    ["Use on all characters"] = "Utiliser sur tous les personnages",
    ["All your characters already use %s."] = "Tous vos personnages utilisent déjà %s.",
    ['Use "%s" on all characters?'] = "Utiliser « %s » sur tous les personnages ?",
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "Chaque personnage, y compris ceux créés plus tard, le chargera. Chacun ne liste que ses propres sorts et objets. Leurs profils restent dans cette liste.",
    ["Use on all"] = "Utiliser",
    ["All your characters use this profile, and new ones will too."]
        = "Tous vos personnages utilisent ce profil, et les nouveaux aussi.",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "Charge votre profil actuel sur tous les personnages. Chacun ne liste que ses propres sorts et objets.",
    ["New"] = "Nouveau",
    ["Make a new, empty profile with the name typed above, and switch to it."]
        = "Crée un nouveau profil vide avec le nom saisi ci-dessus, et l'utilise.",
    ["Copy"] = "Copier",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."]
        = "Copie vos cases cochées dans un nouveau profil avec le nom saisi ci-dessus, et l'utilise.",
    ["Rename"] = "Renommer",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "Donne le nom saisi ci-dessus à votre profil actuel, pour tous les personnages qui l'utilisent.",
    ["Profile"] = "Profil",
    ["loading..."] = "chargement...",
    ["On all characters"] = "Sur tous les personnages",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."]
        = "Faites glisser pour faire défiler la liste, ou tournez la molette de la souris dessus.",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "Copiez avec Ctrl+C, puis collez dans votre navigateur.",
    ["Close"] = "Fermer",
    ["Join the Discord"] = "Rejoindre le Discord",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "Un bug ou une idée ? Copiez avec Ctrl+C, puis collez dans votre navigateur.",
    ["Open"] = "Ouvrir",
    ["%s on %s"] = "%s sur %s",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "Copiez avec Ctrl+C, puis collez dans votre navigateur. Sur CurseForge, Install ouvre l'application CurseForge.",
    ["%s on %s, as a link to copy."] = "%s sur %s, en lien à copier.",
    ["Get it on CurseForge or GitHub: click one for its link."]
        = "Disponible sur CurseForge ou GitHub : cliquez pour avoir le lien.",
    ["Auto (game language)"] = "Auto (langue du jeu)",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish for Spain and Latin America; Traditional Chinese and any other game get English."]
        = "La langue de cette fenêtre, des Nouveautés et des messages de l'addon dans la discussion. Auto suit la langue de votre jeu, avec un seul espagnol pour l'Espagne et l'Amérique latine ; le chinois traditionnel et toute autre langue donnent l'anglais.",
    ["The language of this window, What's new and the addon's lines in chat."]
        = "La langue de cette fenêtre, des Nouveautés et des messages de l'addon dans la discussion.",
    ["Help"] = "Aide",
    ["Take the tour"] = "Visite guidée",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."]
        = "Une courte visite de cette fenêtre, une page à la fois. /fecp tour la lance aussi.",
    ["What's new"] = "Nouveautés",
    ["What changed in this version. /fecp new shows it too."] = "Les changements de cette version. /fecp new les affiche aussi.",
    ["Nothing yet: what changes in each update shows here."] = "Rien pour l'instant : les changements de chaque mise à jour s'afficheront ici.",
    ["The Discord invite, ready to copy: bugs, ideas and help."]
        = "L'invitation au Discord, prête à copier : bugs, idées et aide.",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "Une visite de l'essentiel, les changements de chaque mise à jour, ou le Discord pour les bugs, les idées et l'aide.",
    ["Minimap button"] = "Bouton de la minicarte",
    ["Show the minimap button"] = "Afficher le bouton",
    ["A button on the minimap for these settings. Off, /fecp still opens them."]
        = "Un bouton sur la minicarte pour ces options. Désactivé, /fecp les ouvre toujours.",
    ["Free-floating"] = "Position libre",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "Placez le bouton n'importe où sur l'écran, pas seulement autour de la minicarte. Il reste visible même si la minicarte est masquée.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "Cliquez dessus pour ces options, faites un clic droit pour les Nouveautés, et faites-le glisser autour de la minicarte, ou n'importe où en position libre.",
    ["Window accent"] = "Couleur de la fenêtre",
    ["%s for this window's headings, ticks, sliders and highlights."]
        = "%s pour les titres, cases, curseurs et surbrillances de cette fenêtre.",
    ["Language"] = "Langue",
    ["About"] = "À propos",
    ["Tell me when an update is out"] = "Me prévenir des mises à jour",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "Un message dans la discussion, une fois par session, si une nouvelle version sort. Il utilise un canal caché, qui occupe un emplacement de canal.",
    ["More from Squirt"] = "Autres addons de Squirt",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s, copie tirée directement du code source. Créé par Squirt. /fecp ouvre cette fenêtre.",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."]
        = "%s, version %s. Créé par Squirt. /fecp ouvre cette fenêtre.",
    ["Cancel"] = "Annuler",
    ["Made with %s by %s"] = "Fait avec %s par %s",
    ["/fecp to open"] = "/fecp pour ouvrir",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "Profils : cliquez sur un profil pour l'utiliser, ou sur x pour le supprimer. Saisissez un nom pour en créer, copier ou renommer un.",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "Rien à présenter ici pour l'instant. Survolez un élément et cette ligne dit à quoi il sert.",
    ["Page help"] = "Aide de la page",
    ["Walks you through this page, a step at a time."] = "Présente cette page, étape par étape.",
    ["New: click ? for help with any page"] = "Nouveau : cliquez sur ? pour l'aide",
    ["Put this note away. The ? stays, for help with any page."]
        = "Masquer cette note. Le ? reste là, pour l'aide de chaque page.",
    ["Close the window. Escape closes it too, and /fecp opens it again."]
        = "Fermer la fenêtre. Échap la ferme aussi, et /fecp la rouvre.",
    ["A big icon in the middle of your screen when a cooldown is ready."]
        = "Une grande icône au centre de votre écran quand un temps de recharge est prêt.",
    ["General"] = "Général",
    ["The tour, What's new, the Discord, the minimap button, this window's accent, update notices and Squirt's other addons."]
        = "La visite, les Nouveautés, le Discord, le bouton de la minicarte, la couleur de la fenêtre, les mises à jour et les autres addons de Squirt.",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "Le style Classic pour toute l'interface de WoW Forever, avec des options de confort.",
    ["Installed. Type /era, or click Open."] = "Installé. Tapez /era ou cliquez sur Ouvrir.",
    ["Open EraUI's settings, as /era does."] = "Ouvre les options d'EraUI, comme /era.",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "Le gestionnaire de temps de recharge relooké, plus vos barres de recharge, d'effets et d'incantation.",
    ["Installed. Type /ccm, or click Open."] = "Installé. Tapez /ccm ou cliquez sur Ouvrir.",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."]
        = "Ouvre les options de Forever Enhanced Cooldown Manager, comme /ccm.",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."] = "C'est tout pour cette page. Cliquez sur ? pour la revoir à tout moment.",
    ["Click ? any time to see it again."] = "Cliquez sur ? pour la revoir à tout moment.",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "C'est tout pour les nouveautés. Revoyez-les à tout moment via Nouveautés, ou avec /fecp new.",
    ["See it again any time from What's new, or with /fecp new."]
        = "Revoyez-les à tout moment via Nouveautés, ou avec /fecp new.",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "La visite est terminée. Relancez-la à tout moment depuis la page Général, ou avec /fecp tour.",
    ["Take the tour any time from the General page, or with /fecp tour."]
        = "Lancez la visite à tout moment depuis la page Général, ou avec /fecp tour.",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "La pulsation de recharge est activée dans %s : elle y tourne et cette case attend. Désactivez-la là-bas pour utiliser celle-ci.",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "Une grande icône au centre de votre écran dès qu'un temps de recharge est prêt, même en combat. Cette case l'active ou la désactive.",
    ["Nothing to do here while it runs there."] = "Rien à faire ici tant qu'elle tourne là-bas.",
    ["It's already on."] = "Elle est déjà activée.",
    ["Next"] = "Suivant",
    ["Back"] = "Retour",
    ["Skip tour"] = "Quitter",
    ["%d of %d"] = "%d sur %d",
    ["Welcome"] = "Bienvenue",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "Vous découvrez %s ? Une courte visite vous montre l'essentiel, une page à la fois. Elle dure environ une minute.",
    ["Skip"] = "Passer",
    ["Turn it on"] = "Activer la pulsation",
    ["Try it: tick it."] = "Essayez : cochez la case.",
    ["Pick your cooldowns"] = "Vos temps de recharge",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "Chaque sort connu avec un temps de recharge, ainsi que vos bijoux et potions. Cochez ceux à signaler, puis choisissez Rapide ou Longue pour chacun.",
    ["Try it: tick one."] = "Essayez : cochez-en un.",
    ["You've ticked some already."] = "Vous en avez déjà coché.",
    ["Quick and Long"] = "Rapide et Longue",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "Chacun a ses propres taille, durée et son. Choisissez-en un sous Modifier : Taille, Durée et Son le suivent, et Aperçu le lance.",
    ["Try it: pick Long, then Preview."] = "Essayez : choisissez Longue, puis Aperçu.",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "Déplacer affiche un cadre de la taille de la pulsation : placez-le où vous voulez, puis cliquez sur Terminé. Recentrer la remet au centre.",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "Refaites cette visite, consultez les Nouveautés ou obtenez l'invitation au Discord pour l'aide, les bugs et les idées. Le bouton de la minicarte et la couleur de la fenêtre sont aussi ici. /fecp ouvre cette fenêtre.",
    ["Both styles"] = "Les deux styles",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "Transparent, Grandit à, Contour et Ombre valent pour Rapide comme pour Longue. En dessous : vos bijoux et potions dans la liste, et le son au volume principal.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "Cliquez dessus pour ces options, faites un clic droit pour les Nouveautés, et faites-le glisser autour de la minicarte. Décochez pour le masquer : /fecp ouvre toujours les options.",
    ["The colour of this window's headings, ticks, sliders and highlights."]
        = "La couleur des titres, cases, curseurs et surbrillances de cette fenêtre.",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "La langue de cette fenêtre, des Nouveautés et des messages de l'addon dans la discussion. Auto suit la langue de votre jeu. Le changement est immédiat.",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"]
        = "Clic : options\nClic droit : Nouveautés\nGlisser : déplacer n'importe où",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"]
        = "Clic : options\nClic droit : Nouveautés\nGlisser : déplacer autour de la minicarte",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "Non publiée",
    ["Version %s"] = "Version %s",
    ["Found a bug or have an idea?"] = "Un bug ou une idée ?",
    ["/fecp new shows this again."] = "/fecp new pour les revoir.",
    ["Got it"] = "Compris",
    ["Show me what's new"] = "Montrez-moi",
    ["A quick tour of what's new, a page at a time."] = "Une courte visite des nouveautés, une page à la fois.",
    ["Added"] = "Ajouts",
    ["Changed"] = "Modifications",
    ["Fixed"] = "Corrections",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = "Me prévenir des mises à jour (page Général) : un message dans la discussion quand une version plus récente sort. Activé par défaut.",
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "Des sorts manquants (Sceau d'autorité, Horion sacré, Sang froid, Innervation et d'autres) peuvent maintenant être signalés.",
    ["Spell data updated for Forever's latest patch."] = "Données des sorts mises à jour pour le dernier patch de Forever.",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "Le bouton de la minicarte apparaît à un nouvel endroit, à l'écart des boutons de nos autres addons. S'il a été déplacé, il garde sa place.",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."]
        = "Le Thé de chardon et les quelques autres aliments et boissons avec un temps de recharge sont maintenant signalés.",
    ["Read Leyline keeps its pulse tick after the game renamed it."]
        = "Read Leyline reste coché même après son renommage par le jeu.",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "Moins gourmand en ressources quand vos sacs changent, et données des sorts mises à jour pour la dernière version de Forever.",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "Les potions passent à celle que vous avez sur vous, et un objet épuisé n'est plus signalé.",
    ["Hover boxes widen to fit their title."] = "Les infobulles s'élargissent pour contenir leur titre.",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "Le bouton de la minicarte peut être en position libre : cochez l'option sur la page Général, puis placez-le n'importe où.",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "Autres addons de Squirt sur la page Général : EraUI et Forever Enhanced Cooldown Manager.",
    ["Escape now closes the settings during a fight too."] = "Échap ferme maintenant les options, même en combat.",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "Les options et les Nouveautés se ferment avec les autres fenêtres du jeu, par exemple lors d'un écran de chargement.",
    ["The minimap button's tooltip now matches the addon's look."]
        = "L'infobulle du bouton de la minicarte suit maintenant le style de l'addon.",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."]
        = "Une grande icône au centre de votre écran dès qu'un temps de recharge coché est prêt.",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "Les styles Rapide et Longue, chacun avec ses propres taille, durée et son, plus 15 sons et une option de volume principal.",
    ["Trinkets, potions, healthstones and bag items can pulse too."]
        = "Les bijoux, potions, pierres de soins et objets des sacs peuvent aussi être signalés.",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "Fonctionne avec Forever Enhanced Cooldown Manager : une seule pulsation est active à la fois.",
}
