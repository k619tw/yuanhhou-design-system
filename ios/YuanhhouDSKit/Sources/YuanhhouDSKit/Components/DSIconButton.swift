import SwiftUI

/// Figma `Icon Button`: an interactive, icon-only button. It always needs an accessibility label.
/// For a decorative icon use ``DSUtilityIcon``.
///
///     DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { dismiss() }
public struct DSIconButton: View {
    public enum Size: String, CaseIterable, Identifiable {
        case large, small
        public var id: String { rawValue }
        public var title: String { rawValue.capitalized }
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

    var body: some View {
        let pressed = configuration.isPressed && isEnabled
        let box = size == .large ? DSSize.controlLarge : DSSize.controlSmall
        let shape = RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
        configuration.label
            .font(.system(size: (size == .large ? DSSize.iconLarge : DSSize.iconMedium) * 0.85, weight: .medium))
            .foregroundStyle(foreground)
            .frame(width: box, height: box)
            .background(shape.fill(fill(pressed: pressed)))
            .overlay {
                if kind == .secondary {
                    shape.strokeBorder(stroke(pressed: pressed), lineWidth: DSBorderWidth.regular)
                }
            }
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
