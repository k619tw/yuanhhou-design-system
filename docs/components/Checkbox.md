# Checkbox

Chooses any number of options, or agrees to a single statement in a form. Figma: page `09 — Checkbox`, component sets `Checkbox` (node `82:36`, 9 variants) and `Checkbox Group` (node `88:171`, 4 variants).

## When to use
- Several options can be true at once: notification channels, filters, "I agree to the terms".
- A choice is submitted with a form (Save, Submit) rather than applied immediately.
- Not for a setting that applies at once (use [Toggle](Toggle.md)) or for exactly one of many (use [Radio](Radio.md)).

## Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On, Mixed | Mixed is the DOM `indeterminate` property: a "select all" parent when only some children are selected |
| State | Default, Error, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

Checkbox Group: `Orientation` Vertical, Horizontal; `State` Default, Error; text properties `Legend`, `Helper`; boolean `Show helper`. The options live in an `Options` slot: add, remove or reorder Checkbox instances in it (not limited to three). `State=Error` only colors the default options; set Error on any option you add.

## Layout
| | |
|---|---|
| Box | 24 × 24 (`size/icon/lg`), radius 4 (`spacing/xs`, kept smaller than `radius/sm` so it stays a square), stroke 1.5 (`border/width/default`) inside |
| Mark | check or dash, 2.5 stroke, round caps, drawn in `background/primary` |
| Gap to label | 8 (`spacing/sm`) |
| Min height | 40 (`size/control/md`) so rows are easy to hit |
| Label | `Body 1/Regular` |
| Group | legend `Body 2/Emphasized`, gap 4 (`spacing/xs`) between legend, options and helper; horizontal options gap 24 (`spacing/xl`); helper `Caption 1/Regular` |

## Color tokens
| Checked / State | Box fill | Box stroke | Mark | Label |
|---|---|---|---|---|
| Off, Default | `background/primary` | `border/tertiary` | none | `foreground/primary` |
| Off, Error | `background/primary` | `border/error` | none | `foreground/primary` |
| Off, Disabled | `background/primary` | `border/primary` | none | `foreground/disabled` |
| On or Mixed, Default or Error | `action/primary` | `action/primary` | `background/primary` | `foreground/primary` |
| On or Mixed, Disabled | `background/disabled` | `background/disabled` | `background/primary` | `foreground/disabled` |

Group helper: `foreground/secondary`; in Error `foreground/error`.

## Do
- Make the label part of the click target.
- Start unchecked, unless the safe default is on. Never pre-check consent.
- Write labels as short statements of the option: "Email", not "Send me email".
- Use a Checkbox Group with a legend when options belong together.
- Use Mixed only for a parent whose children are partly selected, and make clicking it select or clear all children.

## Don't
- Don't use a Checkbox for an action that takes effect immediately (use Toggle).
- Don't use a Checkbox for mutually exclusive options (use Radio).
- Don't use Mixed as a third answer for a single option.
- Don't rely on color alone for Error; show the message in the helper text.
- Don't put a foreground on the checked box other than `background/primary`: `action/primary` is lime in EVA, so white would vanish.

## Accessibility
- Native `<input type="checkbox">` inside a `<label>`; Space toggles it. Mixed sets `indeterminate`, which exposes `aria-checked="mixed"`.
- Group: `<fieldset>` with a `<legend>`; the helper is linked with `aria-describedby`; Error sets `aria-invalid`.
- Unchecked outline `border/tertiary` and Error outline `border/error` pass 3:1 against the surface in all four themes; checked fill `action/primary` also passes 3:1.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` around the box (not yet in Figma).

## Code mapping
Source: `src/components/Checkbox`, `src/components/CheckboxGroup`.
```tsx
import { Checkbox, CheckboxGroup } from '../components'

<Checkbox label="I agree" />
<Checkbox label="Select all" checked={all} indeterminate={some} onChange={...} />

<CheckboxGroup
  legend="Notifications"
  helper="Choose any that apply"
  value={channels}
  onValueChange={setChannels}
  options={[{ value: 'email', label: 'Email' }, { value: 'sms', label: 'Text message' }]}
/>
```
Checked is `:checked` (or `indeterminate` for Mixed); Default, Error and Disabled are the `invalid` and `disabled` props. `CheckboxGroup` is a `fieldset`: pass `disabled` to disable every option, `invalid` for Error.

## iOS
SwiftUI has no checkbox control. The design-system version is a style for the native `Toggle`:
```swift
Toggle("Email", isOn: $email).toggleStyle(.dsCheckbox)
Toggle("Select all", isOn: selectAll).toggleStyle(.dsCheckbox).dsMixed(someSelected)
DSCheckboxGroup("Notifications", selection: $channels, options: [DSChoice("Email", value: Channel.email)])
```
For settings that apply at once use the system switch; for many choices in a list use checkmark rows. Both patterns are shown in the app under iOS System > Selection. See `Checkbox-Radio.spec.md`.

## Related
[Radio](Radio.md) · [Toggle](Toggle.md)
