// The addon's rules, checked straight from its source: the TOC loads every
// file once, in order, for Forever, by Squirt; the licence and packaging are
// right; the pulse only hands cooldowns on (it never reads one's times, only
// whether it's on hold) and never takes the mouse but for the box that
// moves it; answers the game may keep secret are read with Open() first;
// Blizzard's frames are never shown, hidden, moved or written on,
// and no panel or game setting is touched; no text is ever run as code;
// every name the addon puts in the game's global space is its own (FECP),
// never Forever Enhanced Cooldown Manager's; that addon's saved settings are
// only read, in Link.lua alone; the art is right; no em dash in anything
// players read; no function given twice in a file; and no other addon is
// named anywhere.
// Run with: node --test Tools/TestRules.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, readdir } from 'node:fs/promises';
import { createHash } from 'node:crypto';

const root = new URL('../', import.meta.url);
const read = name => readFile(new URL(name, root), 'utf8');

async function rootFiles(pattern) {
  return (await readdir(root, { withFileTypes: true }))
    .filter(entry => entry.isFile() && pattern.test(entry.name)).map(entry => entry.name).sort();
}

// The addon's code with its comments and strings blanked out (lines kept),
// so only code is checked.
function codeOnly(lua) {
  let out = '';
  let i = 0;
  const blank = text => text.replace(/[^\n]/g, ' ');
  while (i < lua.length) {
    const rest = lua.slice(i);
    let match;
    if ((match = rest.match(/^--\[(=*)\[[\s\S]*?\]\1\]/))) {
      out += blank(match[0]);
    } else if ((match = rest.match(/^--[^\n]*/))) {
      out += blank(match[0]);
    } else if ((match = rest.match(/^\[(=*)\[[\s\S]*?\]\1\]/))) {
      out += '""' + blank(match[0].slice(2));
    } else if ((match = rest.match(/^"(?:[^"\\\n]|\\.)*"/)) || (match = rest.match(/^'(?:[^'\\\n]|\\.)*'/))) {
      out += '""' + blank(match[0].slice(2));
    } else {
      match = [lua[i]];
      out += lua[i];
    }
    i += match[0].length;
  }
  return out;
}

// The code without its comments, strings kept.
const noComments = lua => lua.replace(/--\[(=*)\[[\s\S]*?\]\1\]/g, '').replace(/--[^\n]*/g, '');

// The text in a Lua file's strings, one entry each (comments left out).
function literals(lua) {
  const found = [];
  let i = 0;
  while (i < lua.length) {
    const rest = lua.slice(i);
    let match;
    if ((match = rest.match(/^--\[(=*)\[[\s\S]*?\]\1\]/)) || (match = rest.match(/^--[^\n]*/))) {
      // a comment
    } else if ((match = rest.match(/^\[(=*)\[([\s\S]*?)\]\1\]/))) {
      found.push({ text: match[2], index: i });
    } else if ((match = rest.match(/^"((?:[^"\\\n]|\\.)*)"/)) || (match = rest.match(/^'((?:[^'\\\n]|\\.)*)'/))) {
      found.push({ text: match[1], index: i });
    } else {
      match = [lua[i]];
    }
    i += match[0].length;
  }
  return found;
}

async function addonCode() {
  const files = await rootFiles(/\.lua$/i);
  assert.ok(files.length >= 13, 'the addon files found');
  return Promise.all(files.map(async name => ({ name, source: await read(name), code: codeOnly(await read(name)) })));
}

function lineOf(text, index) {
  return text.slice(0, index).split('\n').length;
}

const count = (text, pattern) => (text.match(pattern) || []).length;

