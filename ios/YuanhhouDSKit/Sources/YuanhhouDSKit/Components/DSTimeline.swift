import SwiftUI

/// Timeline `Size`: Medium (Body 1 titles, 24 between items) or Large (Title 3 titles, 32 between items).
public enum DSTimelineSize: String, CaseIterable, Identifiable {
    case medium, large
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

/// How much of the line is filled in `action/primary`.
public enum DSTimelineFill: String, CaseIterable, Identifiable {
    /// No fill: the line in `border/primary` only.
    case none
    /// The whole line is filled.
    case full
    /// The fill grows as the list scrolls: it reaches an item when the item is about two thirds of the way up the
    /// scroll view. With Reduce Motion the line is simply full.
    case scroll
    public var id: String { rawValue }
}

/// One moment on a ``DSTimeline``: an optional label (such as a date), a title and an optional description.
public struct DSTimelineItem {
    public var label: Text?
    public var title: Text
    public var description: Text?

    public init(title: Text, label: Text? = nil, description: Text? = nil) {
        self.title = title
        self.label = label
        self.description = description
    }

    /// Localized strings from the app's catalog.
    public init(_ title: LocalizedStringKey, label: LocalizedStringKey? = nil, description: LocalizedStringKey? = nil) {
        self.init(title: Text(title), label: label.map { Text($0) }, description: description.map { Text($0) })
    }
}

/// Figma `Timeline`: an ordered list of moments on a vertical line (experience, milestones, release history).
/// Custom because SwiftUI has no timeline. Each item is one VoiceOver element; the markers and line are hidden.
/// Text uses the DS type styles, so it scales with Dynamic Type, and each marker stays centred on its first line.
public struct DSTimeline: View {
    public typealias Size = DSTimelineSize
    public typealias Fill = DSTimelineFill

    public var items: [DSTimelineItem]
    public var size: Size = .medium
    public var fill: Fill = .none

    public init(_ items: [DSTimelineItem], size: Size = .medium, fill: Fill = .none) {
        self.items = items
        self.size = size
        self.fill = fill
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: size == .large ? DSSpace.gapSection : DSSpacing.xl) {
            ForEach(items.indices, id: \.self) { index in
                DSTimelineRow(item: items[index], size: size)
            }
        }
        .background(alignment: .topLeading) {
            DSTimelineLine(fill: fill)
                .padding(.vertical, DSSpacing.sm)
                .padding(.leading, (DSSize.iconExtraSmall - DSBorderWidth.focus) / 2)
        }
    }
}

private struct DSTimelineRow: View {
    let item: DSTimelineItem
    let size: DSTimelineSize

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // The marker sits in a box one line of the first text tall, so it stays centred on that line at every
            // Dynamic Type size.
            ZStack(alignment: .leading) {
                Text(verbatim: "X").font(firstLineFont).hidden()
                DSTimelineMarker()
            }
            .frame(width: DSSpacing.xxl, alignment: .leading)
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                if let label = item.label {
                    label
                        .font(.ds(.caption1, .emphasized))
                        .foregroundStyle(DSColor.foregroundBrand)
                }
                item.title
                    .font(size == .large ? .ds(.title3, .emphasized) : .ds(.body1))
                    .foregroundStyle(DSColor.foregroundPrimary)
                if let description = item.description {
                    description
                        .font(.ds(size == .large ? .body1 : .body2))
                        .foregroundStyle(DSColor.foregroundSecondary)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    private var firstLineFont: Font {
        if item.label != nil { return .ds(.caption1, .emphasized) }
        return size == .large ? .ds(.title3, .emphasized) : .ds(.body1)
    }
}

/// The 12 pt ring (`size/icon/xs`): `background/primary` with a 2 pt `border/brand` ring. A circle in every brand.
private struct DSTimelineMarker: View {
    var body: some View {
        Circle()
            .fill(DSColor.backgroundPrimary)
            .overlay(Circle().strokeBorder(DSColor.borderBrand, lineWidth: DSBorderWidth.focus))
            .frame(width: DSSize.iconExtraSmall, height: DSSize.iconExtraSmall)
            .accessibilityHidden(true)
    }
}

/// A 2 pt line in `border/primary`, with the fill in `action/primary` drawn from the top.
private struct DSTimelineLine: View {
    let fill: DSTimelineFill
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let followsScroll = fill == .scroll && !reduceMotion
        Capsule()
            .fill(DSColor.borderPrimary)
            .overlay(alignment: .top) {
                if fill != .none {
                    Capsule()
                        .fill(DSColor.actionPrimary)
                        .visualEffect { content, proxy in
                            let frame = proxy.frame(in: .scrollView(axis: .vertical))
                            let visible = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? frame.height
                            let reached = (visible * 0.66 - frame.minY) / max(frame.height, 1)
                            return content.scaleEffect(x: 1, y: followsScroll ? min(max(reached, 0), 1) : 1, anchor: .top)
                        }
                }
            }
            .frame(width: DSBorderWidth.focus)
            .accessibilityHidden(true)
    }
}

#Preview("Timeline") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            DSTimeline([
                DSTimelineItem(title: Text(verbatim: "Lead designer"), label: Text(verbatim: "2026 to now"), description: Text(verbatim: "Example Co.")),
                DSTimelineItem(title: Text(verbatim: "Product designer"), label: Text(verbatim: "2024 to 2026"), description: Text(verbatim: "Another Co.")),
                DSTimelineItem(title: Text(verbatim: "Designer"), label: Text(verbatim: "2022 to 2024")),
            ], fill: .full)
            DSTimeline([
                DSTimelineItem(title: Text(verbatim: "Audit"), description: Text(verbatim: "Every screen and component, side by side.")),
                DSTimelineItem(title: Text(verbatim: "Tokens"), description: Text(verbatim: "One palette, three brands.")),
                DSTimelineItem(title: Text(verbatim: "Release"), description: Text(verbatim: "Web and iOS on the same day.")),
            ], size: .large, fill: .scroll)
        }
        .padding()
    }
}
