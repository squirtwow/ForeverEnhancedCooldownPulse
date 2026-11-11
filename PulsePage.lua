-- The Cooldown pulse page in the /fecp window, as Forever Enhanced Cooldown
-- Manager's own: one tick to turn it on (greyed out while that addon's pulse
-- runs, Link.lua), a live preview of a pulse on a small screen and up close,
-- where it sits, how it looks and sounds in each of its two styles (Quick
-- and Long), and every cooldown you have that can pulse, spells and items,
-- to tick, each one Quick or Long, and your class's procs with Procs too.
-- Pulse.lua does the work. Its words are in
-- the language showing (Locale.lua), the style, border and sound names
-- looked up as they show; spell and item names are the game's own.
local _, ns = ...
local T, L = ns.Theme, ns.L

-- Room for a label before its control (a slider's track, or a choice's
-- buttons). Measured in game, a label runs about seven units a letter: the
-- longest, See-through, needs about 80, and the thumb sits 5 over the
-- track's start, so it never reaches a label.
local LABEL = 96
local COLUMN = 312 -- the right-hand column
local PILLS = 160 -- the left column's choices: as wide as its sliders' tracks
local BORDER_PILLS = 120 -- Border's, with Shadow beside them
local ROW, HEADER_ROW = 24, 20 -- the list's rows
local SWITCH = 96 -- each row's Quick | Long switch, on the right
local SIDE = 90 -- and its cooldown, just before the switch
local SCREEN_HEIGHT = 66 -- the preview's small screen
local SCREEN_MAX = 172 -- and its widest, clear of UP CLOSE on a very wide screen
local CLOSE, CLOSE_BOX = 40, 66 -- the up close preview's icon, and its box
local REST = .6 -- the previews rest this long between pulses

-- A cooldown in plain words: "45s", "3 min", "1.5 min", "1 hour", with the
-- language's decimal mark.
local function Long(seconds)
    if seconds < 60 then return ns.Decimal(L["%gs"]:format(seconds)) end
    if seconds < 3600 then return ns.Decimal(L["%g min"]:format(math.floor(seconds / 6 + .5) / 10)) end
    local hours = math.floor(seconds / 360 + .5) / 10
    return ns.Decimal((hours == 1 and L["%g hour"] or L["%g hours"]):format(hours))
end
ns.PulseLong = Long

-- A slider whose value reads in its own words (format gives them), with
-- room for "160%" up to its track. wide: a little more room, its track
-- ending sooner, for seconds in a language that writes them its own way
-- ("2.5秒", "2.5 s").
local function Worded(slider, format, wide)
    slider.value:SetWidth(wide and 44 or 36)
    if wide then slider.track:SetPoint("RIGHT", -48, 0) end
    local set = slider.Set
    function slider:Set(value)
        set(self, value)
        self.value:SetText(format(value))
    end
end

