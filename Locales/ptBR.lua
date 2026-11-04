-- Brazilian Portuguese (ptBR) for Locale.lua: the text the addon shows, by its
-- English. Shown in the Language list as Português (Brasil). In the words of
-- the game's own Brazilian Portuguese client, with "você": recarga and tempo
-- de recarga for a cooldown (a cooldown ready is a recarga that termina),
-- feitiço, item, berloque, poção, pedra de vida, perfil, personagem, botão do
-- minimapa, em combate. The client's own words: Master volume is volume
-- geral, Done Concluído, Preview Prévia, the Cooldown Manager Gerenciador de
-- recarga, cast bars barras de lançamento, buffs bônus. The pulse is o
-- pulso, its two styles Rápido and Longo; to tick is marcar (what's ticked,
-- marcações), the General page Geral, What's new Novidades, the tour o tour,
-- a new, empty profile um perfil novo e vazio. Spells and items in the notes
-- by the client's own names (Selo de Comando, Choque Sagrado, Sangue Frio,
-- Avivar, Chá de Cardo); Read Leyline stays. Grouped by the file that shows
-- each; the same English always gets the same Portuguese.
local _, ns = ...

ns.LOCALES.ptBR = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "Não é possível trocar de perfil em combate.",
    ["Your profile hasn't loaded yet."] = "Seu perfil ainda não foi carregado.",
    ["Type a profile name first."] = "Digite um nome de perfil primeiro.",
    ["Profile names can be up to %d characters."] = "Nomes de perfil podem ter até %d caracteres (letras com acento contam como 2).",
    ["Profile names can't use the | character."] = "Nomes de perfil não podem usar o caractere |.",
    ['No profile is called "%s".'] = 'Nenhum perfil se chama "%s".',
    ["You're already using %s."] = "Você já está usando %s.",
    ["Now using %s."] = "Agora usando %s.",
    ["%s already exists."] = "%s já existe.",
    ["Copied your ticks to %s, and switched to it."] = "Suas marcações foram copiadas para %s, que agora está em uso.",
    ["Made %s, and switched to it."] = "Perfil %s criado e agora em uso.",
    ["All your characters use %s now, and new ones will too."] = "Todos os seus personagens usam %s agora, e os novos também vão usar.",
    ["That's already its name."] = "Esse já é o nome dele.",
    ["Renamed to %s."] = "Renomeado para %s.",
    ["Deleted %s. You're now on %s."] = "%s excluído. Agora você está usando %s.",
    ["Deleted %s."] = "%s excluído.",
    ["%s %s is out (you have %s). Update on CurseForge."] = "%s %s já saiu (você está na %s). Atualize pelo CurseForge.",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "Um ícone grande no centro da tela no momento em que uma recarga termina. Digite /fecp, use o botão do minimapa ou o botão abaixo para abrir as configurações.",
    ["Open settings"] = "Abrir configurações",
    ["None"] = "Nada",
    ["Thin"] = "Fina",
    ["Thick"] = "Larga",
    ["Chime"] = "Carrilhão",
    ["Bell"] = "Sino",
    ["Bell trill"] = "Trinado de sino",
    ["Shimmer bell"] = "Sino cintilante",
    ["Magic chimes"] = "Carrilhão mágico",
    ["Shimmer"] = "Brilho",
    ["Zippy magic"] = "Magia veloz",
    ["Synth"] = "Sintetizador",
    ["Pitch pipe"] = "Diapasão",
    ["Brass"] = "Metais",
    ["War horn"] = "Trompa de guerra",
    ["Fanfare"] = "Fanfarra",
    ["Gold"] = "Ouro",
    ["Jackpot bell"] = "Sino do prêmio",
    ["Anvil"] = "Bigorna",
    ["Quick"] = "Rápido",
    ["Long"] = "Longo",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."]
        = "O pulso de recarga está ligado no %s. Desligue lá para usar este.",

    -- Theme.lua: the accents.
    ["Orange"] = "Laranja",
    ["Blue"] = "Azul",
    ["Teal"] = "Verde-azulado",
    ["Purple"] = "Roxo",
    ["Green"] = "Verde",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "Item %d",
    ["Trinket %d: %s"] = "Berloque %d: %s",
    ["Healthstones"] = "Pedras de Vida",
    ["Healing Potions"] = "Poções de Cura",
    ["Mana Potions"] = "Poções de Mana",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"]
        = "o pulso de recarga não conseguiu acompanhar uma recarga. Por favor, relate isto: %s",
    ["Finish the fight first, then move it."] = "Termine o combate primeiro e depois mova.",
    ["Cooldown pulse"] = "Pulso de recarga",
    ["Done"] = "Concluído",
    ["Drag the box, then click Done or right-click it."] = "Arraste a caixa e depois aperte Concluído, ou use o botão direito sobre ela.",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%gs",
    ["%g min"] = "%g min",
    ["%g hour"] = "%g hora",
    ["%g hours"] = "%g horas",
    ["On your screen"] = "Na sua tela",
    ["Up close"] = "De perto",
    ["Where it shows"] = "Onde aparece",
    ["Move"] = "Mover",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "Mostra uma caixa do tamanho do estilo escolhido em Editar. Arraste até onde quer o pulso e aperte Concluído. Os dois estilos aparecem ali.",
    ["Reset"] = "Redefinir",
    ["The pulse is back in the middle of your screen."] = "O pulso voltou para o centro da tela.",
    ["Puts the pulse back in the middle of your screen."] = "Coloca o pulso de volta no centro da tela.",
    ["Pulse an icon when a cooldown is ready"] = "Pulsar um ícone quando uma recarga terminar",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "Um ícone grande no centro da tela no momento em que uma recarga termina, também em combate. Ele nunca bloqueia o mouse.",
    ["%.1fs"] = "%.1fs",
    ["Edit"] = "Editar",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "Rápido e Longo têm tamanho, duração e som próprios: escolha qual ajustar abaixo. Prévia mostra o escolhido.",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = "O tamanho do pulso %s, em unidades do jogo: 320 é cerca de um terço da altura da tela.",
    ["Size"] = "Tamanho",
    ["Shows for"] = "Duração",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = "Quanto dura um pulso Rápido, até 2 segundos: ele surge, fica um instante e depois some aos poucos.",
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = "Quanto dura um pulso Longo, até 5 segundos: ele surge, fica um instante e depois some aos poucos.",
    ["Sound"] = "Som",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = "Um som a cada pulso %s. As setas passam pelos sons e tocam cada um; aperte o nome para ouvir de novo.",
    ["See-through"] = "Translúcido",
    ["How much of the game shows through the icon, in both styles. 0 is solid."]
        = "Quanto do jogo aparece através do ícone, nos dois estilos. 0 é sólido.",
    ["Grows to"] = "Cresce até",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "Quanto ele cresce ao sumir, em relação ao próprio tamanho, nos dois estilos. 100 mantém o mesmo tamanho.",
    ["Border"] = "Borda",
    ["A dark edge round the icon, in both styles: none, thin or thick."]
        = "Uma borda escura em volta do ícone, nos dois estilos: nenhuma, fina ou larga.",
    ["Shadow"] = "Sombra",
    ["A soft shadow round the icon, in both styles, fading out from its edge."]
        = "Uma sombra suave em volta do ícone, nos dois estilos, sumindo a partir da borda.",
    ["Trinkets and potions too"] = "Berloques e poções também",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "Seus berloques, poções, pedras de vida e outros itens usáveis nas bolsas. Só pulsam os que têm tempo de recarga.",
    ["Play at Master volume"] = "Tocar no volume geral",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "Toca o som no volume geral, para você ouvir mesmo com os efeitos sonoros baixos ou desligados. Suas configurações de som não mudam.",
    ["Which cooldowns"] = "Quais recargas",
    ["tick the ones you want to pulse, then pick Quick or Long for each"]
        = "marque as que devem pulsar e escolha Rápido ou Longo para cada uma",
    ["Untick to leave %s out."] = "Desmarque para deixar %s de fora.",
    ["Tick to pulse when %s is ready."] = "Marque para pulsar quando a recarga de %s terminar.",
    [" (experimental)"] = " (experimental)",
    ["%s pulses %s."] = "%s: pulso %s.",
    ["Once ticked, %s pulses %s."] = "Se você marcar %s, o pulso será %s.",
    ["Click for %s."] = "Aperte para usar o %s.",
    ["Each style has its own size, time and sound, set under Edit above."]
        = "Cada estilo tem tamanho, duração e som próprios, ajustados em Editar, acima.",
    ["Spells"] = "Feitiços",
    ["Items"] = "Itens",
    ["trinket"] = "berloque",
    ["none left"] = "esgotado",
    ["in your bags"] = "nas bolsas",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "Nenhum dos seus feitiços tem tempo de recarga próprio ainda. Os novos aparecem aqui conforme você os aprende.",
    ["Preview"] = "Prévia",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = "Mostra agora um pulso %s com suas escolhas, sobre esta janela, mesmo com o pulso desligado. Editar escolhe o estilo.",
    ["Preview %s"] = "Prévia: %s",
    ["1 cooldown pulses when it's ready."] = "1 recarga pulsa ao terminar.",
    ["%d cooldowns pulse when they're ready."] = "%d recargas pulsam ao terminar.",
    ["Nothing to pulse yet: tick some below."] = "Nada para pulsar ainda: marque algumas abaixo.",
    ["Running in %s instead."] = "Ativo no %s, não aqui.",
    ["Off. Tick the box below to start."] = "Desligado. Marque a caixa abaixo para começar.",
    ["%s right"] = "%s à direita",
    ["%s left"] = "%s à esquerda",
    ["%s up"] = "%s para cima",
    ["%s down"] = "%s para baixo",
    ["Moved %s and %s from the middle."] = "Deslocado do centro: %s e %s.",
    ["Moved %s from the middle."] = "Deslocado do centro: %s.",
    ["In the middle of your screen."] = "No centro da tela.",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "todos",
    ["you + %d"] = "você + %d",
    ["you"] = "você",
    ["unused"] = "sem uso",
    ["1 character"] = "1 personagem",
    ["%d characters"] = "%d personagens",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = "O perfil que este personagem usa: o que está marcado para pulsar e o que usa o Longo. Aperte para ver todos os perfis, trocar ou criar um.",
    ["Profiles"] = "Perfis",
    ["You're using it, so you'll move to a new, empty profile of your own."]
        = "Você está usando este perfil, então vai passar para um perfil novo e vazio só seu.",
    ["Another character uses it, and loads %s at its next login."]
        = "Outro personagem usa este perfil e vai carregar %s no próximo login.",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "Outro personagem usa este perfil e vai receber um perfil novo e vazio só dele no próximo login.",
    ["%d other characters use it, and each loads %s at its next login."]
        = "%d outros personagens usam este perfil, e cada um vai carregar %s no próximo login.",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "%d outros personagens usam este perfil, e cada um vai receber um perfil novo e vazio só dele no próximo login.",
    ['Delete "%s"?'] = 'Excluir "%s"?',
    ["This can't be undone."] = "Isso não pode ser desfeito.",
    ["Delete"] = "Excluir",
    ["The profile you're on."] = "O perfil que você está usando.",
    ["Switch to %s."] = "Mudar para %s.",
    ["Delete %s. It asks first."] = "Exclui %s. Pede confirmação antes.",
    ["Profile name"] = "Nome do perfil",
    ["A name for New, Copy or Rename."] = "Um nome para Novo, Copiar ou Renomear.",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "Escolha um perfil para usá-lo, ou o x para excluí-lo. Digite um nome para criar, copiar ou renomear. Qualquer classe pode compartilhar um perfil: cada personagem só lista os próprios feitiços.",
    ["Use on all characters"] = "Usar em todos os personagens",
    ["All your characters already use %s."] = "Todos os seus personagens já usam %s.",
    ['Use "%s" on all characters?'] = 'Usar "%s" em todos os personagens?',
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "Todos os personagens, e os que você criar depois, vão carregá-lo. Cada um só lista os próprios feitiços e itens. Os perfis deles continuam nesta lista.",
    ["Use on all"] = "Usar em todos",
    ["All your characters use this profile, and new ones will too."]
        = "Todos os seus personagens usam este perfil, e os novos também vão usar.",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "Carrega o perfil que você está usando em todos os personagens. Cada um só lista os próprios feitiços e itens.",
    ["New"] = "Novo",
    ["Make a new, empty profile with the name typed above, and switch to it."]
        = "Cria um perfil novo e vazio com o nome digitado acima e passa a usá-lo.",
    ["Copy"] = "Copiar",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."]
        = "Copia suas marcações para um perfil novo com o nome digitado acima e passa a usá-lo.",
    ["Rename"] = "Renomear",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "Dá o nome digitado acima ao perfil que você está usando, para todos os personagens que o usam.",
    ["Profile"] = "Perfil",
    ["loading..."] = "carregando...",
    ["On all characters"] = "Em todos os personagens",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."]
        = "Arraste para rolar a lista, ou gire a roda do mouse sobre ela.",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "Pressione Ctrl+C para copiar e depois cole no seu navegador.",
    ["Close"] = "Fechar",
    ["Join the Discord"] = "Entre no Discord",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "Achou um bug ou tem uma ideia? Pressione Ctrl+C para copiar e depois cole no seu navegador.",
    ["Open"] = "Abrir",
    ["%s on %s"] = "%s no %s",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "Pressione Ctrl+C para copiar e depois cole no seu navegador. No CurseForge, Install abre o aplicativo do CurseForge.",
    ["%s on %s, as a link to copy."] = "%s no %s, como link para copiar.",
    ["Get it on CurseForge or GitHub: click one for its link."]
        = "Baixe no CurseForge ou no GitHub: escolha um para ver o link.",
    ["Auto (game language)"] = "Automático (idioma do jogo)",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish for Spain and Latin America; Traditional Chinese and any other game get English."]
        = "O idioma desta janela, das Novidades e das mensagens do addon no chat. Automático segue o idioma do jogo, com um único espanhol para a Espanha e a América Latina; chinês tradicional e os outros idiomas ficam em inglês.",
    ["The language of this window, What's new and the addon's lines in chat."]
        = "O idioma desta janela, das Novidades e das mensagens do addon no chat.",
    ["Help"] = "Ajuda",
    ["Take the tour"] = "Fazer o tour",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."]
        = "Um tour rápido por esta janela, uma página por vez. /fecp tour também começa o tour.",
    ["What's new"] = "Novidades",
    ["What changed in this version. /fecp new shows it too."] = "O que mudou nesta versão. /fecp new também mostra.",
    ["Nothing yet: what changes in each update shows here."] = "Nada ainda: o que mudar em cada atualização aparece aqui.",
    ["The Discord invite, ready to copy: bugs, ideas and help."]
        = "O convite do Discord, pronto para copiar: bugs, ideias e ajuda.",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "Um tour pelo básico, o que mudou em cada atualização, ou o Discord para bugs, ideias e ajuda.",
    ["Minimap button"] = "Botão do minimapa",
    ["Show the minimap button"] = "Mostrar o botão do minimapa",
    ["A button on the minimap for these settings. Off, /fecp still opens them."]
        = "Um botão no minimapa para estas configurações. Desligado, /fecp ainda as abre.",
    ["Free-floating"] = "Posição livre",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "Arraste o botão para qualquer lugar da tela, não só em volta do minimapa. Ele aparece mesmo com o minimapa oculto.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "Com o botão esquerdo, abre estas configurações; com o direito, as Novidades. Arraste-o em volta do minimapa, ou para qualquer lugar com Posição livre.",
    ["Window accent"] = "Cor da janela",
    ["%s for this window's headings, ticks, sliders and highlights."]
        = "%s nos títulos, marcações, barras deslizantes e destaques desta janela.",
    ["Language"] = "Idioma",
    ["About"] = "Sobre",
    ["Tell me when an update is out"] = "Avisar sobre novas versões",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "Uma linha no chat, uma vez por sessão, quando sair uma versão mais nova. Usa um canal de chat oculto, que ocupa uma das suas vagas de canal.",
    ["More from Squirt"] = "Mais do Squirt",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s, uma cópia direto do código-fonte. Feito por Squirt. Digite /fecp para abrir esta janela.",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."]
        = "%s versão %s. Feito por Squirt. Digite /fecp para abrir esta janela.",
    ["Cancel"] = "Cancelar",
    ["Made with %s by %s"] = "Feito com %s por %s",
    ["/fecp to open"] = "/fecp para abrir",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "Perfis: escolha um para usá-lo, ou o x para excluí-lo. Digite um nome para criar, copiar ou renomear.",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "Ainda não há nada para explicar aqui. Passe o mouse sobre qualquer coisa e esta linha diz o que ela faz.",
    ["Page help"] = "Ajuda da página",
    ["Walks you through this page, a step at a time."] = "Explica esta página, um passo por vez.",
    ["New: click ? for help with any page"] = "Novo: use o ? para ajuda em qualquer página",
    ["Put this note away. The ? stays, for help with any page."]
        = "Fecha este aviso. O ? continua aqui, para ajuda em qualquer página.",
    ["Close the window. Escape closes it too, and /fecp opens it again."]
        = "Fecha a janela. Esc também fecha, e /fecp abre de novo.",
    ["A big icon in the middle of your screen when a cooldown is ready."]
        = "Um ícone grande no centro da tela quando uma recarga termina.",
    ["General"] = "Geral",
    ["The tour, What's new, the Discord, the minimap button, this window's accent, update notices and Squirt's other addons."]
        = "O tour, as Novidades, o Discord, o botão do minimapa, a cor da janela, os avisos de atualização e outros addons do Squirt.",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "O visual Clássico para toda a interface do WoW Forever, com opções de qualidade de vida.",
    ["Installed. Type /era, or click Open."] = "Instalado. Digite /era ou aperte Abrir.",
    ["Open EraUI's settings, as /era does."] = "Abre as configurações do EraUI, como o /era.",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "Gerenciador de recarga da Blizzard repaginado, mais suas barras de recarga, bônus e lançamento.",
    ["Installed. Type /ccm, or click Open."] = "Instalado. Digite /ccm ou aperte Abrir.",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."]
        = "Abre as configurações do Forever Enhanced Cooldown Manager, como o /ccm.",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."] = "Fim desta página. Use o ? quando quiser para ver de novo.",
    ["Click ? any time to see it again."] = "Use o ? quando quiser para ver de novo.",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "Essas são as novidades. Veja de novo quando quiser em Novidades, ou com /fecp new.",
    ["See it again any time from What's new, or with /fecp new."]
        = "Veja de novo quando quiser em Novidades, ou com /fecp new.",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "Fim do tour. Faça o tour quando quiser pela página Geral, ou com /fecp tour.",
    ["Take the tour any time from the General page, or with /fecp tour."]
        = "Faça o tour quando quiser pela página Geral, ou com /fecp tour.",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "O pulso de recarga está ligado no %s, então roda lá e esta caixa fica em espera. Desligue lá para usar este.",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "Um ícone grande no centro da tela no momento em que uma recarga termina, também em combate. Esta caixa liga ou desliga o pulso.",
    ["Nothing to do here while it runs there."] = "Nada a fazer aqui enquanto ele roda lá.",
    ["It's already on."] = "Já está ligado.",
    ["Next"] = "Próximo",
    ["Back"] = "Voltar",
    ["Skip tour"] = "Pular tour",
    ["%d of %d"] = "%d de %d",
    ["Welcome"] = "Boas-vindas",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "Novo no %s? Um tour rápido mostra o básico, uma página por vez. Leva cerca de um minuto.",
    ["Skip"] = "Pular",
    ["Turn it on"] = "Ligue o pulso",
    ["Try it: tick it."] = "Experimente: marque a caixa.",
    ["Pick your cooldowns"] = "Escolha suas recargas",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "Todo feitiço que você conhece com tempo de recarga, e seus berloques e poções. Marque os que devem pulsar e escolha Rápido ou Longo para cada um.",
    ["Try it: tick one."] = "Experimente: marque um.",
    ["You've ticked some already."] = "Você já marcou alguns.",
    ["Quick and Long"] = "Rápido e Longo",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "Cada um tem tamanho, duração e som próprios. Escolha um em Editar: Tamanho, Duração e Som acompanham a escolha, e Prévia mostra o pulso.",
    ["Try it: pick Long, then Preview."] = "Experimente: escolha Longo e depois Prévia.",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "Mover mostra uma caixa do tamanho do pulso: arraste até onde quiser e aperte Concluído. Redefinir coloca de volta no centro.",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "Refaça este tour, veja as Novidades ou pegue o convite do Discord para ajuda, bugs e ideias. O botão do minimapa e a cor da janela também ficam aqui. /fecp abre esta janela.",
    ["Both styles"] = "Os dois estilos",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "Translúcido, Cresce até, Borda e Sombra valem para Rápido e Longo. Abaixo deles: seus berloques e poções na lista, e o som no volume geral.",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "Com o botão esquerdo, abre estas configurações; com o direito, as Novidades. Arraste-o em volta do minimapa. Desmarque para ocultá-lo: /fecp ainda as abre.",
    ["The colour of this window's headings, ticks, sliders and highlights."]
        = "A cor dos títulos, marcações, barras deslizantes e destaques desta janela.",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "O idioma desta janela, das Novidades e das mensagens do addon no chat. Automático segue o idioma do jogo. A troca é imediata.",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"]
        = "Botão esquerdo: configurações\nBotão direito: Novidades\nArrastar: mover para qualquer lugar",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"]
        = "Botão esquerdo: configurações\nBotão direito: Novidades\nArrastar: mover em volta do minimapa",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "Não lançada",
    ["Version %s"] = "Versão %s",
    ["Found a bug or have an idea?"] = "Achou um bug? Tem uma ideia?",
    ["/fecp new shows this again."] = "/fecp new abre isto de novo.",
    ["Got it"] = "Entendi",
    ["Show me what's new"] = "Ver as novidades",
    ["A quick tour of what's new, a page at a time."] = "Um tour rápido pelas novidades, uma página por vez.",
    ["Added"] = "Adições",
    ["Changed"] = "Mudanças",
    ["Fixed"] = "Correções",
    ["Spell data updated for launch."]
        = "Dados de feitiços atualizados para o lançamento.",
    ["The list shows Slam at 15 sec, Stormstrike 6, Riptide 12 and Totemic Call 30."]
        = "A lista mostra Batida a 15 s, Golpe de Tormenta 6, Maré Viva 12 e Chamado Totêmico 30.",
    ["Ice Lance can be pulsed at every rank (8 sec), not just rank 1."]
        = "Lança de Gelo pode pulsar em todos os graus (8 s), não só no grau 1.",
    ["Elemental Mastery and Totemic Projection keep their tick when the game renames them."]
        = "Maestria Elemental e Projeção Totêmica mantêm a marca quando o jogo as renomeia.",
    ["Simplified Chinese, German, French, Spanish, Brazilian Portuguese and Russian: pick one on the Language page under General. Auto follows your game's language."]
        = "Chinês simplificado, alemão, francês, espanhol, português do Brasil e russo: escolha um na página Idioma, dentro de Geral. Automático segue o idioma do seu jogo.",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = "Avisar sobre novas versões (página Geral): uma linha no chat quando sair uma versão mais nova. Ligado por padrão.",
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "Feitiços que faltavam (Selo de Comando, Choque Sagrado, Sangue Frio, Avivar e outros) agora podem pulsar.",
    ["Spell data updated for Forever's latest patch."] = "Dados de feitiços atualizados para o patch mais recente do Forever.",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "O botão do minimapa começa em um lugar novo, longe dos botões dos nossos outros addons. Se você já o arrastou, ele fica onde está.",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."]
        = "Chá de Cardo e as poucas outras comidas e bebidas com tempo de recarga agora pulsam.",
    ["Read Leyline keeps its pulse tick after the game renamed it."]
        = "Read Leyline continua marcado para pulsar depois que o jogo mudou o nome dele.",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "Mais leve quando suas bolsas mudam, e dados de feitiços atualizados para a build mais recente do Forever.",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "As poções passam a seguir a que você carrega, e um item que acabou não pulsa.",
    ["Hover boxes widen to fit their title."] = "As caixas de dica ficam mais largas para caber o título.",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "O botão do minimapa pode ter posição livre: marque na página Geral e arraste para qualquer lugar.",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "Mais do Squirt na página Geral: EraUI e Forever Enhanced Cooldown Manager.",
    ["Escape now closes the settings during a fight too."] = "Esc agora fecha as configurações também durante o combate.",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "As configurações e as Novidades fecham junto com as outras janelas do jogo, por exemplo numa tela de carregamento.",
    ["The minimap button's tooltip now matches the addon's look."]
        = "A dica do botão do minimapa agora combina com o visual do addon.",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."]
        = "Um ícone grande no centro da tela no momento em que uma recarga marcada termina.",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "Estilos Rápido e Longo, cada um com tamanho, duração e som próprios, mais 15 sons e uma opção de volume geral.",
    ["Trinkets, potions, healthstones and bag items can pulse too."]
        = "Berloques, poções, pedras de vida e itens das bolsas também podem pulsar.",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "Funciona junto com o Forever Enhanced Cooldown Manager: só um pulso roda por vez.",
}
