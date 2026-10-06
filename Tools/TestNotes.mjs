// What's new in the game (Notes.lua) must say what CHANGELOG.txt says,
// version by version: nothing in either until the first release, then the
// same notes in both. Every tour step has the version it arrived in, the
// first release's waiting as ns.UNRELEASED for its number. No em dashes, and
// the footer's heart is drawn right.
// Run with: node --test Tools/TestNotes.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = name => readFile(new URL(`../${name}`, import.meta.url), 'utf8');
const STRING = '"((?:[^"\\\\]|\\\\.)*)"'; // a Lua string in double quotes
const unquote = text => text.replace(/\\(.)/g, '$1');

// The ns.NOTES table: each version's sections, then their bullets.
function gameNotes(lua) {
  const lines = lua.split(/\r?\n/);
  const start = lines.findIndex(line => line.trim() === 'ns.NOTES = {');
  const end = lines.findIndex((line, i) => i > start && line === '}');
  assert.ok(start >= 0 && end > start, 'ns.NOTES found in Notes.lua');
  const entries = [];
  for (const line of lines.slice(start + 1, end)) {
    let match;
    if ((match = line.match(new RegExp(`^\\s*version = ${STRING},\\s*$`)))) {
      entries.push({ version: unquote(match[1]), sections: [] });
    } else if ((match = line.match(new RegExp(`^\\s*\\{ ${STRING}, \\{\\s*$`)))) {
      entries.at(-1).sections.push({ title: unquote(match[1]), items: [] });
    } else if ((match = line.match(new RegExp(`^\\s*${STRING},\\s*$`)))) {
      entries.at(-1).sections.at(-1).items.push(unquote(match[1]));
    }
  }
  return entries;
}

// CHANGELOG.txt: "## version", then "### section" and "- bullet" lines.
function changelogNotes(text) {
  const entries = [];
  for (const line of text.split(/\r?\n/)) {
    let match;
    if ((match = line.match(/^## (.+)$/))) entries.push({ version: match[1].trim(), sections: [] });
    else if ((match = line.match(/^### (.+)$/))) entries.at(-1).sections.push({ title: match[1].trim(), items: [] });
    else if ((match = line.match(/^- (.+)$/))) entries.at(-1).sections.at(-1).items.push(match[1].trim());
  }
  return entries;
}

test('What\'s new in the game matches CHANGELOG.txt, version by version', async () => {
  const changelog = await read('CHANGELOG.txt');
  assert.match(changelog, /^# Changelog\r?\n/, 'CHANGELOG.txt starts as the packager expects');
  assert.deepEqual(gameNotes(await read('Notes.lua')), changelogNotes(changelog));
});

test('only the newest notes can wait for their version number', async () => {
  gameNotes(await read('Notes.lua')).forEach((entry, index) => {
    if (index === 0 && entry.version === 'Unreleased') return;
    assert.match(entry.version, /^\d+\.\d+(\.\d+)?$/, `"${entry.version}" is a version number`);
  });
});

// Tour.lua's steps, the full tour's then What's new's: each one's title and
// the version lines on it.
async function tourSteps() {
  const lua = (await read('Tour.lua')).replace(/\r\n/g, '\n');
  const steps = [];
  for (const list of ['STEPS', 'NEWS']) {
    const start = lua.indexOf(`\nlocal ${list} = {\n`);
    assert.ok(start >= 0, `${list} found in Tour.lua`);
    const block = lua.slice(start, lua.indexOf('\n}\n', start));
    for (const step of block.split(/\n    \{\n/).slice(1)) {
      const title = step.match(/^        title = "([^"]+)",$/m);
      steps.push({
        title: title ? title[1] : step.trim().split('\n')[1],
        versions: [...step.matchAll(/^        version = (?:"([^"]+)"|(ns\.UNRELEASED)),$/gm)],
      });
    }
  }
  return steps;
}

// Each step says the version it arrived in, so What's new can tour just an
// update's steps. A numbered one must be a version with notes; the first
// release's wait as ns.UNRELEASED until it gives them its number.
test('every tour step has the version it arrived in', async () => {
  const released = new Set(gameNotes(await read('Notes.lua')).map(entry => entry.version));
  const steps = await tourSteps();
  assert.deepEqual(steps.map(step => step.title), ['Turn it on', 'Pick your cooldowns', 'Quick and Long', 'Where it shows', 'General'],
    'the tour: the pulse page\'s four steps, then General');
  for (const step of steps) {
    assert.equal(step.versions.length, 1, `one version on: ${step.title}`);
    const [, number, placeholder] = step.versions[0];
    if (!placeholder) assert.ok(released.has(number), `"${number}" has notes in Notes.lua`);
  }
});

// Before the first release nothing has a number yet; once the notes have
// one, the steps waiting get it too.
test('tour steps waiting for their number get it with the first notes', async () => {
  const notes = gameNotes(await read('Notes.lua'));
  const waiting = (await tourSteps()).filter(step => step.versions[0]?.[2]).map(step => step.title);
  if (notes.length === 0 || notes[0].version === 'Unreleased') return;
  const numbered = (await tourSteps()).filter(step => step.versions[0]?.[1]).length;
  assert.ok(waiting.length === 0 || numbered > 0, `${waiting.join(', ')} still wait as ns.UNRELEASED, but ${notes[0].version} has its number`);
});

test('every section has bullets, and none use em dashes', async () => {
  for (const entry of gameNotes(await read('Notes.lua'))) {
    for (const section of entry.sections) {
      assert.ok(section.items.length > 0, `${entry.version} ${section.title} has bullets`);
      for (const item of section.items) assert.doesNotMatch(item, /[—–]/, item);
    }
  }
});

// The footer's credit draws its heart from Media: a 32x32 uncompressed 32-bit
// TGA, white so the accent can tint it, the right way up.
test('the footer heart is a white 32x32 TGA, point down', async () => {
  const name = (await read('Window.lua')).match(/local HEART = "([^"]+)"/)?.[1];
  assert.equal(name, 'Heart.tga', 'Window.lua names the heart');
  const tga = await readFile(new URL(`../Media/${name}`, import.meta.url));
  const size = 32;
  assert.deepEqual([tga[2], tga.readUInt16LE(12), tga.readUInt16LE(14), tga[16], tga[17]], [2, size, size, 32, 8],
    'uncompressed true colour, 32x32, 32 bits a pixel, 8 of them alpha, bottom row first');
  assert.equal(tga.length, 18 + size * size * 4, 'nothing after the pixels');
  const widths = [];
  let white = true;
  for (let row = 0; row < size; row++) {
    let solid = 0;
    for (let col = 0; col < size; col++) {
      const at = 18 + (row * size + col) * 4;
      if (tga[at] !== 255 || tga[at + 1] !== 255 || tga[at + 2] !== 255) white = false;
      if (tga[at + 3] > 127) solid++;
    }
    widths.push(solid);
  }
  assert.ok(white, 'white everywhere, so the tint is the accent');
  const widest = widths.indexOf(Math.max(...widths));
  assert.ok(widest > size / 2 && widths[1] < widths[widest] / 4, 'the lobes at the top, the point at the bottom');
});
