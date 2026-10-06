-- Run the addon's real files against a mock game (Tools/Harness.lua) for the
-- /fecp window round the pulse: its title bar (icon, name, profile menu, ?
-- and X), its short list (Cooldown pulse and General), the General page
-- (the tour, What's new, the Discord, the minimap button, the accent and the
-- version), the ? with its tooltip, first-time pulse and note, the welcome
-- and the tour, each page's walkthrough, What's new, Escape, /fecp, the
-- entry in Options > AddOns, the minimap button, the profile menu, the
-- debug report, and that everything fits.
-- Run with: fengari Tools/TestWindow.lua
local H = assert(loadfile("Tools/Harness.lua"))()
local S, Equal, Last, Fire, Note = H.S, H.Equal, H.Last, H.Fire, H.Note

-- A frame of the game going by: the ?'s pulse and note run while the
-- window is on screen and the ? has never been clicked.
local function Step(w, elapsed)
    local driver = w.helpNudge.driver
    if driver:IsVisible() then S[driver].scripts.OnUpdate(driver, elapsed or 0) end
end
-- The note under the ?, and the ?'s glow: each on screen or not.
local function Nudge(w)
    return tostring(w.helpNudge:IsVisible()) .. " " .. tostring(w.help.glow:IsVisible())
end
local function Num(v) return ("%.2f"):format(v) end
-- The tour box: its count, the page showing, and its title.
local function Box(w)
    local box = FECPTour
    return S[box.count].text .. " " .. w.selected .. " " .. S[box.title].text
end

