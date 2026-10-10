-- The link with Forever Enhanced Cooldown Manager, whose Cooldown pulse page
-- does what this addon does: with both installed, only one of them pulses, so
-- a cooldown never pops up twice. Whichever pulse is on keeps it; the other's
-- on/off tick greys out, its hover note saying where the pulse runs and how
-- to swap. With both saved as on, Forever Enhanced Cooldown Manager's wins:
-- this one's tick greys out but keeps its choice, so it takes over as soon as
-- the other is turned off. No popups, and no reload: a change in one greys
-- or frees the other at once.
--
-- The link is one small table in the game's global space, ForeverPulseLink,
-- made by whichever addon loads first. Each addon registers itself in it by
-- its folder name: its title, a rank (the higher wins when both are on), a
-- function saying whether its own tick is on, and one to call when the
-- other's changes. Its functions come from the newest version of this code
-- loaded, so an older copy in the other addon never holds back a newer one.
-- Forever Enhanced Cooldown Manager 1.5.0 and older don't register: while
-- one of those is loaded, its saved setting is read instead, and looked at
-- again every second, so it's followed live too.
local ADDON, ns = ...

local L = {}
ns.Link = L

L.VERSION = 1 -- this copy of the link's functions
L.RANK = 1 -- this addon's; Forever Enhanced Cooldown Manager's is 2
L.MANAGER = "ForeverEnhancedCooldownManager"
L.MANAGER_TITLE = "Forever Enhanced Cooldown Manager"
L.MANAGER_RANK = 2
local POLL = 1 -- seconds between looks at an older Forever Enhanced Cooldown Manager's setting

-- The shared table ------------------------------------------------------------------
-- Made here unless the other addon made it first; its functions replaced
-- only by a newer version of them.

local link = _G.ForeverPulseLink
if type(link) ~= "table" then
    link = {}
    _G.ForeverPulseLink = link
end
if type(link.owners) ~= "table" then link.owners = {} end
if type(link.version) ~= "number" or link.version < L.VERSION then
    link.version = L.VERSION

    -- An addon joins (or joins again) under its folder name, and the others
    -- hear of it.
    function link:Register(key, owner)
        if type(key) ~= "string" or type(owner) ~= "table" then return end
        self.owners[key] = owner
        self:Notify(key)
    end

    -- Every other addon hears that something changed. A call that fails is
    -- passed over, so one addon's error never stops the other; one that
    -- calls back in while this runs is ignored, so it can't go round.
    function link:Notify(from)
        if self.notifying then return end
        self.notifying = true
        for key, owner in pairs(self.owners) do
            if key ~= from and type(owner) == "table" and type(owner.Refresh) == "function" then pcall(owner.Refresh) end
        end
        self.notifying = nil
    end

    -- The addon that pulses now: of those whose tick is on, the highest
    -- rank (then the first by name). Its key and entry, or nil for none.
    function link:Runner()
        local bestKey, best, bestRank
        for key, owner in pairs(self.owners) do
            if type(key) == "string" and type(owner) == "table" and type(owner.IsOn) == "function" then
                local ok, on = pcall(owner.IsOn)
                local rank = tonumber(owner.rank) or 0
                if ok and on == true and (not best or rank > bestRank or (rank == bestRank and key < bestKey)) then
                    bestKey, best, bestRank = key, owner, rank
                end
            end
        end
        return bestKey, best
    end
end
L.link = link

-- An older Forever Enhanced Cooldown Manager ------------------------------------------

-- Whether Forever Enhanced Cooldown Manager is loaded without registering
-- (1.5.0 and older). Once loaded it stays loaded, so a yes is kept.
local managerLoaded = false
local function Older()
    if link.owners[L.MANAGER] ~= nil then return false end
    if not managerLoaded then
        local loaded = C_AddOns and C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
        managerLoaded = loaded ~= nil and loaded(L.MANAGER) and true or false
    end
    return managerLoaded
end

-- Its pulse switched on, from its saved settings (read only, never written).
local function OlderOn()
    local saved = _G.ForeverEnhancedCooldownManagerDB
    return type(saved) == "table" and saved.pulse == true
end

-- Where the pulse runs --------------------------------------------------------------

-- The addon that pulses now, by folder name and title, or nil when neither
-- pulse is on.
function L:Runner()
    local key, owner = link:Runner()
    if Older() and OlderOn() and (not owner or (tonumber(owner.rank) or 0) < self.MANAGER_RANK) then
        return self.MANAGER, self.MANAGER_TITLE
    end
    if key then return key, type(owner.name) == "string" and owner.name or key end
    return nil
end

-- Whether this addon's pulse runs: its tick is on, and the other's isn't.
function L:Runs()
    return (self:Runner()) == ADDON
end

-- The title of the other addon while the pulse runs there, else nil.
function L:Elsewhere()
    local key, name = self:Runner()
    if key and key ~= ADDON then return name end
    return nil
end

-- The on/off tick's hover note while it's greyed out, else nil.
function L:Note()
    local name = self:Elsewhere()
    if name then return "Cooldown pulse is on in " .. name .. ". Turn it off there to use this one." end
    return nil
end

-- The other addon changed: the pulse starts or stops here, and the window
-- greys or frees the tick. Your spells and bags aren't read while the pulse
-- runs there (unless the window is open), so taking over has them read again
-- first: a trinket swapped or an item picked up meanwhile is watched as it is now.
function L:Refresh()
    local was = self.last
    self.last = (self:Runner())
    if self.last == ADDON and was ~= ADDON and ns.Spells then ns.Spells:Stale() end
    if ns.Pulse and ns.Pulse.started then ns.Pulse:Apply() end
    if ns.window and ns.window:IsShown() then ns.window:Refresh() end
end

-- This addon's tick changed: the other hears of it.
function L:Changed()
    self.last = (self:Runner())
    link:Notify(ADDON)
end

-- An older Forever Enhanced Cooldown Manager can't tell this addon its tick
-- changed, so while one is loaded its setting is looked at every second.
local function Poll(frame, elapsed)
    frame.since = (frame.since or 0) + (elapsed or 0)
    if frame.since < POLL then return end
    frame.since = 0
    if not Older() then return frame:Hide() end
    if (L:Runner()) ~= L.last then L:Refresh() end
end

local function Watch(frame)
    frame:SetShown(Older())
end

function L:Start()
    if self.started then return end
    self.started = true
    link:Register(ADDON, {
        name = ns.TITLE,
        rank = self.RANK,
        IsOn = function() return ns.Get("pulse") == true end,
        Refresh = function() L:Refresh() end,
    })
    self.last = (self:Runner())
    -- Of its own, not UIParent's, so it keeps looking with the interface hidden.
    local watcher = CreateFrame("Frame", nil, nil)
    watcher:EnableMouse(false)
    watcher:SetScript("OnUpdate", Poll)
    -- An older one loading after this addon, or found at login.
    watcher:RegisterEvent("ADDON_LOADED")
    watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    watcher:SetScript("OnEvent", function(frame)
        Watch(frame)
        if (L:Runner()) ~= L.last then L:Refresh() end
    end)
    Watch(watcher)
    self.watcher = watcher
end
