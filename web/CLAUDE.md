# ds-web

React + TypeScript + Vite implementation of the Figma design system **DS - Components**. Figma and this repo are kept in sync by hand (through Claude), so every change that touches one must be checked against the other.

## Sources of truth
| What | Where |
|---|---|
| Components | Figma file `GLymoPHNnAmM4irCifF2Ei` (DS - Components). Pages `01 — Accordion` … `10 — Radio`, then `Foundation` and `Typography`. Component set node ids are in `docs/components.md` |
| Colors | Figma file `5iR1wP3qoTT4uD6d20ekVv` (Tokens), library collection `02 Semantics` (modes Light, Dark, EVA, Heritage Luxury). Primitives in `01 Primitives` |
| Spacing, radius, size, border width | `Dimension` collection in DS - Components, plus semantic `radius/*` and `space/*` in the Tokens library |
| Typography | Text styles `<Style>/Regular|Emphasized`; mode axes: collection `Platform` (Web, iOS) and `Typography` (density Compact, Default, Loose) |
| Rules and color pairing | `design-system-rules.md` |
| Per-component docs | `docs/components.md`, one section per component (also shown on each Figma page in a frame named `Component documentation`) |
| iOS (SwiftUI) | `/Users/yuanhou/Desktop/App Work/docs/ios.md` (component map, selection patterns, tokens; lives in the iOS repo next to the Swift code) |

## Code layout
- `src/styles/primitives.css`: the 201 primitives from the Tokens file as CSS variables (`--yuanhhouColorBlue100`, `--yuanhhouSpacing150`, spacing on the 8pt rule: 100 = 8px). Components never use them directly; they use the semantic variables below. The iOS twin is `DSPrimitive.swift`.
- `src/styles/tokens.css`: CSS variables mirroring the Figma variables (themes via `data-theme`, density via `data-density`). Variable names are the WEB code syntax of the Figma variables, for example `--color-background-brand-primary`.
- `src/components/<Name>/`: `Name.tsx` + `Name.css`, exported from `src/components/index.ts`. Component CSS uses only token variables, never hex or raw spacing that has a token.
- `src/App.tsx`: demo of every component.
- `src/i18n/`: English and Japanese. Add every UI string to both `en` and `ja` in `messages.ts` and read it with `useI18n().t(key)`; never hardcode user-facing text. The provider sets `<html lang>`, and the font stack falls back to Japanese system fonts.

## Commands
- `npm run dev` start, `npm run build` (type-check + build), `npm run lint` (oxlint). Run build and lint after any code change.

## Rules that must hold
- **Icon rule:** a Utility Icon (`Icon`) is display only. An icon that triggers an action is an `IconButton` (needs `aria-label`). Icons inside Button, Badge and Input are display only.
- **Color pairing:** follow the table in `design-system-rules.md`. Never put a foreground on a surface it was not designed for. All text pairs were audited at 4.5:1 and borders at 3:1.
- **Button Large is 48px from padding** (12 + 24 line height), not a fixed height. Button outlines are drawn with a pseudo-element border, so they never change the button's size and render evenly on all four edges.
- Pressed and Disabled are `:active` and `:disabled`, not props. Hover and Focus are not in Figma yet: focus is a 2px `--color-border-focus` outline.
- **Native first on every platform:** before building a control, check what the platform already provides (on iOS the SwiftUI/HIG control; on web the semantic HTML element). Use it and style it with tokens; build custom only when there is no native equivalent, and say why in the iOS repo's `docs/ios.md`. iOS has no checkbox or radio, so use `Toggle`, `Picker` and checkmark rows first. Details and the per-component table are in `design-system-rules.md` (Platform rule).
- No hardcoded colors. If a color is missing, add it to the Tokens file, publish the library, then add the CSS variable.

The two workflows below are packaged as the skill `/sync-component <Component|tokens> [figma|code]` (`.claude/skills/sync-component`), which runs them for React and SwiftUI together.

## Workflow: a change in Figma
1. Read the current Figma values (use the Figma MCP `use_figma` read-only, or `get_design_context`). Do not trust earlier docs over Figma.
2. Update the component CSS/TSX and `tokens.css` if a token changed.
3. Update the component's section in `docs/components.md`, `design-system-rules.md` and the iOS repo's `docs/ios.md` if the iOS usage changes.
4. Update the `Component documentation` frame on that Figma page so it matches the markdown.
5. `npm run build` and `npm run lint`; for visual changes, check the demo in the browser.

## Workflow: a change in code
Apply the same edit to the Figma component (variants, properties, bound variables), then follow steps 3 to 5 above. Library token changes need the user to publish the Tokens library and accept the update in DS - Components before they can be verified there.

## Figma conventions
- Variant properties are Title Case: `Type`, `State`, `Size`, `Style`, `Orientation`, `Checked`, `Expanded`.
- Icons are chosen with instance swap properties (right panel), not slots. Slots are only for free-form content (Image Card image, Accordion content, Input trailing action).
- Bind fills, strokes, padding, gap and radius to variables. Component colors bind only to the Tokens library.
- Do not rename the `Component documentation` frames; they are found by name.

## Known gaps
- Hover and Focus states are not drawn in Figma.
- Button Small (36), Icon Button (48, 32) and Input heights are fixed values, not bound to `size/control/*`.
- Accordion: Figma shows the chevron as an Icon Button instance; code draws the same look but not a nested button (invalid HTML inside a button).
- Not built: Select, Tabs, Modal.
