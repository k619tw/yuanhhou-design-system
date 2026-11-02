# Design system rules (Figma to code)

Source of truth: Figma file `DS - Components` (key `GLymoPHNnAmM4irCifF2Ei`). Targets: web first (React + CSS custom properties), iOS/SwiftUI in sync (`ios/`, usage in `docs/ios.md`).

## Token layers

1. **Primitives** (library `Tokens` / `01 Primitives`; mirrors `ColorPrimitive` in `ColorPrimitives.swift`). Never used by components.
2. **Color**: components bind only to the **`Tokens` library collection `02 Semantics`** (Figma file `5iR1wP3qoTT4uD6d20ekVv`; modes Light, Dark, EVA, Heritage Luxury; names like `color/background/brand/primary`). Never bind to the local `Color`/`Primitives` collections in this file (they are an unused mirror). Focus rings use `color/border/focus`; pressed overlays use `color/background/overlay`. When a color is missing, add it to the Tokens file, publish, then bind.
3. **Dimension**: `spacing/*`, `radius/*` (`sm` 8, `md` 12, `lg` 16, `xl` 24, `full` 999), `size/icon/*`, `size/control/*`, `border/width/*` (thin 1, default 1.5, focus 2) in the `Dimension` collection of this file; the Tokens library also has semantic `radius/control|card|dialog|sheet|pill` and `space/gap|inset|page/*`, which Figma components may bind to (Button uses `radius/pill` and `space/gap/tight`). Both sets exist as CSS variables in `src/styles/tokens.css`.
   Component padding and gap in Figma bind to the library primitives `spacing/<N>` (8pt rule: `spacing/100` = 8, `spacing/150` = 12). Mapping to the code names: `spacing/25` = `--spacing-2xs` (2), `50` = `xs` (4), `100` = `sm` (8), `150` = `md` (12), `200` = `lg` (16), `300` = `xl` (24), `400` = `2xl` (32), `600` = `3xl` (48). The pixel values are identical, so code needs no change.
