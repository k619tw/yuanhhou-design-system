import SwiftUI

/// Figma `Badge`: a small, non-interactive status label.
///
///     DSBadge("Paid", kind: .success, style: .subtle, icon: .check)
public struct DSBadge: View {
    public enum Kind: String, CaseIterable, Identifiable {
        case brand, info, success, warning, error, promote
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public enum Style: String, CaseIterable, Identifiable {
        case solid, subtle
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public enum Size: String, CaseIterable, Identifiable {
        case medium, small
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public let text: LocalizedStringKey
    public var kind: Kind = .brand
    public var style: Style = .subtle
    public var size: Size = .medium
    public var icon: DSIcon?

    public init(_ text: LocalizedStringKey, kind: Kind = .brand, style: Style = .subtle, size: Size = .medium, icon: DSIcon? = nil) {
        self.text = text
        self.kind = kind
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
        // No line limit: long text and accessibility text sizes wrap instead of truncating.
        .foregroundStyle(colors.foreground)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, size == .medium ? DSSpacing.xs : DSSpacing.xxs)
        .background(Capsule().fill(colors.background))
        .accessibilityElement(children: .combine)
    }

    private var colors: (background: DSColor, foreground: DSColor) {
        let solid = style == .solid
        switch kind {
        case .brand: return solid ? (.backgroundBrandPrimary, .foregroundBrandOnPrimary) : (.backgroundBrandSecondary, .foregroundBrandOnSecondary)
        case .info: return solid ? (.backgroundInfoPrimary, .foregroundInfoOnPrimary) : (.backgroundInfoSecondary, .foregroundInfoOnSecondary)
        case .success: return solid ? (.backgroundSuccessPrimary, .foregroundSuccessOnPrimary) : (.backgroundSuccessSecondary, .foregroundSuccessOnSecondary)
        case .warning: return solid ? (.backgroundWarningPrimary, .foregroundWarningOnPrimary) : (.backgroundWarningSecondary, .foregroundWarningOnSecondary)
        case .error: return solid ? (.backgroundErrorPrimary, .foregroundErrorOnPrimary) : (.backgroundErrorSecondary, .foregroundErrorOnSecondary)
        case .promote: return solid ? (.backgroundPromotePrimary, .foregroundPromoteOnPrimary) : (.backgroundPromoteSecondary, .foregroundPromoteOnSecondary)
        }
    }
}

#Preview("Badge") {
    VStack(spacing: DSSpacing.sm) {
        ForEach(DSBadge.Kind.allCases) { kind in
            HStack {
                DSBadge("Paid", kind: kind, style: .solid)
                DSBadge("Paid", kind: kind, style: .subtle, icon: .check)
            }
        }
    }
    .padding()
}
