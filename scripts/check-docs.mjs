#!/usr/bin/env node
/* Docs name only what exists.
 *
 * The docs have described things that were already gone or never shipped, again and again: Row (iOS) after it left
 * DS - Components, stale theme and accordion text, the Segmented Control (iOS) copy, a wrong Badge node id, and
 * `.dsListBackground()` taught as package API when it lives only in the demo app. A person (or an agent) reading the
 * docs then writes code that does not compile, or uses a token that does not exist.
 *
 * This reads every Markdown file except CHANGELOG.md (history may name removed things) and checks each code span
 * and code block:
 *   - Swift: every `DSSomething` type and `.dsSomething` modifier or style is declared in the YuanhhouDSKit package
 *     (a name ending in `.swift` must be a file under ios/);
 *   - CSS: every `--color-*`, `--radius-*`, `--spacing-*`, ... custom property is defined in web/src;
 *   - Tokens: every colour path (`background/primary`, `color/foreground/brand/on/primary`) is in tokens/colors.json.
 * Names with a placeholder such as `<role>` are skipped.
 *
 * Usage: node scripts/check-docs.mjs */
import { readFileSync, readdirSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'

const root = join(import.meta.dirname, '..')
const SKIP_DIRS = new Set(['node_modules', 'lib', 'dist', 'build', '.git', 'DerivedData', '.build', '.swiftpm'])

function walk(dir, keep, out = []) {
  for (const name of readdirSync(dir)) {
    if (SKIP_DIRS.has(name)) continue
    const path = join(dir, name)
    if (statSync(path).isDirectory()) walk(path, keep, out)
    else if (keep(path)) out.push(path)
  }
  return out
}
const read = (path) => readFileSync(path, 'utf8')

// What exists.
const kitSwift = walk(join(root, 'ios/YuanhhouDSKit/Sources'), (p) => p.endsWith('.swift')).map(read).join('\n')
const swiftNames = new Set(
  [...kitSwift.matchAll(/\b(?:struct|enum|class|protocol|typealias|actor|func|var|let|case)\s+`?([A-Za-z_]\w*)/g)].map((m) => m[1]),
)
const swiftFiles = new Set(walk(join(root, 'ios'), (p) => p.endsWith('.swift')).map((p) => p.split('/').pop()))
const css = walk(join(root, 'web/src'), (p) => p.endsWith('.css')).map(read).join('\n')
const cssVars = new Set([...css.matchAll(/(--[a-z0-9-]+)\s*:/g)].map((m) => m[1]))
const tokens = JSON.parse(read(join(root, 'tokens/colors.json')))
const colorPaths = new Set(Object.keys(tokens.colors))

// What the docs name.
const docs = walk(root, (p) => p.endsWith('.md') && !p.endsWith('CHANGELOG.md'))
const problems = []
for (const file of docs) {
  const text = read(file)
  const spans = [
    ...[...text.matchAll(/```[^\n]*\n([\s\S]*?)```/g)].map((m) => [m[1], m.index]),
    ...[...text.replace(/```[\s\S]*?```/g, (block) => ' '.repeat(block.length)).matchAll(/`([^`\n]+)`/g)].map((m) => [m[1], m.index]),
  ]
  for (const [code, index] of spans) {
    const line = text.slice(0, index).split('\n').length
    const where = `${relative(root, file)}:${line}`
    for (const [, name, ext] of code.matchAll(/\b(DS[A-Z]\w*)(\.swift)?\b/g)) {
      if (ext ? !swiftFiles.has(`${name}.swift`) : !swiftNames.has(name)) problems.push(`${where} names \`${name}${ext ?? ''}\`, which is not in YuanhhouDSKit`)
    }
    for (const [, name] of code.matchAll(/(?<![\w$])\.(ds[A-Z]\w*)/g)) {
      if (!swiftNames.has(name)) problems.push(`${where} names \`.${name}\`, which is not in YuanhhouDSKit`)
    }
    for (const [, name] of code.matchAll(/(?<![\w-])(--(?:color|radius|spacing|space|size|typography|shadow|border|opacity|font|density)-[a-z0-9-]*[a-z0-9])(?![\w-]*[<*])/g)) {
      if (!cssVars.has(name)) problems.push(`${where} names \`${name}\`, which no stylesheet in web/src defines`)
    }
    for (const [, path] of code.matchAll(/(?<![\w/<-])((?:color\/)?(?:background|foreground|action|border)\/[a-z0-9/-]*[a-z0-9])(?![\w/-]*[<*{])/g)) {
      if (/^(?:color\/)?border\/width\//.test(path)) continue // Dimension tokens, not colours
      const full = path.startsWith('color/') ? path : `color/${path}`
      if (!colorPaths.has(full)) problems.push(`${where} names the colour \`${path}\`, which is not in tokens/colors.json`)
    }
  }
}

if (problems.length) {
  console.error(`check-docs: ${problems.length} name${problems.length === 1 ? '' : 's'} in the docs that the code does not have:\n`)
  for (const p of problems) console.error(`- ${p}`)
  console.error('\nFix the doc (or add the missing API) in the same change.')
  process.exit(1)
}
console.log(`check-docs: every Swift name, CSS variable and colour token in ${docs.length} Markdown files exists in the code.`)
