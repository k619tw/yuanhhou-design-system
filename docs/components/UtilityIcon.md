# Utility Icon

A display-only icon from Material Symbols Rounded. Figma: page `Icons`, 30 component sets named `Utility Icon/<name>`, each with a `Size` variant.

## When to use
- To support a label or status inside something that is already interactive or purely informational: Button, Badge, Input, list rows.
- Not clickable. If the icon needs to trigger an action, use an [Icon Button](IconButton.md).

## Icons (v1, 30)
`home` `search` `menu` `close` `settings` `person` `favorite` `star` `add` `remove` `check` `arrow_back` `arrow_forward` `chevron_left` `chevron_right` `expand_more` `expand_less` `more_horiz` `more_vert` `delete` `edit` `share` `info` `warning` `error` `notifications` `mail` `calendar_today` `visibility` `download`

The set name is the Material Symbols ligature name, so `Utility Icon/search` maps to the text `search` in the Material Symbols Rounded font.

## Properties
| Property | Values |
|---|---|
| Size | Small (16, `size/icon/sm`), Medium (20, `size/icon/md`), Large (24, `size/icon/lg`) |

The glyph color defaults to `foreground/primary`. In components it is overridden to match the surrounding text (for example `foreground/brand/on/primary` inside a Primary Button).

## Choosing a size
| Context | Size |
|---|---|
| Button Large, Input, Icon Button Small | Medium (20) |
| Button Small, Badge | Small (16) |
| Icon Button Large | Large (24) |

## How icons are swapped in components
Button, Badge, Input and Icon Button expose an **instance swap** property. Select the icon layer and pick another `Utility Icon/*` from the right panel. The Size is kept when swapping. Do not detach instances.

## Do
- Use icons to reinforce meaning, never as the only carrier of meaning.
- Keep one icon style (rounded, regular weight) across the product.
- Use the size that matches the surrounding text and control.
- Add new icons as new `Utility Icon/<material_name>` sets with the same three sizes, bound to the size tokens.

## Don't
- Don't make a Utility Icon clickable or add a click handler to it.
- Don't scale an icon by dragging its handles; change `Size` instead.
- Don't mix in icons from other families (outlined, sharp, custom) without adding them to the set.
- Don't use color alone to separate meaning (success vs error); pair with text.
- Don't recolor outside the token colors.

## Accessibility
- Decorative icons: `aria-hidden="true"` (the label already says it).
- Icons that carry meaning on their own need a text alternative (visually hidden text or `aria-label` on the parent).

## Code mapping
Source: `src/components/Icon`.
```tsx
import { Icon } from '../components'

<Icon name="search" size="md" />
```
`name` is the exact Material Symbols name; `size`: `sm` (16) `md` (20) `lg` (24), mapped to `--size-icon-sm|md|lg`. The component renders `aria-hidden="true"`; it is never interactive. See `src/styles/tokens.css`.

## Related
[Icon Button](IconButton.md) · [Button](Button.md) · [Badge](Badge.md)
