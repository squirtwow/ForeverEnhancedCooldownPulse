// Every language's words (Locales/<code>.lua, gathered by Locale.lua),
// checked straight from the source: every word the addon looks up
// (ns.L["..."], and the English kept in tables for the names, the notes,
// the tour and More from Squirt, looked up where they show) is in each
// file, and no file has a word nobody looks up; each keeps its %s, %d and
// the rest in the same order, its colour and icon codes and its line
// breaks; none is empty or has an em dash; the Chinese uses full-width
// punctuation. Then, each language on its own, that nothing is still left
// in English but the few words that are rightly the same (SAME): that one
// fails until the language's translator is done. Tools/TestLocale.lua
// shows the window in every language and checks no English is left on it.
// Run with: node --test Tools/TestLocale.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const root = new URL('../', import.meta.url);
const read = name => readFile(new URL(name, root), 'utf8');

// Lua's text: strings (their value), names, numbers and marks; comments left out.
function tokens(lua) {
  const out = [];
  let i = 0;
  const unescape = body => body.replace(/\\(\d{1,3}|.)/gs, (_, c) => {
    if (/^\d+$/.test(c)) return String.fromCharCode(Number(c));
    return { n: '\n', t: '\t', r: '\r', a: '\x07', b: '\b', f: '\f', v: '\v', '\n': '\n' }[c] ?? c;
  });
  while (i < lua.length) {
    const rest = lua.slice(i);
    let m;
    if ((m = rest.match(/^--\[(=*)\[[\s\S]*?\]\1\]/)) || (m = rest.match(/^--[^\n]*/)) || (m = rest.match(/^\s+/))) {
      // a comment, or space
    } else if ((m = rest.match(/^\[(=*)\[([\s\S]*?)\]\1\]/))) {
      out.push({ type: 'string', value: m[2].replace(/^\r?\n/, ''), at: i });
    } else if ((m = rest.match(/^"((?:[^"\\\n]|\\[\s\S])*)"/)) || (m = rest.match(/^'((?:[^'\\\n]|\\[\s\S])*)'/))) {
      out.push({ type: 'string', value: unescape(m[1]), at: i });
    } else if ((m = rest.match(/^[A-Za-z_]\w*/))) {
      out.push({ type: 'name', value: m[0], at: i });
    } else if ((m = rest.match(/^(0x[\da-fA-F]+|\d+(\.\d*)?([eE][-+]?\d+)?|\.\d+)/))) {
      out.push({ type: 'number', value: m[0], at: i });
    } else if ((m = rest.match(/^(\.\.\.|\.\.|==|~=|<=|>=|::|[^\s\w])/))) {
      out.push({ type: 'mark', value: m[0], at: i });
    } else {
      m = [lua[i]];
    }
    i += m[0].length;
  }
  return out;
}

// A string, or strings joined with .., from token i: its text and the token after it.
function joined(list, i) {
  if (list[i]?.type !== 'string') return null;
  let text = list[i].value, j = i + 1;
  while (list[j]?.value === '..' && list[j + 1]?.type === 'string') {
    text += list[j + 1].value;
    j += 2;
  }
  return { text, next: j };
}

// Every word looked up as written: L["..."] or ns.L["..."] (the strings
// inside, joined), so long as the brackets hold only text.
function lookups(list) {
  const found = [];
  list.forEach((token, i) => {
    if (!(token.type === 'name' && token.value === 'L' && list[i + 1]?.value === '[')) return;
    const before = list[i - 1];
    if (before && (before.value === ':' || (before.value === '.' && list[i - 2]?.value !== 'ns'))) return;
    const text = joined(list, i + 2);
    if (text && list[text.next]?.value === ']') found.push(text.text);
  });
  return found;
}

// The table made at `start` (a run of tokens ending in "{"): its tokens.
function block(list, start) {
  const want = start.split(' ');
  for (let i = 0; i < list.length; i++) {
    if (!want.every((word, j) => list[i + j]?.value === word)) continue;
    let depth = 0;
    for (let j = i + want.length - 1; j < list.length; j++) {
      if (list[j].value === '{') depth++;
      if (list[j].value === '}' && --depth === 0) return list.slice(i + want.length, j);
    }
  }
  assert.fail(`${start} found`);
}

// The text given to these fields in a table: name = "...", and so on.
function fields(list, names) {
  const found = [];
  list.forEach((token, i) => {
    if (token.type === 'name' && names.includes(token.value) && list[i + 1]?.value === '=' && list[i - 1]?.value !== '.') {
      const text = joined(list, i + 2);
      if (text) found.push(text.text);
    }
  });
  return found;
}

