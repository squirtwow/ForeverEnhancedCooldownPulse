-- Run the addon's real files against a mock game (Tools/Harness.lua) in
-- every language: each picked by hand on an English game, then Auto on each
-- game's own language. Every page, the profile menu and its questions, the
-- tour and each page's walkthrough, the welcome, the ? note and its
-- tooltip, What's new, the link box, the minimap button's tooltip, the box
-- that moves the pulse, the entry in Options > AddOns and the update notice
-- in chat: no English left on screen or in any hover note but names (the
-- addon's, Squirt's other addons', the languages' own, the game's for
-- spells, items and the character), links, commands and keys; every word
-- looked up is in the language's file; and everything still fits. A
-- language whose translator isn't done yet shows its English placeholders:
-- those pass here (Tools/TestLocale.mjs fails on them), and English that
-- comes from nowhere in the file still doesn't. Then Auto on every other
-- game (English), saved choices old and bad, and the language switched on
-- the Language page while the window is open: made again at once in each
-- language's words, as it was.
-- Run with: fengari Tools/TestLocale.lua
local H = assert(loadfile("Tools/Harness.lua"))()
local S, Equal, Note = H.S, H.Equal, H.Note

local LANGUAGES = { "deDE", "frFR", "esES", "ptBR", "ruRU", "zhCN" }
-- Written in Latin letters, so English can't be told from them by its
-- letters alone: there a word is English when it's in the addon's English
-- and in none of the language's own text.
local LATIN = { deDE = true, frFR = true, esES = true, ptBR = true }
-- English that can rightly stay as it is (Tools/TestLocale.mjs keeps the
-- same lists): names in every language, and in Latin letters SAME too.
local NAMES = { "Discord", "CurseForge", "GitHub", "EraUI", "Forever Enhanced Cooldown Manager", "OK" }
local SAME = { "%gs", "%.1fs", "%g min", "Item %d", "Version %s", "General", "Long", "Orange", "Gold", "Fanfare", "Synth",
    " (experimental)" }
local function Allowed(lang, english)
    for _, word in ipairs(NAMES) do if word == english then return true end end
    if not LATIN[lang] then return false end
    for _, word in ipairs(SAME) do if word == english then return true end end
    return false
end

-- Words that stay as they are on screen: names, brands, keys, the
-- languages' own names, the mock game's own names (its spells, items and
-- character, which a game in another language gives in it) and a profile
-- name the test types.
local KEEP = { "Forever Enhanced Cooldown Pulse", "Forever Enhanced Cooldown Manager", "WoW Forever", "Forever", "EraUI",
    "Squirt", "Discord", "CurseForge", "GitHub", "Install", "Ctrl+C", "Esc", "English", "Deutsch", "Français", "Español",
    "Português (Brasil)", "Read Leyline", "Zriel (Druid) - Zephras", "Walk on Air", "Barkskin", "Overpower", "Bash", "Lucky Charm",
    "Hearthstone", "dev", "Raids" }
table.sort(KEEP, function(a, b) return #a > #b end)

-- A text without its codes, links, names, commands and keys (in capitals
-- too, as headings show them).
local cleaned = {}
local function Clean(text)
    if cleaned[text] then return cleaned[text] end
    local out = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):gsub("https?://%S+", "")
    for _, word in ipairs(KEEP) do
        out = out:gsub((word:gsub("%p", "%%%0")), ""):gsub((word:upper():gsub("%p", "%%%0")), "")
    end
    out = out:gsub("/%l+ %l+", ""):gsub("/%l+", ""):gsub("%f[%a][xX]%f[%A]", "")
    cleaned[text] = out
    return out
end

-- How many lines a text takes in this width, wrapped a word at a time as
-- the game does (Chinese a character at a time), each measured as H.Wide
-- does: stricter than its total width over the line's.
local function Lines(text, font, width)
    text = tostring(text):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", "XX")
    local total, space = 0, H.Wide(" ", font)
    for para in (text .. "\n"):gmatch("(.-)\n") do
        local lines, at = 1, 0
        for word in para:gmatch("%S+") do
            -- Chinese breaks between any two characters (three bytes each).
            local first = true
            for piece in word:gsub("[\224-\239][\128-\191][\128-\191]", " %0 "):gmatch("%S+") do
                local wide, gap = H.Wide(piece, font), (at > 0 and first) and space or 0
                if at > 0 and at + gap + wide > width then lines, at = lines + 1, wide else at = at + gap + wide end
                first = false
            end
        end
        total = total + lines
    end
    return total
end

local FORMAT = "%%[-+ #0]*%d*%.?%d*[cdiouxXeEfgGqs%%]"
local function Words(text, into)
    for word in Clean(text:gsub(FORMAT, " ")):gmatch("%a+") do into[word:lower()] = true end
    return into
end

