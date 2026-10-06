-- Run the addon's real files against a mock game (Tools/Harness.lua) beside
-- Forever Enhanced Cooldown Manager, whose Cooldown pulse page does the same
-- job: only one pulse runs at a time. Whichever is on keeps it; the other's
-- tick greys out, its hover note saying where the pulse runs and how to
-- swap; with both on, Forever Enhanced Cooldown Manager's wins and this
-- one's choice is kept for when that's turned off. No popups, no reload.
-- Forever Enhanced Cooldown Manager is stood in for both ways: as it will be,
-- joining the shared link (ForeverPulseLink) by the contract in Link.lua,
-- and as 1.5.0 is, loaded without joining, its saved setting read instead.
-- Also: the link's own functions, and that the addon's names in the game's
-- global space are all its own, so the two addons never collide.
-- Run with: fengari Tools/TestLink.lua
local H = assert(loadfile("Tools/Harness.lua"))()
local S, Equal, Fire, Note = H.S, H.Equal, H.Fire, H.Note

local MANAGER, PULSE = "ForeverEnhancedCooldownManager", "ForeverEnhancedCooldownPulse"
local NOTE = "Cooldown pulse is on in Forever Enhanced Cooldown Manager. Turn it off there to use this one."

-- The page's tick and title row, and how many cooldowns are watched.
local function State(ns)
    local page = FECPFrame.pages.pulse
    return tostring(page.master.checked) .. " " .. tostring(page.master.usable) .. " " .. S[page.master].alpha .. " | "
        .. S[page.status].text .. " | " .. (ns.Pulse:Watchers())
end
-- Barkskin and Bash ticked, the window open on the pulse page.
local function Ready(ns)
    ns.SetPulsePick("Barkskin", true)
    ns.SetPulsePick("Bash", true)
    ns.Pulse:Apply()
    ns.ShowWindow()
    FECPFrame:Select("pulse")
end
-- Forever Enhanced Cooldown Manager as it will be: the same link code
-- (Link.lua's shared part, run as its own), then registered by the contract:
-- its title, rank 2, its tick, and what it does when told something changed.
local function NewManager(on)
    local manager = { on = on, refreshed = 0 }
    assert(loadfile("Link.lua"))(MANAGER, {})
    ForeverPulseLink:Register(MANAGER, {
        name = "Forever Enhanced Cooldown Manager",
        rank = 2,
        IsOn = function() return manager.on end,
        Refresh = function() manager.refreshed = manager.refreshed + 1 end,
    })
    H.addOns[MANAGER] = true
    return manager
end
-- Its tick clicked: saved, then the others told.
local function Toggle(manager, on)
    manager.on = on
    ForeverPulseLink:Notify(MANAGER)
end

-- Absent: the pulse runs here ---------------------------------------------------------------------

do
    local ns = H.Start(nil)
    Ready(ns)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "no Forever Enhanced Cooldown Manager: it runs here")
    Equal(tostring(ns.Link:Runner()) .. " " .. tostring(ns.Link:Elsewhere()) .. " " .. tostring(ns.Link:Note()), PULSE .. " nil nil",
        "the link says so")
    Equal(Note(FECPFrame.pages.pulse.master), "A big icon in the middle of your screen the moment a cooldown is ready, in a fight too."
        .. " It never takes the mouse.", "its tick says what it does")
    Equal(tostring(S[ns.Link.watcher].shown), "false", "nothing to look at every second")
    Equal(H.Problems(), "", "no errors")
end

-- Forever Enhanced Cooldown Manager on the link ---------------------------------------------------

