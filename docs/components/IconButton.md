# Icon Button

An interactive button that shows only an icon. Figma: page `Icon Button`, component set `Icon Button` (node `15:99`), 24 variants.

## The icon rule
- **Utility Icon is display only. Icon Button is interactive.**
- If an icon sits inside something already tappable (Button, Badge, card), it is a Utility Icon.
- If the icon itself triggers an action (accordion chevron, close, more menu, clear), use an Icon Button.

## When to use
- Compact actions where the meaning is universal and space is tight: close, more, delete, edit, share, expand.
- Inside other components: the Input's clear button, the Accordion's expand chevron.
- Not for the main action of a view; use a [Button](Button.md) with a label.

## Properties
| Property | Values | Notes |
|---|---|---|
| Type | Primary, Secondary, Tertiary, Alert | Same meaning as Button |
| State | Default, Pressed, Disabled | Hover and Focus not yet designed |
| Size | Large, Small | |
| Icon | instance swap | Pick any `Utility Icon/*` from the right panel. Large uses Large (24), Small uses Medium (20); size is kept when swapping |

## Layout
| | Large | Small |
|---|---|---|
| Box | 48 × 48 | 32 × 32 |
| Icon | 24 | 20 |
| Corner radius | 12 (`radius/md`) | 12 |

## Color tokens
| Type / State | Fill | Outline | Icon |
|---|---|---|---|
| Primary / Default | `background/brand/primary` | none | `foreground/brand/on/primary` |
| Primary / Pressed | `background/brand/primary-pressed` | none | `foreground/brand/on/primary` |
| Secondary / Default | none | `border/brand` | `foreground/brand` |
| Secondary / Pressed | `background/overlay` | `border/brand/pressed` | `foreground/brand` |
| Tertiary / Default | none | none | `foreground/brand` |
| Tertiary / Pressed | `background/overlay` | none | `foreground/brand` |
| Alert / Default | `background/error/primary` | none | `foreground/error/on/primary` |
| Alert / Pressed | `background/error/primary-pressed` | none | `foreground/error/on/primary` |
| Any / Disabled | `background/disabled` / none | `foreground/disabled` (Secondary) | `foreground/on-disabled` |

## Do
- Give every Icon Button an accessible name (`aria-label="Close"`).
- Use well-known icons only: `close`, `more_horiz`, `delete`, `edit`, `share`, `expand_more`.
- Add a tooltip for any icon that is not instantly obvious.
- Keep a 44 × 44 touch target; Small (32) needs extra hit padding.
- Swap the icon through the `Icon` property rather than detaching.

## Don't
- Don't use an Icon Button as decoration; use a Utility Icon.
- Don't use ambiguous icons without a label or tooltip.
- Don't put an Icon Button inside a Button (nested interactive controls).
- Don't recolor the icon manually; the color comes from Type and State.
- Don't group more than three Icon Buttons in a row; use a "more" menu.

## Accessibility
- Real `<button type="button" aria-label="…">`; the icon is `aria-hidden="true"`.
- Toggle-style buttons (like the Accordion chevron) also need `aria-expanded` or `aria-pressed`.
- Visible focus ring using `--color-border-focus`.

## Code mapping
Source: `src/components/IconButton`.
```tsx
import { IconButton } from '../components'

<IconButton icon="close" aria-label="Clear" variant="tertiary" size="small" iconSize="md" />
```
`aria-label` is required by the type. `variant`: `primary` `secondary` `tertiary` `alert`; `size`: `large` (48) `small` (32); `iconSize`: `lg` (default, 24) or `md` (20, used when nested in Input and Accordion). Pressed is `:active`, Disabled is `disabled`.

## Related
[Utility Icon](UtilityIcon.md) · [Button](Button.md) · [Accordion](Accordion.md) · [Input](Input.md)
