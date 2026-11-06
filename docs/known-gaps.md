# Known gaps

What the design system does not do yet, or does differently on purpose.

- Hover and Focus states are not drawn in Figma.
- Icon Button (48, 32) and Input heights are fixed values, not bound to `size/control/*`.
- Utility Icon is Material in Figma; iOS renders the mapped SF Symbol (`DSIcon`). Shared components (Button, Icon Button, Badge) therefore show a Material glyph in Figma that differs from what iOS draws.
- The segmented `Picker` exists in SwiftUI (iOS System > Selection) but has no Figma reference.
- Figma `(iOS)` rows are 52 pt high (Apple kit geometry) and `List Section (iOS)` uses `radius/xl` (24; Apple's inset grouped corner is about 26); SwiftUI draws the real values.
- Accordion (iOS) chevron is `action/secondary` in Figma: 1.78:1 against `background/primary` in Light (Dark 4.1, EVA Light 3.0, EVA Dark 13.0, Heritage Luxury Light 9.8, Heritage Luxury Dark 4.8), below the 3:1 used for UI icons; reviewed with an accessibility specialist and accepted. Accordion (Web) uses `foreground/secondary`. SwiftUI draws the chevron through the small `.dsAccordion` style because the system chevron cannot be recolored.
- Not built: Select, Tabs, Modal.
- iOS does not respond to Increase Contrast: the Tokens library has no high-contrast values.
- `DSColor` and `DSTheme` have a fixed set of brands, so adding one changes the public API. Apps cannot bring their own.
- Below iOS 26 the accordion content uses fixed side insets (20 and 16) instead of the system value.
- `DSPrimitive.swift` and `DSDimension.swift` are kept by hand, not generated from Figma.
