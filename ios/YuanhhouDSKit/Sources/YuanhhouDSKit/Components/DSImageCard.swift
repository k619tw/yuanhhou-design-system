import SwiftUI

/// Image Card `Orientation`: Vertical = image on top, Horizontal = image leading.
public enum DSImageCardOrientation: String, CaseIterable, Identifiable {
    case vertical, horizontal
    public var id: String { rawValue }
    public var title: String { rawValue.capitalized }
}

/// Figma `Image Card`: media, optional badge, title, description and optional actions.
/// The card itself is not a button; put real buttons in `actions`, or wrap the card in a
/// `NavigationLink` when the whole card navigates.
public struct DSImageCard<Media: View, Actions: View>: View {
    public typealias Orientation = DSImageCardOrientation

    public var orientation: Orientation = .vertical
    public let title: LocalizedStringKey
    public var description: LocalizedStringKey?
    public var badge: DSBadge?
    @ViewBuilder public var media: Media
    @ViewBuilder public var actions: Actions

    public init(
        orientation: Orientation = .vertical,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        badge: DSBadge? = nil,
        @ViewBuilder media: () -> Media,
        @ViewBuilder actions: () -> Actions
    ) {
        self.orientation = orientation
        self.title = title
        self.description = description
        self.badge = badge
        self.media = media()
        self.actions = actions()
    }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous)
        Group {
            if orientation == .vertical {
                VStack(alignment: .leading, spacing: 0) {
                    mediaArea.frame(height: 180)
                    content
                }
            } else {
                HStack(alignment: .top, spacing: 0) {
                    mediaArea.frame(width: 120)
                    content
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .background(DSColor.backgroundPrimary)
        .clipShape(shape)
        .overlay(shape.strokeBorder(DSColor.borderPrimary, lineWidth: DSBorderWidth.thin))
        .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
    }

    private var mediaArea: some View {
        ZStack {
            Rectangle().fill(DSColor.backgroundSecondary)
            media
        }
        .frame(maxWidth: orientation == .vertical ? .infinity : nil, maxHeight: .infinity)
        .clipped()
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            if let badge { badge }
            Text(title)
                .dsTextStyle(.headline, .emphasized)
                .foregroundStyle(DSColor.foregroundPrimary)
            if let description {
                Text(description)
                    .font(.ds(.body2))
                    .foregroundStyle(DSColor.foregroundSecondary)
            }
            actions
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public extension DSImageCard where Actions == EmptyView {
    /// Card without an actions row (Figma `Show actions` off).
    init(
        orientation: Orientation = .vertical,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        badge: DSBadge? = nil,
        @ViewBuilder media: () -> Media
    ) {
        self.init(orientation: orientation, title: title, description: description, badge: badge, media: media) { EmptyView() }
    }
}
