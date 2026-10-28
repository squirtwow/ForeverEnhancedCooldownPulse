// The words in Simplified Chinese (Locale.lua), checked straight from the
// source: every word the addon looks up (ns.L["..."], and the English kept
// in tables for the names, the notes, the tour and More from Squirt, looked
// up where they show) has its Chinese, and Locale.lua has nothing nobody
// looks up; each keeps its %s, %d and the rest in the same order, its colour
// and icon codes and its line breaks; none is empty or has an em dash; and
// the Chinese uses full-width punctuation. Tools/TestLocale.lua shows the
// window in Chinese and checks no English is left on it.
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

const shipped = async () => (await read('ForeverEnhancedCooldownPulse.toc')).split(/\r?\n/)
  .filter(line => line && !line.startsWith('#'));

// What the addon looks up, by file: as written, and the English its tables keep.
async function used() {
  const words = new Map();
  const add = (file, list) => list.forEach(text => words.set(text, words.get(text) || file));
  for (const file of await shipped()) {
    if (file === 'Locale.lua') continue;
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

// Locale.lua's Simplified Chinese: each English and its Chinese, in order.
async function chinese() {
  const list = tokens(await read('Locale.lua'));
  const inside = block(list, 'LANGUAGES . zhCN = {');
  const pairs = [];
  for (let i = 0; i < inside.length; i++) {
    if (inside[i].value === '[' && inside[i + 1]?.type === 'string' && inside[i + 2]?.value === ']' && inside[i + 3]?.value === '=') {
      const text = joined(inside, i + 4);
      assert.ok(text, `the Chinese for "${inside[i + 1].value}" is text`);
      pairs.push([inside[i + 1].value, text.text]);
      i = text.next - 1;
    }
  }
  return pairs;
}

const FORMAT = /%[-+ #0]*\d*(?:\.\d+)?[cdiouxXeEfgGqs%]/g;
const CODES = /\|c[0-9a-fA-F]{8}|\|r|\|T|\|t|\n/g;
const CJK = /[\u3000-\u303f\u4e00-\u9fff\uff00-\uffef]/;

test('every word the addon looks up has its Simplified Chinese', async () => {
  const words = await used();
  assert.ok(words.size > 250, `the words found (${words.size})`);
  const zh = new Map(await chinese());
  const missing = [...words].filter(([text]) => !zh.has(text)).map(([text, file]) => `${file}: ${JSON.stringify(text)}`);
  assert.deepEqual(missing, [], 'looked up, with no Chinese');
});

test('Locale.lua has nothing nobody looks up, and each word once', async () => {
  const words = await used();
  const pairs = await chinese();
  assert.deepEqual(pairs.map(([text]) => text).filter(text => !words.has(text)), [], 'Chinese for words never looked up');
  const seen = new Set();
  assert.deepEqual(pairs.map(([text]) => text).filter(text => seen.has(text) || !seen.add(text)), [], 'given twice');
});

test('each Chinese keeps its placeholders, codes and line breaks, in order', async () => {
  const wrong = [];
  for (const [english, zh] of await chinese()) {
    const a = english.match(FORMAT) || [], b = zh.match(FORMAT) || [];
    if (a.join(' ') !== b.join(' ')) wrong.push(`${english}: ${a.join(' ')} vs ${b.join(' ')}`);
    const c = english.match(CODES) || [], d = zh.match(CODES) || [];
    if (c.join(' ') !== d.join(' ')) wrong.push(`${english}: codes ${JSON.stringify(c)} vs ${JSON.stringify(d)}`);
  }
  assert.deepEqual(wrong, []);
});

test('none empty, none with an em dash, the Chinese in full-width punctuation', async () => {
  const wrong = [];
  for (const [english, zh] of await chinese()) {
    if (!zh.trim()) wrong.push(`${english}: empty`);
    if (/[—–]/.test(english + zh)) wrong.push(`${english}: an em dash`);
    if (!CJK.test(zh)) wrong.push(`${english}: no Chinese in ${zh}`);
    // ASCII punctuation beside Chinese: a full stop, comma, colon, question
    // or exclamation mark, or brackets, which Chinese writes full width.
    const plain = zh.replace(FORMAT, 'X').replace(/\|c[0-9a-fA-F]{8}|\|r|\|T.*?\|t/g, '');
    if (/[\u4e00-\u9fff\uff09\u300d][,.:;!?()]|[,.:;!?()][\u4e00-\u9fff\uff08\u300c]|[,.:;!?]$/.test(plain)) wrong.push(`${english}: ASCII punctuation in ${zh}`);
  }
  assert.deepEqual(wrong, []);
});

test('the language choice: Auto, English or Simplified Chinese, Auto by default', async () => {
  const core = await read('Core.lua');
  assert.match(core, /language = "auto", --/, 'Auto by default');
  const locale = await read('Locale.lua');
  assert.match(locale, /ns\.LANGUAGE_KEYS = \{ "auto", "enUS", "zhCN" \}/);
  assert.match(locale, /local game = GetLocale and GetLocale\(\)/, 'Auto asks the game');
  assert.match(await read('Window.lua'), /key == "zhCN" and "简体中文" or "English"/, 'each language by its own name');
});
