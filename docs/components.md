# Components

Component documentation for the DS - Components Figma file (`GLymoPHNnAmM4irCifF2Ei`) and its React implementation in `src/components`. One section per component; the Figma pages carry the same content in a `Component documentation` frame. iOS usage is in [ios.md](ios.md). Foundations and global rules live in [design-system-rules.md](../design-system-rules.md); size tokens in [src/styles/tokens.css](../src/styles/tokens.css).

| Component | Purpose | Interactive | Figma page |
|---|---|---|---|
| [Button](#button) | Trigger an action | Yes | `Button` |
| [Icon Button](#icon-button) | Icon-only action | Yes | `Icon Button` |
| [Utility Icon](#utility-icon) | Display-only icon (30 Material Rounded) | No | `Icons` |
| [Badge](#badge) | Status label | No | `Badge` |
| [Image Card](#image-card) | Media card with text and actions | Via inner controls | `Image Card` |
| [Input](#input) | Single-line text field | Yes | `Input` |
| [Toggle](#toggle) | On/off switch | Yes | `Toggle` |
| [Checkbox](#checkbox) | Choose any number of options (Checkbox, Checkbox Group) | Yes | `Checkbox` |
| [Radio](#radio) | Choose exactly one option (Radio, Radio Group) | Yes | `Radio` |
| [Accordion](#accordion) | Expandable section | Yes | `Accordion` |


## Conventions every component follows
- **Icon rule:** an icon inside something already interactive is a Utility Icon (display only). An icon that triggers an action is an Icon Button.
- **Icons** are chosen through instance swap properties (right panel); **slots** are only for free-form content (card image, accordion content, input trailing action).
- **Color** binds only to the Tokens library (`02 Semantics`) and follows the pairing table in the rules file. All text pairs pass 4.5:1 in Light, Dark, EVA and Heritage Luxury.
- **Type** uses the text styles `<Style>/Regular|Emphasized` (Figtree on web; Platform mode `iOS` switches to SF Pro).
- **States:** Pressed and Disabled are designed. Hover and Focus are not yet in Figma; implement focus as a 2px `--color-border-focus` outline.
- **Sizes** use size tokens where they exist (icons: `size/icon/*`).

Each component section has: When to use, Anatomy, Properties, Layout, Color tokens, Do, Don't, Accessibility, Code mapping, Related. Keep this order when adding components.

## Button

Triggers an action or submits a form. Figma: page `Button`, component set `Button` (node `4:94`), 24 variants. iOS: see [ios.md](ios.md).

### When to use
- Use a Button for actions ("Save", "Continue", "Delete account").
- Use a link for navigation to another page or location.
- Use an [Icon Button](#icon-button) when there is no visible label.

### Anatomy
1. Container (fill and/or outline)
2. Leading icon (optional, display only)
3. Label
4. Trailing icon (optional, display only)

### Properties
| Property | Values | Notes |
|---|---|---|
| Type | Primary, Secondary, Tertiary, Alert | Emphasis and intent |
| State | Default, Pressed, Disabled | Pressed = `:active`, Disabled = `disabled`. Hover and Focus are not yet designed in Figma |
| Size | Large, Small | |
| Label | text | Text property |
| Show leading icon / Show trailing icon | boolean, default off | |
| Leading icon / Trailing icon | instance swap | Pick any `Utility Icon/*` from the right panel; size follows the Button's size |

### Types
| Type | Use | Look |
|---|---|---|
| Primary | The single main action on a screen or section | Solid brand fill, light text |
| Secondary | Important but not the main action | Brand outline, brand text, no fill |
| Tertiary | Low emphasis, inline or repeated actions | Brand text only |
| Alert | Destructive or high-risk actions | Tinted error fill, error text |

### Sizes and layout
| | Large | Small |
|---|---|---|
| Height | 48 (hugs: 12 vertical padding + 24 line height) | 36 (fixed) |
| Padding (horizontal / vertical) | 24 (`spacing/300`) / 12 (`spacing/150`) | 16 (`spacing/200`) / 0 |
| Icon gap | 4 (`space/gap/tight`) | 8 (`spacing/100`) |
| Icon size | Medium 20 | Small 16 |
| Text style | `Button 1/Emphasized` (16/24) | `Button 2/Emphasized` (14/20) |
| Corner radius | pill (`radius/pill`) | pill |

Width hugs the label. Large's height comes from padding plus the line height (12 + 24 + 12 = 48), so it follows the text style: it is 46 under the iOS typography mode (Platform = iOS, Default density). Small keeps a fixed 36. Full-width is a layout decision in code, not a variant.

### Color tokens (Tokens library, `02 Semantics`)
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

### Do
- Use one Primary Button per view or section.
- Write labels as verb + object, 1 to 3 words: "Save changes", "Add member".
- Pair actions by emphasis: Primary + Secondary, or Secondary + Tertiary.
- Use Alert only for destructive actions, and make the label say what is destroyed ("Delete project").
- Keep icons supportive: the label must make sense without them.

### Don't
- Don't place two Primary Buttons side by side.
- Don't use a Button for navigation; use a link.
- Don't turn the icon into its own click target. Icons inside a Button are display only because the Button is already the control. If the icon needs its own action, use an Icon Button next to it.
- Don't use long labels or sentence-length text; Buttons don't wrap in the design.
- Don't disable a Button without explaining why (helper text, tooltip on the container).
- Don't hardcode colors or sizes; bind to tokens.

### Accessibility
- Use a real `<button>` (or `type="submit"`). Never a `div`.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` with 2px offset (not yet in Figma).
- Disabled: use `disabled` for native buttons or `aria-disabled="true"` if it must stay focusable.
- Small (36) needs a 44 by 44 hit area on touch: pad the clickable element, keep the visual size.
- Label contrast passes 4.5:1 in all Tokens modes (audited).

### Code mapping
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

### Related
[Icon Button](#icon-button) · [Utility Icon](#utility-icon) · [Input](#input)

## Icon Button

An interactive button that shows only an icon. Figma: page `Icon Button`, component set `Icon Button` (node `15:99`), 24 variants.

### The icon rule
- **Utility Icon is display only. Icon Button is interactive.**
- If an icon sits inside something already tappable (Button, Badge, card), it is a Utility Icon.
- If the icon itself triggers an action (accordion chevron, close, more menu, clear), use an Icon Button.

### When to use
- Compact actions where the meaning is universal and space is tight: close, more, delete, edit, share, expand.
- Inside other components: the Input's clear button, the Accordion's expand chevron.
- Not for the main action of a view; use a [Button](#button) with a label.

### Properties
| Property | Values | Notes |
|---|---|---|
| Type | Primary, Secondary, Tertiary, Alert | Same meaning as Button |
| State | Default, Pressed, Disabled | Hover and Focus not yet designed |
| Size | Large, Small | |
| Icon | instance swap | Pick any `Utility Icon/*` from the right panel. Large uses Large (24), Small uses Medium (20); size is kept when swapping |

### Layout
| | Large | Small |
|---|---|---|
| Box | 48 × 48 | 32 × 32 |
| Icon | 24 | 20 |
| Corner radius | 12 (`radius/md`) | 12 |

### Color tokens
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

### Do
- Give every Icon Button an accessible name (`aria-label="Close"`).
- Use well-known icons only: `close`, `more_horiz`, `delete`, `edit`, `share`, `expand_more`.
- Add a tooltip for any icon that is not instantly obvious.
- Keep a 44 × 44 touch target; Small (32) needs extra hit padding.
- Swap the icon through the `Icon` property rather than detaching.

### Don't
- Don't use an Icon Button as decoration; use a Utility Icon.
- Don't use ambiguous icons without a label or tooltip.
- Don't put an Icon Button inside a Button (nested interactive controls).
- Don't recolor the icon manually; the color comes from Type and State.
- Don't group more than three Icon Buttons in a row; use a "more" menu.

### Accessibility
- Real `<button type="button" aria-label="…">`; the icon is `aria-hidden="true"`.
- Toggle-style buttons (like the Accordion chevron) also need `aria-expanded` or `aria-pressed`.
- Visible focus ring using `--color-border-focus`.

### Code mapping
Source: `src/components/IconButton`.
```tsx
import { IconButton } from '../components'

<IconButton icon="close" aria-label="Clear" variant="tertiary" size="small" iconSize="md" />
```
`aria-label` is required by the type. `variant`: `primary` `secondary` `tertiary` `alert`; `size`: `large` (48) `small` (32); `iconSize`: `lg` (default, 24) or `md` (20, used when nested in Input and Accordion). Pressed is `:active`, Disabled is `disabled`.

### Related
[Utility Icon](#utility-icon) · [Button](#button) · [Accordion](#accordion) · [Input](#input)

## Utility Icon

A display-only icon from Material Symbols Rounded. Figma: page `Icons`, 30 component sets named `Utility Icon/<name>`, each with a `Size` variant.

### When to use
- To support a label or status inside something that is already interactive or purely informational: Button, Badge, Input, list rows.
- Not clickable. If the icon needs to trigger an action, use an [Icon Button](#icon-button).

### Icons (v1, 30)
`home` `search` `menu` `close` `settings` `person` `favorite` `star` `add` `remove` `check` `arrow_back` `arrow_forward` `chevron_left` `chevron_right` `expand_more` `expand_less` `more_horiz` `more_vert` `delete` `edit` `share` `info` `warning` `error` `notifications` `mail` `calendar_today` `visibility` `download`

The set name is the Material Symbols ligature name, so `Utility Icon/search` maps to the text `search` in the Material Symbols Rounded font.

### Properties
| Property | Values |
|---|---|
| Size | Small (16, `size/icon/sm`), Medium (20, `size/icon/md`), Large (24, `size/icon/lg`) |

The glyph color defaults to `foreground/primary`. In components it is overridden to match the surrounding text (for example `foreground/brand/on/primary` inside a Primary Button).

### Choosing a size
| Context | Size |
|---|---|
| Button Large, Input, Icon Button Small | Medium (20) |
| Button Small, Badge | Small (16) |
| Icon Button Large | Large (24) |

### How icons are swapped in components
Button, Badge, Input and Icon Button expose an **instance swap** property. Select the icon layer and pick another `Utility Icon/*` from the right panel. The Size is kept when swapping. Do not detach instances.

### Do
- Use icons to reinforce meaning, never as the only carrier of meaning.
- Keep one icon style (rounded, regular weight) across the product.
- Use the size that matches the surrounding text and control.
- Add new icons as new `Utility Icon/<material_name>` sets with the same three sizes, bound to the size tokens.

### Don't
- Don't make a Utility Icon clickable or add a click handler to it.
- Don't scale an icon by dragging its handles; change `Size` instead.
- Don't mix in icons from other families (outlined, sharp, custom) without adding them to the set.
- Don't use color alone to separate meaning (success vs error); pair with text.
- Don't recolor outside the token colors.

### Accessibility
- Decorative icons: `aria-hidden="true"` (the label already says it).
- Icons that carry meaning on their own need a text alternative (visually hidden text or `aria-label` on the parent).

### Code mapping
Source: `src/components/Icon`.
```tsx
import { Icon } from '../components'

<Icon name="search" size="md" />
```
`name` is the exact Material Symbols name; `size`: `sm` (16) `md` (20) `lg` (24), mapped to `--size-icon-sm|md|lg`. The component renders `aria-hidden="true"`; it is never interactive. See `src/styles/tokens.css`.

### Related
[Icon Button](#icon-button) · [Button](#button) · [Badge](#badge)

## Badge

A small, non-interactive status label. Figma: page `Badge`, component set `Badge` (node `16:148`), 24 variants.

### When to use
- To show status or category: "New", "Paid", "Overdue", "Beta".
- Inside cards, table rows and list items next to a title.
- Not for actions or filters; use a Button or a selectable chip for that.

### Properties
| Property | Values | Notes |
|---|---|---|
| Type | Brand, Info, Success, Warning, Error, Promote | Meaning |
| Style | Solid, Subtle | Solid = high emphasis, Subtle = low emphasis |
| Size | Medium, Small | |
| Label | text | |
| Show icon | boolean, default off | |
| Icon | instance swap | Display-only `Utility Icon/*` (Small, 16) |

### Types
| Type | Meaning |
|---|---|
| Brand | Product or feature highlights |
| Info | Neutral information |
| Success | Completed, approved, healthy |
| Warning | Needs attention, not blocking |
| Error | Failed, blocked, overdue |
| Promote | Promotions, new or upgraded features |

Brand and Info currently share the same colors in the Tokens library, so they look identical.

### Layout
| | Medium | Small |
|---|---|---|
| Height | 24 | 20 |
| Padding | 8 horizontal, 4 vertical | 8 horizontal, 2 vertical |
| Gap (icon to label) | 4 (`spacing/50`) | 4 |
| Text style | `Caption 1/Emphasized` (12) | `Caption 2/Emphasized` (11) |
| Corner radius | full (`radius/full`) | full |

### Color tokens
| Style | Fill | Text and icon |
|---|---|---|
| Solid | `background/<type>/primary` | `foreground/<type>/on/primary` |
| Subtle | `background/<type>/secondary` | `foreground/<type>/on/secondary` |

Replace `<type>` with brand, info, success, warning, error or promote.

### Do
- Keep labels to 1 or 2 words, sentence case.
- Use Subtle by default; use Solid when the status must stand out.
- Match the type to meaning: Success for good, Error for failed.
- Combine color with text (and optionally an icon) so color is never the only signal.
- Place the Badge next to the thing it describes (title, name, row).

### Don't
- Don't make a Badge clickable, removable or expandable.
- Don't use Error and Warning for decoration.
- Don't show more than two Badges on one item.
- Don't write long text or full sentences.
- Don't change colors by hand; use Type and Style.

### Accessibility
- A Badge is plain text, not a control: `<span class="badge">`.
- When the Badge changes live (such as a status), wrap it in a `role="status"` region.
- Contrast: all Type and Style combinations pass 4.5:1 (audited).

### Code mapping
Source: `src/components/Badge`.
```tsx
import { Badge } from '../components'

<Badge type="success" badgeStyle="subtle" size="medium" icon="check">Paid</Badge>
```
`type`: `brand` `info` `success` `warning` `error` `promote`; `badgeStyle`: `solid` `subtle`; `size`: `medium` `small`; `icon` is an optional Material Symbols name (display only, 16px). It renders a plain `<span>`.

### Related
[Image Card](#image-card) · [Utility Icon](#utility-icon)

## Image Card

A content card with media, a title, a description, an optional badge and optional actions. Figma: page `Image Card`, component set `Image Card` (node `16:183`), 2 variants.

### When to use
- To present a self-contained item with a visual: article, product, event, listing.
- In grids or lists where each item has an image and a short summary.
- Not for dense data (use a table or list) or for a single big action (use a banner).

### Anatomy
1. Container (border, radius, shadow)
2. Image (slot)
3. Badge row (optional)
4. Title
5. Description
6. Actions row (optional, holds Buttons or Icon Buttons)

### Properties
| Property | Values | Notes |
|---|---|---|
| Orientation | Vertical, Horizontal | Vertical = image on top, Horizontal = image left |
| Image | slot | Drop any image or media |
| Title | text | |
| Description | text | |
| Show badge | boolean, default on | Contains a Badge instance |
| Show actions | boolean, default on | Contains a Small Primary Button instance |

### Layout
| | Vertical | Horizontal |
|---|---|---|
| Width | 320 (fill in code) | 520 (fill in code) |
| Image | full width, 180 high | 200 wide, full height |
| Body padding | 16 (`spacing/200`) | 16 |
| Gap in body | 8 (`spacing/100`) | 8 |
| Corner radius | 16 (`radius/lg`) | 16 |
| Elevation | `shadow/sm` | `shadow/sm` |
| Border | 1px `border/primary` | same |
| Title | `Headline/Emphasized` | same |
| Description | `Body 2/Regular` | same |

Colors: surface `background/primary`, title `foreground/primary`, description `foreground/secondary`, image placeholder `background/secondary`.

### Do
- Use images with a consistent aspect ratio across cards in the same group (the design uses about 16:9).
- Keep titles to two lines and descriptions to two or three lines.
- Give the image meaningful alt text, or empty alt if it is decorative.
- Use Vertical in grids and narrow layouts; use Horizontal in wide lists.
- Make exactly one primary action per card.

### Don't
- Don't put several Primary Buttons in one card.
- Don't make the whole card and the buttons inside it both clickable without a clear link target.
- Don't place text on top of the image without a contrast-safe scrim.
- Don't stretch or crop images so faces or key content are cut.
- Don't nest cards inside cards.

### Accessibility
- If the whole card is a link, make the title the link (`<a>` around the title) and expand its hit area with CSS; keep other buttons separate.
- Image: `<img alt="…">`. Decorative images: `alt=""`.
- Heading level for the title should fit the page outline (`h2` or `h3`).

### Code mapping
Source: `src/components/ImageCard`.
```tsx
import { Badge, Button, ImageCard } from '../components'

<ImageCard
  orientation="vertical"
  media={<img src="…" alt="…" />}
  badge={<Badge type="brand" badgeStyle="subtle" size="small">New</Badge>}
  title="Card title"
  description="Short supporting description."
  actions={<Button size="small">Read more</Button>}
/>
```
`media` is the Figma Image slot. `badge` and `actions` are optional (Show badge / Show actions). The card renders an `<article>` with an `h3` title and is not clickable itself.

### Related
[Badge](#badge) · [Button](#button) · [Icon Button](#icon-button)

## Input

A single-line text field with a label and helper text. Figma: page `Input`, component set `Input` (node `18:109`), 8 variants.

### When to use
- For short free-text values: name, email, search, URL.
- Not for long text (use a textarea) or for picking from a fixed list (use a select).

### Anatomy
1. Label
2. Field (outline)
3. Leading icon (optional, display only)
4. Value or placeholder
5. Trailing action (optional, interactive: an [Icon Button](#icon-button))
6. Helper text (or error message)

### Properties
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

### Layout
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

### Color tokens
| State | Outline | Fill | Value | Helper |
|---|---|---|---|---|
| Default | `border/tertiary` | `background/primary` | `foreground/secondary` (placeholder) | `foreground/secondary` |
| Focus | `border/focus`, 2px | `background/primary` | `foreground/primary` | `foreground/secondary` |
| Error | `border/error`, 1.5px | `background/primary` | `foreground/primary` | `foreground/error` |
| Disabled | `border/primary` | `background/secondary` | `foreground/disabled` | `foreground/disabled` |

The Default outline uses `border/tertiary` (not `secondary`) so the field boundary passes 3:1 against the surface.

### Do
- Always show a visible label. Hide it only when another visible label already names the field.
- Use helper text for format hints ("Use your work email") before the user makes an error.
- Write errors that say how to fix it: "Enter an email like name@company.com".
- Validate on blur or submit, not on every keystroke.
- Use the right `type`, `autocomplete` and `inputmode` for the data.
- Keep the clear button only when it saves effort (search, long values).

### Don't
- Don't use the placeholder as the label; it disappears while typing and has low contrast.
- Don't communicate an error with the red outline alone; always include the message text.
- Don't put a mandatory action in the leading icon; it is display only.
- Don't disable fields to hide validation problems.
- Don't shrink the field below 40 pt on touch devices or make the clear button the only touch target.

### Accessibility
- `<label for>` linked to the input; helper and error via `aria-describedby`.
- Error: `aria-invalid="true"` and the message in the described-by element.
- The clear Icon Button needs `aria-label="Clear"` and should return focus to the input.
- Focus ring is 2px `border/focus`; do not remove it.

### Code mapping
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

### Related
[Icon Button](#icon-button) · [Utility Icon](#utility-icon) · [Toggle](#toggle)

## Toggle

An on/off switch for a setting that takes effect immediately. Figma: page `Toggle`, component set `Toggle` (node `18:167`), 4 variants.

### When to use
- For binary settings that apply right away: "Notifications", "Dark mode", "Auto-renew".
- Not for choices that are submitted with a form (use a checkbox) or for choosing among more than two options (use radio buttons or a select).

### Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On | `aria-checked` |
| State | Default, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

### Layout
| | |
|---|---|
| Track | 44 × 24, radius full (`radius/full`), padding 2 |
| Knob | 20 circle, left when Off, right when On |
| Gap to label | 8 (`spacing/100`) |
| Label | `Body 1/Regular` |

### Color tokens
| Checked / State | Track | Knob | Label |
|---|---|---|---|
| Off, Default | `border/tertiary` | `background/primary` | `foreground/primary` |
| On, Default | `action/primary` | `background/primary` | `foreground/primary` |
| Off, Disabled | `border/primary` | `background/primary` | `foreground/disabled` |
| On, Disabled | `background/disabled` | `background/primary` | `foreground/disabled` |

### Do
- Make the result immediate; no "Save" step.
- Use a label that describes the setting, not the action: "Email notifications", not "Turn on email".
- Keep On meaning "feature active" so the state is obvious without reading the label.
- Make the label part of the click target.
- Show a brief confirmation if the change has side effects.

### Don't
- Don't use a Toggle inside a form that needs a Submit button to apply.
- Don't use opposite meanings for On and Off in different places.
- Don't rely on color alone to show On; the knob position also signals it.
- Don't stack more than 5 Toggles without grouping and headings.
- Don't use a Toggle to trigger an action (use a Button).

### Accessibility
- `<button role="switch" aria-checked="true|false">` or `<input type="checkbox" role="switch">`.
- Space and Enter toggle it.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` (not yet in Figma).
- Track contrast against the surface: both Off (`border/tertiary`) and On (`action/primary`) pass 3:1 in all four themes. Do not use `action/secondary` for the Off track; it is 1.8:1 in Light.

### Code mapping
Source: `src/components/Toggle`.
```tsx
import { Toggle } from '../components'

<Toggle label="Email notifications" defaultChecked />
```
Built on a native checkbox with `role="switch"`, so Off/On is `:checked` and Default/Disabled is `:disabled`; it works in forms and with `onChange`. The label is part of the click target.

### Related
[Input](#input) · [Accordion](#accordion)

## Checkbox

Chooses any number of options, or agrees to a single statement in a form. Figma: page `09 — Checkbox`, component sets `Checkbox` (node `82:36`, 9 variants) and `Checkbox Group` (node `88:171`, 4 variants).

### When to use
- Several options can be true at once: notification channels, filters, "I agree to the terms".
- A choice is submitted with a form (Save, Submit) rather than applied immediately.
- Not for a setting that applies at once (use [Toggle](#toggle)) or for exactly one of many (use [Radio](#radio)).

### Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On, Mixed | Mixed is the DOM `indeterminate` property: a "select all" parent when only some children are selected |
| State | Default, Error, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

Checkbox Group: `Orientation` Vertical, Horizontal; `State` Default, Error; text properties `Legend`, `Helper`; boolean `Show helper`. The options live in an `Options` slot: add, remove or reorder Checkbox instances in it (not limited to three). `State=Error` only colors the default options; set Error on any option you add.

### Layout
| | |
|---|---|
| Box | 24 × 24 (`size/icon/lg`), radius 4 (`spacing/xs`, kept smaller than `radius/sm` so it stays a square), stroke 1.5 (`border/width/default`) inside |
| Mark | check or dash, 2.5 stroke, round caps, drawn in `background/primary` |
| Gap to label | 8 (`spacing/sm`) |
| Min height | 40 (`size/control/md`) so rows are easy to hit |
| Label | `Body 1/Regular` |
| Group | legend `Body 2/Emphasized`, gap 4 (`spacing/xs`) between legend, options and helper; horizontal options gap 24 (`spacing/xl`); helper `Caption 1/Regular` |

### Color tokens
| Checked / State | Box fill | Box stroke | Mark | Label |
|---|---|---|---|---|
| Off, Default | `background/primary` | `border/tertiary` | none | `foreground/primary` |
| Off, Error | `background/primary` | `border/error` | none | `foreground/primary` |
| Off, Disabled | `background/primary` | `border/primary` | none | `foreground/disabled` |
| On or Mixed, Default or Error | `action/primary` | `action/primary` | `background/primary` | `foreground/primary` |
| On or Mixed, Disabled | `background/disabled` | `background/disabled` | `background/primary` | `foreground/disabled` |

Group helper: `foreground/secondary`; in Error `foreground/error`.

### Do
- Make the label part of the click target.
- Start unchecked, unless the safe default is on. Never pre-check consent.
- Write labels as short statements of the option: "Email", not "Send me email".
- Use a Checkbox Group with a legend when options belong together.
- Use Mixed only for a parent whose children are partly selected, and make clicking it select or clear all children.

### Don't
- Don't use a Checkbox for an action that takes effect immediately (use Toggle).
- Don't use a Checkbox for mutually exclusive options (use Radio).
- Don't use Mixed as a third answer for a single option.
- Don't rely on color alone for Error; show the message in the helper text.
- Don't put a foreground on the checked box other than `background/primary`: `action/primary` is lime in EVA, so white would vanish.

### Accessibility
- Native `<input type="checkbox">` inside a `<label>`; Space toggles it. Mixed sets `indeterminate`, which exposes `aria-checked="mixed"`.
- Group: `<fieldset>` with a `<legend>`; the helper is linked with `aria-describedby`; Error sets `aria-invalid`.
- Unchecked outline `border/tertiary` and Error outline `border/error` pass 3:1 against the surface in all four themes; checked fill `action/primary` also passes 3:1.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` around the box (not yet in Figma).

### Code mapping
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

### iOS
SwiftUI has no checkbox control. The design-system version is a style for the native `Toggle`:
```swift
Toggle("Email", isOn: $email).toggleStyle(.dsCheckbox)
Toggle("Select all", isOn: selectAll).toggleStyle(.dsCheckbox).dsMixed(someSelected)
DSCheckboxGroup("Notifications", selection: $channels, options: [DSChoice("Email", value: Channel.email)])
```
For settings that apply at once use the system switch; for many choices in a list use checkmark rows. Both patterns are shown in the app under iOS System > Selection. See [ios.md](ios.md).

### Related
[Radio](#radio) · [Toggle](#toggle)

## Radio

Chooses exactly one option from a short list. Figma: page `10 — Radio`, component sets `Radio` (node `82:59`, 6 variants) and `Radio Group` (node `88:86`, 4 variants).

### When to use
- One of 2 to 7 options, all of which should be visible at once: delivery speed, plan, payment method.
- The choice is submitted with a form.
- Not for more than about 7 options (use a select), not for on/off (use [Toggle](#toggle)) and not for several answers (use [Checkbox](#checkbox)).

### Properties
| Property | Values | Notes |
|---|---|---|
| Checked | Off, On | `:checked` |
| State | Default, Error, Disabled | Hover and Focus not yet designed |
| Label | text | |
| Show label | boolean, default on | |

Radio Group: `Orientation` Vertical, Horizontal; `State` Default, Error; text properties `Legend`, `Helper` (in Error the helper text is edited on the instance); boolean `Show helper`. The options live in an `Options` slot: add, remove or reorder Radio instances in it (not limited to three). `State=Error` only colors the default options; set Error on any option you add. A Radio is always used inside a Radio Group.

### Layout
| | |
|---|---|
| Circle | 24 × 24 (`size/icon/lg`), radius full, stroke 1.5 (`border/width/default`) inside |
| Dot | 16 (`size/icon/sm`) centered, only when On |
| Gap to label | 8 (`spacing/sm`) |
| Min height | 40 (`size/control/md`) |
| Label | `Body 1/Regular` |
| Group | legend `Body 2/Emphasized`, gap 4 (`spacing/xs`); horizontal options gap 24 (`spacing/xl`); helper `Caption 1/Regular` |

### Color tokens
| Checked / State | Circle fill | Circle stroke | Dot | Label |
|---|---|---|---|---|
| Off, Default | `background/primary` | `border/tertiary` | none | `foreground/primary` |
| Off, Error | `background/primary` | `border/error` | none | `foreground/primary` |
| Off, Disabled | `background/primary` | `border/primary` | none | `foreground/disabled` |
| On, Default or Error | `background/primary` | `action/primary` | `action/primary` | `foreground/primary` |
| On, Disabled | `background/primary` | `background/disabled` | `background/disabled` | `foreground/disabled` |

Group helper: `foreground/secondary`; in Error `foreground/error`.

### Do
- Preselect the safest or most common option, unless the choice must be deliberate (then leave all off and require one).
- Keep options short and mutually exclusive; order them logically.
- Show the legend: a group without a visible question is ambiguous.
- Use Horizontal only for 2 to 3 very short options.
- Let the label be part of the click target.

### Don't
- Don't use a lone Radio; one option is a Checkbox.
- Don't use Radio for a list that scrolls or has more than about 7 options.
- Don't let a user deselect a Radio; to allow "none", add a "None" option.
- Don't rely on color alone for Error; put the message in the helper text.

### Accessibility
- Native `<input type="radio">` elements sharing one `name` inside a `<fieldset>` with a `<legend>`. Tab enters the group at the selected radio; arrow keys move and select; Space selects.
- Error sets `aria-invalid` on the fieldset; the helper is linked with `aria-describedby`.
- Unselected ring `border/tertiary` and Error ring `border/error` pass 3:1 against the surface in all four themes; the selected ring and dot use `action/primary`, which also passes 3:1.
- Visible focus ring: `outline: 2px solid var(--color-border-focus)` around the circle (not yet in Figma).

### Code mapping
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

### iOS
SwiftUI has no radio control either. The platform pattern is `Picker(selection:)` with `.pickerStyle(.inline)` (a checkmark on the selected row) or `.menu`; reach for that first. `PickerStyle` cannot be customised, so the design-system look is a separate view with the same single-value binding:
```swift
DSRadioGroup("Delivery speed", selection: $speed, options: [
    DSChoice("Standard", value: Speed.standard),
    DSChoice("Express", value: Speed.express),
], helper: "Choose one")
```
Selection examples for every pattern are in the app under iOS System > Selection. See [ios.md](ios.md).

### Related
[Checkbox](#checkbox) · [Toggle](#toggle)

## Accordion

An expandable section: a header that toggles a content region. Figma: page `Accordion`, component set `Accordion` (node `18:221`), 4 variants (one item).

### When to use
- To keep long, optional content tidy: FAQs, settings groups, details.
- Not for content everyone must read, or for navigation between pages (use tabs or a menu).

### Anatomy
1. Header row (title)
2. Expand button (an [Icon Button](#icon-button), Tertiary Small)
3. Content (slot, visible when expanded)
4. Bottom divider

### Properties
| Property | Values | Notes |
|---|---|---|
| Expanded | False, True | `aria-expanded` |
| State | Default, Disabled | Disabled items cannot be toggled |
| Title | text | |
| Content | slot | Any content |

The chevron is an Icon Button because it triggers the expand. It shows `expand_more` when closed and `expand_less` when open. To change it, select the Icon Button instance and change its `Icon` property.

### Layout
| | |
|---|---|
| Width | 480 (fill in code) |
| Header padding | 16 left (`spacing/200`), 8 right and vertical (`spacing/100`) |
| Gap title to button | 12 (`spacing/150`) |
| Title | `Body 1/Emphasized` |
| Content padding | 16 left, right and bottom |
| Content text (default) | `Body 2/Regular` |
| Divider | 1px bottom border, `border/primary` |

### Color tokens
| State | Title | Content text | Chevron |
|---|---|---|---|
| Default | `foreground/primary` | `foreground/secondary` | `foreground/brand` |
| Disabled | `foreground/disabled` | `foreground/disabled` | `foreground/on-disabled` |

### Do
- Write titles that predict the content ("Shipping and returns").
- Make the whole header clickable, not just the chevron.
- Keep related items stacked in one group with equal widths.
- Decide group behavior: single-open for long answers, multi-open for independent sections. This is code behavior, not a Figma variant.
- Open the most important item by default only when it is useful on arrival.

### Don't
- Don't hide critical information, errors or required fields inside a closed item.
- Don't nest Accordions.
- Don't use a Utility Icon as the chevron; it must be an Icon Button.
- Don't change the chevron direction rules (down = closed, up = open).
- Don't put long forms in an item; link to a page.

### Accessibility
- Header is a `<button>` inside a heading: `<h3><button aria-expanded aria-controls="panel-1">…</button></h3>`.
- Content is `role="region"` with `aria-labelledby` pointing at the header button.
- Enter and Space toggle; Tab moves between headers. Optional Up/Down/Home/End navigation for groups.
- If the full header is the button, the chevron Icon Button should be `aria-hidden` and not focusable, so there is one tab stop.

### Code mapping
Source: `src/components/Accordion`.
```tsx
import { Accordion } from '../components'

<Accordion title="Shipping and returns" defaultExpanded>
  Content goes here.
</Accordion>
```
Use `defaultExpanded` (uncontrolled) or `expanded` + `onExpandedChange` (controlled); `disabled` blocks toggling. The whole header is one `<button>` with `aria-expanded` and `aria-controls`, and the content is a `role="region"`. In Figma the chevron is an Icon Button instance; in code it is drawn the same way (Tertiary, Small) but is not a nested button, because a button inside a button is invalid HTML. Single- vs multi-open for a group is up to the caller.

### Related
[Icon Button](#icon-button) · [Toggle](#toggle)
