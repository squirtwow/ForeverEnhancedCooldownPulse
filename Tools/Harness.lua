-- A mock of the game for the addon's tests, loaded with loadfile. The addon's
-- real files run in it, in the order the .toc loads them.
--
-- Blizzard's frames here are sealed, as the addon must leave them: writing
-- any key on one is a violation, and so is calling any method but a read
-- (Get..., Is...) or HookScript. The game's tooltip is the one the addon
-- may fill (the minimap button's). Secret values break on any use but being
-- handed on or asked issecretvalue. A cooldown's duration object breaks on
-- any look inside. Violations are recorded even when the addon catches the
-- error, and each test checks none were.
--
-- For the pulse: a spellbook (H.Book), trinkets, bags and item counts,
-- cooldowns on hold, the game's sounds, and Forever Enhanced Cooldown
-- Manager loaded or not, with its saved settings (H.Manager).
local H = {}

H.checks = 0
function H.Equal(actual, expected, label)
    H.checks = H.checks + 1
    if actual ~= expected then
        error(label .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

function H.True(value, label)
    H.checks = H.checks + 1
    if not value then error(label .. ": expected true, got " .. tostring(value), 2) end
end

-- The addon's files, in the TOC's order (Tools/TestRules.mjs checks they match).
H.FILES = { "Core.lua", "Link.lua", "Theme.lua", "Ranks.lua", "Spells.lua", "Pulse.lua", "PulsePage.lua", "ProfileMenu.lua",
    "Window.lua", "Tour.lua", "MinimapButton.lua", "Notes.lua", "Debug.lua" }
H.ADDON = "ForeverEnhancedCooldownPulse"
H.MANAGER = "ForeverEnhancedCooldownManager"

-- Secret values -------------------------------------------------------------------------

H.violations = {}
local function Violation(text)
    H.violations[#H.violations + 1] = text
end
H.Violation = Violation

local function Boom(what)
    return function()
        Violation("a secret value was " .. what)
        error("secret value " .. what, 2)
    end
end
H.SECRET = setmetatable({}, { __index = Boom("indexed"), __newindex = Boom("written into"), __eq = Boom("compared"),
    __lt = Boom("compared"), __le = Boom("compared"), __add = Boom("used in arithmetic"), __sub = Boom("used in arithmetic"),
    __mul = Boom("used in arithmetic"), __div = Boom("used in arithmetic"), __mod = Boom("used in arithmetic"),
    __pow = Boom("used in arithmetic"), __unm = Boom("used in arithmetic"), __concat = Boom("concatenated"),
    __len = Boom("measured"), __call = Boom("called"), __tostring = Boom("turned into text") })
local SECRET = H.SECRET
local function IsSecret(v) return rawequal(v, SECRET) end

-- A cooldown's duration object, as the game hands it over: secret in a
-- fight, so the addon may pass it on but never look inside.
local function Sealed(what)
    return function()
        Violation("the pulse " .. what .. " a cooldown's duration")
        error("the pulse " .. what .. " a cooldown's duration", 2)
    end
end
H.SEALED = setmetatable({}, { __index = Sealed("read"), __newindex = Sealed("wrote on"), __len = Sealed("measured"),
    __call = Sealed("called"), __tostring = Sealed("turned into text") })

-- Mock objects -----------------------------------------------------------------------------

local S = setmetatable({}, { __mode = "k" }) -- each object's state, never on the object
H.S = S
H.objects = {} -- everything made, oldest first
H.frames = {} -- frames made with CreateFrame
local Proto = {}
H.Proto = Proto
local blizzardCalling = false -- Blizzard's own code is running (not a hook of the addon's)

-- Whether the addon may call this on one of Blizzard's objects: reads and hooks only.
local function Allowed(_, key)
    if type(key) ~= "string" or not key:match("^[A-Z]") then return true end
    return key:match("^Get") ~= nil or key:match("^Is") ~= nil or key == "HookScript"
end

local function Name(obj)
    local s = S[obj]
    return s and (s.name or s.kind) or "?"
end

local function Record(obj, key, ...)
    local s = S[obj]
    s.last[key] = table.pack(...)
    s.calls[key] = (s.calls[key] or 0) + 1
end

local New
New = function(kind, parent)
    local obj = {}
    S[obj] = { kind = kind, parent = parent, shown = true, last = {}, calls = {}, scripts = {}, events = {}, points = {},
        width = 0, height = 0, alpha = 1, children = {} }
    H.objects[#H.objects + 1] = obj
    if parent and S[parent] then table.insert(S[parent].children, obj) end
    setmetatable(obj, {
        __index = function(_, key)
            local s = S[obj]
            if s.blizzard and not blizzardCalling and not Allowed(obj, key) then
                return function()
                    Violation("called " .. key .. " on Blizzard's " .. Name(obj))
                    error("called " .. key .. " on a Blizzard frame", 2)
                end
            end
            local method = Proto[key]
            if method then return method end
            if type(key) == "string" and key:match("^[A-Z]") then
                -- Anything else: recorded, the last call's arguments kept.
                return function(self, ...) Record(self, key, ...) end
            end
        end,
        __newindex = function(t, key, value)
            if S[t].sealed and not blizzardCalling then
                Violation("wrote key '" .. tostring(key) .. "' on Blizzard's " .. Name(t))
                error("wrote key '" .. tostring(key) .. "' on a Blizzard frame", 2)
            end
            rawset(t, key, value)
        end,
    })
    return obj
end
H.New = New

function H.Last(obj, method, i)
    local call = S[obj].last[method]
    return call and call[i or 1]
end

function H.Calls(obj, method)
    return S[obj].calls[method] or 0
end

-- Like the game: showing or hiding runs the frame's OnShow or OnHide.
local function Toggled(self, v)
    local s = S[self]
    local changed = s.shown ~= v
    s.shown = v
    if changed then
        local script = s.scripts[v and "OnShow" or "OnHide"]
        if script then script(self) end
    end
end
function Proto:Show() Toggled(self, true) end
function Proto:Hide() Toggled(self, false) end
function Proto:SetShown(v) Toggled(self, v and true or false) end
function Proto:IsShown() return S[self].shown end
-- Like the game: shown, and so is everything it sits in.
function Proto:IsVisible()
    local s = S[self]
    if not s.shown then return false end
    local parent = s.parent
    return parent == nil or S[parent] == nil or parent:IsVisible()
end
function Proto:SetScript(k, fn) S[self].scripts[k] = fn end
function Proto:GetScript(k) return S[self].scripts[k] end
-- Like the game: a hook runs after the script; setting a script drops hooks.
function Proto:HookScript(k, fn)
    local old = S[self].scripts[k]
    S[self].scripts[k] = function(...)
        if old then old(...) end
        local was = blizzardCalling
        blizzardCalling = false
        fn(...)
        blizzardCalling = was
    end
end
function Proto:RegisterEvent(e) S[self].events[e] = true end
function Proto:RegisterUnitEvent(e, unit) S[self].events[e] = unit or true end
function Proto:UnregisterEvent(e) S[self].events[e] = nil end
function Proto:UnregisterAllEvents() S[self].events = {} end
function Proto:GetObjectType() return S[self].kind end
function Proto:GetParent() return S[self].parent end
function Proto:GetName() return S[self].name end
function Proto:CreateTexture(_, layer)
    local t = New("Texture", self)
    S[t].layer = layer
    return t
end
function Proto:CreateFontString(_, layer, template)
    local text = New("FontString", self)
    S[text].template, S[text].layer = template, layer
    return text
end
-- The game refuses text on a string made with no template and given no font.
function Proto:SetText(t)
    local s = S[self]
    if s.kind == "FontString" and not s.template and not s.last.SetFontObject then error("FontString:SetText(): Font not set", 2) end
    s.text = t
end
function Proto:GetText() return S[self].text end
function Proto:SetPoint(...) table.insert(S[self].points, table.pack(...)) end
function Proto:ClearAllPoints() S[self].points = {} end
function Proto:SetAllPoints(rel) S[self].points = {}; S[self].all = rel or true end
function Proto:SetSize(w, h) S[self].width, S[self].height = w, h end
function Proto:SetWidth(w) S[self].width = w end
function Proto:SetHeight(h) S[self].height = h end
function Proto:GetWidth() return S[self].width end
function Proto:GetHeight() return S[self].height end
function Proto:GetSize() return S[self].width, S[self].height end
function Proto:GetVerticalScroll() return S[self].scroll or 0 end
function Proto:SetVerticalScroll(v) S[self].scroll = v end
function Proto:GetEffectiveScale() return 1 end
function Proto:GetLeft() return S[self].left end
function Proto:SetBackdropBorderColor(r, g, b, a) S[self].border = { r, g, b, a } end
function Proto:SetBackdropColor(r, g, b, a) S[self].backdrop = { r, g, b, a } end
function Proto:SetTextColor(r, g, b) S[self].colour = { r, g, b } end
function Proto:SetShadowColor(_, _, _, a) S[self].shadow = a end
function Proto:SetAlpha(a) S[self].alpha = a end
function Proto:GetAlpha() return S[self].alpha end
function Proto:GetCenter() return S[self].cx, S[self].cy end
function Proto:GetFrameLevel() return S[self].level or 1 end
function Proto:SetFrameLevel(level) S[self].level = level; Record(self, "SetFrameLevel", level) end
function Proto:SetFrameStrata(strata) S[self].strata = strata; Record(self, "SetFrameStrata", strata) end
function Proto:GetFrameStrata() return S[self].strata or "MEDIUM" end
function Proto:GetStringWidth()
    local text = S[self].text
    return type(text) == "string" and #text * 6 or 0
end
-- Wrapped text: about six units a letter, twelve a line.
function Proto:GetStringHeight()
    local s = S[self]
    return math.max(1, math.ceil(#(type(s.text) == "string" and s.text or "") * 6 / math.max(1, s.width))) * 12
end
function Proto:GetFont() return "font", 12, "" end
-- Like the game: a disabled button takes no click (its OnClick never runs).
function Proto:Click(button)
    local s = S[self]
    if s.enabled == false then return end
    s.scripts.OnClick(self, button or "LeftButton")
end
function Proto:SetEnabled(v) S[self].enabled = v and true or false end
function Proto:IsEnabled() return S[self].enabled ~= false end
function Proto:SetTexture(t) S[self].texture = t end
function Proto:GetTexture() return S[self].texture end
function Proto:SetTexCoord(...)
    local n = select("#", ...)
    assert(n == 4 or n == 8, "SetTexCoord takes 4 or 8 numbers")
    S[self].texCoord = { ... }
    Record(self, "SetTexCoord", ...)
end
function Proto:SetColorTexture(r, g, b, a) S[self].color = { r, g, b, a }; Record(self, "SetColorTexture", r, g, b, a) end
function Proto:SetVertexColor(r, g, b, a) S[self].tint = { r, g, b, a } end
function Proto:EnableMouse(v) S[self].mouse = v; Record(self, "EnableMouse", v) end
function Proto:IsMouseEnabled() return S[self].mouse == true end
-- Text boxes.
function Proto:SetFocus() S[self].focus = true end
function Proto:ClearFocus()
    local s = S[self]
    if s.focus and s.scripts.OnEditFocusLost then s.focus = false; s.scripts.OnEditFocusLost(self) end
    s.focus = false
end
function Proto:HasFocus() return S[self].focus == true end
-- Cooldowns. A cooldown set by times or by the game's duration object, and
-- Clear: as the game's may, it runs the done script.
function Proto:SetCooldown(start, duration)
    assert(type(start) == "number" and type(duration) == "number", "SetCooldown takes numbers")
    S[self].cooldown = { start, duration }
    S[self].durationObject = nil
    Record(self, "SetCooldown", start, duration)
end
function Proto:SetCooldownFromDurationObject(duration)
    S[self].durationObject = duration
    S[self].cooldown = nil
    Record(self, "SetCooldownFromDurationObject", duration)
end
function Proto:Clear()
    local s = S[self]
    s.cooldown, s.durationObject = nil, nil
    s.clears = (s.clears or 0) + 1
    Record(self, "Clear")
    if s.scripts.OnCooldownDone then s.scripts.OnCooldownDone(self) end
end
-- The game says a cooldown frame is done counting down.
function H.Done(cooldown)
    S[cooldown].scripts.OnCooldownDone(cooldown)
end

-- Seals an object and everything in it as Blizzard's.
local function Seal(obj)
    S[obj].sealed, S[obj].blizzard = true, true
    for _, child in ipairs(S[obj].children) do Seal(child) end
end
H.Seal = Seal

-- Events -------------------------------------------------------------------------------------

function H.Fire(event, ...)
    for _, frame in ipairs(H.frames) do
        if S[frame].events[event] and S[frame].scripts.OnEvent then S[frame].scripts.OnEvent(frame, event, ...) end
    end
end

-- Timers waiting, run all at once, as if that long had passed.
function H.RunTimers()
    local due = H.timers
    H.timers = {}
    for _, timer in ipairs(due) do timer() end
end

-- One frame of the game: the clock moves on, then every visible frame's
-- OnUpdate runs.
function H.Frame(elapsed)
    elapsed = elapsed or 1 / 60
    H.clock = H.clock + elapsed
    local list = H.frames
    for i = 1, #list do
        local frame = list[i]
        local script = S[frame].scripts.OnUpdate
        if script and frame:IsVisible() then script(frame, elapsed) end
    end
end

-- Fights begin and end as the game says.
function H.Combat(on)
    if on then
        H.Fire("PLAYER_REGEN_DISABLED")
        H.lockdown = true
    else
        H.lockdown = false
        H.Fire("PLAYER_REGEN_ENABLED")
    end
end

-- The game -------------------------------------------------------------------------------------

-- Who is logged in: a GUID tells characters apart, even with the same name.
H.character = { guid = "Player-1-0001", name = "Zriel", realm = "Zephras", class = "Druid", classFile = "DRUID" }

-- The spellbook: lines of spells, each { name, spellID, subName, iconID,
-- isPassive, future }. A druid with Moonfire (none), Barkskin and Bash (a
-- minute each), Walk on Air (a racial, two minutes) and Overpower (5 s),
-- a passive and a spell not learned yet.
function H.Book(lines)
    H.book = lines or {
        { name = "General", items = { { name = "Attack", spellID = 6603 },
            { name = "Walk on Air", subName = "Racial", spellID = 1259416, iconID = 1 } } },
        { name = "Balance", items = {
            { name = "Moonfire", subName = "Rank 1", spellID = 8921, iconID = 136096 },
            { name = "Moonfire", subName = "Rank 2", spellID = 8924, iconID = 136096 },
            { name = "Natural Weapons", spellID = 16902, isPassive = true },
            { name = "Starfire", spellID = 2912, future = true },
            { name = "Barkskin", spellID = 22812, iconID = 136097 },
            { name = "Bash", subName = "Rank 1", spellID = 5211, iconID = 132114 },
        } },
        { name = "Arms", items = { { name = "Overpower", subName = "Rank 1", spellID = 7384, iconID = 132223 } } },
    }
end
local function BookItem(index)
    for _, line in ipairs(H.book) do
        if index <= #line.items then return line.items[index] end
        index = index - #line.items
    end
end

-- Forever Enhanced Cooldown Manager: not there (nil), or loaded with these
-- saved settings, as its 1.5.0 is (it doesn't join the link).
function H.Manager(saved)
    H.addOns[H.MANAGER] = saved ~= nil
    _G.ForeverEnhancedCooldownManagerDB = saved
end

-- Blizzard's frames: UIParent and the minimap, sealed; the tooltip.
local function BuildBlizzardFrames()
    _G.UIParent = New("Frame")
    S[UIParent].name, S[UIParent].width, S[UIParent].height, S[UIParent].cx, S[UIParent].cy = "UIParent", 1366, 768, 500, 400
    _G.Minimap = New("Frame", UIParent)
    S[Minimap].name, S[Minimap].width, S[Minimap].height, S[Minimap].cx, S[Minimap].cy = "Minimap", 140, 140, 900, 700
    S[Minimap].level = 2
    for _, frame in ipairs({ UIParent, Minimap }) do Seal(frame) end
    -- The tooltip keeps its lines.
    _G.GameTooltip = New("Frame", UIParent)
    S[GameTooltip].name, S[GameTooltip].shown = "GameTooltip", false
    rawset(GameTooltip, "SetOwner", function(self) S[self].lines = {} end)
    rawset(GameTooltip, "AddLine", function(self, text) table.insert(S[self].lines, text) end)
end

local ADDON_GLOBALS = { "^FECP", "^SLASH_FECP", "^ForeverEnhancedCooldownPulseDB$", "^ForeverPulseLink$",
    "^ForeverEnhancedCooldownManagerDB$" }
local function Ours(key)
    if type(key) ~= "string" then return false end
    for _, pattern in ipairs(ADDON_GLOBALS) do
        if key:find(pattern) then return true end
    end
    return false
end

function H.Environment()
    -- Anything the addon made last time goes, as after a restart.
    for key in pairs(_G) do
        if Ours(key) then _G[key] = nil end
    end
    H.objects, H.frames, H.violations, H.timers, H.printed = {}, {}, {}, {}, {}
    H.lockdown, H.clock, H.bindings = false, 100, {}
    blizzardCalling = false
    _G.C_Timer = { After = function(_, fn) H.timers[#H.timers + 1] = fn end }
    _G.GetCursorPosition = function() return 0, 0 end
    _G.GetTime = function() return H.clock end
    _G.InCombatLockdown = function() return H.lockdown end
    _G.CreateColor = function(r, g, b, a) return { r = r, g = g, b = b, a = a or 1 } end
    _G.wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
    _G.print = function(msg) H.printed[#H.printed + 1] = msg end
    _G.issecretvalue = IsSecret
    _G.ReloadUI = function() error("the addon never reloads the interface") end
    _G.C_CVar = { SetCVar = function(name) Violation("changed the game setting " .. tostring(name)) end }
    _G.SetCVar = C_CVar.SetCVar
    -- The character (H.character, read as it is at each call).
    _G.UnitGUID = function(unit) if unit == "player" then return H.character.guid end end
    _G.UnitName = function(unit) if unit == "player" then return H.character.name, H.character.surname end end
    _G.UnitClass = function(unit) if unit == "player" then return H.character.class, H.character.classFile end end
    _G.GetRealmName = function() return H.character.realm end
    -- The spellbook.
    H.Book()
    _G.Enum = { SpellBookSpellBank = { Player = 0 }, SpellBookItemType = { Spell = 1, FutureSpell = 2, Flyout = 3 } }
    _G.C_SpellBook = {
        GetNumSpellBookSkillLines = function() return #H.book end,
        GetSpellBookSkillLineInfo = function(line)
            local offset = 0
            for i = 1, line - 1 do offset = offset + #H.book[i].items end
            return { name = H.book[line].name, itemIndexOffset = offset, numSpellBookItems = #H.book[line].items }
        end,
        GetSpellBookItemType = function(index) return BookItem(index).future and 2 or 1 end,
        GetSpellBookItemInfo = function(index) return BookItem(index) end,
    }
    -- Spells: the ones whose cooldowns were asked for, and those on hold
    -- (a cooldown that starts once its effect is used up). Like the game:
    -- the times secret, whether it's on hold never.
    H.asked, H.held = {}, {}
    _G.C_Spell = {
        GetSpellCooldownDuration = function(id, ignoreGCD)
            if ignoreGCD ~= true then Violation("asked for a cooldown with the global cooldown") end
            H.asked[#H.asked + 1] = id
            return H.SEALED
        end,
        GetSpellCooldown = function(id)
            return { isEnabled = not H.held[id], startTime = SECRET, duration = SECRET, modRate = SECRET }
        end,
        GetSpellTexture = function() return 1 end,
        GetSpellName = function() return nil end,
    }
    _G.GetSpellBaseCooldown = nil
    -- Gear and bags: trinkets worn (slot -> item ID) and their cooldowns
    -- (slot -> start, length, enable); bag items ({ itemID, hyperlink,
    -- iconFileID } in bag 0); how many of each you carry; every item's
    -- cooldown (one for all, as potions share theirs); items with a use
    -- (item ID -> its spell); items worn.
    H.worn, H.trinketCooldowns, H.bag, H.counts = {}, {}, {}, {}
    H.itemCooldown = { 0, 0, 1 }
    H.itemSpells = { [118] = "Healing Potion", [858] = "Healing Potion", [2455] = "Mana Potion", [5512] = "Healthstone",
        [117] = "Food", [2698] = "Learning", [9999] = "Lucky", [9998] = "Charm", [6948] = "Hearthstone" }
    H.itemNames = { [118] = "Minor Healing Potion", [2455] = "Minor Mana Potion", [9999] = "Lucky Charm", [9998] = "Second Charm",
        [9997] = "Plain Charm", [6948] = "Hearthstone" }
    _G.GetInventoryItemID = function(unit, slot) assert(unit == "player"); return H.worn[slot] end
    _G.GetInventoryItemLink = function(_, slot)
        local id = H.worn[slot]
        return id and ("|cff1eff00|Hitem:" .. id .. "|h[" .. (H.itemNames[id] or "Item") .. "]|h|r")
    end
    _G.GetInventoryItemTexture = function() return 777 end
    _G.GetInventoryItemCooldown = function(_, slot)
        local c = H.trinketCooldowns[slot] or { 0, 0, 1 }
        return c[1], c[2], c[3]
    end
    _G.C_Container = {
        GetContainerNumSlots = function(bag) return bag == 0 and #H.bag or 0 end,
        GetContainerItemInfo = function(bag, slot) if bag == 0 then return H.bag[slot] end end,
    }
    _G.C_Item = {
        GetItemSpell = function(id) return H.itemSpells[id] end,
        GetItemInfoInstant = function(id)
            local class = ({ [118] = { 0, 1 }, [117] = { 0, 5 }, [2698] = { 9, 0 } })[id] or { 15, 0 }
            return id, nil, nil, "", nil, class[1], class[2]
        end,
        GetItemCooldown = function() return H.itemCooldown[1], H.itemCooldown[2], H.itemCooldown[3] end,
        GetItemCount = function(id) return H.counts[id] or 0 end,
        IsUsableItem = function() return true, false end,
        IsEquippedItem = function(id) return id == H.worn[13] or id == H.worn[14] end,
        GetItemIconByID = function() return 888 end,
        GetItemNameByID = function(id) return H.itemNames[id] end,
    }
    -- Sounds played: each kit and channel.
    H.sounds = {}
    _G.PlaySound = function(kit, channel) H.sounds[#H.sounds + 1] = kit .. " " .. tostring(channel) end
    _G.CreateFrame = function(kind, name, parent, template)
        local f = New(kind, parent)
        S[f].name, S[f].template = name, template
        H.frames[#H.frames + 1] = f
        if name then _G[name] = f end
        return f
    end
    _G.GameFontHighlight = { GetFont = function() return "font", 12, "" end }
    _G.SlashCmdList = {}
    -- Which addons are loaded: H.addOns[name] (both answers, as the game
    -- gives them: loaded or loading, and loaded).
    H.addOns = {}
    _G.C_AddOns = { IsAddOnLoaded = function(name)
        local on = H.addOns[name] == true
        return on, on
    end }
    _G.IsAddOnLoaded = nil
    _G.ClearOverrideBindings = function(owner)
        if H.lockdown then Violation("changed a binding in combat") end
        H.bindings[owner] = nil
    end
    _G.SetOverrideBindingClick = function(owner, _, key, button)
        if H.lockdown then Violation("changed a binding in combat") end
        H.bindings[owner] = key .. ":" .. button
    end
    _G.Settings = {
        RegisterCanvasLayoutCategory = function(canvas, title) return { canvas = canvas, title = title } end,
        RegisterAddOnCategory = function(category) H.category = category end,
    }
    H.category = nil
    BuildBlizzardFrames()
    -- What was there before the addon loads, to find what it adds.
    H.before = {}
    for key in pairs(_G) do H.before[key] = true end
end

-- Loads the addon's files as the game does, then logs in (unless told not to).
function H.Load(saved, beforeLogin)
    local ns = {}
    _G.ForeverEnhancedCooldownPulseDB = saved
    for _, file in ipairs(H.FILES) do assert(loadfile(file))(H.ADDON, ns) end
    H.Fire("ADDON_LOADED", H.ADDON)
    if not beforeLogin then
        H.Fire("PLAYER_LOGIN")
        H.Fire("PLAYER_ENTERING_WORLD")
    end
    return ns
end

-- A fresh game, logged in with these saved settings (nil: a first install),
-- past the quiet after logging in, with the list read.
function H.Start(saved)
    H.Environment()
    local ns = H.Load(saved)
    H.Tick(ns)
    H.clock = H.clock + 5
    return ns
end

-- The next frame: what the pulse's events asked for is done now, once.
function H.Tick(ns)
    local driver = ns.Pulse.driver
    local work = S[driver].scripts.OnUpdate
    if work then work(driver, 0) end
end

-- The global names the addon has added since the environment was set up.
function H.NewGlobals()
    local added = {}
    for key in pairs(_G) do
        if not H.before[key] then added[#added + 1] = tostring(key) end
    end
    table.sort(added)
    return added
end

-- Everything that went wrong, as one line: rule violations and anything printed.
function H.Problems()
    local list = {}
    for _, v in ipairs(H.violations) do list[#list + 1] = v end
    for _, p in ipairs(H.printed) do list[#list + 1] = "printed: " .. tostring(p) end
    return table.concat(list, " | ")
end

-- Where things are ------------------------------------------------------------------------
-- Text in the game runs about seven units a letter in the window's usual
-- font. Counted at 7.5 here, 6.5 in the small font, and more for capitals,
-- to be sure, as Forever Enhanced Cooldown Manager's tests do. Places are
-- worked out from each frame's anchors as the game would: left, top, right
-- and bottom, y down from the window's top left.
function H.Wide(text, font)
    text = tostring(text or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", "XX")
    local small = type(font) == "string" and font:find("Small") ~= nil
    local capitals = text:find("%a") ~= nil and text == text:upper()
    local each = small and (capitals and 7.5 or 6.5) or (capitals and 9 or 7.5)
    return #text * each
end

-- Text is as wide as Wide says (in its room, where it's justified), and as
-- many lines tall as it wraps to; a tick is its box and label.
function H.Rect(obj, depth)
    depth = depth or 0
    assert(depth < 40, "anchors that go round in a circle")
    if obj == _G.FECPFrame then return 0, 0, S[obj].width, S[obj].height end
    local s = S[obj]
    if obj == UIParent or not s then return -10000, -10000, 10000, 10000 end
    if s.all then return H.Rect(s.all == true and s.parent or s.all, depth + 1) end
    local width, height, wide = s.width, s.height, nil
    if s.kind == "FontString" then
        wide = H.Wide(s.text, H.Last(obj, "SetFontObject") or s.template)
        if width == 0 then
            width = wide
        elseif wide > width and height == 0 then
            height = math.ceil(wide / width) * 12
        end
        if height == 0 then height = 12 end
    end
    if rawget(obj, "box") and rawget(obj, "text") then width, height = 18 + H.Wide(S[obj.text].text, S[obj.text].template), 16 end
    if #s.points == 0 then return H.Rect(s.parent, depth + 1) end
    local left, top, right, bottom, cx, cy
    for _, p in ipairs(s.points) do
        local point, relative, relativePoint, x, y = p[1], s.parent, p[1], p[2] or 0, p[3] or 0
        if type(p[2]) == "table" then point, relative, relativePoint, x, y = p[1], p[2], p[3] or p[1], p[4] or 0, p[5] or 0 end
        local rl, rt, rr, rb = H.Rect(relative, depth + 1)
        local ax = relativePoint:find("LEFT") and rl or relativePoint:find("RIGHT") and rr or (rl + rr) / 2
        local ay = relativePoint:find("TOP") and rt or relativePoint:find("BOTTOM") and rb or (rt + rb) / 2
        ax, ay = ax + x, ay - y
        if point:find("LEFT") then left = ax elseif point:find("RIGHT") then right = ax else cx = ax end
        if point:find("TOP") then top = ay elseif point:find("BOTTOM") then bottom = ay else cy = ay end
    end
    if not left and not right then left = cx - width / 2 end
    left = left or right - width
    right = right or left + width
    if not top and not bottom then top = cy - height / 2 end
    top = top or bottom - height
    bottom = bottom or top + height
    if wide and s.width > 0 and wide < right - left then
        local justify = H.Last(obj, "SetJustifyH") or "LEFT"
        if justify == "RIGHT" then
            left = right - wide
        elseif justify == "CENTER" then
            left, right = (left + right - wide) / 2, (left + right + wide) / 2
        else
            right = left + wide
        end
    end
    return left, top, right, bottom
end

function H.Inside(obj, root)
    local at = obj
    while at do
        if at == root then return true end
        at = S[at] and S[at].parent
    end
    return false
end

-- In a list that scrolls: cut off at its edge.
local function Scrolled(obj)
    local at = S[obj].parent
    while at and S[at] do
        if S[at].kind == "ScrollFrame" then return true end
        at = S[at].parent
    end
    return false
end

function H.Name(obj)
    local s = S[obj]
    if s.kind == "FontString" then return '"' .. tostring(s.text) .. '"' end
    if rawget(obj, "box") and rawget(obj, "text") then return "tick " .. tostring(S[obj.text].text) end
    if rawget(obj, "buttons") then return "choice " .. tostring(S[obj.buttons[1].label].text) .. "..." end
    if rawget(obj, "label") then return s.kind .. " " .. tostring(S[obj.label].text) end
    return s.kind
end

-- What can run into something else, where each shows: text (not a
-- button's or tick's own), ticks with their labels, buttons, choices, text
-- boxes and slider tracks, the thumb reaching 5 past each end.
local function Pieces(root)
    local list = {}
    for _, obj in ipairs(H.objects) do
        local s = S[obj]
        local parent = s.parent
        if obj ~= root and H.Inside(obj, root) and obj:IsVisible() and not Scrolled(obj) then
            local piece
            if s.kind == "FontString" then
                local own = parent and S[parent] and ((S[parent].kind == "Button" and rawget(parent, "label") == obj)
                    or (rawget(parent, "box") ~= nil and rawget(parent, "text") == obj))
                local inChoice = parent and S[parent] and S[parent].parent and rawget(S[parent].parent, "buttons") ~= nil
                piece = (s.text or "") ~= "" and not own and not inChoice
            elseif rawget(obj, "box") and rawget(obj, "text") then
                piece = true
            elseif rawget(obj, "buttons") and rawget(obj, "SetSelected") then
                piece = true
            elseif s.kind == "Button" and rawget(obj, "label") then
                piece = not (parent and rawget(parent, "buttons"))
            elseif s.kind == "EditBox" then
                piece = true
            elseif parent and rawget(parent, "track") == obj then
                piece = "track"
            end
            if piece then
                local l, t, r, b = H.Rect(obj)
                if piece == "track" then l, r = l - 5, r + 5 end
                list[#list + 1] = { l, t, r, b, obj = obj, name = H.Name(obj) }
            end
        end
    end
    return list
end

local function Below(a, b)
    local at = S[b].parent
    while at do
        if at == a then return true end
        at = S[at] and S[at].parent
    end
    return false
end

-- Every piece on a page inside it and none on another: "" when all fit.
function H.Problems2D(root)
    local list, found = Pieces(root), {}
    local rl, rt, rr, rb = H.Rect(root)
    for i, a in ipairs(list) do
        if a[1] < rl or a[3] > rr or a[2] < rt or a[4] > rb then found[#found + 1] = a.name .. " off the page" end
        for j = i + 1, #list do
            local b = list[j]
            if a[1] < b[3] and b[1] < a[3] and a[2] < b[4] and b[2] < a[4] and not Below(a.obj, b.obj) and not Below(b.obj, a.obj) then
                found[#found + 1] = a.name .. " on " .. b.name
            end
        end
    end
    return table.concat(found, "; ")
end

function H.Clear(a, b)
    local al, at, ar, ab = H.Rect(a)
    local bl, bt, br, bb = H.Rect(b)
    return not (al < br and bl < ar and at < bb and bt < ab)
end

-- The tour box showing, against the part it outlines and the page it's on:
-- nothing when it fits, or what's wrong. The box inside the page, the part
-- outlined there, and the box clear of the outline round it.
function H.BoxFits(page)
    local box = _G.FECPTour
    local o = S[box.outline].points
    local l, t = H.Rect(o[1][2])
    local _, _, r, b = H.Rect(o[2][2])
    l, t, r, b = l - 4, t - 4, r + 4, b + 4
    local bl, bt, br, bb = H.Rect(box)
    local pl, pt, pr, pb = H.Rect(page)
    local wrong = {}
    if bl < pl or bt < pt or br > pr or bb > pb then
        wrong[#wrong + 1] = ("box off the page (%g %g %g %g)"):format(bl - pl, bt - pt, br - pl, bb - pt)
    end
    if l + 4 < pl or t + 4 < pt or r - 4 > pr or b - 4 > pb then wrong[#wrong + 1] = "part off the page" end
    if bl < r and l < br and bt < b and t < bb then wrong[#wrong + 1] = "box on its part" end
    return table.concat(wrong, ", ")
end

-- A control's note, as the footer shows it.
function H.Note(control)
    local hint = control.hint
    if type(hint) == "function" then hint = hint(control) end
    return hint
end

return H