do
    -- Loaded first, its pulse on: it wins, and this one waits, its choice kept.
    H.Environment()
    local manager = NewManager(true)
    local ns = H.Load(nil)
    H.Tick(ns)
    H.clock = H.clock + 5
    Equal(manager.refreshed, 1, "this addon joining: Forever Enhanced Cooldown Manager hears of it")
    Ready(ns)
    local page = FECPFrame.pages.pulse
    Equal(State(ns), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0",
        "both on: Forever Enhanced Cooldown Manager's wins; this tick greyed, still ticked, nothing watched here")
    Equal(Note(page.master), NOTE, "its hover note names where the pulse runs and how to swap")
    page.master:Click()
    Equal(tostring(ns.Get("pulse")) .. " " .. tostring(page.master.checked), "true true", "greyed: a click changes nothing")
    -- A cooldown done here meanwhile: no pulse (it pulses there).
    local before = #H.asked
    Fire("SPELL_UPDATE_COOLDOWN")
    H.Tick(ns)
    Equal(#H.asked - before, 0, "nothing asked of the game here")
    -- Turned off there: this one takes over at once, no reload.
    Toggle(manager, false)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "turned off there: this one takes over at once")
    local _, watchers = ns.Pulse:Watchers()
    H.Done(watchers.Barkskin.cooldown)
    Equal(tostring((ns.Pulse:Showing())), "Barkskin", "and pulses")
    Equal(ForeverPulseLink:Runner(), PULSE, "the link says it runs here: Forever Enhanced Cooldown Manager greys its own tick")
    -- Turned on there again: this one stops at once.
    Toggle(manager, true)
    Equal(State(ns), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0", "on there again: this one stops")
    -- This one's tick changed: the other is told.
    Toggle(manager, false)
    local told = manager.refreshed
    page.master:Click()
    Equal(manager.refreshed - told .. " " .. tostring(ForeverPulseLink:Runner()), "1 nil", "this one off: Forever Enhanced Cooldown Manager is told, nothing runs")
    Equal(State(ns), "false true 1 | Off. Tick the box below to start. | 0", "off here, free to tick")
    page.master:Click()
    Equal(manager.refreshed - told .. " " .. ForeverPulseLink:Runner(), "2 " .. PULSE, "on again: told again")
    -- The tour's first step says where it runs.
    Toggle(manager, true)
    SlashCmdList.FECP("tour")
    local box = FECPTour
    Equal(tostring(S[box.text].text:find("Cooldown pulse is on in Forever Enhanced Cooldown Manager, so it runs there", 1, true) ~= nil)
        .. " " .. tostring(S[box.text].text:find("Nothing to do here while it runs there.", 1, true) ~= nil), "true true",
        "the tour's first step says it runs there, with nothing to try")
    box.skip:Click()
    -- Its callbacks failing never break this addon.
    ForeverPulseLink.owners[MANAGER].IsOn = function() error("broken") end
    ForeverPulseLink.owners[MANAGER].Refresh = function() error("broken") end
    ForeverPulseLink:Notify(MANAGER)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "its IsOn failing counts as off")
    page.master:Click()
    page.master:Click()
    Equal(H.Problems(), "", "its Refresh failing is passed over")
end

