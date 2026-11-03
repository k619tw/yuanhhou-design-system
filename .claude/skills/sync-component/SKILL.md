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
- Component set node ids are in `docs/components.md`. Read variants, properties, bound variables, text styles, sizes. For `tokens`, run `tokens/export-figma.js` on the Tokens file and save the result as `tokens/colors.json`, then run `node tokens/generate.mjs` (never edit the generated color files); read the `Dimension` collection for spacing, radius and sizes.
- Do not trust the markdown over Figma. If a screenshot call drops the connection, rely on the structural read instead.

## 2. Diff against code
- Web: `web/src/components/<Name>/` (`.tsx`, `.css`), exported from `web/src/components/index.ts` (the `@yuanhhou/ds` package), `web/src/styles/tokens.css`, `web/src/styles/primitives.css`, the generated `web/src/styles/colors.css`, the demo page in `web/src/showcase/` (listed in `pages.ts`).
- iOS: the `YuanhhouDSKit` package, `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Tokens/*` and `.../Components/*` (anything the app uses must be `public`; the package's own strings go in its `Resources/Localizable.xcstrings`), plus the demo pages in `ios/YuanhhouDS/Showcase/`. Both catalogs list components in alphabetical order; a new component gets a page in each, in that order.
- List every difference (values, variants, states, token names). If code changed instead (`code` direction), list what Figma lacks.

## 3. Apply to both platforms
- Colors, spacing and radius come from tokens only: no hex, no raw spacing that has a token. If a token is missing, add it to the Tokens library, tell the user to publish it, and only then add the CSS variable and Swift value.
- **Native first (hard rule):** before creating a component on any platform, look for the OS-level control (SwiftUI and the HIG, Material 3, semantic HTML). If one exists, do not build a component for that platform: use the native control styled with tokens (`ButtonStyle`, `ToggleStyle`, `.tint`), and show it instead: a token-bound `<Component> (iOS)` in Figma copied from the Apple iOS kit (rows inside `List Section (iOS)`), a demo in the app's iOS System catalog, and a row in `docs/ios.md`. Build a custom view only when none exists, and say why in `docs/ios.md`. iOS has no checkbox or radio control: iOS always uses `Toggle`, `Picker` and checkmark rows.
- **Platform suffix in Figma:** no suffix = shared; `(Web)` = web only; `(iOS)` = native iOS control with tokens. Keep the suffix when renaming or adding components, and use it to pick components when generating screens (iOS: no-suffix and `(iOS)`; web: no-suffix and `(Web)`).
- Every UI string goes into both languages: `web/src/i18n/messages.ts` (`en` and `ja`) and `ios/YuanhhouDS/Localizable.xcstrings`.
- Code direction: change the Figma component the same way (variants, bound variables), keeping Title Case property names and instance swap (not slots) for icons.

## 4. Update docs and Figma frames
- Update the component's section in `docs/components.md`, `design-system-rules.md` if a rule or token pairing changed, and the row in `docs/ios.md`.
- Update the `Component documentation` frame on the component's Figma page so it matches the markdown. Do not rename that frame. This is part of the change, not a follow-up: the work is not done until the frame matches.
- **Sweep for the same statement everywhere.** A rule or fact rarely lives in one place. For every sentence you changed (a mode list, a token, a "which icon" rule, a size), search for its old wording in all markdown files (`git ls-files '*.md'`) and in the `Component documentation` frame of **every** component page, not just the one you edited (read-only `use_figma`, one page per call, filter the frame's text with a regex of the old words). Fix each hit in the markdown and in Figma. Changes to tokens, themes, shared rules or icons touch many pages.

## 5. Validate
- Docs: repeat the sweep with the old wording and confirm nothing stale is left in the markdown files or any Figma doc frame.
- Web: `npm run build`, `npm run build:lib` and `npm run lint` in `web/`; check the demo in the browser when the change is visual.
- iOS: in `ios/`, `xcodebuild -project YuanhhouDS.xcodeproj -scheme YuanhhouDS -destination 'generic/platform=iOS Simulator' -derivedDataPath <temp dir> build`. Run in the simulator if the user wants to see it.
- Colors changed: re-check contrast across all six modes (text 4.5:1, borders and control outlines 3:1) and run `node tokens/generate.mjs --check`, which fails if `colors.css` or `DSColor+Tokens.swift` no longer match `tokens/colors.json`.
- Anything you could not check (no screenshot, no simulator run) goes in the report.

## 6. Report
Summarize in a short list: what changed in Figma, React, SwiftUI and the docs; what matched, what drifted and was fixed; which Figma doc frames were checked and which were not; what was not verified. Do not commit or push unless the user asks; a change to both platforms is one commit.
