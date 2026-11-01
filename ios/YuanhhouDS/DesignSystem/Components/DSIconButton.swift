import SwiftUI

/// Figma `Icon Button`: an interactive, icon-only button. It always needs an accessibility label.
/// For a decorative icon use ``DSUtilityIcon``.
///
///     DSIconButton(.close, label: "Close", kind: .tertiary, size: .small) { dismiss() }
struct DSIconButton: View {
    enum Size: String, CaseIterable, Identifiable {
        case large, small
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    let icon: DSIcon
    /// Accessibility label, localized from the String Catalog.
    let label: LocalizedStringKey
    var kind: DSButtonStyle.Kind = .primary
    var size: Size = .large
    /// Pads Small (32) out to the 44pt HIG hit target. Turn off only when the parent is already 44pt tall.
    var expandsHitArea = true
    let action: () -> Void

    init(
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

    var body: some View {
        Button(action: action) {
            icon.image
        }
        .buttonStyle(DSIconButtonStyle(kind: kind, size: size, expandsHitArea: expandsHitArea))
        .accessibilityLabel(Text(label))
    }
}

struct DSIconButtonStyle: ButtonStyle {
    var kind: DSButtonStyle.Kind
    var size: DSIconButton.Size
    var expandsHitArea: Bool

    func makeBody(configuration: Configuration) -> some View {
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
