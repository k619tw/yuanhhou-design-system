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
The package is not on a registry yet. Until it is, install a packed file:
```bash
cd path/to/web && npm pack                                 # builds lib/ and writes yuanhhou-ds-<version>.tgz
cd path/to/your-app && npm install path/to/yuanhhou-ds-<version>.tgz
```
`lib/` is not in Git, so a fresh clone has nothing to install until `npm pack` builds it. Pack and install again to pick up kit changes. Commit the `.tgz` in the app if a hosting service has to build it.

```tsx
import { applyTheme, Button } from '@yuanhhou/ds'
import '@yuanhhou/ds/style.css'

applyTheme() // once when the app starts; or applyTheme('eva'), applyTheme('heritage-luxury')

<Button variant="primary">Save</Button>
```
`applyTheme` sets the brand and follows the device's Light or Dark setting, like `.dsTheme(_:)` on iOS. To force one mode, set `data-theme` on `<html>` instead: `light`, `dark`, `eva-light`, `eva-dark`, `heritage-luxury-light`, `heritage-luxury-dark`.

React 19 is a peer dependency. `style.css` loads Figtree and Material Symbols Rounded from Google Fonts, so there is nothing to add to the page. `package.json` is `private` so it cannot be published by accident; remove that when you choose a registry (npm or GitHub Packages).

**Do not install the folder with a plain `npm install ../path/to/web`.** That links to `web/`, which has its own copy of React. A production build then holds two Reacts, and every component that uses hooks (Input, Toggle, Accordion, Checkbox, Radio and the groups) crashes to a blank page, although `npm run dev` looks fine. To install from the folder, run `npm run build:lib` first, then:
```bash
npm install --install-links ../path/to/web
```
`--install-links` copies the package instead of linking it, so it needs running again after kit changes. If a linked folder is unavoidable, add `resolve: { dedupe: ['react', 'react-dom'] }` to the app's `vite.config.ts`.

### Tokens in your own CSS
Use the same variables as the components. Never hardcode a color, and follow the pairing table in [design-system-rules.md](../design-system-rules.md).

| What | Use |
|---|---|
| Color | `--color-<role>-<name>`, named like the Figma variable: `color/background/primary` is `--color-background-primary` |
| Spacing | `--spacing-2xs`, `xs`, `sm`, `md`, `lg`, `xl`, `2xl`, `3xl` (2 to 48) |
| Semantic space | `--space-inset-compact`, `default`, `comfortable`; `--space-gap-tight`, `inline`, `stack`, `section`; `--space-page-mobile`, `desktop` |
| Radius, size, border | `--radius-*`, `--size-icon-*`, `--size-control-*`, `--border-width-*` in `src/styles/tokens.css` |
| Text | `h1`, `h2`, `h3` and `p` are styled for you. Other elements take a class: `text-body-1`, `text-body-2`, `text-button-1`, `text-button-2`, `text-caption-1`, `text-caption-2`, `text-headline`, `text-large-title`, `text-title-1`, `text-title-2`, `text-title-3`, plus `text-emphasized` |

English and Japanese are up to the app: the package has no text of its own to translate on web, and `src/i18n/` belongs to the demo.
