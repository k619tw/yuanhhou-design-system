# YuanhhouDSKit

The yuanhhou design system for SwiftUI: tokens (color, type, spacing, icons) and styles that apply them to native controls. Apps run on iOS 17 or later; building needs Xcode 26 or later (Swift tools 6.2).

## Install
In Xcode, File > Add Package Dependencies, enter `https://github.com/k619tw/yuanhhou-design-system`, and add the product `YuanhhouDSKit`. The repository is private, so your GitHub account needs access.

## Use
Apply the theme once, at the root of the app. It sets the brand palette and tints native controls.

```swift
import YuanhhouDSKit

ContentView().dsTheme(.default)
```

The brands are `.default`, `.eva` and `.heritageLuxury`. Each follows the device between Light and Dark.

```swift
Button("Save") { }.buttonStyle(.ds(.primary, fullWidth: true))
DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { }
DSBadge("Paid", kind: .success, icon: .check)
Text("Title").dsTextStyle(.title2).foregroundStyle(DSColor.foregroundPrimary)
```

Use `.dsTextStyle(...)` for text: it sets the font and marks titles as headings for VoiceOver, which `.font(.ds(...))` does not. Set the page background yourself with `DSColor.backgroundPrimary`.

The full component map is in [`docs/ios.md`](../../docs/ios.md). Use native SwiftUI controls whenever one exists.

## Develop
Colors in `Tokens/DSColor+Tokens.swift` are generated: see [`tokens/README.md`](../../tokens/README.md). Tests need an iOS simulator:

```bash
xcodebuild test -scheme YuanhhouDSKit -destination 'platform=iOS Simulator,name=iPhone 17'
```
