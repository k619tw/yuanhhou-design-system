#!/usr/bin/env node
/* Every UI string in English and Japanese (CLAUDE.md).
 *
 * The web strings are typed (`ja` must have every key of `en`, so the build fails on a gap). The iOS string catalogs
 * are not: Xcode adds a key with no Japanese and builds without a word, and the package test only checks the display
 * names. The demo app shipped "%lld selected" with no Japanese this way.
 *
 * This fails when any key in an iOS Localizable.xcstrings has no translated Japanese. Keys Xcode marked stale (no
 * longer in the code) and keys marked "Don't translate" are skipped.
 *
 * Usage: node scripts/check-strings.mjs */
import { readFileSync, readdirSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'

const root = join(import.meta.dirname, '..')
const walk = (dir, out = []) => {
  for (const name of readdirSync(dir)) {
    if (['node_modules', '.git', '.build', 'DerivedData'].includes(name)) continue
    const path = join(dir, name)
    if (statSync(path).isDirectory()) walk(path, out)
    else if (path.endsWith('.xcstrings')) out.push(path)
  }
  return out
}

/* A localization counts when its string, or every plural or device variation of it, is translated. */
const translated = (unit) => {
  if (!unit) return false
  if (unit.stringUnit) return unit.stringUnit.state === 'translated' && unit.stringUnit.value !== ''
  if (unit.variations) return Object.values(unit.variations).every((cases) => Object.values(cases).every(translated))
  if (unit.substitutions) return true
  return false
}

const catalogs = walk(join(root, 'ios'))
const problems = []
let keys = 0
for (const file of catalogs) {
  const { strings } = JSON.parse(readFileSync(file, 'utf8'))
  for (const [key, entry] of Object.entries(strings)) {
    if (entry.extractionState === 'stale' || entry.shouldTranslate === false || key.trim() === '') continue
    keys++
    if (!translated(entry.localizations?.ja)) problems.push(`${relative(root, file)}: "${key}" has no Japanese`)
  }
}

if (problems.length) {
  console.error(`check-strings: ${problems.length} iOS string${problems.length === 1 ? '' : 's'} without Japanese:\n`)
  for (const p of problems) console.error(`- ${p}`)
  console.error('\nAdd the Japanese in the String Catalog (Xcode) or in the .xcstrings JSON, state "translated".')
  process.exit(1)
}
console.log(`check-strings: all ${keys} iOS strings in ${catalogs.length} catalog${catalogs.length === 1 ? "" : "s"} have Japanese.`)
