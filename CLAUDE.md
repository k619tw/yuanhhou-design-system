# yuanhhou design system

One Figma design system, implemented twice: React in `web/` and SwiftUI in `ios/`. Figma and both codebases are kept in sync by hand (through Claude), so every change that touches one must be checked against the others. Platform-specific notes are in `web/CLAUDE.md` and `ios/CLAUDE.md`.

## Sources of truth
| What | Where |
|---|---|
| Components | Figma file `GLymoPHNnAmM4irCifF2Ei` (DS - Components). Pages `01 — Accordion` … `10 — Radio`, then `Foundation` and `Typography`. Component set node ids are in `docs/components.md` |
| Colors | Figma file `5iR1wP3qoTT4uD6d20ekVv` (Tokens), library collection `02 Semantics` (modes Light, Dark, EVA, Heritage Luxury). Primitives in `01 Primitives` |
| Spacing, radius, size, border width | `Dimension` collection in DS - Components, plus semantic `radius/*` and `space/*` in the Tokens library |
| Typography | Text styles `<Style>/Regular|Emphasized`; mode axes: collection `Platform` (Web, iOS) and `Typography` (density Compact, Default, Loose) |
| Rules and color pairing | `design-system-rules.md` |
| Per-component docs | `docs/components.md`, one section per component (also shown on each Figma page in a frame named `Component documentation`) |
| iOS usage | `docs/ios.md`: Figma component to SwiftUI map, selection patterns, tokens |

## Rules that must hold
- **Native first on every platform:** before building a control, use what the platform already provides (SwiftUI and the HIG on iOS, the semantic HTML element on web) and style it with tokens. Build custom only when there is no native equivalent, and say why in `docs/ios.md`. iOS has no checkbox or radio, so use `Toggle`, `Picker` and checkmark rows first.
- **Icon rule:** a Utility Icon is display only. An icon that triggers an action is an Icon Button (with an accessible label). Icons inside Button, Badge and Input are display only.
- **Color pairing:** follow the table in `design-system-rules.md`. Never put a foreground on a surface it was not designed for. All text pairs were audited at 4.5:1 and borders at 3:1.
- **No hardcoded colors** on either platform. If a color is missing, add it to the Tokens file, publish the library, then add it to `web/src/styles/tokens.css` and `ios/YuanhhouDS/DesignSystem/Tokens/DSColor+Tokens.swift`.
- **Every UI string in English and Japanese** (`web/src/i18n/messages.ts`, `ios/YuanhhouDS/Localizable.xcstrings`).

## One command
The workflows below are packaged as the skill `/sync-component <Component|tokens> [figma|code]` (`.claude/skills/sync-component`), which runs them for React and SwiftUI together. Start Claude in this folder so the skill is found.

## Workflow: a change in Figma
1. Read the current Figma values (Figma MCP `use_figma` read-only, or `get_design_context`). Do not trust earlier docs over Figma.
2. Update the web component (CSS/TSX, `tokens.css`) and the SwiftUI component or style.
3. Update the component's section in `docs/components.md`, `design-system-rules.md`, and `docs/ios.md` if the iOS usage changes.
4. Update the `Component documentation` frame on that Figma page so it matches the markdown.
5. Validate: `npm run build` and `npm run lint` in `web/`, `xcodebuild` for `ios/`; check visual changes in the browser and the simulator.

## Workflow: a change in code
Apply the same edit to the Figma component (variants, properties, bound variables), then follow steps 3 to 5 above. Library token changes need the user to publish the Tokens library and accept the update in DS - Components before they can be verified there.

## Figma conventions
- Variant properties are Title Case: `Type`, `State`, `Size`, `Style`, `Orientation`, `Checked`, `Expanded`.
- Icons are chosen with instance swap properties (right panel), not slots. Slots are only for free-form content (Image Card image, Accordion content, Input trailing action, group options).
- Bind fills, strokes, padding, gap and radius to variables. Component colors bind only to the Tokens library.
- Do not rename the `Component documentation` frames; they are found by name.

## Known gaps
- Hover and Focus states are not drawn in Figma.
- Button Small (36), Icon Button (48, 32) and Input heights are fixed values, not bound to `size/control/*`.
- Accordion: Figma shows the chevron as an Icon Button instance; web draws the same look but not a nested button (invalid HTML inside a button).
- Not built: Select, Tabs, Modal.
