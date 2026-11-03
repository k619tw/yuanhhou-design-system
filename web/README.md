# web

React + TypeScript + Vite implementation of the design system, published as the package `@yuanhhou/ds`. See the [root README](../README.md) for the whole project.

```bash
npm install
npm run dev        # demo catalog at http://localhost:5173 (one page per foundation and component)
npm run build      # type-check and build the demo
npm run build:lib  # build the package into lib/ (index.js, style.css, types)
npm run lint       # oxlint
```

Components are in `src/components/`, tokens in `src/styles/` (`primitives.css`, `tokens.css`, and `colors.css`, which is generated from `../tokens/colors.json`), English and Japanese strings for the demo in `src/i18n/`.

## Using the package in an app
```bash
npm install ../path/to/web          # or a packed tarball: npm pack, then npm install yuanhhou-ds-0.1.0.tgz
```
```tsx
import { Button } from '@yuanhhou/ds'
import '@yuanhhou/ds/style.css'

document.documentElement.dataset.theme = 'light' // dark, eva-light, eva-dark, heritage-luxury-light, heritage-luxury-dark

<Button variant="primary">Save</Button>
```
React 19 is a peer dependency. Load the fonts in the page, as `index.html` does: Figtree (400, 600) and Material Symbols Rounded from Google Fonts. `package.json` is `private` so it cannot be published by accident; remove that when you choose a registry (npm or GitHub Packages).
