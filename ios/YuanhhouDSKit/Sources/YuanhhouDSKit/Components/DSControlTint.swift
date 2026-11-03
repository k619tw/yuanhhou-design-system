import SwiftUI
import UIKit

public extension View {
    /// Tints native controls (Toggle, Slider, Picker, text cursor, disclosure group) with the design-system
    /// action color. iOS uses the native controls as they are; only the tint comes from the design system.
    /// Apply it inside `.environment(\.dsTheme, …)` so it sees the theme.
    func dsControlTint() -> some View {
        modifier(DSControlTintModifier())
    }
}

/// `action/primary` for the current theme as a dynamic color that holds both its Light and Dark values.
/// UIKit-backed controls (the value of a menu `Picker` in a list row) keep the tint they were created with and
/// ignore a new SwiftUI tint when the device switches between Light and Dark; a dynamic color is re-resolved
/// by UIKit itself on that switch, like the system colors. A theme switch rebuilds the screens (see `RootView`).
private struct DSControlTintModifier: ViewModifier {
    @Environment(\.dsTheme) private var theme

    func body(content: Content) -> some View {
        let light = UIColor(DSColor.actionPrimary.color(for: theme.mode(for: .light)))
        let dark = UIColor(DSColor.actionPrimary.color(for: theme.mode(for: .dark)))
        content.tint(Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? dark : light }))
    }
}
