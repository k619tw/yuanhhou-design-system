# ds-web

React + TypeScript + Vite implementation of the Figma design system **DS - Components**, kept in sync with the iOS app (`/Users/yuanhou/Desktop/App Work`).

```bash
npm install
npm run dev      # demo of every component at http://localhost:5173
npm run build    # type-check and build
npm run lint     # oxlint
```

## Where things are
| | |
|---|---|
| `src/components/<Name>/` | components (`Name.tsx` + `Name.css`), exported from `src/components/index.ts` |
| `src/styles/` | `primitives.css` and `tokens.css`: CSS variables mirroring the Figma Tokens library (themes Light, Dark, EVA, Heritage Luxury; density Compact, Default, Loose) |
| `src/i18n/` | English and Japanese strings |
| `docs/components.md` | one section per component: when to use, properties, layout, color tokens, do and don't, accessibility, code mapping |
| iOS repo `docs/ios.md` | how each component is used in SwiftUI, and the native-first rule (lives in `/Users/yuanhou/Desktop/App Work`) |
| `design-system-rules.md` | token layers, color pairing, contrast audit, building and implementing rules |
| `CLAUDE.md` | sources of truth, rules and the Figma-to-code workflow |
