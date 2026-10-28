-- The words the addon shows, in English or Simplified Chinese. The English
-- stays in the code and is the key: ns.L["Take the tour"] is the text in the
-- language showing, and the English itself wherever there's nothing for it.
-- A choice on the General page picks the language: Auto (the default) is
-- Simplified Chinese on a Simplified Chinese game and English on any other,
-- or either one by hand. Core.lua applies it as the saved settings load, so
-- nothing the files make as they load is in it: tables of names keep their
-- English, looked up where they show. Only what players read is here: spell
-- and item names come from the game already in its language; settings,
-- commands, links and the debug report (for us) stay as they are.
-- Tools/TestLocale.mjs checks every word looked up has its Chinese.
local _, ns = ...

-- Each language but English: its text by the English.
local LANGUAGES = {}

-- The language showing, and its text.
local language, showing = "enUS", {}

ns.L = setmetatable({}, { __index = function(_, english) return showing[english] or english end })

-- The choices on the General page: the game's language, or one by hand.
ns.LANGUAGE_KEYS = { "auto", "enUS", "zhCN" }

-- The language a choice shows: Auto follows the game's.
function ns.LanguageFor(choice)
    if choice == "enUS" or LANGUAGES[choice] then return choice end
    local game = GetLocale and GetLocale()
    return type(game) == "string" and LANGUAGES[game] and game or "enUS"
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

