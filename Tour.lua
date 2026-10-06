-- The tour: the basics a step at a time, like the game's own tips for new
-- characters. Each step opens the page it's about, outlines the part it
-- means in the accent, and explains it in a box beside it with Back, Next and
-- Skip tour. A Try it step can move on by itself once you've done what it
-- asks. The tour only opens pages and points: it never changes a setting,
-- and the outline takes no clicks. A first install opens the window with a
-- welcome that offers it; after that it's on the General page and /fecp tour.
-- Each step has the version it arrived in, and What's new offers a shorter
-- tour of just the steps an update added (Show me what's new). The ? in
-- the window's title bar walks through the page showing: every step about
-- it, from the tour, What's new and the page help (HELP), without leaving it.
local _, ns = ...
local T = ns.Theme

local Tour = {}
ns.Tour = Tour

local FLAT = "Interface\\Buttons\\WHITE8X8"
local BOX_WIDTH, PAD = 290, 10
local GAP = 14 -- between the part outlined and the box
local OUTLINE = 4 -- how far outside that part the outline sits
local CHECK_EVERY = .25 -- how often a Try it step looks to see if it's done
local TOUR_NOTE = "Take the tour any time from the General page, or with /fecp tour."
local NEWS_NOTE = "See it again any time from What's new, or with /fecp new."
local PAGE_NOTE = "Click ? any time to see it again."

local window, box, outline
local steps, index, started, welcome
local news -- the tour showing is What's new's
local here -- the page a page's walkthrough is about, while one shows
local since = 0

local function Value(value, ...)
    if type(value) == "function" then return value(...) end
    return value
end

-- How many cooldowns are ticked to pulse, for its Try it.
local function PulsePicks()
    local count = 0
    for _ in pairs(ns.PulsePicks and ns.PulsePicks() or {}) do count = count + 1 end
    return count
end

-- The steps of the full tour, the basics. version: the version the step
-- arrived in (the first release's wait as ns.UNRELEASED for its number).
-- page: the page it opens (none keeps the one showing). when: whether it
-- can show here, if it can't always. target: the part it outlines, or the
-- first and last of a row of them. side: where the box goes, "right",
-- "left", "below" or "above"; align "end" lines the box up with the far
-- end, where the side has one. A Try it step moves on by itself when it has
-- watch, a count that goes up once it's done, unless already says it was
-- done before the step began; without watch it waits for Next, for a step
-- with more to do after it.
local STEPS = {
    {
        version = "1.0.0",
        page = "pulse",
        title = "Turn it on",
        -- With Forever Enhanced Cooldown Manager's own pulse on, it runs
        -- there, and this one's tick is greyed out.
        text = function()
            local elsewhere = ns.Link:Elsewhere()
            if elsewhere then
                return "Cooldown pulse is on in " .. elsewhere .. ", so it runs there and this tick waits."
                    .. " Turn it off there to use this one."
            end
            return "A big icon in the middle of your screen the moment a cooldown is ready, in a fight too."
                .. " This tick turns it on or off."
        end,
        try = "Try it: tick it.",
        already = function() return ns.Get("pulse") or ns.Link:Elsewhere() ~= nil end,
        alreadyText = function()
            return ns.Link:Elsewhere() and "Nothing to do here while it runs there." or "It's already on."
        end,
        watch = function() return ns.Get("pulse") and 1 or 0 end,
        -- The tick; the box under it, over the choices that follow.
        target = function(w) return w.pages.pulse.master end,
        side = "below",
    },
    {
        version = "1.0.0",
        page = "pulse",
        title = "Pick your cooldowns",
        text = "Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse,"
            .. " then pick Quick or Long for each.",
        -- No watch: once one is ticked, Quick or Long is still to pick.
        try = "Try it: tick one.",
        already = function() return PulsePicks() > 0 end,
        alreadyText = "You've ticked some already.",
        -- The list; the box above it, so its rows stay in sight.
        target = function(w) return w.pages.pulse.panel end,
        side = "above",
    },
    {
        version = "1.0.0",
        page = "pulse",
        title = "Quick and Long",
        text = "Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it,"
            .. " and Preview plays it.",
        -- No watch: Long picked, its own size, time and sound are to try.
        try = "Try it: pick Long, then Preview.",
        -- Edit and the three it picks for; the box beside them, over the
        -- look both styles share.
        target = function(w) return w.pages.pulse.styles end,
        side = "right",
    },
    {
        version = "1.0.0",
        page = "pulse",
        title = "Where it shows",
        text = "Move shows a box as big as the pulse: drag it where you want it, then click Done."
            .. " Reset puts it back in the middle.",
        -- No Try it: Move puts the window away while the box shows.
        target = function(w)
            local page = w.pages.pulse
            return page.move, page.reset
        end,
        side = "below",
    },
    {
        version = "1.0.0",
        page = "general",
        title = "General",
        text = "Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas."
            .. " The minimap button and this window's accent are here too. /fecp opens this window.",
        -- The three buttons; the box under them, at the page's left.
        target = function(w) return w.tour, w.discord end,
        side = "below",
    },
}

-- Steps only What's new tours, for what an update added after the basics.
-- The same fields as above. Steps waiting for the next update's number are
-- ns.UNRELEASED; the release gives them that number.
local NEWS = {
}

-- Steps only a page's own walkthrough shows (the ? in the title bar), for
-- what the tour leaves out: never in it or What's new. The same fields,
-- with no version.
local HELP = {
    {
        page = "pulse",
        title = "Both styles",
        text = "See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions"
            .. " in the list, and the sound at your Master volume.",
        -- The right-hand column; the box beside it, over Edit's column.
        target = function(w) return w.pages.pulse.look end,
        side = "left",
    },
    {
        page = "general",
        title = "Minimap button",
        text = "Click it for these settings, right-click for What's new, and drag it round the minimap."
            .. " Untick to hide it: /fecp still opens them.",
        target = function(w) return w.minimap end,
        side = "right",
    },
    {
        page = "general",
        title = "Window accent",
        text = "The colour of this window's headings, ticks, sliders and highlights.",
        target = function(w) return w.swatches[1], w.swatches[#w.swatches] end,
        side = "below",
    },
}

-- Where the box goes against what it points at, and its arrow on the box's
-- edge: the box's point, the target's point, the offset, the arrow's point
-- on the box and its offset, and which way the arrow faces.
local PLACES = {
    right = { "TOPLEFT", "TOPRIGHT", GAP, 0, "RIGHT", "TOPLEFT", 0, -20, "left" },
    left = { "TOPRIGHT", "TOPLEFT", -GAP, 0, "LEFT", "TOPRIGHT", 0, -20, "right" },
    below = { "TOPLEFT", "BOTTOMLEFT", 0, -GAP, "BOTTOM", "TOPLEFT", 24, 0, "up" },
    above = { "BOTTOMLEFT", "TOPLEFT", 0, GAP, "TOP", "BOTTOMLEFT", 24, 0, "down" },
    belowEnd = { "TOPRIGHT", "BOTTOMRIGHT", 0, -GAP, "BOTTOM", "TOPRIGHT", -24, 0, "up" },
    aboveEnd = { "BOTTOMRIGHT", "TOPRIGHT", 0, GAP, "TOP", "BOTTOMRIGHT", -24, 0, "down" },
}
local ALIGNS = { ["end"] = "End" }

local function Strip(frame, layer)
    local strip = frame:CreateTexture(nil, layer)
    strip:SetTexture(FLAT)
    return strip
end

-- A ring of four strips, `width` thick, `out` pixels outside the frame's edge.
local function Ring(frame, width, out, layer)
    local top, bottom, left, right = Strip(frame, layer), Strip(frame, layer), Strip(frame, layer), Strip(frame, layer)
    top:SetPoint("TOPLEFT", -out, out)
    top:SetPoint("TOPRIGHT", out, out)
    top:SetHeight(width)
    bottom:SetPoint("BOTTOMLEFT", -out, -out)
    bottom:SetPoint("BOTTOMRIGHT", out, -out)
    bottom:SetHeight(width)
    left:SetPoint("TOPLEFT", -out, out)
    left:SetPoint("BOTTOMLEFT", -out, -out)
    left:SetWidth(width)
    right:SetPoint("TOPRIGHT", out, out)
    right:SetPoint("BOTTOMRIGHT", out, -out)
    right:SetWidth(width)
    return { top, bottom, left, right }
end

local function Build()
    window = ns.window
    -- The outline: the accent, with a soft edge, gently pulsing.
    outline = CreateFrame("Frame", nil, window)
    outline:SetFrameStrata("FULLSCREEN_DIALOG")
    outline:SetFrameLevel(window:GetFrameLevel() + 70)
    local line = Ring(outline, 2, 0, "OVERLAY")
    local soft = Ring(outline, 3, 3, "ARTWORK")
    T:Paint(function(accent)
        for _, strip in ipairs(line) do strip:SetVertexColor(accent[1], accent[2], accent[3], 1) end
        for _, strip in ipairs(soft) do strip:SetVertexColor(accent[1], accent[2], accent[3], .3) end
    end)
    local pulse = 0
    outline:SetScript("OnUpdate", function(self, elapsed)
        pulse = pulse + elapsed
        self:SetAlpha(.55 + .45 * (1 + math.sin(pulse * 4)) / 2)
    end)
    outline:Hide()

    box = CreateFrame("Frame", "FECPTour", window, "BackdropTemplate")
    box.outline = outline
    box:SetWidth(BOX_WIDTH)
    box:SetFrameStrata("FULLSCREEN_DIALOG")
    box:SetFrameLevel(window:GetFrameLevel() + 80)
    box:SetClampedToScreen(true)
    box:EnableMouse(true)
    T:Flat(box, T.BG, T.CONTROL_BORDER)
    box.title = T:Heading(box, "")
    box.title:SetPoint("TOPLEFT", PAD, -PAD)
    box.count = T:Text(box, "GameFontHighlightSmall", T.MUTED)
    box.count:SetPoint("TOPRIGHT", -PAD, -PAD)
    box.count:SetJustifyH("RIGHT")
    box.text = T:Text(box, "GameFontHighlightSmall")
    box.text:SetPoint("TOPLEFT", PAD, -(PAD + 16))
    box.text:SetWidth(BOX_WIDTH - 2 * PAD)
    box.arrow = box:CreateTexture(nil, "ARTWORK")
    box.arrow:SetTexture(ns.MEDIA .. "TourArrow.tga")
    local nextButton = T:Button(box, "Next", 64, 20)
    nextButton:SetPoint("BOTTOMRIGHT", -PAD, PAD)
    local back = T:Button(box, "Back", 64, 20)
    back:SetPoint("RIGHT", nextButton, "LEFT", -6, 0)
    local skip = T:Button(box, "Skip tour", 76, 20)
    skip:SetPoint("BOTTOMLEFT", PAD, PAD)
    T:Paint(function(accent)
        box:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
        box.arrow:SetVertexColor(accent[1], accent[2], accent[3], 1)
        nextButton:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
    end)
    nextButton:SetScript("OnClick", function()
        if welcome then Tour:Start() else Tour:Next() end
    end)
    back:SetScript("OnClick", function() Tour:Back() end)
    skip:SetScript("OnClick", function()
        local note = here and PAGE_NOTE or news and NEWS_NOTE or TOUR_NOTE
        Tour:Stop()
        window:Say(note)
        window:Refresh()
    end)
    box.next, box.back, box.skip = nextButton, back, skip
    -- A Try it step watches for what it asked for.
    box:SetScript("OnUpdate", function(_, elapsed)
        local step = steps and index and steps[index]
        if not (step and step.watch and started) then return end
        since = since + elapsed
        if since < CHECK_EVERY then return end
        since = 0
        if step.watch() > started then Tour:Next() end
    end)
    box:Hide()
    -- Closing the window ends the tour.
    window:HookScript("OnHide", function() Tour:Stop() end)
    -- Opening or closing the profile menu moves the box beside it, or back.
    if window.profilePanel then
        window.profilePanel:HookScript("OnShow", function() Tour:Repoint() end)
        window.profilePanel:HookScript("OnHide", function() Tour:Repoint() end)
    end
end

local function Ready()
    if not ns.ShowWindow then return false end
    ns.ShowWindow()
    if not box then Build() end
    return true
end

-- Sizes the box round its text: the title row, the text, then the buttons.
local function Fit()
    box:SetHeight(PAD + 16 + math.ceil(box.text:GetStringHeight() or 0) + 12 + 20 + PAD)
end

local function Point(step)
    local first, last = Value(step.target, window)
    last = last or first
    if not first then
        outline:Hide()
        box.arrow:Hide()
        box:ClearAllPoints()
        box:SetPoint("CENTER", window, "CENTER", 75, 30)
        return
    end
    outline:ClearAllPoints()
    outline:SetPoint("TOPLEFT", first, "TOPLEFT", -OUTLINE, OUTLINE)
    outline:SetPoint("BOTTOMRIGHT", last, "BOTTOMRIGHT", OUTLINE, -OUTLINE)
    outline:Show()
    local side = Value(step.side, window) or "below"
    local align = ALIGNS[Value(step.align, window)]
    local place = (align and PLACES[side .. align]) or PLACES[side] or PLACES.below
    local anchor = place[2]:find("RIGHT") and last or first
    box:ClearAllPoints()
    box:SetPoint(place[1], anchor, place[2], place[3], place[4])
    local arrow = box.arrow
    arrow:ClearAllPoints()
    arrow:SetPoint(place[5], box, place[6], place[7], place[8])
    if place[9] == "left" then
        arrow:SetSize(9, 16)
        arrow:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
    elseif place[9] == "right" then
        arrow:SetSize(9, 16)
        arrow:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
    else
        arrow:SetSize(16, 9)
        if place[9] == "up" then arrow:SetTexCoord(0, 1, 0, 1) else arrow:SetTexCoord(0, 1, 1, 0) end
    end
    arrow:Show()
end

local function Show(i)
    index, welcome = i, nil
    local step = steps[i]
    -- A page's walkthrough stays on its page, going back to it should
    -- another have been picked meanwhile.
    if here then
        if window.selected ~= here then window:Select(here) end
    elseif step.page then
        window:Select(step.page)
    end
    local text = Value(step.text, window)
    local already = step.already and step.already()
    if step.try then
        text = text .. "\n\n|cff" .. T:Hex(T:Accent()) .. (already and Value(step.alreadyText, window) or step.try) .. "|r"
    end
    box.title:SetText(step.title:upper())
    box.count:SetText(i .. " of " .. #steps)
    box.count:Show()
    box.text:SetText(text)
    box.back:SetShown(i > 1)
    box.next:SetWidth(64)
    box.next:SetLabel(i == #steps and "Done" or "Next")
    box.skip:SetLabel("Skip tour")
    started = step.watch and not already and step.watch() or nil
    since = 0
    Fit()
    Point(step)
    box:Show()
    box:Raise()
end

-- The tour from the start, over the window.
function Tour:Start()
    if not Ready() then return end
    steps, news, here = {}, nil, nil
    for _, step in ipairs(STEPS) do
        if not step.when or step.when(window) then steps[#steps + 1] = step end
    end
    Show(1)
end

-- The newest version a step that can show here arrived in, no newer than the
-- one running (for a copy straight from the source, the newest there is).
local function Latest(now)
    local compare, latest = ns.CompareVersions, nil
    for _, list in ipairs({ STEPS, NEWS }) do
        for _, step in ipairs(list) do
            if (compare(step.version, now) or 1) < 1 and (not step.when or step.when(window))
                and (not latest or compare(step.version, latest) == 1) then
                latest = step.version
            end
        end
    end
    return latest
end

-- The steps an update added, the full tour's then What's new's: newer than
-- the version seen before it and no newer than the one running, so versions
-- skipped come together. With no version seen (What's new opened by hand, or
-- none noted), the latest update's: the steps of the newest version that
-- added any that can show here. Only steps that can show.
function Tour:News(seen)
    local now, compare = ns.Version(), ns.CompareVersions
    local byHand = not compare(seen, now)
    local latest = byHand and Latest(now)
    local list = {}
    if byHand and not latest then return list end
    for _, group in ipairs({ STEPS, NEWS }) do
        for _, step in ipairs(group) do
            local new
            if latest then
                new = compare(step.version, latest) == 0
            else
                new = compare(step.version, seen) == 1 and (compare(step.version, now) or 1) < 1
            end
            if new and (not step.when or step.when(window)) then list[#list + 1] = step end
        end
    end
    return list
end

-- What's new's tour: just those steps, over the window.
function Tour:StartNews(seen)
    local list = self:News(seen)
    if #list == 0 or not Ready() then return end
    steps, news, here = list, true, nil
    Show(1)
end

-- The steps about a page, for its walkthrough: the full tour's, then What's
-- new's, then the page help's, each where it can show and its part is
-- there to point at. Asked once the window is made.
function Tour:Page(key)
    local list = {}
    for _, group in ipairs({ STEPS, NEWS, HELP }) do
        for _, step in ipairs(group) do
            if step.page and step.page == key and (not step.when or step.when(window)) then
                local part = window and Value(step.target, window)
                if part and part:IsShown() then list[#list + 1] = step end
            end
        end
    end
    return list
end

-- The ? in the title bar: a walkthrough of the page showing, over the
-- window, never leaving it. False, with nothing started, for a page with no
-- steps.
function Tour:StartPage(key)
    if not Ready() then return false end
    local list = self:Page(key)
    if #list == 0 then return false end
    steps, news, here = list, nil, key
    Show(1)
    return true
end

-- A first install: the window, and an offer of the tour.
function Tour:Welcome()
    if not Ready() then return end
    steps, index, started, welcome, news, here = nil, nil, nil, true, nil, nil
    box.title:SetText("WELCOME")
    box.count:Hide()
    box.text:SetText("New to " .. ns.TITLE .. "? A quick tour shows you the basics, a page at a time. It takes about a minute.")
    box.back:Hide()
    box.next:SetWidth(100)
    box.next:SetLabel("Take the tour")
    box.skip:SetLabel("Skip")
    Fit()
    Point({})
    box:Show()
    box:Raise()
end

function Tour:Next()
    if not (steps and index) then return end
    if index < #steps then return Show(index + 1) end
    local done = here and "That's this page. " .. PAGE_NOTE or news and "That's what's new. " .. NEWS_NOTE
        or "That's the tour. " .. TOUR_NOTE
    self:Stop()
    window:Say(done)
    window:Refresh()
end

function Tour:Back()
    if steps and index and index > 1 then Show(index - 1) end
end

function Tour:Stop()
    steps, index, started, welcome, news, here = nil, nil, nil, nil, nil, nil
    if box then
        box:Hide()
        outline:Hide()
    end
end

function Tour:Active()
    return box ~= nil and box:IsShown()
end

-- Called whenever the window changes page: the outline only shows on the page
-- the step is about. Next and Back always go back to it.
function Tour:Sync()
    local step = steps and index and steps[index]
    if not step or not box then return end
    local shown
    if here then shown = window.selected == here else shown = not step.page or step.page == window.selected end
    outline:SetShown(shown and Value(step.target, window) ~= nil)
    box.arrow:SetShown(shown)
end

-- Points the step showing at its part again, for a part that moved or
-- changed (once the profile menu opens or closes).
function Tour:Repoint()
    local step = steps and index and steps[index]
    if not (step and box and box:IsShown()) then return end
    Point(step)
    self:Sync()
end
