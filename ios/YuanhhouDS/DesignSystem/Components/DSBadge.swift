import SwiftUI

/// Figma `Badge`: a small, non-interactive status label.
///
///     DSBadge("Paid", type: .success, style: .subtle, icon: .check)
struct DSBadge: View {
    enum BadgeType: String, CaseIterable, Identifiable {
        case brand, info, success, warning, error, promote
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    enum Style: String, CaseIterable, Identifiable {
        case solid, subtle
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    enum Size: String, CaseIterable, Identifiable {
        case medium, small
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    let text: LocalizedStringKey
    var type: BadgeType = .brand
    var style: Style = .subtle
    var size: Size = .medium
    var icon: DSIcon?

    init(_ text: LocalizedStringKey, type: BadgeType = .brand, style: Style = .subtle, size: Size = .medium, icon: DSIcon? = nil) {
        self.text = text
        self.type = type
        self.style = style
        self.size = size
        self.icon = icon
    }

    var body: some View {
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
