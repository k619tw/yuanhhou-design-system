# iOS (SwiftUI)

How each Figma component is used in SwiftUI. Everything below comes from the Swift package `YuanhhouDSKit` (`ios/YuanhhouDSKit`): add it to the app and `import YuanhhouDSKit`. Values (sizes, colors, spacing) are the same as the web docs in [docs/components.md](components.md); only the API differs. Every pattern below is demonstrated in the app: **yuanhhou - DS** for the design-system versions and **iOS System** for the native controls they build on.

## Rule: native first (hard rule)
Before building a control, use what SwiftUI and the HIG already provide, and style it with tokens (`.tint`, `DSColor`, `.ds(...)` fonts, a `ButtonStyle`, `ToggleStyle` or `DisclosureGroupStyle`). When Apple has an equivalent, there is no DS component on iOS: the native control is shown instead, in Figma as `<Component> (iOS)` (rows inside `List Section (iOS)`), in **iOS System** in the app, and in the table below. Build a custom view only when there is no native equivalent, and say why here. A custom control must keep VoiceOver, Dynamic Type, Voice Control and a 44 pt hit target.

## Component map
| Figma | Use this on iOS | Notes |
|---|---|---|
| [Button](components.md#button) | `Button("Save") {}.buttonStyle(.ds(.primary, size: .large))` | `ButtonStyle`; Pressed is `isPressed`, Disabled is `.disabled()`. Height comes from padding on both sizes: Large is 46 pt and Small 36 pt at the default Dynamic Type, and both grow with it. Small gets a 44 pt hit area (`expandsHitArea`). Labels wrap instead of truncating. Use `.ds(.primary, fullWidth: true)` for a full-width button. For icons in the label, `Button {} label: { DSButtonLabel("Continue", trailing: .chevronRight) }`: custom because SwiftUI's `Label` has one icon and the Figma button can show one on each side (both display only). A link that looks like a button is the native `Link(destination:) { Text("Read the case study") }.buttonStyle(.ds(.secondary))` (VoiceOver reads it as a link); in-app navigation is `NavigationLink(value:)` with the same style. |
| [Icon Button](components.md#icon-button) | `DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { }` | A native `Button` with a `ButtonStyle`. `label` is the accessibility label; Small gets a 44 pt hit area. The box and glyph grow with Dynamic Type |
| [Utility Icon](components.md#utility-icon) | `DSIcon.search.image`, or `DSUtilityIcon(.search, size: .medium)` at a Utility Icon size | Maps each Material icon to an SF Symbol. `DSUtilityIcon` is a native `Image` of that symbol, scaled with Dynamic Type and hidden from VoiceOver. Figma shows the Material glyph; `(iOS)` Figma components draw SF Symbols directly |
| [Badge](components.md#badge) | `DSBadge("Paid", kind: .success, style: .subtle, icon: .check)` | Display only. Custom because SwiftUI's `.badge(_:)` is only a count or text on a list row or tab item, not a status label |
| [Card](components.md#card) | `VStack { … }.dsCard(.outlined, padding: .comfortable)`; a card that is one button or link: `NavigationLink { … } label: { VStack { … }.dsCard() }.buttonStyle(.dsCard)` | Custom because SwiftUI has no card. `.dsCard(_:padding:on:)` is a modifier, not a view: Style Filled, Outlined or Elevated (`DSCardStyle`), Padding (`DSCardPadding`: 16, 24 or 0) and the surface it sits on (`DSCardSurface`). `.buttonStyle(.dsCard)` (`DSCardButtonStyle`) adds the pressed fill (`background/overlay`) and a slight sink, none with Reduce Motion; the iPad pointer lifts the card. The content's own stack sets the spacing inside |
| [Image Card](components.md#image-card) | `DSImageCard(style: .plain, size: .large, title: "…", link: "Read the case study") { media }` in a `NavigationLink` or `Button` with `.buttonStyle(.dsCard)`; or `DSImageCard(...) { media } actions: { buttons }` | Media, badges (`badges:`, they wrap), title, description, then actions or a link row (`link:`, `note:`). Style Elevated, Outlined, Filled or Plain (`DSImageCardStyle`), Size Medium or Large (`DSImageCardSize`), vertical media at `mediaAspectRatio` (16:9 by default). The link row is display only: the wrapping button or link is the control, and with a link the card reads as one element. Custom because SwiftUI has no card control |
| [Timeline](components.md#timeline) | `DSTimeline([DSTimelineItem("Designer", label: "2024", description: "Company A")], size: .large, fill: .scroll)` | Custom because SwiftUI has no timeline. Each item is one VoiceOver element; the line and markers are hidden. Markers stay centred on the first line at every Dynamic Type size. `fill`: `.none`, `.full`, or `.scroll` (grows as the list scrolls; full with Reduce Motion) |
| [Description List](components.md#description-list) `Description List (Web)` → `Labeled Content (iOS)` | `LabeledContent("Role") { Text("Lead designer") }.labeledContentStyle(.dsStacked)`, in a `Form` section or in a stack on a `.dsCard` | A native `LabeledContent` styled with tokens, so no DS view: `.dsStacked` (`DSStackedLabeledContentStyle`) puts the label (Caption 1, `foreground/secondary`) above the value (Body 1, `foreground/primary`) and reads the pair as one element. Without the style, `LabeledContent` stays the system's side-by-side row. See **iOS System > Labeled content**. Figma `Description List (Web)` is web only |
| [Input](components.md#input) `Input (Web)` → `Input (iOS)` | `TextField("Email", text: $email).dsTextField()` (or `SecureField`) in a `Form` section; helper or error in the section footer with `.dsTextFieldFooter(isError:)`; `.dsTextField(isError: true)` colors the value and separator for Error | Native row: font `Body 1`, token colors, cursor in the app tint. No DS input on iOS; Figma `Input (Web)` is web only |
| [Toggle](components.md#toggle) `Toggle (Web)` → `Toggle (iOS)` | `Toggle("Auto-renew", isOn: $on)` | The system switch, tinted with `action/primary` (brand, replaces Apple green) via `.dsTheme(_:)`. Do not redraw it. Figma `Toggle (Web)` is web only |
| [Link](components.md#link) `Link (Web)` → `Link (iOS)` | `Link("Read the rebrand story", destination: url).dsLink(.body2)`; inline: `Text("Read **[the story](https://…)** to learn more.").font(.ds(.body1)).dsLink(.body1)` | SwiftUI's native `Link`, so no DS view. `.dsLink(_:)` sets the `Emphasized` font for Body 1, Body 2 or Caption 1 and tints it `action/primary`. Inline, `**…**` makes only the link Emphasized and `.font` keeps the sentence Regular. Standalone links get a 44 pt hit area (`DSSize.minimumHitTarget`); links go on `background/primary`. No underline, as in Apple's apps. Demo: **iOS System > Controls > Link and share**. Figma `Link (Web)` is web only |
| [List Section (iOS)](components.md#list-section-ios) | `Form { Section { rows } header: { } footer: { } .listRowBackground(Rectangle().fill(DSColor.backgroundPrimary)) }.scrollContentBackground(.hidden).background(DSColor.backgroundSecondary)` | The native section; groups Input, Toggle, Checkmark Row, Picker and Accordion (iOS) rows |
| [Accordion](components.md#accordion) `Accordion (Web)` → `Accordion (iOS)` | `DisclosureGroup("Shipping and returns", isExpanded: $open) { Text("…") }.disclosureGroupStyle(.dsAccordion)` in a `Form` section with `.dsAccordionList()` | The native disclosure group with text content, plus `.disclosureGroupStyle(.dsAccordion)`: a small style that only draws the chevron in `action/secondary` (the system chevron cannot be recolored) and sets the content (Body 2, `foreground/secondary`, aligned with the label, no separator above). Set `.dsAccordionList()` on the `Form` so one-line content is not padded to 44 pt. Figma `Accordion (Web)` is web only |
| [Checkbox](components.md#checkbox) → `Checkmark Row (iOS)` | `Toggle` for one yes or no; checkmark rows bound to a `Set` for several | No DS checkbox on iOS. Figma `Checkbox (Web)` is web only |
| [Radio](components.md#radio) → `Picker (iOS)` | `Picker` with `.pickerStyle(.inline)` (Checkmark Row rows), `.menu` or `.segmented` | No DS radio on iOS. Figma `Radio (Web)` is web only |
| [Segmented Control](components.md#segmented-control) `Segmented Control (Web)` → Segmented Controls in the file iOS System Components | `Picker("Range", selection: $range) { … }.pickerStyle(.segmented)` | The native segmented control for 2 to 5 short options that switch a view. Apple draws it and `.tint` does not reach it, so it keeps Apple's colors in every brand. Do not redraw it. See **iOS System > Selection**. Figma `Segmented Control (Web)` is web only |
| [Modal](components.md#modal) `Modal (Web)` → Sheets in the file iOS System Components | `.sheet(isPresented: $shows) { NavigationStack { … }.presentationDetents([.medium, .large]) }`; `.fullScreenCover` for an immersive task, `.alert` or `.confirmationDialog` for a short decision | No DS modal on iOS: the native sheet keeps the grabber, detents, swipe to dismiss and VoiceOver focus. It inherits the tint from `.dsTheme(_:)`. See **iOS System > Sheet**. Figma `Modal (Web)` is web only |

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
| `color/<role>/<name>` | `DSColor.<roleName>`, for example `DSColor.backgroundPrimary`, resolved for the current brand (`DSTheme`: `.default`, `.eva`, `.cedar`) in Light or Dark from the color scheme (the device, or `DSAppearance` in the showcase) |
| `color/<role>/accent/<hue>/<step>` | `DSColor.<role>Accent<Hue><Step>`, for example `DSColor.foregroundAccentPurple`, `DSColor.backgroundAccentBlueSubtle`, `DSColor.foregroundAccentOnBolder`. Decorative only (see Accent colors in `design-system-rules.md`): the same in every brand, Light or Dark from the color scheme |
| `spacing/*`, `space/*` | `DSSpacing.*`, `DSSpace.*` |
| `radius/*` scale, `size/*`, `border/width/*` | `DSRadius`, `DSSize`, `DSBorderWidth` |
| `radius/control|card|dialog|sheet|pill` (follow the brand) | `@Environment(\.dsShape)` (`DSShape`, set by `.dsTheme(_:)`), drawn with `DSCornerShape(radius:)`, which turns a radius of half the height or more into a capsule. `DSRadius.control`, `card`, `dialog`, `sheet` and `pill` are deprecated: they are the Default brand's values only and do not follow the brand |
| text styles `Body 1/Regular` | `.dsTextStyle(.body1)`, `.dsTextStyle(.body2, .emphasized)` on text, which also marks titles as headings for VoiceOver. Use `.font(.ds(.body1))` only for a font inside another style; Platform `iOS` is SF Pro and matches Apple's Dynamic Type tables: size, leading and tracking come from the Apple text style, and the weight per style (Headline Semibold; Emphasized Bold for Large Title, Title 1, Title 2, Semibold otherwise) |
| primitives | `DSPrimitive` (components do not use them directly) |

## Brand shape
Button, Badge, Icon Button, Card and Image Card (and `.buttonStyle(.dsCard)`) read `@Environment(\.dsShape)` and draw with `DSCornerShape`, so EVA draws them square and Cedar soft. The HIG's capsule buttons describe the system styles; a custom `ButtonStyle` is where a brand shows, so a square EVA button is allowed. The system styles we do not restyle (`.glass`, `.glassProminent`, `.borderedProminent`) stay capsules in every brand, and native controls (TextField rows, Toggle, segmented `Picker`, List sections, sheets) keep Apple's corners. The iPad pointer highlight uses the brand's corners (`.contentShape(.hoverEffect, …)`), while the tap area stays a 44 pt rectangle. Button, Badge, Icon Button, Card and Image Card each have a `… , brands` or `… , styles and brands` preview. The Timeline marker keeps its own geometry: a circle in every brand.

## Same component, different names
React and SwiftUI each follow their platform's habits, so the code names are not all the Figma names. `type` means something else on an HTML button, so web Button uses `variant`.

| Figma | Web | iOS |
|---|---|---|
| Button `Type` | `variant` | `.ds(.primary)` |
| Icon Button `Type` | `variant` | `kind:` |
| Badge `Type` | `type` | `kind:` |
| Badge `Style` | `badgeStyle` | `style:` |
| Card `Style` | `variant` | `.dsCard(.outlined)` (`DSCardStyle`) |
| Image Card `Style` | `variant` | `style:` |
| Image Card link | `href`, `linkLabel`, `linkNote` | `link:`, `note:`, in a `Button` or `NavigationLink` |
| Timeline fill | `progress` (or `--timeline-progress`) | `fill:` |
| Brand and mode | `applyTheme('eva')`, `data-theme` | `.dsTheme(.eva)` |

Theme, appearance (System, Light, Dark), density (Compact = Medium, Default = Large, Loose = xLarge Dynamic Type) and language (English, Japanese) are set on the Home screen. Strings are `LocalizedStringKey` with entries in `Localizable.xcstrings`.
