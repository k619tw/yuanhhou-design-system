# yuanhhou design system

One Figma design system, implemented twice: React in `web/` and SwiftUI in `ios/`. Figma and both codebases are kept in sync by hand (through Claude), so every change that touches one must be checked against the others. Platform-specific notes are in `web/CLAUDE.md` and `ios/CLAUDE.md`.

## Sources of truth
| What | Where |
|---|---|
| Components | Figma file `GLymoPHNnAmM4irCifF2Ei` (DS - Components). Component pages in alphabetical order (`Accordion` … `Toggle`, including `List Section (iOS)`), then `Foundation` and `Typography`. Keep new component pages alphabetical. Component set node ids are in `docs/components.md` |
| Colors | Figma file `5iR1wP3qoTT4uD6d20ekVv` (Tokens), library collection `02 Semantics`, exported to `tokens/colors.json` (modes Light, Dark, EVA Light, EVA Dark, Heritage Luxury Light, Heritage Luxury Dark: each brand in Light and Dark). Primitives in `01 Primitives` |
| Spacing, radius, size, border width | `Dimension` collection in DS - Components, plus semantic `radius/*` and `space/*` in the Tokens library |
| Typography | Text styles `<Style>/Regular|Emphasized`; mode axes: collection `Platform` (Web, iOS) and `Typography` (density Compact, Default, Loose) |
| Rules and color pairing | `design-system-rules.md` |
| Per-component docs | `docs/components.md`, one section per component (also shown on each Figma page in a frame named `Component documentation`) |
| iOS usage | `docs/ios.md`: Figma component to SwiftUI map, selection patterns, tokens |

## Packages
The design system ships as two packages; the demo apps use them the same way any app would.
- Web: `@yuanhhou/ds` from `web/` (`src/index.ts` is the entry; `npm run build:lib` writes `web/lib/`). Apps import components from `@yuanhhou/ds` and the stylesheet from `@yuanhhou/ds/style.css`, which also loads the web fonts, and call `applyTheme()` once. It is on npm (public, MIT); `prepack` builds `lib/`. To try unpublished changes, use `npm pack` or `--install-links`: a plain folder install crashes hook components in production builds, see `web/README.md`.
- iOS: the Swift package `YuanhhouDSKit`, iOS 17 or later. Other apps add this repository by Git URL through the root `Package.swift`; the demo app links `ios/YuanhhouDSKit` as a local package. Keep the two manifests in step (a package test checks the platform). Apps `import YuanhhouDSKit`.
- The repository is public, so everything committed here is public.
- Colors for both are generated from one file, `tokens/colors.json` (see `tokens/README.md`).

## Rules that must hold
- **Native first on every platform (hard rule):** before creating any component, look for the OS-level control on each platform: SwiftUI and the HIG on iOS, Material 3 and Compose on Android, the semantic HTML element on web.
  - If the platform has an equivalent, do **not** build a component for that platform. Use the native control, styled only through tokens (tint, fonts, colors, a `ButtonStyle`/`ToggleStyle`).
  - Show the native control instead of building it: in Figma as a token-bound copy from the platform kit named `<Component> (iOS)` next to the web component (rows go in `List Section (iOS)`), in the app's iOS System catalog, and as a row in `docs/ios.md`.
  - Build custom only when there is no native equivalent, and say why in `docs/ios.md`. iOS has no checkbox or radio, so iOS always uses `Toggle`, `Picker` and checkmark rows (no DS checkbox or radio on iOS).
- **Icon rule:** a Utility Icon is display only. An icon that triggers an action is an Icon Button (with an accessible label). Icons inside Button, Badge and Input are display only.
- **Color pairing:** follow the table in `design-system-rules.md`. Never put a foreground on a surface it was not designed for. All text pairs were audited at 4.5:1 and borders at 3:1.
- **No hardcoded colors** on either platform. If a color is missing, add it to the Tokens file and publish the library. Then export the colors with `tokens/export-figma.js` into `tokens/colors.json` and run `node tokens/generate.mjs`, which writes `web/src/styles/colors.css` and `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/DSColor+Tokens.swift`. Never edit those two files by hand.
- **Every UI string in English and Japanese** (`web/src/i18n/messages.ts`, `ios/YuanhhouDS/Localizable.xcstrings`).