// Every string in a table that isn't given to one of these fields.
function values(list, except = []) {
  const found = [];
  list.forEach((token, i) => {
    if (token.type !== 'string' || list[i - 1]?.value === '..') return;
    if (list[i - 1]?.value === '=' && except.includes(list[i - 2]?.value)) return;
    if (list[i + 1]?.value === '=' || list[i - 1]?.value === '[') return; // a key, not a value
    found.push(joined(list, i).text);
  });
  return found;
}

// The files the game loads, in order, folders with a forward slash.
const shipped = async () => (await read('ForeverEnhancedCooldownPulse.toc')).split(/\r?\n/)
  .filter(line => line && !line.startsWith('#')).map(line => line.replace(/\\/g, '/'));

// Each language's file: its code and path, as the .toc loads them.
const LOCALES = ['deDE', 'frFR', 'esES', 'ptBR', 'ruRU', 'zhCN'];
const localeFile = code => `Locales/${code}.lua`;

// What the addon looks up, by file: as written, and the English its tables keep.
async function used() {
  const words = new Map();
  const add = (file, list) => list.forEach(text => words.set(text, words.get(text) || file));
  for (const file of await shipped()) {
    if (file === 'Locale.lua' || file.startsWith('Locales/')) continue;
    const list = tokens(await read(file));
    add(file, lookups(list));
    if (file === 'Core.lua') {
      for (const name of ['PULSE_BORDER_NAMES', 'PULSE_SOUND_NAMES', 'PULSE_STYLE_NAMES']) {
        add(file, values(block(list, `ns . ${name} = {`)));
      }
    }
    if (file === 'Theme.lua') add(file, fields(block(list, 'T . ACCENTS = {'), ['name']));
    if (file === 'Spells.lua') add(file, fields(block(list, 'local FAMILIES = {'), ['name']));
    if (file === 'Window.lua') add(file, fields(block(list, 'local MORE = {'), ['about', 'installed', 'open']));
    if (file === 'Tour.lua') {
      for (const name of ['STEPS', 'NEWS', 'HELP']) {
        add(file, fields(block(list, `local ${name} = {`), ['title', 'text', 'try', 'alreadyText']));
      }
    }
    if (file === 'Notes.lua') add(file, values(block(list, 'ns . NOTES = {'), ['version']));
  }
  return words;
}

// A language's file: each English and its text in that language, in order.
async function pairsOf(code) {
  const list = tokens(await read(localeFile(code)));
  const inside = block(list, `ns . LOCALES . ${code} = {`);
  const pairs = [];
  for (let i = 0; i < inside.length; i++) {
    if (inside[i].value === '[' && inside[i + 1]?.type === 'string' && inside[i + 2]?.value === ']' && inside[i + 3]?.value === '=') {
      const text = joined(inside, i + 4);
      assert.ok(text, `${code}: the text for "${inside[i + 1].value}" is text`);
      pairs.push([inside[i + 1].value, text.text]);
      i = text.next - 1;
    }
  }
  return pairs;
}

