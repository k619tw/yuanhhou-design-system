# Changelog

Every release of the yuanhhou design system: the web package `@yuanhhou/ds`, the Swift package `YuanhhouDSKit` and the Figma libraries share one version number. Written by the `/release` skill; the same notes are on the `Release Note` page of the Figma file DS - Components.

Versions follow [semantic versioning](https://semver.org): a breaking change (a removed or renamed component, property, token or API) is a major release, or a minor one while the version is 0.x; a new component, token or feature is a minor release; fixes and doc-only changes are a patch.

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
