-- The words the addon shows, in English or another language. The English
-- stays in the code and is the key: ns.L["Take the tour"] is the text in the
-- language showing, and the English itself wherever there's nothing for it.
-- Each other language is a file of its own in Locales\, loaded just after
-- this one: ns.LOCALES.deDE = { ["Take the tour"] = "...", ... }. The
-- Language page picks one: Auto (the default) follows the game's language
-- where there's a file for it and is English on any other game, or one by
-- hand. Core.lua applies it as the saved settings load, so nothing the files
-- make as they load is in it: tables of names keep their English, looked up
-- where they show. Only what players read is here: spell and item names come
-- from the game already in its language; settings, commands, links and the
-- debug report (for us) stay as they are. Tools/TestLocale.mjs checks every
-- word looked up is in every language's file.
local _, ns = ...

-- Each language but English: its text by the English, from its own file.
local LANGUAGES = {}
ns.LOCALES = LANGUAGES

-- The language showing, and its text.
local language, showing = "enUS", {}

ns.L = setmetatable({}, { __index = function(_, english) return showing[english] or english end })

-- The choices on the Language page: the game's language, or one by hand.
ns.LANGUAGE_KEYS = { "auto", "enUS", "deDE", "frFR", "esES", "ptBR", "ruRU", "zhCN" }

-- Each language by its own name, never translated, so it can be found
-- whichever language is showing.
ns.LANGUAGE_NAMES = {
    enUS = "English",
    deDE = "Deutsch",
    frFR = "Français",
    esES = "Español",
    ptBR = "Português (Brasil)",
    ruRU = "Русский",
    zhCN = "简体中文",
}

-- The game's own languages Auto follows, and the file each shows: one
-- Spanish for Spain and Latin America. Any other game (English, Traditional
-- Chinese, Korean, Italian...) is English.
local GAME = { deDE = "deDE", frFR = "frFR", esES = "esES", esMX = "esES", ptBR = "ptBR", ruRU = "ruRU", zhCN = "zhCN" }

-- The language a choice shows: Auto follows the game's.
function ns.LanguageFor(choice)
    if choice == "enUS" or LANGUAGES[choice] then return choice end
    local game = GetLocale and GetLocale()
    local mapped = type(game) == "string" and GAME[game]
    return mapped and LANGUAGES[mapped] and mapped or "enUS"
end

-- Shows this language from now on: true if it's a change.
function ns.UseLanguage(which)
    if not LANGUAGES[which] then which = "enUS" end
    if which == language then return false end
    language, showing = which, LANGUAGES[which] or {}
    return true
end

function ns.Language()
    return language
end

-- Sentences one after another: a space between them, but none in Chinese,
-- whose own full stops part them. Empty or missing ones are left out.
function ns.Join(...)
    local parts = {}
    for i = 1, select("#", ...) do
        local part = select(i, ...)
        if type(part) == "string" and part ~= "" then parts[#parts + 1] = part end
    end
    return table.concat(parts, language == "zhCN" and "" or " ")
end

-- A number the addon writes (a cooldown, the seconds a pulse shows for)
-- with the decimal mark of the language showing: a comma in German,
-- French, Spanish, Portuguese and Russian ("1,5 min"), a point in English
-- and Chinese. Never for a version number.
local COMMA = { deDE = true, frFR = true, esES = true, ptBR = true, ruRU = true }
function ns.Decimal(text)
    if not COMMA[language] then return text end
    return (tostring(text):gsub("(%d)%.(%d)", "%1,%2"))
end

-- Capitals, for headings and titles, in every language: the game's own
-- upper() only knows English letters, so the accented Latin and the
-- Cyrillic ones are done here too (é to É, ß to SS, я to Я). Chinese has
-- none. Each by its two bytes: the game's text is UTF-8.
local CAPITALS = { ["\195\159"] = "SS", ["\197\147"] = "\197\146" } -- ß, and œ to Œ
for byte = 0xA0, 0xBE do -- à to þ, but ÷
    if byte ~= 0xB7 then CAPITALS["\195" .. string.char(byte)] = "\195" .. string.char(byte - 0x20) end
end
for byte = 0xB0, 0xBF do CAPITALS["\208" .. string.char(byte)] = "\208" .. string.char(byte - 0x20) end -- а to п
for byte = 0x80, 0x8F do CAPITALS["\209" .. string.char(byte)] = "\208" .. string.char(byte + 0x20) end -- р to я
for byte = 0x90, 0x9F do CAPITALS["\209" .. string.char(byte)] = "\208" .. string.char(byte - 0x10) end -- ѐ to џ, ё among them

function ns.Upper(text)
    return (tostring(text):upper():gsub("[\195\197\208\209][\128-\191]", CAPITALS))
end
