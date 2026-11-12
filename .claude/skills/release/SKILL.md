---
name: release
description: Release a new version of the yuanhhou design system (web package @yuanhhou/ds, Swift package YuanhhouDSKit and the Figma libraries) with release notes in CHANGELOG.md and on the Figma Release Note page. Use when the user says "release", "publish", "cut a version", "bump the version", "/release", or asks for release notes.
argument-hint: "[major|minor|patch] (optional; inferred from the changes)"
---

# release

One version number for everything: `web/package.json`, `ios/YuanhhouDSKit/Sources/YuanhhouDSKit/DSVersion.swift`, the git tag `vX.Y.Z`, `CHANGELOG.md` and the Figma `Release Note` page. `$ARGUMENTS` may force the bump (`major`, `minor`, `patch`); otherwise infer it and confirm with the user.

Figma: DS - Components `GLymoPHNnAmM4irCifF2Ei`, page `Release Note` (`158:362`), frame `Release notes` with a `Releases` list of `Release entry` instances (component `161:2`), newest first. Load the `figma-use` skill and call `create_session` before any `use_figma` call.

## 1. Preflight (stop if any fails)
- On `main` (or, in a cloud session, its own branch based on the latest `origin/main`), working tree clean, up to date (`git fetch`, `git status -sb`).
- `node tokens/generate.mjs --check`.
- Web, in `web/`: `npm run build`, `npm run build:lib`, `npm run lint`.
- iOS: `xcodebuild` the app (it builds the package too) and `xcodebuild test` the package, as in `ios/CLAUDE.md`.
- If anything fails, report it and do not release.

## 2. Collect what changed
- Last release: `git describe --tags --abbrev=0` (no tag yet: everything up to the version in `CHANGELOG.md`).
- `git log <last-tag>..HEAD --oneline` and `git diff --stat <last-tag>..HEAD`; read the commit bodies, not just the titles.
- Note anything changed only in Figma (component pages, variables, doc frames) that the commits mention or the user tells you about.
- Nothing user-facing since the last tag: say so and stop.

## 3. Choose the version
Semantic versioning, shared by all three:
- **Breaking** (a component, property, variant, token, CSS variable, Swift API or `data-theme` value removed or renamed; a default changed in a way apps notice): major. While the version is `0.x`, use minor and list it under **Breaking**.
- **New** component, token, mode, feature or API: minor.
- **Fixes**, visual corrections, docs only: patch.

Propose the version with a one-line reason and the draft notes (step 4), and wait for the user's yes before writing anything.

## 4. Write the notes
Same text in all places. Sections in this order, only those that apply: **Breaking**, **Added**, **Changed**, **Fixed**. One bullet per change, written for people who use the design system (designers and app developers), not for us:
- Say what they can now do or must change, on which platform (Web, iOS, Figma); name the component, token or API.
- Breaking items say what to do instead ("`tokens.css` no longer has colors: import `style.css`").
- No commit hashes, file-internal details or "refactor" noise.
- A one-sentence **summary** of the release.

## 5. Apply
1. `CHANGELOG.md`: add `## X.Y.Z · YYYY-MM-DD`, the summary and the sections, above the previous release.
2. `web/package.json` and `web/package-lock.json`: in `web/`, `npm version X.Y.Z --no-git-tag-version`.
3. `DSVersion.swift`: `current = "X.Y.Z"`.
4. Figma `Release Note` page: create an instance of `Release entry` (`161:2`), insert it at the top of the `Releases` list (`insertChild(0, …)`), name it `vX.Y.Z`, and set its properties: `Version` (`vX.Y.Z`), `Date`, `Summary`, each section's text (bullets joined with `\n`, each starting with `• `) and `Show Breaking/Added/Changed/Fixed` (off for empty sections). Read the property keys from the component; do not hardcode their ids. Take one screenshot of the `Release notes` frame to check it.
5. If the workflow or packages changed, also update `docs/workflow.md` and the Figma workflow diagram (see `CLAUDE.md`).

## 6. Validate
Rerun `npm run build:lib` and the iOS build (the version changed). Then test as an outside app: `npm pack`, install the file in a new test app outside this repo, and open a production build in the browser with Button, Input, Toggle, Checkbox, Radio and Accordion, checking for no console errors. Dev mode and the demo catalog do not catch install problems. Confirm `CHANGELOG.md`, `package.json`, `DSVersion.swift` and the Figma entry all show `X.Y.Z`.

## 7. Commit and push to main (this publishes)
Pushing the release to `main` publishes it: the GitHub Actions workflow `.github/workflows/release.yml` runs when `web/package.json` changes on `main`. It checks that the version matches `DSVersion.swift` and `CHANGELOG.md`, runs the token check, `build:lib` and lint, creates the tag `vX.Y.Z` and the GitHub release (notes = that version's `CHANGELOG.md` section), and publishes `@yuanhhou/ds` to npm with trusted publishing (no token). Each step skips what already exists, so a rerun (Actions > Release > Run workflow) only finishes what is missing.

- When the user says "publish" or "release", that is the go-ahead for this step, including pushing to `main`. Otherwise show the version, the notes and the files changed, and ask once: "Push vX.Y.Z to main and publish?"
- `git commit -m "Release vX.Y.Z"` (body: the summary; end with the attribution lines from the session), then push the commit to `main` (from a session branch: `git push origin HEAD:main`, and push the session branch too).
- Do not tag or publish by hand. Cloud sessions cannot push tags, and the workflow does both.
- A published npm version can generally be removed only within about 72 hours, so never push a version bump to `main` unless the user wants it released.

## 8. Check the publish
- Wait a few minutes for the workflow, then confirm: `git ls-remote --tags origin vX.Y.Z` shows the tag and `npm view @yuanhhou/ds version` shows `X.Y.Z`. If either is missing, tell the user to open the failed run under Actions > Release and paste its error.
- iOS: apps that use the package by Git URL pick up the tag through the root `Package.swift`. Local-package users get it on their next pull.
- Figma: remind the user to publish the DS - Components and Tokens libraries if they changed, so the version in Figma matches.

## 9. Report
Version, the notes, what was tagged and pushed, what was published, and anything not done (for example the Figma libraries not yet published).
