# yuanhhou design system

One Figma design system, implemented twice: React in `web/` and SwiftUI in `ios/`. Figma and both codebases are kept in sync by hand (through Claude), so every change that touches one must be checked against the others. Platform notes are in `web/CLAUDE.md` and `ios/CLAUDE.md`. The repository is public, so everything committed here is public.

## Sources of truth
| What | Where |
|---|---|
| Components | Figma file `GLymoPHNnAmM4irCifF2Ei` (DS - Components); node ids in `docs/components.md` |
| Native iOS controls, brand applied | Figma file `Ow4FgnInMQhUgn0LEz4ugM` (iOS System Components) |
| Colors and brand corner radii | Figma file `5iR1wP3qoTT4uD6d20ekVv` (Tokens), collection `02 Semantics`, exported to `tokens/colors.json`; primitives in `01 Primitives` |
| Spacing, radius, size, border width | `Dimension` collection in DS - Components, plus semantic `radius/*` and `space/*` in the Tokens library |
| Typography | Text styles `<Style>/Regular|Emphasized`; mode axes: collections `Platform` and `Typography` |
| Rules, color pairing, Figma conventions | `design-system-rules.md` |
| Per-component docs | `docs/components.md` (also on each Figma page in a frame named `Component documentation`) |
| iOS usage | `docs/ios.md` |
| What is missing or accepted | `docs/known-gaps.md`: read it before calling something a bug |

## Packages
- Web: `@yuanhhou/ds` from `web/`, public on npm. A plain folder install crashes hook components in production builds; see `web/README.md`.
- iOS: the Swift package `YuanhhouDSKit`, iOS 17 or later, added by Git URL through the root `Package.swift`. The demo app links `ios/YuanhhouDSKit` locally. Keep the two manifests in step (a package test checks the platform).
- Colors and the brand corner radii for both are generated from `tokens/colors.json` (see `tokens/README.md`).

## Rules that must hold
- **Native first on every platform (hard rule):** before creating any component, look for the OS-level control: SwiftUI and the HIG on iOS, Material 3 and Compose on Android, the semantic HTML element on web. If one exists, do **not** build a component for that platform: use it, styled only through tokens, and show it in Figma as `<Component> (iOS)`, in the app's iOS System catalog and in `docs/ios.md`. Build custom only when there is no equivalent, and say why in `docs/ios.md`. iOS has no checkbox or radio: use `Toggle`, `Picker` and checkmark rows.
- **Icon rule:** a Utility Icon is display only. An icon that triggers an action is an Icon Button (with an accessible label). Icons inside Button, Badge and Input are display only.
- **Color pairing:** follow the table in `design-system-rules.md`. Never put a foreground on a surface it was not designed for.
- **No hardcoded colors** on either platform. If a color is missing, add it to the Tokens file and publish the library, export with `tokens/export-figma.js`, and run `node tokens/generate.mjs`. Never edit the generated files (`colors.css`, `shape.css`, `DSColor+Tokens.swift`, `DSShape+Tokens.swift`) by hand.
- **Every UI string in English and Japanese** (`web/src/i18n/messages.ts`, `ios/YuanhhouDS/Localizable.xcstrings`).
- **Platform suffix in Figma:** no suffix = shared; `(Web)` = web only; `(iOS)` = the native iOS control shown with tokens. An iOS screen uses no-suffix and `(iOS)` components, never `(Web)`; for web, the reverse.

## Making a change
Use `/sync-component <Component|tokens> [figma|code]` (`.claude/skills/sync-component`); start Claude in this folder so the skill is found. Its steps apply to any change, with or without the command:
1. Read Figma first; do not trust docs over it.
2. Apply to both platforms and, for a code-first change, to the Figma component.
3. Update `docs/components.md`, `design-system-rules.md` and `docs/ios.md` as needed, and the `Component documentation` frame.
4. Sweep every markdown file and every component page's frame for the old wording. The change is not done until the sweep is clean.
5. Validate: `node tokens/generate.mjs --check`; `npm run build`, `build:lib` and `lint` in `web/`; `xcodebuild` for `ios/` and `xcodebuild test` in `ios/YuanhhouDSKit/`; check visual changes in the browser and the simulator.

## Team
The main session is the GM of Design and can hand work to the subagents in `.claude/agents/`: content designer, web engineer, DS designer (Figma), iOS engineer, GM assistant (checks everything: native-first verdict before building, then that web, iOS, content, Figma and docs agree; read-only) and PM (summary, questions, release notes, portfolio framing). Only the main session commits, pushes or releases. Roles and the flow are in `docs/workflow.md`.

When the workflow changes, update `docs/workflow.md` and the Figma file `IJKMYKXRddNKjFwY9yWYAv` (frame `4:2`).

## Releases
`/release [major|minor|patch]` (`.claude/skills/release`) cuts one version for both packages and the Figma libraries. Pushing the release commit to `main` publishes it: the GitHub Actions workflow `.github/workflows/release.yml` tags `vX.Y.Z`, creates the GitHub release and publishes `@yuanhhou/ds` to npm. "Publish" or "release" from the user is the go-ahead to push to `main`; otherwise ask first.
