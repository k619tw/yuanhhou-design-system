#!/usr/bin/env node
/* Native first on iOS (the hard rule in CLAUDE.md).
 *
 * Custom iOS controls were built where SwiftUI already had one, and each was later thrown away: the DS checkbox and
 * radio (DSSelectionControls.swift, replaced by Toggle, Picker and checkmark rows), the custom text field (now
 * TextField with .dsTextField()), the custom accordion (now DisclosureGroup with a style), Row (iOS) and a Segmented
 * Control (iOS) copy in Figma.
 *
 * This fails when a public SwiftUI view in the YuanhhouDSKit package (what an app can use):
 *   - is named after a control iOS already has (Checkbox, Radio, Toggle, Picker, Segmented, Sheet, Row, ...), or
 *   - is not in docs/ios.md with its reason: "Custom because ..." or "A native `Button` ...".
 * Styles (`ButtonStyle`, `ToggleStyle`, `DisclosureGroupStyle`, ...), modifiers and the private views inside them are
 * the native-first way to brand a control, so they are not checked. Components belong in the package, not the demo
 * app, so a public DS view anywhere else in ios/ is checked too.
 *
 * Usage: node scripts/check-native-first.mjs */
import { readFileSync, readdirSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'

const root = join(import.meta.dirname, '..')
const walk = (dir, out = []) => {
  for (const name of readdirSync(dir)) {
    if (['.build', '.swiftpm', 'DerivedData'].includes(name)) continue
    const path = join(dir, name)
    if (statSync(path).isDirectory()) walk(path, out)
    else if (path.endsWith('.swift')) out.push(path)
  }
  return out
}

/* Controls SwiftUI (or UIKit through it) already draws, and what to use instead. */
const NATIVE = [
  [/Checkbox|CheckBox/, '`Toggle` for one yes or no, checkmark rows bound to a `Set` for several'],
  [/Radio/, '`Picker` (.inline, .menu or .segmented)'],
  [/Toggle|Switch/, '`Toggle` with `.dsTheme(_:)` for the tint'],
  [/Segmented/, '`Picker` with `.pickerStyle(.segmented)`'],
  [/Picker|Select|Dropdown|Menu/, '`Picker` or `Menu`'],
  [/Slider|Stepper/, '`Slider` or `Stepper`'],
  [/DatePicker|Calendar/, '`DatePicker`'],
  [/TextField|TextInput|Input|SearchBar|SearchField|TextEditor/, '`TextField`, `SecureField` or `.searchable` with `.dsTextField()`'],
  [/Sheet|Modal|Dialog|Alert|Popover|ActionSheet/, '`.sheet`, `.alert`, `.confirmationDialog` or `.popover`'],
  [/Row|Cell|ListItem|List|Section|Form/, '`List`, `Form` and `Section` rows'],
  [/Accordion|Disclosure|Expand/, '`DisclosureGroup` with `.disclosureGroupStyle(.dsAccordion)`'],
  [/TabBar|Tabs?$|NavigationBar|NavBar|Toolbar/, '`TabView`, `NavigationStack` and `.toolbar`'],
  [/Progress|Spinner|Loader|Gauge/, '`ProgressView` or `Gauge`'],
  [/^DSLink$|Hyperlink/, '`Link` with `.dsLink(_:)`'],
  [/Share/, '`ShareLink`'],
]

const map = readFileSync(join(root, 'docs/ios.md'), 'utf8').split('\n')
const reasonFor = (name) => map.find((line) => line.includes(name) && /custom because|a native `/i.test(line))

const problems = []
const files = walk(join(root, 'ios'))
for (const file of files) {
  const text = readFileSync(file, 'utf8')
  for (const m of text.matchAll(/\bpublic\s+(?:nonisolated\s+)?struct\s+(DS\w*)\s*(?:<[^>{]*>)?\s*:\s*([^{]+)\{/g)) {
    const [, name, conformances] = m
    const types = conformances.split(',').map((t) => t.trim())
    if (!types.includes('View') || types.some((t) => /Style$/.test(t))) continue
    const line = text.slice(0, m.index).split('\n').length
    const where = `${relative(root, file)}:${line}`
    if (reasonFor(name)) continue
    const native = NATIVE.find(([pattern]) => pattern.test(name.slice(2)))
    if (native) problems.push(`${where}: \`${name}\` redraws a control iOS already has. Use ${native[1]} instead, styled with tokens.`)
    else problems.push(`${where}: \`${name}\` is a custom view with no reason in docs/ios.md. Add it to the component map with "Custom because ..." (or "A native \`X\` ...").`)
  }
}

if (problems.length) {
  console.error(`check-native-first: ${problems.length} custom iOS view${problems.length === 1 ? '' : 's'} to justify or replace:\n`)
  for (const p of problems) console.error(`- ${p}`)
  console.error('\nCLAUDE.md: if SwiftUI has the control, use it styled with tokens; build custom only when it has none, and say why in docs/ios.md.')
  process.exit(1)
}
console.log(`check-native-first: every public DS view in ${files.length} Swift files has its reason in docs/ios.md, and none redraws a native control.`)
