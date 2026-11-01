# yuanhhou design system

One Figma design system, built for two platforms: **React** for web and **SwiftUI** for iOS. Figma is the source of truth; a Claude Code skill (`/sync-component`) applies each change to both codebases, updates the docs and validates the result.

| Folder | What |
|---|---|
| `web/` | React + TypeScript + Vite. Components, CSS variable tokens, English and Japanese demo |
| `ios/` | SwiftUI app: a catalog of Apple's native components and of the design system, with theme, density and language switching |
| `docs/components.md` | One section per component: when to use, properties, layout, color tokens, do and don't, accessibility, code |
| `docs/ios.md` | How each component is used in SwiftUI, and the native-first rule |
| `design-system-rules.md` | Token layers, color pairing, contrast audit, platform rules |
| `.claude/skills/sync-component/` | The one command that syncs Figma, React and SwiftUI |

## Run it
Web:
```bash
cd web
npm install
npm run dev
```
iOS: open `ios/App Work.xcodeproj` in Xcode and run the `App Work` scheme on a simulator.

## What is in it
- Tokens from a Figma library: primitives plus semantic colors in four themes (Light, Dark, EVA, Heritage Luxury), spacing on an 8 pt scale, radius, sizes and typography with Web and iOS modes.
- Components: Button, Icon Button, Utility Icon, Badge, Image Card, Input, Toggle, Checkbox, Radio, Accordion.
- Accessibility: text pairs checked at 4.5:1 and borders at 3:1 in every theme; native controls first on iOS.
- English and Japanese on both platforms.
