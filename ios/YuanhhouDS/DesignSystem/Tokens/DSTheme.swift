import SwiftUI

/// The four Figma color modes of the Tokens library.
nonisolated enum DSThemeMode: String, CaseIterable, Sendable {
    case light, dark, eva, heritageLuxury
}

/// Which palette a view tree uses. `.system` is the standard palette and follows the device
/// appearance (Light or Dark), as the HIG asks; preview Dark with the device setting or Xcode's
/// Environment Overrides. The brand themes are fixed palettes.
nonisolated enum DSTheme: String, CaseIterable, Identifiable, Sendable {
    case system, eva, heritageLuxury

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "Light / Dark (System)"
        case .eva: "EVA"
        case .heritageLuxury: "Heritage Luxury"
        }
    }

    func mode(for colorScheme: ColorScheme) -> DSThemeMode {
        switch self {
        case .system: colorScheme == .dark ? .dark : .light
        case .eva: .eva
        case .heritageLuxury: .heritageLuxury
        }
    }

    /// Color scheme for native controls inside the theme (EVA is a dark palette, Heritage Luxury a light one).
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .heritageLuxury: .light
        case .eva: .dark
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
    /// Applies a design-system theme to this view tree, including the color scheme of native controls.
    @ViewBuilder
    func dsTheme(_ theme: DSTheme) -> some View {
        if let scheme = theme.colorScheme {
            environment(\.dsTheme, theme).environment(\.colorScheme, scheme)
        } else {
            environment(\.dsTheme, theme)
        }
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
