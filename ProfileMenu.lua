-- The profile menu in the /fecp window's header: the profile this character
-- uses, and a panel under it listing every profile (click one to switch, or
-- its x to delete it after asking) with a box to type a name for New, Copy
-- or Rename. Profiles hold the pulse's ticks and which are Long only; the
-- rules live in Core.lua. Its words are in the language showing; the
-- profiles' names are their own.
local _, ns = ...
local T, L = ns.Theme, ns.L

local WIDTH, ROW = 300, 22
local LIST_ROWS = 8 -- profiles listed at once; more scroll
local LIST_WIDTH = WIDTH - 28 -- the list, clear of its scroll thumb

local function Users(name)
    if ns.OnAll(name) then return L["all characters"] end
    local count = ns.ProfileUsers(name)
    local mine = name == ns.ProfileName()
    if mine and count > 1 then return L["you + %d"]:format(count - 1) end
    if mine then return L["you"] end
    if count == 0 then return L["unused"] end
    return count == 1 and L["1 character"] or L["%d characters"]:format(count)
end

function ns.BuildProfileMenu(window, header, anchor)
    local button = T:Button(header, "", 280, 24)
    button:SetPoint("RIGHT", anchor, "LEFT", -8, 0)
    button.label:SetWidth(264)
    button.label:SetWordWrap(false)
    window:Hint(button, L["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."])
    window.profileButton = button

    local panel = CreateFrame("Frame", nil, window, "BackdropTemplate")
    panel:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, -4)
    panel:SetSize(WIDTH, 200) -- sized again on every refresh
    panel:SetFrameLevel(window:GetFrameLevel() + 60)
    panel:SetClampedToScreen(true)
    T:Flat(panel, T.PANEL, T.CONTROL_BORDER)
    panel:EnableMouse(true)
    panel:Hide()
    window.profilePanel = panel
    T:Heading(panel, L["Profiles"]):SetPoint("TOPLEFT", 10, -10)

    -- The profiles scroll in a list of up to LIST_ROWS, so however many there
    -- are, the name box and buttons under it stay in reach. Pinned by two
    -- corners, again a moment after the menu opens (see the bar page).
    local list = T:Scroll(panel, LIST_WIDTH)
    local tall = 1 -- rows the list is tall enough for
    local function Pin()
        list:ClearAllPoints()
        list:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -28)
        list:SetPoint("BOTTOMRIGHT", panel, "TOPLEFT", 10 + LIST_WIDTH, -(28 + tall * ROW))
        list:ScrollTo(list:GetVerticalScroll() or 0)
    end
    Pin()
    panel:HookScript("OnShow", function() C_Timer.After(0, Pin) end)
    window:Hint(list.thumb, ns.ScrollNote())
    window.profileList = list

    -- Deleting asks first, in the window's own dialog, saying what happens to
    -- any other character using it: at its next login it gets a profile as a
    -- new character would, even one since deleted that only left its name.
    local function Ask(name)
        local ok, why, others = ns.CanDeleteProfile(name)
        if not ok then
            window:Say(why)
            return window:Refresh()
        end
        local mine = name == ns.ProfileName()
        local yours = mine and L["You're using it, so you'll move to a new, empty profile of your own."] or nil
        local theirs
        if others > 0 then
            local everyone = ns.EveryoneProfile()
            local loads = everyone and everyone ~= name and everyone
            if others == 1 then
                theirs = loads and L["Another character uses it, and loads %s at its next login."]:format(loads)
                    or L["Another character uses it, and gets a new, empty profile of its own at its next login."]
            else
                theirs = loads and L["%d other characters use it, and each loads %s at its next login."]:format(others, loads)
                    or L["%d other characters use it, and each gets a new, empty profile of its own at its next login."]:format(others)
            end
        end
        window:Ask(L['Delete "%s"?']:format(name), ns.Join(yours, theirs, L["This can't be undone."]), L["Delete"], function()
            local done, message = ns.DeleteProfile(name)
            window:Say(message)
            -- Deleting your own profile moves you, so the menu closes as for any switch.
            if done and mine then panel:Hide() end
            window:Refresh()
        end)
    end

    local rows = {}
    local function Row(i)
        if rows[i] then return rows[i] end
        local row = CreateFrame("Button", nil, list.content)
        row:SetSize(LIST_WIDTH, ROW - 2)
        row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW)
        row.fill = row:CreateTexture(nil, "BACKGROUND")
        row.fill:SetAllPoints()
        T:Fill(row.fill, T.SELECTED)
        row.mark = row:CreateTexture(nil, "ARTWORK")
        row.mark:SetPoint("TOPLEFT")
        row.mark:SetPoint("BOTTOMLEFT")
        row.mark:SetWidth(3)
        T:Paint(row.mark, function(accent) T:Fill(row.mark, accent) end)
        local hover = row:CreateTexture(nil, "HIGHLIGHT")
        hover:SetAllPoints()
        hover:SetColorTexture(1, 1, 1, .05)
        row.name = T:Text(row, "GameFontHighlight")
        row.name:SetPoint("LEFT", 10, 0)
        row.name:SetWidth(160)
        row.name:SetWordWrap(false)
        row.remove = T:Square(row, "x")
        row.remove:SetSize(16, 16)
        row.remove:SetPoint("RIGHT", -2, 0)
        row.remove:SetScript("OnClick", function() Ask(row.profile) end)
        row.users = T:Text(row, "GameFontHighlightSmall", T.MUTED)
        row.users:SetPoint("RIGHT", row.remove, "LEFT", -8, 0)
        row.users:SetJustifyH("RIGHT")
        row:SetScript("OnClick", function(self)
            local ok, message = ns.UseProfile(self.profile)
            window:Say(message)
            if ok then panel:Hide() end
            window:Refresh()
        end)
        window:Hint(row, function()
            return row.profile == ns.ProfileName() and L["The profile you're on."] or L["Switch to %s."]:format(row.profile)
        end)
        window:Hint(row.remove, function() return L["Delete %s. It asks first."]:format(row.profile) end)
        rows[i] = row
        return row
    end

    -- Placed now as for one profile, then moved under the list on refresh, so
    -- nothing is ever laid out without a place.
    local input = T:Input(panel, L["Profile name"], WIDTH - 20)
    input:SetPoint("TOPLEFT", 10, -54)
    window:Hint(input, L["A name for New, Copy or Rename."])
    window.profileInput = input
    local hint = T:Text(panel, "GameFontHighlightSmall", T.MUTED)
    hint:SetPoint("TOPLEFT", 10, -136)
    hint:SetWidth(WIDTH - 20)
    hint:SetText(L["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. "
        .. "Any class can share a profile: each character only lists its own spells."])

    -- The profile you're on, for every character and any made later.
    local everyone = T:Button(panel, L["Use on all characters"], WIDTH - 20, 22)
    everyone:SetPoint("TOPLEFT", 10, -106)
    everyone:SetScript("OnClick", function()
        local name = ns.ProfileName()
        if not name then return end
        if ns.OnAll(name) then
            window:Say(L["All your characters already use %s."]:format(name))
            return window:Refresh()
        end
        window:Ask(L['Use "%s" on all characters?']:format(name),
            L["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."],
            L["Use on all"], function()
                local _, message = ns.UseOnAll()
                window:Say(message)
                panel:Hide()
                window:Refresh()
            end)
    end)
    window:Hint(everyone, function()
        return ns.OnAll(ns.ProfileName()) and L["All your characters use this profile, and new ones will too."]
            or L["Loads the profile you're on for every character. Each one only lists its own spells and items."]
    end)
    window.profileEveryone = everyone

    -- Each button acts on the typed name. Every one of them leaves you on a
    -- different profile or name, so the menu closes once it has worked.
    local function Act(action)
        return function()
            local ok, message = action(input:GetText())
            window:Say(message)
            if ok then
                input:SetText("")
                input:ClearFocus()
                input.placeholder:Show()
                panel:Hide()
            end
            window:Refresh()
        end
    end
    local buttons = {}
    local x = 10
    -- Each by its key (new, copy, rename), its label in the language showing.
    for _, spec in ipairs({ { "new", L["New"], ns.NewProfile, L["Make a new, empty profile with the name typed above, and switch to it."] },
        { "copy", L["Copy"], ns.CopyProfile, L["Copy your ticks into a new profile with the name typed above, and switch to it."] },
        { "rename", L["Rename"], ns.RenameProfile,
            L["Give the profile you're on the name typed above, for every character using it."] } }) do
        local action = T:Button(panel, spec[2], 90, 22)
        action:SetPoint("TOPLEFT", x, -80)
        action.x = x
        action:SetScript("OnClick", Act(spec[3]))
        window:Hint(action, spec[4])
        buttons[spec[1]] = action
        x = x + 94
    end
    window.profileActions = buttons

    button:SetScript("OnClick", function()
        panel:SetShown(not panel:IsShown())
        window:Refresh()
    end)
    window:HookScript("OnHide", function() panel:Hide() end)

    function window:RefreshProfiles()
        local current = ns.ProfileName()
        button:SetLabel("|cff8b8d92" .. L["Profile"] .. "|r   " .. (current or L["loading..."]))
        if not panel:IsShown() then return end
        local names = ns.ProfileNames()
        for i, name in ipairs(names) do
            local row = Row(i)
            row.profile = name
            row.name:SetText(name)
            row.users:SetText(Users(name))
            local chosen = name == current
            row.fill:SetShown(chosen)
            row.mark:SetShown(chosen)
            row:Show()
        end
        for i = #names + 1, #rows do rows[i]:Hide() end
        -- The list is as tall as its profiles, up to LIST_ROWS; the box,
        -- buttons and hint follow it.
        tall = math.max(1, math.min(#names, LIST_ROWS))
        list.content:SetHeight(math.max(1, #names * ROW))
        Pin()
        local y = 32 + tall * ROW
        input:ClearAllPoints()
        input:SetPoint("TOPLEFT", 10, -y)
        for _, action in pairs(buttons) do
            action:ClearAllPoints()
            action:SetPoint("TOPLEFT", action.x, -(y + 26))
        end
        everyone:ClearAllPoints()
        everyone:SetPoint("TOPLEFT", 10, -(y + 52))
        local onAll = ns.OnAll(current)
        everyone:SetLabel(onAll and L["On all characters"] or L["Use on all characters"])
        everyone:SetAlpha(onAll and .5 or 1)
        hint:ClearAllPoints()
        hint:SetPoint("TOPLEFT", 10, -(y + 82))
        panel:SetHeight(y + 92 + math.max(28, math.ceil(hint:GetStringHeight() or 28)))
    end
end