-- A choice's buttons, from its keys and their names.
local function Choices(keys, names)
    local items = {}
    for _, key in ipairs(keys) do items[#items + 1] = { key = key, label = L[names[key]] } end
    return items
end

-- A style's name: "Quick" or "Long".
local function StyleName(style)
    return L[ns.PULSE_STYLE_NAMES[style] or ns.PULSE_STYLE_NAMES.quick]
end

-- The name of the style the page shows.
local function Editing()
    return StyleName(ns.Pulse.editing)
end

-- How far from the middle, one way: "100 right", "50 down" (plus and minus:
-- its words each way, the number in them).
local function Way(n, plus, minus)
    return (n < 0 and minus or plus):format(math.abs(n))
end

-- The screen's shape, in the game's units, for the small screen.
local function ScreenSize()
    local width, height = UIParent:GetWidth() or 0, UIParent:GetHeight() or 0
    if width <= 0 or height <= 0 then width, height = 1366, 768 end
    return width, height
end

-- The preview: a small screen with the pulse where and as big as it shows,
-- the pulse up close, and where it sits with Move and Reset. Both play the
-- style picked under Edit.
local function BuildTray(window, page, inner)
    local P = ns.Pulse
    local tray = CreateFrame("Frame", nil, page, "BackdropTemplate")
    tray:SetPoint("TOPLEFT", 16, -38)
    tray:SetSize(inner, 100)
    T:Flat(tray, T.PANEL, T.BORDER)
    page.tray = tray
    local function Caption(text, x)
        local caption = T:Text(tray, "GameFontHighlightSmall", T.MUTED)
        caption:SetPoint("TOPLEFT", x, -8)
        caption:SetText(ns.Upper(text))
    end
    Caption(L["On your screen"], 12)
    Caption(L["Up close"], 196)
    Caption(L["Where it shows"], 300)

    local screen = CreateFrame("Frame", nil, tray, "BackdropTemplate")
    screen:SetPoint("TOPLEFT", 12, -24)
    screen:SetSize(SCREEN_HEIGHT * 16 / 9, SCREEN_HEIGHT)
    T:Flat(screen, T.FIELD, T.CONTROL_BORDER)
    screen:SetClipsChildren(true)
    -- Where the pulse sits, outlined in the accent between pulses too.
    local spotBox = CreateFrame("Frame", nil, screen, "BackdropTemplate")
    T:Flat(spotBox, { 0, 0, 0, 0 }, T.CONTROL_BORDER)
    T:Paint(spotBox, function(accent) spotBox:SetBackdropBorderColor(accent[1], accent[2], accent[3], .6) end)
    local spot = P:NewArt(screen)
    spot:SetPoint("CENTER", spotBox, "CENTER")
    local close = CreateFrame("Frame", nil, tray)
    close:SetPoint("TOPLEFT", 196, -24)
    close:SetSize(CLOSE_BOX, CLOSE_BOX)
    close:SetClipsChildren(true)
    local sample = P:NewArt(close)
    sample:SetPoint("CENTER")
    page.screen, page.spotBox, page.spot, page.sample = screen, spotBox, spot, sample

    -- Both run the pulse over and over, as your choices make it.
    local clock = 0
    tray:SetScript("OnUpdate", function(_, elapsed)
        clock = clock + (elapsed or 0)
        local total = P:Seconds(P.editing)
        local at = clock % (total + REST)
        local fade, grow = 0, 1
        if at < total then fade, grow = P:Shape(at / total) end
        local alpha = fade * P:Opacity()
        spot:SetAlpha(alpha)
        sample:SetAlpha(alpha)
        spot:SetSize(spot.size * grow, spot.size * grow)
        sample:SetSize(CLOSE * grow, CLOSE * grow)
    end)
    spot.size = 1

    local move = T:Button(tray, L["Move"], 80, 22)
    move:SetPoint("TOPLEFT", 300, -26)
    move:SetScript("OnClick", function()
        local ok, why = P:StartMove()
        if not ok then
            window:Say(why)
            window:Refresh()
        end
    end)
    window:Hint(move, L["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done."
        .. " Both styles show there."])
    local reset = T:Button(tray, L["Reset"], 80, 22)
    reset:SetPoint("TOPLEFT", 388, -26)
    reset:SetScript("OnClick", function()
        P:ResetPlace()
        window:Say(L["The pulse is back in the middle of your screen."])
        window:Refresh()
    end)
    window:Hint(reset, L["Puts the pulse back in the middle of your screen."])
    local where = T:Text(tray, "GameFontHighlightSmall", T.MUTED)
    where:SetPoint("TOPLEFT", 300, -58)
    where:SetWidth(inner - 312)
    page.move, page.reset, page.where = move, reset, where
end

-- The choices: on or off, then the style picked under Edit (its size, time
-- and sound) on the left, and the look both styles share on the right.
local function BuildOptions(window, page, inner)
    local P = ns.Pulse
    local function Changed()
        P:Apply()
        window:Refresh()
    end
    local options = CreateFrame("Frame", nil, page)
    options:SetPoint("TOPLEFT", page.tray, "BOTTOMLEFT", 0, -10)
    options:SetSize(inner, 156)
    page.options = options
    local master = T:Check(options, L["Pulse an icon when a cooldown is ready"], function(self)
        ns.Set("pulse", self:GetChecked())
        Changed()
    end)
    master:SetPoint("TOPLEFT", 0, 0)
    -- Greyed out while Forever Enhanced Cooldown Manager's pulse runs: then
    -- it says where, and how to swap.
    window:Hint(master, function()
        return ns.Link:Note() or L["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too."
            .. " It never takes the mouse."]
    end)
    page.master = master

    -- A label, then its buttons LABEL along.
    local function Pills(label, keys, names, width, x, y, onPick, note)
        local text = T:Text(options, "GameFontHighlight")
        text:SetPoint("TOPLEFT", x, y - 4)
        text:SetText(label)
        local pills = T:Segmented(options, Choices(keys, names), width, function(key)
            onPick(key)
            Changed()
        end)
        pills:SetPoint("TOPLEFT", x + LABEL, y)
        pills.label = text
        for _, button in ipairs(pills.buttons) do window:Hint(button, note) end
        return pills
    end
    -- Sliders, each saving its setting; one of a style's shows only while
    -- that style is picked under Edit.
    page.sliders, page.slider = {}, {}
    local function Seconds(value) return ns.Decimal(L["%.1fs"]:format(value / 10)) end
    local function Percent(value) return value .. "%" end
    local function Slider(label, key, limits, step, x, y, style, note, format)
        local slider = T:Slider(options, label, limits, step, x == 0 and COLUMN - 16 or inner - COLUMN, function(value)
            ns.Set(key, value)
            Changed()
        end, LABEL)
        slider:SetPoint("TOPLEFT", x, y)
        slider.key, slider.style = key, style
        if format then Worded(slider, format, format == Seconds and L["%.1fs"] ~= "%.1fs") end
        window:Hint(slider, note)
        page.sliders[#page.sliders + 1] = slider
        page.slider[key] = slider
    end

    page.edit = Pills(L["Edit"], ns.PULSE_STYLE_KEYS, ns.PULSE_STYLE_NAMES, PILLS, 0, -26, function(key) P.editing = key end,
        L["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."])
    local big = L["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
    Slider(L["Size"], "pulseSize", ns.PULSE_SIZE, 16, 0, -48, "quick", big:format(StyleName("quick")))
    Slider(L["Size"], "pulseLongSize", ns.PULSE_LONG_SIZE, 16, 0, -48, "long", big:format(StyleName("long")))
    Slider(L["Shows for"], "pulseTime", ns.PULSE_TIME, 1, 0, -70, "quick",
        L["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."], Seconds)
    Slider(L["Shows for"], "pulseLongTime", ns.PULSE_LONG_TIME, 1, 0, -70, "long",
        L["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."], Seconds)
    -- The sound: its name between two arrows. Each click steps to the next
    -- one (or back) and plays it, so they can be heard in turn.
    local function SoundPicker(x, y, note)
        local text = T:Text(options, "GameFontHighlight")
        text:SetPoint("TOPLEFT", x, y - 4)
        text:SetText(L["Sound"])
        local picker = CreateFrame("Frame", nil, options, "BackdropTemplate")
        picker:SetSize(PILLS, 20)
        picker:SetPoint("TOPLEFT", x + LABEL, y)
        T:Flat(picker, T.FIELD, T.CONTROL_BORDER)
        local function Step(by)
            local keys, at = ns.PULSE_SOUND_KEYS, 1
            for i, key in ipairs(keys) do
                if key == picker.selected then at = i end
            end
            local key = keys[(at - 1 + by) % #keys + 1]
            ns.Set(P.STYLES[P.editing].sound, key)
            P:PlaySound(key)
            Changed()
        end
        picker.back = T:Square(picker, "<")
        picker.back:SetPoint("LEFT", 1, 0)
        picker.back:SetScript("OnClick", function() Step(-1) end)
        picker.next = T:Square(picker, ">")
        picker.next:SetPoint("RIGHT", -1, 0)
        picker.next:SetScript("OnClick", function() Step(1) end)
        -- Its name plays it again.
        picker.play = CreateFrame("Button", nil, picker)
        picker.play:SetSize(PILLS - 2 * 18 - 8, 18)
        picker.play:SetPoint("CENTER")
        picker.play:SetScript("OnClick", function() P:PlaySound(picker.selected) end)
        picker.name = T:Text(picker.play, "GameFontHighlightSmall")
        picker.name:SetPoint("CENTER")
        picker.name:SetJustifyH("CENTER")
        picker.label = text
        function picker:SetSelected(key)
            self.selected = key
            self.name:SetText(L[ns.PULSE_SOUND_NAMES[key] or ns.PULSE_SOUND_NAMES.none])
        end
        picker.play.label = picker.name
        picker.buttons = { picker.back, picker.play, picker.next }
        for _, button in ipairs(picker.buttons) do window:Hint(button, note) end
        return picker
    end
    page.sound = SoundPicker(0, -92, function()
        return L["A sound with each %s pulse. The arrows step through them and play each one; click its name to"
            .. " hear it again."]:format(Editing())
    end)
    -- Edit and the size, time and sound it picks for, as one part for the
    -- tour to outline: the box can sit over the right-hand column beside it.
    -- The page's own, so it's no piece of the options.
    local styles = CreateFrame("Frame", nil, page)
    styles:SetPoint("TOPLEFT", options, "TOPLEFT", 0, -26)
    styles:SetSize(COLUMN - 16, 112 - 26)
    page.styles = styles

    Slider(L["See-through"], "pulseSeeThrough", ns.PULSE_SEE_THROUGH, 5, COLUMN, -26, nil,
        L["How much of the game shows through the icon, in both styles. 0 is solid."], Percent)
    Slider(L["Grows to"], "pulseGrow", ns.PULSE_GROW, 5, COLUMN, -48, nil,
        L["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."], Percent)
    page.border = Pills(L["Border"], ns.PULSE_BORDER_KEYS, ns.PULSE_BORDER_NAMES, BORDER_PILLS, COLUMN, -70,
        function(key) ns.Set("pulseBorder", key) end, L["A dark edge round the icon, in both styles: none, thin or thick."])
    local function Tick(label, key, x, y, note)
        local check = T:Check(options, label, function(self)
            ns.Set(key, self:GetChecked())
            Changed()
        end)
        check:SetPoint("TOPLEFT", x, y)
        window:Hint(check, note)
        return check
    end
    page.shadow = Tick(L["Shadow"], "pulseShadow", COLUMN + LABEL + BORDER_PILLS + 12, -72,
        L["A soft shadow round the icon, in both styles, fading out from its edge."])
    page.items = Tick(L["Trinkets and potions too"], "pulseItems", COLUMN, -94,
        L["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."])
    -- Your class's procs, listed to tick (Pulse.lua's Procs); greyed while
    -- the game can't show them.
    page.procs = Tick(L["Procs too"], "pulseProcs", COLUMN, -116, function()
        if not P:CanProcs() then return L["Your game can't show proc pulses."] end
        return L["Your class's procs, like Clearcasting or Missile Barrage: a pulse the moment one lands, in a fight too."
            .. " Procs pulse without a sound."] .. L[" (experimental)"]
    end)
    page.volume = Tick(L["Play at Master volume"], "pulseMaster", COLUMN, -138,
        L["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."])
    -- The right-hand column as one part, for the page's walkthrough: the look
    -- both styles share, and the ticks under it.
    local look = CreateFrame("Frame", nil, page)
    look:SetPoint("TOPLEFT", options, "TOPLEFT", COLUMN, -26)
    look:SetSize(inner - COLUMN, 156 - 26)
    page.look = look
end

-- Which cooldowns pulse: every spell you know with a cooldown of its own,
-- your class's procs (with Procs too), then your items, to tick. Each one
-- is Quick or Long.
local function BuildList(window, page, inner)
    local P = ns.Pulse
    local heading = T:Heading(page, L["Which cooldowns"])
    heading:SetPoint("TOPLEFT", page.options, "BOTTOMLEFT", 0, -10)
    local about = T:Text(page, "GameFontHighlightSmall", T.MUTED)
    about:SetPoint("LEFT", heading, "RIGHT", 10, 0)
    about:SetText(L["tick the ones you want to pulse, then pick Quick or Long for each"])
    page.heading, page.about = heading, about
    local panel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    panel:SetPoint("TOPLEFT", heading, "BOTTOMLEFT", 0, -6)
    panel:SetPoint("BOTTOMRIGHT", -16, 12)
    T:Box(panel)
    local empty = T:Text(panel, "GameFontHighlightSmall", T.MUTED)
    empty:SetPoint("TOPLEFT", 12, -12)
    empty:SetWidth(inner - 24)
    local listWidth = inner - 30
    -- Pinned by two corners, again once the page shows (see the bar page).
    local scroll = T:Scroll(panel, listWidth)
    local function Pin()
        scroll:ClearAllPoints()
        scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -6)
        scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 6)
        scroll:ScrollTo(scroll:GetVerticalScroll() or 0)
    end
    Pin()
    page:HookScript("OnShow", function() C_Timer.After(0, Pin) end)
    window:Hint(scroll.thumb, ns.ScrollNote())
    page.panel, page.list, page.empty, page.rows = panel, scroll, empty, {}

    local function Row(i)
        local row = page.rows[i]
        if row then return row end
        row = CreateFrame("Frame", nil, scroll.content)
        row:SetSize(listWidth, ROW)
        -- A spell or item pulses once ticked.
        row.check = T:Check(row, nil, function(self)
            ns.SetPulsePick(row.key, self:GetChecked())
            P:Apply()
            window:Refresh()
        end)
        row.check:SetPoint("LEFT", 4, 0)
        -- The whole row clicks its tick, as on the bar pages, up to its switch.
        row.check:SetHitRectInsets(-4, -(listWidth - 20 - SWITCH - 12), -(ROW - 16) / 2, -(ROW - 16) / 2)
        -- Items listed from your bags (trinkets, healthstones and potions
        -- have been seen pulsing in game), and procs, aren't seen pulsing in
        -- game yet.
        window:Hint(row.check, function()
            local name = row.name:GetText() or ""
            if row.check:GetChecked() then return L["Untick to leave %s out."]:format(name) end
            if row.proc then return L["Tick to pulse when %s lands."]:format(name) .. L[" (experimental)"] end
            return L["Tick to pulse when %s is ready."]:format(name) .. (row.bags and L[" (experimental)"] or "")
        end)
        -- Quick or Long, on the right; its cooldown just before it. A proc's
        -- pulse is the game's, so it's told the new style too.
        row.style = T:Segmented(row, Choices(ns.PULSE_STYLE_KEYS, ns.PULSE_STYLE_NAMES), SWITCH, function(key)
            ns.SetPulseStyle(row.key, key)
            if row.proc then P:Apply() end
            window:Refresh()
        end)
        row.style:SetPoint("RIGHT", -4, 0)
        -- Says how it pulses now (once ticked, if it isn't), and what this one
        -- picks. A proc's style has no sound.
        for _, button in ipairs(row.style.buttons) do
            window:Hint(button, function()
                local name, now = row.name:GetText() or "", P:StyleOf(row.key)
                local said = (row.check:GetChecked() and L["%s pulses %s."] or L["Once ticked, %s pulses %s."])
                    :format(name, StyleName(now))
                local click = button.key ~= now and L["Click for %s."]:format(StyleName(button.key)) or nil
                if row.proc then
                    return ns.Join(said, click, L["Each style has its own size and time, set under Edit above. Procs pulse without a sound."])
                end
                return ns.Join(said, click, L["Each style has its own size, time and sound, set under Edit above."])
            end)
        end
        row.long = T:Text(row, "GameFontHighlightSmall", T.MUTED)
        row.long:SetPoint("RIGHT", row.style, "LEFT", -12, 0)
        row.long:SetWidth(SIDE)
        row.long:SetJustifyH("RIGHT")
        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(16, 16)
        row.icon:SetPoint("LEFT", 26, 0)
        T:Zoom(row.icon)
        -- Cut short before the cooldown, should a name be very long.
        row.name = T:Text(row, "GameFontHighlight")
        row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
        row.name:SetPoint("RIGHT", row.long, "LEFT", -8, 0)
        row.name:SetWordWrap(false)
        row.header = T:Text(row, "GameFontHighlightSmall", T.MUTED)
        row.header:SetPoint("BOTTOMLEFT", 4, 3)
        page.rows[i] = row
        return row
    end

    -- Headers and rows from the top, for the spells, the procs, then the items.
    function page:FillList(spells, procs, items)
        local y, n = 0, 0
        local function Header(text)
            n = n + 1
            local row = Row(n)
            row:SetHeight(HEADER_ROW)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, -y)
            row.header:SetText(ns.Upper(text))
            row.header:Show()
            for _, part in ipairs({ row.check, row.icon, row.name, row.long, row.style }) do part:Hide() end
            row.key, row.item, row.bags, row.proc = nil, nil, nil, nil
            row:Show()
            y = y + HEADER_ROW
        end
        local function Entry(entry, long, item, proc)
            n = n + 1
            local row = Row(n)
            row:SetHeight(ROW)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, -y)
            row.header:Hide()
            row.key, row.item, row.proc = entry.key, item, proc
            row.bags = item and entry.key:find("^item:") ~= nil or nil
            row.icon:SetTexture(entry.icon or 134400)
            row.name:SetText(entry.name)
            row.long:SetText(long)
            row.check:SetChecked(entry.on)
            row.style:SetSelected(P:StyleOf(entry.key))
            for _, part in ipairs({ row.check, row.icon, row.name, row.long, row.style }) do part:Show() end
            row:Show()
            y = y + ROW
        end
        if #spells > 0 then Header(L["Spells"]) end
        for _, entry in ipairs(spells) do Entry(entry, Long(entry.base), false) end
        -- A proc has no cooldown to show: it pulses as it lands.
        if #procs > 0 then Header(L["Procs"]) end
        for _, entry in ipairs(procs) do Entry(entry, "", false, true) end
        if #items > 0 then Header(L["Items"]) end
        -- An item ticked that you carry none of now says so; it pulses again once you do.
        for _, entry in ipairs(items) do
            Entry(entry, entry.slot and L["trinket"] or entry.carried == false and L["none left"] or L["in your bags"], true)
        end
        for i = n + 1, #page.rows do page.rows[i]:Hide() end
        empty:SetText(n == 0 and L["None of your spells has a cooldown of its own yet. New ones show here as you learn them."] or "")
        empty:SetShown(n == 0)
        scroll.content:SetHeight(math.max(1, y))
        scroll:ScrollTo(scroll:GetVerticalScroll() or 0)
    end
