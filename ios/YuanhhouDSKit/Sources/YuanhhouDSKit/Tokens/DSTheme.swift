import SwiftUI

/// The six Figma color modes of the Tokens library: each brand in Light and Dark.
public nonisolated enum DSThemeMode: String, CaseIterable, Sendable {
    case light, dark, evaLight, evaDark, heritageLuxuryLight, heritageLuxuryDark
}

/// Which brand palette a view tree uses. Every brand has a Light and a Dark mode and follows the
/// color scheme (the device appearance, as the HIG asks, unless ``DSAppearance`` overrides it).
public nonisolated enum DSTheme: String, CaseIterable, Identifiable, Sendable {
    // `system` is the stored value of the standard palette, kept so saved settings still load.
    case system, eva, heritageLuxury

    public var id: String { rawValue }

    /// Localized name from the package catalog.
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }

    /// English name, stable across languages. Show ``label`` to people.
    public var title: String {
        switch self {
        case .system: "Default"
        case .eva: "EVA"
        case .heritageLuxury: "Heritage Luxury"
        }
    }

    public func mode(for colorScheme: ColorScheme) -> DSThemeMode {
        let dark = colorScheme == .dark
        switch self {
        case .system: return dark ? .dark : .light
        case .eva: return dark ? .evaDark : .evaLight
        case .heritageLuxury: return dark ? .heritageLuxuryDark : .heritageLuxuryLight
        }
    }
}

/// Light or Dark for the whole app. `.system` follows the device; the others preview one mode.
public nonisolated enum DSAppearance: String, CaseIterable, Identifiable, Sendable {
    case system, light, dark

    public var id: String { rawValue }

    /// Localized name from the package catalog.
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }

    /// English name, stable across languages. Show ``label`` to people.
    public var title: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    public var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

/// Figma `Typography` density mode, mapped to Apple's Dynamic Type sizes
/// (Compact = Medium, Default = Large, Loose = xLarge). `.system` keeps the user's setting.
public nonisolated enum DSDensity: String, CaseIterable, Identifiable, Sendable {
    case system, compact, standard, loose

    public var id: String { rawValue }

    /// Localized name from the package catalog.
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }

    /// English name, stable across languages. Show ``label`` to people.
    public var title: String {
        switch self {
        case .system: "System"
        case .compact: "Compact"
        case .standard: "Default (Large)"
        case .loose: "Loose"
        }
    }

    public var dynamicTypeSize: DynamicTypeSize? {
        switch self {
        case .system: nil
        case .compact: .medium
        case .standard: .large
        case .loose: .xLarge
        }
    }
}

public nonisolated extension EnvironmentValues {
    @Entry var dsTheme: DSTheme = .system
}

public extension View {
    /// Applies a design-system brand palette to this view tree and tints its native controls with
    /// `action/primary`. Light or Dark comes from the color scheme. Call it once, at the root of the app.
    func dsTheme(_ theme: DSTheme) -> some View {
        dsControlTint().environment(\.dsTheme, theme)
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
