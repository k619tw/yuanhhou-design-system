import SwiftUI

/// Figma `Accordion (iOS)`: a style for the native `DisclosureGroup` with text content, used in a `List` or `Form`.
/// It exists only to draw the SF Symbol chevron in `action/secondary`, which the system chevron cannot do; the
/// group, its rows and separators stay native.
///
///     DisclosureGroup("Shipping and returns") { Text("…") }
///         .disclosureGroupStyle(.dsAccordion)
///
/// The content sits right under the label (no top padding, no separator above it), in Body 2 and `foreground/secondary`.
/// Set `.environment(\.defaultMinListRowHeight, 0)` on the `Form` or `List`, or one-line content is padded to the
/// 44 pt minimum row height and floats in extra space.
struct DSAccordionStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        DSAccordionHeader(configuration: configuration)
        if configuration.isExpanded {
            DSAccordionContent(content: configuration.content)
                .listRowInsets(EdgeInsets(top: 0, leading: DSSpacing.lg, bottom: DSSpacing.md, trailing: DSSpacing.lg))
                .listRowSeparator(.hidden, edges: .top)
        }
    }
}

private struct DSAccordionHeader: View {
    let configuration: DisclosureGroupStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            withAnimation(.snappy) { configuration.isExpanded.toggle() }
        } label: {
            HStack(spacing: DSSpacing.sm) {
                configuration.label
                    .font(.ds(.body1))
                    .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.right")
                    .font(.ds(.body1, .emphasized))
                    .foregroundStyle(isEnabled ? DSColor.actionSecondary : DSColor.foregroundDisabled)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(configuration.isExpanded ? Text("Expanded") : Text("Collapsed"))
    }
}

private struct DSAccordionContent<Content: View>: View {
    let content: Content
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        content
            .font(.ds(.body2))
            .foregroundStyle(isEnabled ? DSColor.foregroundSecondary : DSColor.foregroundDisabled)
    }
}

extension DisclosureGroupStyle where Self == DSAccordionStyle {
    static var dsAccordion: DSAccordionStyle { DSAccordionStyle() }
}
