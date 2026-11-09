import SwiftUI

/// Size of a link, matching Figma `Link (iOS)` property Size. Use the size of the text around the link.
public nonisolated enum DSLinkSize: String, CaseIterable, Identifiable, Sendable {
    case body1, body2, caption1

    public var id: String { rawValue }

    /// The text style the link is set in, always with the `Emphasized` weight.
    public var textStyle: DSTextStyle {
        switch self {
        case .body1: .body1
        case .body2: .body2
        case .caption1: .caption1
        }
    }
}

public extension View {
    /// Figma `Link (iOS)`: styles SwiftUI's native `Link` with tokens. There is no DS link view.
    ///
    ///     Link("Read the rebrand story", destination: url).dsLink(.body2)
    ///
    /// Sets the `Emphasized` font of the size's text style and tints the link `action/primary`.
    /// The tint also colors markdown links inside a `Text`. Write the regular text with `.font(.ds(_:))`
    /// on the `Text` itself and wrap the link in `**…**`, so only the link is Emphasized:
    ///
    ///     Text("Read **[the rebrand story](https://example.com)** to learn more.")
    ///         .font(.ds(.body1))
    ///         .dsLink(.body1)
    ///
    /// No underline, as in Apple's apps. The link has no padding of its own: when it stands alone,
    /// give it a 44 pt hit area (`.frame(minHeight: DSSize.minimumHitTarget)`).
    /// Put it on `background/primary` (4.5:1 in every mode), never on a brand or inverted surface.
    func dsLink(_ size: DSLinkSize = .body1) -> some View {
        font(.ds(size.textStyle, .emphasized))
            .tint(DSColor.actionPrimary)
    }
}
