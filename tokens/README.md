# tokens

One source for the semantic colors of both platforms, so web and iOS cannot drift apart.

| File | What |
|---|---|
| `colors.json` | The Figma Tokens library, collection `02 Semantics`: every color in the six modes (Light, Dark, EVA Light, EVA Dark, Heritage Luxury Light, Heritage Luxury Dark), as hex `RRGGBB` or `RRGGBBAA` |
| `export-figma.js` | Read-only Figma Plugin API script that produces `colors.json` |
| `generate.mjs` | Writes `web/src/styles/colors.css` and `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/DSColor+Tokens.swift` from `colors.json` |

## When the colors change in Figma
1. Publish the Tokens library.
2. Run `export-figma.js` on the Tokens file (`5iR1wP3qoTT4uD6d20ekVv`) with the Figma MCP `use_figma` tool, and save the returned JSON as `colors.json`.
3. Run `node tokens/generate.mjs` from the repo root, then build both platforms.

`node tokens/generate.mjs --check` exits with an error when either generated file is out of date, for CI. Dimensions, typography and primitives are still copied by hand (`tokens.css`, `primitives.css`, `DSDimension.swift`, `DSPrimitive.swift`).
