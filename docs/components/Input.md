# Input

A single-line text field with a label and helper text. Figma: page `Input`, component set `Input` (node `18:109`), 8 variants.

## When to use
- For short free-text values: name, email, search, URL.
- Not for long text (use a textarea) or for picking from a fixed list (use a select).

## Anatomy
1. Label
2. Field (outline)
3. Leading icon (optional, display only)
4. Value or placeholder
5. Trailing action (optional, interactive: an [Icon Button](IconButton.md))
6. Helper text (or error message)

## Properties
| Property | Values | Notes |
|---|---|---|
| State | Default, Focus, Error, Disabled | Focus = `:focus-visible`, Error = `aria-invalid="true"`, Disabled = `disabled` |
| Size | Medium (field 40), Large (field 48) | |
| Label | text | Required for accessibility |
| Value | text | Placeholder or entered value |
| Helper | text | Help or error message |
| Show label / Show helper | boolean, default on | |
| Show leading icon | boolean, default off | |
| Leading icon | instance swap | Display-only `Utility Icon/*` (Medium, 20), default `search` |
| Show trailing action | boolean, default off | |
| Trailing action | slot | Holds an Icon Button, default `close` (clear). Change the icon via the Icon Button's `Icon` property |

## Layout
| | |
|---|---|
| Width | 320 (fill in code) |
| Field height | 40 (Medium) or 48 (Large) |
| Field padding | 12 horizontal (`spacing/150`) |
| Gap inside field | 8 (`spacing/100`) |
| Gap label, field, helper | 4 (`spacing/50`) |
| Corner radius | 12 (`radius/md`) |
| Label | `Body 2/Emphasized` |
| Value | `Body 1/Regular` |
| Helper | `Caption 1/Regular` |

## Color tokens
| State | Outline | Fill | Value | Helper |
|---|---|---|---|---|
| Default | `border/tertiary` | `background/primary` | `foreground/secondary` (placeholder) | `foreground/secondary` |
| Focus | `border/focus`, 2px | `background/primary` | `foreground/primary` | `foreground/secondary` |
| Error | `border/error`, 1.5px | `background/primary` | `foreground/primary` | `foreground/error` |
| Disabled | `border/primary` | `background/secondary` | `foreground/disabled` | `foreground/disabled` |

The Default outline uses `border/tertiary` (not `secondary`) so the field boundary passes 3:1 against the surface.

## Do
- Always show a visible label. Hide it only when another visible label already names the field.
- Use helper text for format hints ("Use your work email") before the user makes an error.
- Write errors that say how to fix it: "Enter an email like name@company.com".
- Validate on blur or submit, not on every keystroke.
- Use the right `type`, `autocomplete` and `inputmode` for the data.
- Keep the clear button only when it saves effort (search, long values).

## Don't
- Don't use the placeholder as the label; it disappears while typing and has low contrast.
- Don't communicate an error with the red outline alone; always include the message text.
- Don't put a mandatory action in the leading icon; it is display only.
- Don't disable fields to hide validation problems.
- Don't shrink the field below 40 pt on touch devices or make the clear button the only touch target.

## Accessibility
- `<label for>` linked to the input; helper and error via `aria-describedby`.
- Error: `aria-invalid="true"` and the message in the described-by element.
- The clear Icon Button needs `aria-label="Clear"` and should return focus to the input.
- Focus ring is 2px `border/focus`; do not remove it.

## Code mapping
Source: `src/components/Input`.
```tsx
import { IconButton, Input } from '../components'

<Input
  label="Email"
  helper="Use your work email"
  leadingIcon="mail"
  size="medium"
  trailingAction={<IconButton icon="close" aria-label="Clear" variant="tertiary" size="small" iconSize="md" />}
/>
```
`invalid` sets the Error state (`aria-invalid`, red outline); keep `helper` as the error message. `size`: `medium` (40) or `large` (48). Focus is `:focus-within`; Disabled is the native `disabled` attribute. The label is linked with `htmlFor` and the helper with `aria-describedby` automatically.

## Related
[Icon Button](IconButton.md) · [Utility Icon](UtilityIcon.md) · [Toggle](Toggle.md)