-- The title bar and the list ------------------------------------------------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    SlashCmdList.FECP("")
    local w, T = FECPFrame, ns.Theme
    Equal(tostring(S[w].shown) .. " " .. S[w].width .. "x" .. S[w].height .. " " .. Last(w, "SetFrameStrata") .. " "
        .. tostring(Last(w, "SetClampedToScreen")) .. " " .. tostring(Last(w, "SetMovable")), "true 790x560 FULLSCREEN_DIALOG true true",
        "/fecp opens the window, Forever Enhanced Cooldown Manager's size bar a narrower list, on screen and movable")
    local header = w.header
    Equal(S[header.icon].texture, ns.MEDIA .. "FECPIcon.tga", "the addon's own icon in the title bar")
    local title
    for _, obj in ipairs(H.objects) do
        if S[obj].parent == header and S[obj].kind == "FontString" then title = obj end
    end
    Equal(S[title].text, "Forever |cffb07df0Enhanced|r Cooldown Pulse", "its name, Enhanced in the purple accent")
    local hp, pp = S[w.help].points[1], S[w.profileButton].points[1]
    Equal(S[w.help.label].text .. " " .. S[w.help].width .. "x" .. S[w.help].height .. " " .. hp[1] .. " " .. tostring(hp[2] == w.close) .. " "
        .. hp[3] .. " " .. hp[4] .. " | " .. pp[1] .. " " .. tostring(pp[2] == w.help) .. " " .. pp[3] .. " " .. pp[4] .. " | "
        .. tostring(w.help.hint), "? 22x22 RIGHT true LEFT -6 | RIGHT true LEFT -8 | nil",
        "a ? square beside the X, the profile menu left of it; the ? has a tooltip, not a footer note")
    local profileLeft = H.Rect(w.profileButton)
    local _, _, titleRight = H.Rect(title)
    Equal(tostring(titleRight + 20 <= profileLeft) .. " " .. profileLeft, "true 441", "the title clear of the profile menu, which starts at 441")
    Equal(S[w.profileButton.label].text, "|cff8b8d92Profile|r   Zriel (Druid) - Zephras", "the profile this character uses")
    -- The list: Cooldown pulse, then General, nothing else.
    local keys = {}
    for key in pairs(w.nav) do keys[#keys + 1] = key end
    table.sort(keys)
    Equal(table.concat(keys, ",") .. " | " .. S[w.nav.pulse.label].text .. " " .. S[w.nav.pulse].points[1][3] .. " | "
        .. S[w.nav.general.label].text .. " " .. S[w.nav.general].points[1][3] .. " | " .. S[w.navFrame].width,
        "general,pulse | Cooldown pulse -12 | General -44 | 150", "a short list: Cooldown pulse at the top, then General")
    Equal(Note(w.nav.pulse) .. " | " .. Note(w.nav.general), "A big icon in the middle of your screen when a cooldown is ready."
        .. " | The tour, What's new, the Discord, the minimap button and this window's accent.", "each says what it's for")
    w.nav.general:Click()
    Equal(w.selected .. " " .. tostring(S[w.pages.general].shown) .. " " .. tostring(S[w.pages.pulse].shown) .. " "
        .. tostring(S[w.nav.general.fill].shown) .. " " .. tostring(S[w.nav.pulse.fill].shown), "general true false true false",
        "General clicked: its page, highlighted")
    w.nav.pulse:Click()
    Equal(w.selected, "pulse", "and back")
    -- The footer: the version and how to open it on the left; on the right
    -- the credit, or a note for whatever is under the mouse.
    Equal(S[w.versionText].text, "dev   /fecp to open", "the version, and how to open it")
    Equal(S[w.note].text:find("by |cffb07df0Squirt|r", 1, true) ~= nil, true, "the credit, the name in the accent")
    S[w.close].scripts.OnEnter(w.close)
    Equal(S[w.note].text, "Close the window. Escape closes it too, and /fecp opens it again.", "hovered: the X says what it does")
    S[w.close].scripts.OnLeave(w.close)
    Equal(S[w.note].text:find("Squirt", 1, true) ~= nil, true, "off it, the footer rests")
    -- Everything fits: the title bar, the list and both pages, in their states.
    local found = {}
    local function Check(key, label)
        w:Select(key)
        local problems = H.Problems2D(w.pages[key])
        if problems ~= "" then found[#found + 1] = (label or key) .. ": " .. problems end
    end
    Check("pulse")
    Check("general")
    local bars = H.Problems2D(w.navFrame) .. H.Problems2D(w.header)
    if bars ~= "" then found[#found + 1] = "list or title bar: " .. bars end
    ns.Set("pulse", false)
    Check("pulse", "pulse off")
    ns.Set("pulse", true)
    H.Manager({ pulse = true })
    Check("pulse", "pulse in Forever Enhanced Cooldown Manager")
    H.Manager(nil)
    Equal(table.concat(found, " | "), "", "on both pages and in every state, each label clear of the next control, all inside the page")
    Equal(H.Problems(), "", "no errors")
end

-- The General page ------------------------------------------------------------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    ns.ShowWindow()
    local w, T = FECPFrame, ns.Theme
    w:Select("general")
    local page = w.pages.general
    local headings = {}
    for _, obj in ipairs(H.objects) do
        if S[obj].parent == page and S[obj].kind == "FontString" and S[obj].template == "GameFontNormalSmall" then
            headings[#headings + 1] = S[obj].text
        end
    end
    Equal(table.concat(headings, ", "), "HELP, MINIMAP BUTTON, WINDOW ACCENT, ABOUT", "help, the minimap button, the accent and about")
    Equal(S[w.tour.label].text .. ", " .. S[w.news.label].text .. ", " .. S[w.discord.label].text, "Take the tour, What's new, Discord",
        "the tour, What's new and the Discord, side by side")
    Equal(Note(w.tour) .. " | " .. Note(w.discord), "A short tour of this window, a page at a time. /fecp tour starts it too."
        .. " | The Discord invite, ready to copy: bugs, ideas and help.", "each says what it does")
    -- What's new: 1.0.0's notes, so it can be clicked (greyed out only
    -- while there are none).
    Equal(tostring(w.news.usable) .. " " .. S[w.news].alpha .. " " .. Note(w.news), "true 1 What changed in this version. /fecp new shows it too.",
        "What's new can be clicked now there are notes")
    w.news:Click()
    Equal(tostring(FECPNotes ~= nil and S[FECPNotes].shown), "true", "and clicking it shows them")
    FECPNotes:Hide()
    -- The Discord: the same server as Forever Enhanced Cooldown Manager's.
    w.discord:Click()
    local copy = FECPCopyLink
    Equal(tostring(S[copy].shown) .. " " .. S[copy.title].text .. " " .. S[copy.input].text .. " " .. tostring(S[copy.input].focus),
        "true JOIN THE DISCORD https://discord.gg/FVfcDWJncr true", "the invite to copy, selected")
    copy.input:SetText("typed")
    S[copy.input].scripts.OnTextChanged(copy.input)
    Equal(S[copy.input].text, "https://discord.gg/FVfcDWJncr", "it can't be changed")
    copy.close:Click()
    -- The minimap button: on, and off from here.
    local button = FECPMinimapButton
    Equal(tostring(w.minimap.checked) .. " " .. tostring(S[button].shown), "true true", "the minimap button, on")
    w.minimap:Click()
    Equal(tostring(ns.Get("minimap")) .. " " .. tostring(S[button].shown) .. " " .. tostring(ForeverEnhancedCooldownPulseDB.minimap), "false false false",
        "unticked: hidden, and saved")
    w.minimap:Click()
    Equal(tostring(S[button].shown), "true", "ticked: back")
    -- The accent: purple to start; a swatch picks another, the whole window repaints.
    local chosen = {}
    for _, swatch in ipairs(w.swatches) do
        if S[swatch].border and S[swatch].border[1] == 1 then chosen[#chosen + 1] = swatch.key end
    end
    Equal(table.concat(chosen, ",") .. " " .. S[w.accentName].text, "purple Purple", "purple to start, outlined in white")
    w.swatches[3]:Click()
    local teal = T.ACCENTS.teal.colour
    Equal(ns.Get("accent") .. " " .. S[w.accentName].text .. " " .. tostring(S[w.nav.general.mark].color[1] == teal[1]), "teal Teal true",
        "Teal picked: saved, and the window repaints")
    w.swatches[4]:Click()
    -- About: which version this is.
    Equal(S[w.about].text, "Forever Enhanced Cooldown Pulse, a copy straight from the source. Made by Squirt. Type /fecp to open this window.",
        "the version, in plain words")
    Equal(H.Problems(), "", "no errors")
end

-- The ?'s tooltip: just under it, in the addon's own look ------------------------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    SlashCmdList.FECP("")
    local w, T = FECPFrame, ns.Theme
    local help = w.help
    local resting = S[w.note].text
    S[help].scripts.OnEnter(help)
    local tip = T.tip
    local p = S[tip].points[1]
    Equal(S[tip.title].text .. " | " .. S[tip.text].text .. " | " .. tostring(S[tip].shown) .. " | " .. p[1] .. " " .. tostring(p[2] == help)
        .. " " .. p[3] .. " " .. p[4] .. " " .. p[5] .. " | " .. tostring(Last(tip, "SetClampedToScreen")) .. " " .. Last(tip, "SetFrameStrata"),
        "PAGE HELP | Walks you through this page, a step at a time. | true | TOPRIGHT true BOTTOMRIGHT 0 -6 | true TOOLTIP",
        "hovered: Page help, just under the ?, lined up with its right edge, kept on screen")
    Equal(tostring(S[w.note].text == resting), "true", "the footer stays as it was")
    S[help].scripts.OnLeave(help)
    Equal(tostring(S[tip].shown), "false", "gone as the mouse leaves")
    S[help].scripts.OnEnter(help)
    help:Click()
    Equal(tostring(S[tip].shown) .. " " .. tostring(S[FECPTour].shown), "false true", "clicked: gone, and the page's walkthrough starts")
    FECPTour.skip:Click()
    S[help].scripts.OnEnter(help)
    w:Hide()
    Equal(tostring(S[tip].shown), "false", "gone with the window")
    Equal(H.Problems(), "", "no errors from the tooltip")
end

-- A first install: the welcome, the tour, and the ?'s pulse and note ----------------------------

do
    local ns = H.Start(nil)
    local db = ForeverEnhancedCooldownPulseDB
    Equal(tostring(ns.firstInstall) .. " " .. tostring(db.helpSeen) .. " " .. tostring(ns.HelpSeen()) .. " " .. tostring(FECPFrame),
        "true nil false nil", "a first install: nothing shown at once, the ? not clicked yet")
    H.RunTimers()
    local w, box = FECPFrame, FECPTour
    Step(w, .5)
    Equal(S[box.title].text .. " " .. tostring(S[box].shown) .. " " .. tostring(S[box.count].shown) .. " " .. S[box.next.label].text .. " "
        .. S[box.skip.label].text .. " | " .. Nudge(w), "WELCOME true false Take the tour Skip | false false",
        "a moment after login: the window opens with a welcome offering the tour; no note, no pulse meanwhile")
    Equal(S[box.text].text, "New to Forever Enhanced Cooldown Pulse? A quick tour shows you the basics, a page at a time. It takes about a minute.",
        "the welcome says what it offers")
    box.next:Click()
    local titles, fits = {}, {}
    local steps = 0
    repeat
        steps = steps + 1
        Step(w, .3)
        titles[#titles + 1] = Box(w)
        if w.helpNudge:IsVisible() or w.help.glow:IsVisible() then titles[#titles + 1] = "(nudge showing)" end
        local wrong = H.BoxFits(w.pages[w.selected])
        if wrong ~= "" then fits[#fits + 1] = S[box.title].text .. ": " .. wrong end
        box.next:Click()
    until not S[box].shown or steps > 10
    Equal(table.concat(titles, " | "), "1 of 5 pulse TURN IT ON | 2 of 5 pulse PICK YOUR COOLDOWNS | 3 of 5 pulse QUICK AND LONG"
        .. " | 4 of 5 pulse WHERE IT SHOWS | 5 of 5 general GENERAL",
        "the tour: the pulse page's four steps, then General; the note and pulse hidden throughout")
    Equal(table.concat(fits, "; "), "", "each step's box on its page, clear of the part it points at")
    Step(w, 0)
    Equal(S[w.note].text .. " | " .. w.selected .. " " .. Nudge(w),
        "That's the tour. Take the tour any time from the General page, or with /fecp tour. | general true true",
        "done: where to find it again; the note and the pulse back, on General")
    Equal(tostring(ns.Get("pulse")) .. " " .. tostring(db.pulsePick and next(db.pulsePick)), "true nil", "the tour changed nothing")
    -- The first step on a first install: already on.
    SlashCmdList.FECP("tour")
    Equal(Box(w) .. " | " .. tostring(S[box.text].text:find("It's already on.", 1, true) ~= nil) .. " "
        .. tostring(S[box.outline].points[1][2] == w.pages.pulse.master), "1 of 5 pulse TURN IT ON | true true",
        "/fecp tour: from the start, the pulse's tick outlined, already on")
    box.skip:Click()
    Equal(S[w.note].text, "Take the tour any time from the General page, or with /fecp tour.", "Skip tour says where to find it")
    -- Off, the first step asks to tick it, and moves on once it's ticked.
    ns.Set("pulse", false)
    w.tour:Click()
    Equal(tostring(S[box.text].text:find("Try it: tick it.", 1, true) ~= nil), "true", "off: try it")
    w.pages.pulse.master:Click()
    S[box].scripts.OnUpdate(box, 1)
    Equal(Box(w), "2 of 5 pulse PICK YOUR COOLDOWNS", "ticked: on to the next step by itself")
    box.skip:Click()
    -- Over the profile menu and What's new: hidden while they're open.
    Step(w, 0)
    w.profileButton:Click()
    Step(w, 0)
    local menu = Nudge(w)
    w.profileButton:Click()
    w:Select("general")
    Step(w, 0)
    Equal(menu .. " | " .. Nudge(w), "false false | true true", "not over the profile menu")
    -- The pulse: slow and light, dim to lit and back, in the accent.
    w:Hide()
    Equal(tostring(S[w.helpNudge].shown) .. " " .. tostring(S[w.help.glow].shown), "false false", "closed: both go with the window")
    w:Show()
    Step(w, 0)
    local glow, T = w.help.glow, ns.Theme
    local accent, edge = T:Accent(), T.CONTROL_BORDER
    local function Pulse() return Num(S[glow].alpha) .. " " .. Num(S[w.help].border[1]) end
    local dim = Pulse()
    Step(w, 1.2)
    local lit = Pulse()
    Equal(dim .. " | " .. lit, Num(0) .. " " .. Num(edge[1]) .. " | " .. Num(.3) .. " " .. Num(edge[1] + (accent[1] - edge[1]) * .8),
        "dim as it opens, lit after 1.2 seconds")
    -- Where the note sits: under the title bar, inside the window, its arrow
    -- pointing up at the ?, clear of the title bar's buttons.
    local nudge = w.helpNudge
    local l, t, r, b = H.Rect(nudge)
    local _, _, _, headerBottom = H.Rect(w.header)
    local al, at, ar = H.Rect(nudge.arrow)
    local hl, _, hr, hb = H.Rect(w.help)
    Equal(tostring(l >= 0 and r <= 790 and b <= 560) .. " " .. tostring(t >= headerBottom) .. " " .. Num((al + ar) / 2 - (hl + hr) / 2) .. " "
        .. Num(at - hb), "true true 0.00 4.00", "inside the window, under the title bar, its arrow under the middle of the ?")
    local clear = {}
    for _, part in ipairs({ w.help, w.close, w.profileButton }) do clear[#clear + 1] = tostring(H.Clear(nudge, part)) end
    Equal(table.concat(clear, " ") .. " " .. S[nudge.text].text, "true true true New: click ? for help with any page",
        "clear of the ?, the X and the profile menu's button")
    -- Nothing on the General page under it; on the pulse page it doesn't show.
    local under = {}
    for _, obj in ipairs(H.objects) do
        local s = S[obj]
        local counts = Last(obj, "EnableMouse") or s.kind == "Button" or s.kind == "EditBox" or (s.kind == "FontString" and (s.text or "") ~= "")
        if counts and H.Inside(obj, w.pages.general) and obj:IsVisible() and not (H.Clear(nudge, obj) and H.Clear(nudge.arrow, obj)) then
            under[#under + 1] = H.Name(obj)
        end
    end
    w:Select("pulse")
    Step(w, 0)
    Equal(table.concat(under, ", ") .. " | " .. Nudge(w), " | false true", "nothing on General under the note; on the pulse page only the ? pulses")
    -- Its x: gone for good, saved.
    w:Select("general")
    Step(w, 0)
    nudge.close:Click()
    Step(w, 1)
    Equal(tostring(db.helpSeen) .. " " .. Nudge(w) .. " " .. tostring(nudge.driver:IsVisible()), "true false false false",
        "x clicked: saved, the note and the pulse gone")
    w:Hide()
    w:Show()
    Step(w, 1)
    Equal(Nudge(w), "false false", "and they stay gone")
    -- Kept over a reload; anything else saved reads as not clicked.
    local saved = ForeverEnhancedCooldownPulseDB
    local again = H.Start(saved)
    Equal(tostring(again.HelpSeen()), "true", "kept over a reload")
    local repaired = {}
    for _, bad in ipairs({ "yes", 1, false, {} }) do
        H.Start({ notesSeen = "dev", helpSeen = bad })
        repaired[#repaired + 1] = tostring(ForeverEnhancedCooldownPulseDB.helpSeen)
    end
    Equal(table.concat(repaired, " "), "nil nil nil nil", "a bad saved value is cleared on load")
    Equal(H.Problems(), "", "no errors from the welcome and the tour")
end

-- The ? on each page: that page's steps, on it, each box fitting --------------------------------

do
    local ns = H.Start({ notesSeen = "dev" })
    SlashCmdList.FECP("")
    local w, box = FECPFrame, nil
    local problems = {}
    local function Walk(key)
        w:Select(key)
        w.help:Click()
        box = FECPTour
        local titles, outlined = {}, true
        local count = S[box.count].text
        local done
        repeat
            titles[#titles + 1] = S[box.title].text
            if w.selected ~= key then titles[#titles + 1] = "(left the page)" end
            if not (S[box.outline].shown and S[box.arrow].shown) then outlined = false end
            local wrong = H.BoxFits(w.pages[key])
            if wrong ~= "" then problems[#problems + 1] = key .. " " .. S[box.title].text .. ": " .. wrong end
            done = S[box.next.label].text == "Done"
            box.next:Click()
        until done or #titles > 20
        return table.concat(titles, ", ") .. " | " .. count:match("of (%d+)") .. " " .. tostring(outlined)
    end
    local before = {}
    for key in pairs(ns.DEFAULTS) do before[#before + 1] = key .. "=" .. tostring(ns.Get(key)) end
    table.sort(before)
    Equal(Walk("pulse"), "TURN IT ON, PICK YOUR COOLDOWNS, QUICK AND LONG, WHERE IT SHOWS, BOTH STYLES | 5 true",
        "the pulse page: the tour's four steps, then both styles' look")
    Equal(Walk("general"), "GENERAL, MINIMAP BUTTON, WINDOW ACCENT | 3 true", "General: the tour's step, then the minimap button and the accent")
    Equal(table.concat(problems, "; "), "", "each box inside the page and clear of the part it points at")
    local after = {}
    for key in pairs(ns.DEFAULTS) do after[#after + 1] = key .. "=" .. tostring(ns.Get(key)) end
    table.sort(after)
    Equal(table.concat(after, " "), table.concat(before, " "), "walking both pages changed no setting")
    Equal(tostring(S[box].shown) .. " " .. S[w.note].text, "false That's this page. Click ? any time to see it again.",
        "Done ends each, saying where to find it again")
    -- Another page picked meanwhile: the outline hides; Next goes back.
    w:Select("general")
    w.help:Click()
    w:Select("pulse")
    Equal(tostring(S[box].shown) .. " " .. tostring(S[box.outline].shown) .. " " .. tostring(S[box.arrow].shown), "true false false",
        "on another page the outline and arrow hide")
    box.next:Click()
    Equal(w.selected .. " " .. S[box.title].text, "general MINIMAP BUTTON", "Next brings it back")
    box.skip:Click()
    Equal(S[w.note].text, "Click ? any time to see it again.", "Skip tour ends it")
    -- Over the profile menu: a word on it in the footer, no walkthrough.
    w.profileButton:Click()
    w.help:Click()
    Equal(tostring(S[box].shown) .. " " .. tostring(S[w.profilePanel].shown) .. " " .. S[w.note].text,
        "false true Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one.",
        "with the profile menu open, the footer explains it and the menu stays")
    w.profileButton:Click()
    Equal(#ns.Tour:Page("nowhere") .. " " .. tostring(ns.Tour:StartPage("nowhere")), "0 false", "a page with no steps starts nothing")
    Equal(H.Problems(), "", "no errors from the walkthroughs")
end

-- What's new: nothing until the first release, then once per version ---------------------------

do
    -- With no notes (as before the first release): nothing shows after an update.
    H.Environment()
    local ns = {}
    _G.ForeverEnhancedCooldownPulseDB = { notesSeen = "0.9.0", helpSeen = true }
    for _, file in ipairs(H.FILES) do
        assert(loadfile(file))(H.ADDON, ns)
        if file == "Notes.lua" then
            for i = #ns.NOTES, 1, -1 do ns.NOTES[i] = nil end
        end
    end
    Fire("ADDON_LOADED", H.ADDON)
    Fire("PLAYER_LOGIN")
    Fire("PLAYER_ENTERING_WORLD")
    H.RunTimers()
    Equal(#ns.NOTES .. " " .. tostring(FECPNotes) .. " " .. tostring(FECPFrame) .. " " .. ForeverEnhancedCooldownPulseDB.notesSeen,
        "0 nil nil dev", "no notes yet: nothing pops up, and this version is noted as seen")
    SlashCmdList.FECP("new")
    Equal(tostring(FECPNotes), "nil", "/fecp new: nothing to show yet")
    -- With the first release's notes (as they'll be, Unreleased until it has its number).
    H.Environment()
    local released = {}
    _G.ForeverEnhancedCooldownPulseDB = { notesSeen = "0.9.0", helpSeen = true }
    for _, file in ipairs(H.FILES) do
        assert(loadfile(file))(H.ADDON, released)
        if file == "Notes.lua" then
            released.NOTES[1] = { version = released.UNRELEASED, sections = { { "Added", { "Cooldown pulse, as its own addon." } } } }
        end
    end
    Fire("ADDON_LOADED", H.ADDON)
    Fire("PLAYER_LOGIN")
    Fire("PLAYER_ENTERING_WORLD")
    H.RunTimers()
    local notes = FECPNotes
    Equal(tostring(S[notes].shown) .. " " .. S[notes.version].text .. " " .. tostring(S[notes.tour].shown) .. " " .. S[notes.done.label].text,
        "true Unreleased true Got it", "after an update: What's new, with Show me what's new")
    local items = {}
    for _, row in ipairs(notes.flow) do items[#items + 1] = S[row.text].text end
    Equal(table.concat(items, " | "), "ADDED | Cooldown pulse, as its own addon.", "the notes, a heading and a bullet")
    Equal(tostring(H.bindings[FECPEscButton]), "ESCAPE:FECPEscButton", "Escape closes it")
    notes.tour:Click()
    local w, box = FECPFrame, FECPTour
    Equal(tostring(S[notes].shown) .. " " .. Box(w), "false 1 of 5 pulse TURN IT ON", "Show me what's new: its tour, over the window")
    for _ = 1, 5 do box.next:Click() end
    Equal(S[w.note].text, "That's what's new. See it again any time from What's new, or with /fecp new.", "Done says where to see it again")
    w:Select("general")
    Equal(tostring(w.news.usable) .. " " .. Note(w.news), "true What changed in this version. /fecp new shows it too.",
        "the General page's What's new, free once there are notes")
    w.news:Click()
    Equal(tostring(S[notes].shown), "true", "and it opens them")
    notes.discord:Click()
    Equal(tostring(S[FECPCopyLink].shown), "true", "What's new's Discord gives the invite")
    FECPCopyLink.close:Click()
    -- Escape: What's new first, then the window.
    FECPEscButton:Click()
    Equal(tostring(S[notes].shown) .. " " .. tostring(S[w].shown), "false true", "Escape: What's new closes first")
    FECPEscButton:Click()
    Equal(tostring(S[w].shown) .. " " .. tostring(H.bindings[FECPEscButton]), "false nil", "then the window, the key handed back")
    -- Not again for the same version.
    H.Environment()
    released = {}
    _G.ForeverEnhancedCooldownPulseDB = { notesSeen = "dev", helpSeen = true }
    for _, file in ipairs(H.FILES) do assert(loadfile(file))(H.ADDON, released) end
    released.NOTES[1] = { version = "1.0.0", sections = { { "Added", { "Cooldown pulse." } } } }
    Fire("ADDON_LOADED", H.ADDON)
    Fire("PLAYER_LOGIN")
    Fire("PLAYER_ENTERING_WORLD")
    H.RunTimers()
    Equal(tostring(FECPNotes), "nil", "seen already: not again")
    Equal(H.Problems(), "", "no errors from What's new")
end

-- Escape, /fecp, Options > AddOns, the minimap button and the debug report -------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    Equal(tostring(SLASH_FECP1) .. " " .. tostring(SLASH_FECP2), "/fecp nil", "/fecp, and nothing else")
    local commands = {}
    for key in pairs(SlashCmdList) do commands[#commands + 1] = key end
    Equal(table.concat(commands, ","), "FECP", "one command of its own")
    SlashCmdList.FECP("")
    local w = FECPFrame
    Equal(tostring(S[w].shown) .. " " .. tostring(H.bindings[FECPEscButton]), "true ESCAPE:FECPEscButton", "open: Escape is borrowed")
    H.Combat(true)
    Equal(tostring(H.bindings[FECPEscButton]), "nil", "a fight: the key handed back at once")
    H.Combat(false)
    Equal(tostring(H.bindings[FECPEscButton]), "ESCAPE:FECPEscButton", "after it, borrowed again")
    SlashCmdList.FECP("tour")
    FECPEscButton:Click()
    Equal(tostring(S[FECPTour].shown) .. " " .. tostring(S[w].shown), "false true", "Escape ends the tour first, the window stays")
    FECPEscButton:Click()
    Equal(tostring(S[w].shown) .. " " .. tostring(H.bindings[FECPEscButton]), "false nil", "then closes the window")
    SlashCmdList.FECP("  ")
    SlashCmdList.FECP("")
    Equal(tostring(S[w].shown), "false", "/fecp toggles it")
    -- Options > AddOns: an entry of its own, with a button for the window.
    local canvas = H.category.canvas
    Equal(H.category.title, "Forever Enhanced Cooldown Pulse", "under its own name in Options > AddOns")
    local open
    for _, f in ipairs(H.frames) do
        if S[f].parent == canvas and S[f].template == "UIPanelButtonTemplate" then open = f end
    end
    Equal(S[open].text, "Open settings", "a button there")
    S[open].scripts.OnClick(open)
    Equal(tostring(S[w].shown), "true", "Open settings opens the window")
    w:Hide()
    -- The minimap button: clear of Forever Enhanced Cooldown Manager's (225)
    -- and the other addons' spots, bottom right of the bottom.
    local button = FECPMinimapButton
    local at = S[button].points[1]
    Equal(table.concat({ at[1], tostring(at[2] == Minimap), at[3], ("%.1f"):format(at[4]), ("%.1f"):format(at[5]) }, " ") .. " "
        .. ns.Get("minimapAngle") .. " " .. S[button].name, "CENTER true CENTER 19.2 -71.5 285 FECPMinimapButton", "at 285 degrees round the minimap")
    S[button].scripts.OnEnter(button)
    Equal(table.concat(S[GameTooltip].lines, ", "), "Click: settings, Right-click: What's new, Drag: move it round the minimap",
        "its tooltip says what it does")
    S[button].scripts.OnClick(button, "LeftButton")
    Equal(tostring(S[w].shown), "true", "a click opens the settings")
    S[button].scripts.OnClick(button, "LeftButton")
    S[button].scripts.OnDragStart(button)
    S[button].scripts.OnUpdate(button)
    S[button].scripts.OnDragStop(button)
    Equal(ns.Get("minimapAngle") .. " " .. tostring(button.isMoving), "218 nil", "dragged round to where the cursor is, and saved")
    S[button].scripts.OnClick(button, "LeftButton")
    Equal(tostring(S[w].shown), "false", "a click just after the drag is the drag letting go")
    -- The debug report: what the pulse is doing, ready to copy.
    SlashCmdList.FECP("debug")
    local debug = FECPDebugFrame
    local report = S[debug.edit].text
    Equal(tostring(S[debug].shown) .. " " .. tostring(report:find("^Forever Enhanced Cooldown Pulse dev") ~= nil) .. " "
        .. tostring(report:find("Pulse: ticked on true, runs in ForeverEnhancedCooldownPulse, profile Zriel (Druid) - Zephras", 1, true) ~= nil) .. " "
        .. tostring(report:find("Ticked 0 (0 Long), watched 0: ", 1, true) ~= nil) .. " " .. tostring(report:find("Last error: none", 1, true) ~= nil),
        "true true true true true", "/fecp debug: the version, where the pulse runs, what's ticked and watched")
    debug.close:Click()
    SlashCmdList.FECP("discord")
    Equal(tostring(S[FECPCopyLink].shown), "true", "/fecp discord")
    Equal(H.Problems(), "", "no errors")
end

-- The profile menu ----------------------------------------------------------------------------------

do
    local ns = H.Start({ notesSeen = "dev", helpSeen = true })
    SlashCmdList.FECP("")
    local w = FECPFrame
    local panel, input = w.profilePanel, w.profileInput
    Equal(Note(w.profileButton), "The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one.",
        "the menu says what a profile holds")
    w.profileButton:Click()
    Equal(tostring(S[panel].shown), "true", "clicked: every profile")
    input:SetText("Raids")
    w.profileActions.new:Click()
    Equal(ns.ProfileName() .. " " .. tostring(S[panel].shown) .. " " .. S[w.note].text, "Raids false Made Raids, and switched to it.",
        "New: made and switched to, the menu closed")
    w.profileButton:Click()
    local rows = {}
    for _, obj in ipairs(H.objects) do
        if S[obj].parent == w.profileList.content and S[obj].shown and obj.profile then
            rows[#rows + 1] = obj.profile .. " (" .. S[obj.users].text .. ")"
        end
    end
    Equal(table.concat(rows, ", "), "Raids (you), Zriel (Druid) - Zephras (unused)", "listed with who uses each")
    local own
    for _, obj in ipairs(H.objects) do
        if S[obj].parent == w.profileList.content and obj.profile == "Zriel (Druid) - Zephras" then own = obj end
    end
    own.remove:Click()
    Equal(tostring(S[w.confirm.shade].shown) .. " " .. S[w.confirm.dialog.title].text, 'true Delete "Zriel (Druid) - Zephras"?',
        "x: it asks first")
    w.confirm.yes:Click()
    Equal(S[w.note].text .. " " .. tostring(ForeverEnhancedCooldownPulseDB.profiles["Zriel (Druid) - Zephras"]),
        "Deleted Zriel (Druid) - Zephras. nil", "and deletes it once you say so")
    w.profileEveryone:Click()
    Equal(S[w.confirm.dialog.title].text, 'Use "Raids" on all characters?', "Use on all characters asks first too")
    w.confirm.yes:Click()
    Equal(tostring(ns.OnAll("Raids")) .. " " .. S[w.note].text, "true All your characters use Raids now, and new ones will too.", "and does it")
    Equal(H.Problems(), "", "no errors from the profile menu")
end

Equal(H.Problems(), "", "no errors")
io.write("Window checks passed: " .. H.checks .. " assertions.\n")
