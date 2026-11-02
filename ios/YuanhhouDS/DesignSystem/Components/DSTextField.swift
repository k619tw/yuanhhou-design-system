import SwiftUI

extension View {
    /// Figma `Text Field (iOS)`: the native `TextField` in a `Form` or `List` row, styled with tokens.
    /// This is the default on iOS. Put helper and error text in the section footer.
    ///
    ///     Section {
    ///         TextField("Email", text: $email, prompt: Text("name@company.com")).dsTextField()
    ///     } footer: {
    ///         Text("Enter an email like name@company.com").dsTextFieldFooter(isError: true)
    ///     }
    ///
    /// The cursor uses the app tint (`action/primary`, set once with `.dsControlTint()`).
    func dsTextField() -> some View {
        modifier(DSTextFieldRowStyle())
    }
}

private struct DSTextFieldRowStyle: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    func body(content: Content) -> some View {
        content
            .font(.ds(.body1))
            .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
    }
}

extension Text {
    /// Section footer under a `.dsTextField()` row: Caption 1 in `foreground/secondary`, or `foreground/error`.
    func dsTextFieldFooter(isError: Bool = false) -> some View {
        let color = isError ? DSColor.foregroundError : DSColor.foregroundSecondary
        // Localized text auto-links emails and URLs; tint them like the rest of the footer.
        return font(.ds(.caption1))
            .foregroundStyle(color)
            .tint(color)
    }
}
