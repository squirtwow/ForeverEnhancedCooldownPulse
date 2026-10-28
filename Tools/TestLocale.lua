-- Run the addon's real files against a mock game (Tools/Harness.lua) in
-- Simplified Chinese: picked by hand on an English game, and Auto on a
-- Simplified Chinese one. Every page, the profile menu and its questions,
-- the tour and each page's walkthrough, the welcome, What's new, the link
-- box, the minimap button's tooltip, the box that moves the pulse, the entry
-- in Options > AddOns and the update notice in chat: no English left on
-- screen or in any hover note but names (the addon's, Squirt's other addons',
-- the game's for spells, items and the character), links, commands and
-- keys, every word looked up found, and everything still fitting. Then Auto
-- on other games (English), and the language switched on the General page
-- while the window is open: made again at once in the new words, as it was.
-- Run with: fengari Tools/TestLocale.lua
local H = assert(loadfile("Tools/Harness.lua"))()
local S, Equal, Note = H.S, H.Equal, H.Note

-- Words that stay as they are: names, brands, keys, the mock game's own
-- names (its spells, items and character, which a Chinese game gives in
-- Chinese) and a profile name the test types.
local KEEP = { "Forever Enhanced Cooldown Pulse", "Forever Enhanced Cooldown Manager", "WoW Forever", "Forever", "EraUI",
    "Squirt", "Discord", "CurseForge", "GitHub", "Install", "Ctrl+C", "Esc", "English", "Read Leyline",
    "Zriel (Druid) - Zephras", "Walk on Air", "Barkskin", "Overpower", "Bash", "Lucky Charm", "Hearthstone", "dev", "Raids" }
table.sort(KEEP, function(a, b) return #a > #b end)

-- The English left in a text once the names, links, commands and keys are
-- taken out (in capitals too, as headings show them), or nil.
local function English(text)
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):gsub("https?://%S+", "")
    for _, word in ipairs(KEEP) do
        text = text:gsub((word:gsub("%p", "%%%0")), ""):gsub((word:upper():gsub("%p", "%%%0")), "")
    end
    text = text:gsub("/%l+ %l+", ""):gsub("/%l+", ""):gsub("%f[%a][xX]%f[%A]", "")
    return text:match("%a+")
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

-- What's still English, as one line: "" when there's none.
local found = {}
local function Look(label, root)
    for _, text in ipairs(Showing(root)) do
        local left = English(text)
        if left then found[#found + 1] = label .. ": " .. text end
    end
end

-- Every word looked up while Chinese shows that has no Chinese.
local missing = {}
local function Watch(ns)
    local meta = getmetatable(ns.L)
    local base = meta.__index
    meta.__index = function(t, english)
        local text = base(t, english)
        if text == english and ns.Language() == "zhCN" then missing[#missing + 1] = tostring(english) end
        return text
    end
end

-- A game with a trinket worn, a potion and a hearthstone carried, so the list has items.
local function Gear()
    H.worn[13] = 9999
    H.counts[118] = 2
    H.bag = { { itemID = 6948, hyperlink = "|cffffffff|Hitem:6948|h[Hearthstone]|h|r", iconFileID = 134414 } }
    H.counts[6948] = 1
end

-- The window in Chinese, everywhere ---------------------------------------------------------------

local function Everywhere(ns, label)
    local P, T = ns.Pulse, ns.Theme
    ns.ShowWindow()
    local w = FECPFrame
    -- Both pages, in their states.
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
    Look(label .. " General")
    H.addOns.EraUI = true
    w:Select("pulse")
    w:Select("general")
    Look(label .. " General, EraUI loaded")
    H.addOns.EraUI = nil
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
    own.remove:Click()
    Look(label .. " deleting")
    w.confirm.no:Click()
    w.profileEveryone:Click()
    Look(label .. " use on all")
    w.confirm.yes:Click()
    w.profileButton:Click()
    Look(label .. " on all")
    w.profileButton:Click()
    -- The tour, the welcome and each page's walkthrough, each box fitting.
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
            box.next:Click()
        until not S[box].shown or steps > 10
        Look(label .. " " .. name .. " done")
        return steps
    end
    Equal(Walk(function() ns.Tour:Start() end, "tour"), 5, label .. ": the tour's five steps")
    Equal(Walk(function() w:Select("pulse"); w.help:Click() end, "pulse walkthrough"), 5, label .. ": the pulse page's walkthrough")
    Equal(Walk(function() w:Select("general"); w.help:Click() end, "General walkthrough"), 4, label .. ": General's walkthrough")
    ns.Tour:Welcome()
    Look(label .. " welcome")
    FECPTour.skip:Click()
    Look(label .. " skipped")
    Equal(table.concat(fits, "; "), "", label .. ": each tour box on its page, clear of its part")
    -- The ?'s tooltip and note, What's new, the link box and the minimap button.
    S[w.help].scripts.OnEnter(w.help)
    Look(label .. " ? tooltip", T.tip)
    S[w.help].scripts.OnLeave(w.help)
    ns.ShowNotes()
    Look(label .. " What's new", FECPNotes)
    S[FECPNotes.tour].scripts.OnEnter(FECPNotes.tour)
    Look(label .. " What's new tooltip", T.tip)
    FECPNotes:Hide()
    w:Select("general")
    w.discord:Click()
    Look(label .. " Discord", FECPCopyLink)
    w.more[1].links[1]:Click()
    Look(label .. " CurseForge link", FECPCopyLink)
    FECPCopyLink.close:Click()
    local button = FECPMinimapButton
    S[button].scripts.OnEnter(button)
    Look(label .. " minimap tooltip", T.tip)
    S[button].scripts.OnLeave(button)
    -- The box that moves the pulse.
    P:StartMove()
    Look(label .. " moving", P.mover)
    P:StopMove(true)
    -- Options > AddOns.
    Look(label .. " Options", H.category.canvas)
    -- Everything fits in Chinese too.
    local laid = {}
    for _, key in ipairs({ "pulse", "general" }) do
        w:Select(key)
        local problems = H.Problems2D(w.pages[key])
        if problems ~= "" then laid[#laid + 1] = key .. ": " .. problems end
    end
    local bars = H.Problems2D(w.navFrame) .. H.Problems2D(w.header)
    if bars ~= "" then laid[#laid + 1] = "list or title bar: " .. bars end
    Equal(table.concat(laid, " | "), "", label .. ": everything inside its page, nothing on anything else")
    -- Each button's and choice's label inside it, each slider's label and
    -- value clear of its track, and the title row clear of Preview.
    local tight = {}
    local page = w.pages.pulse
    for _, bar in ipairs({ page.edit, page.border, w.language, page.rows[2] and page.rows[2].style }) do
        for _, b in ipairs(bar and bar.buttons or {}) do
            local name = S[b.label]
            if H.Wide(name.text, name.template) + 4 > S[b].width then tight[#tight + 1] = name.text end
        end
    end
    for _, b in ipairs({ page.previewButton, page.move, page.reset, w.tour, w.news, w.profileActions.new, w.profileActions.copy,
        w.profileActions.rename, w.confirm.yes, w.confirm.no, FECPTour.next, FECPTour.back, FECPTour.skip, FECPNotes.tour, FECPNotes.done }) do
        local name = S[b.label]
        if H.Wide(name.text, name.template) + 4 > S[b].width then tight[#tight + 1] = name.text end
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
    for _, said in ipairs({ "已关闭。勾选下方的选项即可开启。", "还没有要提示的冷却：在下方勾选一些。", "12 个冷却会在就绪时提示。",
        "改由 Forever Enhanced Cooldown Manager 运行。" }) do
        longest = math.max(longest, H.Wide(said, S[page.status].template))
    end
    if from + longest + 8 > 638 - 16 - S[page.previewButton].width then tight[#tight + 1] = "the title row" end
    Equal(table.concat(tight, ", "), "", label .. ": every label, value and name inside its own room")
    w:Hide()
end

-- Simplified Chinese picked by hand, on an English game.
do
    H.locale = "enUS"
    H.Environment()
    Gear()
    local ns = H.Load({ notesSeen = "dev", language = "zhCN" })
    Watch(ns)
    H.Tick(ns)
    Equal(ns.Language() .. " " .. ns.Get("language"), "zhCN zhCN", "picked by hand: Simplified Chinese, on an English game")
    Everywhere(ns, "by hand")
    local w = FECPFrame
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
    -- The update notice in chat.
    local said = {}
    local print = _G.print
    _G.print = function(line) said[#said + 1] = line end
    SquirtVersions:Tell(SquirtVersions.addons.CP, "1.0.5", "1.0.4")
    _G.print = print
    Equal(said[1], "|cffffd100Forever Enhanced Cooldown Pulse|r 1.0.5 已发布（你的版本为 1.0.4）。请在 CurseForge 更新。",
        "the update notice in chat, in Chinese")
    Equal(table.concat(found, "\n"), "", "no English left on screen or in a hover note, but names, links, commands and keys")
    Equal(table.concat(missing, " | "), "", "every word looked up has its Chinese")
    Equal(H.Problems(), "", "no errors")
end

-- Auto on a Simplified Chinese game.
do
    H.locale = "zhCN"
    H.Environment()
    Gear()
    local ns = H.Load({ notesSeen = "dev" })
    Watch(ns)
    H.Tick(ns)
    Equal(ns.Language() .. " " .. ns.Get("language") .. " " .. tostring(ForeverEnhancedCooldownPulseDB.language),
        "zhCN auto nil", "Auto on a Simplified Chinese game: Chinese, the choice not even saved")
    Everywhere(ns, "auto")
    Equal(table.concat(found, "\n"), "", "no English left with Auto either")
    Equal(table.concat(missing, " | "), "", "every word looked up has its Chinese")
    Equal(H.Problems(), "", "no errors")
end

-- Auto on any other game is English; a bad saved choice is Auto ----------------------------------------

do
    local seen = {}
    for _, locale in ipairs({ "enUS", "zhTW", "deDE", "koKR" }) do
        H.locale = locale
        local ns = H.Start({ notesSeen = "dev", helpSeen = true })
        ns.ShowWindow()
        seen[#seen + 1] = locale .. "=" .. ns.Language() .. " " .. S[FECPFrame.nav.general.label].text
    end
    Equal(table.concat(seen, ", "), "enUS=enUS General, zhTW=enUS General, deDE=enUS General, koKR=enUS General",
        "Auto: English on every game but a Simplified Chinese one (Traditional Chinese picks it by hand)")
    H.locale = "zhTW"
    local ns = H.Start({ notesSeen = "dev", helpSeen = true, language = "zhCN" })
    Equal(ns.Language(), "zhCN", "a Traditional Chinese game can pick Simplified Chinese by hand")
    H.locale = "zhCN"
    ns = H.Start({ notesSeen = "dev", helpSeen = true, language = "enUS" })
    Equal(ns.Language(), "enUS", "and a Simplified Chinese game English")
    local bad = {}
    for _, value in ipairs({ "frFR", 1, true, {} }) do
        ns = H.Start({ notesSeen = "dev", helpSeen = true, language = value })
        bad[#bad + 1] = ns.Get("language") .. "=" .. ns.Language()
    end
    Equal(table.concat(bad, " "), "auto=zhCN auto=zhCN auto=zhCN auto=zhCN", "a bad saved choice is Auto")
    H.locale = "enUS"
    Equal(H.Problems(), "", "no errors")
end

-- Switched on the General page: at once, no reload ----------------------------------------------------

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
    old:Select("general")
    Equal(S[old.language.buttons[1].label].text .. ", " .. S[old.language.buttons[2].label].text .. ", "
        .. S[old.language.buttons[3].label].text .. " | " .. old.language.selected, "Auto (game language), English, 简体中文 | auto",
        "Auto, English and 简体中文, each by its own name; Auto to start")
    Equal(Note(old.language.buttons[3]), "The language of this window, What's new and the addon's lines in chat. Auto follows your"
        .. " game: Simplified Chinese on a Simplified Chinese game, English on any other. (experimental)",
        "it says what it does, the quiet way, and that Auto is English on a Traditional Chinese game")
    -- English on an English game already: Auto to English changes nothing.
    old.language.buttons[2]:Click()
    Equal(tostring(FECPFrame == old) .. " " .. ForeverEnhancedCooldownPulseDB.language .. " " .. old.language.selected, "true enUS enUS",
        "English on an English game: saved, the window as it is")
    -- What's new open, and both dragged somewhere: 简体中文 makes both again
    -- in Chinese, where they were.
    ns.ShowNotes()
    local oldNotes = FECPNotes
    old:ClearAllPoints()
    old:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 123, 456)
    oldNotes:ClearAllPoints()
    oldNotes:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 40, 700)
    old.language.buttons[3]:Click()
    local w = FECPFrame
    Equal(tostring(w ~= old) .. " " .. tostring(S[old].shown) .. " " .. tostring(S[w].shown) .. " " .. w.selected .. " "
        .. w.language.selected .. " " .. ForeverEnhancedCooldownPulseDB.language, "true false true general zhCN zhCN",
        "简体中文: the window made again in Chinese, open on General as it was; the old one hidden for good")
    Equal(S[w.nav.general.label].text .. " | " .. S[w.about].text, "常规 | Forever Enhanced Cooldown Pulse 开发版。由 Squirt 制作。"
        .. "输入 /fecp 打开此窗口。", "its words in Chinese")
    Equal(tostring(S[FECPNotes].shown) .. " " .. tostring(FECPNotes ~= oldNotes) .. " " .. S[FECPNotes.done.label].text, "true true 知道了",
        "What's new open again, made again in Chinese")
    local function Anchors(frame)
        local list = {}
        for _, p in ipairs(S[frame].points) do
            list[#list + 1] = table.concat({ tostring(p[1]), p[2] == UIParent and "UIParent" or tostring(p[2]), tostring(p[3]),
                tostring(p[4]), tostring(p[5]) }, " ")
        end
        return table.concat(list, ", ")
    end
    Equal(Anchors(w) .. " | " .. Anchors(FECPNotes), "TOPLEFT UIParent BOTTOMLEFT 123 456 | TOPLEFT UIParent BOTTOMLEFT 40 700",
        "the window and What's new made again where they were dragged to")
    -- A new accent repaints the new window and What's new, never the old
    -- ones (their rows, profile menu and tour box too): their painters went
    -- with them.
    local function Looks(root)
        local list = {}
        local function Add(c)
            if type(c) == "table" then list[#list + 1] = tostring(c[1] or c.r) .. "," .. tostring(c[2] or c.g) .. "," .. tostring(c[3] or c.b) end
        end
        for _, obj in ipairs(H.objects) do
            if H.Inside(obj, root) then
                local s = S[obj]
                Add(s.border)
                Add(s.color)
                Add(s.colour)
                Add(s.tint)
                if s.last.SetGradient then Add(s.last.SetGradient[3]) end
                if type(s.text) == "string" then list[#list + 1] = s.text end
            end
        end
        return table.concat(list, ";")
    end
    local was, fresh = Looks(old) .. " | " .. Looks(oldNotes), Looks(w) .. " | " .. Looks(FECPNotes)
    for _, swatch in ipairs(w.swatches) do
        if swatch.key == "green" then swatch:Click() end
    end
    Equal(tostring(Looks(old) .. " | " .. Looks(oldNotes) == was) .. " " .. tostring(Looks(w) .. " | " .. Looks(FECPNotes) ~= fresh),
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
    w.language.buttons[2]:Click()
    local back = FECPFrame
    Equal(S[back.nav.general.label].text .. " " .. back.selected .. " " .. S[open].text, "General general Open settings", "English again, at once")
    back.language.buttons[1]:Click()
    Equal(tostring(FECPFrame == back) .. " " .. ForeverEnhancedCooldownPulseDB.language, "true auto", "Auto on an English game: English, as it is")
    -- Sentences join with a space in English.
    Equal(ns.Join("One.", nil, "", "Two."), "One. Two.", "English sentences, a space between")
    Equal(H.Problems(), "", "no errors from switching")
end

Equal(H.Problems(), "", "no errors")
io.write("Locale checks passed: " .. H.checks .. " assertions.\n")
