import SwiftUI

public nonisolated extension EnvironmentValues {
    /// The corner radii of the current brand: Default round, EVA sharp, Heritage Luxury soft.
    /// Set by ``SwiftUI/View/dsTheme(_:)``; read it with `@Environment(\.dsShape)`.
    var dsShape: DSShape { dsTheme.mode(for: colorScheme).shape }
}

/// A rounded rectangle for one `radius/*` token. A radius of half the height or more draws a capsule, so
/// `radius/pill` (9999) stays a capsule at any size while EVA's 0 and Heritage Luxury's 10 draw corners.
public nonisolated struct DSCornerShape: InsettableShape {
    public var radius: CGFloat
    private var inset: CGFloat = 0

    public init(radius: CGFloat) {
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: inset, dy: inset)
        let corner = max(0, radius - inset)
        if corner >= min(rect.width, rect.height) / 2 {
            return Capsule(style: .continuous).path(in: rect)
        }
        return RoundedRectangle(cornerRadius: corner, style: .continuous).path(in: rect)
    }

    public func inset(by amount: CGFloat) -> DSCornerShape {
        var shape = self
        shape.inset += amount
        return shape
    }
}
