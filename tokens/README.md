# tokens

One source for the theme tokens of both platforms, so web and iOS cannot drift apart: the semantic colors and the corner radii that follow the brand.

| File | What |
|---|---|
| `colors.json` | The Figma Tokens library, collection `02 Semantics`, in the six modes (Light, Dark, EVA Light, EVA Dark, Heritage Luxury Light, Heritage Luxury Dark): every color as hex `RRGGBB` or `RRGGBBAA`, and every `radius/*` in points |
| `export-figma.js` | Read-only Figma Plugin API script that produces `colors.json` |
| `generate.mjs` | Writes `web/src/styles/colors.css`, `web/src/styles/shape.css`, `DSColor+Tokens.swift` and `DSShape+Tokens.swift` (in `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/`) from `colors.json` |

## Brand shape
The semantic radii (`radius/control`, `card`, `dialog`, `sheet`, `pill`) have a value per mode, so each brand has its own corners: Default is round, EVA is sharp (0), Heritage Luxury is soft. Light and Dark of one brand match. On web they are CSS variables per `data-theme`; on iOS, `@Environment(\.dsShape)` returns them for the current `DSTheme`. `radius/none` is 0 everywhere and stays with the Dimension scale.

## When the colors or radii change in Figma
1. Publish the Tokens library.
2. Run `export-figma.js` on the Tokens file (`5iR1wP3qoTT4uD6d20ekVv`) with the Figma MCP `use_figma` tool, and save the returned JSON as `colors.json`.
3. Run `node tokens/generate.mjs` from the repo root, then build both platforms.

`node tokens/generate.mjs --check` exits with an error when any generated file is out of date, for CI. The Dimension scale, typography and primitives are still copied by hand (`tokens.css`, `primitives.css`, `DSDimension.swift`, `DSPrimitive.swift`).
