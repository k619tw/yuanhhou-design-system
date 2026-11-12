# Known gaps

What the design system does not do yet, or does differently on purpose.

- Hover and Focus states are not drawn in Figma.
- Icon Button (48, 32) and Input heights are fixed values, not bound to `size/control/*`.
- Utility Icon is Material in Figma; iOS renders the mapped SF Symbol (`DSIcon`). Shared components (Button, Icon Button, Badge) therefore show a Material glyph in Figma that differs from what iOS draws.
- The segmented `Picker` exists in SwiftUI (iOS System > Selection) but has no Figma reference.
- Figma `(iOS)` rows are 52 pt high (Apple kit geometry) and `List Section (iOS)` uses `radius/xl` (24; Apple's inset grouped corner is about 26); SwiftUI draws the real values.
- Accordion (iOS) chevron is `action/secondary` in Figma: 1.78:1 against `background/primary` in Light (Dark 4.1, EVA Light 3.0, EVA Dark 13.0, Heritage Luxury Light 9.8, Heritage Luxury Dark 4.8), below the 3:1 used for UI icons; reviewed with an accessibility specialist and accepted. Accordion (Web) uses `foreground/secondary`. SwiftUI draws the chevron through the small `.dsAccordion` style because the system chevron cannot be recolored.
- Not built: Select and Tabs on web. iOS uses the native sheet instead of a modal (see `docs/ios.md`).
- `color/background/scrim` (the web modal backdrop) is not drawn in Figma: `Modal (Web)` shows the box only, because the backdrop is page level.
- SwiftUI's `.glassProminent` and `.borderedProminent` fill with `.tint` (`action/primary`) and draw a white label, which is 1.25:1 in EVA Dark and 1.78:1 in Heritage Luxury Dark. Figma's iOS System Components file already uses the `background/brand/primary` and `foreground/brand/on/primary` pair for these; the code does not yet.
- `.tint` also overrides `role: .destructive` on a `.bordered` button, so Delete draws in the brand color rather than red in **iOS System > Buttons**.
- A `.sheet` toolbar's `.confirmationAction` draws tinted text on glass in SwiftUI, while the Figma sheet shows a filled button. Add `.buttonStyle(.glassProminent)` to get the fill.
- The iOS Toggle knob is white and the Off track is the system grey, as iOS draws them, in both `Toggle (iOS)` and the iOS System Components file. A white knob on the On track is 1.25:1 in EVA Dark and 1.78:1 in Heritage Luxury Dark; the knob position still shows On or Off. Not reviewed with an accessibility specialist yet.
- The iOS System Components file's Lists page was removed (it did not translate to SwiftUI); only `Index Bar` and `Header` are left on it. The `Row`, `Row - Button` and `_Separator` instances on other pages (Examples, Activity Views, Alerts, Sliders, Text Fields) no longer have a component behind them.
- `Toggle (iOS)` in DS - Components binds its knob and Off track to variables of the iOS System Components file, while that file imports `Input (iOS)` from DS - Components, so the two libraries depend on each other.
- Brand shape reaches only what the design system draws: Button, Badge, Icon Button, Image Card and Input (Web). Native iOS controls (TextField rows, Toggle, List sections, sheets) keep Apple's corners in every brand, and Checkbox, Radio and Toggle (Web) keep their box, circle and track.
- iOS does not respond to Increase Contrast: the Tokens library has no high-contrast values.
- `DSColor` and `DSTheme` have a fixed set of brands, so adding one changes the public API. Apps cannot bring their own.
- Below iOS 26 the accordion content uses fixed side insets (20 and 16) instead of the system value.
- `DSPrimitive.swift` and `DSDimension.swift` are kept by hand, not generated from Figma.
