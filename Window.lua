-- The /fecp window, in Forever Enhanced Cooldown Manager's style: a short
-- list down the left (Cooldown pulse and General), and the chosen page in
-- the rest. The title bar has the profile menu, the ? for help with the page
-- showing and the X; the footer the version, and a note for whatever is
-- under the mouse. Drawn in the flat charcoal Theme style.
local _, ns = ...
local T = ns.Theme

-- The pages are as wide as Forever Enhanced Cooldown Manager's, with a
-- narrower list for just the two.
local WIDTH, HEIGHT = 790, 560
local HEADER, FOOTER, NAV = 42, 28, 150
local HEART = "Heart.tga" -- white on clear, tinted to the accent in the footer's credit
-- A list's scroll thumb, wherever there's one: the cooldowns and the profiles.
ns.SCROLL_NOTE = "Drag to scroll the list, or turn the mouse wheel over it."

local function Version()
    local version = ns.Version()
    return version == "dev" and version or "v" .. version
end

-- A link to copy, in the window's own look: an addon can't open a web page
-- itself. The link stays as it is, selected.
local COPY = "Press Ctrl+C to copy, then paste it into your browser."
local copyBox
local function CopyLink(title, url, note)
    if not copyBox then
        local box = CreateFrame("Frame", "FECPCopyLink", UIParent, "BackdropTemplate")
        box:SetSize(420, 136)
        box:SetPoint("CENTER", 0, 120)
        box:SetFrameStrata("FULLSCREEN_DIALOG")
        box:SetToplevel(true)
        box:EnableMouse(true)
        T:Flat(box, T.BG, T.CONTROL_BORDER)
        T:Paint(function(accent) box:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1) end)
        box.title = T:Heading(box, "")
        box.title:SetPoint("TOPLEFT", 16, -16)
        box.note = T:Text(box, "GameFontHighlightSmall", T.MUTED)
        box.note:SetPoint("TOPLEFT", 16, -36)
        box.note:SetWidth(388)
        box.input = T:Input(box, "", 388)
        box.input:SetPoint("TOPLEFT", 16, -72)
        box.input:SetScript("OnTextChanged", function(self)
            if self:GetText() ~= box.url then
                self:SetText(box.url or "")
                self:HighlightText()
            end
        end)
        box.input:SetScript("OnEscapePressed", function() box:Hide() end)
        box.input:SetScript("OnEnterPressed", function() box:Hide() end)
        local close = T:Button(box, "Close", 90, 22)
        close:SetPoint("BOTTOMRIGHT", -16, 12)
        close:SetScript("OnClick", function() box:Hide() end)
        box.close = close
        copyBox = box
    end
    copyBox.url = url
    copyBox.title:SetText(title:upper())
    copyBox.note:SetText(note or COPY)
    copyBox:Show()
    copyBox:Raise()
    copyBox.input:SetText(url)
    copyBox.input:HighlightText()
    copyBox.input:SetFocus()
end
-- The same server as Forever Enhanced Cooldown Manager's.
ns.DISCORD_URL = "https://discord.gg/FVfcDWJncr"

-- The Discord invite, ready to copy: from the General page, What's new and
-- /fecp discord.
function ns.ShowDiscord()
    CopyLink("Join the Discord", ns.DISCORD_URL, "Found a bug or have an idea? " .. COPY)
end

-- General ----------------------------------------------------------------------------

local SWATCH, SWATCH_GAP = 20, 6 -- the accent's colour swatches

local function Detail(page, text, x, y, width)
    local detail = T:Text(page, "GameFontHighlightSmall", T.MUTED)
    detail:SetPoint("TOPLEFT", x, y)
    detail:SetWidth(width or 420)
    detail:SetText(text)
    return detail
end

