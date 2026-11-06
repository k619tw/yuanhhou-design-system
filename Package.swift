// swift-tools-version: 6.2
import PackageDescription

// yuanhhou design system for SwiftUI: tokens (colors, typography, dimensions, icons) and the styles that
// apply them to native controls. Colors are generated from the Figma Tokens library (see `tokens/` at the
// repo root); do not edit `DSColor+Tokens.swift` by hand.
// This root manifest is what apps get when they add the repo by Git URL. Keep it in step with
// ios/YuanhhouDSKit/Package.swift, which the demo app links locally; a test checks that they match.
let package = Package(
    name: "YuanhhouDSKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "YuanhhouDSKit", targets: ["YuanhhouDSKit"]),
    ],
    targets: [
        .target(
            name: "YuanhhouDSKit",
            path: "ios/YuanhhouDSKit/Sources/YuanhhouDSKit",
            resources: [.process("Resources")],
            // Swift 6 language mode; same isolation settings as the app target (main actor by default).
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
        .testTarget(name: "YuanhhouDSKitTests", dependencies: ["YuanhhouDSKit"], path: "ios/YuanhhouDSKit/Tests/YuanhhouDSKitTests"),
    ]
)