4. **Typography** and text styles `<Style>/Regular|Emphasized`, driven by two independent mode axes on a frame: collection **Platform** (`Web` = Figtree, `iOS` = SF Pro) and collection **Typography** (density `Compact` / `Default` / `Loose`). Text styles bind to `typography/*` variables, which alias the hidden `platform/<style>/<prop>/<density>` variables. Web values are the web scale; iOS values come from Apple's HIG Dynamic Type tables: Compact = Medium, Default = Large (default), Loose = xLarge (size, leading, SF Pro tracking and weight). Weights are per style (`typography/<style>/weight/regular|emphasized`): on iOS they follow Apple, so Headline and Button 1 Regular are Semibold, and Emphasized is Bold for Large Title, Title 1 and Title 2 and Semibold for the rest; on Web every style uses Regular 400 and Emphasized SemiBold 600. Letter spacing is per style too and always in px (Figma binds tracking variables in px only): Web is -1px / 0 / +1px for Compact / Default / Loose, iOS is Apple's SF Pro tracking in pt. Mapping to SwiftUI (also in each variable's iOS code syntax and the style description): Large Title `.largeTitle`, Title 1 `.title`, Title 2 `.title2`, Title 3 `.title3`, Headline and Button 1 `.headline`, Body 1 `.body`, Body 2 and Button 2 `.subheadline`, Caption 1 `.caption`, Caption 2 `.caption2`; `.ds(style, weight)` applies the per-style Apple weight (`DSTextStyle.weight(_:)`). The semantic set is not 1:1 with iOS, so Body 2 and the Button styles share iOS styles.
5. **Effect styles**: `shadow/sm|md|lg`.

Code: `web/src/styles/tokens.css` is generated from these variables (all four themes via `data-theme`, density via `data-density`); component CSS uses only those variables. Each variable has WEB code syntax (`var(--color-background-brand-primary)`) and, for Color/Dimension, iOS syntax (`ColorToken.Background.brand.primary`). Use `get_variable_defs` to read the exact names.

## Color pairing

Pair by role. Never put a foreground on a surface it was not designed for.

| Surface | Use for text, icons, borders |
|---|---|
| `color/background/primary`, `color/background/secondary` (neutral surfaces) | Any base foreground: `foreground/primary`, `secondary`, `hero`, `disabled`, and the status foregrounds `foreground/brand`, `info`, `success`, `warning`, `error`, `promote`. Borders: `border/primary`, `secondary`, `tertiary`, `border/<status>`. |
| `color/background/<status>/primary` (solid fill) | `foreground/<status>/on/primary` only. Pressed fill: `…/primary-pressed`. |
| `color/background/<status>/secondary` (tinted fill) | `foreground/<status>/on/secondary` only. Pressed fill: `…/secondary-pressed`. |
| `color/background/inverted-primary`, `inverted-secondary` | `foreground/inverted/primary`, `inverted/secondary`, `border/inverted`. |
| `color/background/disabled` | `foreground/on-disabled`. Disabled outlines: `foreground/disabled`. |

Other rules:
- `<status>` is brand, info, success, warning, error or promote.
- Controls with no fill (Secondary and Tertiary buttons): pressed fill is `color/background/overlay`; outline is `border/<status>`, pressed `border/<status>/pressed`; focus ring is `color/border/focus`.
- Status "on" colors are not always white: warning on-primary is dark, promote on-primary flips between Light and Dark. Always use the token, never white or black.
- Borders: `border/primary` and `border/secondary` are decorative (dividers, card edges) and are below 3:1 in Light. For boundaries that identify a control (Input outline, checkbox box) use `border/tertiary` or a `border/<status>` token, which pass 3:1.
- Contrast audit (all four Tokens modes, 256 pairs): every text pair listed above passes 4.5:1 and every status/tertiary/focus border passes 3:1. Known exception: disabled text on `background/disabled` (exempt; 2.9:1 Light, 1.6:1 Dark). Checkbox boxes and Radio rings pass 3:1 the same way (unselected `border/tertiary`, error `border/error`, selected `action/primary`; the check mark and the Toggle knob are `background/primary`). Toggle tracks pass 3:1 against the surface in all modes (Off uses `border/tertiary`, On uses `action/primary`), and both knobs use `background/primary`. Re-run the audit after changing any semantic token or adding a pair.
- Audit fixes applied in the Tokens file: `foreground/<status>/on/secondary` darkened (brand/info blue 700, success green 600, warning orange 800, error red 900, promote purple 600) so text passes on both secondary and secondary-pressed fills; `border/warning` and `border/promote` darkened in Light; `action/primary` Dark = blue 500 and EVA = EVA Lime 300 (primitive `color/eva/lime/300`, `#A0FF3C`, 13.5:1 against the page), applied directly in the Tokens file rather than through `foreground/hero`; `background/warning/secondary-ressed` renamed to `secondary-pressed`. Publish the library and accept the update in consuming files to pick these up.
- `action/primary` is for control fills and tint (Toggle track, picker values). In EVA it is lime, so never place white or `foreground/brand/on/primary` text on it; use `background/primary` for things drawn on top of it (Toggle knob).

## Icons and the display-only vs interactive rule

- Icons are Material Symbols Rounded, 30 in v1, as 30 individual component sets named `Utility Icon/<material_name>` (page `Icons`), each with a `Size` variant = Small (16) / Medium (20) / Large (24), bound to `size/icon/sm|md|lg`. The glyph is a font ligature, so the set name is the exact Material icon name used in code. Swapping an instance to another icon set keeps its Size.
- **Utility Icon = display only.** **Icon Button = interactive.**
- If the icon sits inside something that is already tappable (Button, Badge, a card action), it is a Utility Icon. If the icon itself triggers an action (accordion chevron, close, more menu), use Icon Button, never a Utility Icon with a click handler.
- Icons inside components (Button leading/trailing, Badge, Input leading, Icon Button) use **instance swap** properties: pick the icon from the Figma right panel (the list shows the 30 Utility Icon sets). Button, Badge and Input also have a `Show … icon` boolean. The instance keeps its Size when you swap. To change an Icon Button used inside another component (Input clear button, Accordion chevron), select the Icon Button instance and change its `Icon` property. Slots are for free-form content only (card image, accordion content, input trailing action).
- Icon Button always needs an accessible name (`aria-label`).

## Building in Figma

- Bind fills, strokes, padding, gap and radius to variables; only intentional fixed geometry is hard-coded.
- Variable scopes set explicitly; primitives hidden.
- Auto-layout everywhere; text via a component property, optional parts via boolean + slot.
- Variant property names are Title Case (`Type`, `State`, `Size`, `Style`).
- Slots: create them on each variant before combining into a set, so they merge into one property. Clear the slot's default white fill.

## Implementing in code

1. Read the component's description and variables in Figma; use `get_design_context` for structure only.
2. Use semantic tokens (CSS variables), never hex or raw px for spacing and radius.
3. Pressed and Disabled map to `:active` and `:disabled` / `aria-disabled`, not props.
4. Heading styles map to real `h1/h2/h3`; Body to `p`; Button, Caption and Headline are utility classes.
5. Every component gets a section in `docs/components.md`, and a row in `docs/ios.md`. Figma is the only source of truth: when code, docs and Figma disagree, read the Figma variables and update the docs to match.

## Platform rule: follow the native pattern first (hard rule)
A Figma component is a design, not an order to redraw it on every platform. On each platform, check what the platform already provides before building a custom control. If the platform has an equivalent, no component is built for that platform: the native control is used and styled with tokens, and it is shown (Figma `<Component> (iOS)`, the app's iOS System catalog, `docs/ios.md`) rather than rebuilt.

1. **Look for the native control or pattern first** (Apple HIG and SwiftUI on iOS, semantic HTML elements on web). If it fits the job, use it and style it with tokens (tint, fonts, colors). Do not redraw it.
2. **Build a custom control only when there is no native equivalent** or the native one cannot meet the Figma design in a way users would accept. Say why in the component spec.
3. **Prefer styling over replacing:** a `ToggleStyle`, `ButtonStyle` or `DisclosureGroupStyle` on the native view, `.tint(...)`, token fonts and colors.
4. **Name the platform in Figma.** No suffix = shared by web and iOS. `(Web)` = web only, because the platform has its own control (Input, Toggle, Checkbox, Radio). `(iOS)` = the native iOS control shown with our tokens. An iOS screen uses no-suffix and `(iOS)` components, never `(Web)`; a web screen the reverse. `docs/ios.md` lists the native pattern for every `(Web)` component.
5. **Keep what the platform gives for free:** VoiceOver, Dynamic Type, Voice Control, minimum 44 pt hit target, keyboard operation on web. A custom control must reproduce them or it must not ship.
6. **Draw the native control in Figma when it differs from web.** Copy it from the platform kit (Apple iOS kit, later Material 3), then rebind every fill, stroke and text to `02 Semantics` and the text styles so it follows all four themes. Never use the kit instance directly: its colors are the kit's own and ignore EVA and Heritage Luxury. Replace the kit's accent (Apple green or blue) with `action/primary`. Name it `<Component> (iOS)` next to the `<Component> (Web)` component and set the `Platform` mode. Rows (inputs, toggles, pickers) are bare, with a `Show separator` boolean, and go in the `Rows` slot of `List Section (iOS)`, which owns the background, corners, header and footer, as SwiftUI's `Form` `Section` does. Current: `Input (iOS)`, `Toggle (iOS)`, `List Section (iOS)`.
7. **Android (planned):** add an `Android` mode to the `Platform` collection (Roboto, Material 3 type scale) and map the semantic styles to it the same way as iOS (for example Body 1 to `bodyLarge`, Body 2 to `bodyMedium`, Button to `labelLarge`). Compose controls (`TextField`, `OutlinedTextField`, `Switch`) take the Semantics colors through a `MaterialTheme` color scheme per theme.

Per-component choices for iOS are in `docs/ios.md`.
