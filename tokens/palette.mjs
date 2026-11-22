#!/usr/bin/env node
// The one colour palette (`color/<hue>/<50-900>`, `color/white`, `color/black` and `color/alpha/*` in the Tokens file,
// collection `01 Primitives`). Every brand, semantic and accent colour aliases these values.
//
// Every hue is built in OKLCH at the same relative luminance per step, so a step pairing gives the same contrast in
// every hue. Purple and lime carry more chroma (the EVA violet and neon); gray and sand are near-neutrals.
// Accents use one fixed step mapping, the same in every brand:
//   Light: subtler 100, subtle 200, bolder 500, text 600, bolder text 700, border 500
//   Dark:  subtler 900, subtle 800, bolder 400, text 300, bolder text 200, border 400
//
//   node tokens/palette.mjs           print the palette and the WCAG AA audit of tokens/colors.json (all six modes)
//   node tokens/palette.mjs --write   rewrite the colour primitives in primitives.css and DSPrimitive.swift
//   node tokens/palette.mjs --check   exit 1 when those files are out of date or any audited pair fails
//
// New values are entered in the Tokens file (or with a use_figma script), exported with export-figma.js, then
// `node tokens/generate.mjs` writes the semantic colours.
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const steps = { 50: 0.93, 100: 0.88, 200: 0.72, 300: 0.45, 400: 0.3, 500: 0.16, 600: 0.09, 700: 0.045, 800: 0.022, 900: 0.01 }
const chroma = {
  standard: { 50: 0.02, 100: 0.045, 200: 0.09, 300: 0.14, 400: 0.16, 500: 0.16, 600: 0.14, 700: 0.12, 800: 0.09, 900: 0.06 },
  vivid: { 50: 0.03, 100: 0.06, 200: 0.14, 300: 0.22, 400: 0.26, 500: 0.26, 600: 0.25, 700: 0.2, 800: 0.15, 900: 0.1 },
  neon: { 50: 0.03, 100: 0.07, 200: 0.26, 300: 0.26, 400: 0.24, 500: 0.2, 600: 0.16, 700: 0.13, 800: 0.1, 900: 0.07 },
  sand: { 50: 0.006, 100: 0.01, 200: 0.016, 300: 0.022, 400: 0.028, 500: 0.032, 600: 0.032, 700: 0.028, 800: 0.02, 900: 0.012 },
  gray: Object.fromEntries(Object.keys(steps).map((s) => [s, 0.006])),
}
// OKLCH hue angle and chroma table per hue.
const hues = {
  blue: [258, 'standard'],
  teal: [192, 'standard'],
  green: [148, 'standard'],
  lime: [128, 'neon'],
  yellow: [88, 'standard'],
  orange: [48, 'standard'],
  red: [25, 'standard'],
  magenta: [345, 'standard'],
  purple: [305, 'vivid'],
  gray: [265, 'gray'],
  sand: [70, 'sand'],
}
export const accentHues = ['blue', 'teal', 'green', 'lime', 'yellow', 'orange', 'red', 'magenta', 'purple', 'gray']

const toLinear = (c) => (c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4)
const toGamma = (c) => (c <= 0.0031308 ? 12.92 * c : 1.055 * c ** (1 / 2.4) - 0.055)
export const luminance = (hex) => {
  const [r, g, b] = [0, 2, 4].map((i) => toLinear(parseInt(hex.slice(i, i + 2), 16) / 255))
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
}
export const contrast = (a, b) => {
  const [x, y] = [luminance(a), luminance(b)]
  return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05)
}
const oklchToLinearRgb = (L, C, H) => {
  const a = C * Math.cos((H * Math.PI) / 180)
  const b = C * Math.sin((H * Math.PI) / 180)
  const l = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3
  const m = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3
  const s = (L - 0.0894841775 * a - 1.291485548 * b) ** 3
  return [4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s, -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s, -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s]
}
const inGamut = (rgb) => rgb.every((c) => c >= -1e-4 && c <= 1 + 1e-4)
const toHex = (rgb) =>
  rgb.map((c) => Math.round(Math.min(1, Math.max(0, toGamma(Math.min(1, Math.max(0, c))))) * 255).toString(16).padStart(2, '0')).join('').toUpperCase()
// The largest chroma up to `maxChroma` that stays in sRGB at this lightness and hue.
const fit = (L, maxChroma, H) => {
  let c = maxChroma
  while (c > 0 && !inGamut(oklchToLinearRgb(L, c, H))) c -= 0.002
  return toHex(oklchToLinearRgb(L, Math.max(c, 0), H))
}
// Binary search on OKLCH lightness for the target relative luminance.
const make = (H, maxChroma, target) => {
  let [lo, hi] = [0, 1]
  for (let i = 0; i < 40; i++) {
    const mid = (lo + hi) / 2
    if (luminance(fit(mid, maxChroma, H)) < target) lo = mid
    else hi = mid
  }
  return fit(lo, maxChroma, H)
}

export const ramps = Object.fromEntries(
  Object.entries(hues).map(([hue, [H, table]]) => [hue, Object.fromEntries(Object.entries(steps).map(([step, target]) => [step, make(H, chroma[table][step], target)]))]),
)
// Name (camel case after `yuanhhouColor` / `color`) and hex RRGGBB or RRGGBBAA, in file order.
const cap = (s) => s[0].toUpperCase() + s.slice(1)
const alphaSteps = [10, 20, 30, 40, 50, 60, 70, 80, 90]
const alphaHex = (a) => Math.round((a / 100) * 255).toString(16).padStart(2, '0').toUpperCase()
export const primitives = [
  ...Object.entries(ramps).flatMap(([hue, ramp]) => Object.entries(ramp).map(([step, hex]) => [`${cap(hue)}${step}`, hex])),
  ['White', 'FFFFFF'],
  ['Black', '000000'],
  // Alpha white is gray 50 and alpha black is gray 900, at 10% to 90%.
  ...alphaSteps.map((a) => [`AlphaWhite${a}`, ramps.gray[50] + alphaHex(a)]),
  ...alphaSteps.map((a) => [`AlphaBlack${a}`, ramps.gray[900] + alphaHex(a)]),
]

