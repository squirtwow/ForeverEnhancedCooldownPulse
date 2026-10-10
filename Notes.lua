-- What's new: this version's notes, shown once after the addon updates (a
-- first install has nothing new to show), then any time from What's new on
-- the General page or /fecp new. The releases before it follow underneath.
-- Drawn in the window's flat style. Show me what's new beside Got it tours
-- the steps the update added (Tour.lua), when it added any.
local _, ns = ...
local T = ns.Theme

-- Newest first, word for word as in CHANGELOG.txt (Tools/TestNotes.mjs checks).
-- Notes waiting for their version number are "Unreleased". None until the
-- first release: there's nothing new to a first install.
ns.NOTES = {
    {
        version = "1.0.2",
        sections = {
            { "Changed", {
                "Lighter when your bags change, and spell data updated for Forever's latest build.",
            } },
            { "Fixed", {
                "Potions move on to the one you carry, and an item you've run out of doesn't pulse.",
                "Hover boxes widen to fit their title.",
            } },
        },
    },
    {
        version = "1.0.1",
        sections = {
            { "Added", {
                "The minimap button can be free-floating: tick it on the General page, then drag it anywhere.",
                "More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager.",
            } },
            { "Changed", {
                "Escape now closes the settings during a fight too.",
                "The settings and What's new close along with the game's other windows, for example at a loading screen.",
                "The minimap button's tooltip now matches the addon's look.",
            } },
        },
    },
    {
        version = "1.0.0",
        sections = {
            { "Added", {
                "A big icon in the middle of your screen the moment a cooldown you tick is ready.",
                "Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option.",
                "Trinkets, potions, healthstones and bag items can pulse too.",
                "Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time.",
            } },
        },
    },
}

local WIDTH, HEADER = 520, 42
local TOP, FOOT = 82, 52 -- above and below the notes
local TEXT = WIDTH - 48 -- the notes' width, clear of the scroll thumb
local BULLET = 16 -- bullet text indent
local MAX_HEIGHT = 620
local HISTORY = 3 -- this version's notes and the two before

local N = {}
ns.Notes = N

