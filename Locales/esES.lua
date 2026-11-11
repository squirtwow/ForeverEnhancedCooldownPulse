-- Spanish (esES) for Locale.lua: the text the addon shows, by its
-- English. Shown in the Language list as Español.
-- One Spanish for Spain and Latin America: Auto picks it on esES and esMX
-- games, so it's neutral Spanish with tú (never vosotros or vos), and words
-- both read the same way (clic, opciones, no ratón or mouse).
--
-- In the game's own words: tiempo de reutilización for a cooldown, hechizo,
-- objeto, abalorio, poción, piedra de salud, perfil, botón del minimapa, en
-- combate. The pulse is an aviso (its page and feature, Cooldown pulse, is
-- Aviso de recarga, short enough for the list of pages); its two styles are
-- Rápido and Largo, written so wherever they show. To tick is marcar (the
-- box a casilla), the General page General, What's new Novedades, the tour
-- el tour, Preview Probar, Done Listo, See-through Translúcido. The same
-- English always gets the same Spanish. A proc is un proc (los procs), as
-- players say; it se activa.
--
-- Room, in the game's units (about 7.5 a letter, 6.5 in the small font):
-- the page names 130; the labels before a slider or choice 88; Preview %s
-- 106; Take the tour, What's new and Got it 96; Show me what's new 116;
-- Move, Reset, Open and Done 76; Close, Cancel, Delete, Use on all, New,
-- Copy and Rename 86; Next, Back and Done in the tour 60; Skip tour and Skip
-- 72; None, Thin and Thick 35 each; Quick and Long 43 each. The page's title
-- and its longest status line share 478. Tools/TestLocale.lua checks it all
-- fits.
--
-- Grouped by the file that shows each, as in zhCN.lua.
local _, ns = ...

