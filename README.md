# yuanhhou design system

One Figma design system, built for two platforms: **React** for web and **SwiftUI** for iOS. Figma is the source of truth; a Claude Code skill (`/sync-component`) applies each change to both codebases, updates the docs and validates the result.

| Folder | What |
|---|---|
| `web/` | React + TypeScript + Vite: the `@yuanhhou/ds` package (components, CSS variable tokens) and an English and Japanese demo catalog |
| `ios/YuanhhouDSKit/` | The design system as a Swift package: tokens, `DSColor`, typography and the styles for native controls |
| `ios/YuanhhouDS.xcodeproj` | SwiftUI app: a catalog of Apple's native components and of the design system, with theme, appearance (Light or Dark), density and language switching |
| `tokens/` | `colors.json` (exported from Figma) and `generate.mjs`, which writes the color files for both platforms |
| `docs/workflow.md` | Diagrams of how Figma, the token generator, the two packages and the apps fit together, and the steps of every change (also in Figma: Ai Design Systems Workflow) |
| `docs/components.md` | One section per component: when to use, properties, layout, color tokens, do and don't, accessibility, code |
| `docs/ios.md` | How each component is used in SwiftUI, and the native-first rule |
| `design-system-rules.md` | Token layers, color pairing, contrast audit, platform rules |
| `.claude/skills/sync-component/` | The one command that syncs Figma, React and SwiftUI |
| `.claude/skills/release/` | `/release`: version, release notes (`CHANGELOG.md` and the Figma `Release Note` page) and tag |
| `CHANGELOG.md` | Every release, newest first |

## Run it
Web:
```bash
cd web
npm install
npm run dev
```
iOS: open `ios/YuanhhouDS.xcodeproj` in Xcode and run the `YuanhhouDS` scheme on a simulator.

## Use it in an app
- **Web:** `npm install @yuanhhou/ds`, then `import { applyTheme, Button } from '@yuanhhou/ds'` and `import '@yuanhhou/ds/style.css'`, and call `applyTheme()` once. Details in [web/README.md](web/README.md).
- **iOS** (iOS 17 or later, built with Xcode 26 or later): in Xcode, File > Add Package Dependencies, enter `https://github.com/k619tw/yuanhhou-design-system`, then `import YuanhhouDSKit`. At the root of the app use `.dsTheme(.default)` (or `.eva`, `.heritageLuxury`), which sets the palette and tints native controls, then `.buttonStyle(.ds(.primary))`, `DSColor` and `.dsTextStyle(.body1)` in views. See `ios/YuanhhouDSKit/README.md`.
- **Colors:** change them in Figma, export with `tokens/export-figma.js` into `tokens/colors.json`, and run `node tokens/generate.mjs`. See [tokens/README.md](tokens/README.md).

## What is in it
- Tokens from a Figma library: primitives plus semantic colors in six modes (Light, Dark, EVA Light, EVA Dark, Heritage Luxury Light, Heritage Luxury Dark: each brand in Light and Dark), spacing on an 8 pt scale, radius, sizes and typography with Web and iOS modes.
- Components: Button, Icon Button, Utility Icon, Badge, Image Card, Input, Toggle, Checkbox, Radio, Accordion.
- Accessibility: text pairs checked at 4.5:1 and borders at 3:1 in every mode; native controls first on iOS.
- English and Japanese on both platforms.

## License
[MIT](LICENSE)
