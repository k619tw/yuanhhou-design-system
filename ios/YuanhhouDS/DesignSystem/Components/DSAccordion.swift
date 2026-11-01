import SwiftUI

/// Figma `Accordion` as a style for the native `DisclosureGroup`:
///
///     DisclosureGroup("Shipping and returns") { Text("…") }
///         .disclosureGroupStyle(.dsAccordion)
///
/// The whole header is one button (title + chevron), which is what VoiceOver and the HIG expect.
struct DSAccordionStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        DSAccordionBody(configuration: configuration)
    }
}

private struct DSAccordionBody: View {
    let configuration: DisclosureGroupStyle.Configuration

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.snappy) { configuration.isExpanded.toggle() }
            } label: {
                HStack(spacing: DSSpacing.md) {
                    configuration.label
                        .font(.ds(.body1, .emphasized))
                        .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    (configuration.isExpanded ? DSIcon.expandLess : DSIcon.expandMore).image
                        .font(.system(size: DSSize.iconMedium * 0.85, weight: .semibold))
                        .foregroundStyle(isEnabled ? DSColor.foregroundBrand : DSColor.foregroundOnDisabled)
                        .frame(width: DSSize.controlSmall, height: DSSize.controlSmall)
                        .accessibilityHidden(true)
                }
                .padding(.leading, DSSpacing.lg)
                .padding(.trailing, DSSpacing.sm)
                .padding(.vertical, DSSpacing.sm)
                .frame(minHeight: DSSize.minimumHitTarget)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(configuration.isExpanded ? "Expanded" : "Collapsed")

            if configuration.isExpanded {
                configuration.content
                    .font(.ds(.body2))
                    .foregroundStyle(isEnabled ? DSColor.foregroundSecondary : DSColor.foregroundDisabled)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.bottom, DSSpacing.lg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(DSColor.borderPrimary).frame(height: DSBorderWidth.thin)
        }
    }
}

extension DisclosureGroupStyle where Self == DSAccordionStyle {
    static var dsAccordion: DSAccordionStyle { DSAccordionStyle() }
}

extension View {
    /// Tints native controls (Toggle, Slider, Picker) with the design-system action color.
    /// The DS Toggle on iOS is the system switch, not a custom drawing.
    func dsControlTint() -> some View {
        tint(DSColor.actionPrimary)
    }
}
