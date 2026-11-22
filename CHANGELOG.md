# Changelog

Every release of the yuanhhou design system: the web package `@yuanhhou/ds`, the Swift package `YuanhhouDSKit` and the Figma libraries share one version number. Written by the `/release` skill; the same notes are on the `Release Note` page of the Figma file DS - Components.

Versions follow [semantic versioning](https://semver.org): a breaking change (a removed or renamed component, property, token or API) is a major release, or a minor one while the version is 0.x; a new component, token or feature is a minor release; fixes and doc-only changes are a patch.

## 0.9.0 · 2026-11-22

Decorative accent colors in ten hues, kept apart from the status colors.

### Added
- All: accent colors for decoration with no meaning, such as category tags, illustrations, charts and gradients, in blue, teal, green, lime, yellow, orange, red, magenta, purple and gray. Each hue has a subtler, subtle and bolder background, a text color and a bolder text color, and a border color, plus one color for text on any bolder fill. They are the same in every brand and change between Light and Dark. Keep using success, warning, error and info for status only.
- All: every accent pair passes WCAG AA in all six modes: accent text 5.48:1 or more on the page and on its own subtler and subtle fills, bolder text 8.06:1 or more, text on a bolder fill 5.0:1 or more, and borders 4.11:1 or more against the page. The pairing rules are in `design-system-rules.md` (Accent colors).
- Web: CSS variables `--color-background-accent-<hue>-subtler`, `-subtle` and `-bolder`, `--color-foreground-accent-<hue>` and `-bolder`, `--color-border-accent-<hue>` and `--color-foreground-accent-on-bolder`, and the primitives `--yuanhhouColorAccent<Hue><Step>`. The demo Colors page shows them in an Accent group.
- iOS: `DSColor.backgroundAccent<Hue>Subtler`, `Subtle` and `Bolder`, `DSColor.foregroundAccent<Hue>` and `<Hue>Bolder`, `DSColor.borderAccent<Hue>` and `DSColor.foregroundAccentOnBolder`, and the primitives `DSPrimitive.colorAccent<Hue><Step>`. The showcase Colors page has an Accent group.
- Figma: the Tokens library has the accent variables in `02 Semantics` (`color/background/accent/<hue>/…`, `color/foreground/accent/<hue>…`, `color/border/accent/<hue>`), the primitives `color/accent/<hue>/100`–`900` and a `Token Documentation — Accent` frame. Accept the library update in your files.

## 0.8.0 · 2026-11-21

New Segmented Control for picking one of a few short options, on web and in Figma; iOS keeps the native control.

### Added
- Web: `SegmentedControl` picks one of 2 to 5 short options that switch a view or a setting right away. Built on native radios, so Tab and the arrow keys work; segments share the width equally and one thumb slides under the choice. Sizes `large` and `small`, `fullWidth`, `disabled` per control or per option, and `ariaLabel` and `lang` for abbreviated or other-language labels.
- Figma: page `Segmented Control` with `Segmented Control (Web)` and `Segment (Web)`, bound to the semantic tokens and following the brand's corners.
- iOS: keep using `Picker` with `.pickerStyle(.segmented)`; Figma shows it on the Segmented Controls page of the iOS System Components file.

## 0.7.0 · 2026-11-17

Heritage Luxury is now Cedar: a woody, apothecary palette with the same contrast as before.

### Breaking
- Web: the theme is renamed. Use `data-theme="cedar-light"` and `"cedar-dark"` (were `heritage-luxury-light` and `heritage-luxury-dark`), and `applyTheme('cedar')` (was `'heritage-luxury'`).
- Web and iOS: the theme's primitives are renamed and recoloured: `--yuanhhouColorCedar<Family><Step>` and `DSPrimitive.colorCedar<Family><Step>`, with the families linen, oak, honey, sage, smoke, clay and fig (were `Heritage` parchment, brass, bordeaux, forest and slate). Components use the semantic tokens, so only code that used these primitives directly needs to change.
- Web and iOS: the unused `alpha/brand` primitives are removed (`--yuanhhouColorAlphaBrand10`–`90`, `DSPrimitive.colorAlphaBrand10`–`90`). Use a semantic token instead.
- iOS: `DSTheme.heritageLuxury` is now `.cedar`, `DSThemeMode.heritageLuxuryLight` and `Dark` are `.cedarLight` and `.cedarDark`, and `DSColor`'s `heritageLuxuryLight` and `heritageLuxuryDark` are `cedarLight` and `cedarDark`. The old `DSTheme` and `DSThemeMode` names still work, marked deprecated, and a saved Heritage Luxury setting still loads as Cedar.
- Figma: the Tokens modes are now `Cedar Light` and `Cedar Dark`, and the primitives are `color/cedar/<family>/<step>`. Accept the library update in your files.

### Changed
- All: Cedar's colours are woody and calm: linen for pages and text, oak for the brand, links and focus, honey for warnings, sage for success, smoke for info, clay for errors, and fig for promote and the end of the AI gradient. Every step is exactly as light as the colour it replaced, so every documented pair keeps its contrast ratio (all text pairs at least 4.5:1, outlines at least 3:1).

## 0.6.1 · 2026-11-12

Modal can now start with focus in a field, such as a password.

### Fixed
- Web: `Modal` focuses the element marked `data-autofocus` when it opens, so a rename or password modal starts in its field. Before, focus always went to the close button: React's `autoFocus` runs before the dialog opens, so the browser drops it. Add `data-autofocus` to the `Input` in the content slot.

## 0.6.0 · 2026-11-12

A Modal for web, built on the native dialog, and a scrim token for the backdrop behind it.

### Added
- Web: `Modal`, a dialog for a short decision or a small task, built on the native `<dialog>`. Focus stays inside it, Escape and the backdrop close it, and focus returns to the button that opened it. Control it with `open` and `onClose`; add `description`, a close button (`closeLabel`), content (children) and `actions` as needed. Set `dismissOnBackdrop={false}` when closing would lose what someone typed. Corners follow the brand (`--radius-dialog`).
- Web and iOS: `color/background/scrim` (`--color-background-scrim`, `DSColor.backgroundScrim`) dims the page behind a modal: black at 40% in Light modes and 60% in Dark modes. Draw nothing on it.
- Figma: `Modal (Web)` on the new Modal page, with Title and Description, a Content slot (put `Input (Web)` in it for a field such as a password) and switches for the description, close button, content and actions. iOS keeps the native `.sheet`, `.alert` and `.confirmationDialog`.

## 0.5.1 · 2026-11-12

Promote badges show their tint again in the Heritage Luxury theme.

### Fixed
- Both: in Heritage Luxury, `background/promote/secondary` is now bordeaux (Light 200, Dark 700; pressed Light 300, Dark 600). It was the same colour as `background/secondary`, so subtle Promote badges had no visible fill on cards. Badge text passes 6.8:1 or better.

## 0.5.0 · 2026-11-12

Corners now follow the brand on web, iOS and in Figma: Default stays round, EVA is sharp and Heritage Luxury is soft.

### Breaking
- Web: in the Default brand, `--radius-control` is now 12px (was 8) and `--radius-card` 16px (was 12), and both change with the brand. If your own UI uses them, check those corners.
- iOS: `DSRadius.control`, `card`, `dialog`, `sheet` and `pill` are deprecated and now hold the Default brand's values (`control` 12, `card` 16). Read `@Environment(\.dsShape)` so corners follow the brand.

### Added
- Both: brand shape. Button, Badge, Icon Button, Image Card and Input (web) take their corners from the brand you already set (`data-theme` or `.dsTheme`): Default round, EVA square, Heritage Luxury soft (controls 8, cards 12, buttons and badges 10). Light and Dark match.
- Web: `--radius-control`, `--radius-card`, `--radius-dialog`, `--radius-sheet` and `--radius-pill` per theme, included in `style.css`.
- iOS: `@Environment(\.dsShape)` returns the brand's radii, and `DSCornerShape(radius:)` draws them, as a capsule when the radius is half the height or more.
- Figma: `radius/control`, `card`, `dialog`, `sheet` and `pill` have a value per brand mode in the Tokens library, and Badge, Icon Button, Input (Web) and Image Card bind to them. Switch the `02 Semantics` mode to see each brand's corners.

### Changed
- Both: native iOS controls (text fields, toggles, segmented pickers, list sections, sheets), Checkbox, Radio and Toggle keep their own corners in every brand.
- iOS: on iPad, the pointer highlight of Button and Icon Button follows the brand's corners.
- Docs: a native SwiftUI `Link` takes the DS button style when a link should look like a button: `Link(destination: url) { Text("Read more") }.buttonStyle(.ds(.secondary))`.

## 0.4.0 · 2026-11-09

Links arrive on web, iOS and Figma, Dark mode's tint is lighter so it passes contrast on every surface, and the iOS text field can show an error.

### Added
- Web: `Link`, an underlined text link in Body 1, Body 2 or Caption 1 (Emphasized weight) in `action/primary`: `import { Link } from '@yuanhhou/ds'`.
- iOS: `.dsLink(.body2)` styles SwiftUI's native `Link` with the same sizes and tint, and no underline. In a sentence, write `Text("Read **[the story](url)**").font(.ds(.body1)).dsLink(.body1)`.
- Figma: `Link (Web)` and `Link (iOS)` on the new `Link` page.
- iOS: `dsTextField(isError:)` draws the Error state from Figma: the value in `foreground/error` and the separator in `border/error`.

### Changed
- Both: `action/primary` in Dark is a lighter blue (`#3A9DFF`, was `#0073E5`), so links, tints and control fills pass 4.5:1 on `background/primary` and `background/secondary`. Expect lighter Toggle tracks, checkmarks and radio dots in Dark.
- Docs: how native iOS controls take the brand (filled with a label uses the `background/brand/primary` pair, tint with no fill uses `action/primary`), sheets as the iOS modal, and the iOS switch's knob and Off track being drawn by the system.

### Fixed
- Figma: `Badge` icons now use the same colour token as the label in every variant. Success, Warning, Error and Promote icons were black, and Info Subtle used the Brand token.

## 0.3.0 · 2026-11-06

The kit is public: install the web package from npm and the iOS package by Git URL without any access set up, with simpler setup on both.

### Breaking
- Web: `Badge` now defaults to Subtle, matching iOS and Figma. Set `badgeStyle="solid"` to keep the old look.

### Added
- Web: `@yuanhhou/ds` is on npm: `npm install @yuanhhou/ds`.
- Web: `applyTheme()` sets the brand and follows the device's Light or Dark.
- Both: an MIT license.

### Changed
- Web: `style.css` now loads the fonts, so remove any Google Fonts link you added for the kit.
- iOS: the Default brand is `.dsTheme(.default)`. `.system` still works but shows a warning.
- Docs: titles on iOS use `.dsTextStyle`, which marks them as headings for VoiceOver. There is also a table of names across platforms, and a list of web tokens and text classes.

### Fixed
- Web: packing the package always builds it first.
- Figma, docs: Subtle is the stated Badge default, and the Badge node id is corrected.

## 0.2.0 · 2026-11-06

The iOS package can now be installed from Git on iOS 17 and later, with accessibility fixes and an updated Accordion chevron.

### Breaking
- iOS: `.dsControlTint()` is no longer public. Call `.dsTheme(_:)` once at the root of the app; it sets the palette and tints native controls.
- iOS: `DSBadge.BadgeType` and `type:` are renamed. Use `DSBadge.Kind` and `kind:`.
- iOS: `Color(dsHex:)` is no longer public. Use `DSColor` and the other tokens.
- iOS: Small `Button` now takes 44 pt in layouts while still drawing at 36 pt, so tight stacks may shift. Pass `expandsHitArea: false` when the parent is already 44 pt tall.

### Added
- iOS: install `YuanhhouDSKit` in Xcode by Git URL with `https://github.com/k619tw/yuanhhou-design-system`.
- iOS: `fullWidth` on the `Button` style, for example `.ds(.primary, fullWidth: true)`.
- iOS: `.dsAccordionList()` for a `Form` or `List` that holds accordions.
- iOS: `.label` on display enums such as `DSTheme` and `DSBadge.Kind`, a `Text` in English or Japanese. `DSShadow.small` for the `shadow/sm` elevation.

### Changed
- iOS: the minimum version is now iOS 17, down from iOS 27.
- Web, Figma: the `Accordion` chevron is Large 24 in `foreground/secondary`.
- iOS, Figma: the `Accordion (iOS)` chevron is `Body 2/Emphasized` in `action/secondary`.
- iOS: `Icon Button` grows with Dynamic Type.

### Fixed
- iOS: `Button` and `Badge` text wraps instead of truncating at large text sizes.
- iOS: Small `Button` now has the 44 pt hit target.
- iOS: `DSButtonLabel` uses the right icon gap for each size (Large 4, Small 8).
- iOS: the `Image Card` shadow uses a token, matching web, instead of a hardcoded black.
- iOS: `DSIconButtonStyle` can now be created from an app.

## 0.1.0 · 2026-11-03

The first release: the design system ships as two packages generated from one Figma source.

### Added
- Components: Accordion, Badge, Button, Checkbox, Icon Button, Image Card, Input, Radio, Toggle and 30 Utility Icons. On iOS, Accordion, Input, Toggle, Checkbox and Radio use the native controls styled with tokens.
- Six color modes: Default, EVA and Heritage Luxury, each in Light and Dark. All 67 audited text and border pairs pass in every mode.
- Web: the package `@yuanhhou/ds` (`npm run build:lib`), with types and one stylesheet; React 19 is a peer dependency.
- iOS: the Swift package `YuanhhouDSKit` with a public API and its own English and Japanese strings.
- Tokens: `tokens/colors.json`, exported from Figma, and `tokens/generate.mjs`, which writes the color files for both platforms.
- Web demo catalog with a page per foundation and component, matching the iOS catalog.
- Appearance setting (System, Light, Dark) in both demos.

### Changed
- Web Accordion takes the iOS look: regular title, Material `chevron_right` / `expand_more` chevron as a display-only icon, text right under the label, inset separator.
- iOS Accordion chevron rotates instead of swapping glyphs, so it animates smoothly.

### Fixed
- iOS: native controls (menu pickers in list rows) now follow a device Light or Dark switch; the tint is a dynamic color.
