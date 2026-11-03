import SwiftUI

/// A semantic color token from the Figma Tokens library (`02 Semantics`).
///
/// `DSColor` is a `ShapeStyle`, so it resolves itself against the current ``DSTheme`` and color scheme:
/// `.foregroundStyle(DSColor.foregroundPrimary)`, `.background(DSColor.backgroundPrimary)`,
/// `.tint(DSColor.actionPrimary)`. The token values live in `DSColor+Tokens.swift`.
nonisolated struct DSColor: ShapeStyle, Hashable, Sendable, Identifiable {
    /// Figma variable name, for example `color/background/brand/primary`.
    let name: String
    let light: String
    let dark: String
    let evaLight: String
    let evaDark: String
    let heritageLuxuryLight: String
    let heritageLuxuryDark: String

    var id: String { name }

    init(
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

    func resolve(in environment: EnvironmentValues) -> Color {
        color(for: environment.dsTheme.mode(for: environment.colorScheme))
    }

    /// Hex string (`RRGGBB` or `RRGGBBAA`) for one Figma mode.
    func hex(for mode: DSThemeMode) -> String {
        switch mode {
        case .light: light
        case .dark: dark
        case .evaLight: evaLight
        case .evaDark: evaDark
        case .heritageLuxuryLight: heritageLuxuryLight
        case .heritageLuxuryDark: heritageLuxuryDark
        }
    }

    func color(for mode: DSThemeMode) -> Color {
        Color(dsHex: hex(for: mode))
    }
}

nonisolated extension Color {
    /// Creates a color from `RRGGBB` or `RRGGBBAA`.
    init(dsHex hex: String) {
        let value = UInt64(hex, radix: 16) ?? 0
        let hasAlpha = hex.count == 8
        let r = Double((value >> (hasAlpha ? 24 : 16)) & 0xFF) / 255
        let g = Double((value >> (hasAlpha ? 16 : 8)) & 0xFF) / 255
        let b = Double((value >> (hasAlpha ? 8 : 0)) & 0xFF) / 255
        let a = hasAlpha ? Double(value & 0xFF) / 255 : 1
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
