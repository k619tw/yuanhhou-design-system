// swift-tools-version: 6.2
import PackageDescription

// yuanhhou design system for SwiftUI: tokens (colors, typography, dimensions, icons) and the styles that
// apply them to native controls. Colors are generated from the Figma Tokens library (see `tokens/` at the
// repo root); do not edit `DSColor+Tokens.swift` by hand.
let package = Package(
    name: "YuanhhouDSKit",
    defaultLocalization: "en",
    platforms: [.iOS("27.0")],
    products: [
        .library(name: "YuanhhouDSKit", targets: ["YuanhhouDSKit"]),
    ],
    targets: [
        .target(
            name: "YuanhhouDSKit",
            resources: [.process("Resources")],
            // Same concurrency settings as the app target (main actor by default, approachable concurrency).
            swiftSettings: [
                .swiftLanguageMode(.v5),
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
    ]
)