export const accentMapping = {
  light: { 'background/accent/HUE/subtler': 100, 'background/accent/HUE/subtle': 200, 'background/accent/HUE/bolder': 500, 'foreground/accent/HUE': 600, 'foreground/accent/HUE/bolder': 700, 'border/accent/HUE': 500 },
  dark: { 'background/accent/HUE/subtler': 900, 'background/accent/HUE/subtle': 800, 'background/accent/HUE/bolder': 400, 'foreground/accent/HUE': 300, 'foreground/accent/HUE/bolder': 200, 'border/accent/HUE': 400 },
}

// WCAG AA audit of the exported semantic colours. Each entry: foreground, background, minimum ratio.
const statuses = ['brand', 'info', 'success', 'warning', 'error', 'promote']
function pairs() {
  const list = []
  for (const bg of ['background/primary', 'background/secondary']) {
    for (const fg of ['foreground/primary', 'foreground/secondary', 'foreground/hero', 'action/primary', ...statuses.map((s) => `foreground/${s}`)]) list.push([fg, bg, 4.5])
    for (const b of ['border/tertiary', 'border/focus', ...statuses.map((s) => `border/${s}`)]) list.push([b, bg, 3])
  }
  for (const s of statuses) {
    for (const bg of ['primary', 'primary-pressed']) list.push([`foreground/${s}/on/primary`, `background/${s}/${bg}`, 4.5])
    for (const bg of ['secondary', 'secondary-pressed']) list.push([`foreground/${s}/on/secondary`, `background/${s}/${bg}`, 4.5])
  }
  for (const bg of ['background/inverted-primary', 'background/inverted-secondary']) for (const fg of ['foreground/inverted/primary', 'foreground/inverted/secondary']) list.push([fg, bg, 4.5])
  list.push(['background/primary', 'action/primary', 3])
  for (const hue of accentHues) {
    for (const bg of ['background/primary', 'background/secondary', `background/accent/${hue}/subtler`, `background/accent/${hue}/subtle`]) {
      list.push([`foreground/accent/${hue}`, bg, 4.5])
      list.push([`foreground/accent/${hue}/bolder`, bg, 7])
    }
    list.push(['foreground/accent/on/bolder', `background/accent/${hue}/bolder`, 4.5])
    for (const bg of ['background/primary', 'background/secondary']) list.push([`border/accent/${hue}`, bg, 3])
  }
  return list
}
export function audit() {
  const tokens = JSON.parse(readFileSync(join(root, 'tokens/colors.json'), 'utf8'))
  const failures = []
  let count = 0
  for (const mode of tokens.modes) {
    for (const [fg, bg, min] of pairs()) {
      const a = tokens.colors[`color/${fg}`]?.[mode]
      const b = tokens.colors[`color/${bg}`]?.[mode]
      if (!a || !b) throw new Error(`Missing color/${a ? bg : fg} in tokens/colors.json`)
      const ratio = contrast(a.slice(0, 6), b.slice(0, 6))
      count++
      if (ratio < min) failures.push(`${fg} on ${bg} (${mode}): ${ratio.toFixed(2)}:1, needs ${min}:1`)
    }
  }
  return { count, failures }
}

const files = {
  css: [join(root, 'web/src/styles/primitives.css'), /^ {2}--yuanhhouColor\w+: #[0-9a-f]+;\n/gm, ([n, hex]) => `  --yuanhhouColor${n}: #${hex.toLowerCase()};\n`],
  swift: [
    join(root, 'ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/DSPrimitive.swift'),
    /^ {4}public static let color\w+ = Color\(dsHex: "[0-9A-F]+"\)\n/gm,
    ([n, hex]) => `    public static let color${n} = Color(dsHex: "${hex}")\n`,
  ],
}
// Replace the block of colour lines (wherever they start) with the current palette.
const render = (text, pattern, line) => {
  const matches = [...text.matchAll(pattern)]
  if (!matches.length) throw new Error('No colour primitives found')
  const start = matches[0].index
  const end = matches.at(-1).index + matches.at(-1)[0].length
  return text.slice(0, start) + primitives.map(line).join('') + text.slice(end).replace(pattern, '')
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  const write = process.argv.includes('--write')
  const check = process.argv.includes('--check')
  let stale = false
  for (const [path, pattern, line] of Object.values(files)) {
    const text = readFileSync(path, 'utf8')
    const next = render(text, pattern, line)
    if (next === text) continue
    if (write) {
      writeFileSync(path, next)
      console.log(`Wrote ${path.slice(root.length + 1)}`)
    } else {
      stale = true
      console.log(`Out of date: ${path.slice(root.length + 1)} (run node tokens/palette.mjs --write)`)
    }
  }
  if (!write && !check) for (const [hue, ramp] of Object.entries(ramps)) console.log(hue.padEnd(8), Object.values(ramp).join(' '))
  const { count, failures } = audit()
  console.log(`\nWCAG AA audit of tokens/colors.json: ${count - failures.length} of ${count} pairs pass in all six modes.`)
  for (const f of failures) console.log(`  FAIL ${f}`)
  if (check && (stale || failures.length)) process.exit(1)
}
