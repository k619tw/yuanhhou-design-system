# Checks

The rule: when the same mistake happens twice, a machine checks for it from then on. Every check below runs on each pull request and each push to `main` (`.github/workflows/checks.yml`), and you can run it locally from the repo root.

## Machine checks
| Command | Fails when | The mistake it stops |
|---|---|---|
| `node tokens/generate.mjs --check` | a generated colour or shape file is out of date or edited by hand | generated files copied or edited by hand |
| `node tokens/palette.mjs --check` | a colour pair in `colors.json` is below WCAG AA in any of the six modes, or the primitives are stale | `action/primary` in Dark at 3.80:1 on `background/secondary` |
| `node scripts/check-docs.mjs` | a Markdown file (not `CHANGELOG.md`) names a Swift type or modifier, a CSS variable or a colour token that the code does not have | docs describing Row (iOS) after it was removed, stale theme and accordion text, the demo app's list background modifiers taught as package API |
| `node scripts/check-native-first.mjs` | a public SwiftUI view in the package is named after a control iOS already has, or has no reason in `docs/ios.md` ("Custom because ..." or "a native `X` ...") | a custom checkbox and radio, text field and accordion on iOS, each later replaced by the native control |
| `node scripts/check-strings.mjs` | an iOS string catalog has a key with no translated Japanese (stale keys and "Don't translate" are skipped) | "%lld selected" shipped in the demo app with no Japanese. Web strings are typed, so the build already fails on a gap |
| `npm run build`, `build:lib`, `lint` in `web/` | TypeScript, the library build or oxlint fails | |

Still on a Mac before release: `xcodebuild` for `ios/` and `xcodebuild test` in `ios/YuanhhouDSKit/` (the token contrast, icon, string and version tests). The cloud and Linux CI cannot run them.

## Checks a person makes
These came up more than once but need judgement, so they are not automated.
- **Native first, before building.** Ask the GM assistant for the native-first verdict before any new component. The script only sees a component once it exists.
- **Figma doc frames.** After a change, sweep every component page's `Component documentation` frame for the old wording. The docs check reads Markdown only.
- **Status colours mean status.** Error, success, warning, info and promote are for state. Decoration (gradients, tags, illustrations) uses the accent colours.