test('the TOC loads every file once, in order, for Forever, by Squirt', async () => {
  const toc = await read('ForeverEnhancedCooldownPulse.toc');
  assert.match(toc, /^## Interface: 16001$/m);
  assert.match(toc, /^## Title: Forever Enhanced Cooldown Pulse$/m);
  assert.match(toc, /^## Notes: .+ for WoW Forever\.$/m, 'a short plain line about it');
  assert.match(toc, /^## Author: Squirt$/m);
  assert.match(toc, /^## Version: @project-version@$/m, 'the packager fills the version in from the tag');
  assert.match(toc, /^## SavedVariables: ForeverEnhancedCooldownPulseDB$/m);
  assert.doesNotMatch(toc, /SavedVariablesPerCharacter/, 'account-wide settings only');
  assert.match(toc, /^## IconTexture: Interface\\AddOns\\ForeverEnhancedCooldownPulse\\Media\\FECPIcon\.tga$/m);
  assert.match(toc, /^## Category: UI$/m, 'filed as Forever Enhanced Cooldown Manager is');
  assert.match(toc, /^## OptionalDeps: ForeverEnhancedCooldownManager$/m, 'that addon first, when it\'s there, so the link finds it');
  assert.doesNotMatch(toc, /X-Curse-Project-ID/, 'no CurseForge project yet');
  const listed = toc.split(/\r?\n/).filter(line => line && !line.startsWith('#'));
  assert.deepEqual([...listed].sort(), await rootFiles(/\.lua$/i), 'every .lua file in the folder, and no other');
  assert.equal(new Set(listed).size, listed.length, 'each once');
  const at = name => listed.indexOf(name);
  assert.equal(at('Core.lua'), 0, 'the settings first');
  assert.ok(at('Link.lua') < at('Pulse.lua') && at('Theme.lua') < at('Pulse.lua'), 'the link and the look before the pulse, which uses both');
  assert.ok(at('Ranks.lua') < at('Spells.lua') && at('Spells.lua') < at('Pulse.lua'), 'the game data and the list before the pulse');
  assert.ok(at('PulsePage.lua') < at('Window.lua') && at('ProfileMenu.lua') < at('Window.lua'), 'the page and the profile menu before the window');
  const harness = (await read('Tools/Harness.lua')).match(/^H\.FILES = \{([^}]*)\}/m);
  assert.ok(harness, 'H.FILES found in Tools/Harness.lua');
  assert.deepEqual([...harness[1].matchAll(/"([^"]+)"/g)].map(match => match[1]), listed, 'the tests load what the game loads');
});

test('All Rights Reserved, and packaged without the tools', async () => {
  const licence = await read('LICENSE.txt');
  assert.match(licence, /^Copyright \(c\) 2026 Squirt\. All rights reserved\.$/m);
  assert.match(licence, /Forever Enhanced Cooldown Pulse and its source code are the property of the\s+author/);
  const pkgmeta = await read('.pkgmeta');
  assert.match(pkgmeta, /^package-as: ForeverEnhancedCooldownPulse$/m);
  assert.match(pkgmeta, /^manual-changelog: CHANGELOG\.txt$/m);
  assert.match(await read('CHANGELOG.txt'), /^# Changelog\r?\n/, 'the changelog it names is there');
  for (const folder of ['.github', 'Screenshots', 'Tools']) assert.match(pkgmeta, new RegExp(`^  - ${folder}$`, 'm'));
  const ignore = await read('.gitignore');
  assert.match(ignore, /^Tools\/ReleasePreview\.md$/m, 'the private notes stay private');
  assert.match(ignore, /^Tools\/ReleaseAudit-\*\.md$/m);
  const readme = await read('README.md');
  assert.match(readme, /^# Forever Enhanced Cooldown Pulse$/m);
  assert.match(readme, /Created by Squirt\. Built for World of Warcraft: Forever\. All rights reserved\./);
});

test('the pulse hands cooldowns on, never reads one, and takes no mouse but to move it', async () => {
  const pulse = noComments(await read('Pulse.lua'));
  // A duration object or a cooldown frame is never asked anything.
  for (const pattern of [/IsActive/, /IsZero/, /GetRemaining/, /GetElapsed/, /GetTotal/, /Evaluate/, /GetCooldownTimes/,
    /GetCooldownDuration\b/, /cooldown:IsShown/, /cooldown:IsVisible/, /startTime/, /modRate/, /isActive/]) {
    assert.equal(pattern.test(pulse), false, `${pattern} in Pulse.lua`);
  }
  // One plain question, whether a spell's cooldown is on hold: only its field
  // that's never secret is read.
  assert.equal(count(pulse, /GetSpellCooldown\(/g), 1, 'C_Spell.GetSpellCooldown, once');
  assert.equal(count(pulse, /C_Spell\.GetSpellCooldown and C_Spell\.GetSpellCooldown\(watch\.spellID\)/g), 1);
  assert.deepEqual([...new Set(pulse.match(/\binfo\.\w+/g))], ['info.isEnabled'], 'only isEnabled is read');
  assert.equal(count(pulse, /GetSpellCooldownDuration\(watch\.spellID, true\)/g), 1, 'asked for once, without the global cooldown');
  assert.equal(count(pulse, /SetCooldownFromDurationObject\(duration\)/g), 1, 'and handed straight on');
  // A watcher is let go of while it's cleared, so a done the game may send for the clear is no pulse.
  assert.match(pulse, /local function Clear\(watch\)\r?\n\s*local cooldown = watch\.cooldown\r?\n\s*cooldown\.watch = nil\r?\n\s*cooldown:Clear\(\)\r?\n\s*cooldown\.watch = watch\r?\n/);
  assert.equal(count(pulse, /cooldown:Clear\(\)/g), 2, 'cleared only there, and as a watcher is let go of');
  // The one frame that takes the mouse: the box that moves it.
  assert.equal(count(pulse, /EnableMouse\(true\)/g), 1);
  assert.match(pulse, /mover = CreateFrame\("Frame", "FECPPulseMover", UIParent, "BackdropTemplate"\)[\s\S]*?mover:EnableMouse\(true\)/);
  assert.equal(count(pulse, /EnableMouse\(false\)/g), 4, 'the pulse, its icon, the watchers and their frame');
  assert.doesNotMatch(noComments(await read('Link.lua')), /EnableMouse\(true\)/, 'the link\'s watcher takes none either');
});

// Answers the game may keep secret in a fight are never compared, tested or
// used in sums until Open() (or issecretvalue) says they can be read: a
// secret compared errors in the game ("attempt to compare ... a secret
// number value, while execution tainted by ..."). The mock game's secrets
// catch most of this as the tests run (type() says what one stands for, so
// a type check alone never gets past one), but Lua can't make
// `secret == true` or `if secret then` error, so this reads it from the
// source, as Forever Enhanced Cooldown Manager's rules do: after each answer
// is taken, every comparison, test or sum with it within its function needs
// an Open() of it first: on the same line, in the `if` it sits in, or in an
// `if not Open(...) then return` before it. Item counts and cooldowns, worn
// and usable items (Pulse.lua's Feed and PickBack, Spells.lua's Pick and
// Carries), and the rest in case they're ever used.
const SECRET_ANSWERS = ['GetInventoryItemCooldown', 'C_Item.GetItemCooldown', 'C_Item.GetItemCount', 'C_Item.IsUsableItem',
  'C_Item.IsEquippedItem', 'C_Spell.IsSpellUsable', 'C_Spell.IsSpellInRange', 'UnitCanAttack', 'GetInventoryItemCount',
  'UnitPower'];
const escape = text => text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const indent = line => line.match(/^\s*/)[0].length;
// From line i to the end of its function, each compare, test or sum with
// `name` needs an Open() of it first.
function follow(lines, i, name, found) {
  const v = escape(name);
  // Compared, in a sum or joined, or tested (if x, not x, x and, x or).
  const use = new RegExp(`(?<![\\w.:])${v}\\s*(==|~=|<=|>=|<|>|\\.\\.|[-+*/%^])|(==|~=|<=|>=|<|>|\\.\\.|[-+*/%^])\\s*${v}(?![\\w(])`
    + `|\\bnot\\s+${v}\\b|(?<![\\w.:])${v}\\s+(and|or)\\b|\\b(if|elseif|while)\\s+${v}\\s+(then|do)\\b`);
  const check = new RegExp(`(Open|issecretvalue)\\(${v}\\)`);
  let always = false, block = -1; // guarded from here on; guarded while deeper than this
  for (let j = i + 1; j < lines.length && !/^(end|function|local function)\b/.test(lines[j]); j++) {
    const text = lines[j];
    if (block >= 0 && text.trim() && indent(text) <= block) block = -1;
    const at = text.search(use);
    if (at >= 0 && !always && block < 0 && !check.test(text.slice(0, at + 1))) {
      found.push(`line ${j + 1}: ${name} (${text.trim()})`);
    }
    if (check.test(text) && !/\bor\b/.test(text)) {
      // Leaves early unless it's open: `if not Open(x) then return`, or
      // `if not (Open(x) and ...) then` with a return in its block. Not
      // `if not other and Open(x) and x == y then`: that tests other.
      let exits = /\bthen\s+return\b/.test(text);
      if (!exits && /\bthen\s*$/.test(text)) {
        const body = [];
        for (let k = j + 1; k < lines.length && (!lines[k].trim() || indent(lines[k]) > indent(text)); k++) body.push(lines[k]);
        const first = body.find(line => line.trim());
        const depth = first ? indent(first) : -1;
        exits = body.some(line => line.trim() && indent(line) === depth && /^\s*return\b/.test(line));
      }
      if (/^\s*if not\s*(\(|(Open|issecretvalue)\()/.test(text) && exits) always = true;
      else if (/^\s*if\b.*\bthen\s*$/.test(text)) block = indent(text);
    }
  }
}
// Every answer taken in this code (its comments and strings blanked), and
// each unguarded use of one.
function unguarded(source) {
  const lines = codeOnly(source).split(/\r?\n/), found = [];
  let taken = 0;
  lines.forEach((line, i) => {
    for (const api of SECRET_ANSWERS) {
      const left = line.match(new RegExp(`((?:\\b\\w+\\s*,\\s*)*\\b\\w+)\\s*=(?!=)\\s*(?:[\\w.()" ,]+?\\s+and\\s+)?(?:\\w+\\.)?${escape(api)}\\(`));
      if (!left) continue;
      taken++;
      for (const name of left[1].split(',').map(part => part.trim()).filter(part => part && part !== '_')) {
        follow(lines, i, name, found);
      }
    }
  });
  return { found, taken };
}

test('answers the game may keep secret are read with Open() first', async () => {
  let taken = 0;
  const found = [];
  for (const { name, source } of await addonCode()) {
    const result = unguarded(source);
    taken += result.taken;
    found.push(...result.found.map(problem => `${name} ${problem}`));
  }
  // Pulse.lua: a trinket's and an item's cooldown, and a ticked item's
  // count (PickBack); Spells.lua: counts and usable (Pick), counts and worn
  // (Carries).
  assert.ok(taken >= 7, `the answers found (${taken})`);
  assert.deepEqual(found, [], 'compared or summed before Open()');
  // The check finds what the mock game can't.
  const sample = 'local function Lit(id)\n    local usable = C_Spell.IsSpellUsable(id)\n    return usable == true\nend\n';
  assert.equal(unguarded(sample).found.length, 1, 'usable == true with no Open() first');
  assert.equal(unguarded(sample.replace('return usable', 'return Open(usable) and usable')).found.length, 0, 'and fine with one');
  const back = 'local function Back(id)\n    local count = C_Item.GetItemCount(id, false, true)\n'
    + '    if type(count) == "number" and count > 0 then return true end\nend\n';
  assert.equal(unguarded(back).found.length, 1, 'a count checked by type alone');
  assert.equal(unguarded(back.replace('if type', 'if Open(count) and type')).found.length, 0, 'and fine with Open() first');
  const early = 'local function Has(id)\n    local count = C_Item.GetItemCount(id)\n    if not Open(count) then return false end\n'
    + '    return count > 0\nend\n';
  assert.equal(unguarded(early).found.length, 0, 'fine after an early return');
});

// Blizzard's frames the addon could reach by name (the game's tooltip is
// the minimap button's to fill, as every addon's is).
const BLIZZARD = String.raw`(?:UIParent|WorldFrame|Minimap|MinimapCluster|PlayerFrame|TargetFrame|MainMenuBar|SettingsPanel|`
  + String.raw`DEFAULT_CHAT_FRAME|ChatFrame\d+)`;
const CHAIN = String.raw`((?:\s*(?:\.\s*[A-Za-z_]\w*|\[[^\]\n]*\]))*)`;
const FORBIDDEN = new Set(['Show', 'Hide', 'SetShown', 'SetScale', 'SetSize', 'SetWidth', 'SetHeight', 'SetPoint',
  'ClearAllPoints', 'ClearPoint', 'SetAllPoints', 'SetParent', 'SetScript', 'SetFrameStrata', 'SetFrameLevel',
  'EnableMouse', 'SetAttribute', 'RegisterEvent', 'RegisterUnitEvent', 'UnregisterEvent', 'UnregisterAllEvents',
  'SetMovable', 'StartMoving', 'StopMovingOrSizing', 'SetClampedToScreen', 'SetUserPlaced', 'SetIgnoreParentScale',
  'SetIgnoreParentAlpha', 'SetToplevel', 'Raise', 'Lower', 'SetID', 'Enable', 'Disable', 'SetAlpha']);

test('no show, hide, move, scale, resize, script or key on a Blizzard frame named in the code', async () => {
  const found = [];
  const call = new RegExp(String.raw`(?<![\w.:])(${BLIZZARD})${CHAIN}\s*:\s*([A-Za-z_]\w*)\s*\(`, 'g');
  const write = new RegExp(String.raw`(?<![\w.:])(${BLIZZARD})((?:\s*(?:\.\s*[A-Za-z_]\w*|\[[^\]\n]*\]))+)\s*=(?!=)`, 'g');
  for (const { name, code } of await addonCode()) {
    for (const match of code.matchAll(call)) {
      if (FORBIDDEN.has(match[3])) found.push(`${name}:${lineOf(code, match.index)} ${match[1]}${match[2]}:${match[3]}`);
    }
    for (const match of code.matchAll(write)) found.push(`${name}:${lineOf(code, match.index)} ${match[1]}${match[2]} =`);
  }
  assert.deepEqual(found, []);
});

test('nothing opens a panel or changes a game setting, and nothing gets round the rules', async () => {
  const found = [];
  for (const { name, code } of await addonCode()) {
    for (const match of code.matchAll(/(?<![\w.:])(rawset|SetCVar|SetCVarBitfield|ShowUIPanel|HideUIPanel|securecall|issecurevariable|ReloadUI|ConsoleExec|OpenToCategory|EnterEditMode|C_EditMode|CooldownViewerSettings|RunMacroText|ChatEdit_SendText)\b/g)) {
      found.push(`${name}:${lineOf(code, match.index)} ${match[1]}`);
    }
  }
  assert.deepEqual(found, []);
});

const RUN = ['loadstring', 'load', 'loadfile', 'dofile', 'RunScript', 'RunMacroText', 'RunMacro', 'setfenv', 'getfenv', 'getglobal'];
test('no text is ever run as code', async () => {
  const found = [];
  const named = new RegExp(String.raw`(?<![\w])(${RUN.join('|')})(?![\w])`, 'g');
  for (const { name, source, code } of await addonCode()) {
    for (const match of code.matchAll(named)) found.push(`${name}:${lineOf(source, match.index)} ${match[1]}`);
    for (const { text, index } of literals(source)) {
      const piece = RUN.find(word => text === word || (text.length >= 4 && word.startsWith(text)));
      if (piece) found.push(`${name}:${lineOf(source, index)} "${text}" (${piece} by name)`);
    }
  }
  assert.deepEqual(found, [], 'nothing names a way to run text');
});

// Its names in the game's global space: frames named FECP..., its saved
// settings, its command, and the shared link. Never Forever Enhanced Cooldown
// Manager's (FECM..., /ccm, /fecm), so the two never collide when both load.
// More from Squirt (Window.lua) opens the author's other addons by the names
// they give their command and settings window: read there, never written.
// FECMIcon.tga is this addon's own copy of that logo.
const MORE_NAMES = ['FECM', 'FECMFrame', 'FECMIcon.tga'];
test('every name in the game\'s global space is the addon\'s own', async () => {
  const found = [];
  for (const { name, source, code } of await addonCode()) {
    for (const match of source.matchAll(/CreateFrame\(\s*"\w+"\s*,\s*"([^"]+)"/g)) {
      if (!match[1].startsWith('FECP')) found.push(`${name}:${lineOf(source, match.index)} frame ${match[1]}`);
    }
    for (const match of code.matchAll(/\b(SLASH_\w+|SlashCmdList\s*\.\s*\w+|_G\s*\.\s*\w+\s*=(?!=)|FECM\w*|CCM\w*)/g)) {
      const text = match[1].replace(/\s+/g, '');
      if (!['SLASH_FECP1', 'SlashCmdList.FECP', '_G.ForeverPulseLink='].includes(text)) found.push(`${name}:${lineOf(code, match.index)} ${text}`);
    }
    for (const { text, index } of literals(source)) {
      if (name === 'Window.lua' && MORE_NAMES.includes(text)) continue;
      if (/^\/(ccm|fecm)\b|^FECM/i.test(text)) found.push(`${name}:${lineOf(source, index)} "${text}"`);
    }
    // Nothing is put in the game's global space by a name worked out as it runs.
    for (const match of code.matchAll(/\b(SlashCmdList|_G)\s*\[[^\]\n]*\]\s*=(?!=)/g)) {
      found.push(`${name}:${lineOf(code, match.index)} ${match[1]}[...] =`);
    }
  }
  assert.deepEqual(found, []);
  const more = codeOnly(await read('Window.lua'));
  assert.equal(count(more, /\b(SlashCmdList|_G)\s*\[/g), 2, 'More from Squirt reads one command and one window by name');
  assert.equal(count(more, /local run, other = SlashCmdList and SlashCmdList\[more\.slash\], _G\[more\.frame\]/g), 1, 'into locals');
  const core = codeOnly(await read('Core.lua'));
  assert.match(core, /\n\s*SLASH_FECP1 = ""\s*SlashCmdList\.FECP = function/, '/fecp, its only command');
  assert.match(await read('Core.lua'), /SLASH_FECP1 = "\/fecp"/);
  assert.equal(count(core, /SLASH_/g), 1, 'and no other');
});

// Forever Enhanced Cooldown Manager's saved settings are only read, in
// Link.lua alone, and only while it's loaded; nothing of it is ever called
// but its command, when More from Squirt's Open is clicked (Window.lua).
test('Forever Enhanced Cooldown Manager\'s saved settings are only read, in Link.lua', async () => {
  const found = [];
  for (const { name, source, code } of await addonCode()) {
    for (const match of code.matchAll(/ForeverEnhancedCooldownManagerDB/g)) {
      if (name !== 'Link.lua') found.push(`${name}:${lineOf(source, match.index)}`);
    }
  }
  assert.deepEqual(found, [], 'only Link.lua reaches them');
  const link = codeOnly(await read('Link.lua'));
  assert.equal(count(link, /ForeverEnhancedCooldownManagerDB/g), 1, 'reached once');
  assert.match(link, /local saved = _G\.ForeverEnhancedCooldownManagerDB\r?\n/, 'into a local');
  assert.doesNotMatch(link, /ForeverEnhancedCooldownManagerDB\s*=(?!=)|\bsaved\s*(\.\s*\w+|\[[^\]]*\])\s*=(?!=)/, 'never written');
  assert.match(link, /if Older\(\) and OlderOn\(\)/, 'and only while it\'s loaded');
});

// A function defined on a name the file doesn't own would replace one of the game's.
test('the game\'s functions are never replaced', async () => {
  const found = [];
  for (const { name, code } of await addonCode()) {
    const own = new Set();
    for (const match of code.matchAll(/\blocal\s+function\s+([A-Za-z_]\w*)/g)) own.add(match[1]);
    for (const match of code.matchAll(/\blocal\s+([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)*)/g)) {
      for (const part of match[1].split(',')) own.add(part.trim());
    }
    for (const match of code.matchAll(/\bfunction\s*[\w.:]*\s*\(([^)]*)\)/g)) {
      for (const part of match[1].split(',')) own.add(part.trim());
    }
    for (const match of code.matchAll(/\bfunction\s+([A-Za-z_]\w*)((?:\s*[.:]\s*\w+)*)\s*\(/g)) {
      if (!own.has(match[1])) found.push(`${name}:${lineOf(code, match.index)} function ${match[1]}${match[2]}`);
    }
  }
  assert.deepEqual(found, [], "global functions are the game's; the addon keeps its own on ns or in locals");
});

test('no function is defined twice in one file', async () => {
  const found = [];
  for (const { name, code } of await addonCode()) {
    const seen = new Set();
    for (const match of code.matchAll(/\bfunction\s+([A-Za-z_]\w*\s*[.:]\s*[A-Za-z_][\w.:]*)\s*\(/g)) {
      const fn = match[1].replace(/\s+/g, '');
      if (seen.has(fn)) found.push(`${name}:${lineOf(code, match.index)} ${fn}`);
      seen.add(fn);
    }
  }
  assert.deepEqual(found, []);
});

// The art: every file used, each an uncompressed 32-bit TGA, square and a
// power of two across: the icon at 128, the minimap's mark at 64, and
// More from Squirt's logos (copies of EraUI's and Forever Enhanced Cooldown
// Manager's) at 128.
test('the art: every file used, and each one the game can load', async () => {
  const media = (await readdir(new URL('Media/', root))).sort();
  assert.deepEqual(media, ['EraUIIcon.tga', 'FECMIcon.tga', 'FECPIcon.tga', 'Heart.tga', 'MinimapIcon.tga', 'TourArrow.tga']);
  const sources = (await Promise.all((await rootFiles(/\.(lua|toc)$/i)).map(read))).join('\n');
  const sizes = {};
  for (const file of media) {
    assert.ok(sources.includes(file), `${file} is used`);
    const data = await readFile(new URL(`Media/${file}`, root));
    const width = data.readUInt16LE(12), height = data.readUInt16LE(14);
    assert.equal(data[2], 2, `${file}: uncompressed`);
    assert.equal(data[16], 32, `${file}: 32-bit`);
    assert.equal(data[17], 8, `${file}: 8 bits of alpha, bottom row first`);
    assert.equal(width, height, `${file}: square`);
    assert.equal(width & (width - 1), 0, `${file}: a power of two`);
    // Whole: every pixel, then at most the 26-byte footer some tools add.
    const pixels = 18 + width * height * 4;
    const footer = data.length === pixels + 26 && data.toString('latin1', data.length - 18) === 'TRUEVISION-XFILE.\0';
    assert.ok(data.length === pixels || footer, `${file}: whole`);
    sizes[file] = width;
  }
  assert.deepEqual(sizes, { 'EraUIIcon.tga': 128, 'FECMIcon.tga': 128, 'FECPIcon.tga': 128, 'Heart.tga': 32, 'MinimapIcon.tga': 64,
    'TourArrow.tga': 32 });
  // The minimap's mark fills its square, as Forever Enhanced Cooldown
  // Manager's does: something drawn (its ring is see-through) within a few
  // pixels of each edge.
  const mark = await readFile(new URL('Media/MinimapIcon.tga', root));
  const solid = (x, y) => mark[18 + (y * 64 + x) * 4 + 3] > 40;
  const edges = { left: false, right: false, top: false, bottom: false };
  for (let i = 0; i < 64; i++) {
    for (let d = 0; d < 4; d++) {
      if (solid(d, i)) edges.left = true;
      if (solid(63 - d, i)) edges.right = true;
      if (solid(i, d)) edges.bottom = true;
      if (solid(i, 63 - d)) edges.top = true;
    }
  }
  assert.deepEqual(edges, { left: true, right: true, top: true, bottom: true }, 'the mark fills the square');
  // The CurseForge avatar: a 400 square PNG.
  const png = await readFile(new URL('Tools/CurseForgeAvatar.png', root));
  assert.equal(png.toString('ascii', 1, 4), 'PNG');
  assert.deepEqual([png.readUInt32BE(16), png.readUInt32BE(20)], [400, 400], 'the avatar, 400 square');
});

test('no em dashes in anything players read', async () => {
  for (const name of await rootFiles(/\.(lua|toc|md|txt)$/i)) {
    assert.doesNotMatch(await read(name), /[—–]/, name);
  }
  const escaped = /\\226\\128\\14[78]|\\x[eE]2\\x80\\x9[34]|\\u\{0*201[34]\}/;
  const found = [];
  for (const { name, source } of await addonCode()) {
    for (const { text, index } of literals(source)) if (escaped.test(text)) found.push(`${name}:${lineOf(source, index)}`);
  }
  assert.deepEqual(found, [], 'no em dash written as an escape');
});

// Other addons are never named, in the addon, its text or its tests. Their
// names are kept here as hashes only, so this file names none either. Squirt's
// own addons (OWN) are passed over whole: Forever Enhanced Cooldown Manager
// is named where the pulse runs there instead, so a word or two of its name
// that another addon's name shares counts as its own. Nothing else of the
// list is let through.
const OTHERS = new Set(['06826c441678339a', 'fdd508e96907f59b', '7f466e6770936442',
  '9c30a3e707dcf583', '72ecb0128ced47c2', '6fc79fada620a1c9', 'e52a90bc5daa975e', 'af6d017462ed41ba', '0bbe8420d9c30286',
  '5cab34c79b0b9875', '007e4d0cfa14fe5f', '4f23dd1f73797e72', '88ed36849a168ebc', '95926befd4f439b3', '9f576eec3619bfe2',
  '17e96a475e1830bf', 'f12a22af8df5e508', '3494444fd5c12c8c', '16614b5df8db4ed3', '89c5df462dcb969f', '8e1fd1320c1ec0c9',
  '7b841cc1685b8265', '6ab18144a65cb982', '94d9217d231a426a', '0cdaf053d971025e', 'f2b83e490eacf0ab', 'f570e5c3bf419861',
  '7641fefdddae81a8', 'f30b3dec56800f2d', 'b36304575a067c83', '36b8e826fe73ecd1', '9f7ffe1ac0b90e2d', 'f6642857381c08dc',
  'fb8e46d54110a9ff', '1b9c0bcd7113eacd', '2e21a65ec2ad8687', 'd69e0ac49ca8e11d', 'dafeaf414c71197e', 'f0354e832758ef47',
  'c92ae2f85364c65b', '02aca0a6f01611ce', '1c835ab4bac854a0', 'e04637df5b0cfa3e', '47e63f8db8f80cf8', '14061dabb7e78781',
  '50fc4e00bb14b506', '6c2d526afba9d1ef', '367e9594e3d906d2']);
const hash = text => createHash('sha1').update(text).digest('hex').slice(0, 16);
const OWN = ['forever enhanced cooldown manager', 'forever enhanced cooldown pulse', 'fecm', 'fecp'].map(name => name.split(' '));

function ownWords(words) {
  const own = new Set();
  for (let i = 0; i < words.length; i++) {
    for (const name of OWN) {
      if (name.every((word, j) => words[i + j] === word)) name.forEach((_, j) => own.add(i + j));
    }
  }
  return own;
}

test('no other addon is named anywhere', async () => {
  const names = [...await rootFiles(/\.(lua|toc|md|txt|html)$|^\.pkgmeta$|^\.gitignore$/i)];
  for (const name of await readdir(new URL('Tools/', root))) {
    if (/\.(lua|mjs|js|html)$/i.test(name)) names.push(`Tools/${name}`);
  }
  assert.ok(names.includes('Tools/TestRules.mjs') && names.includes('Core.lua'), 'the files to check');
  const found = [];
  for (const name of names) {
    const words = (await read(name)).toLowerCase().split(/[^a-z0-9]+/).filter(Boolean);
    const own = ownWords(words);
    for (let i = 0; i < words.length; i++) {
      for (let n = 1; n <= 4 && i + n <= words.length; n++) {
        if (words.slice(i, i + n).some((_, j) => own.has(i + j))) continue;
        if (OTHERS.has(hash(words.slice(i, i + n).join(' ')))) found.push(`${name}: word ${i + 1}`);
      }
    }
  }
  assert.deepEqual(found, []);
  // Only Squirt's own names, whole, are passed over: the words they share
  // with the list still count anywhere else.
  const shared = OWN[0].slice(1);
  assert.ok(OTHERS.has(hash(shared.join(' '))), "a name the list has, shared in part with one of Squirt's");
  assert.equal(ownWords(shared).size, 0, 'counted on its own');
  assert.equal(ownWords(['forever', ...shared]).size, 4, 'and passed over only as part of the whole own name');
});

// Never the game's tooltip: an addon writing into it taints it, and in
// Forever it then breaks on your hidden health every frame it shows a player
// (thousands of errors, 2026-10-06). The addon's own (Theme.lua T:ShowTip).
test("never the game's tooltip", async () => {
  const names = (await readdir(root)).filter(name => name.endsWith('.lua'));
  const using = [];
  for (const name of names) if (/\bGameTooltip\b/.test(noComments(await read(name)))) using.push(name);
  assert.deepEqual(using, [], 'files using GameTooltip');
});

// Escape closes the addon's windows through the game's own list of windows
// it closes (UISpecialFrames), never by changing key bindings: a binding
// changed from addon code has the game rebuild your action bars and state
// inside the addon's code, which then breaks on your hidden health
// (thousands of errors, 2026-10-06). Tools/TestWindow.lua checks Escape
// closes them, and the mock game counts any binding call as a violation.
const BINDING = String.raw`SetOverrideBinding\w*|ClearOverrideBindings?|SetBinding\w*|SaveBindings|LoadBindings`;
test('no key binding is ever changed from addon code', async () => {
  const found = [];
  const named = new RegExp(String.raw`(?<![\w])(${BINDING})(?![\w])`, 'g');
  const byName = new RegExp(String.raw`^(${BINDING})$`);
  for (const { name, source, code } of await addonCode()) {
    for (const match of code.matchAll(named)) found.push(`${name}:${lineOf(source, match.index)} ${match[1]}`);
    for (const { text, index } of literals(source)) {
      if (byName.test(text)) found.push(`${name}:${lineOf(source, index)} "${text}" by name`);
    }
    if (/EscUpdate|EscButton/.test(noComments(source))) found.push(`${name}: the old Escape button`);
  }
  assert.deepEqual(found, [], 'nothing changes a key binding');
});

test("Escape closes the windows through the game's own list", async () => {
  const [core, window, notes, debug] = await Promise.all(['Core.lua', 'Window.lua', 'Notes.lua', 'Debug.lua']
    .map(async name => noComments(await read(name))));
  assert.equal(count(core, /table\.insert\(UISpecialFrames, name\)/g), 1, 'ns.CloseOnEscape lists a window by name');
  assert.equal(count(window, /ns\.CloseOnEscape\(window\)/g), 1, 'the /fecp window');
  assert.equal(count(notes, /ns\.CloseOnEscape\(window\)/g), 1, "What's new");
  assert.equal(count(debug, /table\.insert\(UISpecialFrames, "FECPDebugFrame"\)/g), 1, 'the debug report');
});
