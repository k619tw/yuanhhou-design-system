# tokens

One source for the theme tokens of both platforms, so web and iOS cannot drift apart: the semantic colors and the corner radii that follow the brand.

| File | What |
|---|---|
| `colors.json` | The Figma Tokens library, collection `02 Semantics`, in the six modes (Light, Dark, EVA Light, EVA Dark, Cedar Light, Cedar Dark): every color as hex `RRGGBB` or `RRGGBBAA`, and every `radius/*` in points |
| `export-figma.js` | Read-only Figma Plugin API script that produces `colors.json` |
| `palette.mjs` | The one colour palette every brand, semantic and accent colour aliases: eleven hues (`color/<hue>/<50-900>`) at the same relative luminance per step, plus white, black and alpha. `node tokens/palette.mjs` prints it and the WCAG AA audit of `colors.json` (all six modes); `--write` updates the colour primitives in `primitives.css` and `DSPrimitive.swift`; `--check` fails when they are out of date or a pair fails |
| `generate.mjs` | Writes `web/src/styles/colors.css`, `web/src/styles/shape.css`, `DSColor+Tokens.swift` and `DSShape+Tokens.swift` (in `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/`) from `colors.json` |

## Brand shape
The semantic radii (`radius/control`, `card`, `dialog`, `sheet`, `pill`) have a value per mode, so each brand has its own corners: Default is round, EVA is sharp (0), Cedar is soft. Light and Dark of one brand match. On web they are CSS variables per `data-theme`; on iOS, `@Environment(\.dsShape)` returns them for the current `DSTheme`. `radius/none` is 0 everywhere and stays with the Dimension scale.

## When the colors or radii change in Figma
1. Publish the Tokens library.
2. Run `export-figma.js` on the Tokens file (`5iR1wP3qoTT4uD6d20ekVv`) with the Figma MCP `use_figma` tool, and save the returned JSON as `colors.json`.
3. Run `node tokens/generate.mjs` from the repo root, then build both platforms.

`node tokens/generate.mjs --check` exits with an error when any generated file is out of date, for CI, and `node tokens/palette.mjs --check` does the same for the colour primitives and the contrast audit. The Dimension scale, typography and the spacing, radius and opacity primitives are still copied by hand (`tokens.css`, `primitives.css`, `DSDimension.swift`, `DSPrimitive.swift`).

## When the palette changes
1. Change `tokens/palette.mjs` and run it: every audited pair must still pass.
2. Enter the new values in `01 Primitives` of the Tokens file (a `use_figma` script can set them), and re-point any semantic alias that should move.
3. Run `node tokens/palette.mjs --write`, then export and generate as above.