-- The words of each language: the English it was made from (every key),
-- its own (in each text translated, or rightly the same), and those still
-- waiting for its translator (in each text still its English).
-- And each text's English, by the text.
local ENGLISH, OWN, WAITING, FROM = {}, {}, {}, {}
local function Learn(ns)
    if next(ENGLISH) then return end
    for english in pairs(ns.LOCALES.zhCN) do Words(english, ENGLISH) end
    for _, lang in ipairs(LANGUAGES) do
        OWN[lang], WAITING[lang], FROM[lang] = {}, {}, {}
        for english, text in pairs(ns.LOCALES[lang]) do
            Words(text, (text ~= english or Allowed(lang, english)) and OWN[lang] or WAITING[lang])
            FROM[lang][text] = english
        end
    end
end

-- The English left in a text in this language, or nil: a word in Latin
-- letters that's neither the language's own nor waiting for its translator,
-- and in a language written in Latin letters, only one of the addon's
-- English.
local judged = {}
local function English(text, lang)
    judged[lang] = judged[lang] or {}
    local seen = judged[lang][text]
    if seen ~= nil then return seen or nil end
    local left = false
    for word in Clean(text):gmatch("%a+") do
        local lower = word:lower()
        if not (OWN[lang][lower] or WAITING[lang][lower]) and (not LATIN[lang] or (#word > 1 and ENGLISH[lower])) then
            left = word
            break
        end
    end
    judged[lang][text] = left
    return left or nil
end

-- Every text showing (under root, if given), and every hover note there.
local function Showing(root)
    local list = {}
    for _, obj in ipairs(H.objects) do
        local s = S[obj]
        if obj:IsVisible() and (root == nil or H.Inside(obj, root)) then
            if (s.kind == "FontString" or s.kind == "Button") and type(s.text) == "string" and s.text ~= "" then
                list[#list + 1] = s.text
            end
            if rawget(obj, "hint") ~= nil then list[#list + 1] = Note(obj) or "" end
        end
    end
    return list
end

-- What's still English, and every word looked up that the language's file
-- hasn't, for the language showing.
local found, missing = {}, {}
local current -- the ns being looked at
local function Look(label, root)
    local lang = current.Language()
    for _, text in ipairs(Showing(root)) do
        if English(text, lang) then found[#found + 1] = label .. ": " .. text .. " (" .. English(text, lang) .. ")" end
    end
end

local function Watch(ns)
    current = ns
    Learn(ns)
    local meta = getmetatable(ns.L)
    local base = meta.__index
    meta.__index = function(t, english)
        local words = ns.LOCALES[ns.Language()]
        if words and words[english] == nil then missing[#missing + 1] = ns.Language() .. " " .. tostring(english) end
        return base(t, english)
    end
end

local function Checked(label)
    Equal(table.concat(found, "\n"), "", label .. ": no English left on screen or in a hover note, but names, links, commands and keys")
    Equal(table.concat(missing, " | "), "", label .. ": every word looked up is in the language's file")
    Equal(H.Problems(), "", label .. ": no errors")
    found, missing = {}, {}
end

-- A game with a trinket worn, a potion and a hearthstone carried, so the list has items.
local function Gear()
    H.worn[13] = 9999
    H.counts[118] = 2
    H.bag = { { itemID = 6948, hyperlink = "|cffffffff|Hitem:6948|h[Hearthstone]|h|r", iconFileID = 134414 } }
    H.counts[6948] = 1
end

-- The window in a language, everywhere -------------------------------------------------------------

local function Everywhere(ns, label)
    local P, T, L = ns.Pulse, ns.Theme, ns.L
    ns.ShowWindow()
    local w = FECPFrame
    local tight = {}
    -- Text inside its room: a button's label, or any text and its room. Or,
    -- for a word of the language's file, no wider than its English, which
    -- the window was made for and has been seen in game (this measure is a
    -- little wide, to be sure).
    local lang = ns.Language()
    local function Fits(text, font, room, what)
        local english = FROM[lang] and FROM[lang][text]
        if english then room = math.max(room, H.Wide(english, font)) end
        if H.Wide(text, font) > room then tight[#tight + 1] = (what and what .. " " or "") .. tostring(text) end
    end
    -- Every page, in its states.
    w:Select("pulse")
    Look(label .. " pulse page")
    w.pages.pulse.edit.buttons[2]:Click()
    Look(label .. " pulse page, Long")
    w.pages.pulse.edit.buttons[1]:Click()
    ns.Set("pulseX", 100)
    ns.Set("pulseY", -50)
    Look(label .. " moved")
    P:ResetPlace()
    ns.Set("pulse", false)
    Look(label .. " off")
    ns.Set("pulse", true)
    H.Manager({ pulse = true })
    w:Refresh()
    Look(label .. " running elsewhere")
    H.Manager(nil)
    w:Refresh()
    w:Select("general")
    H.Frame()
    Equal(tostring(S[w.helpNudge].shown), "true", label .. ": the note under the ? shows on General")
    Look(label .. " General")
    Fits(S[w.helpNudge.text].text, "GameFontHighlightSmall", 240 * 2, "the ?'s note, in two lines")
    H.addOns.EraUI = true
    w:Select("pulse")
    w:Select("general")
    Look(label .. " General, EraUI loaded")
    -- Each card's line in its two lines, wrapped as the game wraps it, and
    -- the line at its foot in one, clear of its edge; the About line in
    -- two, as players see it (a version number in it).
    for _, card in ipairs(w.more) do
        if Lines(S[card.about].text, "GameFontHighlightSmall", S[card.about].width) > 2 then
            tight[#tight + 1] = "a card's line in two lines: " .. S[card.about].text
        end
        Fits(S[card.state].text, "GameFontHighlightSmall", S[card].width - 60 - 12, "a card's foot in one line:")
    end
    H.addOns.EraUI = nil
    w:Select("pulse")
    w:Select("general")
    for _, card in ipairs(w.more) do
        Fits(S[card.state].text, "GameFontHighlightSmall", S[card].width - 60 - 12, "a card's foot in one line:")
    end
    local released = L["%s version %s. Made by Squirt. Type /fecp to open this window."]:format(ns.TITLE, "1.0.10")
    if Lines(released, "GameFontHighlightSmall", S[w.about].width) > 2 then tight[#tight + 1] = "About in two lines: " .. released end
    w:Select("language")
    Look(label .. " Language")
    -- The language list: the choice saved lit, each name clear of its row's
    -- edge, and Auto's clear of the language it shows on this game.
    local list = w.language
    local lit = {}
    for _, row in ipairs(list.buttons) do
        if S[row.fill].shown then lit[#lit + 1] = row.key end
        local room = S[row].width - (12 + 12 + 8) - 10
        if row.detail then room = room - 8 - H.Wide(S[row.detail].text, "GameFontHighlightSmall") end
        Fits(S[row.label].text, "GameFontHighlight", room, "the language list's")
    end
    Equal(table.concat(lit, " ") .. " " .. list.selected, ns.Get("language") .. " " .. ns.Get("language"), label .. ": the choice lit")
    -- The footer's note for everything on the Cooldown pulse and General
    -- pages (the title bar's too) in two lines, as the game measures it,
    -- never climbing into the page; and inside the window, clear of the
    -- version on its left.
    local long = {}
    for _, key in ipairs({ "pulse", "general" }) do
        w:Select(key)
        for _, obj in ipairs(H.objects) do
            if rawget(obj, "hint") ~= nil and obj:IsVisible() and (H.Inside(obj, w.pages[key]) or H.Inside(obj, w.header)) then
                w:Note(obj)
                local note = w.note
                local _, size = note:GetFont()
                if note:GetStringHeight() > 2.5 * size or S[note].width > 790 - 12 - w.versionText:GetStringWidth() - 24 - 12 then
                    long[#long + 1] = key .. ": " .. S[note].text
                end
                w:Unnote(obj)
            end
        end
    end
    Equal(table.concat(long, " | "), "", label .. ": every note in the footer in two lines, clear of the version")
    -- The profile menu, and what it asks.
    w.profileButton:Click()
    Look(label .. " profiles")
    w.profileInput:SetText("Raids")
    w.profileActions.new:Click()
    w.profileButton:Click()
    Look(label .. " two profiles")
    local own
    for _, obj in ipairs(H.objects) do
        if obj:IsVisible() and rawget(obj, "profile") == "Zriel (Druid) - Zephras" then own = obj end
    end
    for _, row in ipairs({ own }) do
        Fits(S[row.users].text, "GameFontHighlightSmall", 90, "who uses a profile:")
    end
    own.remove:Click()
    Look(label .. " deleting")
    w.confirm.no:Click()
    w.profileEveryone:Click()
    Look(label .. " use on all")
    w.confirm.yes:Click()
    w.profileButton:Click()
    Look(label .. " on all")
    w.profileButton:Click()
    -- The tour, the welcome and each page's walkthrough, each box fitting,
    -- its title clear of its count.
    local fits = {}
    local function Walk(start, name)
        start()
        local box, steps = FECPTour, 0
        repeat
            steps = steps + 1
            Look(label .. " " .. name .. " " .. steps)
            if S[box.outline].shown then
                local wrong = H.BoxFits(w.pages[w.selected])
                if wrong ~= "" then fits[#fits + 1] = name .. " " .. steps .. ": " .. wrong end
            end
            Fits(S[box.title].text, "GameFontNormalSmall", 290 - 20 - 8 - H.Wide(S[box.count].text, "GameFontHighlightSmall"),
                "a tour box's title")
            box.next:Click()
        until not S[box].shown or steps > 10
        Look(label .. " " .. name .. " done")
        return steps
    end
    Equal(Walk(function() ns.Tour:Start() end, "tour"), 5, label .. ": the tour's five steps")
    Equal(Walk(function() w:Select("pulse"); w.help:Click() end, "pulse walkthrough"), 5, label .. ": the pulse page's walkthrough")
    Equal(Walk(function() w:Select("general"); w.help:Click() end, "General walkthrough"), 3, label .. ": General's walkthrough")
    Equal(Walk(function() w:Select("language"); w.help:Click() end, "Language walkthrough"), 1, label .. ": Language's walkthrough")
    ns.Tour:Welcome()
    Look(label .. " welcome")
    Fits(S[FECPTour.next.label].text, "GameFontHighlightSmall", S[FECPTour.next].width - 4)
    Fits(S[FECPTour.skip.label].text, "GameFontHighlightSmall", S[FECPTour.skip].width - 4)
    FECPTour.skip:Click()
    Look(label .. " skipped")
    Equal(table.concat(fits, "; "), "", label .. ": each tour box on its page, clear of its part")
    -- The ?'s tooltip and note, What's new, the link box and the minimap button.
    S[w.help].scripts.OnEnter(w.help)
    Look(label .. " ? tooltip", T.tip)
    S[w.help].scripts.OnLeave(w.help)
    ns.ShowNotes()
    Look(label .. " What's new", FECPNotes)
    -- The two lines at its foot, beside Discord: no wider than the wider of
    -- the English two, seen there in game.
    local foot = math.max(H.Wide("Found a bug or have an idea?", "GameFontHighlightSmall"),
        H.Wide("/fecp new shows this again.", "GameFontHighlightSmall"))
    for _, said in ipairs({ L["Found a bug or have an idea?"], L["/fecp new shows this again."] }) do
        if H.Wide(said, "GameFontHighlightSmall") > foot then tight[#tight + 1] = "What's new's foot: " .. said end
    end
    S[FECPNotes.tour].scripts.OnEnter(FECPNotes.tour)
    Look(label .. " What's new tooltip", T.tip)
    FECPNotes:Hide()
    w:Select("general")
    -- The link box: its link under the note's last line however many it
    -- takes, the box round both.
    local function LinkClear(what)
        local box = FECPCopyLink
        local _, _, _, _, y = box.input:GetPoint()
        if -y < 36 + box.note:GetStringHeight() + 8 or S[box].height + y < 136 - 72 then
            tight[#tight + 1] = what .. ": the note on its link"
        end
    end
    w.discord:Click()
    Look(label .. " Discord", FECPCopyLink)
    LinkClear("the Discord's box")
    Fits(S[FECPCopyLink.close.label].text, "GameFontHighlightSmall", S[FECPCopyLink.close].width - 4)
    for _, card in ipairs(w.more) do
        card.links[1]:Click()
        Look(label .. " CurseForge link", FECPCopyLink)
        LinkClear("a CurseForge link's box")
        Fits(S[FECPCopyLink.title].text, "GameFontNormalSmall", 420 - 16 - 8, "the link box's title, to 8 from its edge,")
    end
    FECPCopyLink.close:Click()
    local button = FECPMinimapButton
    S[button].scripts.OnEnter(button)
    Look(label .. " minimap tooltip", T.tip)
    S[button].scripts.OnLeave(button)
    -- The box that moves the pulse.
    P:StartMove()
    Look(label .. " moving", P.mover)
    Fits(S[P.mover.done.label].text, "GameFontHighlightSmall", S[P.mover.done].width - 4)
    P:StopMove(true)
    -- Options > AddOns.
    Look(label .. " Options", H.category.canvas)
    for _, f in ipairs(H.frames) do
        if S[f].parent == H.category.canvas and S[f].template == "UIPanelButtonTemplate" then
            Fits(S[f].text, "GameFontNormal", S[f].width - 10, "Options > AddOns'")
        end
    end
    -- Everything fits: every page, the list of pages and the title bar.
    local laid = {}
    for _, key in ipairs({ "pulse", "general", "language" }) do
        w:Select(key)
        local problems = H.Problems2D(w.pages[key])
        if problems ~= "" then laid[#laid + 1] = key .. ": " .. problems end
    end
    local bars = H.Problems2D(w.navFrame) .. H.Problems2D(w.header)
    if bars ~= "" then laid[#laid + 1] = "list or title bar: " .. bars end
    Equal(table.concat(laid, " | "), "", label .. ": everything inside its page, nothing on anything else")
    -- Each page's name in the list, each button's and choice's label inside
    -- it, each slider's label and value clear of its track, every sound's
    -- name, the list's right column, and the title row clear of Preview.
    for _, item in pairs(w.nav) do Fits(S[item.label].text, "GameFontHighlight", 150 - 14 - 6, "a page's name") end
    local page = w.pages.pulse
    for _, bar in ipairs({ page.edit, page.border, page.rows[2] and page.rows[2].style }) do
        for _, b in ipairs(bar and bar.buttons or {}) do
            local name = S[b.label]
            Fits(name.text, name.template, S[b].width - 4)
        end
    end
    for _, b in ipairs({ page.previewButton, page.move, page.reset, w.tour, w.news, w.profileActions.new, w.profileActions.copy,
        w.profileActions.rename, w.profileEveryone, w.confirm.yes, w.confirm.no, FECPTour.next, FECPTour.back, FECPTour.skip,
        FECPNotes.tour, FECPNotes.done, w.more[1].open }) do
        local name = S[b.label]
        Fits(name.text, name.template, S[b].width - 4)
    end
    for _, key in ipairs({ "quick", "long" }) do
        Fits(L["Preview %s"]:format(L[ns.PULSE_STYLE_NAMES[key]]), "GameFontHighlightSmall", S[page.previewButton].width - 4)
    end
    for _, key in ipairs(ns.PULSE_SOUND_KEYS) do
        Fits(L[ns.PULSE_SOUND_NAMES[key]], "GameFontHighlightSmall", S[page.sound.play].width - 4, "a sound's name")
    end
    for _, text in ipairs({ L["trinket"], L["none left"], L["in your bags"], ns.PulseLong(45), ns.PulseLong(90), ns.PulseLong(1800),
        ns.PulseLong(3600), ns.PulseLong(5400) }) do
        Fits(text, "GameFontHighlightSmall", 90, "the list's right column:")
    end
    local limits = { pulseSize = ns.PULSE_SIZE, pulseLongSize = ns.PULSE_LONG_SIZE, pulseTime = ns.PULSE_TIME,
        pulseLongTime = ns.PULSE_LONG_TIME, pulseSeeThrough = ns.PULSE_SEE_THROUGH, pulseGrow = ns.PULSE_GROW }
    for _, slider in ipairs(page.sliders) do
        local track, labelText = S[slider.track].points, S[slider.label]
        if H.Wide(labelText.text, labelText.template) + 8 > track[1][2] then tight[#tight + 1] = labelText.text end
        for _, value in ipairs(limits[slider.key]) do
            slider:Set(value)
            local shown = S[slider.value]
            if H.Wide(shown.text, shown.template) + 5 > -track[#track][2] or H.Wide(shown.text, shown.template) > shown.width then
                tight[#tight + 1] = slider.key .. " at " .. shown.text
            end
        end
        slider:Set(ns.Get(slider.key))
    end
    local title = S[page.title]
    local from = 16 + H.Wide(title.text, title.template) + 10
    local longest = 0
    for _, said in ipairs({ L["Off. Tick the box below to start."], L["Nothing to pulse yet: tick some below."],
        L["1 cooldown pulses when it's ready."], L["%d cooldowns pulse when they're ready."]:format(12),
        L["Running in %s instead."]:format("Forever Enhanced Cooldown Manager") }) do
        longest = math.max(longest, H.Wide(said, S[page.status].template))
    end
    if from + longest + 8 > 638 - 16 - S[page.previewButton].width then tight[#tight + 1] = "the title row" end
    Equal(table.concat(tight, ", "), "", label .. ": every label, value and name inside its own room")
    w:Hide()
end

-- The update notice in chat, in the language showing.
local function Notice(ns)
    local said = {}
    local print = _G.print
    _G.print = function(line) said[#said + 1] = line end
    SquirtVersions:Tell(SquirtVersions.addons.CP, "1.0.5", "1.0.4")
    _G.print = print
    return said[1]
end

-- Each language picked by hand, on an English game ---------------------------------------------------

for _, lang in ipairs(LANGUAGES) do
    H.locale = "enUS"
    H.Environment()
    Gear()
    local ns = H.Load({ notesSeen = "dev", language = lang })
    Watch(ns)
    H.Tick(ns)
    local words = ns.LOCALES[lang]
    Equal(ns.Language() .. " " .. ns.Get("language"), lang .. " " .. lang, lang .. " picked by hand, on an English game")
    Everywhere(ns, lang .. " by hand")
    local w = FECPFrame
    Equal(S[w.nav.pulse.label].text .. " | " .. S[w.nav.general.label].text .. " | " .. S[w.nav.language.label].text,
        words["Cooldown pulse"] .. " | " .. words["General"] .. " | " .. words["Language"], lang .. ": the list of pages in it")
    local notice = Notice(ns)
    Equal(notice, words["%s %s is out (you have %s). Update on CurseForge."]:format("|cffffd100Forever Enhanced Cooldown Pulse|r",
        "1.0.5", "1.0.4"), lang .. ": the update notice in chat in it")
    -- Numbers with the language's decimal mark: a comma but in Chinese.
    ns.ShowWindow()
    w:Select("pulse")
    local mark = lang == "zhCN" and "." or ","
    local function Marked(text, number) return (text:format(number):gsub("(%d)%.(%d)", "%1" .. mark .. "%2")) end
    Equal(ns.PulseLong(90) .. " | " .. ns.PulseLong(5400) .. " | " .. S[w.pages.pulse.slider.pulseTime.value].text,
        Marked(words["%g min"], 1.5) .. " | " .. Marked(words["%g hours"], 1.5) .. " | " .. Marked(words["%.1fs"], 1),
        lang .. ": cooldowns and seconds with its decimal mark")
    w:Hide()
    if lang == "zhCN" then
        Equal(S[w.nav.pulse.label].text .. " " .. S[w.nav.general.label].text .. " | " .. S[w.pages.pulse.title].text,
            "冷却提示 常规 | 冷却提示", "the list and the page's title in Chinese")
        ns.ShowWindow()
        w:Select("pulse")
        local page = w.pages.pulse
        local rows = {}
        for _, row in ipairs(page.rows) do
            if S[row].shown then rows[#rows + 1] = S[row.header].shown and S[row.header].text or (S[row.name].text .. " " .. S[row.long].text) end
        end
        Equal(table.concat(rows, " | "), "法术 | Barkskin 1分钟 | Bash 1分钟 | Overpower 5秒 | Walk on Air 1.5分钟"
            .. " | 物品 | 饰品 1：Lucky Charm 饰品 | 治疗药水 在背包中 | Hearthstone 在背包中",
            "the list: the game's own names for spells and items, the addon's in Chinese, cooldowns in Chinese")
        Equal(S[page.previewButton.label].text .. " | " .. S[page.slider.pulseTime.value].text .. " " .. S[page.slider.pulseTime.value].width,
            "预览「快速」 | 1.0秒 44", "Preview and seconds in Chinese, the style's name quoted, the seconds with room for 秒")
        w.pages.pulse.rows[2].check:Click()
        Equal(Note(page.rows[2].style.buttons[2]), "Barkskin 以「快速」样式提示。点击改为「持久」。每种样式都有自己的大小、时长和声音，在上方「编辑」中设置。",
            "the switch's note: sentences run on with no spaces between them")
        Equal(S[page.status].text, "1 个冷却会在就绪时提示。", "the title row counts in Chinese")
        Equal(notice, "|cffffd100Forever Enhanced Cooldown Pulse|r 1.0.5 已发布（你的版本为 1.0.4）。请在 CurseForge 更新。",
            "the update notice in chat, in Chinese")
        w:Select("language")
        Equal(S[w.languageNote].text, "此窗口、更新内容以及插件聊天信息所用的语言。「自动」跟随游戏语言，西班牙和拉丁美洲客户端使用同一种西班牙语；"
            .. "繁体中文及其他客户端显示英文。", "under the list: what it covers, and Auto by the game")
        w:Hide()
    end
    Checked(lang .. " by hand")
end

-- Auto on each game's own language: the language Auto picks, everywhere -----------------------------------

local GAMES = { { "deDE", "deDE" }, { "frFR", "frFR" }, { "esES", "esES" }, { "esMX", "esES" }, { "ptBR", "ptBR" },
    { "ruRU", "ruRU" }, { "zhCN", "zhCN" } }
for _, game in ipairs(GAMES) do
    local locale, lang = game[1], game[2]
    H.locale = locale
    H.Environment()
    Gear()
    local ns = H.Load({ notesSeen = "dev" })
    Watch(ns)
    H.Tick(ns)
    Equal(ns.Language() .. " " .. ns.Get("language") .. " " .. tostring(ForeverEnhancedCooldownPulseDB.language), lang .. " auto nil",
        "Auto on a " .. locale .. " game: " .. lang .. ", the choice not even saved")
    Everywhere(ns, locale .. " auto")
    ns.ShowWindow()
    FECPFrame:Select("language")
    Equal(S[FECPFrame.language.byKey.auto.detail].text .. " | " .. S[FECPFrame.nav.general.label].text,
        ns.LANGUAGE_NAMES[lang] .. " | " .. ns.LOCALES[lang]["General"], locale .. ": Auto says it shows " .. ns.LANGUAGE_NAMES[lang])
    FECPFrame:Hide()
    Checked(locale .. " auto")
end

-- Auto on any other game is English; old saved choices keep working; a bad one is Auto ---------------------

do
    local seen = {}
    for _, locale in ipairs({ "enUS", "enGB", "zhTW", "koKR", "itIT", "ptPT", "esAR" }) do
        H.locale = locale
        local ns = H.Start({ notesSeen = "dev", helpSeen = true })
        ns.ShowWindow()
        FECPFrame:Select("language")
        seen[#seen + 1] = locale .. "=" .. ns.Language() .. " " .. S[FECPFrame.nav.general.label].text .. " "
            .. S[FECPFrame.language.byKey.auto.detail].text
    end
    Equal(table.concat(seen, ", "), "enUS=enUS General English, enGB=enUS General English, zhTW=enUS General English, koKR=enUS General English,"
        .. " itIT=enUS General English, ptPT=enUS General English, esAR=enUS General English",
        "Auto: English on every game without its own file, Traditional Chinese too")
    local kept = {}
    for _, case in ipairs({ { "zhTW", "zhCN" }, { "zhCN", "enUS" }, { "deDE", "enUS" }, { "enUS", "zhCN" }, { "deDE", "auto" },
        { "enUS", "ruRU" }, { "ruRU", "esES" } }) do
        H.locale = case[1]
        local ns = H.Start({ notesSeen = "dev", helpSeen = true, language = case[2] })
        kept[#kept + 1] = case[1] .. ":" .. case[2] .. "=" .. ns.Get("language") .. "/" .. ns.Language()
    end
    Equal(table.concat(kept, " "), "zhTW:zhCN=zhCN/zhCN zhCN:enUS=enUS/enUS deDE:enUS=enUS/enUS enUS:zhCN=zhCN/zhCN deDE:auto=auto/deDE"
        .. " enUS:ruRU=ruRU/ruRU ruRU:esES=esES/esES", "a choice saved before (auto, enUS, zhCN) or now keeps working, on any game")
    H.locale = "zhCN"
    local bad = {}
    for _, value in ipairs({ "frCA", "esMX", "zhTW", "", 1, true, {} }) do
        local ns = H.Start({ notesSeen = "dev", helpSeen = true, language = value })
        bad[#bad + 1] = ns.Get("language") .. "=" .. ns.Language()
    end
    Equal(table.concat(bad, " "), "auto=zhCN auto=zhCN auto=zhCN auto=zhCN auto=zhCN auto=zhCN auto=zhCN", "a bad saved choice is Auto")
    H.locale = "enUS"
    Equal(H.Problems(), "", "no errors")
end

-- Capitals in every language ------------------------------------------------------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    Equal(ns.Upper("Paramètres, Größe, Über, À propos, ação, ñ, œuvre | Язык, ёлка, щит | 语言 | Edit 2.0s"),
        "PARAMÈTRES, GRÖSSE, ÜBER, À PROPOS, AÇÃO, Ñ, ŒUVRE | ЯЗЫК, ЁЛКА, ЩИТ | 语言 | EDIT 2.0S",
        "headings in capitals in every language: accents, ß, Cyrillic; Chinese as it is")
    Equal(ns.Upper("÷ × ÿ"), "÷ × ÿ", "and nothing that has no capital of its own changes")
end

-- Switched on the Language page: at once, no reload, to every language ---------------------------------

do
    H.locale = "enUS"
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    ns.ShowWindow()
    local old = FECPFrame
    -- Made before the switch, so they're the old window's: the list's rows,
    -- the profile menu's and the tour's box.
    old:Select("pulse")
    old.profileButton:Click()
    old.profileButton:Click()
    ns.Tour:Start()
    FECPTour.skip:Click()
    H.True(#old.pages.pulse.rows > 0 and H.Inside(FECPTour, old), "the old window has its list's rows and the tour's box")
    old:Select("language")
    local names = {}
    for _, row in ipairs(old.language.buttons) do names[#names + 1] = S[row.label].text end
    Equal(table.concat(names, ", ") .. " | " .. old.language.selected .. " " .. S[old.language.byKey.auto.detail].text,
        "Auto (game language), English, Deutsch, Français, Español, Português (Brasil), Русский, 简体中文 | auto English",
        "a row each: Auto, then every language by its own name; Auto to start, which shows English here")
    local _, top, _, bottom = H.Rect(old.language)
    local _, noteTop, _, noteBottom = H.Rect(old.languageNote)
    local _, _, _, pageBottom = H.Rect(old.pages.language)
    Equal(S[old.language.buttons[1]].height .. " " .. (bottom - top) .. " " .. S[old.language].width .. " "
        .. tostring(noteTop >= bottom + 8) .. " " .. tostring(noteBottom <= pageBottom), "24 194 400 true true",
        "rows 24 tall, the list 194 by 400, what it covers under it, all on the page")
    Equal(Note(old.language.byKey.auto) .. " | " .. Note(old.language.byKey.deDE),
        "The language of this window, What's new and the addon's lines in chat. Auto follows your game's language, with one Spanish"
        .. " for Spain and Latin America; Traditional Chinese and any other game get English. | Switch to Deutsch.",
        "Auto says what it covers and how Auto picks; a language, that a click switches to it")
    Equal(S[old.languageNote].text, Note(old.language.byKey.auto), "the same line under the list")
    -- English on an English game already: Auto to English changes nothing.
    old.language.byKey.enUS:Click()
    Equal(tostring(FECPFrame == old) .. " " .. ForeverEnhancedCooldownPulseDB.language .. " " .. old.language.selected .. " "
        .. tostring(S[old.language.byKey.enUS.fill].shown) .. " " .. tostring(S[old.language.byKey.auto.fill].shown) .. " | "
        .. Note(old.language.byKey.enUS), "true enUS enUS true false | You're already using English.",
        "English on an English game: saved and lit, the window as it is")
    -- What's new open, and both dragged somewhere: each language makes both
    -- again in its words, where they were, open on Language.
    ns.ShowNotes()
    old:ClearAllPoints()
    old:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 123, 456)
    FECPNotes:ClearAllPoints()
    FECPNotes:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 40, 700)
    local function Anchors(frame)
        local out = {}
        for _, p in ipairs(S[frame].points) do
            out[#out + 1] = table.concat({ tostring(p[1]), p[2] == UIParent and "UIParent" or tostring(p[2]), tostring(p[3]),
                tostring(p[4]), tostring(p[5]) }, " ")
        end
        return table.concat(out, ", ")
    end
    local before, beforeNotes = old, FECPNotes
    for _, lang in ipairs(LANGUAGES) do
        before.language.byKey[lang]:Click()
        local w = FECPFrame
        local words = ns.LOCALES[lang]
        Equal(tostring(w ~= before) .. " " .. tostring(S[before].shown) .. " " .. tostring(S[w].shown) .. " " .. w.selected .. " "
            .. w.language.selected .. " " .. ForeverEnhancedCooldownPulseDB.language .. " " .. ns.Language(),
            "true false true language " .. lang .. " " .. lang .. " " .. lang,
            lang .. ": the window made again in it, open on Language as it was; the old one hidden for good")
        Equal(S[w.nav.language.label].text .. " | " .. S[FECPNotes.done.label].text .. " " .. tostring(S[FECPNotes].shown) .. " "
            .. tostring(FECPNotes ~= beforeNotes), words["Language"] .. " | " .. words["Got it"] .. " true true",
            lang .. ": its words, and What's new open again, made again in them")
        Equal(Anchors(w) .. " | " .. Anchors(FECPNotes), "TOPLEFT UIParent BOTTOMLEFT 123 456 | TOPLEFT UIParent BOTTOMLEFT 40 700",
            lang .. ": the window and What's new made again where they were dragged to")
        Equal(tostring(next(S[beforeNotes].events)) .. " " .. tostring(next(S[FECPNotes].events) ~= nil), "nil true",
            lang .. ": the old What's new listens for nothing now, the new one for the screen's size")
        before, beforeNotes = w, FECPNotes
    end
    local w = FECPFrame
    w:Select("general")
    Equal(S[w.nav.general.label].text .. " | " .. S[w.about].text, "常规 | Forever Enhanced Cooldown Pulse 开发版。由 Squirt 制作。"
        .. "输入 /fecp 打开此窗口。", "Chinese last: its words")
    -- A new accent repaints the new window and What's new, never the old
    -- ones (their rows, profile menu and tour box too): their painters went
    -- with them.
    local function Looks(root)
        local out = {}
        local function Add(c)
            if type(c) == "table" then out[#out + 1] = tostring(c[1] or c.r) .. "," .. tostring(c[2] or c.g) .. "," .. tostring(c[3] or c.b) end
        end
        for _, obj in ipairs(H.objects) do
            if H.Inside(obj, root) then
                local s = S[obj]
                Add(s.border)
                Add(s.color)
                Add(s.colour)
                Add(s.tint)
                if s.last.SetGradient then Add(s.last.SetGradient[3]) end
                if type(s.text) == "string" then out[#out + 1] = s.text end
            end
        end
        return table.concat(out, ";")
    end
    local was, fresh = Looks(old), Looks(w) .. " | " .. Looks(FECPNotes)
    for _, swatch in ipairs(w.swatches) do
        if swatch.key == "green" then swatch:Click() end
    end
    Equal(tostring(Looks(old) == was) .. " " .. tostring(Looks(w) .. " | " .. Looks(FECPNotes) ~= fresh),
        "true true", "a new accent: the new window and What's new repainted, the old ones left be")
    FECPNotes:Hide()
    local open
    for _, f in ipairs(H.frames) do
        if S[f].parent == H.category.canvas and S[f].template == "UIPanelButtonTemplate" then open = f end
    end
    Equal(S[open].text, "打开设置", "Options > AddOns in Chinese too")
    ns.Tour:Start()
    Equal(tostring(S[FECPTour].shown) .. " " .. tostring(H.Inside(FECPTour, w)) .. " " .. S[FECPTour.title].text, "true true 开启冷却提示",
        "the tour starts again, on the new window, in Chinese")
    FECPTour.skip:Click()
    Equal(S[w.note].text, "随时可从「常规」页面或输入 /fecp tour 开始导览。", "and says so in Chinese")
    -- Escape still closes it, listed once; no new names in the game's space.
    local listed = 0
    for _, name in ipairs(UISpecialFrames) do
        if name == "FECPFrame" then listed = listed + 1 end
    end
    Equal(tostring(CloseSpecialWindows()) .. " " .. tostring(S[w].shown) .. " " .. listed, "1 false 1", "Escape closes the new window")
    ns.ShowWindow()
    -- Back to English, then Auto on this English game.
    w:Select("general")
    w.language.byKey.enUS:Click()
    local back = FECPFrame
    Equal(S[back.nav.general.label].text .. " " .. back.selected .. " " .. S[open].text, "General general Open settings", "English again, at once")
    back.language.byKey.auto:Click()
    Equal(tostring(FECPFrame == back) .. " " .. ForeverEnhancedCooldownPulseDB.language, "true auto", "Auto on an English game: English, as it is")
    -- Sentences join with a space but in Chinese.
    Equal(ns.Join("One.", nil, "", "Two."), "One. Two.", "sentences, a space between")
    Equal(H.Problems(), "", "no errors from switching")
end

Equal(H.Problems(), "", "no errors")
io.write("Locale checks passed: " .. H.checks .. " assertions.\n")
