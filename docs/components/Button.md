# Button

Triggers an action or submits a form. Figma: page `Button`, component set `Button` (node `4:94`), 24 variants. iOS notes: see [../../Button.spec.md](../../Button.spec.md).

## When to use
- Use a Button for actions ("Save", "Continue", "Delete account").
- Use a link for navigation to another page or location.
- Use an [Icon Button](IconButton.md) when there is no visible label.

## Anatomy
1. Container (fill and/or outline)
2. Leading icon (optional, display only)
3. Label
4. Trailing icon (optional, display only)

## Properties
| Property | Values | Notes |
|---|---|---|
| Type | Primary, Secondary, Tertiary, Alert | Emphasis and intent |
| State | Default, Pressed, Disabled | Pressed = `:active`, Disabled = `disabled`. Hover and Focus are not yet designed in Figma |
| Size | Large, Small | |
| Label | text | Text property |
| Show leading icon / Show trailing icon | boolean, default off | |
| Leading icon / Trailing icon | instance swap | Pick any `Utility Icon/*` from the right panel; size follows the Button's size |

## Types
| Type | Use | Look |
|---|---|---|
| Primary | The single main action on a screen or section | Solid brand fill, light text |
| Secondary | Important but not the main action | Brand outline, brand text, no fill |
| Tertiary | Low emphasis, inline or repeated actions | Brand text only |
| Alert | Destructive or high-risk actions | Tinted error fill, error text |

## Sizes and layout
| | Large | Small |
|---|---|---|
| Height | 48 (hugs: 12 vertical padding + 24 line height) | 36 (fixed) |
| Padding (horizontal / vertical) | 24 (`spacing/300`) / 12 (`spacing/150`) | 16 (`spacing/200`) / 0 |
| Icon gap | 4 (`space/gap/tight`) | 8 (`spacing/100`) |
| Icon size | Medium 20 | Small 16 |
| Text style | `Button 1/Emphasized` (16/24) | `Button 2/Emphasized` (14/20) |
| Corner radius | pill (`radius/pill`) | pill |

Width hugs the label. Large's height comes from padding plus the line height (12 + 24 + 12 = 48), so it follows the text style: it is 46 under the iOS typography mode (Platform = iOS, Default density). Small keeps a fixed 36. Full-width is a layout decision in code, not a variant.

## Color tokens (Tokens library, `02 Semantics`)
| Type / State | Fill | Outline | Label and icon |
|---|---|---|---|
| Primary / Default | `background/brand/primary` | none | `foreground/brand/on/primary` |
| Primary / Pressed | `background/brand/primary-pressed` | none | `foreground/brand/on/primary` |
| Secondary / Default | none | `border/brand` | `foreground/brand` |
| Secondary / Pressed | `background/overlay` | `border/brand/pressed` | `foreground/brand` |
| Tertiary / Default | none | none | `foreground/brand` |
| Tertiary / Pressed | `background/overlay` | none | `foreground/brand` |
| Alert / Default | `background/error/secondary` | none | `foreground/error/on/secondary` |
| Alert / Pressed | `background/error/secondary-pressed` | none | `foreground/error/on/secondary` |
| Any / Disabled | `background/disabled` (Primary, Alert) | `foreground/disabled` (Secondary) | `foreground/on-disabled` |

## Do
- Use one Primary Button per view or section.
- Write labels as verb + object, 1 to 3 words: "Save changes", "Add member".
- Pair actions by emphasis: Primary + Secondary, or Secondary + Tertiary.
- Use Alert only for destructive actions, and make the label say what is destroyed ("Delete project").
- Keep icons supportive: the label must make sense without them.

## Don't
- Don't place two Primary Buttons side by side.
- Don't use a Button for navigation; use a link.
- Don't turn the icon into its own click target. Icons inside a Button are display only because the Button is already the control. If the icon needs its own action, use an Icon Button next to it.
- Don't use long labels or sentence-length text; Buttons don't wrap in the design.
- Don't disable a Button without explaining why (helper text, tooltip on the container).
- Don't hardcode colors or sizes; bind to tokens.

## Accessibility
- Use a real `<button>` (or `type="submit"`). Never a `div`.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` with 2px offset (not yet in Figma).
- Disabled: use `disabled` for native buttons or `aria-disabled="true"` if it must stay focusable.
- Small (36) needs a 44 by 44 hit area on touch: pad the clickable element, keep the visual size.
- Label contrast passes 4.5:1 in all Tokens modes (audited).

## Code mapping
Source: `src/components/Button`.
```tsx
import { Button } from '../components'

<Button variant="primary" size="large" leadingIcon="add">Save changes</Button>
```
| Prop | Values | Figma |
|---|---|---|
| `variant` | `primary` `secondary` `tertiary` `alert` | Type |
| `size` | `large` `small` | Size |
| `leadingIcon` / `trailingIcon` | Material Symbols name | Show leading/trailing icon + icon swap |
| `fullWidth` | boolean | layout only, not a Figma variant |

Pressed is `:active` and Disabled is `:disabled` (or `aria-disabled="true"`); they are not props. Large's 48px height comes from its 12px vertical padding plus the 24px line height; the outline is a pseudo-element border (not a real border or inset shadow), so it never changes the size and renders evenly on all four edges.

## Related
[Icon Button](IconButton.md) · [Utility Icon](UtilityIcon.md) · [Input](Input.md)