const FORMAT = /%[-+ #0]*\d*(?:\.\d+)?[cdiouxXeEfgGqs%]/g;
const CODES = /\|c[0-9a-fA-F]{8}|\|r|\|T|\|t|\n/g;
const CJK = /[　-〿一-鿿＀-￯]/;

// The words that can rightly be the same as the English: names, in every
// language (NAMES); and in the languages written in Latin letters, words
// some of them share with English too (Orange, General, Version %s, Long,
// Fanfare, %g min and the seconds, " (experimental)", Procs, as players
// say it there). Russian and Chinese write those their own way. The same
// lists as Tools/TestLocale.lua's, checked below.
const NAMES = ['Discord', 'CurseForge', 'GitHub', 'EraUI', 'Forever Enhanced Cooldown Manager', 'OK'];
const SAME = [...NAMES, '%gs', '%.1fs', '%g min', 'Item %d', 'Version %s', 'General', 'Long', 'Orange', 'Gold', 'Fanfare', 'Synth',
  ' (experimental)', 'Procs'];
const LATIN = ['deDE', 'frFR', 'esES', 'ptBR'];
const allowed = code => LATIN.includes(code) ? SAME : NAMES;

test('the .toc loads every language\'s file, and only those', async () => {
  const files = (await shipped()).filter(file => file.startsWith('Locales/'));
  assert.deepEqual(files, LOCALES.map(localeFile));
});

for (const code of LOCALES) {
  test(`${code}: every word the addon looks up is there`, async () => {
    const words = await used();
    assert.ok(words.size > 250, `the words found (${words.size})`);
    const have = new Map(await pairsOf(code));
    const missing = [...words].filter(([text]) => !have.has(text)).map(([text, file]) => `${file}: ${JSON.stringify(text)}`);
    assert.deepEqual(missing, [], 'looked up, and not in the file');
  });

  test(`${code}: nothing nobody looks up, and each word once`, async () => {
    const words = await used();
    const pairs = await pairsOf(code);
    assert.deepEqual(pairs.map(([text]) => text).filter(text => !words.has(text)), [], 'words never looked up');
    const seen = new Set();
    assert.deepEqual(pairs.map(([text]) => text).filter(text => seen.has(text) || !seen.add(text)), [], 'given twice');
  });

  test(`${code}: each keeps its placeholders, codes and line breaks, in order`, async () => {
    const wrong = [];
    for (const [english, text] of await pairsOf(code)) {
      const a = english.match(FORMAT) || [], b = text.match(FORMAT) || [];
      if (a.join(' ') !== b.join(' ')) wrong.push(`${english}: ${a.join(' ')} vs ${b.join(' ')}`);
      const c = english.match(CODES) || [], d = text.match(CODES) || [];
      if (c.join(' ') !== d.join(' ')) wrong.push(`${english}: codes ${JSON.stringify(c)} vs ${JSON.stringify(d)}`);
    }
    assert.deepEqual(wrong, []);
  });

  test(`${code}: none empty, none with an em dash${code === 'zhCN' ? ', in full-width punctuation' : ''}`, async () => {
    const wrong = [];
    for (const [english, text] of await pairsOf(code)) {
      if (!text.trim()) wrong.push(`${english}: empty`);
      if (/[—–]/.test(english + text)) wrong.push(`${english}: an em dash`);
      if (code !== 'zhCN') continue;
      if (!CJK.test(text)) wrong.push(`${english}: no Chinese in ${text}`);
      // ASCII punctuation beside Chinese: a full stop, comma, colon, question
      // or exclamation mark, or brackets, which Chinese writes full width.
      const plain = text.replace(FORMAT, 'X').replace(/\|c[0-9a-fA-F]{8}|\|r|\|T.*?\|t/g, '');
      if (/[一-鿿）」][,.:;!?()]|[,.:;!?()][一-鿿（「]|[,.:;!?]$/.test(plain)) wrong.push(`${english}: ASCII punctuation in ${text}`);
    }
    assert.deepEqual(wrong, []);
  });
}

// Fails while a translator is still at work: each language on its own, so
// the run says which are done.
for (const code of LOCALES) {
  test(`${code}: nothing left in English (fails until it's translated)`, async () => {
    const left = (await pairsOf(code)).filter(([english, text]) => text === english && !allowed(code).includes(english));
    assert.equal(left.length, 0, `${left.length} still the same as their English, the first: `
      + left.slice(0, 5).map(([english]) => JSON.stringify(english)).join(', '));
  });
}

test('the words that can be the same are the same lists in Tools/TestLocale.lua', async () => {
  const list = tokens(await read('Tools/TestLocale.lua'));
  assert.deepEqual(values(block(list, 'local NAMES = {')), NAMES);
  assert.deepEqual(values(block(list, 'local SAME = {')), SAME.slice(NAMES.length), 'and SAME, after the names');
  assert.match(await read('Tools/TestLocale.lua'), /local LATIN = \{ deDE = true, frFR = true, esES = true, ptBR = true \}/);
});

test('the language choice: Auto by default, every language by its own name, Auto by the game', async () => {
  const core = await read('Core.lua');
  assert.match(core, /language = "auto", --/, 'Auto by default');
  const locale = await read('Locale.lua');
  assert.match(locale, /ns\.LANGUAGE_KEYS = \{ "auto", "enUS", "deDE", "frFR", "esES", "ptBR", "ruRU", "zhCN" \}/);
  const names = values(block(tokens(locale), 'ns . LANGUAGE_NAMES = {'));
  assert.deepEqual(names, ['English', 'Deutsch', 'Français', 'Español', 'Português (Brasil)', 'Русский', '简体中文'],
    'each language by its own name, never looked up');
  assert.match(locale, /local game = GetLocale and GetLocale\(\)/, 'Auto asks the game');
  assert.match(locale, /local GAME = \{ deDE = "deDE", frFR = "frFR", esES = "esES", esMX = "esES", ptBR = "ptBR", ruRU = "ruRU", zhCN = "zhCN" \}/,
    'one Spanish for Spain and Latin America; any other game English');
  assert.match(await read('Window.lua'), /label = names\[key\]/, 'the list shows the names as they are');
});