end

function ns.BuildPulsePage(window, page, width)
    local P = ns.Pulse
    local inner = width - 32
    local title = T:Heading(page, L["Cooldown pulse"])
    title:SetPoint("TOPLEFT", 16, -16)
    local status = T:Text(page, "GameFontHighlightSmall", T.MUTED)
    status:SetPoint("LEFT", title, "RIGHT", 10, 0)
    page.title, page.status = title, status
    local preview = T:Button(page, L["Preview"], 110, 20)
    preview:SetPoint("TOPRIGHT", -16, -12)
    preview:SetScript("OnClick", function() P:Preview() end)
    window:Hint(preview, function()
        return L["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]:format(Editing())
    end)
    page.previewButton = preview
    BuildTray(window, page, inner)
    BuildOptions(window, page, inner)
    BuildList(window, page, inner)

    function page:Refresh()
        if not P.STYLES[P.editing] then P.editing = "quick" end
        local on, editing = ns.Get("pulse"), P.editing
        -- Your own choice, greyed out while the pulse runs in Forever
        -- Enhanced Cooldown Manager: it's kept for when that one's turned off.
        local elsewhere = ns.Link:Elsewhere()
        self.master:SetChecked(on)
        self.master:SetUsable(not elsewhere)
        self.edit:SetSelected(editing)
        for _, slider in ipairs(self.sliders) do
            slider:SetShown(slider.style == nil or slider.style == editing)
            slider:Set(ns.Get(slider.key))
        end
        self.sound:SetSelected(P:Sound(editing))
        self.border:SetSelected(ns.Get("pulseBorder"))
        self.shadow:SetChecked(ns.Get("pulseShadow"))
        self.items:SetChecked(ns.Get("pulseItems"))
        self.procs:SetChecked(ns.Get("pulseProcs"))
        self.procs:SetUsable(P:CanProcs())
        self.volume:SetChecked(ns.Get("pulseMaster"))
        self.previewButton:SetLabel(L["Preview %s"]:format(Editing()))

        local spells, items = P:Spells(), ns.Get("pulseItems") and P:Items() or {}
        local procs = ns.Get("pulseProcs") and P:CanProcs() and P:Procs() or {}
        local count, ticked = 0, 0
        for _, list in ipairs({ spells, items }) do
            for _, entry in ipairs(list) do
                if entry.on then count = count + 1 end
            end
        end
        for _, entry in ipairs(procs) do
            if entry.on then ticked = ticked + 1 end
        end
        local said = count == 1 and L["1 cooldown pulses when it's ready."] or L["%d cooldowns pulse when they're ready."]:format(count)
        -- With procs ticked too, both in one line, short enough to clear Preview.
        if ticked > 0 then
            if count == 0 then
                said = ticked == 1 and L["1 proc pulses as it lands."] or L["%d procs pulse as they land."]:format(ticked)
            else
                local landing = ticked == 1 and L["1 proc as it lands."] or L["%d procs as they land."]:format(ticked)
                said = count == 1 and L["1 cooldown pulses when ready, %s"]:format(landing)
                    or L["%d cooldowns pulse when ready, %s"]:format(count, landing)
            end
        end
        if count == 0 and ticked == 0 then said = L["Nothing to pulse yet: tick some below."] end
        if elsewhere then
            said = L["Running in %s instead."]:format(elsewhere)
        elseif not on then
            said = L["Off. Tick the box below to start."]
        end
        self.status:SetText(said)
        self:FillList(spells, procs, items)

        -- Where it shows, in words and on the small screen, to scale, as big
        -- as the style picked under Edit.
        local x, y, size = ns.Get("pulseX"), ns.Get("pulseY"), P:Size(editing)
        local parts = {}
        if x ~= 0 then parts[#parts + 1] = Way(x, L["%s right"], L["%s left"]) end
        if y ~= 0 then parts[#parts + 1] = Way(y, L["%s up"], L["%s down"]) end
        if #parts == 2 then
            self.where:SetText(L["Moved %s and %s from the middle."]:format(parts[1], parts[2]))
        elseif #parts == 1 then
            self.where:SetText(L["Moved %s from the middle."]:format(parts[1]))
        else
            self.where:SetText(L["In the middle of your screen."])
        end
        -- As tall as it can be, but no wider than its room.
        local width, height = ScreenSize()
        local scale = math.min(SCREEN_HEIGHT / height, SCREEN_MAX / width)
        self.screen:SetSize(math.floor(width * scale + .5), math.floor(height * scale + .5))
        self.spotBox:SetSize(size * scale, size * scale)
        self.spotBox:ClearAllPoints()
        self.spotBox:SetPoint("CENTER", self.screen, "CENTER", x * scale, y * scale)
        self.spot.size = size * scale
        local icon = P:SampleIcon()
        self.spot.texture:SetTexture(icon)
        self.sample.texture:SetTexture(icon)
        -- The border and shadow as they'd be on the real one, made small.
        P:Dress(self.spot, size * scale)
        P:Dress(self.sample, CLOSE)
    end
end