-- Sentences one after another: a space between them in English, none in
-- Chinese, whose own full stops part them. Empty or missing ones are left out.
function ns.Join(...)
    local parts = {}
    for i = 1, select("#", ...) do
        local part = select(i, ...)
        if type(part) == "string" and part ~= "" then parts[#parts + 1] = part end
    end
    return table.concat(parts, language == "zhCN" and "" or " ")
end

-- Simplified Chinese, in the words of the game's own Simplified Chinese
-- client: 冷却 for a cooldown, 就绪 for ready, 法术, 物品, 饰品, 药水, 配置文件
-- for a profile, 小地图按钮, 战斗中. The pulse is 提示, its two styles 快速 and
-- 持久; to tick is 勾选 (the box 勾选框, what's ticked 勾选项), the General
-- page 常规, What's new 更新内容, the tour 导览, a new, empty profile 新的空白配置文件.
-- Grouped by the file that shows each; the same English always gets the
-- same Chinese, with full-width punctuation.
LANGUAGES.zhCN = {
    -- Core.lua: profiles, the update notice, Options > AddOns, the choices' names.
    ["Profiles can't change in combat."] = "战斗中无法更改配置文件。",
    ["Your profile hasn't loaded yet."] = "你的配置文件尚未载入。",
    ["Type a profile name first."] = "请先输入配置文件名称。",
    ["Profile names can be up to %d characters."] = "配置文件名称最多 %d 个字节（一个汉字占 3 个字节）。",
    ["Profile names can't use the | character."] = "配置文件名称不能包含 | 字符。",
    ['No profile is called "%s".'] = "没有名为「%s」的配置文件。",
    ["You're already using %s."] = "你已经在使用 %s。",
    ["Now using %s."] = "已切换到 %s。",
    ["%s already exists."] = "%s 已存在。",
    ["Copied your ticks to %s, and switched to it."] = "已将你的勾选项复制到 %s，并切换到该配置文件。",
    ["Made %s, and switched to it."] = "已创建 %s，并切换到该配置文件。",
    ["All your characters use %s now, and new ones will too."] = "你的所有角色现在都使用 %s，新角色也会使用。",
    ["That's already its name."] = "这已经是它的名称了。",
    ["Renamed to %s."] = "已重命名为 %s。",
    ["Deleted %s. You're now on %s."] = "已删除 %s。你现在使用 %s。",
    ["Deleted %s."] = "已删除 %s。",
    ["%s %s is out (you have %s). Update on CurseForge."] = "%s %s 已发布（你的版本为 %s）。请在 CurseForge 更新。",
    ["A big icon in the middle of your screen the moment a cooldown is ready. Type /fecp, click the minimap button, or click below, for the settings."]
        = "冷却就绪的那一刻，屏幕中央会出现一个大图标。输入 /fecp、点击小地图按钮或点击下方按钮即可打开设置。",
    ["Open settings"] = "打开设置",
    ["None"] = "无",
    ["Thin"] = "细",
    ["Thick"] = "粗",
    ["Chime"] = "风铃",
    ["Bell"] = "铃声",
    ["Bell trill"] = "颤音铃",
    ["Shimmer bell"] = "微光铃",
    ["Magic chimes"] = "魔法风铃",
    ["Shimmer"] = "微光",
    ["Zippy magic"] = "轻快魔法",
    ["Synth"] = "合成器",
    ["Pitch pipe"] = "定音笛",
    ["Brass"] = "铜管",
    ["War horn"] = "战争号角",
    ["Fanfare"] = "号角齐鸣",
    ["Gold"] = "金币",
    ["Jackpot bell"] = "头奖铃声",
    ["Anvil"] = "铁砧",
    ["Quick"] = "快速",
    ["Long"] = "持久",

    -- Link.lua: the pulse running in the other addon.
    ["Cooldown pulse is on in %s. Turn it off there to use this one."] = "冷却提示已在 %s 中开启。在那里关闭后即可使用此插件的提示。",

    -- Theme.lua: the accents.
    ["Orange"] = "橙色",
    ["Blue"] = "蓝色",
    ["Teal"] = "青色",
    ["Purple"] = "紫色",
    ["Green"] = "绿色",

    -- Spells.lua: the names the addon gives items.
    ["Item %d"] = "物品 %d",
    ["Trinket %d: %s"] = "饰品 %d：%s",
    ["Healthstones"] = "治疗石",
    ["Healing Potions"] = "治疗药水",
    ["Mana Potions"] = "法力药水",

    -- Pulse.lua: an error in chat, and the box that moves the pulse.
    ["the cooldown pulse couldn't follow a cooldown. Please report this: %s"] = "冷却提示无法跟踪某个冷却。请把以下内容报告给我们：%s",
    ["Finish the fight first, then move it."] = "请先结束战斗再移动。",
    ["Cooldown pulse"] = "冷却提示",
    ["Done"] = "完成",
    ["Drag the box, then click Done or right-click it."] = "拖动方框，然后点击「完成」或右键点击方框。",

    -- PulsePage.lua: the Cooldown pulse page.
    ["%gs"] = "%g秒",
    ["%g min"] = "%g分钟",
    ["%g hour"] = "%g小时",
    ["%g hours"] = "%g小时",
    ["On your screen"] = "屏幕上",
    ["Up close"] = "特写",
    ["Where it shows"] = "显示位置",
    ["Move"] = "移动",
    ["Shows a box as big as the style picked under Edit. Drag it where you want the pulse, then click Done. Both styles show there."]
        = "显示一个与「编辑」所选样式同样大小的方框。把它拖到你想让提示出现的位置，然后点击「完成」。两种样式都会显示在那里。",
    ["Reset"] = "重置",
    ["The pulse is back in the middle of your screen."] = "提示已回到屏幕中央。",
    ["Puts the pulse back in the middle of your screen."] = "将提示放回屏幕中央。",
    ["Pulse an icon when a cooldown is ready"] = "冷却就绪时显示图标提示",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. It never takes the mouse."]
        = "冷却就绪的那一刻，屏幕中央会出现一个大图标，战斗中也一样。它不会拦截鼠标点击。",
    ["%.1fs"] = "%.1f秒",
    ["Edit"] = "编辑",
    ["Quick and Long each have their own size, time and sound: pick which one to set below. Preview plays it."]
        = "「快速」和「持久」各有自己的大小、时长和声音：在这里选择要在下方设置哪一个。「预览」会播放它。",
    ["How big a %s pulse is, in the game's units: 320 is about a third of your screen's height."]
        = "「%s」提示的大小，以游戏单位计：320 约为屏幕高度的三分之一。",
    ["Size"] = "大小",
    ["Shows for"] = "显示时长",
    ["How long a Quick pulse lasts, up to 2 seconds: it pops in, holds a moment, then fades out."]
        = "「快速」提示持续多久，最长 2 秒：它会弹出、停留片刻，然后淡出。",
    ["How long a Long pulse lasts, up to 5 seconds: it pops in, holds a moment, then fades out."]
        = "「持久」提示持续多久，最长 5 秒：它会弹出、停留片刻，然后淡出。",
    ["Sound"] = "声音",
    ["A sound with each %s pulse. The arrows step through them and play each one; click its name to hear it again."]
        = "每次「%s」提示时播放的声音。用箭头逐个切换并试听；点击名称可再听一次。",
    ["See-through"] = "透明度",
    ["How much of the game shows through the icon, in both styles. 0 is solid."] = "图标的透明程度，两种样式通用。0 为完全不透明。",
    ["Grows to"] = "放大至",
    ["How big it gets as it fades, as a share of its size, in both styles. 100 keeps it the same size."]
        = "淡出时放大到原大小的百分比，两种样式通用。100 为保持原大小。",
    ["Border"] = "边框",
    ["A dark edge round the icon, in both styles: none, thin or thick."] = "图标周围的深色边框，两种样式通用：无、细或粗。",
    ["Shadow"] = "阴影",
    ["A soft shadow round the icon, in both styles, fading out from its edge."] = "图标周围的柔和阴影，两种样式通用，从边缘向外淡出。",
    ["Trinkets and potions too"] = "也包括饰品和药水",
    ["Your trinkets, potions, healthstones and other items with a use in your bags. Only ones with a cooldown pulse."]
        = "你的饰品、药水、治疗石以及背包里其他可使用的物品。只有带冷却的才会提示。",
    ["Play at Master volume"] = "以主音量播放",
    ["Plays the sound at your Master volume, so you hear it with Sound Effects down or off. Your sound settings don't change."]
        = "以主音量播放声音，即使音效调低或关闭也能听到。你的声音设置不会改变。",
    ["Which cooldowns"] = "冷却列表",
    ["tick the ones you want to pulse, then pick Quick or Long for each"] = "勾选要提示的冷却，再为每个选择「快速」或「持久」",
    ["Untick to leave %s out."] = "取消勾选后不再提示 %s。",
    ["Tick to pulse when %s is ready."] = "勾选后，%s 就绪时会提示。",
    [" (experimental)"] = "（实验性）",
    ["%s pulses %s."] = "%s 以「%s」样式提示。",
    ["Once ticked, %s pulses %s."] = "勾选后，%s 将以「%s」样式提示。",
    ["Click for %s."] = "点击改为「%s」。",
    ["Each style has its own size, time and sound, set under Edit above."] = "每种样式都有自己的大小、时长和声音，在上方「编辑」中设置。",
    ["Spells"] = "法术",
    ["Items"] = "物品",
    ["trinket"] = "饰品",
    ["none left"] = "已用完",
    ["in your bags"] = "在背包中",
    ["None of your spells has a cooldown of its own yet. New ones show here as you learn them."]
        = "你的法术都还没有自己的冷却。学会新法术后会显示在这里。",
    ["Preview"] = "预览",
    ["Shows a %s pulse now with your choices, over this window, on or off. Edit picks the style."]
        = "立即按你的设置在此窗口上方显示一次「%s」提示，无论是否开启。「编辑」决定样式。",
    ["Preview %s"] = "预览「%s」",
    ["1 cooldown pulses when it's ready."] = "1 个冷却会在就绪时提示。",
    ["%d cooldowns pulse when they're ready."] = "%d 个冷却会在就绪时提示。",
    ["Nothing to pulse yet: tick some below."] = "还没有要提示的冷却：在下方勾选一些。",
    ["Running in %s instead."] = "改由 %s 运行。",
    ["Off. Tick the box below to start."] = "已关闭。勾选下方的选项即可开启。",
    ["%s right"] = "右移 %s",
    ["%s left"] = "左移 %s",
    ["%s up"] = "上移 %s",
    ["%s down"] = "下移 %s",
    ["Moved %s and %s from the middle."] = "已从中央%s、%s。",
    ["Moved %s from the middle."] = "已从中央%s。",
    ["In the middle of your screen."] = "位于屏幕中央。",

    -- ProfileMenu.lua: the profile menu.
    ["all characters"] = "所有角色",
    ["you + %d"] = "你 + %d",
    ["you"] = "你",
    ["unused"] = "未使用",
    ["1 character"] = "1 个角色",
    ["%d characters"] = "%d 个角色",
    ["The profile this character uses: what's ticked to pulse, and which are Long. Click for every profile, to switch or make one."]
        = "此角色使用的配置文件：勾选了哪些要提示，以及哪些为「持久」。点击查看所有配置文件，可切换或新建。",
    ["Profiles"] = "配置文件",
    ["You're using it, so you'll move to a new, empty profile of your own."] = "你正在使用它，删除后你会改用一个新的空白配置文件。",
    ["Another character uses it, and loads %s at its next login."] = "另有一个角色在使用它，该角色下次登录时会载入 %s。",
    ["Another character uses it, and gets a new, empty profile of its own at its next login."]
        = "另有一个角色在使用它，该角色下次登录时会改用一个新的空白配置文件。",
    ["%d other characters use it, and each loads %s at its next login."] = "另有 %d 个角色在使用它，它们下次登录时都会载入 %s。",
    ["%d other characters use it, and each gets a new, empty profile of its own at its next login."]
        = "另有 %d 个角色在使用它，它们下次登录时会各自改用一个新的空白配置文件。",
    ['Delete "%s"?'] = "删除「%s」？",
    ["This can't be undone."] = "此操作无法撤销。",
    ["Delete"] = "删除",
    ["The profile you're on."] = "你正在使用的配置文件。",
    ["Switch to %s."] = "切换到 %s。",
    ["Delete %s. It asks first."] = "删除 %s。删除前会先确认。",
    ["Profile name"] = "配置文件名称",
    ["A name for New, Copy or Rename."] = "用于「新建」、「复制」或「重命名」的名称。",
    ["Click a profile to use it, or x to delete it. Type a name to make, copy or rename one. Any class can share a profile: each character only lists its own spells."]
        = "点击配置文件即可使用，点击 x 可删除。输入名称可新建、复制或重命名。任何职业都可以共用配置文件：每个角色只会列出自己的法术。",
    ["Use on all characters"] = "用于所有角色",
    ["All your characters already use %s."] = "你的所有角色都已在使用 %s。",
    ['Use "%s" on all characters?'] = "将「%s」用于所有角色？",
    ["Every character, and any you make later, loads it. Each only lists its own spells and items. Their own profiles stay in this list."]
        = "所有角色以及以后创建的角色都会载入它。每个角色只会列出自己的法术和物品。它们原来的配置文件仍保留在此列表中。",
    ["Use on all"] = "用于所有角色",
    ["All your characters use this profile, and new ones will too."] = "你的所有角色都在使用此配置文件，新角色也会使用。",
    ["Loads the profile you're on for every character. Each one only lists its own spells and items."]
        = "为所有角色载入你正在使用的配置文件。每个角色只会列出自己的法术和物品。",
    ["New"] = "新建",
    ["Make a new, empty profile with the name typed above, and switch to it."] = "用上方输入的名称新建一个空白配置文件，并切换到它。",
    ["Copy"] = "复制",
    ["Copy your ticks into a new profile with the name typed above, and switch to it."] = "用上方输入的名称新建配置文件，复制你的勾选项，并切换到它。",
    ["Rename"] = "重命名",
    ["Give the profile you're on the name typed above, for every character using it."]
        = "将你正在使用的配置文件改为上方输入的名称，所有使用它的角色都会随之更改。",
    ["Profile"] = "配置文件",
    ["loading..."] = "载入中……",
    ["On all characters"] = "已用于所有角色",

    -- Window.lua: the window, its General page, the link box and More from Squirt.
    ["Drag to scroll the list, or turn the mouse wheel over it."] = "拖动以滚动列表，或在列表上滚动鼠标滚轮。",
    ["Press Ctrl+C to copy, then paste it into your browser."] = "按 Ctrl+C 复制，然后粘贴到浏览器中。",
    ["Close"] = "关闭",
    ["Join the Discord"] = "加入 Discord",
    ["Found a bug or have an idea? Press Ctrl+C to copy, then paste it into your browser."]
        = "发现了问题或有好点子？按 Ctrl+C 复制，然后粘贴到浏览器中。",
    ["Open"] = "打开",
    ["%s on %s"] = "%s 的 %s 页面",
    ["Press Ctrl+C to copy, then paste it into your browser. On CurseForge, Install opens the CurseForge app."]
        = "按 Ctrl+C 复制，然后粘贴到浏览器中。在 CurseForge 页面上，点击 Install 会打开 CurseForge 应用。",
    ["%s on %s, as a link to copy."] = "%s 的 %s 页面链接，可复制。",
    ["Get it on CurseForge or GitHub: click one for its link."] = "可从 CurseForge 或 GitHub 获取：点击其中一个获取链接。",
    ["Auto (game language)"] = "自动（游戏语言）",
    ["The language of this window, What's new and the addon's lines in chat. Auto follows your game: Simplified Chinese on a Simplified Chinese game, English on any other. (experimental)"]
        = "此窗口、更新内容以及插件聊天信息所用的语言。「自动」跟随游戏：简体中文客户端显示简体中文，其他客户端（包括繁体中文）显示英文。（实验性）",
    ["Help"] = "帮助",
    ["Take the tour"] = "开始导览",
    ["A short tour of this window, a page at a time. /fecp tour starts it too."] = "本窗口的简短导览，一次一页。也可以输入 /fecp tour 开始。",
    ["What's new"] = "更新内容",
    ["What changed in this version. /fecp new shows it too."] = "此版本的改动。也可以输入 /fecp new 查看。",
    ["Nothing yet: what changes in each update shows here."] = "暂无内容：每次更新的改动会显示在这里。",
    ["The Discord invite, ready to copy: bugs, ideas and help."] = "可复制的 Discord 邀请链接：报告问题、提出想法、获取帮助。",
    ["A tour of the basics, what changed in each update, or the Discord for bugs, ideas and help."]
        = "基础导览、每次更新的改动，或前往 Discord 报告问题、提出想法和获取帮助。",
    ["Minimap button"] = "小地图按钮",
    ["Show the minimap button"] = "显示小地图按钮",
    ["A button on the minimap for these settings. Off, /fecp still opens them."] = "小地图上用于打开这些设置的按钮。关闭后，/fecp 仍可打开设置。",
    ["Free-floating"] = "自由放置",
    ["Drag the button anywhere on the screen, not just round the minimap. It shows even with the minimap hidden."]
        = "可将按钮拖到屏幕上任意位置，不限于小地图周围。即使隐藏小地图也会显示。",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap, or anywhere while it's free-floating."]
        = "点击打开这些设置，右键点击查看更新内容，拖动可沿小地图移动；自由放置时可拖到任意位置。",
    ["Window accent"] = "窗口主题色",
    ["%s for this window's headings, ticks, sliders and highlights."] = "%s：用于本窗口的标题、勾选框、滑块和高亮。",
    ["Language"] = "语言",
    ["About"] = "关于",
    ["Tell me when an update is out"] = "有新版本时提醒我",
    ["A line in chat, once a session, when a newer version is out. It uses a hidden chat channel, which takes one of your chat channel slots."]
        = "有新版本时，每次登录在聊天框中提示一次。它使用一个隐藏的聊天频道，会占用你的一个聊天频道名额。",
    ["More from Squirt"] = "Squirt 的更多作品",
    ["%s, a copy straight from the source. Made by Squirt. Type /fecp to open this window."]
        = "%s 开发版。由 Squirt 制作。输入 /fecp 打开此窗口。",
    ["%s version %s. Made by Squirt. Type /fecp to open this window."] = "%s 版本 %s。由 Squirt 制作。输入 /fecp 打开此窗口。",
    ["Cancel"] = "取消",
    ["Made with %s by %s"] = "用 %s 制作，作者：%s",
    ["/fecp to open"] = "输入 /fecp 打开",
    ["Profiles: click one to use it, or x to delete it. Type a name to make, copy or rename one."]
        = "配置文件：点击即可使用，点击 x 可删除。输入名称可新建、复制或重命名。",
    ["Nothing to walk through here yet. Hover over anything and this line says what it does."]
        = "这里暂时没有可讲解的内容。将鼠标悬停在任意控件上，这一行会说明它的作用。",
    ["Page help"] = "页面帮助",
    ["Walks you through this page, a step at a time."] = "逐步讲解此页面。",
    ["New: click ? for help with any page"] = "新功能：点击 ? 查看各页帮助",
    ["Put this note away. The ? stays, for help with any page."] = "收起这条提示。? 按钮会保留，随时获取任意页面的帮助。",
    ["Close the window. Escape closes it too, and /fecp opens it again."] = "关闭窗口。按 Esc 键也可关闭，输入 /fecp 可再次打开。",
    ["A big icon in the middle of your screen when a cooldown is ready."] = "冷却就绪时，屏幕中央会出现一个大图标。",
    ["General"] = "常规",
    ["The tour, What's new, the Discord, the minimap button, this window's accent and language, update notices and Squirt's other addons."]
        = "导览、更新内容、Discord、小地图按钮、本窗口的主题色和语言、更新提醒以及 Squirt 的其他插件。",
    ["The Classic look for WoW Forever's whole interface, with quality of life options."]
        = "为 WoW Forever 带来经典外观和便利功能。",
    ["Installed. Type /era, or click Open."] = "已安装。输入 /era 或点击「打开」。",
    ["Open EraUI's settings, as /era does."] = "打开 EraUI 的设置，与 /era 相同。",
    ["Blizzard's Cooldown Manager restyled, plus cooldown, buff and cast bars of your own."]
        = "重制冷却管理器，另加自定义计时条。",
    ["Installed. Type /ccm, or click Open."] = "已安装。输入 /ccm 或点击「打开」。",
    ["Open Forever Enhanced Cooldown Manager's settings, as /ccm does."] = "打开 Forever Enhanced Cooldown Manager 的设置，与 /ccm 相同。",

    -- Tour.lua: the tour, its steps and the page walkthroughs.
    ["That's this page. Click ? any time to see it again."] = "此页面讲解完毕。随时点击 ? 可再次查看。",
    ["Click ? any time to see it again."] = "随时点击 ? 可再次查看。",
    ["That's what's new. See it again any time from What's new, or with /fecp new."]
        = "更新内容介绍完毕。随时可从「更新内容」或输入 /fecp new 再次查看。",
    ["See it again any time from What's new, or with /fecp new."] = "随时可从「更新内容」或输入 /fecp new 再次查看。",
    ["That's the tour. Take the tour any time from the General page, or with /fecp tour."]
        = "导览结束。随时可从「常规」页面或输入 /fecp tour 再次开始导览。",
    ["Take the tour any time from the General page, or with /fecp tour."] = "随时可从「常规」页面或输入 /fecp tour 开始导览。",
    ["Cooldown pulse is on in %s, so it runs there and this tick waits. Turn it off there to use this one."]
        = "冷却提示已在 %s 中开启，因此由它运行，此处的勾选框暂时停用。在那里关闭后即可使用此插件的提示。",
    ["A big icon in the middle of your screen the moment a cooldown is ready, in a fight too. This tick turns it on or off."]
        = "冷却就绪的那一刻，屏幕中央会出现一个大图标，战斗中也一样。这个勾选框用于开启或关闭它。",
    ["Nothing to do here while it runs there."] = "它在那里运行时，这里无需操作。",
    ["It's already on."] = "它已经开启了。",
    ["Next"] = "下一步",
    ["Back"] = "上一步",
    ["Skip tour"] = "跳过导览",
    ["%d of %d"] = "第 %d/%d 步",
    ["Welcome"] = "欢迎",
    ["New to %s? A quick tour shows you the basics, a page at a time. It takes about a minute."]
        = "初次使用 %s？简短的导览会一页一页地介绍基础功能，大约需要一分钟。",
    ["Skip"] = "跳过",
    ["Turn it on"] = "开启冷却提示",
    ["Try it: tick it."] = "试试看：勾选它。",
    ["Pick your cooldowns"] = "选择你的冷却",
    ["Every spell you know with a cooldown, and your trinkets and potions. Tick the ones to pulse, then pick Quick or Long for each."]
        = "你学会的每个带冷却的法术，以及你的饰品和药水。勾选要提示的，再为每个选择「快速」或「持久」。",
    ["Try it: tick one."] = "试试看：勾选一个。",
    ["You've ticked some already."] = "你已经勾选了一些。",
    ["Quick and Long"] = "快速与持久",
    ["Each has its own size, time and sound. Pick one under Edit: Size, Shows for and Sound follow it, and Preview plays it."]
        = "两者各有自己的大小、时长和声音。在「编辑」中选择一个：「大小」、「显示时长」和「声音」会随之切换，「预览」会播放它。",
    ["Try it: pick Long, then Preview."] = "试试看：选择「持久」，然后点击「预览」。",
    ["Move shows a box as big as the pulse: drag it where you want it, then click Done. Reset puts it back in the middle."]
        = "「移动」会显示一个与提示同样大小的方框：把它拖到你想要的位置，然后点击「完成」。「重置」会把它放回中央。",
    ["Take this tour again, see What's new, or get the Discord invite for help, bugs and ideas. The minimap button and this window's accent are here too. /fecp opens this window."]
        = "可再次开始导览、查看更新内容，或获取 Discord 邀请以寻求帮助、报告问题和提出想法。小地图按钮和本窗口的主题色也在这里。/fecp 可打开此窗口。",
    ["Both styles"] = "两种样式",
    ["See-through, Grows to, Border and Shadow are for Quick and Long alike. Under them: your trinkets and potions in the list, and the sound at your Master volume."]
        = "「透明度」、「放大至」、「边框」和「阴影」对「快速」和「持久」同样适用。下方：在列表中加入饰品和药水，以及以主音量播放声音。",
    ["Click it for these settings, right-click for What's new, and drag it round the minimap. Untick to hide it: /fecp still opens them."]
        = "点击打开这些设置，右键点击查看更新内容，拖动可沿小地图移动。取消勾选可隐藏它：/fecp 仍可打开设置。",
    ["The colour of this window's headings, ticks, sliders and highlights."] = "本窗口标题、勾选框、滑块和高亮的颜色。",
    ["English or Simplified Chinese for this window, What's new and the addon's lines in chat. Auto follows your game's language. It changes at once."]
        = "此窗口、更新内容以及插件聊天信息可使用英文或简体中文。「自动」跟随游戏语言。切换后立即生效。",

    -- MinimapButton.lua: its tooltip.
    ["Click: settings\nRight-click: What's new\nDrag: move it anywhere"] = "点击：设置\n右键点击：更新内容\n拖动：移到任意位置",
    ["Click: settings\nRight-click: What's new\nDrag: move it round the minimap"] = "点击：设置\n右键点击：更新内容\n拖动：沿小地图移动",

    -- Notes.lua: What's new, and every release's notes.
    ["Unreleased"] = "未发布",
    ["Version %s"] = "版本 %s",
    ["Found a bug or have an idea?"] = "发现了问题或有好点子？",
    ["/fecp new shows this again."] = "输入 /fecp new 可再次查看。",
    ["Got it"] = "知道了",
    ["Show me what's new"] = "带我看看新内容",
    ["A quick tour of what's new, a page at a time."] = "新内容的简短导览，一次一页。",
    ["Added"] = "新增",
    ["Changed"] = "改动",
    ["Fixed"] = "修复",
    ["Tell me when an update is out (General page): a line in chat when a newer version is out. On by default."]
        = "「有新版本时提醒我」（常规页面）：有新版本时在聊天框中显示一条消息。默认开启。",
    ["Missing spells (Seal of Command, Holy Shock, Cold Blood, Innervate and more) can now be pulsed."]
        = "之前缺失的法术（命令圣印、神圣震击、冷血、激活等）现在可以提示了。",
    ["Spell data updated for Forever's latest patch."] = "法术数据已更新至 Forever 最新补丁。",
    ["The minimap button starts in a new spot, clear of our other addons' buttons. A spot you dragged it to stays."]
        = "小地图按钮的初始位置改到了新的地方，不再与我们其他插件的按钮重叠。你拖动过的位置会保留。",
    ["Thistle Tea, and the few other foods and drinks with a cooldown, now pulse."] = "菊花茶以及少数其他带冷却的食物和饮料现在会提示了。",
    ["Read Leyline keeps its pulse tick after the game renamed it."] = "游戏将 Read Leyline 改名后，它的勾选状态会保留。",
    ["Lighter when your bags change, and spell data updated for Forever's latest build."]
        = "背包变化时占用更少资源，法术数据已更新至 Forever 最新版本。",
    ["Potions move on to the one you carry, and an item you've run out of doesn't pulse."]
        = "药水会自动换成你携带的那种，已用完的物品不会再提示。",
    ["Hover boxes widen to fit their title."] = "悬停提示框会加宽以容纳标题。",
    ["The minimap button can be free-floating: tick it on the General page, then drag it anywhere."]
        = "小地图按钮可以自由放置：在「常规」页面勾选后，可拖到任意位置。",
    ["More from Squirt on the General page: EraUI and Forever Enhanced Cooldown Manager."]
        = "「常规」页面新增「Squirt 的更多作品」：EraUI 和 Forever Enhanced Cooldown Manager。",
    ["Escape now closes the settings during a fight too."] = "现在战斗中也可以按 Esc 键关闭设置。",
    ["The settings and What's new close along with the game's other windows, for example at a loading screen."]
        = "设置和更新内容窗口会与游戏的其他窗口一同关闭，例如进入载入画面时。",
    ["The minimap button's tooltip now matches the addon's look."] = "小地图按钮的鼠标提示现在与插件外观一致。",
    ["A big icon in the middle of your screen the moment a cooldown you tick is ready."] = "你勾选的冷却就绪的那一刻，屏幕中央会出现一个大图标。",
    ["Quick and Long styles, each with its own size, time and sound, plus 15 sounds and a Master volume option."]
        = "「快速」和「持久」两种样式，各有自己的大小、时长和声音，另有 15 种声音和主音量选项。",
    ["Trinkets, potions, healthstones and bag items can pulse too."] = "饰品、药水、治疗石和背包物品也可以提示。",
    ["Works alongside Forever Enhanced Cooldown Manager: only one pulse runs at a time."]
        = "可与 Forever Enhanced Cooldown Manager 同时使用：同一时间只运行一个冷却提示。",
}
