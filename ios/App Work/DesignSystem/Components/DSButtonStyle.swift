import SwiftUI

/// Figma `Button` as a `ButtonStyle`, so it works on any SwiftUI `Button`:
///
///     Button("Save changes") { }
///         .buttonStyle(.ds(.primary, size: .large))
///
/// Pressed and Disabled are not parameters: they come from `configuration.isPressed` and `.disabled()`.
/// Use `Label` for a leading icon and ``DSButtonLabel`` when a trailing icon is needed.
struct DSButtonStyle: ButtonStyle {
    enum Kind: String, CaseIterable, Identifiable {
        case primary, secondary, tertiary, alert
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    enum Size: String, CaseIterable, Identifiable {
        case large, small
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    var kind: Kind = .primary
    var size: Size = .large

    func makeBody(configuration: Configuration) -> some View {
        DSButtonBody(configuration: configuration, kind: kind, size: size)
    }
}

private struct DSButtonBody: View {
    let configuration: ButtonStyle.Configuration
    let kind: DSButtonStyle.Kind
    let size: DSButtonStyle.Size

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        let pressed = configuration.isPressed && isEnabled
        configuration.label
            .font(size == .large ? .ds(.button1, .emphasized) : .ds(.button2, .emphasized))
            .labelStyle(DSButtonLabelStyle(spacing: size == .large ? DSSpace.gapTight : DSSpacing.sm))
            .lineLimit(1)
            .foregroundStyle(foreground)
            // Large: height comes from padding (12 + line height + 12), like Figma. Small: fixed 36.
            .padding(.horizontal, size == .large ? DSSpacing.xl : DSSpacing.lg)
            .padding(.vertical, size == .large ? DSSpacing.md : 0)
            .frame(minHeight: size == .small ? 36 : nil)
            .background(Capsule().fill(fill(pressed: pressed)))
            .overlay {
                if kind == .secondary {
                    Capsule().strokeBorder(stroke(pressed: pressed), lineWidth: DSBorderWidth.regular)
                }
            }
            .contentShape(Capsule())
    }

    private var foreground: AnyShapeStyle {
        if !isEnabled {
            return AnyShapeStyle(kind == .primary || kind == .alert ? DSColor.foregroundOnDisabled : DSColor.foregroundDisabled)
        }
        switch kind {
        case .primary: return AnyShapeStyle(DSColor.foregroundBrandOnPrimary)
        case .secondary, .tertiary: return AnyShapeStyle(DSColor.foregroundBrand)
        case .alert: return AnyShapeStyle(DSColor.foregroundErrorOnSecondary)
        }
    }

    private func fill(pressed: Bool) -> AnyShapeStyle {
        switch kind {
        case .primary:
            if !isEnabled { return AnyShapeStyle(DSColor.backgroundDisabled) }
            return AnyShapeStyle(pressed ? DSColor.backgroundBrandPrimaryPressed : DSColor.backgroundBrandPrimary)
        case .alert:
            if !isEnabled { return AnyShapeStyle(DSColor.backgroundDisabled) }
            return AnyShapeStyle(pressed ? DSColor.backgroundErrorSecondaryPressed : DSColor.backgroundErrorSecondary)
        case .secondary, .tertiary:
            return AnyShapeStyle(pressed ? AnyShapeStyle(DSColor.backgroundOverlay) : AnyShapeStyle(Color.clear))
        }
    }

    private func stroke(pressed: Bool) -> DSColor {
        if !isEnabled { return DSColor.foregroundDisabled }
        return pressed ? DSColor.borderBrandPressed : DSColor.borderBrand
    }
}

/// Icon + title with the Figma gap; the icon is display only.
private struct DSButtonLabelStyle: LabelStyle {
    let spacing: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon.accessibilityHidden(true)
            configuration.title
        }
    }
}

/// Button content with optional leading and trailing Utility Icons (display only).
struct DSButtonLabel: View {
    let title: LocalizedStringKey
    var leading: DSIcon?
    var trailing: DSIcon?

    init(_ title: LocalizedStringKey, leading: DSIcon? = nil, trailing: DSIcon? = nil) {
        self.title = title
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        HStack(spacing: DSSpace.gapTight + 4) {
            if let leading { leading.image.accessibilityHidden(true) }
            Text(title)
            if let trailing { trailing.image.accessibilityHidden(true) }
        }
    }
}

extension ButtonStyle where Self == DSButtonStyle {
    static func ds(_ kind: DSButtonStyle.Kind = .primary, size: DSButtonStyle.Size = .large) -> DSButtonStyle {
        DSButtonStyle(kind: kind, size: size)
    }
}
