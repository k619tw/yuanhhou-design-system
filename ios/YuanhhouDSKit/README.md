# YuanhhouDSKit

The yuanhhou design system for SwiftUI: tokens (color, type, spacing, icons) and styles that apply them to native controls. iOS 17 or later.

## Install
In Xcode, File > Add Package Dependencies, enter `https://github.com/k619tw/yuanhhou-design-system`, and add the product `YuanhhouDSKit`.

## Use
Apply the theme once, at the root of the app. It sets the brand palette and tints native controls.

```swift
import YuanhhouDSKit

ContentView().dsTheme(.eva)
```

```swift
Button("Save") { }.buttonStyle(.ds(.primary, fullWidth: true))
DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { }
DSBadge("Paid", kind: .success, icon: .check)
Text("Title").dsTextStyle(.title2).foregroundStyle(DSColor.foregroundPrimary)
```

The full component map is in [`docs/ios.md`](../../docs/ios.md). Use native SwiftUI controls whenever one exists.

## Develop
Colors in `Tokens/DSColor+Tokens.swift` are generated: see [`tokens/README.md`](../../tokens/README.md). Tests need an iOS simulator:

```bash
xcodebuild test -scheme YuanhhouDSKit -destination 'platform=iOS Simulator,name=iPhone 17'
```
