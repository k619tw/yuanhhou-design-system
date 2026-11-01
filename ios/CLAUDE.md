# ios (SwiftUI)

SwiftUI showcase of Apple's system components and the design system. Open `App Work.xcodeproj` (scheme `App Work`). Shared rules, sources of truth and workflows are in `../CLAUDE.md`; component specs in `../docs/components.md`; how each component maps to SwiftUI in `../docs/ios.md`.

## Rule: native pattern first
Before building any control, check what SwiftUI and the HIG already provide. Use the native control and style it with design tokens (`.tint`, `DSColor`, `.ds(...)` fonts, a `ToggleStyle`/`ButtonStyle`/`DisclosureGroupStyle`). Build a custom control only when there is no native equivalent, and say why in `../docs/ios.md`.

- Toggle is the system switch. Accordion is `DisclosureGroup` with a style. Input is `TextField`.
- iOS has no checkbox or radio control. Use `Toggle` for a setting, `Picker` (`.inline`, `.menu`, `.segmented`) for one of many, and checkmark rows bound to a `Set` for several. `.dsCheckbox` and `DSRadioGroup` are optional design-system looks, for form consent and similar cases only.
- A custom control must keep VoiceOver (value and traits), Dynamic Type, Voice Control and a 44 pt hit target.
- Every pattern is demonstrated in the app under iOS System; add a demo there when you introduce a new native pattern.

## Layout
- `App Work/App/`: app entry and Home screen (theme, density, language).
- `App Work/DesignSystem/Tokens/`: `DSColor` (4 themes), `DSDimension`, `DSTypography`, `DSIcon`, `DSPrimitive`.
- `App Work/DesignSystem/Components/`: DS controls and styles.
- `App Work/Showcase/System/` (native catalog) and `Showcase/DesignSystem/` (DS catalog).
- Colors are never hardcoded: use `DSColor` tokens. All user-facing text is a `LocalizedStringKey` with English and Japanese entries in `Localizable.xcstrings`.

## Build
`xcodebuild -project "App Work.xcodeproj" -scheme "App Work" -destination 'generic/platform=iOS Simulator' build`
