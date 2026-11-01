---
name: sync-component
description: Sync one design-system component (or the tokens) between Figma, React (web/) and SwiftUI (ios/), then validate and report. Use when the user changes a component in Figma, changes it in code, or says "sync Button", "apply this Figma change to iOS and web", "/sync-component".
argument-hint: "<Component name | tokens> [figma|code]"
---

# sync-component

One command, same steps for both platforms. `$ARGUMENTS` is a component name (`Button`, `Icon Button`, `Checkbox`...) or `tokens`, optionally followed by the direction: `figma` (Figma changed, update code; the default) or `code` (code changed, update Figma).

Everything is in this repo: React in `web/`, SwiftUI in `ios/`, shared docs in `docs/` and the root. Paths below are relative to the repo root. Figma files: components `GLymoPHNnAmM4irCifF2Ei`, Tokens library `5iR1wP3qoTT4uD6d20ekVv`. Read the root `CLAUDE.md` and `design-system-rules.md` first if you have not this session: they hold the rules and the color-pairing table.

## 1. Read Figma (the source of truth)
- Load the `figma-use` skill, call `create_session` for the file, then read with `use_figma` (read-only). Never run two `use_figma` calls at once.
- Component set node ids are in `docs/components.md`. Read variants, properties, bound variables, text styles, sizes. For `tokens`, read the `02 Semantics` collection (4 modes) and the `Dimension` collection.
- Do not trust the markdown over Figma. If a screenshot call drops the connection, rely on the structural read instead.

## 2. Diff against code
- Web: `web/src/components/<Name>/` (`.tsx`, `.css`), `web/src/styles/tokens.css`, `web/src/styles/primitives.css`, `web/src/App.tsx`.
- iOS: `ios/App Work/DesignSystem/Tokens/*` and `ios/App Work/DesignSystem/Components/*`, plus the demo pages in `ios/App Work/Showcase/`.
- List every difference (values, variants, states, token names). If code changed instead (`code` direction), list what Figma lacks.

## 3. Apply to both platforms
- Colors, spacing and radius come from tokens only: no hex, no raw spacing that has a token. If a token is missing, add it to the Tokens library, tell the user to publish it, and only then add the CSS variable and Swift value.
- **Native first on iOS:** use the SwiftUI control and style it (`ButtonStyle`, `ToggleStyle`, `.tint`); build a custom view only when none exists, and say why in `docs/ios.md`. iOS has no checkbox or radio control.
- Every UI string goes into both languages: `web/src/i18n/messages.ts` (`en` and `ja`) and `ios/App Work/Localizable.xcstrings`.
- Code direction: change the Figma component the same way (variants, bound variables), keeping Title Case property names and instance swap (not slots) for icons.

## 4. Update docs and Figma frames
- Update the component's section in `docs/components.md`, `design-system-rules.md` if a rule or token pairing changed, and the row in `docs/ios.md`.
- Update the `Component documentation` frame on the component's Figma page so it matches the markdown. Do not rename that frame.

## 5. Validate
- Web: `npm run build` and `npm run lint` in `web/`; check the demo in the browser when the change is visual.
- iOS: in `ios/`, `xcodebuild -project "App Work.xcodeproj" -scheme "App Work" -destination 'generic/platform=iOS Simulator' -derivedDataPath <temp dir> build`. Run in the simulator if the user wants to see it.
- Colors changed: re-check contrast across all four themes (text 4.5:1, borders and control outlines 3:1) and compare Figma code syntax values with `tokens.css` and `DSColor+Tokens.swift`.
- Anything you could not check (no screenshot, no simulator run) goes in the report.

## 6. Report
Summarize in a short list: what changed in Figma, React, SwiftUI and the docs; what matched, what drifted and was fixed; what was not verified. Do not commit or push unless the user asks; a change to both platforms is one commit.
