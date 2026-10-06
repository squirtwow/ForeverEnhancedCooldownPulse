-- Forever Enhanced Cooldown Pulse: saved settings, profiles, the /fecp
-- command, Escape for the window and the entry in Options > AddOns. Each part
-- lives in its own file and starts from here once the saved settings are
-- loaded.
local ADDON, ns = ...

ns.ADDON = ADDON
ns.TITLE = "Forever Enhanced Cooldown Pulse"
ns.MEDIA = "Interface\\AddOns\\" .. ADDON .. "\\Media\\"

-- The addon's version, filled in when it's packaged for release; "dev" for a
-- copy straight from the source.
function ns.Version()
    local get = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    local version = get and get(ADDON, "Version")
    if type(version) ~= "string" or version == "" or version:find("@", 1, true) then return "dev" end
    return version
end

-- The version of whatever waits for the next update's number: its notes
-- (Notes.lua) and the tour steps it adds (Tour.lua). The release gives them
-- that number in place of this.
ns.UNRELEASED = "Unreleased"

-- A version as numbers to compare part by part ("1.10.2" is 1, 10, 2), or nil
-- if it isn't one. What's unreleased comes after every release, and a copy
-- straight from the source ("dev") after that.
local function VersionParts(version)
    if version == ns.UNRELEASED then return { math.huge } end
    if version == "dev" then return { math.huge, math.huge } end
    local digits = type(version) == "string" and version:match("^v?(%d+[%d%.]*)")
    if not digits then return nil end
    local parts = {}
    for part in digits:gmatch("%d+") do parts[#parts + 1] = tonumber(part) end
    return parts
end

-- -1, 0 or 1 as version a is older than, the same as or newer than b ("1.1"
-- is "1.1.0"); nil if either isn't a version.
function ns.CompareVersions(a, b)
    a, b = VersionParts(a), VersionParts(b)
    if not (a and b) then return nil end
    for i = 1, math.max(#a, #b) do
        local x, y = a[i] or 0, b[i] or 0
        if x ~= y then return x < y and -1 or 1 end
    end
    return 0
end

-- The pulse's settings and their limits are Forever Enhanced Cooldown
-- Manager's Cooldown pulse page's, with the same install defaults. Each
-- cooldown pulses Quick or Long; each style has its own size, time and sound.
ns.DEFAULTS = {
    pulse = true, -- on from the start (the user's pick for this addon); Link.lua says where it runs
    pulseSize = 272, -- Quick: the icon's size, in the game's units (about a third of the screen's height)
    pulseTime = 10, -- how long each pulse lasts, in tenths of a second
    pulseSound = "none",
    pulseLongSize = 400, -- Long: the same three
    pulseLongTime = 25,
    pulseLongSound = "none",
    pulseMaster = false, -- both styles: the sound at your Master volume, heard with Sound Effects down or off
    pulseSeeThrough = 80, -- both styles: how much of the game shows through it, in percent (see Pulse.lua's Opacity)
    pulseGrow = 135, -- how big it gets by the end, in percent of its size
    pulseBorder = "thin", -- a dark edge round it: none, thin or thick
    pulseShadow = true, -- and a soft shadow
    pulseItems = true, -- your trinkets, potions and items with a use are listed too
    pulseX = 0, -- where it sits: from the middle of the screen
    pulseY = 0,
    accent = "purple", -- the /fecp window's accent colour
    minimap = true, -- the minimap button
    minimapAngle = 285, -- where it sits round the minimap: degrees anticlockwise from the right
    minimapFree = false, -- free-floating: anywhere on the screen, not on the minimap's edge
    minimapX = 0, -- where it sits while free-floating: from the middle of the screen
    minimapY = 0,
}
-- Number settings, each within its limits: min, max, default.
ns.MINIMAP_ANGLE = { 0, 359, 285 }
ns.MINIMAP_PLACE = { -4000, 4000, 0 }
ns.PULSE_SIZE = { 64, 512, 272 }
ns.PULSE_TIME = { 3, 20, 10 } -- tenths of a second: 0.3 to 2 seconds
ns.PULSE_LONG_SIZE = { 64, 512, 400 }
ns.PULSE_LONG_TIME = { 3, 50, 25 } -- 0.3 to 5 seconds
ns.PULSE_SEE_THROUGH = { 0, 90, 80 }
ns.PULSE_GROW = { 100, 160, 135 }
ns.PULSE_PLACE = { -4000, 4000, 0 }
local NUMBERS = { minimapAngle = ns.MINIMAP_ANGLE, pulseSize = ns.PULSE_SIZE, pulseTime = ns.PULSE_TIME,
    pulseLongSize = ns.PULSE_LONG_SIZE, pulseLongTime = ns.PULSE_LONG_TIME, pulseSeeThrough = ns.PULSE_SEE_THROUGH,
    pulseGrow = ns.PULSE_GROW, pulseX = ns.PULSE_PLACE, pulseY = ns.PULSE_PLACE, minimapX = ns.MINIMAP_PLACE,
    minimapY = ns.MINIMAP_PLACE }
-- Choices a text setting may hold.
ns.ACCENT_KEYS = { "orange", "blue", "teal", "purple", "green" }
ns.PULSE_BORDER_KEYS = { "none", "thin", "thick" }
ns.PULSE_BORDER_NAMES = { none = "None", thin = "Thin", thick = "Thick" }
ns.PULSE_SOUND_KEYS = { "none", "chime", "bell", "trill", "shimmerBell", "magicChimes", "shimmer", "zippy", "synth", "pipe", "brass",
    "warhorn", "fanfare", "gold", "jackpot", "anvil" }
ns.PULSE_SOUND_NAMES = { none = "None", chime = "Chime", bell = "Bell", trill = "Bell trill", shimmerBell = "Shimmer bell",
    magicChimes = "Magic chimes", shimmer = "Shimmer", zippy = "Zippy magic", synth = "Synth", pipe = "Pitch pipe", brass = "Brass",
    warhorn = "War horn", fanfare = "Fanfare", gold = "Gold", jackpot = "Jackpot bell", anvil = "Anvil" }
ns.PULSE_STYLE_KEYS = { "quick", "long" }
ns.PULSE_STYLE_NAMES = { quick = "Quick", long = "Long" }
local CHOICES = { accent = {}, pulseBorder = {}, pulseSound = {}, pulseLongSound = {} }
for _, key in ipairs(ns.ACCENT_KEYS) do CHOICES.accent[key] = true end
for _, key in ipairs(ns.PULSE_BORDER_KEYS) do CHOICES.pulseBorder[key] = true end
for _, key in ipairs(ns.PULSE_SOUND_KEYS) do CHOICES.pulseSound[key], CHOICES.pulseLongSound[key] = true, true end

function ns.Valid(key, value)
    local default = ns.DEFAULTS[key]
    if type(default) == "boolean" then return type(value) == "boolean" end
    if CHOICES[key] then return CHOICES[key][value] == true end
    local limits = NUMBERS[key]
    if limits then return type(value) == "number" and value >= limits[1] and value <= limits[2] end
    return type(value) == type(default)
end

local db

function ns.Get(key)
    local value = db and db[key]
    if value == nil or not ns.Valid(key, value) then value = ns.DEFAULTS[key] end
    return value
end

-- Profiles ---------------------------------------------------------------------
-- A profile holds the pulse's two lists: what's ticked, and what's Long.
-- Everything else (how it looks, sounds and where it sits) is shared. Each
-- character, told apart by its GUID since two can share a name, uses one
-- profile, at first its own "Name Surname (Class) - Realm". Several
-- characters can share one, and profiles never change in combat.
ns.PROFILE_MAX = 48 -- longest profile name

local active -- this character's profile, once the character is known
local scratch = {} -- lists used before then; never saved

local function Profiles()
    if type(db.profiles) ~= "table" then db.profiles = {} end
    return db.profiles
end

local function Chars()
    if type(db.chars) ~= "table" then db.chars = {} end
    return db.chars
end

-- The pulse's two lists in a profile, and the one value each keeps: what's
-- ticked (spell names and item keys -> true), and what's switched to Long
-- (-> "long"; the rest are Quick).
local PULSE_LISTS = { pulsePick = true, pulseStyle = "long" }

-- A profile's lists, repaired in place.
local function Lists(profile)
    for field, keep in pairs(PULSE_LISTS) do
        if type(profile[field]) ~= "table" then profile[field] = {} end
        for key, value in pairs(profile[field]) do
            if type(key) ~= "string" or key == "" or value ~= keep then profile[field][key] = nil end
        end
    end
    return profile
end

-- The profile chosen for every character, new ones included, if there is one.
local function Everyone()
    local name = db and db.everyone
    if type(name) == "string" and Profiles()[name] then return name end
end

local function RepairProfiles()
    local profiles = Profiles()
    for name, profile in pairs(profiles) do
        if type(name) ~= "string" or type(profile) ~= "table" then profiles[name] = nil else Lists(profile) end
    end
    local chars = Chars()
    for guid, name in pairs(chars) do
        if type(guid) ~= "string" or type(name) ~= "string" then chars[guid] = nil end
    end
    db.everyone = Everyone()
end

local function PlayerGUID()
    local guid = UnitGUID and UnitGUID("player")
    return type(guid) == "string" and guid ~= "" and guid or nil
end

local UNKNOWN = UNKNOWNOBJECT or "Unknown"

-- Text cut to at most max bytes, never through the middle of a letter, and
-- without a space left at the end.
local function Cut(text, max)
    if #text <= max then return text end
    local cut = max
    -- A byte from 128 to 191 carries on the letter before it.
    while cut > 0 and (text:byte(cut + 1) or 0) >= 128 and (text:byte(cut + 1) or 0) < 192 do cut = cut - 1 end
    return (text:sub(1, cut):gsub("%s+$", ""))
end

-- "Name Surname (Class) - Realm", cut to fit a profile name: Forever gives
-- the surname apart, and it tells two characters of one first name apart. On
-- a character's very first login the game may not know its name yet: nil
-- then, unless a name is needed now anyway.
local function OwnName(anyway)
    local name, surname
    if UnitName then name, surname = UnitName("player") end
    if type(name) ~= "string" or name == "" or name == UNKNOWN then
        if not anyway then return nil end
        name = UNKNOWN
    elseif not (issecretvalue and issecretvalue(surname)) and type(surname) == "string" and surname ~= "" then
        name = name .. " " .. surname
    end
    local class = UnitClass and UnitClass("player") or UNKNOWN
    local realm = GetRealmName and GetRealmName() or ""
    if realm == "" then return Cut(("%s (%s)"):format(name, class), ns.PROFILE_MAX) end
    return Cut(("%s (%s) - %s"):format(name, class, realm), ns.PROFILE_MAX)
end

-- The name itself if it's free, otherwise with a number after it, cut
-- shorter where needed so it still fits.
local function FreeName(name)
    local profiles, candidate, n = Profiles(), name, 1
    while profiles[candidate] do
        n = n + 1
        local suffix = " " .. n
        candidate = Cut(name, ns.PROFILE_MAX - #suffix) .. suffix
    end
    return candidate
end

-- Works out this character's profile, making its own on its first login (or
-- using the one chosen for every character). A new profile waits until the
-- game knows the character's name, at login at the latest ("final").
function ns.ResolveProfile(final)
    if active then return true end
    local guid = db and PlayerGUID()
    if not guid then return false end
    local profiles, chars = Profiles(), Chars()
    local name = chars[guid]
    if not profiles[name] and Everyone() then
        name = Everyone()
        chars[guid] = name
    elseif not profiles[name] then
        local own = OwnName(final)
        if not own then return false end
        name = FreeName(own)
        profiles[name] = {}
        chars[guid] = name
    end
    Lists(profiles[name])
    active = name
    return true
end

function ns.ProfileName()
    return active
end

function ns.ProfileNames()
    local names = {}
    if not db then return names end
    for name in pairs(Profiles()) do names[#names + 1] = name end
    table.sort(names, function(a, b)
        if a:lower() ~= b:lower() then return a:lower() < b:lower() end
        return a < b
    end)
    return names
end

-- How many characters use a profile.
function ns.ProfileUsers(name)
    local count = 0
    for _, used in pairs(db and Chars() or {}) do
        if used == name then count = count + 1 end
    end
    return count
end

local function Blocked()
    if InCombatLockdown() then return "Profiles can't change in combat." end
    if not active then return "Your profile hasn't loaded yet." end
end

local function CleanName(text)
    local name = type(text) == "string" and text:match("^%s*(.-)%s*$") or ""
    if name == "" then return nil, "Type a profile name first." end
    if #name > ns.PROFILE_MAX then return nil, "Profile names can be up to " .. ns.PROFILE_MAX .. " characters." end
    if name:find("[%c|]") then return nil, "Profile names can't use the | character." end
    return name
end

local function Switch(name)
    Chars()[PlayerGUID()] = name
    active = name
    if ns.Pulse and ns.Pulse.started then ns.Pulse:Apply() end
end

function ns.UseProfile(name)
    local why = Blocked()
    if why then return false, why end
    if not Profiles()[name] then return false, ('No profile is called "%s".'):format(tostring(name)) end
    if name == active then return true, "You're already using " .. name .. "." end
    Switch(name)
    return true, "Now using " .. name .. "."
end

local function Create(text, copy)
    local why = Blocked()
    if why then return false, why end
    local name, problem = CleanName(text)
    if not name then return false, problem end
    if Profiles()[name] then return false, name .. " already exists." end
    local from, profile = Profiles()[active], {}
    for field in pairs(PULSE_LISTS) do
        profile[field] = {}
        for key, value in pairs(copy and from[field] or {}) do profile[field][key] = value end
    end
    Profiles()[name] = profile
    Switch(name)
    return true, (copy and "Copied your ticks to " or "Made ") .. name .. ", and switched to it."
end

-- A new, empty profile.
function ns.NewProfile(text)
    return Create(text, false)
end

-- A new profile starting with this character's ticks.
function ns.CopyProfile(text)
    return Create(text, true)
end

-- The profile chosen for every character, if any.
function ns.EveryoneProfile()
    return db and Everyone()
end

-- This character's profile for every character, and for any made later.
-- Each one only lists its own spells from it.
function ns.UseOnAll()
    local why = Blocked()
    if why then return false, why end
    local chars = Chars()
    for guid in pairs(chars) do chars[guid] = active end
    db.everyone = active
    return true, "All your characters use " .. active .. " now, and new ones will too."
end

-- Whether every character known uses this profile, as chosen for them all.
function ns.OnAll(name)
    if name == nil or name ~= ns.EveryoneProfile() then return false end
    for _, used in pairs(Chars()) do
        if used ~= name then return false end
    end
    return true
end

-- Gives this character's profile a new name, for every character using it.
local function Rename(name)
    local profiles, chars = Profiles(), Chars()
    profiles[name], profiles[active] = profiles[active], nil
    for guid, used in pairs(chars) do
        if used == active then chars[guid] = name end
    end
    if db.everyone == active then db.everyone = name end
    active = name
end

function ns.RenameProfile(text)
    local why = Blocked()
    if why then return false, why end
    local name, problem = CleanName(text)
    if not name then return false, problem end
    if name == active then return true, "That's already its name." end
    if Profiles()[name] then return false, name .. " already exists." end
    Rename(name)
    return true, "Renamed to " .. name .. "."
end

-- A profile made before the game knew the character's name ("Unknown
-- (Paladin)") takes the name, while it's still that character's alone.
function ns.NameUnknownProfile()
    local own = OwnName()
    if not (active and own) or active == own or Profiles()[own] then return false end
    local prefix = UNKNOWN .. " ("
    if active:sub(1, #prefix) ~= prefix or ns.ProfileUsers(active) ~= 1 then return false end
    Rename(own)
    return true
end

-- Whether a profile can be deleted now: true, its name and how many other
-- characters use it, or false and why. The exact name is looked up first.
function ns.CanDeleteProfile(text)
    local why = Blocked()
    if why then return false, why end
    local name = type(text) == "string" and Profiles()[text] and text
    if not name then
        local problem
        name, problem = CleanName(text)
        if not name then return false, problem end
        if not Profiles()[name] then return false, ('No profile is called "%s".'):format(name) end
    end
    local me, others = PlayerGUID(), 0
    for guid, used in pairs(Chars()) do
        if used == name and guid ~= me then others = others + 1 end
    end
    return true, name, others
end

-- Deletes the named profile. Other characters that used it, even ones since
-- deleted, are let go of: at their next login they get a profile as a new
-- character would. Deleting your own leaves you on a new, empty profile of
-- your own.
function ns.DeleteProfile(text)
    local ok, name = ns.CanDeleteProfile(text)
    if not ok then return false, name end
    local profiles, chars = Profiles(), Chars()
    profiles[name] = nil
    for guid, used in pairs(chars) do
        if used == name then chars[guid] = nil end
    end
    if db.everyone == name then db.everyone = nil end
    if name == active then
        local fresh = FreeName(OwnName(true))
        profiles[fresh] = Lists({})
        Switch(fresh)
        return true, "Deleted " .. name .. ". You're now on " .. fresh .. "."
    end
    return true, "Deleted " .. name .. "."
end

-- One of the pulse's lists in this character's profile (repaired with the
-- rest of it), or a stand-in until the character is known.
local function PulseList(field)
    local store = active and db and Profiles()[active] or scratch
    if type(store[field]) ~= "table" then store[field] = {} end
    return store[field]
end

-- The spells (by name) and items (by key) you ticked -> true. Every spell you
-- know with a cooldown is listed, and your items; none pulses until it's
-- ticked (new ones show as you learn them, and you choose).
function ns.PulsePicks()
    return PulseList("pulsePick")
end

function ns.SetPulsePick(key, pick)
    if not db or type(key) ~= "string" or key == "" then return end
    ns.PulsePicks()[key] = pick and true or nil
end

-- The spells and items switched to the Long style, by key -> "long".
-- Everything else is Quick.
function ns.PulseStyles()
    return PulseList("pulseStyle")
end

function ns.SetPulseStyle(key, style)
    if not db or type(key) ~= "string" or key == "" then return end
    ns.PulseStyles()[key] = style == "long" and "long" or nil
end

-- Changes ---------------------------------------------------------------------------
-- Everything lives in the saved settings, which the game writes at logout and
-- on a reload; a change only needs the window redrawn. The pulse switched on
-- or off is told to Forever Enhanced Cooldown Manager too (Link.lua).

function ns.Set(key, value)
    if not db then return end
    db[key] = value
    if key == "pulse" and ns.Link then ns.Link:Changed() end
    if ns.window and ns.window:IsShown() then ns.window:Refresh() end
end

-- What's new: the version whose notes were last shown, or passed over on a
-- first install.
function ns.NotesSeen()
    return db and type(db.notesSeen) == "string" and db.notesSeen or nil
end

function ns.SetNotesSeen(version)
    if not db then return end
    db.notesSeen = version
end

-- The ? in the window's title bar: clicked at least once, on any character.
-- Until then it pulses and a note points it out (Window.lua).
function ns.HelpSeen()
    return db ~= nil and db.helpSeen == true
end

function ns.SetHelpSeen()
    if not db then return end
    db.helpSeen = true
end

-- Escape closes the /fecp window and What's new through the game's own list
-- of windows Escape closes (UISpecialFrames), never by changing key bindings:
-- a binding changed from addon code has the game rebuild your action bars
-- and state inside the addon's code, which then breaks on your hidden health
-- (thousands of errors, 2026-10-06). The game reads that list inside a
-- securecall, so the entries stay out of the rest of its Escape handling.
-- One Escape closes every listed window that's open; a tour ends as its
-- window closes (Tour.lua). Like the game's own windows on that list, they
-- also close whenever the game closes all windows: the interface coming
-- back after Alt+Z (the game's Escape brings it back first), a loading
-- screen, death, losing control of your character, or a centre or full
-- screen panel of the game's opening (Edit Mode, Help).
local escapeListed = {}
function ns.CloseOnEscape(frame)
    local name = frame and frame:GetName()
    if not name or escapeListed[name] or type(UISpecialFrames) ~= "table" then return end
    escapeListed[name] = true
    table.insert(UISpecialFrames, name)
end

-- Options > AddOns ------------------------------------------------------------------

local function BuildOptionsEntry()
    if not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then return end
    local canvas = CreateFrame("Frame")
    local title = canvas:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(ns.TITLE)
    local about = canvas:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    about:SetWidth(560)
    about:SetJustifyH("LEFT")
    about:SetText("A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings.")
    local open = CreateFrame("Button", nil, canvas, "UIPanelButtonTemplate")
    open:SetSize(160, 24)
    open:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -14)
    open:SetText("Open settings")
    open:SetScript("OnClick", function() if ns.ShowWindow then ns.ShowWindow() end end)
    local category = Settings.RegisterCanvasLayoutCategory(canvas, ns.TITLE)
    Settings.RegisterAddOnCategory(category)
end

-- Startup -------------------------------------------------------------------------

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")

local function Load()
    ForeverEnhancedCooldownPulseDB = type(ForeverEnhancedCooldownPulseDB) == "table" and ForeverEnhancedCooldownPulseDB or {}
    db = ForeverEnhancedCooldownPulseDB
    -- An empty settings file: the addon's first login on this account.
    ns.firstInstall = next(db) == nil
    if db.helpSeen ~= true then db.helpSeen = nil end -- the ? clicked once: true, or not saved at all
    -- Everything saved is checked and repaired now, before anything uses it.
    RepairProfiles()
    ns.ResolveProfile()

    SLASH_FECP1 = "/fecp"
    SlashCmdList.FECP = function(msg)
        msg = type(msg) == "string" and msg:lower() or ""
        if msg:match("^%s*new%s*$") and ns.ShowNotes then
            ns.ShowNotes()
        elseif msg:match("^%s*tour%s*$") and ns.Tour then
            ns.Tour:Start()
        elseif msg:match("^%s*discord%s*$") and ns.ShowDiscord then
            ns.ShowDiscord()
        elseif msg:match("^%s*debug%s*$") and ns.ShowDebug then
            ns.ShowDebug()
        elseif ns.Toggle then
            ns.Toggle()
        end
    end
    BuildOptionsEntry()

    if ns.Link then ns.Link:Start() end
    if ns.Pulse then ns.Pulse:Start() end
    if ns.MinimapButton then ns.MinimapButton:Start() end
    if ns.Notes then ns.Notes:Start() end
end

loader:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" then
        if name ~= ADDON then return end
        self:UnregisterEvent("ADDON_LOADED")
        Load()
    elseif event == "PLAYER_LOGIN" and db then
        self:UnregisterEvent("PLAYER_LOGIN")
        -- In case the character, or its name, wasn't known yet when the
        -- settings loaded.
        if not active and ns.ResolveProfile(true) and ns.Pulse and ns.Pulse.started then ns.Pulse:Apply() end
        if ns.NameUnknownProfile() and ns.window and ns.window:IsShown() then ns.window:Refresh() end
    end
end)
