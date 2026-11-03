# Workflow

How the design system moves from Figma to the two packages and the apps, and the steps every change follows. The same diagrams are in the Figma file [Ai Design Systems Workflow](https://www.figma.com/design/IJKMYKXRddNKjFwY9yWYAv/Ai-Design-Systems-Workflow?node-id=4-2).

## How the pieces fit

Figma is the source of truth. Colors are exported once and generated for both platforms; components are synced by hand, through Claude, with the `/sync-component` skill.

```mermaid
flowchart LR
  subgraph Figma["Figma (source of truth)"]
    T["Tokens library<br/>02 Semantics, 6 modes"]
    C["DS - Components<br/>components + doc frames"]
  end

  subgraph Repo["tokens/"]
    E["export-figma.js"]
    J["colors.json"]
    G["generate.mjs"]
  end

  subgraph Web["web/ · @yuanhhou/ds"]
    WC["colors.css<br/>(generated)"]
    WR["React components<br/>tokens.css, typography"]
    WL["npm run build:lib<br/>lib/index.js, style.css, types"]
  end

  subgraph IOS["ios/YuanhhouDSKit · Swift package"]
    IC["DSColor+Tokens.swift<br/>(generated)"]
    IR["SwiftUI styles<br/>DSColor, .ds fonts, DSIcon"]
  end

  subgraph Apps["Apps"]
    WD["Web demo catalog"]
    ID["iOS demo app"]
    X["Your web app / iOS app"]
  end

  T --> E --> J --> G
  G --> WC
  G --> IC
  C -- "/sync-component" --> WR
  C -- "/sync-component" --> IR
  WC --> WL
  WR --> WL
  WL --> WD
  WL --> X
  IC --> ID
  IR --> ID
  IC --> X
  IR --> X
```

## Making a change

The same steps whether the change starts in Figma or in code. `/sync-component <Component|tokens> [figma|code]` runs them for React and SwiftUI together.

```mermaid
flowchart TD
  A["Change in Figma<br/>or in code"] --> B["/sync-component"]
  B --> R["1. Read Figma<br/>use_figma, read-only"]
  R --> D["2. Diff against code<br/>web/ and ios/YuanhhouDSKit"]
  D --> K{"Colors changed?"}
  K -- yes --> P["Publish Tokens library<br/>export-figma.js → colors.json<br/>node tokens/generate.mjs"]
  K -- no --> AP
  P --> AP["3. Apply to both platforms<br/>React + SwiftUI, native first,<br/>English + Japanese strings"]
  AP --> DOC["4. Update docs<br/>components.md, ios.md, rules"]
  DOC --> FR["Update the Figma<br/>Component documentation frame"]
  FR --> SW["Sweep every .md and every<br/>page's doc frame for old wording"]
  SW --> V["5. Validate<br/>generate.mjs --check · build · build:lib · lint<br/>xcodebuild · browser · simulator"]
  V --> OK{"All clean?"}
  OK -- no --> AP
  OK -- yes --> REP["6. Report<br/>what changed, what was not verified"]
  REP --> CP["Commit and push<br/>when you say so"]
```

## Where each step's rules live
| Step | Rules |
|---|---|
| Native first, color pairing, contrast | [design-system-rules.md](../design-system-rules.md) |
| Component specs | [components.md](components.md) |
| SwiftUI usage | [ios.md](ios.md) |
| Token export and generation | [tokens/README.md](../tokens/README.md) |
| The skill itself | [.claude/skills/sync-component/SKILL.md](../.claude/skills/sync-component/SKILL.md) |
