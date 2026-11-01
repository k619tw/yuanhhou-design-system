import SwiftUI

nonisolated extension EnvironmentValues {
    /// Error state for DS selection controls (red outline). Set with `.dsInvalid()`.
    @Entry var dsInvalid: Bool = false
    /// Mixed ("indeterminate") state for `.dsCheckbox` toggles. Set with `.dsMixed()`.
    @Entry var dsMixed: Bool = false
}

extension View {
    func dsInvalid(_ invalid: Bool = true) -> some View { environment(\.dsInvalid, invalid) }
    /// Shows a dash instead of the checkmark: some, but not all, children are selected.
    func dsMixed(_ mixed: Bool = true) -> some View { environment(\.dsMixed, mixed) }
}

/// Figma `Checkbox` as a style for the native `Toggle`:
///
///     Toggle("Email", isOn: $email).toggleStyle(.dsCheckbox)
///
/// iOS has no checkbox control (the HIG uses switches and checkmark rows), so this is the design-system
/// look for the cases where a form needs one. The whole row is one button.
struct DSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        DSCheckboxBody(configuration: configuration)
    }
}

private struct DSCheckboxBody: View {
    let configuration: ToggleStyle.Configuration

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsInvalid) private var invalid
    @Environment(\.dsMixed) private var mixed

    private var filled: Bool { configuration.isOn || mixed }

    private var boxFill: DSColor {
        guard filled else { return DSColor.backgroundPrimary }
        return isEnabled ? DSColor.actionPrimary : DSColor.backgroundDisabled
    }

    private var boxStroke: DSColor {
        if filled { return isEnabled ? DSColor.actionPrimary : DSColor.backgroundDisabled }
        if !isEnabled { return DSColor.borderPrimary }
        return invalid ? DSColor.borderError : DSColor.borderTertiary
    }

    var body: some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                RoundedRectangle(cornerRadius: DSSpacing.xs)
                    .fill(boxFill)
                    .overlay(RoundedRectangle(cornerRadius: DSSpacing.xs).strokeBorder(boxStroke, lineWidth: DSBorderWidth.regular))
                    .overlay {
                        if filled {
                            // Drawn on action/primary (lime in EVA): the surface color, never white.
                            Image(systemName: mixed && !configuration.isOn ? "minus" : "checkmark")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(DSColor.backgroundPrimary)
                        }
                    }
                    .frame(width: DSSize.iconLarge, height: DSSize.iconLarge)
                    .accessibilityHidden(true)
                configuration.label
                    .font(.ds(.body1))
                    .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minHeight: DSSize.minimumHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(mixed ? Text("Mixed") : (configuration.isOn ? Text("Checked") : Text("Unchecked")))
    }
}

extension ToggleStyle where Self == DSCheckboxToggleStyle {
    static var dsCheckbox: DSCheckboxToggleStyle { DSCheckboxToggleStyle() }
}

/// One option of a `DSRadioGroup` or `DSCheckboxGroup`.
struct DSChoice<Value: Hashable>: Identifiable {
    let value: Value
    let title: LocalizedStringKey
    var isDisabled = false

    var id: Value { value }

    init(_ title: LocalizedStringKey, value: Value, isDisabled: Bool = false) {
        self.title = title
        self.value = value
        self.isDisabled = isDisabled
    }
}

/// Figma `Radio Group`: pick exactly one option.
///
///     DSRadioGroup("Delivery speed", selection: $speed, options: [
///         DSChoice("Standard", value: Speed.standard),
///         DSChoice("Express", value: Speed.express),
///     ])
///
/// SwiftUI's own pattern for this is `Picker` with `.pickerStyle(.inline)` (or `.menu` when space is tight),
/// which is what you should reach for first. `PickerStyle` cannot be customised, so the design-system
/// version is a separate view with the same selection binding. Use it only when the Figma look is needed.
struct DSRadioGroup<Value: Hashable>: View {
    let title: LocalizedStringKey
    @Binding var selection: Value
    let options: [DSChoice<Value>]
    var helper: LocalizedStringKey?
    var errorMessage: LocalizedStringKey?

