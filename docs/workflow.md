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
  WL -- "npm install @yuanhhou/ds" --> X
  IC --> ID
  IR --> ID
  IC -- "Git URL" --> X
  IR -- "Git URL" --> X
  X -. "findings go through<br/>the same loop" .-> C
```

## Making a change

The same steps whether the change starts in Figma, in code or with feedback from an app. `/sync-component <Component|tokens> [figma|code]` runs them for React and SwiftUI together.

```mermaid
flowchart TD
  A["Change in Figma or in code,<br/>or feedback from an app"] --> B["/sync-component"]
  B --> R["1. Read Figma<br/>use_figma, read-only"]
  R --> D["2. Diff against code<br/>web/ and ios/YuanhhouDSKit"]
  D --> K{"Colors changed?"}
  K -- yes --> P["Publish Tokens library<br/>export-figma.js → colors.json<br/>node tokens/generate.mjs"]
  K -- no --> AP
  P --> AP["3. Apply to both platforms<br/>React + SwiftUI, native first,<br/>English + Japanese strings"]
  AP --> DOC["4. Update docs<br/>components.md, ios.md, rules"]
  DOC --> FR["Update the Figma<br/>Component documentation frame"]
  FR --> SW["Sweep every .md and every<br/>page's doc frame for old wording"]
  SW --> V["5. Validate<br/>generate.mjs --check · build · build:lib · lint<br/>xcodebuild · xcodebuild test · browser · simulator"]
  V --> OK{"All clean?"}
  OK -- no --> AP
  OK -- yes --> REP["6. Report<br/>what changed, what was not verified"]
  REP --> CP["Commit and push to main<br/>after validation passes"]
  CP --> REL["/release<br/>version · CHANGELOG.md · Figma Release Note<br/>test in an outside app · tag vX.Y.Z<br/>publish to npm and Figma: you approve"]
```

## The team

The main Claude session acts as GM of Design: it plans the work, hands pieces to the subagents in `.claude/agents/`, checks what they return, and is the only one that commits, pushes or runs `/release`. Each subagent ends its report with **Questions for the GM**, which the PM collects.

| Agent | Role | Model, effort | Owns |
|---|---|---|---|
| `content-designer` | Content Designer | Sonnet, low | English and Japanese strings, doc wording, the markdown sweep |
| `web-engineer` | Staff Web Engineer | Opus, medium | React and CSS in `web/`, web validation and browser check |
| `ds-designer` | Design Systems Designer assistant | Sonnet, medium | Figma components, variables, doc frames, the Figma sweep |
| `ios-engineer` | Staff iOS Engineer | Opus, medium | SwiftUI in `ios/`, iOS validation and simulator check |
| `native-consultant` | Native DS consultant | Sonnet, medium | Parity verdict: what web and native share, where each follows its own platform (advisory, no edits) |
| `pm` | Product Manager | Sonnet, medium | Summary, flagged questions, risks, release notes draft for `/release` |

```mermaid
flowchart LR
  GM["GM of Design<br/>main session"] --> RF["Native consultant<br/>native-first verdict"]
  RF --> AK["DS designer<br/>Figma"]
  RF --> SM["Web engineer<br/>web/"]
  RF --> VT["iOS engineer<br/>ios/"]
  CJ["Content designer<br/>strings + docs"] --> SM
  CJ --> VT
  AK --> PM["PM<br/>summary · questions · notes"]
  SM --> PM
  VT --> PM
  CJ --> PM
  PM --> GM
  GM --> REL["Commit, push,<br/>/release"]
```

## Where each step's rules live
| Step | Rules |
|---|---|
| Native first, color pairing, contrast | [design-system-rules.md](../design-system-rules.md) |
| Component specs | [components.md](components.md) |
| SwiftUI usage | [ios.md](ios.md) |
| Token export and generation | [tokens/README.md](../tokens/README.md) |
| The sync skill | [.claude/skills/sync-component/SKILL.md](../.claude/skills/sync-component/SKILL.md) |
| Releases and notes | [.claude/skills/release/SKILL.md](../.claude/skills/release/SKILL.md), [CHANGELOG.md](../CHANGELOG.md) |
| The team's roles | [.claude/agents/](../.claude/agents/) |
