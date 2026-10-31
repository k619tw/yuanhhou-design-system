# Components

Component documentation for the DS - Components Figma file (`GLymoPHNnAmM4irCifF2Ei`) and its React implementation in `src/components`. One file per component; the Figma pages carry the same content in a `Component documentation` frame. Foundations and global rules live in [../../design-system-rules.md](../../design-system-rules.md); size tokens in [../../src/styles/tokens.css](../../src/styles/tokens.css).

| Component | Purpose | Interactive | Figma page |
|---|---|---|---|
| [Button](Button.md) | Trigger an action | Yes | `Button` |
| [Icon Button](IconButton.md) | Icon-only action | Yes | `Icon Button` |
| [Utility Icon](UtilityIcon.md) | Display-only icon (30 Material Rounded) | No | `Icons` |
| [Badge](Badge.md) | Status label | No | `Badge` |
| [Image Card](ImageCard.md) | Media card with text and actions | Via inner controls | `Image Card` |
| [Input](Input.md) | Single-line text field | Yes | `Input` |
| [Toggle](Toggle.md) | On/off switch | Yes | `Toggle` |
| [Accordion](Accordion.md) | Expandable section | Yes | `Accordion` |

## Conventions every component follows
- **Icon rule:** an icon inside something already interactive is a Utility Icon (display only). An icon that triggers an action is an Icon Button.
- **Icons** are chosen through instance swap properties (right panel); **slots** are only for free-form content (card image, accordion content, input trailing action).
- **Color** binds only to the Tokens library (`02 Semantics`) and follows the pairing table in the rules file. All text pairs pass 4.5:1 in Light, Dark, EVA and Heritage Luxury.
- **Type** uses the text styles `<Style>/Regular|Emphasized` (Figtree on web; Platform mode `iOS` switches to SF Pro).
- **States:** Pressed and Disabled are designed. Hover and Focus are not yet in Figma; implement focus as a 2px `--color-border-focus` outline.
- **Sizes** use size tokens where they exist (icons: `size/icon/*`).

## Doc template
Each component file has: When to use, Anatomy, Properties, Layout, Color tokens, Do, Don't, Accessibility, Code mapping, Related. Keep this order when adding components.

## Known gaps
- Hover and Focus states are not drawn in Figma.
- Button Large is 48 from padding (12 + 24 line height); Button Small (36) and Icon Button (48, 32) are fixed values, not yet bound to `size/control/*`.
- Checkbox, Radio, Select, Tabs, Modal are not built.
