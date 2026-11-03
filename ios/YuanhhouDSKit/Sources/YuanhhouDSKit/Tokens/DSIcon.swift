import SwiftUI

/// The 30 Utility Icons from Figma. Figma draws them with Material Symbols Rounded; on iOS the
/// HIG asks for SF Symbols, so each icon maps to the closest SF Symbol.
public nonisolated enum DSIcon: String, CaseIterable, Identifiable, Sendable {
    case home, search, menu, close, settings, person, favorite, star, add, remove
    case check, arrowBack = "arrow_back", arrowForward = "arrow_forward"
    case chevronLeft = "chevron_left", chevronRight = "chevron_right"
    case expandMore = "expand_more", expandLess = "expand_less"
    case moreHoriz = "more_horiz", moreVert = "more_vert"
    case delete, edit, share, info, warning, error, notifications, mail
    case calendarToday = "calendar_today", visibility, download

    public var id: String { rawValue }

    /// Figma / Material Symbols name, for example `expand_more`.
    public var materialName: String { rawValue }

    public var systemName: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .menu: "line.3.horizontal"
        case .close: "xmark"
        case .settings: "gearshape"
        case .person: "person"
        case .favorite: "heart"
        case .star: "star"
        case .add: "plus"
        case .remove: "minus"
        case .check: "checkmark"
        case .arrowBack: "arrow.left"
        case .arrowForward: "arrow.right"
        case .chevronLeft: "chevron.left"
        case .chevronRight: "chevron.right"
        case .expandMore: "chevron.down"
        case .expandLess: "chevron.up"
        case .moreHoriz: "ellipsis"
        case .moreVert: "ellipsis" // SF Symbols has no vertical ellipsis; rotated in `rotation`
        case .delete: "trash"
        case .edit: "pencil"
        case .share: "square.and.arrow.up"
        case .info: "info.circle"
        case .warning: "exclamationmark.triangle"
        case .error: "exclamationmark.circle"
        case .notifications: "bell"
        case .mail: "envelope"
        case .calendarToday: "calendar"
        case .visibility: "eye"
        case .download: "arrow.down.to.line"
        }
    }

    /// Extra rotation needed to match the Material glyph.
    public var rotation: Angle { self == .moreVert ? .degrees(90) : .zero }

    /// The SF Symbol image, rotated where needed.
    @MainActor public var image: some View {
        Image(systemName: systemName).rotationEffect(rotation)
    }
}

/// Utility Icon `Size` variant.
public nonisolated enum DSIconSize: Sendable {
    case small, medium, large

    public var points: CGFloat {
        switch self {
        case .small: DSSize.iconSmall
        case .medium: DSSize.iconMedium
        case .large: DSSize.iconLarge
        }
    }
}

/// Utility Icon: display only, hidden from VoiceOver. If the icon itself triggers an action,
/// use ``DSIconButton`` instead. Scales with Dynamic Type.
public struct DSUtilityIcon: View {
    public let icon: DSIcon
    public var size: DSIconSize = .medium

    @ScaledMetric private var scale: CGFloat = 1

    public init(_ icon: DSIcon, size: DSIconSize = .medium) {
        self.icon = icon
        self.size = size
    }

    public var body: some View {
        icon.image
            .font(.system(size: size.points * scale * 0.85, weight: .regular))
            .frame(width: size.points * scale, height: size.points * scale)
            .accessibilityHidden(true)
    }
}
