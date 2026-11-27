import SwiftUI

/// Figma `Labeled Content (iOS)`, the iOS side of `Description List (Web)`: the native `LabeledContent` with the
/// label above the value (Caption 1 `foreground/secondary` over Body 1 `foreground/primary`), read as one element.
/// A native `LabeledContent` styled with tokens, so no DS view: use it in a `Form` section or in a stack on a
/// `.dsCard`.
///
/// ```swift
/// LabeledContent("Role") { Text("Lead designer") }
///     .labeledContentStyle(.dsStacked)
/// ```
public struct DSStackedLabeledContentStyle: LabeledContentStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            configuration.label
                .font(.ds(.caption1))
                .foregroundStyle(DSColor.foregroundSecondary)
            configuration.content
                .font(.ds(.body1))
                .foregroundStyle(DSColor.foregroundPrimary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

public extension LabeledContentStyle where Self == DSStackedLabeledContentStyle {
    /// `.labeledContentStyle(.dsStacked)`: see ``DSStackedLabeledContentStyle``.
    static var dsStacked: DSStackedLabeledContentStyle { DSStackedLabeledContentStyle() }
}

#Preview("Labeled Content, stacked") {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
        LabeledContent("Role") { Text(verbatim: "Lead designer") }
        LabeledContent("Company") { Text(verbatim: "Example Co.") }
    }
    .labeledContentStyle(.dsStacked)
    .dsCard()
    .padding()
}
