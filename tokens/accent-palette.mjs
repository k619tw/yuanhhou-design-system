#!/usr/bin/env node
// Generates the accent primitives (`color/accent/<hue>/<100-900>` in the Tokens file, collection `01 Primitives`)
// and checks every accent pair against WCAG AA on the surfaces of all six modes.
//
// Every hue is built in OKLCH at the same relative luminance per step, so one step mapping passes AA for every hue:
//   Light: subtler 100, subtle 200, bolder 500, text 600, bolder text 700, border 500
//   Dark:  subtler 900, subtle 800, bolder 400, text 300, bolder text 200, border 400
// Accents are the same in every brand (Default, EVA, Cedar); only Light and Dark differ.
//
//   node tokens/accent-palette.mjs          print the palette (hex per hue and step) and the contrast audit
//   node tokens/accent-palette.mjs --css    print the lines for web/src/styles/primitives.css
//   node tokens/accent-palette.mjs --swift  print the lines for DSPrimitive.swift
//
// The output is entered in the Tokens file by hand (or with a use_figma script), then exported with export-figma.js.

const steps = { 100: 0.88, 200: 0.72, 300: 0.45, 400: 0.3, 500: 0.16, 600: 0.09, 700: 0.045, 800: 0.022, 900: 0.01 }
const chroma = { 100: 0.045, 200: 0.09, 300: 0.14, 400: 0.16, 500: 0.16, 600: 0.14, 700: 0.12, 800: 0.09, 900: 0.06 }
// OKLCH hue angle per accent. Gray is a near-neutral with a slight cool tint.
const hues = { blue: 258, teal: 192, green: 148, lime: 128, yellow: 88, orange: 48, red: 25, magenta: 345, purple: 305, gray: 265 }
const grayChroma = 0.006

export const mapping = {
  light: { 'background/accent/HUE/subtler': 100, 'background/accent/HUE/subtle': 200, 'background/accent/HUE/bolder': 500, 'foreground/accent/HUE': 600, 'foreground/accent/HUE/bolder': 700, 'border/accent/HUE': 500 },
  dark: { 'background/accent/HUE/subtler': 900, 'background/accent/HUE/subtle': 800, 'background/accent/HUE/bolder': 400, 'foreground/accent/HUE': 300, 'foreground/accent/HUE/bolder': 200, 'border/accent/HUE': 400 },
}
// `foreground/accent/on/bolder`: neutral 100 in Light modes, neutral 800 in Dark modes.
const onBolder = { light: 'FFFFFF', dark: '1A1A1A' }
// background/primary and background/secondary of each mode.
const surfaces = {
  Light: ['light', ['FFFFFF', 'F6F4F4']],
  Dark: ['dark', ['000000', '1A1A1A']],
  'EVA Light': ['light', ['FFFFFF', 'F6F4F4']],
  'EVA Dark': ['dark', ['320050', '1E0532']],
  'Cedar Light': ['light', ['FAF7F3', 'EEE8E0']],
  'Cedar Dark': ['dark', ['181513', '2A2520']],
}

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
  Object.entries(hues).map(([hue, H]) => [hue, Object.fromEntries(Object.entries(steps).map(([step, target]) => [step, make(H, hue === 'gray' ? grayChroma : chroma[step], target)]))]),
)

function audit() {
  const worst = {}
  const record = (pair, ratio, where) => {
    if (!worst[pair] || ratio < worst[pair].ratio) worst[pair] = { ratio: Number(ratio.toFixed(2)), where }
  }
  for (const [hue, ramp] of Object.entries(ramps)) {
    for (const [mode, [kind, page]] of Object.entries(surfaces)) {
      const get = (role) => ramp[mapping[kind][role]]
      const textSurfaces = [...page, get('background/accent/HUE/subtler'), get('background/accent/HUE/subtle')]
      for (const s of textSurfaces) {
        record('foreground/accent/<hue> on page, subtler, subtle (4.5)', contrast(get('foreground/accent/HUE'), s), `${hue} ${mode}`)
        record('foreground/accent/<hue>/bolder on the same (7)', contrast(get('foreground/accent/HUE/bolder'), s), `${hue} ${mode}`)
      }
      record('foreground/accent/on/bolder on background/accent/<hue>/bolder (4.5)', contrast(onBolder[kind], get('background/accent/HUE/bolder')), `${hue} ${mode}`)
      for (const s of page) record('border/accent/<hue> on page (3)', contrast(get('border/accent/HUE'), s), `${hue} ${mode}`)
    }
  }
  return worst
}

const cap = (s) => s[0].toUpperCase() + s.slice(1)
const entries = Object.entries(ramps).flatMap(([hue, ramp]) => Object.entries(ramp).map(([step, hex]) => [`${cap(hue)}${step}`, hex]))
if (process.argv[1] && import.meta.url.endsWith(process.argv[1].split('/').pop())) {
  if (process.argv.includes('--css')) console.log(entries.map(([n, hex]) => `  --yuanhhouColorAccent${n}: #${hex.toLowerCase()};`).join('\n'))
  else if (process.argv.includes('--swift')) console.log(entries.map(([n, hex]) => `    public static let colorAccent${n} = Color(dsHex: "${hex}")`).join('\n'))
  else {
    for (const [hue, ramp] of Object.entries(ramps)) console.log(hue.padEnd(8), Object.values(ramp).join(' '))
    console.log('\nLowest contrast per pair, all six modes:')
    for (const [pair, { ratio, where }] of Object.entries(audit())) console.log(`  ${pair}: ${ratio}:1 (${where})`)
  }
}
