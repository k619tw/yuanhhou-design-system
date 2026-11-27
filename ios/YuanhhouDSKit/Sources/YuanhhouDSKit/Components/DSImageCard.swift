import SwiftUI

/// Image Card `Orientation`: Vertical = image on top, Horizontal = image leading.
public enum DSImageCardOrientation: String, CaseIterable, Identifiable {
    case vertical, horizontal
    public var id: String { rawValue }
    /// English name, stable across languages. Show ``label`` to people.
    public var title: String { rawValue.capitalized }
    /// Localized name from the package catalog.
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

/// Image Card `Style`: Elevated, Outlined and Filled are the Card styles (``DSCardStyle``); Plain has no container,
/// so the media takes the card corners and the text sits under it on the page.
public enum DSImageCardStyle: String, CaseIterable, Identifiable {
    case elevated, outlined, filled, plain
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

/// Image Card `Size`: Medium (Headline title, Body 2 description, 16 padding) or Large (Title 2 title, Body 1
/// description, 24 padding), for a feature card such as a case study.
public enum DSImageCardSize: String, CaseIterable, Identifiable {
    case medium, large
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
    public var label: Text { Text(LocalizedStringKey(title), bundle: .module) }
}

/// Figma `Image Card`: media, badges, title, description, then either actions or a link row.
///
/// - Actions: put real buttons in `actions`; the card itself is not a button.
/// - Link card: when the whole card opens something, give it a `link` (and an optional `note`, such as "Password
///   needed") and wrap it in one `Button` or `NavigationLink` with `.buttonStyle(.dsCard)`. The link row is display
///   only, and VoiceOver reads the card as one element.
public struct DSImageCard<Media: View, Actions: View>: View {
    public typealias Orientation = DSImageCardOrientation
    public typealias Style = DSImageCardStyle
    public typealias Size = DSImageCardSize

    public var orientation: Orientation = .vertical
    public var style: Style = .elevated
    public var size: Size = .medium
    /// Width over height of the media when vertical. 16:9 by default.
    public var mediaAspectRatio: CGFloat = 16 / 9
    public let title: LocalizedStringKey
    public var description: LocalizedStringKey?
    public var badges: [DSBadge] = []
    public var link: LocalizedStringKey?
    public var note: Text?
    @ViewBuilder public var media: Media
    @ViewBuilder public var actions: Actions

    @Environment(\.dsShape) private var corners

    public init(
        orientation: Orientation = .vertical,
        style: Style = .elevated,
        size: Size = .medium,
        mediaAspectRatio: CGFloat = 16 / 9,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        badge: DSBadge? = nil,
        badges: [DSBadge] = [],
        link: LocalizedStringKey? = nil,
        note: Text? = nil,
        @ViewBuilder media: () -> Media,
        @ViewBuilder actions: () -> Actions
    ) {
        self.orientation = orientation
        self.style = style
        self.size = size
        self.mediaAspectRatio = mediaAspectRatio
        self.title = title
        self.description = description
        self.badges = (badge.map { [$0] } ?? []) + badges
        self.link = link
        self.note = note
        self.media = media()
        self.actions = actions()
    }

