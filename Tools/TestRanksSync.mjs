// Ranks.lua is two tables from Forever Enhanced Cooldown Manager's own
// Ranks.lua (generated there by its Tools/GenerateRanks.mjs from Blizzard's
// game data): ns.RANKS, every class spell and active racial with the spell
// IDs of all its ranks, and ns.COOLDOWNS, the base cooldown of each that has
// one. The pulse lists a spell when its base cooldown is longer than the
// global cooldown, and asks the game only of a spell the data doesn't cover.
// With Forever Enhanced Cooldown Manager beside this addon (C:/AddonDev),
// this checks the copy still matches; after it regenerates its Ranks.lua,
// copy the two tables across with: node Tools/TestRanksSync.mjs --write
// Run with: node --test Tools/TestRanksSync.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const ours = new URL('../Ranks.lua', import.meta.url);
const theirs = new URL('../../ForeverEnhancedCooldownManager/Ranks.lua', import.meta.url);

const HEADER = [
  '-- Copied from Forever Enhanced Cooldown Manager\'s Ranks.lua, which is',
  '-- generated from Blizzard\'s game data for build 1.60.1.70170: every class',
  '-- spell and active racial with the spell IDs of all its ranks (ns.RANKS),',
  '-- and the base cooldown in seconds of every spell ID there that has one',
  '-- (ns.COOLDOWNS). Tools/TestRanksSync.mjs checks the copy and refreshes it.',
  '-- Do not edit.',
  'local _, ns = ...',
];

// One table of a Ranks.lua, from its "ns.NAME = {" line to its closing "}".
function block(lines, name) {
  const start = lines.indexOf(`ns.${name} = {`);
  const end = lines.findIndex((line, i) => i > start && line === '}');
  assert.ok(start >= 0 && end > start, `ns.${name} found`);
  return lines.slice(start, end + 1);
}

function expected() {
  const lines = readFileSync(theirs, 'utf8').split(/\r?\n/);
  return [...HEADER, ...block(lines, 'RANKS'), ...block(lines, 'COOLDOWNS'), ''].join('\n');
}

if (process.argv.includes('--write')) {
  writeFileSync(ours, expected());
  console.log('Ranks.lua copied from Forever Enhanced Cooldown Manager');
} else {
  test('Ranks.lua is its two tables, and nothing else', () => {
    const lines = readFileSync(ours, 'utf8').split(/\r?\n/);
    assert.deepEqual(lines.slice(0, HEADER.length), HEADER, 'the header');
    const ranks = block(lines, 'RANKS'), cooldowns = block(lines, 'COOLDOWNS');
    assert.equal(lines.length, HEADER.length + ranks.length + cooldowns.length + 1, 'only the two tables');
    assert.ok(ranks.length > 500 && cooldowns.length > 400, 'both whole');
    // The spells the tests count on.
    for (const [id, seconds] of [[22812, 60], [5211, 60], [7384, 5], [17, 4], [871, 900], [1856, 300], [8122, 30], [1259416, 120]]) {
      assert.ok(cooldowns.includes(` [${id}]=${seconds},`), `${id}: ${seconds} s`);
    }
  });

  test('the same as Forever Enhanced Cooldown Manager\'s, when it\'s there', { skip: !existsSync(theirs) && 'not beside this addon' }, () => {
    assert.equal(readFileSync(ours, 'utf8').replace(/\r\n/g, '\n'), expected(),
      'Ranks.lua differs: copy it across with node Tools/TestRanksSync.mjs --write');
  });
}