## Releases
`/release [major|minor|patch]` (`.claude/skills/release`) cuts a version: one number for `@yuanhhou/ds`, `YuanhhouDSKit` (`DSVersion.swift`) and the Figma libraries, notes in `CHANGELOG.md` and on the Figma `Release Note` page (DS - Components, page `158:362`), then a `vX.Y.Z` tag. It asks before committing, pushing or publishing.

## One command
The workflows below are packaged as the skill `/sync-component <Component|tokens> [figma|code]` (`.claude/skills/sync-component`), which runs them for React and SwiftUI together. Start Claude in this folder so the skill is found. The flow is drawn in `docs/workflow.md` and in the Figma file `IJKMYKXRddNKjFwY9yWYAv` (Ai Design Systems Workflow, frame `4:2`); update both when the workflow changes.

## Workflow: a change in Figma
1. Read the current Figma values (Figma MCP `use_figma` read-only, or `get_design_context`). Do not trust earlier docs over Figma.
2. Update the web component (CSS/TSX; `tokens.css` for dimensions and typography; colors through `tokens/`, see above) and the SwiftUI component or style in the `YuanhhouDSKit` package.
3. Update the component's section in `docs/components.md`, `design-system-rules.md`, and `docs/ios.md` if the iOS usage changes.
4. Update the `Component documentation` frame on that Figma page so it matches the markdown, then sweep every markdown file and every component page's frame for the old wording of what you changed (a rule or fact is usually repeated in several places). The change is not done until the sweep is clean.
5. Validate: `node tokens/generate.mjs --check`; `npm run build`, `npm run build:lib` and `npm run lint` in `web/`; `xcodebuild` for `ios/`, and `xcodebuild test` in `ios/YuanhhouDSKit/` (token contrast, icons, strings); check visual changes in the browser and the simulator.

## Workflow: a change in code
Apply the same edit to the Figma component (variants, properties, bound variables), then follow steps 3 to 5 above. Library token changes need the user to publish the Tokens library and accept the update in DS - Components before they can be verified there.

## Figma conventions
- **Platform suffix:** no suffix = shared by web and iOS; `(Web)` = web only (Accordion, Input, Toggle, Checkbox, Radio); `(iOS)` = the native iOS control shown with tokens (`Accordion (iOS)`, `Input (iOS)`, `Toggle (iOS)`, `Checkmark Row (iOS)`, `Picker (iOS)`, `List Section (iOS)`). When generating an iOS screen or prototype use no-suffix and `(iOS)` components, never `(Web)`; for web, the reverse.
- Variant properties are Title Case: `Type`, `State`, `Size`, `Style`, `Orientation`, `Checked`, `Expanded`.
- Icons are chosen with instance swap properties (right panel), not slots. Slots are only for free-form content (Image Card image, Accordion content, Input trailing action, group options).
- Bind fills, strokes, padding, gap and radius to variables. Component colors bind only to the Tokens library.
- Do not rename the `Component documentation` frames; they are found by name.

## Known gaps
- Hover and Focus states are not drawn in Figma.
- Icon Button (48, 32) and Input heights are fixed values, not bound to `size/control/*`.
- Utility Icon is Material in Figma; iOS renders the mapped SF Symbol (`DSIcon`). Shared components (Button, Icon Button, Badge) therefore show a Material glyph in Figma that differs from what iOS draws.
- The segmented `Picker` exists in SwiftUI (iOS System > Selection) but has no Figma reference.
- Figma `(iOS)` rows are 52 pt high (Apple kit geometry) and `List Section (iOS)` uses `radius/xl` (24; Apple's inset grouped corner is about 26); SwiftUI draws the real values.
- Accordion (iOS) chevron is `action/secondary` in Figma: 1.78:1 against `background/primary` in Light (Dark 4.1, EVA Light 3.0, EVA Dark 13.0, Heritage Luxury Light 9.8, Heritage Luxury Dark 4.8), below the 3:1 used for UI icons; reviewed with an accessibility specialist and accepted. Accordion (Web) uses `foreground/secondary`. SwiftUI draws the chevron through the small `.dsAccordion` style because the system chevron cannot be recolored.
- Not built: Select, Tabs, Modal.
- iOS does not respond to Increase Contrast: the Tokens library has no high-contrast values.
- `DSColor` and `DSTheme` have a fixed set of brands, so adding one changes the public API. Apps cannot bring their own.
- Below iOS 26 the accordion content uses fixed side insets (20 and 16) instead of the system value.
- `DSPrimitive.swift` and `DSDimension.swift` are kept by hand, not generated from Figma.