ns.LOCALES.esES = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "Los perfiles no se pueden cambiar en combate.",
    ["Your profile hasn't loaded yet."] = "Tu perfil todavía no está cargado.",
    ["Type a profile name first."] = "Primero escribe un nombre de perfil.",
    ["Profile names can be up to %d characters."]
        = "Los nombres de perfil tienen como máximo %d caracteres (una letra con tilde o la ñ cuentan como dos).",
    ["Profile names can't use the | character."] = "Los nombres de perfil no pueden llevar el carácter |.",
    ['No profile is called "%s".'] = 'No hay ningún perfil llamado "%s".',
    ["You're already using %s."] = "Ya estás usando %s.",
    ["Now using %s."] = "Ahora usas %s.",
    ["%s already exists."] = "%s ya existe.",
    ["Copied your ticks to %s, and switched to it."] = "Se copió tu selección en %s y ya lo estás usando.",
    ["Made %s, and switched to it."] = "Se creó %s y ya lo estás usando.",
    ["All your characters use %s now, and new ones will too."]
        = "Todos tus personajes usan ahora %s, y los nuevos también lo harán.",
    ["That's already its name."] = "Ese ya es su nombre.",
    ["Renamed to %s."] = "Ahora se llama %s.",
    ["Deleted %s. You're now on %s."] = "Se eliminó %s. Ahora usas %s.",
    ["Deleted %s."] = "Se eliminó %s.",
    ["%s %s is out (you have %s). Update on CurseForge."]
        = "Ya está disponible %s %s (tienes la %s). Actualiza en CurseForge.",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "Un icono grande en el centro de la pantalla en cuanto termina un tiempo de reutilización. Para las opciones, escribe /fecp, haz clic en el botón del minimapa o en el botón de abajo.",
    ["Open settings"] = "Abrir opciones",
    ["None"] = "Nada",
    ["Thin"] = "Fino",
    ["Thick"] = "Ancho",
    ["Chime"] = "Carillón",
    ["Bell"] = "Campana",
    ["Bell trill"] = "Trino de campana",
    ["Shimmer bell"] = "Campana brillante",
    ["Magic chimes"] = "Carillón mágico",
    ["Shimmer"] = "Brillo",
    ["Zippy magic"] = "Magia veloz",
    ["Synth"] = "Sintetizador",
    ["Pitch pipe"] = "Diapasón",
    ["Brass"] = "Metales",
    ["War horn"] = "Cuerno de guerra",
    ["Fanfare"] = "Fanfarria",
    ["Gold"] = "Oro",
    ["Jackpot bell"] = "Campana de premio",
    ["Anvil"] = "Yunque",
    ["Quick"] = "Rápido",
    ["Long"] = "Largo",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."]
        = "El aviso de recarga está activado en %s. Desactívalo allí para usar este.",

    -- Theme.lua: the accents.
    ["Orange"] = "Naranja",
    ["Blue"] = "Azul",
    ["Teal"] = "Turquesa",
    ["Purple"] = "Morado",
    ["Green"] = "Verde",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "Objeto %d",
    ["Trinket %d: %s"] = "Abalorio %d: %s",
    ["Healthstones"] = "Piedras de salud",
    ["Healing Potions"] = "Pociones de sanación",
    ["Mana Potions"] = "Pociones de maná",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"]
        = "el aviso de recarga no pudo seguir un tiempo de reutilización. Por favor, envíanos esto: %s",
    ["proc pulses couldn't start. Please report this: %s"]
        = "los avisos de procs no pudieron iniciarse. Por favor, envíanos esto: %s",
    ["Finish the fight first, then move it."] = "Primero termina el combate y luego muévelo.",
    ["Cooldown pulse"] = "Aviso de recarga",
    ["Done"] = "Listo",
    ["Drag the box, then click Done or right-click it."]
        = "Arrastra el recuadro y luego haz clic en Listo o clic derecho sobre él.",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%g s",
    ["%g min"] = "%g min",
    ["%g hour"] = "%g hora",
    ["%g hours"] = "%g horas",
    ["On your screen"] = "En tu pantalla",
    ["Up close"] = "De cerca",
    ["Where it shows"] = "Dónde aparece",
    ["Move"] = "Mover",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "Muestra un recuadro del tamaño del estilo elegido en Editar. Arrástralo adonde quieras el aviso y luego haz clic en Listo. Ambos estilos aparecen ahí.",
    ["Reset"] = "Restablecer",
    ["The pulse is back in the middle of your screen."] = "El aviso vuelve a estar en el centro de la pantalla.",
    ["Puts the pulse back in the middle of your screen."] = "Devuelve el aviso al centro de la pantalla.",
    ["Pulse an icon when a cooldown is ready"] = "Mostrar un icono al terminar un tiempo de reutilización",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "Un icono grande en el centro de la pantalla en cuanto termina un tiempo de reutilización, también en combate. Nunca bloquea tus clics.",
    ["%.1fs"] = "%.1f s",
    ["Edit"] = "Editar",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "Rápido y Largo tienen cada uno su tamaño, duración y sonido: elige cuál quieres ajustar abajo. Probar lo muestra.",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = "El tamaño del aviso %s, en unidades del juego: 320 es más o menos un tercio de la altura de tu pantalla.",
    ["Size"] = "Tamaño",
    ["Shows for"] = "Duración",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = "Cuánto dura un aviso Rápido, hasta 2 segundos: aparece, se mantiene un momento y luego se desvanece.",
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = "Cuánto dura un aviso Largo, hasta 5 segundos: aparece, se mantiene un momento y luego se desvanece.",
    ["Sound"] = "Sonido",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = "Un sonido con cada aviso %s. Las flechas los recorren y reproducen uno a uno; haz clic en su nombre para volver a oírlo.",
    ["See-through"] = "Translúcido",
    ["How much of the game shows through the icon, in both styles. 0 is solid."]
        = "Cuánto se ve el juego a través del icono, en ambos estilos. 0 es opaco.",
    ["Grows to"] = "Crece hasta",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "Cuánto crece al desvanecerse, en porcentaje de su tamaño, en ambos estilos. 100 lo deja del mismo tamaño.",
    ["Border"] = "Borde",
    ["A dark edge round the icon, in both styles: none, thin or thick."]
        = "Un borde oscuro alrededor del icono, en ambos estilos: nada, fino o ancho.",
    ["Shadow"] = "Sombra",
    ["A soft shadow round the icon, in both styles, fading out from its edge."]
        = "Una sombra suave alrededor del icono, en ambos estilos, que se difumina desde su borde.",
    ["Trinkets and potions too"] = "También abalorios y pociones",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "Tus abalorios, pociones, piedras de salud y otros objetos usables de tus bolsas. Solo avisan los que tienen tiempo de reutilización.",
    ["Procs too"] = "También procs",
    ["Your class's procs, like Clearcasting or Missile Barrage: a pulse the moment one lands, in a fight too. Procs pulse without a sound."]
        = "Los procs de tu clase, como Libre lanzamiento o Tromba de misiles: un aviso en cuanto se activa uno, también en combate. Los procs avisan sin sonido.",
    ["Your game can't show proc pulses."] = "Tu juego no puede mostrar avisos de procs.",
    ["Play at Master volume"] = "Sonar con el volumen general",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "Reproduce el sonido con tu volumen general, para oírlo aunque los efectos de sonido estén bajos o desactivados. Tus opciones de sonido no cambian.",
    ["Which cooldowns"] = "Cuáles avisan",
    ["tick the ones you want to pulse, then pick Quick or Long for each"]
        = "marca los que quieras que avisen y elige Rápido o Largo para cada uno",
    ["Untick to leave %s out."] = "Desmarca para dejar fuera %s.",
    ["Tick to pulse when %s is ready."] = "Marca para avisar cuando %s esté disponible.",
    ["Tick to pulse when %s lands."] = "Marca para avisar cuando se active %s.",
    ["Each style has its own size and time, set under Edit above. Procs pulse without a sound."]
        = "Tamaño y duración de cada estilo: en Editar, arriba. Los procs avisan sin sonido.",
    ["Procs"] = "Procs",
    [" (experimental)"] = " (experimental)",
    ["%s pulses %s."] = "%s usa el aviso %s.",
    ["Once ticked, %s pulses %s."] = "Al marcar la casilla, %s usará el aviso %s.",
    ["Click for %s."] = "Haz clic para elegir %s.",
    ["Each style has its own size, time and sound, set under Edit above."]
        = "Cada estilo tiene su propio tamaño, duración y sonido, que se ajustan en Editar, arriba.",
    ["Spells"] = "Hechizos",
    ["Items"] = "Objetos",
    ["trinket"] = "abalorio",
    ["none left"] = "no te quedan",
    ["in your bags"] = "en tus bolsas",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "Ninguno de tus hechizos tiene aún tiempo de reutilización propio. Los nuevos aparecerán aquí al aprenderlos.",
    ["Preview"] = "Probar",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = "Muestra ahora un aviso %s con tus opciones, sobre esta ventana, esté activado o no. Editar elige el estilo.",
    ["Preview %s"] = "Probar %s",
    ["1 cooldown pulses when it's ready."] = "1 tiempo de reutilización avisa al terminar.",
    ["%d cooldowns pulse when they're ready."] = "%d tiempos de reutilización avisan al terminar.",
    ["1 proc pulses as it lands."] = "1 proc avisa al activarse.",
    ["%d procs pulse as they land."] = "%d procs avisan al activarse.",
    ["1 cooldown pulses when ready, %s"] = "1 tiempo de reutilización y %s",
    ["%d cooldowns pulse when ready, %s"] = "%d tiempos de reutilización y %s",
    ["1 proc as it lands."] = "1 proc avisan.",
    ["%d procs as they land."] = "%d procs avisan.",
    ["Nothing to pulse yet: tick some below."] = "Aún no hay avisos: marca alguno abajo.",
    ["Running in %s instead."] = "Se usa el de %s.",
    ["Off. Tick the box below to start."] = "Desactivado. Marca la casilla de abajo para empezar.",
    ["%s right"] = "%s a la derecha",
    ["%s left"] = "%s a la izquierda",
    ["%s up"] = "%s hacia arriba",
    ["%s down"] = "%s hacia abajo",
    ["Moved %s and %s from the middle."] = "Desplazado %s y %s respecto al centro.",
    ["Moved %s from the middle."] = "Desplazado %s respecto al centro.",
    ["In the middle of your screen."] = "En el centro de la pantalla.",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "todos",
    ["you + %d"] = "tú + %d",
    ["you"] = "tú",
    ["unused"] = "sin uso",
    ["1 character"] = "1 personaje",
    ["%d characters"] = "%d personajes",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = "El perfil de este personaje: qué está marcado para avisar y cuáles usan Largo. Haz clic para ver todos los perfiles, cambiar o crear uno.",
    ["Profiles"] = "Perfiles",
    ["You're using it, so you'll move to a new, empty profile of your own."]
        = "Lo estás usando, así que pasarás a un perfil propio, nuevo y vacío.",
    ["Another character uses it, and loads %s at its next login."]
        = "Otro personaje lo usa y cargará %s al volver a conectarse.",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "Otro personaje lo usa y recibirá un perfil propio, nuevo y vacío, al volver a conectarse.",
    ["%d other characters use it, and each loads %s at its next login."]
        = "Lo usan otros %d personajes, y cada uno cargará %s al volver a conectarse.",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "Lo usan otros %d personajes, y cada uno recibirá un perfil propio, nuevo y vacío, al volver a conectarse.",
    ['Delete "%s"?'] = '¿Eliminar "%s"?',
    ["This can't be undone."] = "No se puede deshacer.",
    ["Delete"] = "Eliminar",
    ["The profile you're on."] = "El perfil que usas.",
    ["Switch to %s."] = "Cambiar a %s.",
    ["Delete %s. It asks first."] = "Eliminar %s. Antes pide confirmación.",
    ["Profile name"] = "Nombre del perfil",
    ["A name for New, Copy or Rename."] = "Un nombre para Nuevo, Copiar o Renombrar.",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "Haz clic en un perfil para usarlo, o en la x para eliminarlo. Escribe un nombre para crear, copiar o renombrar uno. Cualquier clase puede compartir un perfil: cada personaje solo muestra sus propios hechizos.",
    ["Use on all characters"] = "Usar en todos los personajes",
    ["All your characters already use %s."] = "Todos tus personajes ya usan %s.",
    ['Use "%s" on all characters?'] = '¿Usar "%s" en todos los personajes?',
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "Lo cargarán todos tus personajes, también los que crees después. Cada uno solo muestra sus propios hechizos y objetos. Sus perfiles propios siguen en esta lista.",
    ["Use on all"] = "Usar en todos",
    ["All your characters use this profile, and new ones will too."]
        = "Todos tus personajes usan este perfil, y los nuevos también lo harán.",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "Carga el perfil que usas en todos los personajes. Cada uno solo muestra sus propios hechizos y objetos.",
    ["New"] = "Nuevo",
    ["Make a new, empty profile with the name typed above, and switch to it."]
        = "Crea un perfil nuevo y vacío con el nombre escrito arriba, y pasa a usarlo.",
    ["Copy"] = "Copiar",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."]
        = "Copia tu selección en un perfil nuevo con el nombre escrito arriba, y pasa a usarlo.",
    ["Rename"] = "Renombrar",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "Pone el nombre escrito arriba al perfil que usas, para todos los personajes que lo usan.",
    ["Profile"] = "Perfil",
    ["loading..."] = "cargando...",
    ["On all characters"] = "En todos los personajes",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."]
        = "Arrastra para desplazar la lista, o usa la rueda de desplazamiento sobre ella.",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "Pulsa Ctrl+C para copiar y luego pégalo en tu navegador.",
    ["Close"] = "Cerrar",
    ["Join the Discord"] = "Únete al Discord",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "¿Un error o una idea? Pulsa Ctrl+C para copiar y luego pégalo en tu navegador.",
    ["Open"] = "Abrir",
    ["%s on %s"] = "%s en %s",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "Pulsa Ctrl+C para copiar y luego pégalo en tu navegador. En CurseForge, Install abre la aplicación de CurseForge.",
    ["%s on %s, as a link to copy."] = "%s en %s, como enlace para copiar.",
    ["Get it on CurseForge or GitHub: click one for its link."]
        = "Disponible en CurseForge y GitHub: haz clic en uno para ver su enlace.",
    ["Auto (game language)"] = "Automático (idioma del juego)",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish for Spain and Latin America; Traditional Chinese and any other game get English."]
        = "El idioma de esta ventana, de Novedades y de los mensajes del addon en el chat. Automático sigue el idioma de tu juego, con un solo español para España y Latinoamérica; el chino tradicional y cualquier otro idioma usan inglés.",
    ["The language of this window, What's new and the addon's lines in chat."]
        = "El idioma de esta ventana, de Novedades y de los mensajes del addon en el chat.",
    ["Help"] = "Ayuda",
    ["Take the tour"] = "Hacer el tour",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."]
        = "Un tour breve por esta ventana, página a página. También se inicia con /fecp tour.",
    ["What's new"] = "Novedades",
    ["What changed in this version. /fecp new shows it too."] = "Los cambios de esta versión. También se ven con /fecp new.",
    ["Nothing yet: what changes in each update shows here."] = "Aún nada: aquí aparecerán los cambios de cada actualización.",
    ["The Discord invite, ready to copy: bugs, ideas and help."]
        = "La invitación al Discord, lista para copiar: errores, ideas y ayuda.",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "Un tour por lo básico, los cambios de cada actualización o el Discord para errores, ideas y ayuda.",
    ["Minimap button"] = "Botón del minimapa",
    ["Show the minimap button"] = "Mostrar botón del minimapa",
    ["A button on the minimap for these settings. Off, /fecp still opens them."]
        = "Un botón en el minimapa para estas opciones. Si lo desactivas, /fecp sigue abriéndolas.",
    ["Free-floating"] = "Posición libre",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "Arrastra el botón a cualquier parte de la pantalla, no solo alrededor del minimapa. Se ve incluso con el minimapa oculto.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "Haz clic para estas opciones, clic derecho para Novedades, y arrástralo alrededor del minimapa, o a cualquier parte si tiene posición libre.",
    ["Window accent"] = "Color de la ventana",
    ["%s for this window's headings, ticks, sliders and highlights."]
        = "%s para los títulos, casillas, controles deslizantes y resaltados de esta ventana.",
    ["Language"] = "Idioma",
    ["About"] = "Acerca de",
    ["Tell me when an update is out"] = "Avisarme de actualizaciones",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "Un mensaje en el chat, una vez por sesión, cuando haya una versión más nueva. Usa un canal de chat oculto, que ocupa uno de tus espacios de canales de chat.",
    ["More from Squirt"] = "Más de Squirt",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s, una copia directa del código fuente. Creado por Squirt. /fecp abre esta ventana.",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."]
        = "%s, versión %s. Creado por Squirt. /fecp abre esta ventana.",
    ["Cancel"] = "Cancelar",
    ["Made with %s by %s"] = "Hecho con %s por %s",
    ["/fecp to open"] = "/fecp para abrir",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "Perfiles: haz clic en uno para usarlo, o en la x para eliminarlo. Escribe un nombre para crear, copiar o renombrar uno.",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "Aquí aún no hay nada que explicar. Pasa el cursor sobre cualquier cosa y esta línea te dirá qué hace.",
    ["Page help"] = "Ayuda de la página",
    ["Walks you through this page, a step at a time."] = "Te explica esta página, paso a paso.",
    ["New: click ? for help with any page"] = "Nuevo: haz clic en ? para ver la ayuda de cada página",
    ["Put this note away. The ? stays, for help with any page."]
        = "Ocultar esta nota. El ? se queda, para ayudarte en cualquier página.",
    ["Close the window. Escape closes it too, and /fecp opens it again."]
        = "Cierra la ventana. Esc también la cierra, y /fecp la vuelve a abrir.",
    ["A big icon in the middle of your screen when a cooldown is ready."]
        = "Un icono grande en el centro de la pantalla cuando termina un tiempo de reutilización.",
    ["General"] = "General",
    ["The tour, What's new, the Discord, the minimap button, this window's accent, update notices and Squirt's other addons."]
        = "El tour, Novedades, el Discord, el botón del minimapa, el color de esta ventana, los avisos de actualización y los otros addons de Squirt.",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "El aspecto clásico para toda la interfaz de WoW Forever, con opciones de calidad de vida.",
    ["Installed. Type /era, or click Open."] = "Instalado. Escribe /era o haz clic en Abrir.",
    ["Open EraUI's settings, as /era does."] = "Abre las opciones de EraUI, igual que /era.",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "Gestor de reutilización de Blizzard renovado, más barras de reutilización, beneficios y lanzamiento.",
    ["Installed. Type /ccm, or click Open."] = "Instalado. Escribe /ccm o haz clic en Abrir.",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."]
        = "Abre las opciones de Forever Enhanced Cooldown Manager, igual que /ccm.",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."]
        = "Eso es todo en esta página. Haz clic en ? cuando quieras para volver a verlo.",
    ["Click ? any time to see it again."] = "Haz clic en ? cuando quieras para volver a verlo.",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "Esas son las novedades. Vuelve a verlas cuando quieras desde Novedades o con /fecp new.",
    ["See it again any time from What's new, or with /fecp new."]
        = "Vuelve a verlas cuando quieras desde Novedades o con /fecp new.",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "Fin del tour. Hazlo de nuevo cuando quieras desde la página General o con /fecp tour.",
    ["Take the tour any time from the General page, or with /fecp tour."]
        = "Haz el tour cuando quieras desde la página General o con /fecp tour.",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "El aviso de recarga está activado en %s, así que funciona allí y esta casilla espera. Desactívalo allí para usar este.",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "Un icono grande en el centro de la pantalla en cuanto termina un tiempo de reutilización, también en combate. Esta casilla lo activa o desactiva.",
    ["Nothing to do here while it runs there."] = "Aquí no hay nada que hacer mientras funcione allí.",
    ["It's already on."] = "Ya está activado.",
    ["Next"] = "Siguiente",
    ["Back"] = "Atrás",
    ["Skip tour"] = "Saltar tour",
    ["%d of %d"] = "%d de %d",
    ["Welcome"] = "¡Te damos la bienvenida!",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "¿Es tu primera vez con %s? Un tour rápido te enseña lo básico, página a página. Dura más o menos un minuto.",
    ["Skip"] = "Saltar",
    ["Turn it on"] = "Actívalo",
    ["Try it: tick it."] = "Pruébalo: marca la casilla.",
    ["Pick your cooldowns"] = "Elige tus avisos",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "Todos los hechizos que conoces con tiempo de reutilización, y tus abalorios y pociones. Marca los que quieras que avisen y elige Rápido o Largo para cada uno.",
    ["Try it: tick one."] = "Pruébalo: marca uno.",
    ["You've ticked some already."] = "Ya tienes alguno marcado.",
    ["Quick and Long"] = "Rápido y Largo",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "Cada uno tiene su tamaño, duración y sonido. Elige uno en Editar: Tamaño, Duración y Sonido cambian con él, y Probar lo muestra.",
    ["Try it: pick Long, then Preview."] = "Pruébalo: elige Largo y luego Probar.",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "Mover muestra un recuadro del tamaño del aviso: arrástralo adonde quieras y haz clic en Listo. Restablecer lo devuelve al centro.",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "Repite este tour, mira las Novedades o consigue la invitación al Discord para ayuda, errores e ideas. Aquí también están el botón del minimapa y el color de esta ventana. /fecp abre esta ventana.",
    ["Both styles"] = "Ambos estilos",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "Translúcido, Crece hasta, Borde y Sombra valen igual para Rápido y Largo. Debajo: tus abalorios y pociones en la lista, y el sonido con tu volumen general.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "Haz clic para estas opciones, clic derecho para Novedades, y arrástralo alrededor del minimapa. Desmárcalo para ocultarlo: /fecp sigue abriéndolas.",
    ["The colour of this window's headings, ticks, sliders and highlights."]
        = "El color de los títulos, casillas, controles deslizantes y resaltados de esta ventana.",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "El idioma de esta ventana, de Novedades y de los mensajes del addon en el chat. Automático sigue el idioma de tu juego. Cambia al instante.",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"]
        = "Clic: opciones\nClic derecho: Novedades\nArrastrar: moverlo a cualquier parte",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"]
        = "Clic: opciones\nClic derecho: Novedades\nArrastrar: moverlo alrededor del minimapa",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "Sin publicar",
    ["Version %s"] = "Versión %s",
    ["Found a bug or have an idea?"] = "¿Un error o una idea?",
    ["/fecp new shows this again."] = "/fecp new lo vuelve a abrir.",
    ["Got it"] = "Entendido",
    ["Show me what's new"] = "Ver las novedades",
    ["A quick tour of what's new, a page at a time."] = "Un tour rápido por las novedades, página a página.",
    ["Added"] = "Añadido",
    ["Changed"] = "Cambiado",
    ["Fixed"] = "Corregido",
    ["Spell data updated for this week's Forever patch, like Shank and Reckless Swings."]
        = "Datos de hechizos actualizados para el parche de Forever de esta semana, como Shank y Reckless Swings.",
    ["The pulse no longer goes off in a fight for a spell that's already ready, for players still seeing it after 1.0.7."]
        = "El aviso ya no salta en combate por un hechizo que ya está listo, para quienes aún lo veían tras la 1.0.7.",
    ["Shooting a wand no longer pulses ready spells."]
        = "Disparar con una varita ya no hace saltar el aviso de los hechizos listos.",
    ["Added procs to Cooldown pulse."]
        = "Añadidos los procs al aviso de reutilización.",
    ["The pulse no longer goes off again and again in a fight for a spell that's already ready."]
        = "El aviso ya no salta una y otra vez en combate por un hechizo que ya está listo.",
    ["Spell data updated for launch."]
        = "Datos de hechizos actualizados para el lanzamiento.",
    ["The list shows Slam at 15 sec, Stormstrike 6, Riptide 12 and Totemic Call 30."]
        = "La lista muestra Embate a 15 s, Golpe de tormenta 6, Mareas vivas 12 y Llamada totémica 30.",
    ["Ice Lance can be pulsed at every rank (8 sec), not just rank 1."]
        = "Lanza de hielo puede pulsar en todos los rangos (8 s), no solo en el rango 1.",
    ["Elemental Mastery and Totemic Projection keep their tick when the game renames them."]
        = "Maestría elemental y Proyección totémica conservan su marca cuando el juego las renombra.",
    ["Simplified Chinese, German, French, Spanish, Brazilian Portuguese and Russian: pick one on the Language page under General. Auto follows your game's language."]
        = "Chino simplificado, alemán, francés, español, portugués de Brasil y ruso: elige uno en la página Idioma, dentro de General. Automático sigue el idioma de tu juego.",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = "Avisarme de actualizaciones (página General): un mensaje en el chat cuando haya una versión más nueva. Activado por defecto.",
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "Los hechizos que faltaban (Sello de orden, Choque Sagrado, Sangre fría, Estimular y más) ya pueden avisar.",
    ["Spell data updated for Forever's latest patch."] = "Datos de hechizos actualizados para el último parche de Forever.",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "El botón del minimapa empieza en un lugar nuevo, lejos de los botones de nuestros otros addons. Si lo habías movido, se queda donde estaba.",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."]
        = "El Té de cardo y las otras pocas comidas y bebidas con tiempo de reutilización ya avisan.",
    ["Read Leyline keeps its pulse tick after the game renamed it."]
        = "Read Leyline sigue marcado para avisar aunque el juego le haya cambiado el nombre.",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "Más ligero cuando cambian tus bolsas, y datos de hechizos actualizados para la última versión de Forever.",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "Las pociones pasan a la que llevas encima, y un objeto que ya no tienes no avisa.",
    ["Hover boxes widen to fit their title."] = "Las descripciones emergentes se ensanchan para que quepa su título.",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "El botón del minimapa puede tener posición libre: márcalo en la página General y arrástralo a cualquier parte.",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "Más de Squirt en la página General: EraUI y Forever Enhanced Cooldown Manager.",
    ["Escape now closes the settings during a fight too."] = "Esc ahora cierra las opciones también en combate.",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "Las opciones y Novedades se cierran junto con las demás ventanas del juego, por ejemplo en una pantalla de carga.",
    ["The minimap button's tooltip now matches the addon's look."]
        = "La descripción emergente del botón del minimapa ahora sigue el estilo del addon.",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."]
        = "Un icono grande en el centro de la pantalla en cuanto termina un tiempo de reutilización que marques.",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "Estilos Rápido y Largo, cada uno con su tamaño, duración y sonido, más 15 sonidos y una opción de volumen general.",
    ["Trinkets, potions, healthstones and bag items can pulse too."]
        = "Los abalorios, pociones, piedras de salud y objetos de las bolsas también pueden avisar.",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "Funciona junto a Forever Enhanced Cooldown Manager: solo hay un aviso activo a la vez.",
}