    @Environment(\.isEnabled) private var isEnabled

    init(_ title: LocalizedStringKey, selection: Binding<Value>, options: [DSChoice<Value>],
         helper: LocalizedStringKey? = nil, errorMessage: LocalizedStringKey? = nil) {
        self.title = title
        self._selection = selection
        self.options = options
        self.helper = helper
        self.errorMessage = errorMessage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title)
                .font(.ds(.body2, .emphasized))
                .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                .accessibilityAddTraits(.isHeader)
            ForEach(options) { option in
                DSRadioRow(option: option, isSelected: selection == option.value, invalid: errorMessage != nil) {
                    selection = option.value
                }
            }
            if let errorMessage {
                Text(errorMessage).font(.ds(.caption1)).foregroundStyle(DSColor.foregroundError)
            } else if let helper {
                Text(helper).font(.ds(.caption1)).foregroundStyle(DSColor.foregroundSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }
}

private struct DSRadioRow<Value: Hashable>: View {
    let option: DSChoice<Value>
    let isSelected: Bool
    let invalid: Bool
    let action: () -> Void

    @Environment(\.isEnabled) private var groupEnabled

    private var enabled: Bool { groupEnabled && !option.isDisabled }

    private var ring: DSColor {
        if isSelected { return enabled ? DSColor.actionPrimary : DSColor.backgroundDisabled }
        if !enabled { return DSColor.borderPrimary }
        return invalid ? DSColor.borderError : DSColor.borderTertiary
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.sm) {
                Circle()
                    .fill(DSColor.backgroundPrimary)
                    .overlay(Circle().strokeBorder(ring, lineWidth: DSBorderWidth.regular))
                    .overlay {
                        if isSelected {
                            Circle()
                                .fill(enabled ? DSColor.actionPrimary : DSColor.backgroundDisabled)
                                .frame(width: DSSize.iconSmall, height: DSSize.iconSmall)
                        }
                    }
                    .frame(width: DSSize.iconLarge, height: DSSize.iconLarge)
                    .accessibilityHidden(true)
                Text(option.title)
                    .font(.ds(.body1))
                    .foregroundStyle(enabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minHeight: DSSize.minimumHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// Figma `Checkbox Group`: pick any number of options. Selection is a `Set`.
struct DSCheckboxGroup<Value: Hashable>: View {
    let title: LocalizedStringKey
    @Binding var selection: Set<Value>
    let options: [DSChoice<Value>]
    var helper: LocalizedStringKey?
    var errorMessage: LocalizedStringKey?

    @Environment(\.isEnabled) private var isEnabled

    init(_ title: LocalizedStringKey, selection: Binding<Set<Value>>, options: [DSChoice<Value>],
         helper: LocalizedStringKey? = nil, errorMessage: LocalizedStringKey? = nil) {
        self.title = title
        self._selection = selection
        self.options = options
        self.helper = helper
        self.errorMessage = errorMessage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title)
                .font(.ds(.body2, .emphasized))
                .foregroundStyle(isEnabled ? DSColor.foregroundPrimary : DSColor.foregroundDisabled)
                .accessibilityAddTraits(.isHeader)
            ForEach(options) { option in
                Toggle(isOn: Binding(
                    get: { selection.contains(option.value) },
                    set: { on in
                        if on { selection.insert(option.value) } else { selection.remove(option.value) }
                    }
                )) {
                    Text(option.title)
                }
                .toggleStyle(.dsCheckbox)
                .disabled(option.isDisabled)
            }
            if let errorMessage {
                Text(errorMessage).font(.ds(.caption1)).foregroundStyle(DSColor.foregroundError)
            } else if let helper {
                Text(helper).font(.ds(.caption1)).foregroundStyle(DSColor.foregroundSecondary)
            }
        }
        .dsInvalid(errorMessage != nil)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }
}
