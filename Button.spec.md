# Button spec (iOS SwiftUI; web in `src/components/Button`)

Figma: https://www.figma.com/design/GLymoPHNnAmM4irCifF2Ei/DS---Components?node-id=4-94
Component set: `Button` (page `Button`, node `4:94`), 24 variants.

## API

| Figma property | Values | SwiftUI |
|---|---|---|
| Type | Primary, Secondary, Tertiary, Alert | `AppButtonStyle(kind:)` |
| State | Default, Pressed, Disabled | Not a parameter. Pressed = `configuration.isPressed`; Disabled = `@Environment(\.isEnabled) == false` / `.disabled(true)` |
| Size | Large, Small | `AppButtonStyle(size:)` |
| Label (text) | string | the `Button` label |
| Show leading icon / Show trailing icon + Leading icon / Trailing icon (instance swap) | boolean + Material Symbols name (defaults `add` / `chevron_right`), 20 pt | `Label` with `Image(systemName:)` before/after the text |

Suggested usage:

```swift
Button("Continue") { }
    .buttonStyle(AppButtonStyle(kind: .primary, size: .large))
```

Full width is a layout concern, not a variant: add `.frame(maxWidth: .infinity)`.

## Layout

| | Large | Small |
|---|---|---|
| Height | 48 pt on web (hugs: vertical padding + line height; iOS Large default = 46 pt) | 36 pt (fixed) |
| Horizontal padding | `Spacing.xl` = 24 | `Spacing.lg` = 16 |
| Gap between icon and label | `space/gap/tight` = 4 | `Spacing.sm` = 8 |
| Vertical padding | 12 (`Spacing.md`); height = 24 + line height | 0 (height is fixed, content centered) |
| Corner radius | `Radius.pill` = 9999 (capsule) | `Radius.pill` = 9999 |
| Width | hugs label | hugs label |
| Text style | Button 1/Emphasized (web 16 / 24; iOS Headline: SF Pro Semibold 17 / 22) | Button 2/Emphasized (web 14 / 20; iOS Subheadline: SF Pro Semibold 15 / 20) |
| Stroke (Secondary only) | `BorderWidth.default` = 1.5, inside | same |

Use `.font(.headline)` / `.font(.subheadline)` with `.fontWeight(.semibold)` so Dynamic Type works. Large's height comes from its padding, so it grows with Dynamic Type: use `.padding(.vertical, Spacing.md)` and no fixed height. Small uses `.frame(minHeight: 36)`.

## Colors per Type and State

Token names are the `ColorToken` paths in `ColorTokens.swift`; each resolves for light and dark automatically.

| Type | State | Fill | Stroke | Label |
|---|---|---|---|---|
| Primary | Default | `Background.brand.primary` | none | `Foreground.brand.onPrimary` |
| Primary | Pressed | `Background.brand.primaryPressed` | none | `Foreground.brand.onPrimary` |
| Primary | Disabled | `Background.disabled` | none | `Foreground.onDisabled` |
| Secondary | Default | none | `Border.brand` | `Foreground.brand` |
| Secondary | Pressed | `Background.overlay` | `Border.brand.pressed` | `Foreground.brand` |
| Secondary | Disabled | none | `Foreground.disabled` | `Foreground.disabled` |
| Tertiary | Default | none | none | `Foreground.brand` |
| Tertiary | Pressed | `Background.overlay` | none | `Foreground.brand` |
| Tertiary | Disabled | none | none | `Foreground.disabled` |
| Alert | Default | `Background.error.secondary` (tinted) | none | `Foreground.error.onSecondary` |
| Alert | Pressed | `Background.error.secondaryPressed` | none | `Foreground.error.onSecondary` |
| Alert | Disabled | `Background.disabled` | none | `Foreground.onDisabled` |

Disabled Primary and Alert share the grey fill; Secondary keeps a grey outline and Tertiary has no container. Alert here is a tinted fill (`error/secondary`), unlike Icon Button Alert, which is solid `error/primary`.

## Figma variable to Swift map

Figma collections: Tokens library `01 Primitives` and `02 Semantics` (Light, Dark, EVA, Heritage Luxury), plus local `Dimension`. Each variable carries an iOS code syntax value.

| Figma variable | Swift |
|---|---|
| `color/background/disabled` | `ColorToken.Background.disabled` |
| `color/background/overlay` | `ColorToken.Background.overlay` |
| `color/background/brand/primary`, `primary-pressed` | `ColorToken.Background.brand.primary`, `.primaryPressed` |
| `color/background/error/secondary`, `secondary-pressed` | `ColorToken.Background.error.secondary`, `.secondaryPressed` |
| `color/foreground/brand`, `brand/on/primary` | `ColorToken.Foreground.brand`, `.brand.onPrimary` |
| `color/foreground/error/on/secondary` | `ColorToken.Foreground.error.onSecondary` |
| `color/foreground/on-disabled`, `disabled` | `ColorToken.Foreground.onDisabled`, `.disabled` |
| `color/border/brand`, `brand/pressed` | `ColorToken.Border.brand`, `.brand.pressed` |
| `spacing/100, lg, xl`, `space/gap/tight` | `Spacing.sm/lg/xl` = 8 / 16 / 24, tight = 4 |
| `radius/pill` | `Radius.pill` = 9999 |
| `border/width/default` | `BorderWidth.default` = 1.5 |

Variable names come from the Tokens library (`02 Semantics`) and the `Dimension` collection of `DS - Components`. The Swift paths follow each variable's iOS code syntax in Figma; check there if a path differs.

`Spacing`, `Radius` and `BorderWidth` do not exist in the Xcode project yet; create them when implementing.

## Behavior notes

- Pressed: swap to the pressed color immediately, no animation needed (optional 0.1 s ease-out).
- Disabled: not interactive, no pressed state, no extra opacity (colors already carry the disabled look).
- Minimum tap target is 44 pt. Small (36 pt) needs a 44 pt hit area: `.contentShape(Rectangle())` with outer padding, or `.frame(minHeight: 44)` on the tappable area.
- Accessibility: use the label as the accessibility label; Alert buttons should say what they destroy ("Delete account", not "Delete").

## Not in v1

Loading state, Medium size, focus state, Alert outline variant.
