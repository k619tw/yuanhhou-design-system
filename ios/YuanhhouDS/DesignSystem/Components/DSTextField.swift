import SwiftUI

/// Figma `Input`, built on the native `TextField` (keyboard, autofill, accessibility stay native).
///
///     DSTextField("Email", text: $email, prompt: "name@company.com",
///                 helper: "Use your work email", leadingIcon: .mail)
///
/// States: Focus comes from focus, Error from `errorMessage`, Disabled from `.disabled()`.
struct DSTextField: View {
    enum Size: String, CaseIterable, Identifiable {
        case medium, large
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
    }

    let label: LocalizedStringKey
    @Binding var text: String
    var prompt: LocalizedStringKey = ""
    var helper: LocalizedStringKey?
    /// Non-nil puts the field in the Error state and replaces the helper text.
    var errorMessage: LocalizedStringKey?
    var leadingIcon: DSIcon?
    var showsClearButton = false
    var size: Size = .medium

    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled

    init(
        _ label: LocalizedStringKey,
        text: Binding<String>,
        prompt: LocalizedStringKey = "",
        helper: LocalizedStringKey? = nil,
        errorMessage: LocalizedStringKey? = nil,
        leadingIcon: DSIcon? = nil,
        showsClearButton: Bool = false,
        size: Size = .medium
    ) {
        self.label = label
        self._text = text
        self.prompt = prompt
        self.helper = helper
        self.errorMessage = errorMessage
        self.leadingIcon = leadingIcon
        self.showsClearButton = showsClearButton
        self.size = size
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label)
                .font(.ds(.body2, .emphasized))
                .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                .accessibilityHidden(true)

            HStack(spacing: DSSpacing.sm) {
                if let leadingIcon {
                    DSUtilityIcon(leadingIcon, size: .medium)
                        .foregroundStyle(iconColor)
                }
                TextField(label, text: $text, prompt: Text(prompt).foregroundStyle(DSColor.foregroundSecondary))
                    .font(.ds(.body1))
                    .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                    .focused($isFocused)
                if showsClearButton, !text.isEmpty, isEnabled {
                    DSIconButton(.close, label: "Clear", kind: .tertiary, size: .small, expandsHitArea: false) {
                        text = ""
                        isFocused = true
                    }
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .frame(minHeight: size == .medium ? DSSize.controlMedium : DSSize.controlLarge)
            .background(shape.fill(isEnabled ? DSColor.backgroundPrimary : DSColor.backgroundSecondary))
            .overlay(shape.strokeBorder(borderColor, lineWidth: isFocused ? DSBorderWidth.focus : DSBorderWidth.regular))
            .contentShape(shape)
            .onTapGesture { isFocused = true }

            if let message = errorMessage ?? helper {
                Text(message)
                    .font(.ds(.caption1))
                    .foregroundStyle(messageColor)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityHint(errorMessage.map { Text($0) } ?? helper.map { Text($0) } ?? Text(verbatim: ""))
    }

    private var borderColor: DSColor {
        if !isEnabled { return .borderPrimary }
        if isFocused { return .borderFocus }
        if errorMessage != nil { return .borderError }
        return .borderTertiary
    }

    private var iconColor: DSColor {
        if !isEnabled { return .foregroundDisabled }
        if errorMessage != nil { return .foregroundError }
        return .foregroundSecondary
    }

    private var messageColor: DSColor {
        if !isEnabled { return .foregroundDisabled }
        return errorMessage != nil ? .foregroundError : .foregroundSecondary
    }
}
