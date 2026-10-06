-- Run the addon's real files against a mock game (Tools/Harness.lua) for the
-- pulse itself: its page in the /fecp window, its choices and live preview,
-- its two styles (Quick and Long, each with its own size, time and sound,
-- picked on each row), which cooldowns it lists (every spell you know with
-- a cooldown of its own, from the game data, and your trinkets, potions and
-- bag items, to tick), how it hands the game's duration objects to Cooldown
-- frames of its own without ever reading them, the pulse itself (its fade,
-- growth, queue and sound), moving it, that everything on its page fits, its
-- profiles, and its settings over a reload. The same checks as Forever
-- Enhanced Cooldown Manager's own Cooldown pulse page has, for this addon.
-- Run with: fengari Tools/TestPulse.lua
local H = assert(loadfile("Tools/Harness.lua"))()
local S, Equal, Last, Fire, Note = H.S, H.Equal, H.Last, H.Fire, H.Note

-- Time passing on the pulse while it shows.
local function Run(P, seconds)
    local frame = P.frame
    if S[frame].shown then S[frame].scripts.OnUpdate(frame, seconds) end
end
-- Every pulse showing and waiting played out.
local function Finish(P)
    local frame = P.frame
    while frame and S[frame].shown do S[frame].scripts.OnUpdate(frame, 5) end
