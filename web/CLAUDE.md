# web (React)

React + TypeScript + Vite implementation of the design system. Shared rules, sources of truth and workflows are in `../CLAUDE.md`; component specs in `../docs/components.md`.

## Code layout
- `src/styles/primitives.css`: the 201 primitives from the Tokens file as CSS variables (`--yuanhhouColorBlue100`, `--yuanhhouSpacing150`, spacing on the 8pt rule: 100 = 8px). Components never use them directly; they use the semantic variables below. The iOS twin is `DSPrimitive.swift`.
- `src/styles/tokens.css`: CSS variables mirroring the Figma variables (themes via `data-theme`, density via `data-density`). Variable names are the WEB code syntax of the Figma variables, for example `--color-background-brand-primary`.
- `src/components/<Name>/`: `Name.tsx` + `Name.css`, exported from `src/components/index.ts`. Component CSS uses only token variables, never hex or raw spacing that has a token.
- `src/App.tsx`: demo shell (title, language, theme, appearance and density menus) that shows the catalog or one page.
- `src/showcase/`: the demo pages, the same structure as the iOS DS catalog. `pages.ts` lists Foundations (Colors, Typography, Spacing and radius, Icons) and Components in alphabetical order; `Catalog.tsx` is the home list; `ComponentPages.tsx` and `FoundationPages.tsx` hold one page per entry, built from `ShowcasePage` and `ShowcaseSection`. Routes are hashes (`#/button`). A new component gets a page and an entry in `pages.ts`, in alphabetical order.
- `src/i18n/`: English and Japanese. Add every UI string to both `en` and `ja` in `messages.ts` and read it with `useI18n().t(key)`; never hardcode user-facing text. The provider sets `<html lang>`, and the font stack falls back to Japanese system fonts.

## Commands
- `npm run dev` start, `npm run build` (type-check + build), `npm run lint` (oxlint). Run build and lint after any code change.

## Web rules
- An icon that triggers an action is an `IconButton` and needs `aria-label`; `Icon` is display only.
- **Button Large is 48px from padding** (12 + 24 line height), not a fixed height. Button outlines are drawn with a pseudo-element border, so they never change the button's size and render evenly on all four edges.
- Pressed and Disabled are `:active` and `:disabled`, not props. Focus is a 2px `--color-border-focus` outline.
- Form controls are native elements (`input type="checkbox"`, `radio`, `fieldset` + `legend`) styled with tokens.