-- This version's notes and the ones before, or the newest if this version has
-- none (a copy straight from the source).
local function Entries()
    local version, start = ns.Version(), 1
    for i, entry in ipairs(ns.NOTES) do
        if entry.version == version then
            start = i
            break
        end
    end
    local list = {}
    for i = start, math.min(#ns.NOTES, start + HISTORY - 1) do list[#list + 1] = ns.NOTES[i] end
    return list
end

local function Label(version)
    return version:match("^%d") and "Version " .. version or version
end

local window

local function Build()
    window = CreateFrame("Frame", "FECPNotes", UIParent, "BackdropTemplate")
    window:SetSize(WIDTH, 400)
    window:SetPoint("CENTER", 0, 40)
    window:SetFrameStrata("FULLSCREEN_DIALOG")
    window:SetToplevel(true)
    window:SetClampedToScreen(true)
    window:EnableMouse(true)
    window:SetMovable(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    T:Flat(window, T.BG, T.CONTROL_BORDER)
    T:Paint(function(accent) window:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1) end)
    window:Hide()
    -- Set before anything hooks it: setting a script later drops hooks.
    window:SetScript("OnHide", function(self)
        self:StopMovingOrSizing() -- closed mid-drag, it never hears the mouse let go
    end)
    ns.CloseOnEscape(window)
    ns.notes = window

    local header = T:TitleBar(window, HEADER)
    window.close = header.close
    local fade = T:Fade(window, T.FADE.page)
    fade:SetPoint("TOPLEFT", 1, -(HEADER + 1))
    fade:SetPoint("BOTTOMRIGHT", -1, 1)

    local entries = Entries()
    local heading = T:Heading(window, "What's new")
    heading:SetPoint("TOPLEFT", 20, -(HEADER + 18))
    window.version = T:Text(window, "GameFontHighlightSmall", T.MUTED)
    window.version:SetPoint("LEFT", heading, "RIGHT", 10, 0)
    window.version:SetText(Label(entries[1].version))

    -- The notes scroll between the heading and the footer, pinned by two
    -- corners, again once shown, so they always draw.
    local scroll = T:Scroll(window, TEXT)
    local function Pin()
        scroll:ClearAllPoints()
        scroll:SetPoint("TOPLEFT", 20, -TOP)
        scroll:SetPoint("BOTTOMRIGHT", -28, FOOT)
        scroll:ScrollTo(scroll:GetVerticalScroll() or 0)
    end
    Pin()
    window:HookScript("OnShow", function() C_Timer.After(0, Pin) end)
    window.scroll = scroll
    local content = scroll.content

    -- Each row with the space above it; placed by Layout once the text has
    -- its width.
    local flow = {}
    window.flow = flow
    for index, entry in ipairs(entries) do
        local gap = 0
        if index > 1 then
            local rule = content:CreateTexture(nil, "ARTWORK")
            rule:SetHeight(1)
            T:Fill(rule, T.BORDER)
            flow[#flow + 1] = { rule = rule, gap = 22 }
            local older = T:Text(content, "GameFontHighlight", T.MUTED)
            older:SetWidth(TEXT)
            older:SetText(Label(entry.version))
            flow[#flow + 1] = { text = older, gap = 14 }
            gap = 12
        end
        for s, section in ipairs(entry.sections) do
            local title = T:Heading(content, section[1])
            title:SetWidth(TEXT)
            flow[#flow + 1] = { text = title, gap = s > 1 and 18 or gap }
            for i, item in ipairs(section[2]) do
                local text = T:Text(content, "GameFontHighlight")
                text:SetWidth(TEXT - BULLET)
                text:SetText(item)
                -- A small accent square level with the first line.
                local _, size = text:GetFont()
                local dot = content:CreateTexture(nil, "ARTWORK")
                dot:SetSize(4, 4)
                T:Paint(function(accent) T:Fill(dot, accent) end)
                flow[#flow + 1] = { text = text, indent = BULLET, dot = dot, gap = i == 1 and 8 or 6,
                    dotY = math.max(2, math.floor((size or 12) / 2) - 1) }
            end
        end
    end

    -- Rows top to bottom; the window grows to fit, up to the screen.
    function window:Layout()
        local y = 0
        for _, row in ipairs(flow) do
            y = y + row.gap
            local region = row.rule or row.text
            region:ClearAllPoints()
            region:SetPoint("TOPLEFT", row.indent or 0, -y)
            if row.dot then
                row.dot:ClearAllPoints()
                row.dot:SetPoint("TOPLEFT", 4, -(y + row.dotY))
            end
            if row.rule then
                region:SetPoint("TOPRIGHT", 0, -y)
                y = y + 1
            else
                y = y + math.max(1, row.text:GetStringHeight() or 12)
            end
        end
        content:SetHeight(math.max(1, y))
        local room = math.max(200, math.min(MAX_HEIGHT, (UIParent:GetHeight() or MAX_HEIGHT) - 40))
        self:SetHeight(math.max(200, math.min(room, TOP + y + FOOT + 12)))
        scroll:ScrollTo(scroll:GetVerticalScroll() or 0)
    end
    window:RegisterEvent("UI_SCALE_CHANGED")
    window:RegisterEvent("DISPLAY_SIZE_CHANGED")
    window:SetScript("OnEvent", function(self) if self:IsShown() then self:Layout() end end)

    -- Two short lines on the left: where to take a bug or an idea, and how to
    -- see this again. On the right Got it, then Show me what's new while
    -- there's a tour of it, then the Discord button.
    local ask = T:Text(window, "GameFontHighlightSmall")
    ask:SetPoint("BOTTOMLEFT", 20, 27)
    ask:SetText("Found a bug or have an idea?")
    local hint = T:Text(window, "GameFontHighlightSmall", T.MUTED)
    hint:SetPoint("BOTTOMLEFT", 20, 13)
    hint:SetText("/fecp new shows this again.")
    local done = T:Button(window, "Got it", 100, 24)
    done:SetPoint("BOTTOMRIGHT", -16, 14)
    T:Paint(function(accent) done:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1) end)
    done:SetScript("OnClick", function() window:Hide() end)
    window.done = done
    -- Closes this for the tour, which opens the settings. Its tooltip says
    -- what it does, as the label has no room to.
    local tour = T:Button(window, "Show me what's new", 120, 24)
    tour:SetPoint("RIGHT", done, "LEFT", -8, 0)
    tour:SetScript("OnClick", function()
        window:Hide()
        if ns.Tour then ns.Tour:StartNews(window.seen) end
    end)
    tour:HookScript("OnEnter", function(self)
        T:ShowTip(self, "Show me what's new", "A quick tour of what's new, a page at a time.")
    end)
    tour:HookScript("OnLeave", function() T:HideTip() end)
    window.tour = tour
    local discord = T:Button(window, "Discord", 80, 24)
    discord:SetPoint("RIGHT", done, "LEFT", -8, 0)
    discord:SetScript("OnClick", function() if ns.ShowDiscord then ns.ShowDiscord() end end)
    window.discord, window.ask = discord, ask
end

-- seen: after an update, the version whose notes were seen before it, so
-- the tour takes in every step since. Opened by hand, the tour offered is
-- the latest update's. Nothing to show until the first release has notes.
function ns.ShowNotes(seen)
    if #ns.NOTES == 0 then return end
    if not window then Build() end
    window.seen = type(seen) == "string" and seen or nil
    local tour = ns.Tour ~= nil and #ns.Tour:News(window.seen) > 0
    window.tour:SetShown(tour)
    window.discord:ClearAllPoints()
    window.discord:SetPoint("RIGHT", tour and window.tour or window.done, "LEFT", -8, 0)
    window:Show()
    window:Raise()
    window:Layout()
    window.scroll:ScrollTo(0)
end

-- Once per version: a moment after the first login with it, and never in
-- combat. A first install has nothing new to show: the window opens instead,
-- with the offer of a tour.
function N:Start()
    local version, seen = ns.Version(), ns.NotesSeen()
    if seen == version then return end
    ns.SetNotesSeen(version)
    local welcome = ns.firstInstall
    if not welcome and #ns.NOTES == 0 then return end
    local events = CreateFrame("Frame")
    local due, waiting = false, false
    local function ShowWhenFree()
        if not due or InCombatLockdown() then return end
        due = false
        events:UnregisterAllEvents()
        if not welcome then return ns.ShowNotes(seen) end
        if ns.Tour then ns.Tour:Welcome() else ns.ShowWindow() end
    end
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("PLAYER_REGEN_ENABLED")
    events:SetScript("OnEvent", function(_, event)
        if event ~= "PLAYER_ENTERING_WORLD" then return ShowWhenFree() end
        if waiting then return end
        waiting = true
        C_Timer.After(2, function()
            due = true
            ShowWhenFree()
        end)
    end)
end
