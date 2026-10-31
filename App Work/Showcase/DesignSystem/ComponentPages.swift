import SwiftUI

struct ButtonPage: View {
    var body: some View {
        DSShowcasePage(title: "Button") {
            ForEach(DSButtonStyle.Size.allCases) { size in
                DSShowcaseSection(title: LocalizedStringKey(size.title), note: size == .large ? "Height comes from padding: 12 + line height + 12." : "Fixed 36pt height.") {
                    ForEach(DSButtonStyle.Kind.allCases) { kind in
                        HStack(spacing: DSSpacing.md) {
                            Button(LocalizedStringKey(kind.title)) {}
                                .buttonStyle(.ds(kind, size: size))
                            Button(LocalizedStringKey(kind.title)) {}
                                .buttonStyle(.ds(kind, size: size))
                                .disabled(true)
                        }
                    }
                }
            }
            DSShowcaseSection(title: "With icons", note: "Icons inside a button are display only.") {
                Button {} label: { Label("Add item", systemImage: DSIcon.add.systemName) }
                    .buttonStyle(.ds(.primary))
                Button {} label: { DSButtonLabel("Continue", trailing: .chevronRight) }
                    .buttonStyle(.ds(.secondary))
            }
        }
    }
}

struct IconButtonPage: View {
    var body: some View {
        DSShowcasePage(title: "Icon Button") {
            ForEach(DSIconButton.Size.allCases) { size in
                DSShowcaseSection(title: LocalizedStringKey(size.title), note: size == .small ? "32pt visual size, padded to a 44pt hit target." : "48pt.") {
                    HStack(spacing: DSSpacing.sm) {
                        ForEach(DSButtonStyle.Kind.allCases) { kind in
                            DSIconButton(.add, label: "Add", kind: kind, size: size) {}
                        }
                        DSIconButton(.add, label: "Add", kind: .primary, size: size) {}
                            .disabled(true)
                    }
                }
            }
            DSShowcaseSection(title: "Common icons") {
                HStack(spacing: DSSpacing.sm) {
                    DSIconButton(.close, label: "Close", kind: .tertiary) {}
                    DSIconButton(.moreHoriz, label: "More", kind: .tertiary) {}
                    DSIconButton(.share, label: "Share", kind: .secondary) {}
                    DSIconButton(.delete, label: "Delete", kind: .alert) {}
                }
            }
        }
    }
}

struct BadgePage: View {
    var body: some View {
        DSShowcasePage(title: "Badge") {
            ForEach(DSBadge.Style.allCases) { style in
                DSShowcaseSection(title: LocalizedStringKey(style.title)) {
                    ForEach(DSBadge.BadgeType.allCases) { type in
                        HStack(spacing: DSSpacing.sm) {
                            DSBadge(LocalizedStringKey(type.title), type: type, style: style, size: .medium)
                            DSBadge(LocalizedStringKey(type.title), type: type, style: style, size: .small)
                            DSBadge(LocalizedStringKey(type.title), type: type, style: style, size: .medium, icon: .star)
                        }
                    }
                }
            }
        }
    }
}

struct ImageCardPage: View {
    var body: some View {
        DSShowcasePage(title: "Image Card") {
            ForEach(DSImageCardOrientation.allCases) { orientation in
                DSShowcaseSection(title: LocalizedStringKey(orientation.title)) {
                    DSImageCard(
                        orientation: orientation,
                        title: "Card title",
                        description: "Short supporting description that explains the card content in a line or two.",
                        badge: DSBadge("New", type: .brand, style: .subtle, size: .small)
                    ) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(DSColor.foregroundSecondary)
                            .accessibilityHidden(true)
                    } actions: {
                        Button("Read more") {}
                            .buttonStyle(.ds(.primary, size: .small))
                    }
                }
            }
        }
    }
}

struct InputPage: View {
    @State private var name = ""
    @State private var email = "name@company"
    @State private var search = "Sydney"

    var body: some View {
        DSShowcasePage(title: "Input") {
            DSShowcaseSection(title: "States", note: "Built on the native TextField. Tap a field to see Focus.") {
                DSTextField("Name", text: $name, prompt: "Your full name", helper: "As it appears on your ID")
                DSTextField("Email", text: $email, prompt: "name@company.com",
                            errorMessage: "Enter an email like name@company.com", leadingIcon: .mail, size: .large)
                DSTextField("Search", text: $search, prompt: "City", leadingIcon: .search, showsClearButton: true)
                DSTextField("Disabled", text: .constant("Not editable"), helper: "Locked by your admin")
                    .disabled(true)
            }
        }
    }
}

struct TogglePage: View {
    @State private var on = true
    @State private var off = false

    var body: some View {
        DSShowcasePage(title: "Toggle") {
            DSShowcaseSection(title: "System switch", note: "On iOS the Figma Toggle is the native switch, tinted with action/primary. Do not redraw it.") {
                Toggle("Email notifications", isOn: $on)
                Toggle("Auto-renew", isOn: $off)
                Toggle("Disabled", isOn: .constant(true)).disabled(true)
            }
            .font(.ds(.body1))
            .foregroundStyle(DSColor.foregroundPrimary)
        }
    }
}

struct AccordionPage: View {
    @State private var first = true
    @State private var second = false

    var body: some View {
        DSShowcasePage(title: "Accordion") {
            DSShowcaseSection(title: "Group", note: "A native DisclosureGroup with the design-system style.") {
                VStack(spacing: 0) {
                    DisclosureGroup("Shipping and returns", isExpanded: $first) {
                        Text("Free returns within 30 days. Items must be unused and in their original packaging.")
                    }
                    DisclosureGroup("Payment options", isExpanded: $second) {
                        Text("Pay with card, Apple Pay or bank transfer.")
                    }
                    DisclosureGroup("Gift cards") {
                        Text("Unavailable for this order.")
                    }
                    .disabled(true)
                }
                .disclosureGroupStyle(.dsAccordion)
            }
        }
    }
}
