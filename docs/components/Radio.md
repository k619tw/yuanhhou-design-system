# Radio

Chooses exactly one option from a short list. Figma: page `10 — Radio`, component sets `Radio` (node `82:59`, 6 variants) and `Radio Group` (node `88:86`, 4 variants).

## When to use
- One of 2 to 7 options, all of which should be visible at once: delivery speed, plan, payment method.
- The choice is submitted with a form.
- Not for more than about 7 options (use a select), not for on/off (use [Toggle](Toggle.md)) and not for several answers (use [Checkbox](Checkbox.md)).

## Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On | `:checked` |
| State | Default, Error, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

Radio Group: `Orientation` Vertical, Horizontal; `State` Default, Error; text properties `Legend`, `Helper` (in Error the helper text is edited on the instance); boolean `Show helper`. The options live in an `Options` slot: add, remove or reorder Radio instances in it (not limited to three). `State=Error` only colors the default options; set Error on any option you add. A Radio is always used inside a Radio Group.

## Layout
| | |
|---|---|
| Circle | 24 × 24 (`size/icon/lg`), radius full, stroke 1.5 (`border/width/default`) inside |
| Dot | 16 (`size/icon/sm`) centered, only when On |
| Gap to label | 8 (`spacing/sm`) |
| Min height | 40 (`size/control/md`) |
| Label | `Body 1/Regular` |
| Group | legend `Body 2/Emphasized`, gap 4 (`spacing/xs`); horizontal options gap 24 (`spacing/xl`); helper `Caption 1/Regular` |

## Color tokens
| Checked / State | Circle fill | Circle stroke | Dot | Label |
|---|---|---|---|---|
| Off, Default | `background/primary` | `border/tertiary` | none | `foreground/primary` |
| Off, Error | `background/primary` | `border/error` | none | `foreground/primary` |
| Off, Disabled | `background/primary` | `border/primary` | none | `foreground/disabled` |
| On, Default or Error | `background/primary` | `action/primary` | `action/primary` | `foreground/primary` |
| On, Disabled | `background/primary` | `background/disabled` | `background/disabled` | `foreground/disabled` |

Group helper: `foreground/secondary`; in Error `foreground/error`.

## Do
- Preselect the safest or most common option, unless the choice must be deliberate (then leave all off and require one).
- Keep options short and mutually exclusive; order them logically.
- Show the legend: a group without a visible question is ambiguous.
- Use Horizontal only for 2 to 3 very short options.
- Let the label be part of the click target.

## Don't
- Don't use a lone Radio; one option is a Checkbox.
- Don't use Radio for a list that scrolls or has more than about 7 options.
- Don't let a user deselect a Radio; to allow "none", add a "None" option.
- Don't rely on color alone for Error; put the message in the helper text.

## Accessibility
- Native `<input type="radio">` elements sharing one `name` inside a `<fieldset>` with a `<legend>`. Tab enters the group at the selected radio; arrow keys move and select; Space selects.
- Error sets `aria-invalid` on the fieldset; the helper is linked with `aria-describedby`.
- Unselected ring `border/tertiary` and Error ring `border/error` pass 3:1 against the surface in all four themes; the selected ring and dot use `action/primary`, which also passes 3:1.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` around the circle (not yet in Figma).

## Code mapping
Source: `src/components/Radio`, `src/components/RadioGroup`.
```tsx
import { RadioGroup } from '../components'

<RadioGroup
  legend="Delivery speed"
  helper="Choose one"
  defaultValue="standard"
  onValueChange={setSpeed}
  options={[
    { value: 'standard', label: 'Standard' },
    { value: 'express', label: 'Express' },
    { value: 'drone', label: 'Drone', disabled: true },
  ]}
/>
```
Controlled with `value`, uncontrolled with `defaultValue`. `orientation="horizontal"` lays the options out in a row, `invalid` is Error and `disabled` disables the whole group. `Radio` is exported too but should only be used inside a group (it needs a shared `name`).

## iOS
SwiftUI has no radio control either. The platform pattern is `Picker(selection:)` with `.pickerStyle(.inline)` (a checkmark on the selected row) or `.menu`; reach for that first. `PickerStyle` cannot be customised, so the design-system look is a separate view with the same single-value binding:
```swift
DSRadioGroup("Delivery speed", selection: $speed, options: [
    DSChoice("Standard", value: Speed.standard),
    DSChoice("Express", value: Speed.express),
], helper: "Choose one")
```
Selection examples for every pattern are in the app under iOS System > Selection. See [../ios.md](../ios.md).

## Related
[Checkbox](Checkbox.md) · [Toggle](Toggle.md)
