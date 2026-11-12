# Changelog

Every release of the yuanhhou design system: the web package `@yuanhhou/ds`, the Swift package `YuanhhouDSKit` and the Figma libraries share one version number. Written by the `/release` skill; the same notes are on the `Release Note` page of the Figma file DS - Components.

Versions follow [semantic versioning](https://semver.org): a breaking change (a removed or renamed component, property, token or API) is a major release, or a minor one while the version is 0.x; a new component, token or feature is a minor release; fixes and doc-only changes are a patch.

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
