# Accordion

An expandable section: a header that toggles a content region. Figma: page `Accordion`, component set `Accordion` (node `18:221`), 4 variants (one item).

## When to use
- To keep long, optional content tidy: FAQs, settings groups, details.
- Not for content everyone must read, or for navigation between pages (use tabs or a menu).

## Anatomy
1. Header row (title)
2. Expand button (an [Icon Button](IconButton.md), Tertiary Small)
3. Content (slot, visible when expanded)
4. Bottom divider

## Properties
| Property | Values | Notes |
|---|---|---|
| Expanded | False, True | `aria-expanded` |
| State | Default, Disabled | Disabled items cannot be toggled |
| Title | text | |
| Content | slot | Any content |

The chevron is an Icon Button because it triggers the expand. It shows `expand_more` when closed and `expand_less` when open. To change it, select the Icon Button instance and change its `Icon` property.

## Layout
| | |
|---|---|
| Width | 480 (fill in code) |
| Header padding | 16 left (`spacing/lg`), 8 right and vertical (`spacing/sm`) |
| Gap title to button | 12 (`spacing/md`) |
| Title | `Body 1/Emphasized` |
| Content padding | 16 left, right and bottom |
| Content text (default) | `Body 2/Regular` |
| Divider | 1px bottom border, `border/primary` |

## Color tokens
| State | Title | Content text | Chevron |
|---|---|---|---|
| Default | `foreground/primary` | `foreground/secondary` | `foreground/brand` |
| Disabled | `foreground/disabled` | `foreground/disabled` | `foreground/on-disabled` |

## Do
- Write titles that predict the content ("Shipping and returns").
- Make the whole header clickable, not just the chevron.
- Keep related items stacked in one group with equal widths.
- Decide group behavior: single-open for long answers, multi-open for independent sections. This is code behavior, not a Figma variant.
- Open the most important item by default only when it is useful on arrival.

## Don't
- Don't hide critical information, errors or required fields inside a closed item.
- Don't nest Accordions.
- Don't use a Utility Icon as the chevron; it must be an Icon Button.
- Don't change the chevron direction rules (down = closed, up = open).
- Don't put long forms in an item; link to a page.

## Accessibility
- Header is a `<button>` inside a heading: `<h3><button aria-expanded aria-controls="panel-1">…</button></h3>`.
- Content is `role="region"` with `aria-labelledby` pointing at the header button.
- Enter and Space toggle; Tab moves between headers. Optional Up/Down/Home/End navigation for groups.
- If the full header is the button, the chevron Icon Button should be `aria-hidden` and not focusable, so there is one tab stop.

## Code mapping
Source: `src/components/Accordion`.
```tsx
import { Accordion } from '../components'

<Accordion title="Shipping and returns" defaultExpanded>
  Content goes here.
</Accordion>
```
Use `defaultExpanded` (uncontrolled) or `expanded` + `onExpandedChange` (controlled); `disabled` blocks toggling. The whole header is one `<button>` with `aria-expanded` and `aria-controls`, and the content is a `role="region"`. In Figma the chevron is an Icon Button instance; in code it is drawn the same way (Tertiary, Small) but is not a nested button, because a button inside a button is invalid HTML. Single- vs multi-open for a group is up to the caller.

## Related
[Icon Button](IconButton.md) · [Toggle](Toggle.md)
