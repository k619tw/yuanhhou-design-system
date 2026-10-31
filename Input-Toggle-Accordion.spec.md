# Input, Toggle, Accordion (web spec)

Figma file `GLymoPHNnAmM4irCifF2Ei`. Pages `Input` (set 18:109), `Toggle` (18:167), `Accordion` (18:221). Tokens are CSS variables; names below drop the `var(--…)` wrapper (for example `color-border-secondary`).

Icon rule: icons inside a component are display-only (`Utility Icon`). A control inside a component that does something is an `Icon Button`.

## Input

| Property | Values |
|---|---|
| State | Default, Focus, Error, Disabled (Focus and Error are real states: `:focus-visible`, `aria-invalid="true"`; Disabled is `disabled`) |
| Size | Medium (40 px, `size-control-md`), Large (48 px, `size-control-lg`) |
| Text properties | Label, Value, Helper |
| Booleans | Show label, Show helper, Show leading icon, Show trailing action |
| Slots | Leading icon (Utility Icon, display only, default `search` 20 px), Trailing action (Icon Button, default `close`, e.g. clear or show password; needs `aria-label`) |

Layout: column, width 320 (fill in code), gap `spacing-xs`. Field: row, horizontal padding `spacing-md`, gap `spacing-sm`, radius `radius-md`, fill `color-background-primary`.

| State | Stroke | Field fill | Value text | Helper |
|---|---|---|---|---|
| Default | `color-border-tertiary`, `border-width-default` (1.5) | `color-background-primary` | `color-foreground-secondary` (placeholder; typed text is `color-foreground-primary`) | `color-foreground-secondary` |
| Focus | `color-border-focus`, `border-width-focus` (2) | `color-background-primary` | `color-foreground-primary` | `color-foreground-secondary` |
| Error | `color-border-error`, 1.5 | `color-background-primary` | `color-foreground-primary` | `color-foreground-error` |
| Disabled | `color-border-primary`, 1.5 | `color-background-secondary` | `color-foreground-disabled` | `color-foreground-disabled` |

Leading icon: `color-foreground-secondary` (Default), `color-foreground-primary` (Focus), `color-foreground-error` (Error), `color-foreground-disabled` (Disabled). Trailing action: Icon Button instance, 32 px, glyph 20 px, `color-foreground-brand` (Disabled: `color-foreground-on-disabled`). Error keeps the focus ring on focus.

Text: Label = `Body 2/Emphasized`, value = `Body 1/Regular`, helper = `Caption 1/Regular`.
Notes: link label with `for`/`id`; helper and error with `aria-describedby`; do not show error with color alone (keep the message text).

## Toggle

| Property | Values |
|---|---|
| Checked | Off, On (`aria-checked`) |
| State | Default, Disabled |
| Text / boolean | Label, Show label |

Track 44 × 24, radius `radius-full`, padding `spacing-2xs`, knob 20 px circle (left when Off, right when On), gap to label `spacing-sm`.

| Checked / State | Track | Knob | Label |
|---|---|---|---|
| Off, Default | `color-action-secondary` | `color-foreground-brand-on-primary` | `color-foreground-primary` |
| On, Default | `color-action-primary` | `color-foreground-brand-on-primary` | `color-foreground-primary` |
| Off, Disabled | `color-border-primary` | `color-background-primary` | `color-foreground-disabled` |
| On, Disabled | `color-background-disabled` | `color-background-primary` | `color-foreground-disabled` |

Use `role="switch"`; the label is part of the click target. For choices submitted with a form use Checkbox (not built yet). The switch's keyboard focus ring is not in the Figma variants; code uses `outline: border-width-focus solid color-border-focus`. Figma confirms the track and knob colors above (Off Default track `color-action-secondary`, On Default `color-action-primary`, Disabled Off `color-border-primary`, Disabled On `color-background-disabled`).

## Accordion (item)

| Property | Values |
|---|---|
| Expanded | False, True (`aria-expanded`) |
| State | Default, Disabled |
| Text | Title |
| Slot | Content (any content) |

Width 480 (fill in code). Bottom border 1 px `color-border-primary`. Header: row, padding left `spacing-lg`, right/vertical `spacing-sm`, gap `spacing-md`; title `Body 1/Emphasized` (`color-foreground-primary`, disabled `color-foreground-disabled`). Chevron is 32 px, radius `radius-md`, glyph 20 px, `color-foreground-brand` (disabled `color-foreground-on-disabled`). Disabled content text is `color-foreground-disabled`. Content slot: padding `spacing-lg` left/right/bottom, text `Body 2/Regular` `color-foreground-secondary`.

The chevron is an Icon Button (Tertiary, Small) because it triggers the expand: `expand_more` when closed, `expand_less` when open. Make the whole header toggle too; give the button `aria-expanded` and `aria-controls` pointing at the content region (`role="region"`, `aria-labelledby`). Disabled items are not toggleable. For a group, stack items; single-open or multi-open is a code behavior, not a Figma variant.
