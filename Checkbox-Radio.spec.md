# Checkbox and Radio (iOS SwiftUI spec)

Figma file `GLymoPHNnAmM4irCifF2Ei`. Pages `09 — Checkbox` (sets `Checkbox` 82:36, `Checkbox Group` 88:171) and `10 — Radio` (sets `Radio` 82:59, `Radio Group` 88:86). Component docs: `docs/components/Checkbox.md`, `docs/components/Radio.md`. Code: `App Work/DesignSystem/Components/DSSelectionControls.swift`.

## First, the platform pattern
SwiftUI has no checkbox or radio control (macOS has a checkbox `Toggle` style; iOS does not). Selection on iOS is a binding, and the HIG pattern depends on the question:

| Question | Pattern | Binding |
|---|---|---|
| One setting, applies at once | `Toggle` (switch) | `Bool` |
| One of many | `Picker` with `.pickerStyle(.inline)` (checkmark row), `.menu` (compact) or `.segmented` (2 to 5 short options) | single value, `tag` each option |
| Several of many | rows with a trailing `checkmark`, selection kept in a `Set` | `Set<Value>` |
| Bulk actions on rows (delete, move) | `List(selection:)` in edit mode (system selection circles) | `Set<ID>` |

The app shows all of these under **iOS System > Selection**. Use them first; use the design-system controls only when the Figma look is required (forms, branded flows).

## Design-system controls
| Figma | SwiftUI |
|---|---|
| Checkbox | `Toggle("Email", isOn: $on).toggleStyle(.dsCheckbox)`; Mixed: `.dsMixed(true)`; Error: `.dsInvalid()`; Disabled: `.disabled(true)` |
| Checkbox Group | `DSCheckboxGroup("Notifications", selection: $set, options: [DSChoice("Email", value: Channel.email)], helper:, errorMessage:)` |
| Radio Group | `DSRadioGroup("Delivery speed", selection: $value, options: [...], helper:, errorMessage:)` |
| Radio | the row inside `DSRadioGroup` (no standalone Radio) |

`PickerStyle` cannot be customised in SwiftUI, so `DSRadioGroup` is a separate view with the same single-value binding as `Picker`. A group is disabled with `.disabled(true)`; one option with `DSChoice(..., isDisabled: true)`.

## Geometry and color (same tokens as web)
| | Value |
|---|---|
| Box / circle | 24 (`DSSize.iconLarge`); stroke 1.5 (`DSBorderWidth.regular`) |
| Box corner | 4 (`DSSpacing.xs`) |
| Radio dot | 16 (`DSSize.iconSmall`) |
| Row | min height 44 (`DSSize.minimumHitTarget`), gap `DSSpacing.sm`, label `.ds(.body1)` |
| Group | legend `.ds(.body2, .emphasized)`, gap `DSSpacing.xs`, helper `.ds(.caption1)` |

| State | Fill / stroke | Mark |
|---|---|---|
| Off | `backgroundPrimary` / `borderTertiary` | none |
| Error | `backgroundPrimary` / `borderError` | none |
| Disabled off | `backgroundPrimary` / `borderPrimary` | none |
| On, Mixed | `actionPrimary` / `actionPrimary` | `backgroundPrimary` (never white: lime in EVA) |
| Disabled on | `backgroundDisabled` / `backgroundDisabled` | `backgroundPrimary` |
| Radio on | ring and dot `actionPrimary`; disabled `backgroundDisabled` | |

## Accessibility
- The whole row is one button (`contentShape`), at least 44 pt tall.
- Checkbox: VoiceOver value reads Checked, Unchecked or Mixed. Radio: the selected row carries the `.isSelected` trait; groups are `.accessibilityElement(children: .contain)` with the title as a header.
- Text uses Dynamic Type through `.ds(...)` styles.
- Error is shown with text (`errorMessage`), not color alone.
