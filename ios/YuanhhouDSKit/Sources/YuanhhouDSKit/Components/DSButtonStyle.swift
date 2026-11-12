import SwiftUI

/// Figma `Button` as a `ButtonStyle`, so it works on any SwiftUI `Button`:
///
///     Button("Save changes") { }
///         .buttonStyle(.ds(.primary, size: .large))
///
/// Pressed and Disabled are not parameters: they come from `configuration.isPressed` and `.disabled()`.
/// Use `Label` for a leading icon and ``DSButtonLabel`` when a trailing icon is needed.
public struct DSButtonStyle: ButtonStyle {
    public enum Kind: String, CaseIterable, Identifiable {
        case primary, secondary, tertiary, alert
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public enum Size: String, CaseIterable, Identifiable {
        case large, small
        public var id: String { rawValue }
        /// English name, stable across languages. Show ``label`` to people.
        public var title: String { rawValue.capitalized }
        /// Localized name from the package catalog.
        public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
    }

    public var kind: Kind = .primary
    public var size: Size = .large
    /// Stretches the button to the width its container offers.
    public var fullWidth = false
    /// Pads Small out to the 44 pt HIG hit target. Turn off only when the parent is already 44 pt tall.
    public var expandsHitArea = true

    public init(kind: Kind = .primary, size: Size = .large, fullWidth: Bool = false, expandsHitArea: Bool = true) {
        self.kind = kind
        self.size = size
        self.fullWidth = fullWidth
        self.expandsHitArea = expandsHitArea
    }

    public func makeBody(configuration: Configuration) -> some View {
        DSButtonBody(configuration: configuration, kind: kind, size: size, fullWidth: fullWidth, expandsHitArea: expandsHitArea)
    }
}

private struct DSButtonBody: View {
    let configuration: ButtonStyle.Configuration
    let kind: DSButtonStyle.Kind
    let size: DSButtonStyle.Size
    let fullWidth: Bool
    let expandsHitArea: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsShape) private var shape

    var body: some View {
        let pressed = configuration.isPressed && isEnabled
        let corners = DSCornerShape(radius: shape.pill)
        let iconGap = size == .large ? DSSpace.gapTight : DSSpacing.sm
        configuration.label
            .font(size == .large ? .ds(.button1, .emphasized) : .ds(.button2, .emphasized))
            .labelStyle(DSButtonLabelStyle(spacing: iconGap))
            .environment(\.dsButtonIconGap, iconGap)
            // No line limit: long labels and accessibility text sizes wrap instead of truncating.
            .multilineTextAlignment(.center)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .foregroundStyle(foreground)
            // Height comes from padding, like Figma: Large 12 + line height + 12, Small 8 + line height + 8.
            // Both grow with Dynamic Type.
            .padding(.horizontal, size == .large ? DSSpacing.xl : DSSpacing.lg)
            .padding(.vertical, size == .large ? DSSpacing.md : DSSpacing.sm)
            .background(corners.fill(fill(pressed: pressed)))
            .overlay {
                if kind == .secondary {
                    corners.strokeBorder(stroke(pressed: pressed), lineWidth: DSBorderWidth.regular)
                }
            }
            // The iPad pointer highlight takes the brand's corners; the tap area below stays a 44 pt rectangle.
            .contentShape(.hoverEffect, corners)
            .hoverEffect(.highlight)
            // Small draws about 36 pt; this pads its layout and tap area to 44 without changing what is drawn.
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
public struct DSButtonLabel: View {
    public let title: LocalizedStringKey
    public var leading: DSIcon?
    public var trailing: DSIcon?

    @Environment(\.dsButtonIconGap) private var iconGap

    public init(_ title: LocalizedStringKey, leading: DSIcon? = nil, trailing: DSIcon? = nil) {
        self.title = title
        self.leading = leading
        self.trailing = trailing
    }

    public var body: some View {
        HStack(spacing: iconGap) {
            if let leading { leading.image.accessibilityHidden(true) }
            Text(title)
            if let trailing { trailing.image.accessibilityHidden(true) }
        }
    }
}

public extension ButtonStyle where Self == DSButtonStyle {
    static func ds(
        _ kind: DSButtonStyle.Kind = .primary,
        size: DSButtonStyle.Size = .large,
        fullWidth: Bool = false,
        expandsHitArea: Bool = true
    ) -> DSButtonStyle {
        DSButtonStyle(kind: kind, size: size, fullWidth: fullWidth, expandsHitArea: expandsHitArea)
    }
}

private extension EnvironmentValues {
    /// Icon gap of the enclosing button: Large 4, Small 8, as in Figma.
    @Entry var dsButtonIconGap: CGFloat = DSSpace.gapTight
}

#Preview("Button") {
    VStack(spacing: DSSpacing.md) {
        ForEach(DSButtonStyle.Kind.allCases) { kind in
            Button { } label: { kind.label }.buttonStyle(.ds(kind))
            Button { } label: { kind.label }.buttonStyle(.ds(kind, size: .small))
        }
        Button("Full width") { }.buttonStyle(.ds(fullWidth: true))
        // A native Link takes the same style: it looks like a button and VoiceOver reads it as a link.
        Link(destination: URL(string: "https://github.com/k619tw/yuanhhou-design-system")!) { Text(verbatim: "Link as a button") }
            .buttonStyle(.ds(.secondary))
    }
    .padding()
}

#Preview("Button, brands") {
    VStack(spacing: DSSpacing.lg) {
        ForEach(DSTheme.allCases) { theme in
            HStack(spacing: DSSpacing.md) {
                Button("Primary") { }.buttonStyle(.ds(.primary))
                Button("Secondary") { }.buttonStyle(.ds(.secondary))
            }
            .dsTheme(theme)
        }
    }
    .padding()
}
