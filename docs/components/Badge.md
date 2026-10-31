# Badge

A small, non-interactive status label. Figma: page `Badge`, component set `Badge` (node `16:148`), 24 variants.

## When to use
- To show status or category: "New", "Paid", "Overdue", "Beta".
- Inside cards, table rows and list items next to a title.
- Not for actions or filters; use a Button or a selectable chip for that.

## Properties
| Property | Values | Notes |
|---|---|---|
| Type | Brand, Info, Success, Warning, Error, Promote | Meaning |
| Style | Solid, Subtle | Solid = high emphasis, Subtle = low emphasis |
| Size | Medium, Small | |
| Label | text | |
| Show icon | boolean, default off | |
| Icon | instance swap | Display-only `Utility Icon/*` (Small, 16) |

## Types
| Type | Meaning |
|---|---|
| Brand | Product or feature highlights |
| Info | Neutral information |
| Success | Completed, approved, healthy |
| Warning | Needs attention, not blocking |
| Error | Failed, blocked, overdue |
| Promote | Promotions, new or upgraded features |

Brand and Info currently share the same colors in the Tokens library, so they look identical.

## Layout
| | Medium | Small |
|---|---|---|
| Height | 24 | 20 |
| Padding | 8 horizontal, 4 vertical | 8 horizontal, 2 vertical |
| Gap (icon to label) | 4 (`spacing/xs`) | 4 |
| Text style | `Caption 1/Emphasized` (12) | `Caption 2/Emphasized` (11) |
| Corner radius | full (`radius/full`) | full |

## Color tokens
| Style | Fill | Text and icon |
|---|---|---|
| Solid | `background/<type>/primary` | `foreground/<type>/on/primary` |
| Subtle | `background/<type>/secondary` | `foreground/<type>/on/secondary` |

Replace `<type>` with brand, info, success, warning, error or promote.

## Do
- Keep labels to 1 or 2 words, sentence case.
- Use Subtle by default; use Solid when the status must stand out.
- Match the type to meaning: Success for good, Error for failed.
- Combine color with text (and optionally an icon) so color is never the only signal.
- Place the Badge next to the thing it describes (title, name, row).

## Don't
- Don't make a Badge clickable, removable or expandable.
- Don't use Error and Warning for decoration.
- Don't show more than two Badges on one item.
- Don't write long text or full sentences.
- Don't change colors by hand; use Type and Style.

## Accessibility
- A Badge is plain text, not a control: `<span class="badge">`.
- When the Badge changes live (such as a status), wrap it in a `role="status"` region.
- Contrast: all Type and Style combinations pass 4.5:1 (audited).

## Code mapping
Source: `src/components/Badge`.
```tsx
import { Badge } from '../components'

<Badge type="success" badgeStyle="subtle" size="medium" icon="check">Paid</Badge>
```
`type`: `brand` `info` `success` `warning` `error` `promote`; `badgeStyle`: `solid` `subtle`; `size`: `medium` `small`; `icon` is an optional Material Symbols name (display only, 16px). It renders a plain `<span>`.

## Related
[Image Card](ImageCard.md) · [Utility Icon](UtilityIcon.md)
