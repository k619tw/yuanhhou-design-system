import SwiftUI

/// A semantic color token from the Figma Tokens library (`02 Semantics`).
///
/// `DSColor` is a `ShapeStyle`, so it resolves itself against the current ``DSTheme`` and color scheme:
/// `.foregroundStyle(DSColor.foregroundPrimary)`, `.background(DSColor.backgroundPrimary)`,
/// `.fill(DSColor.backgroundBrandPrimary)`. Native controls get their tint from ``SwiftUI/View/dsTheme(_:)``,
/// not from `.tint(DSColor…)`. The token values live in `DSColor+Tokens.swift`.
public nonisolated struct DSColor: ShapeStyle, Hashable, Sendable, Identifiable {
    /// Figma variable name, for example `color/background/brand/primary`.
    public let name: String
    public let light: String
    public let dark: String
    public let evaLight: String
    public let evaDark: String
    public let heritageLuxuryLight: String
    public let heritageLuxuryDark: String

    public var id: String { name }

    public init(
        _ name: String, light: String, dark: String, evaLight: String, evaDark: String,
        heritageLuxuryLight: String, heritageLuxuryDark: String
    ) {
        self.name = name
        self.light = light
        self.dark = dark
        self.evaLight = evaLight
        self.evaDark = evaDark
        self.heritageLuxuryLight = heritageLuxuryLight
        self.heritageLuxuryDark = heritageLuxuryDark
    }

    public func resolve(in environment: EnvironmentValues) -> Color {
        color(for: environment.dsTheme.mode(for: environment.colorScheme))
    }

    /// Hex string (`RRGGBB` or `RRGGBBAA`) for one Figma mode.
    public func hex(for mode: DSThemeMode) -> String {
        switch mode {
        case .light: light
        case .dark: dark
        case .evaLight: evaLight
        case .evaDark: evaDark
        case .heritageLuxuryLight: heritageLuxuryLight
        case .heritageLuxuryDark: heritageLuxuryDark
        }
    }

    public func color(for mode: DSThemeMode) -> Color {
        Color(dsHex: hex(for: mode))
    }
}

nonisolated extension Color {
    /// Creates a color from `RRGGBB` or `RRGGBBAA`. Internal: apps use tokens, never hex values.
    init(dsHex hex: String) {
        guard hex.count == 6 || hex.count == 8, let value = UInt64(hex, radix: 16) else {
            assertionFailure("Invalid token hex: \(hex)")
            self = .clear
            return
        }
        let hasAlpha = hex.count == 8
        let r = Double((value >> (hasAlpha ? 24 : 16)) & 0xFF) / 255
        let g = Double((value >> (hasAlpha ? 16 : 8)) & 0xFF) / 255
        let b = Double((value >> (hasAlpha ? 8 : 0)) & 0xFF) / 255
        let a = hasAlpha ? Double(value & 0xFF) / 255 : 1
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
