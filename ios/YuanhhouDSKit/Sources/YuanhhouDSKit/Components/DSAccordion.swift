import SwiftUI

/// Figma `Accordion (iOS)`: a style for the native `DisclosureGroup` with text content, used in a `List` or `Form`.
/// It exists only to draw the SF Symbol chevron in `action/secondary`, which the system chevron cannot do; the
/// group, its rows and separators stay native.
///
///     DisclosureGroup("Shipping and returns") { Text("…") }
///         .disclosureGroupStyle(.dsAccordion)
///
/// The content sits right under the label (no top padding, no separator above it), in Body 2 and `foreground/secondary`.
/// Add `.dsAccordionList()` to the `Form` or `List`, or one-line content is padded to the
/// 44 pt minimum row height and floats in extra space.
public struct DSAccordionStyle: DisclosureGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        DSAccordionHeader(configuration: configuration)
        if configuration.isExpanded {
            DSAccordionContent(content: configuration.content)
                // Only the vertical insets change; the leading inset stays the system's, so the text lines up
                // with the label on every device.
                .dsAccordionContentInsets()
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
                // One glyph that turns 90 degrees. Swapping chevron.right for chevron.down changes the glyph's
                // width and cross-fades, which jumps; rotating keeps the same shape and animates smoothly.
                Image(systemName: "chevron.right")
                    .font(.ds(.body2, .emphasized))
                    .foregroundStyle(isEnabled ? DSColor.actionSecondary : DSColor.foregroundDisabled)
                    .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(configuration.isExpanded ? Text("Expanded", bundle: .module) : Text("Collapsed", bundle: .module))
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

private extension View {
    @ViewBuilder
    func dsAccordionContentInsets() -> some View {
        if #available(iOS 26.0, *) {
            listRowInsets(.top, 0).listRowInsets(.bottom, DSSpacing.md)
        } else {
            // Before iOS 26 all four insets must be set together; 16 and 20 are the system's list values.
            listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: DSSpacing.md, trailing: 16))
        }
    }
}

public extension View {
    /// Lets `.dsAccordion` content rows be as short as their text. Apply it to the `Form` or `List`.
    func dsAccordionList() -> some View {
        environment(\.defaultMinListRowHeight, 0)
    }
}

public extension DisclosureGroupStyle where Self == DSAccordionStyle {
    static var dsAccordion: DSAccordionStyle { DSAccordionStyle() }
}

#Preview("Accordion") {
    Form {
        DisclosureGroup("Shipping and returns") { Text("Free returns within 30 days.") }
            .disclosureGroupStyle(.dsAccordion)
    }
    .dsAccordionList()
}
