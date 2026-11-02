import SwiftUI

extension View {
    /// Tints native controls (Toggle, Slider, Picker, text cursor, disclosure group) with the design-system
    /// action color. iOS uses the native controls as they are; only the tint comes from the design system.
    func dsControlTint() -> some View {
        tint(DSColor.actionPrimary)
    }
}