-- More from Squirt: the author's other addons, each in a card with its logo
-- (this addon's own copy, so it shows without it), a line about it, and Open
-- while it's loaded, or its links to copy while it isn't. slash and frame:
-- its command and its settings window, by their names in the game, only read.
local MORE_HEIGHT, MORE_GAP = 74, 8
local GET_IT = "Get it on CurseForge or GitHub: click one for its link."
local INSTALL = COPY .. " On CurseForge, Install opens the CurseForge app."
local MORE = {
    {
        name = "EraUI", folder = "EraUI", icon = "EraUIIcon.tga", slash = "ERAUI", frame = "EraUISettingsFrame",
        about = "The Classic look for WoW Forever's whole interface, with quality of life options.",
        installed = "Installed. Type /era, or click Open.",
        open = "Open EraUI's settings, as /era does.",
        links = {
            { label = "CurseForge", url = "https://www.curseforge.com/wow/addons/eraui", note = INSTALL },
            { label = "GitHub", url = "https://github.com/squirtwow/EraUI" },
        },
    },
    {
        name = "Forever Enhanced Cooldown Manager", folder = "ForeverEnhancedCooldownManager", icon = "FECMIcon.tga",
        slash = "FECM", frame = "FECMFrame",
        about = "Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own.",
        installed = "Installed. Type /ccm, or click Open.",
        open = "Open Forever Enhanced Cooldown Manager's settings, as /ccm does.",
        links = {
            { label = "CurseForge", url = "https://www.curseforge.com/wow/addons/forever-enhanced-cooldown-manager", note = INSTALL },
            { label = "GitHub", url = "https://github.com/squirtwow/ForeverEnhancedCooldownManager" },
        },
    },
}

local function MoreCard(window, page, more, y)
    local card = CreateFrame("Frame", nil, page, "BackdropTemplate")
    card:SetPoint("TOPLEFT", 16, y)
    card:SetSize(WIDTH - NAV - 34, MORE_HEIGHT)
    T:Flat(card, T.PANEL, T.BORDER)
    local icon = card:CreateTexture(nil, "ARTWORK")
    icon:SetSize(36, 36)
    icon:SetPoint("TOPLEFT", 12, -12)
    icon:SetTexture(ns.MEDIA .. more.icon)
    local name = T:Text(card, "GameFontHighlight")
    name:SetPoint("TOPLEFT", 60, -12)
    name:SetText(more.name)
    -- Two lines, then the line under them at the foot: clear of each other.
    local about = T:Text(card, "GameFontHighlightSmall", T.MUTED)
    about:SetPoint("TOPLEFT", 60, -28)
    about:SetWidth(330) -- clear of the buttons on the right
    about:SetText(more.about)
    local state = T:Text(card, "GameFontHighlightSmall", T.MUTED)
    state:SetPoint("BOTTOMLEFT", 60, 8)
    -- Open: this window goes and the other's comes up, as its command
    -- brings it. One already open comes to the front, never toggled shut.
    local open = T:Button(card, "Open", 80, 22)
    open:SetPoint("RIGHT", -12, 0)
    open:SetScript("OnClick", function()
        local run, other = SlashCmdList and SlashCmdList[more.slash], _G[more.frame]
        local shown = other and other.IsShown and other:IsShown()
        if not (shown or run) then return end
        window:Hide()
        if shown then other:Raise() else run("") end
    end)
    window:Hint(open, more.open)
    local links = {}
    for i, link in ipairs(more.links) do
        local button = T:Button(card, link.label, 90, 22)
        button:SetPoint("RIGHT", -12 - (#more.links - i) * 98, 0)
        button:SetScript("OnClick", function() CopyLink(more.name .. " on " .. link.label, link.url, link.note) end)
        window:Hint(button, more.name .. " on " .. link.label .. ", as a link to copy.")
        links[i] = button
    end
    card.icon, card.name, card.about, card.state, card.open, card.links = icon, name, about, state, open, links
    -- Loaded or not, looked at again each time the page shows.
    function card:Refresh()
        local installed = C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(more.folder)
        open:SetShown(installed and true or false)
        for _, button in ipairs(links) do button:SetShown(not installed) end
        state:SetText(installed and more.installed or GET_IT)
    end
    return card
end

-- Help (the tour, What's new and the Discord), the minimap button, the
-- window's accent, which version this is, and more from Squirt.
local function BuildGeneral(window, page)
    T:Heading(page, "Help"):SetPoint("TOPLEFT", 16, -16)
    local tour = T:Button(page, "Take the tour", 110, 22)
    tour:SetPoint("TOPLEFT", 16, -36)
    tour:SetScript("OnClick", function() if ns.Tour then ns.Tour:Start() end end)
    window:Hint(tour, "A short tour of this window, a page at a time. /fecp tour starts it too.")
    local news = T:Square(page, "What's new")
    news:SetSize(100, 22)
    news.label:SetFontObject("GameFontHighlightSmall")
    news:SetPoint("TOPLEFT", 134, -36)
    news:SetScript("OnClick", function() if ns.ShowNotes then ns.ShowNotes() end end)
    window:Hint(news, function()
        return #ns.NOTES > 0 and "What changed in this version. /fecp new shows it too."
            or "Nothing yet: what changes in each update shows here."
    end)
    local discord = T:Button(page, "Discord", 80, 22)
    discord:SetPoint("TOPLEFT", 242, -36)
    discord:SetScript("OnClick", ns.ShowDiscord)
    window:Hint(discord, "The Discord invite, ready to copy: bugs, ideas and help.")
    Detail(page, "A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help.", 16, -66, 600)
    window.tour, window.news, window.discord = tour, news, discord

    T:Heading(page, "Minimap button"):SetPoint("TOPLEFT", 16, -100)
    local minimap = T:Check(page, "Show the minimap button", function(self)
        ns.Set("minimap", self:GetChecked())
        if ns.MinimapButton then ns.MinimapButton:Apply() end
    end)
    minimap:SetPoint("TOPLEFT", 16, -120)
    window:Hint(minimap, "A button on the minimap for these settings. Off, /fecp still opens them.")
    window.minimap = minimap
    local free = T:Check(page, "Free-floating", function(self)
        if ns.MinimapButton then ns.MinimapButton:SetFree(self:GetChecked()) end
    end)
    free:SetPoint("TOPLEFT", 260, -120)
    window:Hint(free, "Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden.")
    window.minimapFree = free
    Detail(page, "Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating.",
        34, -140, 580)

    -- The window's own accent.
    T:Heading(page, "Window accent"):SetPoint("TOPLEFT", 16, -180)
    local swatches = {}
    for i, key in ipairs(ns.ACCENT_KEYS) do
        local swatch = CreateFrame("Button", nil, page, "BackdropTemplate")
        swatch:SetSize(SWATCH, SWATCH)
        swatch:SetPoint("TOPLEFT", 16 + (i - 1) * (SWATCH + SWATCH_GAP), -200)
        swatch:SetScript("OnClick", function()
            ns.Set("accent", key)
            T:Repaint()
            window:Refresh()
        end)
        swatch.key = key
        window:Hint(swatch, T.ACCENTS[key].name .. " for this window's headings, ticks, sliders and highlights.")
        swatches[i] = swatch
    end
    local chosen = T:Text(page, "GameFontHighlightSmall", T.MUTED)
    chosen:SetPoint("TOPLEFT", 16 + #ns.ACCENT_KEYS * (SWATCH + SWATCH_GAP) + 2, -204)
    window.swatches, window.accentName = swatches, chosen

    -- Which version this is, and how to open the window.
    T:Heading(page, "About"):SetPoint("TOPLEFT", 16, -236)
    local about = Detail(page, "", 16, -256, 600)
    window.about = about

    -- More from Squirt: the author's other addons, a card each.
    T:Heading(page, "More from Squirt"):SetPoint("TOPLEFT", 16, -296)
    local cards = {}
    for i, more in ipairs(MORE) do
        cards[i] = MoreCard(window, page, more, -316 - (i - 1) * (MORE_HEIGHT + MORE_GAP))
    end
    window.more = cards

    function page:Refresh()
        for _, card in ipairs(cards) do card:Refresh() end
        minimap:SetChecked(ns.Get("minimap"))
        free:SetChecked(ns.Get("minimapFree"))
        news:SetUsable(#ns.NOTES > 0)
        local accent = ns.Get("accent")
        for _, swatch in ipairs(swatches) do
            local colour, picked = T.ACCENTS[swatch.key].colour, swatch.key == accent
            T:Flat(swatch, { colour[1], colour[2], colour[3], 1 }, picked and { 1, 1, 1, 1 } or T.CONTROL_BORDER)
        end
        chosen:SetText(T.ACCENTS[accent].name)
        local version = ns.Version()
        about:SetText(ns.TITLE .. (version == "dev" and ", a copy straight from the source." or (" version " .. version .. "."))
            .. " Made by Squirt. Type /fecp to open this window.")
    end
end

-- The list ---------------------------------------------------------------------

-- What each page is for, in the footer on hover.
local NAV_NOTES = {
    pulse = "A big icon in the middle of your screen when a cooldown is ready.",
    general = "The tour, What's new, the Discord, the minimap button, this window's accent and Squirt's other addons.",
}

local function NavItem(window, nav, key, label, y)
    local item = CreateFrame("Button", nil, nav)
    item:SetPoint("TOPLEFT", 0, -y)
    item:SetPoint("RIGHT")
    item:SetHeight(30)
    item.fill = item:CreateTexture(nil, "BACKGROUND")
    item.fill:SetAllPoints()
    T:Fill(item.fill, T.SELECTED)
    item.glow = T:Fade(item, T.FADE.selected)
    item.glow:SetAllPoints()
    item.mark = item:CreateTexture(nil, "ARTWORK")
    item.mark:SetPoint("TOPLEFT")
    item.mark:SetPoint("BOTTOMLEFT")
    item.mark:SetWidth(3)
    T:Paint(function(accent) T:Fill(item.mark, accent) end)
    local hover = item:CreateTexture(nil, "HIGHLIGHT")
    hover:SetAllPoints()
    hover:SetColorTexture(1, 1, 1, .04)
    item.label = T:Text(item, "GameFontHighlight")
    item.label:SetPoint("TOPLEFT", 14, -9)
    item.label:SetText(label)
    item.key = key
    item:SetScript("OnClick", function() window:Select(key) end)
    window:Hint(item, NAV_NOTES[key])
    return item
end

-- Setup ------------------------------------------------------------------------------

-- "Are you sure?": a small dialog over the whole window, for anything that
-- can't simply be clicked back. window:Ask(title, detail, button, action).
local function BuildConfirm(window)
    local shade = CreateFrame("Frame", nil, window)
    shade:SetAllPoints()
    shade:SetFrameLevel(window:GetFrameLevel() + 80)
    shade:EnableMouse(true) -- nothing behind it can be clicked meanwhile
    local dim = shade:CreateTexture(nil, "BACKGROUND")
    dim:SetAllPoints()
    dim:SetColorTexture(0, 0, 0, .45)
    shade:Hide()
    local dialog = CreateFrame("Frame", nil, shade, "BackdropTemplate")
    dialog:SetSize(320, 112)
    dialog:SetPoint("CENTER")
    T:Flat(dialog, T.PANEL, T.CONTROL_BORDER)
    dialog.title = T:Text(dialog, "GameFontHighlight")
    dialog.title:SetPoint("TOPLEFT", 14, -14)
    dialog.title:SetWidth(292)
    dialog.detail = T:Text(dialog, "GameFontHighlightSmall", T.MUTED)
    dialog.detail:SetPoint("TOPLEFT", dialog.title, "BOTTOMLEFT", 0, -8)
    dialog.detail:SetWidth(292)
    local yes = T:Button(dialog, "", 90, 22)
    yes:SetPoint("BOTTOMRIGHT", -14, 14)
    yes.label:SetTextColor(T.WARN[1], T.WARN[2], T.WARN[3])
    local no = T:Button(dialog, "Cancel", 90, 22)
    no:SetPoint("RIGHT", yes, "LEFT", -6, 0)
    window.confirm = { shade = shade, dialog = dialog, yes = yes, no = no }
    local pending
    local function Close()
        pending = nil
        shade:Hide()
    end
    no:SetScript("OnClick", Close)
    yes:SetScript("OnClick", function()
        local action = pending
        Close()
        if action then action() end
    end)
    window:HookScript("OnHide", Close)
    function window:Ask(title, detail, label, action)
        pending = action
        dialog.title:SetText(title)
        dialog.detail:SetText(detail)
        yes:SetLabel(label)
        -- A long profile name wraps, and the dialog grows to fit it all.
        local text = (dialog.title:GetStringHeight() or 14) + 8 + (dialog.detail:GetStringHeight() or 14)
        dialog:SetHeight(math.max(112, math.ceil(14 + text + 16 + 22 + 14)))
        shade:Show()
    end
end

-- The footer: the version on the left; on the right a note for the control
-- under the mouse, or else the last message, or else who made the addon.
-- Built before the pages, which give their controls notes as they're made.

-- "Made with <heart> by Squirt", the heart and name in the accent. The font
-- has no heart, so it's a small white texture inline in the text, tinted by
-- the escape's own colour: the text lays it out, so it sits right however
-- the line is justified, and it repaints with the line.
local function Credit()
    local accent = T:Accent()
    local function Byte(v) return math.floor(math.max(0, math.min(1, v)) * 255 + .5) end
    return ("Made with |T%s:0:0:0:0:32:32:0:32:0:32:%d:%d:%d|t by |cff%sSquirt|r"):format(ns.MEDIA .. HEART,
        Byte(accent[1]), Byte(accent[2]), Byte(accent[3]), T:Hex(accent))
end

local function BuildFooter(window)
    local version = T:Text(window, "GameFontHighlightSmall", T.MUTED)
    version:SetPoint("BOTTOMLEFT", 12, 9)
    version:SetText(Version() .. "   /fecp to open")
    window.versionText = version
    local note = T:Text(window, "GameFontHighlightSmall", T.MUTED)
    note:SetPoint("BOTTOMRIGHT", -12, 9)
    note:SetJustifyH("RIGHT")
    note:SetWidth(WIDTH - 260)
    window.note = note
    -- Shown at the next refresh, and until the one after.
    function window:Say(text)
        self.message = text
    end
    -- The hovered control's note, worked out afresh (some change as you
    -- click), or what the footer rests on: the last message, or the credit.
    -- A message just said goes in front of the hovered control's note until
    -- the mouse moves onto a control, or the next refresh.
    function window:ShowNote()
        local hovered = self.hovered
        if hovered and not hovered:IsVisible() then hovered, self.hovered = nil, nil end
        local text = hovered and not self.saying and hovered.hint
        if type(text) == "function" then text = text(hovered) end
        self.lastNote = self.said or Credit()
        note:SetText(text or self.lastNote)
    end
    function window:Note(control)
        self.hovered, self.saying = control, nil
        self:ShowNote()
    end
    -- Off a control, the footer rests. Only the control whose note is up can
    -- take it down, whichever order the game sends enter and leave.
    function window:Unnote(control)
        if self.hovered ~= control then return end
        self.hovered = nil
        self:ShowNote()
    end
    -- Every control's note, set up the same way. text: its note, or a
    -- function for one that changes. Hooked, so each keeps its own hover
    -- look. A slider has it all over, its label and value too, and on its
    -- track, which takes the mouse over the rest.
    function window:Hint(control, text)
        if control.track then
            control:EnableMouse(true)
            self:Hint(control.track, text)
        end
        control.hint = text
        control:HookScript("OnEnter", function() window:Note(control) end)
        control:HookScript("OnLeave", function() window:Unnote(control) end)
    end
    -- Closed, nothing is under the mouse any more: open, the footer rests.
    window:HookScript("OnHide", function() window.hovered = nil end)
    -- A new accent recolours the heart and name at once.
    T:Paint(function() window:ShowNote() end)
end

-- The ? beside the X: a walkthrough of the page showing (Tour.lua), or a
-- word in the footer where there's none, as over the profile menu. Hovered,
-- a tooltip just under it says what it does. Until it's first clicked (once
-- for the whole account), it gently pulses in the accent and a note under
-- it points it out, with an x to put the note away, on the page it leaves
-- room on (General). Neither shows while the welcome, the tour or a
-- walkthrough is up, nor over the profile menu or What's new: they come
-- back after, and each time the window opens again.
local NUDGE_TEXT = "New: click ? for help with any page"
local NUDGE_PAD = 10
local NUDGE_TEXT_WIDTH = 240 -- one line, with room to spare
local NUDGE_GAP = 4 -- between the ? and the tip of the note's arrow
local NUDGE_ARROW = { 16, 9 }
local NUDGE_PERIOD = 2.4 -- seconds for one slow pulse, dim to lit and back
local NUDGE_FILL, NUDGE_EDGE = .3, .8 -- how much accent at its strongest: inside, and the edge

local function BuildHelp(window, header)
    local help = T:Square(header, "?")
    help:SetSize(22, 22)
    help:SetPoint("RIGHT", header.close, "LEFT", -6, 0)
    window.help = help
    function window:Help()
        if self.profilePanel and self.profilePanel:IsShown() then
            self:Say("Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one.")
            return self:Refresh()
        end
        if ns.Tour and ns.Tour:StartPage(self.selected) then return end
        self:Say("Nothing to walk through here yet. Hover over anything and this line says what it does.")
        self:Refresh()
    end
    help:HookScript("OnEnter", function(self)
        T:ShowTip(self, "Page help", "Walks you through this page, a step at a time.", "below")
    end)
    help:HookScript("OnLeave", function(self) T:HideTip(self) end)

    -- The pulse: the accent glowing softly inside the ? and on its edge.
    local glow = help:CreateTexture(nil, "ARTWORK")
    glow:SetPoint("TOPLEFT", 1, -1)
    glow:SetPoint("BOTTOMRIGHT", -1, 1)
    glow:SetAlpha(0)
    glow:Hide()
    help.glow = glow
    -- The note: under the ? and the X, inside the window (which stays on
    -- screen), below the title bar, its arrow pointing up at the ?. Under
    -- the profile menu (60), the tour (70, 80) and Are you sure? (80).
    local nudge = CreateFrame("Frame", nil, window, "BackdropTemplate")
    nudge:SetSize(NUDGE_PAD + NUDGE_TEXT_WIDTH + 6 + 16 + 6, 28) -- its height again once the text is in
    nudge:SetFrameLevel(window:GetFrameLevel() + 50)
    nudge:SetClampedToScreen(true)
    nudge:EnableMouse(true) -- what's under it isn't clicked by mistake
    T:Flat(nudge, T.BG, T.CONTROL_BORDER)
    nudge.text = T:Text(nudge, "GameFontHighlightSmall")
    nudge.text:SetWidth(NUDGE_TEXT_WIDTH)
    nudge.text:SetJustifyH("CENTER")
    nudge.text:SetWordWrap(true)
    nudge.text:SetText(NUDGE_TEXT)
    nudge.text:SetPoint("LEFT", NUDGE_PAD, 0)
    local away = T:Square(nudge, "x")
    away:SetSize(16, 16)
    away:SetPoint("RIGHT", -6, 0)
    window:Hint(away, "Put this note away. The ? stays, for help with any page.")
    nudge.close = away
    nudge:SetHeight(2 * 8 + math.max(12, math.ceil(nudge.text:GetStringHeight() or 12)))
    nudge:SetPoint("TOPRIGHT", header.close, "BOTTOMRIGHT", 0, -(NUDGE_GAP + NUDGE_ARROW[2]))
    nudge.arrow = nudge:CreateTexture(nil, "ARTWORK")
    nudge.arrow:SetTexture(ns.MEDIA .. "TourArrow.tga")
    nudge.arrow:SetSize(NUDGE_ARROW[1], NUDGE_ARROW[2])
    nudge.arrow:SetTexCoord(0, 1, 0, 1)
    nudge.arrow:SetPoint("TOP", help, "BOTTOM", 0, -NUDGE_GAP)
    nudge:Hide()
    window.helpNudge = nudge

    -- Runs every frame until the ? is clicked: the note and the pulse, held
    -- back while something else is up.
    local driver = CreateFrame("Frame", nil, window)
    driver:SetSize(1, 1)
    driver:SetPoint("TOPLEFT")
    nudge.driver = driver
    local since = 0
    local function Edge(share)
        local accent, from = T:Accent(), T.CONTROL_BORDER
        local function Mix(i) return from[i] + (accent[i] - from[i]) * share end
        help:SetBackdropBorderColor(Mix(1), Mix(2), Mix(3), 1)
    end
    local function Held()
        return (ns.Tour ~= nil and ns.Tour:Active()) or (window.profilePanel ~= nil and window.profilePanel:IsShown())
            or (ns.notes ~= nil and ns.notes:IsShown())
    end
    -- The note only where nothing is under it: General. On the Cooldown
    -- pulse page Preview sits at the right of its top row, so there only
    -- the ? pulses.
    local function Room()
        return window.selected == "general"
    end
    local function Update(_, elapsed)
        since = (since + (elapsed or 0)) % NUDGE_PERIOD
        local held = Held()
        nudge:SetShown(not held and Room())
        glow:SetShown(not held)
        -- Dim to lit and back, smoothly.
        local share = held and 0 or (1 - math.cos(since / NUDGE_PERIOD * 2 * math.pi)) / 2
        glow:SetAlpha(NUDGE_FILL * share)
        Edge(NUDGE_EDGE * share)
    end
    driver:SetScript("OnUpdate", Update)
    -- Clicked once, by the ? or the note's x: gone for good.
    local function Seen()
        ns.SetHelpSeen()
        driver:Hide()
        nudge:Hide()
        glow:Hide()
        Edge(0)
    end
    driver:SetShown(not ns.HelpSeen())
    away:SetScript("OnClick", Seen)
    help:SetScript("OnClick", function(self)
        T:HideTip(self)
        Seen()
        window:Help()
    end)
    -- Each time the window opens the pulse starts dim, the note waiting a
    -- frame to see what else is up; closed, both go with it.
    window:HookScript("OnShow", function() since = 0 end)
    window:HookScript("OnHide", function()
        T:HideTip(help)
        nudge:Hide()
        glow:Hide()
    end)
    -- A new accent: the note and the glow at once, the ?'s edge next frame.
    T:Paint(function(accent)
        nudge:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
        nudge.arrow:SetVertexColor(accent[1], accent[2], accent[3], 1)
        glow:SetColorTexture(accent[1], accent[2], accent[3], 1)
    end)
end

local function BuildWindow()
    local window = CreateFrame("Frame", "FECPFrame", UIParent, "BackdropTemplate")
    window:SetSize(WIDTH, HEIGHT)
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
    window:Hide()
    -- Set before anything hooks these: setting a script later would drop the
    -- hooks the pages and the profile menu add. Opened, your spells and bags
    -- are read again, so the list is up to date.
    window:SetScript("OnShow", function(self)
        if ns.Spells then ns.Spells:Scan() end
        self:Refresh()
    end)
    window:SetScript("OnHide", function(self)
        -- Closed mid-drag, it never hears the mouse let go: stop moving now.
        self:StopMovingOrSizing()
    end)
    ns.CloseOnEscape(window)

    -- Header: the addon's icon, and "Enhanced" in the accent.
    local header = T:TitleBar(window, HEADER)
    -- The accent washes in from the right, over the title bar and the pages.
    window.fades = { header = header.fade, page = T:Fade(window, T.FADE.page) }
    window.fades.page:SetPoint("TOPLEFT", NAV + 1, -(HEADER + 1))
    window.fades.page:SetPoint("BOTTOMRIGHT", -1, FOOTER)
    window.close = header.close
    window.header = header
    BuildFooter(window)
    window:Hint(header.close, "Close the window. Escape closes it too, and /fecp opens it again.")
    BuildHelp(window, header)
    BuildConfirm(window)
    ns.BuildProfileMenu(window, header, window.help)

    -- The list down the left.
    local nav = CreateFrame("Frame", nil, window, "BackdropTemplate")
    nav:SetPoint("TOPLEFT", 1, -(HEADER + 1))
    nav:SetPoint("BOTTOMLEFT", 1, FOOTER)
    nav:SetWidth(NAV)
    window.navFrame = nav
    T:Flat(nav, T.NAV, T.NAV)
    local edge = nav:CreateTexture(nil, "BORDER")
    edge:SetPoint("TOPRIGHT")
    edge:SetPoint("BOTTOMRIGHT")
    edge:SetWidth(1)
    T:Fill(edge, T.BORDER)
    window.nav = {
        pulse = NavItem(window, nav, "pulse", "Cooldown pulse", 12),
        general = NavItem(window, nav, "general", "General", 44),
    }

    -- Pages fill the rest.
    local function Page()
        local page = CreateFrame("Frame", nil, window)
        page:SetPoint("TOPLEFT", NAV + 1, -(HEADER + 1))
        page:SetPoint("BOTTOMRIGHT", -1, FOOTER)
        page:Hide()
        return page
    end
    window.pages = { pulse = Page(), general = Page() }
    ns.BuildPulsePage(window, window.pages.pulse, WIDTH - NAV - 2)
    BuildGeneral(window, window.pages.general)

    window.selected = "pulse"
    function window:Select(key)
        if not self.pages[key] then return end
        self.selected = key
        self.profilePanel:Hide()
        self:Refresh()
        if ns.Tour then ns.Tour:Sync() end
    end

    function window:Refresh()
        self:RefreshProfiles()
        local selected = self.selected
        for key, item in pairs(self.nav) do
            local chosen = key == selected
            item.fill:SetShown(chosen)
            item.glow:SetShown(chosen)
            item.mark:SetShown(chosen)
        end
        for key, page in pairs(self.pages) do page:SetShown(key == selected) end
        self.pages[selected]:Refresh()
        -- A message takes the footer, even from the control just clicked,
        -- for now: the next refresh without one, or the mouse onto another
        -- control, brings a hovered control's note back, updated.
        self.said, self.message = self.message, nil
        self.saying = self.said ~= nil
        self:ShowNote()
    end

    ns.window = window
    return window
end

function ns.ShowWindow()
    local window = ns.window or BuildWindow()
    window:Show()
    window:Raise()
end

function ns.Toggle()
    local window = ns.window or BuildWindow()
    window:SetShown(not window:IsShown())
end
