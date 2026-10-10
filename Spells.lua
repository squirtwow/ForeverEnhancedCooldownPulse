-- Everything the pulse can list, one entry each: your spells at their highest
-- known rank, your trinkets, healthstones and potions whatever their rank,
-- and usable items in your bags. Ticks and styles store each entry's key (a
-- spell name, "item:<id>", "slot:<n>" or "family:<name>"), so training a new
-- rank, swapping a trinket or carrying a better potion carries on without
-- any change to what's saved. Read when something wants it, once your
-- spells, gear or level change or a loading screen ends (Pulse.lua), as the
-- /fecp window opens, and as the pulse takes over from Forever Enhanced
-- Cooldown Manager (S:Stale).
local _, ns = ...

local S = {}
ns.Spells = S

local BANK = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0
local ITEM = Enum and Enum.SpellBookItemType or {}
local TRINKETS = { 13, 14 }
local BAGS = 4

-- Healthstones and potions come in ranks, and you carry whichever you have:
-- a family is one entry for every rank of one, showing the best you carry.
-- Item IDs from the Forever client's own item tables (build 1.60.1.70009),
-- weakest first by what each restores, as Forever Enhanced Cooldown
-- Manager lists them. A rank's twins sit beside it: Improved Healthstone's,
-- the conjured Perishable potions (after the plain ones, so they show first:
-- they don't last), and the battleground and other same-named ones.
-- Discolored and Restored potions work differently, so they stay single items.
local FAMILIES = {
    { key = "family:healthstone", name = "Healthstones", items = {
        19004, 5512, 19005, -- Minor
        19006, 5511, 19007, -- Lesser
        19008, 5509, 19009, -- Healthstone
        19010, 5510, 19011, -- Greater
        19012, 9421, 19013, -- Major
    } },
    { key = "family:healing", name = "Healing Potions", items = {
        118, 268881, -- Minor
        858, 268882, -- Lesser
        929, 268883, -- Healing Potion
        1710, 223914, -- Greater
        3928, 18839, -- Superior, Combat Healing Potion
        13446, 223913, -- Major
    } },
    { key = "family:mana", name = "Mana Potions", mana = true, items = {
        2455, 3385, 3827, 6149, -- Minor, Lesser, Mana Potion, Greater
        13443, 18841, -- Superior, Combat Mana Potion
        13444, -- Major
    } },
}
S.FAMILIES = FAMILIES
-- Mana Potions are only offered to classes with mana.
local NO_MANA = { WARRIOR = true, ROGUE = true }

local familyOf = {}
for _, family in ipairs(FAMILIES) do
    for _, id in ipairs(family.items) do familyOf[id] = family end
end
-- The item each family showed last, kept over each scan: what it shows while
-- the game hides your bags in a fight, or once you carry none.
local shown = {}

local list, byKey = {}, {}

local function Open(value)
    return not (issecretvalue and issecretvalue(value))
end

local function Text(value)
    return type(value) == "string" and Open(value) and value ~= "" and value or nil
end

local function Add(entry)
    if byKey[entry.key] then return byKey[entry.key] end
    byKey[entry.key] = entry
    list[#list + 1] = entry
    return entry
end

-- Each spell once, by name, at the highest rank you know. Passives and
-- spells not learned yet are passed over.
local function ScanSpellbook()
    if not (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines) then return end
    for line = 1, C_SpellBook.GetNumSpellBookSkillLines() or 0 do
        local info = C_SpellBook.GetSpellBookSkillLineInfo(line)
        if info and not info.shouldHide and (info.offSpecID or 0) == 0 then
            local first = (info.itemIndexOffset or 0) + 1
            local last = (info.itemIndexOffset or 0) + (info.numSpellBookItems or 0)
            for index = first, last do
                local kind = C_SpellBook.GetSpellBookItemType(index, BANK)
                if kind ~= ITEM.FutureSpell and kind ~= ITEM.Flyout then
                    local item = C_SpellBook.GetSpellBookItemInfo(index, BANK)
                    local name = item and Text(item.name)
                    local spellID = item and (item.spellID or item.actionID)
                    if name and spellID and not item.isPassive then
                        local rank = tonumber((Text(item.subName) or ""):match("%d+")) or 0
                        local entry = byKey[name] or Add({ key = name, name = name, kind = "spell", rank = -1 })
                        if rank >= entry.rank then
                            entry.spellID, entry.icon, entry.rank = spellID, item.iconID, rank
                        end
                    end
                end
            end
        end
    end
end

local function ItemName(itemID, link)
    local name = Text(link) and link:match("%[(.-)%]")
    if not name and C_Item and C_Item.GetItemNameByID then name = Text(C_Item.GetItemNameByID(itemID)) end
    return name or ("Item " .. itemID)
end

local function AddItem(itemID, link, icon)
    return Add({ key = "item:" .. itemID, name = ItemName(itemID, link), kind = "item", itemID = itemID,
        icon = icon or (C_Item.GetItemIconByID and C_Item.GetItemIconByID(itemID)) })
end

-- Moves a family on to the item it should show now: the best one you carry
-- and can use (a potion above your level can't be), else the best you carry,
-- else the one it showed before. Anything the game hides keeps it as it is.
-- True when anything changed.
function S:Pick(entry)
    local family = entry and entry.family
    if not family then return false end
    local best, carried
    for i = #family.items, 1, -1 do
        local id = family.items[i]
        local count = C_Item.GetItemCount(id, false, true)
        if not Open(count) then return false end
        if type(count) == "number" and count > 0 then
            local usable = C_Item.IsUsableItem(id)
            if not Open(usable) then return false end
            carried = carried or id
            if usable then
                best = id
                break
            end
        end
    end
    local have = carried ~= nil
    best = best or carried or entry.itemID
    if best == entry.itemID and have == entry.have then return false end
    shown[entry.key] = best
    entry.itemID, entry.have = best, have
    entry.icon = C_Item.GetItemIconByID and C_Item.GetItemIconByID(best) or entry.icon
    return true
end

-- Whether you carry any of a bag item, or any rank of a healthstone or potion
-- family: true or false, or nil while the game won't say. An item worn (a
-- cloak with a use, say) counts as carried. Only asked of bag items and
-- families; trinkets are worn.
function S:Carries(entry)
    local ids
    if entry and entry.kind == "family" then
        ids = entry.family.items
    elseif entry and entry.kind == "item" then
        ids = { entry.itemID }
    else
        return nil
    end
    for _, id in ipairs(ids) do
        local count = C_Item.GetItemCount(id, false, true)
        if not (Open(count) and type(count) == "number") then return nil end
        if count > 0 then return true end
    end
    if entry.kind == "item" and C_Item.IsEquippedItem then
        local worn = C_Item.IsEquippedItem(entry.itemID)
        if not Open(worn) then return nil end
        if worn then return true end
    end
    return false
end

local function AddFamily(family)
    local itemID = shown[family.key] or family.items[1]
    local entry = Add({ key = family.key, name = family.name, kind = "family", family = family, itemID = itemID,
        icon = C_Item.GetItemIconByID and C_Item.GetItemIconByID(itemID) })
    S:Pick(entry)
    return entry
end

-- Food, drink and recipes can be used but never have a cooldown to show.
local RECIPE, CONSUMABLE, FOOD_AND_DRINK = 9, 0, 5
local function NoCooldown(itemID)
    if not (C_Item and C_Item.GetItemInfoInstant) then return false end
    local _, _, _, _, _, classID, subclassID = C_Item.GetItemInfoInstant(itemID)
    return classID == RECIPE or (classID == CONSUMABLE and subclassID == FOOD_AND_DRINK)
end

-- Your two trinket slots, whatever is in them, the healthstone and potion
-- families, then usable items in your bags.
local function ScanItems()
    for index, slot in ipairs(TRINKETS) do
        local itemID = GetInventoryItemID("player", slot)
        if itemID then
            local link = GetInventoryItemLink("player", slot)
            Add({ key = "slot:" .. slot, name = "Trinket " .. index .. ": " .. ItemName(itemID, link), kind = "slot",
                slot = slot, itemID = itemID, icon = GetInventoryItemTexture("player", slot) })
        end
    end
    local _, class = UnitClass("player")
    for _, family in ipairs(FAMILIES) do
        if not (family.mana and NO_MANA[class]) then AddFamily(family) end
    end
    if not (C_Container and C_Container.GetContainerNumSlots) then return end
    for bag = 0, BAGS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            local itemID = info and info.itemID
            if itemID and not byKey["item:" .. itemID] and C_Item.GetItemSpell(itemID) and not NoCooldown(itemID) then
                AddItem(itemID, info.hyperlink, info.iconFileID)
            end
        end
    end
end

-- The list is only read when something wants it: after your spellbook, gear
-- or level change, a loading screen, a ticked bag item comes back, the /fecp
-- window opens or the pulse takes over (S:Stale) it waits, and is read again
-- the next time anything looks in it. With the pulse off (or running in Forever Enhanced
-- Cooldown Manager) and /fecp shut, nothing does, so it's never read at all.
-- Your bags changing alone doesn't mark it (unless /fecp is open, whose list
-- shows them): the pulse looks at its items again itself (Pulse.lua,
-- P:Restock). As Forever Enhanced Cooldown Manager's list does.
local stale, reads = true, 0

function S:Scan()
    stale, reads = false, reads + 1
    wipe(list)
    wipe(byKey)
    ScanSpellbook()
    ScanItems()
    return list
end

local function Ready()
    if stale then S:Scan() end
end

-- Something the list holds may have changed: it's read again when next wanted.
function S:Stale()
    stale = true
end

-- How many times the list has been read, and whether it may hold something
-- new since the read-th time: read again since, or waiting to be.
function S:Reads()
    return reads
end

function S:Changed(read)
    return stale or reads ~= read
end

-- The list, read again first if anything changed since.
function S:Fresh()
    Ready()
    return list
end

-- The list as last read, even if something has changed since. For the tests.
function S:List()
    return list
end

function S:Find(key)
    Ready()
    return byKey[key]
end

-- The healthstone or potion family an item is a rank of, if any.
function S:Family(itemID)
    return Open(itemID) and itemID ~= nil and familyOf[itemID] or nil
end
