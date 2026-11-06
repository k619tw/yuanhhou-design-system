# iOS (SwiftUI)

How each Figma component is used in SwiftUI. Everything below comes from the Swift package `YuanhhouDSKit` (`ios/YuanhhouDSKit`): add it to the app and `import YuanhhouDSKit`. Values (sizes, colors, spacing) are the same as the web docs in [docs/components.md](components.md); only the API differs. Every pattern below is demonstrated in the app: **yuanhhou - DS** for the design-system versions and **iOS System** for the native controls they build on.

## Rule: native first (hard rule)
Before building a control, use what SwiftUI and the HIG already provide, and style it with tokens (`.tint`, `DSColor`, `.ds(...)` fonts, a `ButtonStyle`, `ToggleStyle` or `DisclosureGroupStyle`). When Apple has an equivalent, there is no DS component on iOS: the native control is shown instead, in Figma as `<Component> (iOS)` (rows inside `List Section (iOS)`), in **iOS System** in the app, and in the table below. Build a custom view only when there is no native equivalent, and say why here. A custom control must keep VoiceOver, Dynamic Type, Voice Control and a 44 pt hit target.

## Component map
| Figma | Use this on iOS | Notes |
|---|---|---|
| [Button](components.md#button) | `Button("Save") {}.buttonStyle(.ds(.primary, size: .large))` | `ButtonStyle`; Pressed is `isPressed`, Disabled is `.disabled()`. Height comes from padding on both sizes: Large is 46 pt and Small 36 pt at the default Dynamic Type, and both grow with it. Small gets a 44 pt hit area (`expandsHitArea`). Labels wrap instead of truncating. Use `.ds(.primary, fullWidth: true)` for a full-width button |
| [Icon Button](components.md#icon-button) | `DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { }` | A native `Button` with a `ButtonStyle`. `label` is the accessibility label; Small gets a 44 pt hit area. The box and glyph grow with Dynamic Type |
| [Utility Icon](components.md#utility-icon) | `DSIcon.search.image` | Maps each Material icon to an SF Symbol. Figma shows the Material glyph; `(iOS)` Figma components draw SF Symbols directly |
| [Badge](components.md#badge) | `DSBadge("Paid", kind: .success, style: .subtle, icon: .check)` | Display only. Custom because SwiftUI's `.badge(_:)` is only a count or text on a list row or tab item, not a status label |
| [Image Card](components.md#image-card) | `DSImageCard(...)` | Media, title, description, optional actions. Custom because SwiftUI has no card control |
| [Input](components.md#input) `Input (Web)` → `Input (iOS)` | `TextField("Email", text: $email).dsTextField()` (or `SecureField`) in a `Form` section; helper or error in the section footer with `.dsTextFieldFooter(isError:)`; `.dsTextField(isError: true)` colors the value and separator for Error | Native row: font `Body 1`, token colors, cursor in the app tint. No DS input on iOS; Figma `Input (Web)` is web only |
| [Toggle](components.md#toggle) `Toggle (Web)` → `Toggle (iOS)` | `Toggle("Auto-renew", isOn: $on)` | The system switch, tinted with `action/primary` (brand, replaces Apple green) via `.dsTheme(_:)`. Do not redraw it. Figma `Toggle (Web)` is web only |
| [List Section (iOS)](components.md#list-section-ios) | `Form { Section { rows } header: { } footer: { } .dsListRowBackground() }.dsListBackground()` | The native section; groups Input, Toggle, Checkmark Row, Picker and Accordion (iOS) rows |
| [Accordion](components.md#accordion) `Accordion (Web)` → `Accordion (iOS)` | `DisclosureGroup("Shipping and returns", isExpanded: $open) { Text("…") }.disclosureGroupStyle(.dsAccordion)` in a `Form` section with `.dsAccordionList()` | The native disclosure group with text content, plus `.disclosureGroupStyle(.dsAccordion)`: a small style that only draws the chevron in `action/secondary` (the system chevron cannot be recolored) and sets the content (Body 2, `foreground/secondary`, aligned with the label, no separator above). Set `.dsAccordionList()` on the `Form` so one-line content is not padded to 44 pt. Figma `Accordion (Web)` is web only |
| [Checkbox](components.md#checkbox) → `Checkmark Row (iOS)` | `Toggle` for one yes or no; checkmark rows bound to a `Set` for several | No DS checkbox on iOS. Figma `Checkbox (Web)` is web only |
| [Radio](components.md#radio) → `Picker (iOS)` | `Picker` with `.pickerStyle(.inline)` (Checkmark Row rows), `.menu` or `.segmented` | No DS radio on iOS. Figma `Radio (Web)` is web only |
| Modal → Sheets in the file iOS System Components | `.sheet(isPresented: $shows) { NavigationStack { … }.presentationDetents([.medium, .large]) }`; `.fullScreenCover` for an immersive task, `.alert` or `.confirmationDialog` for a short decision | No DS modal on iOS: the native sheet keeps the grabber, detents, swipe to dismiss and VoiceOver focus. It inherits the tint from `.dsTheme(_:)`. See **iOS System > Sheet**. A web modal is not built yet |

## Selection on iOS
There is no checkbox or radio control (macOS has a checkbox `Toggle` style; iOS does not). Selection is a binding:

| Question | Pattern | Binding |
|---|---|---|
| One setting, applies at once | `Toggle` | `Bool` |
| One of many | `Picker`: `.inline` (checkmark row), `.menu` (compact), `.segmented` (2 to 5 short options) | single value, `tag` each option |
| Several of many | rows with a trailing `checkmark` | `Set<Value>` |
| Bulk actions (delete, move) | `List(selection:)` in edit mode | `Set<ID>` |

See **iOS System > Selection** and the DS Checkbox and Radio pages. There is no DS checkbox or radio on iOS: always use `Toggle`, `Picker` and checkmark rows.

## Tokens
Tokens are Swift types named like the Figma variables; the iOS code syntax in Figma is the source of truth.

| Figma | Swift |
|---|---|
| `color/<role>/<name>` | `DSColor.<roleName>`, for example `DSColor.backgroundPrimary`, resolved for the current brand (`DSTheme`: `.default`, `.eva`, `.heritageLuxury`) in Light or Dark from the color scheme (the device, or `DSAppearance` in the showcase) |
| `spacing/*`, `space/*` | `DSSpacing.*`, `DSSpace.*` |
| `radius/*`, `size/*`, `border/width/*` | `DSRadius`, `DSSize`, `DSBorderWidth` |
| text styles `Body 1/Regular` | `.dsTextStyle(.body1)`, `.dsTextStyle(.body2, .emphasized)` on text, which also marks titles as headings for VoiceOver. Use `.font(.ds(.body1))` only for a font inside another style; Platform `iOS` is SF Pro and matches Apple's Dynamic Type tables: size, leading and tracking come from the Apple text style, and the weight per style (Headline Semibold; Emphasized Bold for Large Title, Title 1, Title 2, Semibold otherwise) |
| primitives | `DSPrimitive` (components do not use them directly) |

## Same component, different names
React and SwiftUI each follow their platform's habits, so the code names are not all the Figma names. `type` means something else on an HTML button, so web Button uses `variant`.

| Figma | Web | iOS |
|---|---|---|
| Button `Type` | `variant` | `.ds(.primary)` |
| Icon Button `Type` | `variant` | `kind:` |
| Badge `Type` | `type` | `kind:` |
| Badge `Style` | `badgeStyle` | `style:` |
| Brand and mode | `applyTheme('eva')`, `data-theme` | `.dsTheme(.eva)` |

Theme, appearance (System, Light, Dark), density (Compact = Medium, Default = Large, Loose = xLarge Dynamic Type) and language (English, Japanese) are set on the Home screen. Strings are `LocalizedStringKey` with entries in `Localizable.xcstrings`.