do
    -- Loaded after this addon, its pulse off; then both saved as on.
    H.Environment()
    local ns = H.Load({ pulse = true })
    H.Tick(ns)
    H.clock = H.clock + 5
    Ready(ns)
    local manager = NewManager(false)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "it joins later with its pulse off: this one runs on")
    Toggle(manager, true)
    Equal(State(ns), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0", "switched on there: it takes over")
    -- A reload with both saved as on: the same.
    local saved = ForeverEnhancedCooldownPulseDB
    H.Environment()
    NewManager(true)
    local again = H.Load(saved)
    H.Tick(again)
    again.ShowWindow()
    Equal(State(again), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0", "both saved as on: its pulse wins")
    Equal(tostring(saved.pulse), "true", "this one's choice kept")
    -- A refresh calling back in doesn't go round.
    local calls = 0
    ForeverPulseLink.owners[MANAGER].Refresh = function()
        calls = calls + 1
        ForeverPulseLink:Notify(MANAGER)
    end
    again.Set("pulse", false)
    Equal(calls, 1, "a Refresh that notifies back: heard once")
    Equal(H.Problems(), "", "no errors")
end

-- Taking over: the list read again first ---------------------------------------------------------

-- What's watched, by key and item.
local function Watched(ns)
    local _, watchers = ns.Pulse:Watchers()
    local keys = {}
    for key, watch in pairs(watchers) do keys[#keys + 1] = key .. "=" .. tostring(watch.itemID) end
    table.sort(keys)
    return table.concat(keys, ", ")
end
-- A trinket ticked and a bag item ticked but not carried; the window opened
-- once and shut. Then, while the pulse runs elsewhere (nothing read here),
-- the trinket is swapped and the item picked up.
local function Meanwhile(ns)
    H.clock = H.clock + 5
    ns.SetPulsePick("slot:13", true)
    ns.SetPulsePick("item:9997", true)
    H.itemSpells[9997] = "Plain"
    ns.ShowWindow()
    FECPFrame:Hide()
    H.worn[13] = 9998
    Fire("PLAYER_EQUIPMENT_CHANGED")
    H.bag[1] = { itemID = 9997, hyperlink = "|cff|Hitem:9997|h[Plain Charm]|h|r", iconFileID = 555 }
    H.counts[9997] = 1
    Fire("BAG_UPDATE_DELAYED")
    H.Tick(ns)
    local trinket = ns.Spells:Find("slot:13")
    return tostring(trinket and trinket.itemID) .. " " .. tostring(ns.Spells:Find("item:9997") ~= nil)
end

do
    -- Forever Enhanced Cooldown Manager on the link, turned off there.
    H.Environment()
    local manager = NewManager(true)
    H.worn[13] = 9999
    local ns = H.Load({ pulse = true })
    H.Tick(ns)
    Equal(Meanwhile(ns), "9999 false", "while it runs there, the list here isn't read again")
    Toggle(manager, false)
    Equal(Watched(ns), "item:9997=9997, slot:13=9998", "taking over: the trinket worn now and the item picked up are watched")
    Toggle(manager, false)
    Equal(Watched(ns), "item:9997=9997, slot:13=9998", "told again while it runs here: the same")
    Equal(H.Problems(), "", "no errors")
end

do
    -- Forever Enhanced Cooldown Manager 1.5.0, turned off there.
    H.Environment()
    H.Manager({ pulse = true })
    H.worn[13] = 9999
    local ns = H.Load({ pulse = true })
    H.Tick(ns)
    Equal(Meanwhile(ns), "9999 false", "1.5.0: while it runs there, the list here isn't read again")
    ForeverEnhancedCooldownManagerDB.pulse = false
    H.Frame(1.1)
    Equal(Watched(ns), "item:9997=9997, slot:13=9998", "1.5.0 turned off: the trinket worn now and the item picked up are watched")
    Equal(H.Problems(), "", "no errors")
end

-- The link's own functions: from the newest copy loaded --------------------------------------------

do
    -- An older copy made it first: its owners kept, its functions replaced.
    H.Environment()
    local old = { name = "Old", rank = 1, IsOn = function() return false end, Refresh = function() end }
    _G.ForeverPulseLink = { version = 0, owners = { Old = old }, Register = function() error("old") end }
    local ns = H.Load(nil)
    Equal(ForeverPulseLink.version .. " " .. tostring(ForeverPulseLink.owners.Old == old) .. " " .. tostring(ForeverPulseLink.owners[PULSE] ~= nil)
        .. " " .. tostring(ns.Link.link == ForeverPulseLink), "1 true true true", "an older link: its owners kept, newer functions, this addon joined")
    -- A newer copy: left as it is.
    H.Environment()
    local newer = function(self, key, owner) self.owners[key] = owner; self.newer = true end
    _G.ForeverPulseLink = { version = 2, owners = {}, Register = newer, Notify = function() end,
        Runner = function() return nil end }
    H.Load(nil)
    Equal(ForeverPulseLink.version .. " " .. tostring(ForeverPulseLink.Register == newer) .. " " .. tostring(ForeverPulseLink.newer),
        "2 true true", "a newer link: its functions used, not replaced")
    -- Something else in its place: made afresh.
    H.Environment()
    _G.ForeverPulseLink = "nonsense"
    H.Load(nil)
    Equal(type(ForeverPulseLink) .. " " .. type(ForeverPulseLink.owners[PULSE]), "table table", "anything else: made afresh")
    -- The rule: the highest rank on runs, then the first by name.
    H.Environment()
    assert(loadfile("Link.lua"))("Test", {})
    local link = ForeverPulseLink
    local on = {}
    for key, rank in pairs({ A = 1, B = 2, C = 2 }) do
        link.owners[key] = { name = key, rank = rank, IsOn = function() return on[key] == true end, Refresh = function() end }
    end
    local picks = {}
    for _, set in ipairs({ {}, { A = true }, { A = true, C = true }, { A = true, B = true, C = true } }) do
        on = set
        picks[#picks + 1] = tostring(link:Runner())
    end
    Equal(table.concat(picks, " "), "nil A C B", "none on: none; the highest rank; ties by name")
    Equal(H.Problems(), "", "no errors")
end

-- Forever Enhanced Cooldown Manager 1.5.0: loaded, not on the link --------------------------------

do
    -- Its pulse on: read from its saved settings, this one waits.
    H.Environment()
    H.Manager({ pulse = true })
    local ns = H.Load(nil)
    H.Tick(ns)
    H.clock = H.clock + 5
    Ready(ns)
    local page = FECPFrame.pages.pulse
    Equal(State(ns) .. " | " .. Note(page.master), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0 | " .. NOTE,
        "1.5.0 with its pulse on: read from its saved settings, this one greyed")
    Equal(tostring(S[ns.Link.watcher].shown) .. " " .. tostring(ForeverEnhancedCooldownManagerDB.pulse), "true true",
        "looked at every second, and only read")
    -- Toggled there, live: noticed within a second, no reload.
    ForeverEnhancedCooldownManagerDB.pulse = false
    H.Frame(.5)
    Equal(State(ns), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0", "not before the second is up")
    H.Frame(.6)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "turned off there: within a second this one takes over")
    ForeverEnhancedCooldownManagerDB.pulse = true
    H.Frame(1.1)
    Equal(State(ns), "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0", "on there again: this one stops")
    -- Anything but on in its settings counts as off.
    for _, value in ipairs({ "yes", 1, {} }) do
        ForeverEnhancedCooldownManagerDB.pulse = value
        H.Frame(1.1)
        Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "its setting " .. type(value) .. ": off")
    end
    ForeverEnhancedCooldownManagerDB = nil
    H.Frame(1.1)
    Equal(State(ns), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "no settings: off")
    Equal(tostring(ForeverEnhancedCooldownManagerDB), "nil", "never written")
    -- Its saved settings left behind with it not loaded: not looked at.
    H.Environment()
    _G.ForeverEnhancedCooldownManagerDB = { pulse = true }
    local alone = H.Load(nil)
    H.Tick(alone)
    Ready(alone)
    Equal(State(alone) .. " " .. tostring(S[alone.Link.watcher].shown), "true true 1 | 2 cooldowns pulse when they're ready. | 2 false",
        "not loaded: its leftover settings mean nothing")
    -- Loading after this addon: noticed as it loads.
    H.addOns[MANAGER] = true
    Fire("ADDON_LOADED", MANAGER)
    Equal(State(alone) .. " " .. tostring(S[alone.Link.watcher].shown),
        "true false 0.35 | Running in Forever Enhanced Cooldown Manager instead. | 0 true", "loaded later: noticed at once")
    -- A newer one joining the link takes over from its saved setting.
    NewManager(false)
    Equal(State(alone), "true true 1 | 2 cooldowns pulse when they're ready. | 2", "on the link, its own word counts")
    H.Frame(1.1)
    Equal(tostring(S[alone.Link.watcher].shown), "false", "and nothing is looked at every second any more")
    Equal(H.Problems(), "", "no errors")
end

-- The addon's names: all its own -----------------------------------------------------------------

do
    local ns = H.Start(nil)
    H.RunTimers()
    Ready(ns)
    H.worn[13] = 9999
    ns.SetPulsePick("slot:13", true)
    ns.Pulse:Apply()
    ns.Pulse:Preview()
    FECPFrame.pages.pulse.move:Click()
    ns.Pulse:StopMove(true)
    SlashCmdList.FECP("tour")
    SlashCmdList.FECP("discord")
    SlashCmdList.FECP("debug")
    FECPFrame.help:Click()
    local added = H.NewGlobals()
    Equal(table.concat(added, ", "), "FECPCopyLink, FECPDebugFrame, FECPFrame, FECPMinimapButton, FECPPulse, FECPPulseMover,"
        .. " FECPTour, ForeverEnhancedCooldownPulseDB, ForeverPulseLink, SLASH_FECP1",
        "every name it puts in the game's global space is its own (FECP, its saved settings and the shared link)")
    local theirs = {}
    for key in pairs(_G) do
        if type(key) == "string" and (key:find("^FECM") or key:find("^SLASH_FECM") or key:find("^SLASH_CCM")) then theirs[#theirs + 1] = key end
    end
    local commands = {}
    for key in pairs(SlashCmdList) do commands[#commands + 1] = key end
    Equal(table.concat(theirs, ",") .. " | " .. table.concat(commands, ","), " | FECP",
        "none of Forever Enhanced Cooldown Manager's names, and only its own command")
    Equal(H.Problems(), "", "no errors")
end

io.write("Link checks passed: " .. H.checks .. " assertions.\n")
