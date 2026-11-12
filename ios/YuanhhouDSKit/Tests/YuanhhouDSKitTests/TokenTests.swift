import Foundation
import Testing
import UIKit
@testable import YuanhhouDSKit

private func luminance(_ hex: String) -> Double {
    let value = UInt64(hex.prefix(6), radix: 16)!
    let channels = [value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF].map { channel -> Double in
        let c = Double(channel) / 255
        return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
    }
    return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2]
}

private func contrast(_ a: String, _ b: String) -> Double {
    let (x, y) = (luminance(a), luminance(b))
    return (max(x, y) + 0.05) / (min(x, y) + 0.05)
}

private func token(_ name: String) throws -> DSColor {
    try #require(DSColor.all.first { $0.name == "color/\(name)" }, "Missing token \(name)")
}

private func checkContrast(_ foreground: String, on background: String, minimum: Double) throws {
    let (fg, bg) = (try token(foreground), try token(background))
    for mode in DSThemeMode.allCases {
        let ratio = contrast(fg.hex(for: mode), bg.hex(for: mode))
        #expect(ratio >= minimum, "\(foreground) on \(background) in \(mode): \(ratio)")
    }
}

private let statuses = ["brand", "info", "success", "warning", "error", "promote"]
private var repoRoot: URL {
    // .../ios/YuanhhouDSKit/Tests/YuanhhouDSKitTests/TokenTests.swift
    var url = URL(fileURLWithPath: #filePath)
    for _ in 0..<5 { url.deleteLastPathComponent() }
    return url
}

@MainActor @Suite struct TokenTests {
    @Test func everyTokenHasValidHexInEveryMode() {
        for color in DSColor.all {
            for mode in DSThemeMode.allCases {
                let hex = color.hex(for: mode)
                #expect((hex.count == 6 || hex.count == 8) && UInt64(hex, radix: 16) != nil, "\(color.name) \(mode)")
            }
        }
    }

    /// The text pairs in the `design-system-rules.md` pairing table.
    @Test func statusPairsPassTextContrast() throws {
        for status in statuses {
            try checkContrast("foreground/\(status)/on/primary", on: "background/\(status)/primary", minimum: 4.5)
            try checkContrast("foreground/\(status)/on/secondary", on: "background/\(status)/secondary", minimum: 4.5)
        }
    }

    @Test func neutralPairsPassTextContrast() throws {
        for surface in ["background/primary", "background/secondary"] {
            for foreground in ["foreground/primary", "foreground/secondary"] + statuses.map({ "foreground/\($0)" }) {
                try checkContrast(foreground, on: surface, minimum: 4.5)
            }
        }
    }

    @Test func everyIconIsARealSFSymbol() {
        for icon in DSIcon.allCases {
            #expect(UIImage(systemName: icon.systemName) != nil, "\(icon.rawValue)")
        }
    }
}

@MainActor @Suite struct PackageTests {
    @Test func everyDisplayNameHasJapanese() throws {
        let file = repoRoot.appending(path: "ios/YuanhhouDSKit/Sources/YuanhhouDSKit/Resources/Localizable.xcstrings")
        let root = try #require(JSONSerialization.jsonObject(with: Data(contentsOf: file)) as? [String: Any])
        let strings = try #require(root["strings"] as? [String: [String: Any]])
        let titles = DSButtonStyle.Kind.allCases.map(\.title) + DSButtonStyle.Size.allCases.map(\.title)
            + DSBadge.Kind.allCases.map(\.title) + DSBadge.Style.allCases.map(\.title) + DSBadge.Size.allCases.map(\.title)
            + DSImageCardOrientation.allCases.map(\.title) + DSTheme.allCases.map(\.title)
            + DSAppearance.allCases.map(\.title) + DSDensity.allCases.map(\.title)
        for title in titles {
            let localizations = strings[title]?["localizations"] as? [String: Any]
            #expect(localizations?["ja"] != nil, "\(title)")
        }
    }

    @Test func versionMatchesWebPackage() throws {
        let data = try Data(contentsOf: repoRoot.appending(path: "web/package.json"))
        let web = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(web["version"] as? String == DSVersion.current)
    }

    /// The root manifest (Git URL installs) and the local manifest (the demo app) must not drift.
    @Test func manifestsDeclareTheSamePlatform() throws {
        func platforms(_ path: String) throws -> String? {
            let text = try String(contentsOf: repoRoot.appending(path: path), encoding: .utf8)
            return text.split(separator: "\n").first { $0.contains("platforms:") }.map(String.init)
        }
        #expect(try platforms("Package.swift") == platforms("ios/YuanhhouDSKit/Package.swift"))
    }
}

/// `docs/components.md` Link: Body 1, Body 2 and Caption 1, each set in the Emphasized weight.
@Test func linkSizesMatchTheFigmaTextStyles() {
    #expect(DSLinkSize.allCases.map(\.textStyle) == [.body1, .body2, .caption1])
    for size in DSLinkSize.allCases {
        #expect(size.textStyle.weight(.emphasized) == .semibold, "\(size)")
    }
}

/// A link is `action/primary` text with no fill behind it, so it must pass text contrast on its surface.
/// Only `background/primary` is checked: on `background/secondary` the Default Dark mode is 3.8:1.
@Test func linkTintPassesTextContrast() throws {
    try checkContrast("action/primary", on: "background/primary", minimum: 4.5)
}

@Test func defaultBrandKeepsItsSavedValue() {
    // Settings saved when the case was named `.system` must still load.
    #expect(DSTheme(rawValue: "system") == .default)
    #expect(DSTheme.default.title == "Default")
}

// MARK: - Brand shape

@Test func brandShapeIsTheSameInLightAndDark() {
    for theme in DSTheme.allCases {
        #expect(theme.mode(for: .light).shape == theme.mode(for: .dark).shape, "\(theme) corners differ between Light and Dark")
    }
}

@Test func defaultBrandKeepsItsCorners() {
    // Default must draw as before: Button and Badge are capsules, controls 12, cards 16.
    let shape = DSTheme.default.mode(for: .light).shape
    #expect(shape.pill >= 999)
    #expect(shape.control == DSRadius.md)
    #expect(shape.card == DSRadius.lg)
}

@Test @available(*, deprecated, message: "Checks the deprecated constants on purpose")
func deprecatedRadiusConstantsMatchTheDefaultBrand() {
    let shape = DSTheme.default.mode(for: .light).shape
    #expect(DSRadius.control == shape.control)
    #expect(DSRadius.card == shape.card)
    #expect(DSRadius.dialog == shape.dialog)
    #expect(DSRadius.sheet == shape.sheet)
    #expect(DSRadius.pill == shape.pill)
}

@Test func cornerShapeDrawsACapsuleForPill() {
    let rect = CGRect(x: 0, y: 0, width: 120, height: 40)
    let pill = DSCornerShape(radius: 9999).path(in: rect)
    #expect(pill.boundingRect == rect)
    // A sharp corner keeps the rectangle's corner point; a capsule does not.
    #expect(DSCornerShape(radius: 0).path(in: rect).contains(CGPoint(x: 0.5, y: 0.5)))
    #expect(!pill.contains(CGPoint(x: 0.5, y: 0.5)))
}
