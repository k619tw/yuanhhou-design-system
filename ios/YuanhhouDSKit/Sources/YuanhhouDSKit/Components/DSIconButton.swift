import SwiftUI

/// Figma `Icon Button`: an interactive, icon-only button. It always needs an accessibility label.
/// For a decorative icon use ``DSUtilityIcon``.
///
///     DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { dismiss() }
public struct DSIconButton: View {
    public enum Size: String, CaseIterable, Identifiable {
        case large, small
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public let icon: DSIcon
    /// Accessibility label, localized from the String Catalog.
    public let label: LocalizedStringKey
    public var kind: DSButtonStyle.Kind = .primary
    public var size: Size = .large
    /// Pads Small (32) out to the 44pt HIG hit target. Turn off only when the parent is already 44pt tall.
    public var expandsHitArea = true
    public let action: () -> Void

    public init(
        _ icon: DSIcon,
        label: LocalizedStringKey,
        kind: DSButtonStyle.Kind = .primary,
        size: Size = .large,
        expandsHitArea: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.kind = kind
        self.size = size
        self.expandsHitArea = expandsHitArea
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            icon.image
        }
        .buttonStyle(DSIconButtonStyle(kind: kind, size: size, expandsHitArea: expandsHitArea))
        .accessibilityLabel(Text(label))
    }
}

public struct DSIconButtonStyle: ButtonStyle {
    public var kind: DSButtonStyle.Kind
    public var size: DSIconButton.Size
    public var expandsHitArea: Bool

    public init(kind: DSButtonStyle.Kind = .primary, size: DSIconButton.Size = .large, expandsHitArea: Bool = true) {
        self.kind = kind
        self.size = size
        self.expandsHitArea = expandsHitArea
    }

    public func makeBody(configuration: Configuration) -> some View {
        DSIconButtonBody(configuration: configuration, kind: kind, size: size, expandsHitArea: expandsHitArea)
    }
}

private struct DSIconButtonBody: View {
    let configuration: ButtonStyle.Configuration
    let kind: DSButtonStyle.Kind
    let size: DSIconButton.Size
    let expandsHitArea: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsShape) private var corners
    /// Grows the box and glyph with Dynamic Type; 1 at the default size.
    @ScaledMetric private var scale: CGFloat = 1

    var body: some View {
        let pressed = configuration.isPressed && isEnabled
        let box = (size == .large ? DSSize.controlLarge : DSSize.controlSmall) * scale
        let shape = DSCornerShape(radius: corners.control)
        configuration.label
            .font(.system(size: (size == .large ? DSSize.iconLarge : DSSize.iconMedium) * 0.85 * scale, weight: .medium))
            .foregroundStyle(foreground)
            .frame(width: box, height: box)
            .background(shape.fill(fill(pressed: pressed)))
            .overlay {
                if kind == .secondary {
                    shape.strokeBorder(stroke(pressed: pressed), lineWidth: DSBorderWidth.regular)
                }
            }
            // The iPad pointer highlight takes the brand's corners; the tap area below stays a 44 pt rectangle.
            .contentShape(.hoverEffect, shape)
            .hoverEffect(.highlight)
            .frame(
                minWidth: expandsHitArea ? DSSize.minimumHitTarget : nil,
                minHeight: expandsHitArea ? DSSize.minimumHitTarget : nil
            )
            .contentShape(Rectangle())
    }

    private var foreground: AnyShapeStyle {
        if !isEnabled {
            return AnyShapeStyle(kind == .primary || kind == .alert ? DSColor.foregroundOnDisabled : DSColor.foregroundDisabled)
        }
        switch kind {
        case .primary: return AnyShapeStyle(DSColor.foregroundBrandOnPrimary)
        case .secondary, .tertiary: return AnyShapeStyle(DSColor.foregroundBrand)
        case .alert: return AnyShapeStyle(DSColor.foregroundErrorOnPrimary)
        }
    }

    private func fill(pressed: Bool) -> AnyShapeStyle {
        switch kind {
        case .primary:
            if !isEnabled { return AnyShapeStyle(DSColor.backgroundDisabled) }
            return AnyShapeStyle(pressed ? DSColor.backgroundBrandPrimaryPressed : DSColor.backgroundBrandPrimary)
        case .alert:
            if !isEnabled { return AnyShapeStyle(DSColor.backgroundDisabled) }
            return AnyShapeStyle(pressed ? DSColor.backgroundErrorPrimaryPressed : DSColor.backgroundErrorPrimary)
        case .secondary, .tertiary:
            return pressed ? AnyShapeStyle(DSColor.backgroundOverlay) : AnyShapeStyle(Color.clear)
        }
    }

    private func stroke(pressed: Bool) -> DSColor {
        if !isEnabled { return DSColor.foregroundDisabled }
        return pressed ? DSColor.borderBrandPressed : DSColor.borderBrand
    }
}

#Preview("Icon Button") {
    HStack(spacing: DSSpacing.md) {
        ForEach(DSButtonStyle.Kind.allCases) { kind in
            DSIconButton(.close, label: "Close", kind: kind) { }
            DSIconButton(.close, label: "Close", kind: kind, size: .small) { }
        }
    }
    .padding()
}

#Preview("Icon Button, brands") {
    VStack(spacing: DSSpacing.lg) {
        ForEach(DSTheme.allCases) { theme in
            HStack(spacing: DSSpacing.md) {
                DSIconButton(.close, label: "Close") { }
                DSIconButton(.close, label: "Close", kind: .secondary) { }
            }
            .dsTheme(theme)
        }
    }
    .padding()
}
