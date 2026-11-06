import SwiftUI

public extension View {
    /// Figma `Text Field (iOS)`: the native `TextField` in a `Form` or `List` row, styled with tokens.
    /// This is the default on iOS. Put helper and error text in the section footer.
    ///
    ///     Section {
    ///         TextField("Email", text: $email, prompt: Text("name@company.com")).dsTextField()
    ///     } footer: {
    ///         Text("Enter an email like name@company.com").dsTextFieldFooter(isError: true)
    ///     }
    ///
    /// The cursor uses the app tint (`action/primary`, set once with `.dsTheme(_:)`).
    /// Pass `isError: true` for the Figma Error state: the value in `foreground/error` and the row separator
    /// in `border/error`. Disabled wins over error. Show the message in the footer too, not by color alone.
    func dsTextField(isError: Bool = false) -> some View {
        modifier(DSTextFieldRowStyle(isError: isError))
    }
}

private struct DSTextFieldRowStyle: ViewModifier {
    let isError: Bool
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .font(.ds(.body1))
            .foregroundStyle(valueColor)
            .listRowSeparatorTint(isError ? DSColor.borderError.color(for: theme.mode(for: colorScheme)) : nil)
    }

    private var valueColor: DSColor {
        if !isEnabled { return .foregroundDisabled }
        return isError ? .foregroundError : .foregroundPrimary
    }
}

public extension Text {
    /// Section footer under a `.dsTextField()` row: Caption 1 in `foreground/secondary`, or `foreground/error`.
    func dsTextFieldFooter(isError: Bool = false) -> some View {
        let color = isError ? DSColor.foregroundError : DSColor.foregroundSecondary
        // Localized text auto-links emails and URLs; tint them like the rest of the footer.
        return font(.ds(.caption1))
            .foregroundStyle(color)
            .tint(color)
    }
}
