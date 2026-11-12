import SwiftUI

/// Spacing scale (Figma `Dimension` collection, `spacing/*`).
public nonisolated enum DSSpacing {
    public static let none: CGFloat = 0
    public static let xxs: CGFloat = 2
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 48
}

/// Semantic spacing (Tokens library, `space/*`).
public nonisolated enum DSSpace {
    public static let insetCompact: CGFloat = 8
    public static let insetDefault: CGFloat = 16
    public static let insetComfortable: CGFloat = 24
    public static let gapTight: CGFloat = 4
    public static let gapInline: CGFloat = 8
    public static let gapStack: CGFloat = 16
    public static let gapSection: CGFloat = 32
    public static let pageMobile: CGFloat = 16
    public static let pageDesktop: CGFloat = 32
}

/// Corner radius scale (`radius/*` in the Dimension collection), the same in every brand. The semantic radii
/// (`control`, `card`, `dialog`, `sheet`, `pill`) follow the brand: read `@Environment(\.dsShape)` and draw them
/// with ``DSCornerShape``. The deprecated `DSRadius.control` and friends (in `DSShape+Tokens.swift`) are the
/// Default brand's values only.
public nonisolated enum DSRadius {
    public static let none: CGFloat = 0
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
}

/// Component and icon sizes (`size/*`).
public nonisolated enum DSSize {
    public static let iconSmall: CGFloat = 16
    public static let iconMedium: CGFloat = 20
    public static let iconLarge: CGFloat = 24
    public static let controlSmall: CGFloat = 32
    public static let controlMedium: CGFloat = 40
    public static let controlLarge: CGFloat = 48
    /// Apple HIG minimum hit target.
    public static let minimumHitTarget: CGFloat = 44
}

/// Stroke widths (`border/width/*`).
public nonisolated enum DSBorderWidth {
    public static let thin: CGFloat = 1
    public static let regular: CGFloat = 1.5
    public static let focus: CGFloat = 2
}

/// Elevation (`shadow/*`), the same values as `--shadow-*` on web. iOS uses the color, radius and offset of the
/// first layer only.
public struct DSShadow: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let y: CGFloat

    /// `shadow/sm`: 0 1 2 at `1A1A1A` 8%.
    public nonisolated static let small = DSShadow(color: Color(dsHex: "1A1A1A14"), radius: 2, y: 1)
}

/// Opacity tokens (Tokens library, `opacity/*`).
public nonisolated enum DSOpacity {
    public static let disabled: Double = 0.4
    public static let scrim: Double = 0.6
}
