import CoreGraphics

/// Spacing scale (Figma `Dimension` collection, `spacing/*`).
nonisolated enum DSSpacing {
    static let none: CGFloat = 0
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

/// Semantic spacing (Tokens library, `space/*`).
nonisolated enum DSSpace {
    static let insetCompact: CGFloat = 8
    static let insetDefault: CGFloat = 16
    static let insetComfortable: CGFloat = 24
    static let gapTight: CGFloat = 4
    static let gapInline: CGFloat = 8
    static let gapStack: CGFloat = 16
    static let gapSection: CGFloat = 32
    static let pageMobile: CGFloat = 16
    static let pageDesktop: CGFloat = 32
}

/// Corner radii (`radius/*`). Use `Capsule()` for `radius/pill` and `radius/full`.
nonisolated enum DSRadius {
    static let none: CGFloat = 0
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let control: CGFloat = 8
    static let card: CGFloat = 12
    static let dialog: CGFloat = 16
    static let sheet: CGFloat = 24
    /// `radius/pill`; use `Capsule()` for the shape.
    static let pill: CGFloat = 9999
}

/// Component and icon sizes (`size/*`).
nonisolated enum DSSize {
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 20
    static let iconLarge: CGFloat = 24
    static let controlSmall: CGFloat = 32
    static let controlMedium: CGFloat = 40
    static let controlLarge: CGFloat = 48
    /// Apple HIG minimum hit target.
    static let minimumHitTarget: CGFloat = 44
}

/// Stroke widths (`border/width/*`).
nonisolated enum DSBorderWidth {
    static let thin: CGFloat = 1
    static let regular: CGFloat = 1.5
    static let focus: CGFloat = 2
}

/// Opacity tokens (Tokens library, `opacity/*`).
nonisolated enum DSOpacity {
    static let disabled: Double = 0.4
    static let scrim: Double = 0.6
}
