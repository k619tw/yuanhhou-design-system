import SwiftUI

/// The Figma text styles, set to Platform = iOS.
///
/// Each style maps to an Apple text style, so it uses SF Pro and scales with Dynamic Type.
/// At the default Dynamic Type size (Large) the values match the Figma `iOS` / `Default` mode;
/// the Figma `Compact` and `Loose` densities are Apple's Medium and xLarge sizes (see ``DSDensity``).
nonisolated enum DSTextStyle: String, CaseIterable, Identifiable, Sendable {
    case largeTitle, title1, title2, title3, headline, body1, body2, button1, button2, caption1, caption2

    var id: String { rawValue }

    /// Figma style name.
    var figmaName: String {
        switch self {
        case .largeTitle: "Large Title"
        case .title1: "Title 1"
        case .title2: "Title 2"
        case .title3: "Title 3"
        case .headline: "Headline"
        case .body1: "Body 1"
        case .body2: "Body 2"
        case .button1: "Button 1"
        case .button2: "Button 2"
        case .caption1: "Caption 1"
        case .caption2: "Caption 2"
        }
    }

    /// The Apple text style this maps to. Body 2 and the button styles share Apple styles,
    /// because the Figma set is not 1:1 with iOS.
    var appleTextStyle: Font.TextStyle {
        switch self {
        case .largeTitle: .largeTitle
        case .title1: .title
        case .title2: .title2
        case .title3: .title3
        case .headline, .button1: .headline
        case .body1: .body
        case .body2, .button2: .subheadline
        case .caption1: .caption
        case .caption2: .caption2
        }
    }

    /// Size and leading at Dynamic Type Large (Figma `iOS` / `Default`), for documentation.
    var defaultMetrics: (size: Int, lineHeight: Int) {
        switch self {
        case .largeTitle: (34, 41)
        case .title1: (28, 34)
        case .title2: (22, 28)
        case .title3: (20, 25)
        case .headline, .body1, .button1: (17, 22)
        case .body2, .button2: (15, 20)
        case .caption1: (12, 16)
        case .caption2: (11, 13)
        }
    }

    /// Accessibility heading role, mirroring the web HTML tags (h1, h2, h3).
    var isHeading: Bool {
        switch self {
        case .largeTitle, .title1, .title2, .title3: true
        default: false
        }
    }
}

/// `Regular` or `Emphasized` (semibold) variant of a text style.
nonisolated enum DSFontWeight: String, CaseIterable, Sendable {
    case regular, emphasized

    var weight: Font.Weight {
        switch self {
        case .regular: .regular
        case .emphasized: .semibold
        }
    }
}

extension Font {
    /// Design-system font: `.font(.ds(.body1, .emphasized))`.
    static func ds(_ style: DSTextStyle, _ weight: DSFontWeight = .regular) -> Font {
        .system(style.appleTextStyle, weight: weight.weight)
    }
}

extension View {
    /// Applies a design-system text style and, for titles, the header accessibility trait.
    func dsTextStyle(_ style: DSTextStyle, _ weight: DSFontWeight = .regular) -> some View {
        font(.ds(style, weight))
            .accessibilityAddTraits(style.isHeading ? .isHeader : [])
    }
}
