import SwiftUI

/// The six Figma color modes of the Tokens library: each brand in Light and Dark.
nonisolated enum DSThemeMode: String, CaseIterable, Sendable {
    case light, dark, evaLight, evaDark, heritageLuxuryLight, heritageLuxuryDark
}

/// Which brand palette a view tree uses. Every brand has a Light and a Dark mode and follows the
/// color scheme (the device appearance, as the HIG asks, unless ``DSAppearance`` overrides it).
nonisolated enum DSTheme: String, CaseIterable, Identifiable, Sendable {
    // `system` is the stored value of the standard palette, kept so saved settings still load.
    case system, eva, heritageLuxury

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "Default"
        case .eva: "EVA"
        case .heritageLuxury: "Heritage Luxury"
        }
    }

    func mode(for colorScheme: ColorScheme) -> DSThemeMode {
        let dark = colorScheme == .dark
        switch self {
        case .system: return dark ? .dark : .light
        case .eva: return dark ? .evaDark : .evaLight
        case .heritageLuxury: return dark ? .heritageLuxuryDark : .heritageLuxuryLight
        }
    }
}

/// Light or Dark for the whole app. `.system` follows the device; the others preview one mode.
nonisolated enum DSAppearance: String, CaseIterable, Identifiable, Sendable {
    case system, light, dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

/// Figma `Typography` density mode, mapped to Apple's Dynamic Type sizes
/// (Compact = Medium, Default = Large, Loose = xLarge). `.system` keeps the user's setting.
nonisolated enum DSDensity: String, CaseIterable, Identifiable, Sendable {
    case system, compact, standard, loose

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "System"
        case .compact: "Compact"
        case .standard: "Default (Large)"
        case .loose: "Loose"
        }
    }

    var dynamicTypeSize: DynamicTypeSize? {
        switch self {
        case .system: nil
        case .compact: .medium
        case .standard: .large
        case .loose: .xLarge
        }
    }
}

nonisolated extension EnvironmentValues {
    @Entry var dsTheme: DSTheme = .system
}

extension View {
    /// Applies a design-system brand palette to this view tree. Light or Dark comes from the color scheme.
    func dsTheme(_ theme: DSTheme) -> some View {
        environment(\.dsTheme, theme)
    }

    /// Previews a typography density. Production screens should leave Dynamic Type to the user.
    @ViewBuilder
    func dsDensity(_ density: DSDensity) -> some View {
        if let size = density.dynamicTypeSize {
            dynamicTypeSize(size)
        } else {
            self
        }
    }
}
