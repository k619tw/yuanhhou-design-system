# iOS (SwiftUI)

How each Figma component is used in the iOS app (`/Users/yuanhou/Desktop/App Work`). Values (sizes, colors, spacing) are the same as the web docs in this folder; only the API differs. Every pattern below is demonstrated in the app: **yuanhhou - DS** for the design-system versions and **iOS System** for the native controls they build on.

## Rule: native first
Before building a control, use what SwiftUI and the HIG already provide, and style it with tokens (`.tint`, `DSColor`, `.ds(...)` fonts, a `ButtonStyle`, `ToggleStyle` or `DisclosureGroupStyle`). Build a custom view only when there is no native equivalent, and say why here. A custom control must keep VoiceOver, Dynamic Type, Voice Control and a 44 pt hit target.

## Component map
| Figma | Use this on iOS | Notes |
|---|---|---|
| [Button](components/Button.md) | `Button("Save") {}.buttonStyle(.ds(.primary, size: .large))` | `ButtonStyle`; Pressed is `isPressed`, Disabled is `.disabled()`. Large is 46 pt at the default Dynamic Type |
| [Icon Button](components/IconButton.md) | `DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { }` | `label` is the accessibility label; Small gets a 44 pt hit area |
| [Utility Icon](components/UtilityIcon.md) | `DSIcon.search.image` | Maps each Material icon to an SF Symbol |
| [Badge](components/Badge.md) | `DSBadge("Paid", type: .success, style: .subtle, icon: .check)` | Display only |
| [Image Card](components/ImageCard.md) | `DSImageCard(...)` | Media, title, description, optional actions |
| [Input](components/Input.md) | `DSTextField("Email", text: $email, helper: "...", leadingIcon: .mail)` | Wraps the native `TextField` |
| [Toggle](components/Toggle.md) | `Toggle("Auto-renew", isOn: $on)` | The system switch, tinted with `action/primary` via `.dsControlTint()`. Do not redraw it |
| [Accordion](components/Accordion.md) | `DisclosureGroup("Title") { ... }.disclosureGroupStyle(.dsAccordion)` | A style on the native view |
| [Checkbox](components/Checkbox.md) | no native control. Switch for a setting, checkmark rows for several choices. Optional: `Toggle(...).toggleStyle(.dsCheckbox)` | `.dsMixed()`, `.dsInvalid()`; `DSCheckboxGroup` for a `Set` |
| [Radio](components/Radio.md) | `Picker` with `.pickerStyle(.inline)`. Optional: `DSRadioGroup` | Radio is web-first |

## Selection on iOS
There is no checkbox or radio control (macOS has a checkbox `Toggle` style; iOS does not). Selection is a binding:

| Question | Pattern | Binding |
|---|---|---|
| One setting, applies at once | `Toggle` | `Bool` |
| One of many | `Picker`: `.inline` (checkmark row), `.menu` (compact), `.segmented` (2 to 5 short options) | single value, `tag` each option |
| Several of many | rows with a trailing `checkmark` | `Set<Value>` |
| Bulk actions (delete, move) | `List(selection:)` in edit mode | `Set<ID>` |

See **iOS System > Selection**. Use `.dsCheckbox` only for form consent and similar cases where a switch reads wrongly. `PickerStyle` cannot be customised, so `DSRadioGroup` is a separate view with the same single-value binding; it is optional.

## Tokens
Tokens are Swift types named like the Figma variables; the iOS code syntax in Figma is the source of truth.

| Figma | Swift |
|---|---|
| `color/<role>/<name>` | `DSColor.<roleName>`, for example `DSColor.backgroundPrimary`, resolved for the current theme (`DSTheme`: Light/Dark by device, EVA, Heritage Luxury) |
| `spacing/*`, `space/*` | `DSSpacing.*`, `DSSpace.*` |
| `radius/*`, `size/*`, `border/width/*` | `DSRadius`, `DSSize`, `DSBorderWidth` |
| text styles `Body 1/Regular` | `.font(.ds(.body1))`, `.ds(.body2, .emphasized)`; Platform `iOS` is SF Pro and follows Dynamic Type |
| primitives | `DSPrimitive` (components do not use them directly) |

Theme, density (Compact = Medium, Default = Large, Loose = xLarge Dynamic Type) and language (English, Japanese) are set on the Home screen. Strings are `LocalizedStringKey` with entries in `Localizable.xcstrings`.
