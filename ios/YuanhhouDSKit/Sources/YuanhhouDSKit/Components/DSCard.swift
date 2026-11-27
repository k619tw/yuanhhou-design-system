import SwiftUI

/// Card `Style` (Material 3's card types): Filled is one step off the surface it sits on, Outlined has a hairline,
/// Elevated has a hairline and a shadow (the hairline keeps the edge in Dark, where shadows don't show).
public enum DSCardStyle: String, CaseIterable, Identifiable {
    case filled, outlined, elevated
    public var id: String { rawValue }
    /// English name, stable across languages. Show ``label`` to people.
    public var title: String { rawValue.capitalized }
    /// Localized name from the package catalog.
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

/// Card `Padding`: Default 16 (`space/inset/default`), Comfortable 24 (`space/inset/comfortable`), None 0 (for
/// full-bleed media inside).
public enum DSCardPadding: String, CaseIterable, Identifiable {
    case `default`, comfortable, none
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }

    public var points: CGFloat {
        switch self {
        case .default: DSSpace.insetDefault
        case .comfortable: DSSpace.insetComfortable
        case .none: 0
        }
    }
}

/// Card `Surface`: the background the card sits on. Filled and Outlined take their fill from it.
public enum DSCardSurface: String, CaseIterable, Identifiable {
    case primary, secondary
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

public extension View {
    /// Figma `Card`: puts the view on a card surface in the brand's card corners (`radius/card`). Custom because
    /// SwiftUI has no card. For a card that is one button or link, wrap it in a `Button` or `NavigationLink` with
    /// `.buttonStyle(.dsCard)`.
    func dsCard(_ style: DSCardStyle = .filled, padding: DSCardPadding = .default, on surface: DSCardSurface = .primary) -> some View {
        modifier(DSCardModifier(style: style, padding: padding, surface: surface))
    }
}

private struct DSCardModifier: ViewModifier {
    let style: DSCardStyle
    let padding: DSCardPadding
    let surface: DSCardSurface
    @Environment(\.dsShape) private var corners

    func body(content: Content) -> some View {
        let shape = DSCornerShape(radius: corners.card)
        content
            .padding(padding.points)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(fill)
            // Clips full-bleed content (Padding None) to the card corners.
            .clipShape(shape)
            .overlay {
                if style != .filled {
                    shape.strokeBorder(DSColor.borderPrimary, lineWidth: DSBorderWidth.thin)
                }
            }
            .background {
                // Drawn behind the clipped card, so only the card casts the shadow, not the text on it.
                if style == .elevated {
                    shape.fill(fill)
                        .shadow(color: DSShadow.small.color, radius: DSShadow.small.radius, y: DSShadow.small.y)
                }
            }
            // A wrapping button or link highlights in the brand's corners.
            .contentShape(shape)
    }

    private var fill: DSColor {
        switch (style, surface) {
        case (.filled, .primary): .backgroundSecondary
        case (.filled, .secondary): .backgroundPrimary
        case (.outlined, .primary): .backgroundPrimary
        case (.outlined, .secondary): .backgroundSecondary
        case (.elevated, _): .backgroundPrimary
        }
    }
}

/// The pressed look for a card that is one `Button` or `NavigationLink` (Card or Image Card): the
/// `background/overlay` fill over the card in its corners and a slight sink (none with Reduce Motion); the iPad
/// pointer lifts it. It draws no surface of its own: put `.dsCard(...)` or a `DSImageCard` in the label.
public struct DSCardButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        DSCardButtonBody(configuration: configuration)
    }
}

public extension ButtonStyle where Self == DSCardButtonStyle {
    /// `.buttonStyle(.dsCard)`: see ``DSCardButtonStyle``.
    static var dsCard: DSCardButtonStyle { DSCardButtonStyle() }
}

private struct DSCardButtonBody: View {
    let configuration: ButtonStyle.Configuration

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsShape) private var corners
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let pressed = configuration.isPressed && isEnabled
        let shape = DSCornerShape(radius: corners.card)
        configuration.label
            .overlay {
                shape.fill(DSColor.backgroundOverlay)
                    .opacity(pressed ? 1 : 0)
                    .allowsHitTesting(false)
            }
            .scaleEffect(pressed && !reduceMotion ? 0.98 : 1)
            .animation(.spring(duration: 0.25), value: pressed)
            .contentShape(shape)
            .contentShape(.hoverEffect, shape)
            .hoverEffect(.lift)
    }
}

#Preview("Card, styles and brands") {
    ScrollView {
        VStack(spacing: DSSpacing.lg) {
            ForEach(DSTheme.allCases) { theme in
                ForEach(DSCardStyle.allCases) { style in
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text(verbatim: style.title).font(.ds(.headline, .emphasized))
                        Text(verbatim: "Any content goes in a card.").font(.ds(.body2))
                    }
                    .dsCard(style)
                }
                .dsTheme(theme)
            }
        }
        .padding()
    }
}
