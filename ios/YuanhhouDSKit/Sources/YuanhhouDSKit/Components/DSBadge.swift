import SwiftUI

/// Figma `Badge`: a small, non-interactive status label.
///
///     DSBadge("Paid", type: .success, style: .subtle, icon: .check)
public struct DSBadge: View {
    public enum BadgeType: String, CaseIterable, Identifiable {
        case brand, info, success, warning, error, promote
        public var id: String { rawValue }
        public var title: String { rawValue.capitalized }
    }

    public enum Style: String, CaseIterable, Identifiable {
        case solid, subtle
        public var id: String { rawValue }
        public var title: String { rawValue.capitalized }
    }

    public enum Size: String, CaseIterable, Identifiable {
        case medium, small
        public var id: String { rawValue }
        public var title: String { rawValue.capitalized }
    }

    public let text: LocalizedStringKey
    public var type: BadgeType = .brand
    public var style: Style = .subtle
    public var size: Size = .medium
    public var icon: DSIcon?

    public init(_ text: LocalizedStringKey, type: BadgeType = .brand, style: Style = .subtle, size: Size = .medium, icon: DSIcon? = nil) {
        self.text = text
        self.type = type
        self.style = style
        self.size = size
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            if let icon { icon.image.accessibilityHidden(true) }
            Text(text)
        }
        .font(size == .medium ? .ds(.caption1, .emphasized) : .ds(.caption2, .emphasized))
        .lineLimit(1)
        .foregroundStyle(colors.foreground)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, size == .medium ? DSSpacing.xs : DSSpacing.xxs)
        .background(Capsule().fill(colors.background))
        .accessibilityElement(children: .combine)
    }

    private var colors: (background: DSColor, foreground: DSColor) {
        let solid = style == .solid
        switch type {
        case .brand: return solid ? (.backgroundBrandPrimary, .foregroundBrandOnPrimary) : (.backgroundBrandSecondary, .foregroundBrandOnSecondary)
        case .info: return solid ? (.backgroundInfoPrimary, .foregroundInfoOnPrimary) : (.backgroundInfoSecondary, .foregroundInfoOnSecondary)
        case .success: return solid ? (.backgroundSuccessPrimary, .foregroundSuccessOnPrimary) : (.backgroundSuccessSecondary, .foregroundSuccessOnSecondary)
        case .warning: return solid ? (.backgroundWarningPrimary, .foregroundWarningOnPrimary) : (.backgroundWarningSecondary, .foregroundWarningOnSecondary)
        case .error: return solid ? (.backgroundErrorPrimary, .foregroundErrorOnPrimary) : (.backgroundErrorSecondary, .foregroundErrorOnSecondary)
        case .promote: return solid ? (.backgroundPromotePrimary, .foregroundPromoteOnPrimary) : (.backgroundPromoteSecondary, .foregroundPromoteOnSecondary)
        }
    }
}