end
-- The page's list as text: headers, then each row ticked or not, its name,
-- its cooldown and its style.
local function Rows(page)
    local out = {}
    for _, row in ipairs(page.rows) do
        if S[row].shown then
            if S[row.header].shown then
                out[#out + 1] = S[row.header].text
            else
                out[#out + 1] = (row.check.checked and "[x] " or "[ ] ") .. S[row.name].text .. " " .. S[row.long].text .. " "
                    .. (row.style.selected == "long" and "Long" or "Quick")
            end
        end
    end
    return table.concat(out, " | ")
end
-- A cooldown's row on the page, by its key.
local function RowFor(page, key)
    for _, row in ipairs(page.rows) do
        if row.key == key and S[row].shown then return row end
    end
end
-- Clicks a row's Quick or Long.
local function Switch(row, style)
    row.style.buttons[style == "long" and 2 or 1]:Click()
end
-- The sliders showing, each with its value.
local function Sliders(page)
    local out = {}
    for _, slider in ipairs(page.sliders) do
        if S[slider].shown then out[#out + 1] = S[slider.label].text .. " " .. S[slider.value].text end
    end
    return table.concat(out, ", ")
end
-- One of the pulse's lists in this character's profile, as saved.
local function Profile(list)
    local db = ForeverEnhancedCooldownPulseDB
    local profile = type(db.profiles) == "table" and type(db.chars) == "table" and db.profiles[db.chars[UnitGUID("player")]]
    return profile and profile[list]
end
-- Its keys, in order.
local function Saved(list)
    local keys = {}
    for key in pairs(Profile(list) or {}) do keys[#keys + 1] = tostring(key) end
    table.sort(keys)
    return table.concat(keys, ",")
end
-- What's showing now, and in which style.
local function Now(P)
    local key, _, style = P:Showing()
    return tostring(key) .. " " .. tostring(style)
end
local function Watched(P)
    return (P:Watchers())
end
local SPELLS = "SPELLS | [ ] Barkskin 1 min Quick | [ ] Bash 1 min Quick | [ ] Overpower 5s Quick | [ ] Walk on Air 2 min Quick"

-- On from the start, with Forever Enhanced Cooldown Manager's defaults --------------------------

local ns = H.Start(nil)
local P = ns.Pulse
ns.ShowWindow()
local w = FECPFrame
local page = w.pages.pulse
do
    Equal(tostring(S[page].shown) .. " " .. w.selected .. " " .. tostring(S[w.nav.pulse.fill].shown), "true pulse true",
        "the window opens on the Cooldown pulse page, highlighted in the list")
    Equal(tostring(ns.Get("pulse")) .. " " .. tostring(page.master.checked) .. " " .. tostring(page.master.usable),
        "true true true", "on from the start (the user's pick for this addon), its tick free")
    Equal(S[page.master.text].text, "Pulse an icon when a cooldown is ready", "no Needs testing: the user tested it in game")
    local widths = {}
    for _, slider in ipairs(page.sliders) do widths[#widths + 1] = S[slider.value].width end
    Equal(table.concat(widths, " "), "28 28 36 36 36 36", "room for 160% and 2.5s beside each track")
    Equal(page.edit.selected .. " | " .. Sliders(page), "quick | Size 272, Shows for 1.0s, See-through 80%, Grows to 135%",
        "Edit starts on Quick, at the same defaults: Quick's size and time, then the look both styles share")
    Equal(tostring(S[page.slider.pulseLongSize].shown) .. " " .. tostring(S[page.slider.pulseLongTime].shown), "false false",
        "Long's own hidden meanwhile")
    Equal(ns.Get("pulseLongSize") .. " " .. ns.Get("pulseLongTime") .. " " .. ns.Get("pulseLongSound") .. " | "
        .. table.concat(ns.PULSE_LONG_TIME, " ") .. " | " .. table.concat(ns.PULSE_TIME, " ") .. " | "
        .. table.concat(ns.PULSE_SIZE, " ") .. " | " .. table.concat(ns.PULSE_SEE_THROUGH, " ") .. " | " .. table.concat(ns.PULSE_GROW, " "),
        "400 25 none | 3 50 25 | 3 20 10 | 64 512 272 | 0 90 80 | 100 160 135",
        "Long: bigger, 2.5 s and silent to start, up to 5 s (Quick up to 2 s); the same ranges")
    Equal(page.border.selected .. " " .. page.sound.selected .. " " .. S[page.sound.name].text .. " " .. tostring(page.shadow.checked) .. " "
        .. tostring(page.items.checked) .. " " .. tostring(page.volume.checked), "thin none None true true false",
        "a thin border and a shadow, no sound, trinkets and potions too, at the Sound Effects volume")
    Equal(S[page.previewButton.label].text, "Preview Quick", "Preview says which style it plays")
    Equal(ns.Get("pulseX") .. " " .. ns.Get("pulseY") .. " | " .. S[page.where].text, "0 0 | In the middle of your screen.",
        "in the middle of the screen")
    Equal(S[page.status].text, "Nothing to pulse yet: tick some below.", "on with nothing ticked: the title row says what to do")
    Equal(Watched(P) .. " " .. tostring(P.holder) .. " " .. #H.asked, "0 nil 0", "nothing ticked: nothing watched, nothing asked of the game")
    Equal(Rows(page), SPELLS, "every spell you know with a cooldown of its own, by name, each unticked and Quick, with its cooldown;"
        .. " Moonfire and Attack (none), a passive and a spell not learned left out; no potions you don't carry")
    Equal(S[page.about].text, "tick the ones you want to pulse, then pick Quick or Long for each", "the list says what to do")
    local controls = { page.master, page.previewButton, page.move, page.reset, page.shadow, page.items, page.volume }
    for _, pills in ipairs({ page.edit, page.sound, page.border }) do
        for _, button in ipairs(pills.buttons) do controls[#controls + 1] = button end
    end
    for _, slider in ipairs(page.sliders) do controls[#controls + 1] = slider end
    local plain = 0
    for _, control in ipairs(controls) do
        local hint = Note(control)
        if type(hint) == "string" and #hint > 10 and hint:find("\226\128\148") == nil then plain = plain + 1 end
    end
    Equal(plain .. "/" .. #controls, "21/21", "every control says what it does on hover, no dashes")
    -- See-through: 80% leaves a tenth, and past it, fainter still.
    local shown = {}
    for _, see in ipairs({ 0, 40, 80, 85, 90 }) do
        ns.Set("pulseSeeThrough", see)
        shown[#shown + 1] = string.format("%.3f", P:Opacity())
    end
    Equal(table.concat(shown, " "), "1.000 0.550 0.100 0.070 0.040", "see-through: 80% leaves a tenth, then fainter to 90%")
    -- The checks below were measured at Forever Enhanced Cooldown Manager's first build's look.
    for key, value in pairs({ pulseSize = 320, pulseTime = 7, pulseSeeThrough = 30, pulseGrow = 120 }) do ns.Set(key, value) end
    -- Off and on again from its tick.
    page.master:Click()
    Equal(tostring(ns.Get("pulse")) .. " " .. S[page.status].text, "false Off. Tick the box below to start.", "unticked: off, and how to start")
    page.master:Click()
    Equal(tostring(ns.Get("pulse")), "true", "ticked: on again")
end

-- Ticked: a Cooldown frame of its own for each, handed the game's duration ---------------------

do
    Equal(Note(RowFor(page, "Barkskin").check), "Tick to pulse when Barkskin is ready.", "a row says what ticking does")
    for _, key in ipairs({ "Barkskin", "Bash", "Walk on Air" }) do RowFor(page, key).check:Click() end
    Equal(Saved("pulsePick") .. " | " .. S[page.status].text, "Barkskin,Bash,Walk on Air | 3 cooldowns pulse when they're ready.",
        "three ticked: saved by name in this character's profile, and counted")
    Equal(Rows(page), "SPELLS | [x] Barkskin 1 min Quick | [x] Bash 1 min Quick | [ ] Overpower 5s Quick | [x] Walk on Air 2 min Quick",
        "ticked on the page")
    Equal(Note(RowFor(page, "Overpower").style.buttons[1]), "Once ticked, Overpower pulses Quick. Each style has its own size, time"
        .. " and sound, set under Edit above.", "an unticked row's switch says it pulses once ticked")
    Equal(Note(RowFor(page, "Overpower").style.buttons[2]), "Once ticked, Overpower pulses Quick. Click for Long. Each style has its"
        .. " own size, time and sound, set under Edit above.", "and Long says what clicking it does")
end
local count, watchers = P:Watchers()
do
    Equal(count, 3, "ticked: three cooldowns watched")
    local holder = P.holder
    Equal(tostring(S[holder].parent) .. " " .. S[holder].width .. "x" .. S[holder].height .. " "
        .. tostring(Last(holder, "EnableMouse")) .. " " .. tostring(holder:IsVisible()), "nil 1x1 false true",
        "the watchers sit on a shown frame of their own (not hidden with the interface), one unit square, with no mouse")
    local keys = {}
    for key, watch in pairs(watchers) do
        keys[#keys + 1] = key
        local cd = watch.cooldown
        Equal(S[cd].kind .. " " .. S[cd].template .. " " .. tostring(S[cd].parent == holder) .. " " .. tostring(Last(cd, "SetDrawSwipe"))
            .. tostring(Last(cd, "SetDrawEdge")) .. tostring(Last(cd, "SetDrawBling")) .. " "
            .. tostring(Last(cd, "SetHideCountdownNumbers")) .. " " .. tostring(Last(cd, "EnableMouse")),
            "Cooldown CooldownFrameTemplate true falsefalsefalse true false",
            key .. ": Blizzard's Cooldown frame that draws nothing and takes no mouse")
        Equal(rawequal(Last(cd, "SetCooldownFromDurationObject"), H.SEALED), true, key .. ": handed the game's duration as it is")
    end
    table.sort(keys)
    local seen, ids = {}, {}
    for _, id in ipairs(H.asked) do
        if not seen[id] then seen[id], ids[#ids + 1] = true, id end
    end
    table.sort(ids)
    Equal(table.concat(keys, ",") .. " | " .. table.concat(ids, ","), "Barkskin,Bash,Walk on Air | 5211,22812,1259416",
        "each ticked one asked for, without the global cooldown; Overpower, unticked, never")
    -- Cooldowns change: each is asked again, once, on the next frame.
    H.asked = {}
    Fire("SPELL_UPDATE_COOLDOWN")
    Fire("SPELL_UPDATE_COOLDOWN")
    Equal(#H.asked, 0, "nothing asked until the next frame")
    H.Tick(ns)
    Equal(#H.asked, 3, "then each watched spell once, however many events")
    -- In a fight the same, the duration never read.
    H.lockdown = true
    Fire("SPELL_UPDATE_COOLDOWN")
    H.Tick(ns)
    Equal(#H.asked, 6, "in a fight too")
    -- On hold (like Presence of Mind still up): it hasn't started, so it's
    -- cleared, its duration not even asked for, until it starts. The game
    -- may answer the Clear with its done script: no pulse for that.
    local bark = watchers.Barkskin.cooldown
    local clears = S[bark].clears or 0
    S[bark].last.SetCooldownFromDurationObject = nil
    H.held[22812], H.asked = true, {}
    Fire("SPELL_UPDATE_COOLDOWN")
    H.Tick(ns)
    table.sort(H.asked)
    Equal(table.concat(H.asked, ",") .. " " .. ((S[bark].clears or 0) - clears) .. " "
        .. tostring(Last(bark, "SetCooldownFromDurationObject")) .. " " .. tostring(P:Showing()) .. " " .. tostring(bark.watch ~= nil),
        "5211,1259416 1 nil nil true", "Barkskin's cooldown on hold, in a fight: cleared, never counted from the cast, and no pulse for the clear")
    H.held[22812] = nil
    Fire("SPELL_UPDATE_COOLDOWN")
    H.Tick(ns)
    Equal(rawequal(Last(bark, "SetCooldownFromDurationObject"), H.SEALED), true, "once it starts: handed on")
    H.lockdown = false
end

-- A cooldown done: its icon pulses ---------------------------------------------------------------

local frame
do
    H.clock = H.clock + 5
    local barkskin = watchers.Barkskin.cooldown
    H.Done(barkskin)
    frame = P.frame
    Equal(Now(P), "Barkskin quick", "Barkskin is ready: it pulses, Quick")
    Equal(tostring(S[frame].shown) .. " " .. tostring(S[frame].parent == UIParent) .. " " .. Last(frame, "SetFrameStrata")
        .. " " .. tostring(Last(frame, "EnableMouse")) .. " " .. tostring(Last(frame.art, "EnableMouse")) .. " " .. S[frame].name,
        "true true HIGH false false FECPPulse", "a plain frame of the addon's own, high up, that never takes the mouse")
    local at = S[frame].points[1]
    Equal(S[frame].width .. " " .. table.concat({ at[1], tostring(at[2] == UIParent), at[3], at[4], at[5] }, " "),
        "320 CENTER true CENTER 0 0", "320 big, in the middle of the screen")
    Equal(S[frame.art.texture].texture .. " " .. tostring(S[frame].alpha == 0), "136097 true", "Barkskin's icon, starting unseen")
    local function Look() return string.format("%.3f %.1f", S[frame].alpha, S[frame.art].width) end
    Run(P, .0525)
    Equal(Look(), "0.331 329.2", "fading in fast: half way in after 0.05 s, already growing")
    Run(P, .1575)
    Equal(Look(), "0.663 352.6", "held at full, 30% see-through")
    Run(P, .28)
    Equal(Look(), "0.361 378.2", "fading out, still growing")
    Run(P, .25)
    Equal(tostring(S[frame].shown) .. " " .. tostring(P:Showing()), "false nil", "gone after 0.7 s")
    -- Told twice: once only.
    H.Done(barkskin)
    Equal(tostring(P:Showing()), "nil", "Barkskin done again within 3 seconds is the same one: no second pulse")
    H.clock = H.clock + 3
    H.Done(barkskin)
    Equal(P:Showing(), "Barkskin", "three seconds on, it can pulse again")
    Finish(P)
    -- Just after a loading screen, a login or a reload: no pulses for two seconds.
    Fire("PLAYER_ENTERING_WORLD")
    H.Tick(ns)
    local bash = watchers.Bash.cooldown
    H.clock = H.clock + 1.5
    H.Done(bash)
    Equal(tostring(P:Showing()), "nil", "just after a loading screen: no pulse")
    H.clock = H.clock + 1
    H.Done(bash)
    Equal(P:Showing(), "Bash", "two seconds on, it pulses")
    Finish(P)
    -- With the interface hidden (Alt+Z), none.
    H.clock = H.clock + 5
    S[UIParent].shown = false
    H.Done(watchers["Walk on Air"].cooldown)
    S[UIParent].shown = true
    Equal(tostring(P:Showing()), "nil", "the interface hidden: no pulse")
    Equal(#H.sounds, 0, "no sound chosen, none played")
    -- Hidden mid-pulse with the interface: what showed and waited is let go.
    for _, key in ipairs({ "h1", "h2", "h3" }) do P:Queue(1, key) end
    S[frame].scripts.OnHide(frame)
    local key, waiting = P:Showing()
    Equal(tostring(key) .. " " .. waiting .. " " .. tostring(S[frame].shown), "nil 0 false",
        "the interface hidden mid-pulse: nothing left showing or waiting")
    Equal(tostring(P:Queue(1, "after")) .. " " .. P:Showing(), "true after", "and the next pulse shows as usual")
    Finish(P)
end

-- Several at once: one after another, never a flood --------------------------------------------

do
    local took = {}
    for _, key in ipairs({ "a", "b", "c", "d", "e", "b" }) do took[#took + 1] = tostring(P:Queue(1, key)) end
    Equal(table.concat(took, " "), "true true true true false false",
        "one shows and three wait; any more are let go, and one already waiting isn't added again")
    local order = {}
    for _ = 1, 5 do
        order[#order + 1] = tostring(P:Showing())
        Run(P, 1)
    end
    Equal(table.concat(order, " "), "a b c d nil", "one after another, each in full, never stacked")
    Equal(tostring(P:Queue(1, "a")), "true", "and once played out, room again")
    Finish(P)
end

-- Sound, Master volume, border and shadow ---------------------------------------------------------

do
    page.sound.buttons[3]:Click()
    Equal(ns.Get("pulseSound") .. " " .. S[page.sound.name].text .. " " .. table.concat(H.sounds, ","), "chime Chime 316447 SFX",
        "the next arrow: Chime, and it plays")
    P:Queue(1, "x")
    Equal(#H.sounds .. " " .. H.sounds[#H.sounds], "2 316447 SFX", "and each pulse plays it")
    Finish(P)
    page.sound.buttons[3]:Click()
    Equal(H.sounds[#H.sounds], "316493 SFX", "Bell")
    local heard = #H.sounds
    page.sound.buttons[2]:Click()
    Equal((#H.sounds - heard) .. " " .. H.sounds[#H.sounds] .. " " .. ns.Get("pulseSound"), "1 316493 SFX bell", "its name plays it again, still Bell")
    -- Play at Master volume: the same sound, on the game's Master channel.
    page.volume:Click()
    page.sound.buttons[2]:Click()
    Equal(tostring(ns.Get("pulseMaster")) .. " " .. H.sounds[#H.sounds], "true 316493 Master", "Play at Master volume: played on Master")
    P:Queue(1, "master")
    Equal(H.sounds[#H.sounds], "316493 Master", "a pulse too")
    Finish(P)
    page.volume:Click()
    page.sound.buttons[2]:Click()
    Equal(tostring(ns.Get("pulseMaster")) .. " " .. H.sounds[#H.sounds], "false 316493 SFX", "unticked: Sound Effects again")
    -- Round the list both ways.
    page.sound.buttons[1]:Click()
    page.sound.buttons[1]:Click()
    Equal(ns.Get("pulseSound"), "none", "the back arrow: Chime, then None")
    heard = #H.sounds
    page.sound.buttons[2]:Click()
    Equal(#H.sounds - heard, 0, "None plays nothing")
    page.sound.buttons[1]:Click()
    Equal(ns.Get("pulseSound") .. " " .. S[page.sound.name].text, "anvil Anvil", "back from None: round to the last")
    page.sound.buttons[3]:Click()
    Equal(ns.Get("pulseSound"), "none", "and on from the last: None")
    local missing, kits = {}, {}
    for _, key in ipairs(ns.PULSE_SOUND_KEYS) do
        local kit = P.SOUNDS[key]
        if key ~= "none" and not (kit and ns.PULSE_SOUND_NAMES[key] and not kits[kit]) then missing[#missing + 1] = key end
        if kit then kits[kit] = true end
    end
    Equal(#ns.PULSE_SOUND_KEYS .. " [" .. table.concat(missing, ",") .. "]", "16 []", "None and 15 sounds, each its own, with a name")
    heard = #H.sounds
    P:Queue(1, "y")
    Finish(P)
    Equal(#H.sounds .. " " .. ns.Get("pulseLongSound"), heard .. " none", "None: silent; and all of it Quick's, Long's sound untouched")

    local art = frame.art
    local function Ring(ring) return tostring(S[ring[1]].shown) .. " " .. S[ring[1]].height end
    P:Queue(1, "look")
    Equal(Ring(art.border) .. " " .. Last(art.border[1], "SetColorTexture", 4) .. " | " .. Ring(art.shadow[1]) .. " "
        .. Ring(art.shadow[4]) .. " " .. S[art.shadow[4][1]].points[1][5] .. " " .. Last(art.shadow[1][1], "SetColorTexture", 4),
        "true 2 1 | true 5 true 5 17 0.55", "at 320: a thin dark border 2 thick, then a soft shadow of four rings 5 thick, fading out")
    Finish(P)
    page.border.buttons[3]:Click()
    page.shadow:Click()
    P:Queue(1, "look 2")
    Equal(Ring(art.border) .. " | " .. tostring(S[art.shadow[1][1]].shown), "true 5 | false", "Thick, and Shadow unticked")
    Finish(P)
    page.border.buttons[1]:Click()
    P:Queue(1, "look 3")
    Equal(tostring(S[art.border[1]].shown), "false", "None: no border")
    Finish(P)
    page.border.buttons[2]:Click()
    page.shadow:Click()
    Equal(ns.Get("pulseBorder") .. " " .. tostring(ns.Get("pulseShadow")), "thin true", "back to thin with a shadow")
end

-- Two styles: Quick or Long, picked on each row ------------------------------------------------

do
    local bark = RowFor(page, "Barkskin")
    Equal(S[bark.style.buttons[1].label].text .. " " .. S[bark.style.buttons[2].label].text .. " " .. bark.style.selected .. " "
        .. S[bark.style].width .. " " .. table.concat(S[bark.style].points[1], " "), "Quick Long quick 96 RIGHT -4 0",
        "each row has a small Quick | Long switch on its right, on Quick to start")
    Switch(bark, "long")
    Equal(Note(bark.style.buttons[1]):sub(1, 39), "Barkskin pulses Long. Click for Quick. ", "switched: says Long, and Quick goes back")
    Equal(Saved("pulseStyle") .. " " .. Profile("pulseStyle").Barkskin .. " | " .. Rows(page),
        "Barkskin long | SPELLS | [x] Barkskin 1 min Long | [x] Bash 1 min Quick | [ ] Overpower 5s Quick | [x] Walk on Air 2 min Quick",
        "switched to Long: saved, the rest stay Quick")
    -- Its pulse: Long's own size, time and sound.
    H.clock = H.clock + 5
    local heard = #H.sounds
    H.Done(watchers.Barkskin.cooldown)
    Equal(Now(P) .. " " .. S[frame].width .. " " .. (#H.sounds - heard), "Barkskin long 400 0",
        "Barkskin pulses Long: 400 big, with Long's sound (none yet)")
    Run(P, .1875)
    Equal(string.format("%.3f %.0f", S[frame].alpha, S[frame.art].width), "0.331 412",
        "fading in over Long's time: half way in after 0.19 s, growing as Quick's do")
    Run(P, 2.2)
    Equal(tostring(S[frame].shown), "true", "still there at 2.4 s")
    Run(P, .2)
    Equal(Now(P), "nil nil", "gone after 2.5 s")
    H.Done(watchers.Bash.cooldown)
    Equal(Now(P) .. " " .. S[frame].width, "Bash quick 320", "Bash still pulses Quick, 320 big")
    Finish(P)

    -- Edit: Long. The page shows and sets Long's own.
    page.edit.buttons[2]:Click()
    Equal(P.editing .. " " .. page.edit.selected .. " | " .. Sliders(page) .. " | " .. page.sound.selected .. " | "
        .. S[page.previewButton.label].text, "long long | Size 400, Shows for 2.5s, See-through 30%, Grows to 120% | none | Preview Long",
        "Edit: Long. Long's own size, time and sound, then the shared look")
    page.slider.pulseLongSize:Choose(448)
    page.slider.pulseLongTime:Choose(40)
    page.sound.buttons[3]:Click()
    page.sound.buttons[3]:Click()
    Equal(ns.Get("pulseLongSize") .. " " .. ns.Get("pulseLongTime") .. " " .. ns.Get("pulseLongSound") .. " " .. H.sounds[#H.sounds] .. " | "
        .. ns.Get("pulseSize") .. " " .. ns.Get("pulseTime") .. " " .. ns.Get("pulseSound"), "448 40 bell 316493 SFX | 320 7 none",
        "Long's size, time and sound set (Bell played as picked); Quick's unchanged")
    Equal(Note(page.sound.buttons[1]), "A sound with each Long pulse. The arrows step through them and play each one; click its name to"
        .. " hear it again.", "the sound says which style it's for")
    heard = #H.sounds
    page.previewButton:Click()
    Equal(Now(P) .. " " .. S[frame].width .. " " .. (#H.sounds - heard) .. " " .. H.sounds[#H.sounds] .. " " .. Last(frame, "SetFrameStrata"),
        "preview long 448 1 316493 SFX TOOLTIP", "Preview: a Long pulse, its size and bell, over the window")
    Run(P, 3.9)
    Equal(tostring(S[frame].shown), "true", "for Long's 4 s")
    Finish(P)
    -- Edit: Quick again, and Preview plays Quick.
    page.edit.buttons[1]:Click()
    page.previewButton:Click()
    Equal(P.editing .. " " .. Now(P) .. " " .. S[frame].width, "quick preview quick 320", "Edit: Quick. Preview plays Quick")
    -- Edit switched while a preview shows: the new Preview takes its place at once.
    page.edit.buttons[2]:Click()
    page.previewButton:Click()
    Equal(Now(P) .. " " .. S[frame].width .. " " .. select(2, P:Showing()), "preview long 448 0",
        "Preview Quick showing, Edit: Long, Preview: Long at once, nothing left waiting")
    page.edit.buttons[1]:Click()
    page.previewButton:Click()
    Equal(tostring(P:Preview()) .. " " .. Now(P), "false preview quick", "the same style again: the one showing carries on")
    Finish(P)
    Switch(RowFor(page, "Barkskin"), "quick")
    Equal(tostring(Profile("pulseStyle").Barkskin) .. " " .. RowFor(page, "Barkskin").style.selected, "nil quick",
        "back to Quick: nothing saved")
end

-- Trinkets and potions -------------------------------------------------------------------------------

do
    H.worn[13] = 9999
    H.counts[118] = 2
    Fire("PLAYER_EQUIPMENT_CHANGED")
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    Equal(tostring(watchers["slot:13"]) .. " " .. tostring(watchers["family:healing"]) .. " | " .. Rows(page),
        "nil nil | " .. SPELLS:gsub("%[ %] Barkskin", "[x] Barkskin"):gsub("%[ %] Bash", "[x] Bash"):gsub("%[ %] Walk", "[x] Walk")
        .. " | ITEMS | [ ] Trinket 1: Lucky Charm trinket Quick | [ ] Healing Potions in your bags Quick",
        "a trinket with a use put on, and a healing potion carried: listed under Items at once, unticked, so not watched")
    RowFor(page, "slot:13").check:Click()
    RowFor(page, "family:healing").check:Click()
    Equal(tostring(watchers["slot:13"] ~= nil) .. " " .. tostring(watchers["family:healing"] ~= nil) .. " " .. Saved("pulsePick"),
        "true true Barkskin,Bash,Walk on Air,family:healing,slot:13", "ticked: watched, saved with the spells")
    Equal(S[page.status].text, "5 cooldowns pulse when they're ready.", "counted")
    -- Plain numbers: a cooldown running is handed on; one only as long as
    -- the global cooldown is cleared, never counted, and its clear no pulse.
    H.trinketCooldowns[13], H.itemCooldown = { 50, 120, 1 }, { 100, 1.5, 1 }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(ns)
    local trinketCd, potionCd = watchers["slot:13"].cooldown, watchers["family:healing"].cooldown
    Equal(tostring(Last(trinketCd, "SetCooldown", 1)) .. " " .. tostring(Last(trinketCd, "SetCooldown", 2)), "50 120",
        "the trinket's cooldown handed on")
    Equal(tostring(Last(potionCd, "SetCooldown")) .. " " .. tostring((S[potionCd].clears or 0) > 0) .. " " .. tostring(P:Showing()),
        "nil true nil", "the global cooldown alone: cleared, and no pulse for it")
    -- Hidden in a fight: the watcher keeps what it had.
    H.lockdown = true
    H.trinketCooldowns[13] = { H.SECRET, H.SECRET, 1 }
    S[trinketCd].last.SetCooldown = nil
    local clears = S[trinketCd].clears or 0
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(ns)
    Equal(tostring(Last(trinketCd, "SetCooldown")) .. " " .. ((S[trinketCd].clears or 0) - clears), "nil 0",
        "secret numbers: left as they were")
    H.lockdown = false
    H.trinketCooldowns[13] = { 0, 0, 1 }
    H.clock = H.clock + 5
    H.Done(potionCd)
    Equal(P:Showing() .. " " .. S[frame.art.texture].texture, "family:healing 888", "a potion ready pulses its own icon")
    Finish(P)
    -- An item can be Long too.
    Switch(RowFor(page, "family:healing"), "long")
    H.clock = H.clock + 5
    H.Done(potionCd)
    Equal(Now(P) .. " " .. Profile("pulseStyle")["family:healing"], "family:healing long long", "Healing Potions switched to Long: pulse Long")
    Finish(P)
    -- On hold (not enabled: 0, or false as C_Item says it): not counted.
    for _, enable in ipairs({ 0, false }) do
        H.itemCooldown = { 100, 120, enable }
        S[potionCd].last.SetCooldown = nil
        Fire("BAG_UPDATE_COOLDOWN")
        H.Tick(ns)
        Equal(tostring(Last(potionCd, "SetCooldown")), "nil", "a cooldown on hold (" .. tostring(enable) .. "): not counted")
    end
    H.itemCooldown = { 100, 120, true }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(ns)
    Equal(tostring(Last(potionCd, "SetCooldown", 2)), "120", "enabled (true from C_Item): counted")
    -- Your last one drunk: none left to drink, so no pulse, and the row says so.
    H.counts[118] = 0
    H.clock = H.clock + 5
    H.Done(potionCd)
    Equal(tostring(P:Showing()), "nil", "a potion you carry none of now: no pulse")
    w:Refresh()
    Equal(Rows(page):match("ITEMS.*"), "ITEMS | [x] Trinket 1: Lucky Charm trinket Quick | [x] Healing Potions none left Long",
        "ticked, it stays listed, saying none are left")
    -- Healing and Mana Potions share one cooldown: one pulse, not two.
    H.counts[118], H.counts[2455] = 1, 1
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    RowFor(page, "family:mana").check:Click()
    H.itemCooldown = { 200, 120, true }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(ns)
    H.clock = H.clock + 5
    H.Done(potionCd)
    H.Done(watchers["family:mana"].cooldown)
    local key, waiting, style = P:Showing()
    Equal(key .. " " .. waiting .. " " .. style, "cd:200:120 0 long", "potions sharing a cooldown: one pulse, the second let go")
    Finish(P)
    Switch(RowFor(page, "family:healing"), "quick")
    RowFor(page, "family:mana").check:Click()
    Equal(tostring(watchers["family:mana"]) .. " " .. Saved("pulseStyle"), "nil ", "Mana Potions unticked: not watched; nothing Long")
    -- A bag item with a use, straight from your bags.
    H.bag[1] = { itemID = 6948, hyperlink = "|cffffffff|Hitem:6948::|h[Hearthstone]|h|r", iconFileID = 134414 }
    H.counts[6948] = 1
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    Equal(Rows(page):match("ITEMS.*"), "ITEMS | [x] Trinket 1: Lucky Charm trinket Quick | [x] Healing Potions in your bags Quick"
        .. " | [ ] Mana Potions in your bags Quick | [ ] Hearthstone in your bags Quick",
        "potions you carry and bag items with a use, listed from your bags, unticked")
    RowFor(page, "item:6948").check:Click()
    Equal(tostring(watchers["item:6948"] ~= nil) .. " " .. tostring(Profile("pulsePick")["item:6948"]), "true true", "ticked: watched")
    -- Run out of it: gone. Carrying it again, with /fecp shut: read again, watched again.
    H.bag[1], H.counts[6948] = nil, 0
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    Equal(tostring(watchers["item:6948"]), "nil", "none left: not watched")
    w:Hide()
    H.bag[1], H.counts[6948] = { itemID = 6948, hyperlink = "|cffffffff|Hitem:6948::|h[Hearthstone]|h|r", iconFileID = 134414 }, 1
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    Equal(tostring(watchers["item:6948"] ~= nil), "true", "back in your bags: watched again, the window shut")
    w:Show()
    RowFor(page, "item:6948").check:Click()
    H.bag[1], H.counts[6948] = nil, 0
    -- Food and recipes have a use but never a cooldown: not listed.
    H.bag[1] = { itemID = 117, hyperlink = "|cffffffff|Hitem:117::|h[Tough Jerky]|h|r", iconFileID = 1 }
    H.bag[2] = { itemID = 2698, hyperlink = "|cffffffff|Hitem:2698::|h[Recipe]|h|r", iconFileID = 1 }
    H.counts[117], H.counts[2698] = 1, 1
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    Equal(tostring((RowFor(page, "item:117"))) .. " " .. tostring((RowFor(page, "item:2698"))), "nil nil", "food and recipes: not listed")
    H.bag[1], H.bag[2] = nil, nil
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    page.items:Click()
    Equal(tostring(watchers["slot:13"]) .. " " .. tostring(watchers["family:healing"]) .. " | " .. Rows(page),
        "nil nil | SPELLS | [x] Barkskin 1 min Quick | [x] Bash 1 min Quick | [ ] Overpower 5s Quick | [x] Walk on Air 2 min Quick",
        "Trinkets and potions too unticked: spells only")
    page.items:Click()
    Equal(Watched(P), 5, "ticked again: all five watched")
end

-- Ticking and unticking ------------------------------------------------------------------------------

do
    local bashRow = RowFor(page, "Bash")
    local reach = Last(bashRow.check, "SetHitRectInsets", 2)
    Equal(reach .. " " .. tostring(4 + 16 - reach < S[bashRow].width - 4 - S[bashRow.style].width), "-448 true",
        "the whole row clicks its tick, up to its switch")
    Equal(Note(bashRow.check), "Untick to leave Bash out.", "and says what unticking does")
    local old = watchers.Bash.cooldown
    bashRow.check:Click()
    Equal(tostring(Profile("pulsePick").Bash) .. " " .. tostring(watchers.Bash) .. " " .. tostring(old.watch) .. " "
        .. tostring(bashRow.check.checked) .. " " .. S[bashRow.style].alpha, "nil nil nil false 1",
        "unticked: forgotten, its watcher let go, its switch still full strength")
    Equal(S[page.status].text, "4 cooldowns pulse when they're ready.", "one fewer")
    H.clock = H.clock + 5
    H.Done(old)
    Equal(tostring(P:Showing()), "nil", "a watcher let go says nothing")
    bashRow.check:Click()
    Equal(tostring(Profile("pulsePick").Bash) .. " " .. tostring(watchers.Bash ~= nil), "true true", "ticked again: back")
end

-- Moving it ---------------------------------------------------------------------------------------------

do
    page.move:Click()
    local mover = P.mover
    Equal(tostring(P:Moving()) .. " " .. tostring(S[w].shown), "true false", "Move: the box shows and the window steps aside")
    Equal(S[mover].width .. " " .. Last(mover, "SetFrameStrata") .. " " .. tostring(Last(mover, "EnableMouse")) .. " "
        .. tostring(Last(mover, "SetClampedToScreen")) .. " " .. tostring(Last(mover, "RegisterForDrag")) .. " " .. S[mover].name,
        "320 DIALOG true true LeftButton FECPPulseMover", "Quick's size, draggable, kept on the screen")
    Equal(S[mover.icon].texture .. " " .. S[mover.title].text .. " " .. S[mover.done.label].text, "136097 COOLDOWN PULSE Done",
        "your first cooldown's icon in it, named, with Done")
    -- Dragged so its middle is 100 right of the screen's and 50 down (the screen's middle is at 500, 400).
    S[mover].cx, S[mover].cy = 600, 350
    S[mover].scripts.OnDragStart(mover)
    S[mover].scripts.OnDragStop(mover)
    local at = S[mover].points[1]
    Equal(ns.Get("pulseX") .. " " .. ns.Get("pulseY") .. " | " .. table.concat({ at[1], tostring(at[2] == UIParent), at[3], at[4], at[5] }, " "),
        "100 -50 | CENTER true CENTER 100 -50", "let go: saved from the middle of the screen")
    Equal(tostring(Last(mover, "SetUserPlaced")) .. " " .. tostring(mover.dragging), "false nil", "kept out of the game's own layout")
    P:Queue(1, "moved")
    Equal(S[frame].points[1][4] .. " " .. S[frame].points[1][5], "100 -50", "the pulse shows there")
    Finish(P)
    P:Queue(1, "moved long", nil, "long")
    Equal(S[frame].width .. " " .. S[frame].points[1][4] .. " " .. S[frame].points[1][5], "448 100 -50", "a Long pulse too")
    Finish(P)
    mover.done:Click()
    Equal(tostring(P:Moving()) .. " " .. tostring(S[w].shown) .. " " .. w.selected, "false true pulse",
        "Done: the box goes, and the window comes back on this page")
    page.edit.buttons[2]:Click()
    page.move:Click()
    Equal(S[mover].width, 448, "with Long picked under Edit: a box Long's size")
    mover.done:Click()
    page.edit.buttons[1]:Click()
    page.move:Click()
    S[mover].scripts.OnMouseUp(mover, "LeftButton")
    Equal(tostring(P:Moving()), "true", "a left click is only a drag")
    S[mover].scripts.OnMouseUp(mover, "RightButton")
    Equal(tostring(P:Moving()) .. " " .. tostring(S[w].shown) .. " " .. tostring(ns.Get("pulseX")), "false true 100",
        "a right-click finishes too, where it was put")
    Equal(S[page.where].text, "Moved 100 right and 50 down from the middle.", "the page says where, in plain words")
    local spot = S[page.spotBox].points[1]
    Equal(string.format("%.1f %.1f %.1f", S[page.spotBox].width, spot[4], spot[5]), "27.5 8.6 -4.3",
        "the small screen shows it there, to scale")
    page.reset:Click()
    Equal(ns.Get("pulseX") .. " " .. ns.Get("pulseY") .. " | " .. S[page.where].text .. " | " .. S[w.note].text,
        "0 0 | In the middle of your screen. | The pulse is back in the middle of your screen.", "Reset: the middle again")
    -- Not in a fight, and a fight ends a move.
    H.lockdown = true
    page.move:Click()
    Equal(tostring(P:Moving()) .. " " .. S[w.note].text, "false Finish the fight first, then move it.", "in a fight: not now, and why")
    H.lockdown = false
    page.move:Click()
    H.Combat(true)
    Equal(tostring(P:Moving()) .. " " .. ns.Get("pulseX"), "false 0", "a fight starting puts the box away")
    H.Combat(false)
    -- Mid-drag: where it is now is kept (50 left of the middle and 100 up).
    page.move:Click()
    S[mover].cx, S[mover].cy = 450, 500
    S[mover].scripts.OnDragStart(mover)
    S[mover].last.SetUserPlaced = nil
    H.Combat(true)
    Equal(tostring(P:Moving()) .. " " .. ns.Get("pulseX") .. " " .. ns.Get("pulseY") .. " " .. tostring(Last(mover, "SetUserPlaced"))
        .. " " .. tostring(mover.dragging), "false -50 100 false nil", "a fight starting mid-drag: the box goes, where it was put kept")
    H.Combat(false)
    ns.ShowWindow()
    w:Select("pulse")
    Equal(S[page.where].text, "Moved 50 left and 100 up from the middle.", "the page says so")
    page.reset:Click()
    ns.Set("pulseY", -40)
    w:Refresh()
    Equal(S[page.where].text, "Moved 40 down from the middle.", "one way only")
    page.reset:Click()
end

-- The live preview, and Preview while it's off ------------------------------------------------------

do
    Equal(S[page.screen].width .. "x" .. S[page.screen].height .. " " .. S[page.spotBox].width, "117x66 27.5",
        "a small screen the shape of yours, the pulse on it to scale")
    S[UIParent].width = 2732
    w:Refresh()
    Equal(S[page.screen].width .. "x" .. S[page.screen].height .. " " .. string.format("%.1f", S[page.spotBox].width), "172x48 20.1",
        "a very wide screen: no wider than its room, the pulse still to scale")
    S[UIParent].width = 1366
    w:Refresh()
    Equal(S[page.sample.texture].texture .. " " .. S[page.spot.texture].texture, "136097 136097", "your first cooldown's icon")
    local tray = page.tray
    S[tray].scripts.OnUpdate(tray, .0525)
    Equal(string.format("%.3f %.1f %.2f", S[page.sample].alpha, S[page.sample].width, S[page.spot].width), "0.331 41.2 28.29",
        "both pulse as the real one does")
    S[tray].scripts.OnUpdate(tray, 1)
    Equal(S[page.sample].alpha, 0, "then rest a moment before the next")
    page.master:Click()
    Equal(Watched(P) .. " " .. tostring(watchers.Barkskin), "0 nil", "off: nothing watched")
    page.previewButton:Click()
    Equal(P:Showing() .. " " .. Last(frame, "SetFrameStrata") .. " " .. S[frame.art.texture].texture, "preview TOOLTIP 136097",
        "Preview: a pulse now, over the window, with your first cooldown's icon, even while it's off")
    Finish(P)
    page.master:Click()
    Equal(Watched(P), 5, "on again: all five watched")
end

-- Everything fits: each label clear of its control, nothing on anything else ------------------------

do
    local Wide = H.Wide
    -- Every piece of the options showing: inside them, and none on another.
    local function Laid()
        local left, top, right, bottom = H.Rect(page.options)
        local rects, outside, overlaps = {}, {}, {}
        for _, obj in ipairs(H.objects) do
            if S[obj].parent == page.options and S[obj].shown then
                local l, t, r, b = H.Rect(obj)
                local name = S[obj].text or (obj.text and S[obj.text].text) or (obj.label and S[obj.label].text) or S[obj].kind
                if l < left or t < top or r > right or b > bottom then outside[#outside + 1] = name end
                for _, other in ipairs(rects) do
                    if l < other[3] and other[1] < r and t < other[4] and other[2] < b then overlaps[#overlaps + 1] = name .. " on " .. other[5] end
                end
                rects[#rects + 1] = { l, t, r, b, name }
            end
        end
        return #rects .. " | " .. table.concat(outside, ", ") .. " | " .. table.concat(overlaps, ", ")
    end
    for i, style in ipairs({ "Quick", "Long" }) do
        page.edit.buttons[i]:Click()
        Equal(Laid(), "14 |  | ", style .. " under Edit: every tick, label, choice and slider inside the options, none on another")
    end
    page.edit.buttons[1]:Click()
    Equal(H.Problems2D(page), "", "every piece of the page inside it, none on another")
    -- Each slider's label clear of its track, and each value clear of the thumb.
    local limits = { pulseSize = ns.PULSE_SIZE, pulseLongSize = ns.PULSE_LONG_SIZE, pulseTime = ns.PULSE_TIME,
        pulseLongTime = ns.PULSE_LONG_TIME, pulseSeeThrough = ns.PULSE_SEE_THROUGH, pulseGrow = ns.PULSE_GROW }
    local tight = {}
    for _, slider in ipairs(page.sliders) do
        local track = S[slider.track].points
        local label = S[slider.label]
        if Wide(label.text, label.template) + 5 + 3 > track[1][2] then tight[#tight + 1] = label.text end
        for _, value in ipairs({ limits[slider.key][1], limits[slider.key][2] }) do
            slider:Set(value)
            local shown = S[slider.value]
            if Wide(shown.text, shown.template) + 5 > -track[2][2] or Wide(shown.text, shown.template) > shown.width then
                tight[#tight + 1] = slider.key .. " at " .. shown.text
            end
        end
        slider:Set(ns.Get(slider.key))
    end
    for _, pills in ipairs({ page.edit, page.sound, page.border }) do
        local label = S[pills.label]
        if Wide(label.text, label.template) + 6 > S[pills].points[1][2] - label.points[1][2] then tight[#tight + 1] = label.text end
        for _, button in ipairs(pills.buttons) do
            local name = S[button.label]
            if Wide(name.text, name.template) + 4 > S[button].width then tight[#tight + 1] = name.text end
        end
    end
    local row = RowFor(page, "family:healing")
    for _, text in ipairs({ "in your bags", "none left", "trinket", "1.5 min", "2 hours" }) do
        if Wide(text, S[row.long].template) > S[row.long].width then tight[#tight + 1] = text end
    end
    local room = S[page.sound.play].width
    for _, key in ipairs(ns.PULSE_SOUND_KEYS) do
        if Wide(ns.PULSE_SOUND_NAMES[key], S[page.sound.name].template) + 4 > room then tight[#tight + 1] = ns.PULSE_SOUND_NAMES[key] end
    end
    Equal(table.concat(tight, ", "), "", "every label beside its control with room to spare, every value and name inside its own")
    -- The title row: the longest it says, clear of Preview.
    local title = S[page.title]
    local from = 16 + Wide(title.text, title.template) + 10
    local longest = 0
    for _, said in ipairs({ "Off. Tick the box below to start.", "Nothing to pulse yet: tick some below.",
        "12 cooldowns pulse when they're ready.", "Running in Forever Enhanced Cooldown Manager instead." }) do
        longest = math.max(longest, Wide(said, S[page.status].template))
    end
    local previewLeft = 638 - 16 - S[page.previewButton].width
    Equal(tostring(from + longest + 8 <= previewLeft), "true", "the title row, saying the most it can, clear of Preview")
    -- Our own plain words, and no long dashes.
    local found = {}
    for _, obj in ipairs(H.objects) do
        local text = S[obj].kind == "FontString" and S[obj].text
        if type(text) == "string" and H.Inside(obj, w) and text:find("\226\128\148") then found[#found + 1] = text end
    end
    Equal(table.concat(found, ", "), "", "no long dashes in the window")
end

-- The game data: each spell's base cooldown --------------------------------------------------------------

do
    Equal(P:BaseCooldown(22812) .. " " .. P:BaseCooldown(871) .. " " .. P:BaseCooldown(1856) .. " " .. P:BaseCooldown(8921) .. " "
        .. P:BaseCooldown(6603) .. " " .. P:BaseCooldown(17), "60 900 300 0 0 4",
        "from the game data: Barkskin, Shield Wall, Vanish, Power Word: Shield; Moonfire and Attack have none")
    Equal(P:BaseCooldown(999999), 0, "a spell the data doesn't cover, with no way to ask: none")
    _G.GetSpellBaseCooldown = function(id)
        if id == 999999 then return 45000, 1500 end
        if id == 999998 then return H.SECRET end
        return 99000
    end
    Equal(string.format("%g %g %g", P:BaseCooldown(999999), P:BaseCooldown(999998), P:BaseCooldown(8921)), "45 0 0",
        "asked of the game only for a spell the data doesn't cover, and only a plain answer counts")
    _G.GetSpellBaseCooldown = nil
    Equal(ns.PulseLong(4) .. ", " .. ns.PulseLong(45) .. ", " .. ns.PulseLong(90) .. ", " .. ns.PulseLong(180) .. ", "
        .. ns.PulseLong(3600), "4s, 45s, 1.5 min, 3 min, 1 hour", "a cooldown in plain words")
end

-- Ticks follow the profile ---------------------------------------------------------------------

do
    local own = ns.ProfileName()
    Equal(own .. " | " .. tostring(ForeverEnhancedCooldownPulseDB.pulsePick) .. " " .. Saved("pulsePick"),
        "Zriel (Druid) - Zephras | nil Barkskin,Bash,Walk on Air,family:healing,slot:13",
        "each character its own profile at first, its ticks saved in it")
    ns.SetPulseStyle("Bash", "long")
    local made, said = ns.NewProfile("Empty")
    w:Refresh()
    Equal(tostring(made) .. " " .. said .. " " .. Watched(P) .. " [" .. Saved("pulsePick") .. "] " .. RowFor(page, "Bash").style.selected,
        "true Made Empty, and switched to it. 0 [] quick", "a new, empty profile: nothing ticked, all Quick, nothing watched")
    ns.UseProfile(own)
    w:Refresh()
    Equal(Watched(P) .. " " .. RowFor(page, "Bash").style.selected, "5 long", "back on your own: your ticks and Long again")
    ns.CopyProfile("Copied")
    Equal(ns.ProfileName() .. " " .. Watched(P) .. " " .. Saved("pulsePick") .. " " .. Saved("pulseStyle"),
        "Copied 5 Barkskin,Bash,Walk on Air,family:healing,slot:13 Bash", "a copy takes your ticks and Long")
    ns.SetPulsePick("Barkskin", false)
    ns.UseProfile(own)
    Equal(tostring(Profile("pulsePick").Barkskin) .. " " .. Watched(P), "true 5", "unticking in the copy leaves your own alone")
    Equal(select(2, ns.RenameProfile("Mine")) .. " " .. ns.ProfileName() .. " " .. Watched(P), "Renamed to Mine. Mine 5", "renamed, ticks kept")
    ns.RenameProfile(own)
    -- In a fight, profiles never change.
    H.lockdown = true
    Equal(select(2, ns.UseProfile("Copied")) .. " " .. ns.ProfileName(), "Profiles can't change in combat. " .. own, "not in a fight")
    H.lockdown = false
    -- Another character: its own profile; then everyone on one.
    local saved = ForeverEnhancedCooldownPulseDB
    H.character = { guid = "Player-1-0002", name = "Mirel", surname = "Ashdown", realm = "Zephras", class = "Mage", classFile = "MAGE" }
    local alt = H.Start(saved)
    Equal(alt.ProfileName() .. " | " .. Saved("pulsePick"), "Mirel Ashdown (Mage) - Zephras | ", "another character: its own, empty, named with its surname")
    alt.UseProfile(own)
    alt.UseOnAll()
    Equal(tostring(alt.OnAll(own)) .. " " .. tostring(saved.everyone), "true " .. own, "one profile on all characters")
    H.character = { guid = "Player-1-0003", name = "Newt", realm = "Zephras", class = "Priest", classFile = "PRIEST" }
    local fresh = H.Start(saved)
    Equal(fresh.ProfileName(), own, "a new character loads it too")
    -- Delete: asks first in the window (ProfileMenu.lua); here, the rules.
    local ok, why = fresh.DeleteProfile(own)
    Equal(tostring(ok) .. " " .. why, "true Deleted " .. own .. ". You're now on Newt (Priest) - Zephras.",
        "deleting the profile you're on leaves you on a new one of your own")
    Equal(tostring(saved.everyone) .. " " .. tostring(saved.profiles[own]), "nil nil", "gone for everyone")
    for _, name in ipairs({ "Copied", "Empty" }) do fresh.DeleteProfile(name) end
    H.character = { guid = "Player-1-0001", name = "Zriel", realm = "Zephras", class = "Druid", classFile = "DRUID" }
    Equal(H.Problems(), "", "no errors from profiles")
end

-- Kept over a reload; anything wrong falls back ---------------------------------------------------------

do
    local first = H.Start(nil)
    first.ShowWindow()
    local fp = FECPFrame.pages.pulse
    RowFor(fp, "Barkskin").check:Click()
    RowFor(fp, "Bash").check:Click()
    first.SetPulseStyle("Barkskin", "long")
    fp.sound.buttons[3]:Click()
    fp.slider.pulseSize:Choose(400)
    first.Set("pulseLongSize", 448)
    fp.master:Click()
    fp.master:Click()
    local saved = ForeverEnhancedCooldownPulseDB
    local again = H.Start(saved)
    local n, kept = again.Pulse:Watchers()
    Equal(tostring(again.Get("pulse")) .. " " .. again.Get("pulseSize") .. " " .. again.Get("pulseSound") .. " " .. again.Get("pulseLongSize")
        .. " | " .. n .. " " .. tostring(kept.Barkskin ~= nil) .. " " .. again.Pulse.editing .. " " .. again.Pulse:StyleOf("Barkskin"),
        "true 400 chime 448 | 2 true quick long", "on, its choices and what's ticked, all kept; Edit back on Quick")
    -- Just logged in: quiet, then it works, in its style.
    H.Environment()
    local quiet = H.Load(saved)
    H.Tick(quiet)
    local _, list = quiet.Pulse:Watchers()
    H.Done(list.Barkskin.cooldown)
    Equal(tostring(quiet.Pulse:Showing()), "nil", "no pulse as you log in")
    H.clock = H.clock + 5
    H.Done(list.Barkskin.cooldown)
    Equal(Now(quiet.Pulse) .. " " .. S[quiet.Pulse.frame].width, "Barkskin long 448", "after that, it pulses, still Long")

    local bad = H.Start({ pulse = "yes", pulseSize = 9999, pulseTime = 1, pulseSeeThrough = -5, pulseGrow = 300, pulseBorder = "pink",
        pulseSound = 3, pulseLongSize = 30, pulseLongTime = 51, pulseLongSound = "horn", pulseX = 1e9, pulseY = 0 / 0,
        pulseShadow = "no", pulseItems = 1, pulseMaster = "on", accent = "pink", minimap = 0, minimapAngle = 400, helpSeen = "yes",
        profiles = { [5] = {}, Broken = "x", Fine = { pulsePick = { Barkskin = true, Bash = "yes", [3] = true, [""] = true },
            pulseStyle = { Barkskin = "long", Bash = "LONG", [5] = "long", Moonfire = true } } },
        chars = { [7] = "Fine", ["Player-1-0001"] = "Fine" }, everyone = "Gone" })
    Equal(tostring(bad.Get("pulse")) .. " " .. bad.Get("pulseSize") .. " " .. bad.Get("pulseTime") .. " " .. bad.Get("pulseSeeThrough")
        .. " " .. bad.Get("pulseGrow") .. " " .. bad.Get("pulseBorder") .. " " .. bad.Get("pulseSound") .. " | " .. bad.Get("pulseLongSize")
        .. " " .. bad.Get("pulseLongTime") .. " " .. bad.Get("pulseLongSound") .. " | " .. bad.Get("pulseX") .. " " .. bad.Get("pulseY") .. " "
        .. tostring(bad.Get("pulseShadow")) .. " " .. tostring(bad.Get("pulseItems")) .. " " .. tostring(bad.Get("pulseMaster")) .. " | "
        .. bad.Get("accent") .. " " .. tostring(bad.Get("minimap")) .. " " .. bad.Get("minimapAngle"),
        "true 272 10 80 135 thin none | 400 25 none | 0 0 true true false | purple true 285",
        "anything wrong in the saved settings reads as the default")
    local db = ForeverEnhancedCooldownPulseDB
    local names = {}
    for name in pairs(db.profiles) do names[#names + 1] = tostring(name) end
    table.sort(names)
    Equal(table.concat(names, ",") .. " | " .. tostring(db.chars[7]) .. " " .. tostring(db.everyone) .. " " .. tostring(db.helpSeen) .. " | "
        .. Saved("pulsePick") .. " | " .. Saved("pulseStyle"), "Fine | nil nil nil | Barkskin | Barkskin",
        "broken profiles and characters dropped, only proper entries kept: spells by name, Long only as long")
    Equal(H.Problems(), "", "no errors from a reload")
end

-- A new spell learned: listed on the next frame, unticked ------------------------------------------

do
    H.Environment()
    H.Book({ { name = "General", items = { { name = "Attack", spellID = 6603 } } },
        { name = "Holy", items = { { name = "Smite", subName = "Rank 1", spellID = 585, iconID = 135924 } } } })
    local learner = H.Load(nil)
    local LP = learner.Pulse
    H.Tick(learner)
    H.clock = H.clock + 5
    learner.ShowWindow()
    local lp = FECPFrame.pages.pulse
    Equal(Rows(lp) .. " | " .. tostring(S[lp.empty].shown) .. " " .. S[lp.empty].text .. " | " .. S[lp.status].text,
        " | true None of your spells has a cooldown of its own yet. New ones show here as you learn them."
        .. " | Nothing to pulse yet: tick some below.", "no cooldowns yet: the list says new ones show as you learn them")
    table.insert(H.book[2].items, { name = "Power Word: Shield", subName = "Rank 1", spellID = 17, iconID = 135940 })
    Fire("SPELLS_CHANGED")
    Equal(Rows(lp):find("Power Word", 1, true), nil, "not until the next frame")
    H.Tick(learner)
    Equal(Rows(lp) .. " | " .. tostring(S[lp.empty].shown), "SPELLS | [ ] Power Word: Shield 4s Quick | false",
        "learned: listed, unticked, Quick, its 4 s cooldown")
    Equal(Watched(LP), 0, "and not watched until it's ticked")
    RowFor(lp, "Power Word: Shield").check:Click()
    local n, watched = LP:Watchers()
    Equal(n .. " " .. S[lp.status].text, "1 1 cooldown pulses when it's ready.", "ticked: watched")
    H.Done(watched["Power Word: Shield"].cooldown)
    Equal(Now(LP), "Power Word: Shield quick", "and it pulses when it's ready")
    Finish(LP)
    -- A higher rank learned: the same row, at the new rank.
    table.insert(H.book[2].items, { name = "Power Word: Shield", subName = "Rank 2", spellID = 592, iconID = 135940 })
    Fire("PLAYER_LEVEL_UP")
    H.Tick(learner)
    Equal(Rows(lp) .. " " .. watched["Power Word: Shield"].spellID, "SPELLS | [x] Power Word: Shield 4s Quick 592",
        "a new rank: still one row, still ticked, now watching the new rank")
    -- Unlearned (talents reset): its row goes, and its old cooldown ending says nothing.
    local old = watched["Power Word: Shield"].cooldown
    table.remove(H.book[2].items, 3)
    table.remove(H.book[2].items, 2)
    Fire("SPELLS_CHANGED")
    H.Tick(learner)
    H.clock = H.clock + 5
    H.Done(old)
    Equal(Rows(lp) .. " | " .. Watched(LP) .. " " .. tostring(old.watch) .. " " .. tostring(LP:Showing()),
        " | 0 nil nil", "unlearned: its row and watcher gone; its old cooldown ending: no pulse")
    Equal(tostring(Profile("pulsePick")["Power Word: Shield"]), "true", "still ticked should it be learned again")
    Equal(H.Problems(), "", "no errors from learning")
end

-- Two trinkets at once, or a trinket and a potion: a pulse each ---------------------------------

do
    local tns = H.Start(nil)
    local TP = tns.Pulse
    H.worn[13], H.worn[14] = 9999, 9998
    H.counts[118] = 1
    Fire("PLAYER_EQUIPMENT_CHANGED")
    H.Tick(tns)
    for _, key in ipairs({ "slot:13", "slot:14", "family:healing" }) do tns.SetPulsePick(key, true) end
    TP:Apply()
    local _, watching = TP:Watchers()
    Equal(tostring(watching["slot:13"] ~= nil) .. " " .. tostring(watching["slot:14"] ~= nil) .. " " .. tostring(watching["family:healing"] ~= nil),
        "true true true", "both trinkets and Healing Potions ticked: each watched")
    H.trinketCooldowns[13], H.trinketCooldowns[14] = { 200, 120, 1 }, { 200, 120, 1 }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(tns)
    H.Done(watching["slot:13"].cooldown)
    H.Done(watching["slot:14"].cooldown)
    local key, waiting = TP:Showing()
    Equal(key .. " " .. waiting, "slot:13 1", "two trinkets used together: each pulses, the second waiting its turn")
    TP:Next()
    Equal(tostring((TP:Showing())), "slot:14", "then the second trinket's own pulse")
    Finish(TP)
    H.trinketCooldowns[13], H.itemCooldown = { 400, 120, 1 }, { 400, 120, true }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(tns)
    H.clock = H.clock + 5
    H.Done(watching["slot:13"].cooldown)
    H.Done(watching["family:healing"].cooldown)
    key, waiting = TP:Showing()
    Equal(key .. " " .. waiting, "slot:13 1", "a trinket and a potion with the same cooldown: the trinket now, the potion next")
    TP:Next()
    Equal(tostring((TP:Showing())), "cd:400:120", "the potion's own pulse, keyed by the cooldown potions share")
    Finish(TP)
    -- A trinket that only gives stats has no use: not listed.
    H.worn[14] = 9997
    Fire("PLAYER_EQUIPMENT_CHANGED")
    H.Tick(tns)
    local function Keys()
        local keys = {}
        for _, entry in ipairs(TP:Items()) do keys[#keys + 1] = entry.key end
        return table.concat(keys, ",")
    end
    Equal(Keys(), "slot:13,family:healing", "a trinket with no use: not listed")
    -- Carrying a Minor Healing Potion: Healing Potions lists it, the bag
    -- item isn't listed again (each pulse is the family's).
    H.bag[1] = { itemID = 118, hyperlink = "|cffffffff|Hitem:118::|h[Minor Healing Potion]|h|r", iconFileID = 888 }
    tns.Spells:Scan()
    Equal(Keys(), "slot:13,family:healing", "a potion in your bags: once, as Healing Potions, not twice")
    tns.SetPulsePick("item:118", true)
    Equal(Keys(), "slot:13,family:healing,item:118", "ticked on its own (an older list): listed, so it can be unticked")
    tns.SetPulsePick("item:118", false)
    -- A class without mana has no Mana Potions row: one carried shows on its own.
    H.character.classFile = "WARRIOR"
    H.bag[1] = { itemID = 2455, hyperlink = "|cffffffff|Hitem:2455::|h[Minor Mana Potion]|h|r", iconFileID = 888 }
    H.counts[2455] = 1
    tns.Spells:Scan()
    Equal(Keys(), "slot:13,family:healing,item:2455", "a warrior's mana potion: no Mana Potions row, so its own")
    H.character.classFile = "DRUID"
    -- Lucky Charm ticked from your bags before you wore it, and as Trinket
    -- 1: its cooldown pulses once, as the slot's.
    H.bag[1] = { itemID = 9999, hyperlink = "|cff1eff00|Hitem:9999::|h[Lucky Charm]|h|r", iconFileID = 777 }
    H.counts[9999] = 1
    tns.Spells:Scan()
    tns.SetPulsePick("item:9999", true)
    TP:Apply()
    Equal(tostring(watching["slot:13"] ~= nil) .. " " .. tostring(watching["item:9999"] ~= nil), "true true",
        "the worn trinket ticked twice over: as Trinket 1, and as the item")
    H.trinketCooldowns[13], H.itemCooldown = { 600, 120, 1 }, { 600, 120, true }
    Fire("BAG_UPDATE_COOLDOWN")
    H.Tick(tns)
    H.clock = H.clock + 5
    H.Done(watching["slot:13"].cooldown)
    H.Done(watching["item:9999"].cooldown)
    key, waiting = TP:Showing()
    Equal(key .. " " .. waiting, "slot:13 0", "one trinket, ticked twice: one pulse, the slot's")
    Finish(TP)
    Equal(H.Problems(), "", "no errors from trinkets and potions")
end

Equal(H.Problems(), "", "no errors")
io.write("Pulse checks passed: " .. H.checks .. " assertions.\n")
