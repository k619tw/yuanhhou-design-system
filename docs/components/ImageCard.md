# Image Card

A content card with media, a title, a description, an optional badge and optional actions. Figma: page `Image Card`, component set `Image Card` (node `16:183`), 2 variants.

## When to use
- To present a self-contained item with a visual: article, product, event, listing.
- In grids or lists where each item has an image and a short summary.
- Not for dense data (use a table or list) or for a single big action (use a banner).

## Anatomy
1. Container (border, radius, shadow)
2. Image (slot)
3. Badge row (optional)
4. Title
5. Description
6. Actions row (optional, holds Buttons or Icon Buttons)

## Properties
| Property | Values | Notes |
|---|---|---|
| Orientation | Vertical, Horizontal | Vertical = image on top, Horizontal = image left |
| Image | slot | Drop any image or media |
| Title | text | |
| Description | text | |
| Show badge | boolean, default on | Contains a Badge instance |
| Show actions | boolean, default on | Contains a Small Primary Button instance |

## Layout
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

## Do
- Use images with a consistent aspect ratio across cards in the same group (the design uses about 16:9).
- Keep titles to two lines and descriptions to two or three lines.
- Give the image meaningful alt text, or empty alt if it is decorative.
- Use Vertical in grids and narrow layouts; use Horizontal in wide lists.
- Make exactly one primary action per card.

## Don't
- Don't put several Primary Buttons in one card.
- Don't make the whole card and the buttons inside it both clickable without a clear link target.
- Don't place text on top of the image without a contrast-safe scrim.
- Don't stretch or crop images so faces or key content are cut.
- Don't nest cards inside cards.

## Accessibility
- If the whole card is a link, make the title the link (`<a>` around the title) and expand its hit area with CSS; keep other buttons separate.
- Image: `<img alt="…">`. Decorative images: `alt=""`.
- Heading level for the title should fit the page outline (`h2` or `h3`).

## Code mapping
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

## Related
[Badge](Badge.md) · [Button](Button.md) · [Icon Button](IconButton.md)
