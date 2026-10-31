# Icon, Icon Button, Badge, Image Card (web spec)

Figma file `GLymoPHNnAmM4irCifF2Ei`. Pages `Icons`, `Icon Button` (set 15:99), `Badge` (16:148), `Image Card` (16:183). Code in `src/components/<Name>`. Token names drop the `var(--…)` wrapper.

## Icon (Utility Icon, display only)

Material Symbols Rounded, `FILL 0, GRAD 0`. Prop `name` is the exact Material icon name. Size Small 16 / Medium 20 / Large 24 = `size-icon-sm|md|lg`. `aria-hidden`. Use Icon Button when the icon triggers an action.

## Icon Button (interactive)

| Property | Values |
|---|---|
| Type | Primary, Secondary, Tertiary, Alert |
| State | Default, Pressed (`:active`), Disabled (`disabled`) |
| Size | Large 48 px (`size-control-lg`), Small 32 px (`size-control-sm`) |
| Icon | instance swap, default `add`; glyph is 24 px in the variants (nested uses override to 20 px) |

Radius `radius-md` (12). Needs `aria-label`.

| Type | Default fill | Pressed fill | Stroke | Icon |
|---|---|---|---|---|
| Primary | `color-background-brand-primary` | `…brand-primary-pressed` | none | `color-foreground-brand-on-primary` |
| Secondary | none | `color-background-overlay` | `color-border-brand` (pressed `color-border-brand-pressed`), 1.5 | `color-foreground-brand` |
| Tertiary | none | `color-background-overlay` | none | `color-foreground-brand` |
| Alert | `color-background-error-primary` (solid) | `…error-primary-pressed` | none | `color-foreground-error-on-primary` |

Disabled: icon `color-foreground-on-disabled`; Primary and Alert fill `color-background-disabled`; Secondary stroke `color-foreground-disabled`; Tertiary no container. Note Alert here is solid while Button Alert is a tinted fill (both as designed in Figma).

## Badge

| Property | Values |
|---|---|
| Type | Brand, Info, Success, Warning, Error, Promote |
| Style | Solid, Subtle |
| Size | Medium, Small |
| Text / boolean | Label, Show icon (Utility Icon, 16 px, default `star`) |

Row, gap `spacing-xs`, radius `radius-full`, padding horizontal `spacing-sm`; Medium vertical `spacing-xs` with `Caption 1/Emphasized`, Small vertical `spacing-2xs` with `Caption 2/Emphasized`. Solid: fill `color-background-<type>-primary`, text and icon `color-foreground-<type>-on-primary`. Subtle: fill `color-background-<type>-secondary`, text `color-foreground-<type>-on-secondary`. Non-interactive; use Button or a chip for clickable.

## Image Card

| Property | Values |
|---|---|
| Orientation | Vertical (320 wide), Horizontal (520 wide) |
| Text | Title, Description |
| Booleans | Show badge, Show actions |
| Slot | Image (any media) |

Fill `color-background-primary`, border `border-width-thin` `color-border-primary`, radius `radius-lg` (16), shadow `shadow-sm`, clipped. Image area fill `color-background-secondary`: Vertical height 180, Horizontal width 200 full height. Body: column, padding `spacing-lg`, gap `spacing-sm`. Badge row is a Subtle Brand Small badge. Title `Headline/Emphasized` `color-foreground-primary`; description `Body 2/Regular` `color-foreground-secondary`. Actions row (gap `spacing-sm`) holds real Small Buttons. The card is not clickable unless wrapped in a link.
