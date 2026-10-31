# Toggle

An on/off switch for a setting that takes effect immediately. Figma: page `Toggle`, component set `Toggle` (node `18:167`), 4 variants.

## When to use
- For binary settings that apply right away: "Notifications", "Dark mode", "Auto-renew".
- Not for choices that are submitted with a form (use a checkbox) or for choosing among more than two options (use radio buttons or a select).

## Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On | `aria-checked` |
| State | Default, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

## Layout
| | |
|---|---|
| Track | 44 × 24, radius full (`radius/full`), padding 2 |
| Knob | 20 circle, left when Off, right when On |
| Gap to label | 8 (`spacing/100`) |
| Label | `Body 1/Regular` |

## Color tokens
| Checked / State | Track | Knob | Label |
|---|---|---|---|
| Off, Default | `border/tertiary` | `background/primary` | `foreground/primary` |
| On, Default | `action/primary` | `background/primary` | `foreground/primary` |
| Off, Disabled | `border/primary` | `background/primary` | `foreground/disabled` |
| On, Disabled | `background/disabled` | `background/primary` | `foreground/disabled` |

## Do
- Make the result immediate; no "Save" step.
- Use a label that describes the setting, not the action: "Email notifications", not "Turn on email".
- Keep On meaning "feature active" so the state is obvious without reading the label.
- Make the label part of the click target.
- Show a brief confirmation if the change has side effects.

## Don't
- Don't use a Toggle inside a form that needs a Submit button to apply.
- Don't use opposite meanings for On and Off in different places.
- Don't rely on color alone to show On; the knob position also signals it.
- Don't stack more than 5 Toggles without grouping and headings.
- Don't use a Toggle to trigger an action (use a Button).

## Accessibility
- `<button role="switch" aria-checked="true|false">` or `<input type="checkbox" role="switch">`.
- Space and Enter toggle it.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` (not yet in Figma).
- Track contrast against the surface: both Off (`border/tertiary`) and On (`action/primary`) pass 3:1 in all four themes. Do not use `action/secondary` for the Off track; it is 1.8:1 in Light.

## Code mapping
Source: `src/components/Toggle`.
```tsx
import { Toggle } from '../components'

<Toggle label="Email notifications" defaultChecked />
```
Built on a native checkbox with `role="switch"`, so Off/On is `:checked` and Default/Disabled is `:disabled`; it works in forms and with `onChange`. The label is part of the click target.

## Related
[Input](Input.md) · [Accordion](Accordion.md)