    public var body: some View {
        let shape = DSCornerShape(radius: corners.card)
        Group {
            if orientation == .vertical {
                VStack(alignment: .leading, spacing: 0) {
                    mediaArea
                        .aspectRatio(mediaAspectRatio, contentMode: .fit)
                    content
                }
                // Always as tall as its content: a parent that offers less height must not narrow the media.
                .fixedSize(horizontal: false, vertical: true)
            } else {
                HStack(alignment: .top, spacing: 0) {
                    mediaArea.frame(width: 120)
                    content
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .modifier(ImageCardContainer(style: style, shape: shape))
        // A wrapping Button or NavigationLink highlights in the brand's corners.
        .contentShape(shape)
        .accessibilityElement(children: link == nil ? .contain : .combine)
    }

    private var mediaArea: some View {
        Rectangle()
            .fill(DSColor.backgroundSecondary)
            .frame(maxWidth: orientation == .vertical ? .infinity : nil, maxHeight: .infinity)
            .overlay { media }
            .clipShape(style == .plain ? AnyShape(DSCornerShape(radius: corners.card)) : AnyShape(Rectangle()))
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: size == .large ? DSSpacing.lg : DSSpacing.sm) {
            if !badges.isEmpty {
                DSFlowLayout(spacing: DSSpacing.sm) {
                    ForEach(badges.indices, id: \.self) { badges[$0] }
                }
            }
            VStack(alignment: .leading, spacing: size == .large ? DSSpacing.md : DSSpacing.sm) {
                Text(title)
                    .dsTextStyle(size == .large ? .title2 : .headline, .emphasized)
                    .foregroundStyle(DSColor.foregroundPrimary)
                if let description {
                    Text(description)
                        .font(.ds(size == .large ? .body1 : .body2))
                        .foregroundStyle(DSColor.foregroundSecondary)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            if let link {
                linkRow(link)
            } else {
                actions
            }
        }
        .padding(bodyPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func linkRow(_ link: LocalizedStringKey) -> some View {
        DSFlowLayout(spacing: DSSpacing.lg, lineSpacing: DSSpacing.sm) {
            HStack(spacing: DSSpacing.xs) {
                Text(link).font(.ds(.body2, .emphasized))
                DSUtilityIcon(.chevronRight, size: .small)
            }
            .foregroundStyle(DSColor.actionPrimary)
            if let note {
                note
                    .font(.ds(.caption1))
                    .foregroundStyle(DSColor.foregroundSecondary)
            }
        }
    }

    private var bodyPadding: EdgeInsets {
        let inset = size == .large ? DSSpacing.xl : DSSpacing.lg
        guard style == .plain else { return EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset) }
        // Plain: the text sits under (or beside) the media, with no other padding.
        return orientation == .vertical
            ? EdgeInsets(top: DSSpacing.lg, leading: 0, bottom: 0, trailing: 0)
            : EdgeInsets(top: 0, leading: DSSpacing.lg, bottom: 0, trailing: 0)
    }
}

public extension DSImageCard where Actions == EmptyView {
    /// Card without an actions row (Figma `Show actions` off), such as a link card.
    init(
        orientation: Orientation = .vertical,
        style: Style = .elevated,
        size: Size = .medium,
        mediaAspectRatio: CGFloat = 16 / 9,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        badge: DSBadge? = nil,
        badges: [DSBadge] = [],
        link: LocalizedStringKey? = nil,
        note: Text? = nil,
        @ViewBuilder media: () -> Media
    ) {
        self.init(
            orientation: orientation, style: style, size: size, mediaAspectRatio: mediaAspectRatio, title: title,
            description: description, badge: badge, badges: badges, link: link, note: note, media: media
        ) { EmptyView() }
    }
}

/// The card container per style; the same fills, hairline and shadow as ``DSCardStyle``.
private struct ImageCardContainer: ViewModifier {
    let style: DSImageCardStyle
    let shape: DSCornerShape

    func body(content: Content) -> some View {
        if style == .plain {
            content
        } else {
            content
                .background(style == .filled ? DSColor.backgroundSecondary : DSColor.backgroundPrimary)
                .clipShape(shape)
                .overlay {
                    if style != .filled {
                        shape.strokeBorder(DSColor.borderPrimary, lineWidth: DSBorderWidth.thin)
                    }
                }
                .background {
                    // Drawn behind the clipped card, so only the card casts the shadow.
                    if style == .elevated {
                        shape.fill(DSColor.backgroundPrimary)
                            .shadow(color: DSShadow.small.color, radius: DSShadow.small.radius, y: DSShadow.small.y)
                    }
                }
        }
    }
}

/// Lays its views out in rows and wraps to a new row when one is full (badges, the link row).
struct DSFlowLayout: Layout {
    var spacing: CGFloat = DSSpacing.sm
    var lineSpacing: CGFloat?

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(ProposedViewSize(width: width, height: nil))
            if x > 0, x + size.width > width {
                y += rowHeight + (lineSpacing ?? spacing)
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            widest = max(widest, x - spacing)
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: proposal.width ?? widest, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(ProposedViewSize(width: bounds.width, height: nil))
            if x > bounds.minX, x + size.width > bounds.maxX {
                y += rowHeight + (lineSpacing ?? spacing)
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview("Image Card, brands") {
    ScrollView {
        VStack(spacing: DSSpacing.lg) {
            ForEach(DSTheme.allCases) { theme in
                DSImageCard(title: "Card title", description: "Short supporting description.", badge: DSBadge("New")) {
                    Image(systemName: "photo").font(.largeTitle)
                } actions: {
                    Button("Read more") { }.buttonStyle(.ds(size: .small))
                }
                .dsTheme(theme)
            }
        }
        .padding()
    }
}

#Preview("Image Card, link card") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            ForEach(DSImageCardStyle.allCases) { style in
                Button { } label: {
                    DSImageCard(
                        style: style, size: .large, mediaAspectRatio: 4 / 3, title: "Case study title",
                        description: "One line on the problem and the outcome.",
                        badges: [DSBadge("Design system", size: .small), DSBadge("iOS", size: .small), DSBadge("Web", size: .small)],
                        link: "Read the case study", note: Text(verbatim: "Password needed")
                    ) {
                        Image(systemName: "photo").font(.largeTitle)
                    }
                }
                .buttonStyle(.dsCard)
            }
        }
        .padding()
    }
}
