import SwiftUI
import YuanhhouDSKit

struct ButtonPage: View {
    var body: some View {
        DSShowcasePage(title: "Button") {
            ForEach(DSButtonStyle.Size.allCases) { size in
                DSShowcaseSection(title: LocalizedStringKey(size.title), note: size == .large ? "Height comes from padding: 12 + line height + 12." : "Height comes from padding: 8 + line height + 8.") {
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
                    ForEach(DSBadge.Kind.allCases) { type in
                        HStack(spacing: DSSpacing.sm) {
                            DSBadge(LocalizedStringKey(type.title), kind: type, style: style, size: .medium)
                            DSBadge(LocalizedStringKey(type.title), kind: type, style: style, size: .small)
                            DSBadge(LocalizedStringKey(type.title), kind: type, style: style, size: .medium, icon: .star)
                        }
                    }
                }
            }
        }
    }
}

struct CardPage: View {
    var body: some View {
        DSShowcasePage(title: "Card") {
            DSShowcaseSection(title: "Styles", note: "Filled, Outlined and Elevated, as in Material 3. Corners come from the brand (radius/card).") {
                ForEach(DSCardStyle.allCases) { style in
                    sample(LocalizedStringKey(style.title)).dsCard(style)
                }
            }
            DSShowcaseSection(title: "Padding") {
                ForEach(DSCardPadding.allCases) { padding in
                    sample(LocalizedStringKey(padding.title)).dsCard(.outlined, padding: padding)
                }
            }
            DSShowcaseSection(title: "On a secondary surface") {
                VStack(spacing: DSSpacing.lg) {
                    ForEach(DSCardStyle.allCases) { style in
                        sample(LocalizedStringKey(style.title)).dsCard(style, on: .secondary)
                    }
                }
                .padding(DSSpacing.lg)
                .background(DSColor.backgroundSecondary)
            }
            DSShowcaseSection(title: "Link card", note: "The whole card is one button. Keep the text short: VoiceOver reads all of it.") {
                Button {} label: {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("A card that is one link")
                            .font(.ds(.headline, .emphasized))
                            .foregroundStyle(DSColor.foregroundPrimary)
                        Text("Any content goes in a card: text, a demo or a list.")
                            .font(.ds(.body2))
                            .foregroundStyle(DSColor.foregroundSecondary)
                    }
                    .dsCard(.outlined)
                }
                .buttonStyle(.dsCard)
            }
        }
    }

    private func sample(_ title: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title)
                .font(.ds(.headline, .emphasized))
                .foregroundStyle(DSColor.foregroundPrimary)
            Text("Any content goes in a card: text, a demo or a list.")
                .font(.ds(.body2))
                .foregroundStyle(DSColor.foregroundSecondary)
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
                        badge: DSBadge("New", kind: .brand, style: .subtle, size: .small)
                    ) {
                        placeholder
                    } actions: {
                        Button("Read more") {}
                            .buttonStyle(.ds(.primary, size: .small))
                    }
                }
            }
            DSShowcaseSection(title: "Styles", note: "Elevated, Outlined and Filled are the Card styles. Plain has no container: the media takes the card corners.") {
                ForEach(DSImageCardStyle.allCases) { style in
                    DSImageCard(
                        style: style,
                        title: LocalizedStringKey(style.title),
                        description: "Short supporting description that explains the card content in a line or two."
                    ) {
                        placeholder
                    }
                }
            }
            DSShowcaseSection(title: "Large", note: "Title 2 and Body 1, for a feature card such as a case study.") {
                DSImageCard(
                    size: .large,
                    title: "Card title",
                    description: "Short supporting description that explains the card content in a line or two."
                ) {
                    placeholder
                }
            }
            DSShowcaseSection(title: "Link card", note: "The whole card is one button. Keep the text short: VoiceOver reads all of it.") {
                Button {} label: {
                    DSImageCard(
                        style: .plain,
                        size: .large,
                        mediaAspectRatio: 4 / 3,
                        title: "A card that is one link",
                        description: "Short supporting description that explains the card content in a line or two.",
                        badges: [
                            DSBadge("Design system", size: .small),
                            DSBadge("iOS", size: .small),
                            DSBadge("Web", size: .small),
                        ],
                        link: "Read the case study",
                        note: Text("\(Image(systemName: DSIcon.lock.systemName)) Password needed")
                    ) {
                        placeholder
                    }
                }
                .buttonStyle(.dsCard)
            }
        }
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.largeTitle)
            .foregroundStyle(DSColor.foregroundSecondary)
            .accessibilityHidden(true)
    }
}

struct InputPage: View {
    @State private var name = ""
    @State private var password = ""
    @State private var email = "name@company"

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name, prompt: Text("Your full name")).dsTextField()
                SecureField("Password", text: $password, prompt: Text("Password")).dsTextField()
            } header: {
                Text("Input (iOS)")
            } footer: {
                Text("As it appears on your ID").dsTextFieldFooter()
            }
            .dsListRowBackground()

            Section {
                TextField("Email", text: $email, prompt: Text("name@company.com"))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .dsTextField(isError: true)
            } footer: {
                Text("Enter an email like name@company.com").dsTextFieldFooter(isError: true)
            }
            .dsListRowBackground()

            Section {
                TextField("Disabled", text: .constant("Not editable")).dsTextField().disabled(true)
            } footer: {
                Text("Locked by your admin").dsTextFieldFooter()
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("Input")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TimelinePage: View {
    var body: some View {
        DSShowcasePage(title: "Timeline") {
            DSShowcaseSection(title: "Medium: milestones") {
                DSTimeline([
                    DSTimelineItem("Kick-off and research", label: "Jan 2026"),
                    DSTimelineItem("First release to a small group", label: "Mar 2026"),
                    DSTimelineItem("Released to everyone", label: "Jun 2026"),
                ])
            }
            DSShowcaseSection(title: "Large: experience") {
                DSTimeline([
                    DSTimelineItem("Senior Designer", description: "Company A · 2024 to present"),
                    DSTimelineItem("Designer", description: "Company B · 2021 to 2024"),
                    DSTimelineItem("Junior Designer", description: "Company C · 2019 to 2021"),
                ], size: .large)
            }
            DSShowcaseSection(title: "Fill that follows scroll", note: "The line fills as you scroll. With Reduce Motion it is full.") {
                DSTimeline([
                    DSTimelineItem("Kick-off and research", label: "Jan 2026"),
                    DSTimelineItem("First release to a small group", label: "Mar 2026"),
                    DSTimelineItem("Released to everyone", label: "Jun 2026"),
                ], fill: .scroll)
            }
        }
    }
}

struct TogglePage: View {
    @State private var on = true
    @State private var off = false

    var body: some View {
        Form {
            Section {
                Group {
                    Toggle("Email notifications", isOn: $on)
                    Toggle("Auto-renew", isOn: $off)
                    Toggle("Disabled", isOn: .constant(true)).disabled(true)
                }
                .font(.ds(.body1))
                .foregroundStyle(DSColor.foregroundPrimary)
            } header: {
                Text("Toggle (iOS)")
            } footer: {
                Text("The native switch, tinted with action/primary. Do not redraw it.").dsTextFieldFooter()
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("Toggle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccordionPage: View {
    @State private var shipping = true
    @State private var payment = false

    var body: some View {
        Form {
            Section {
                DisclosureGroup("Shipping and returns", isExpanded: $shipping) {
                    Text("Free returns within 30 days. Items must be unused and in their original packaging.")
                }
                DisclosureGroup("Payment options", isExpanded: $payment) {
                    Text("Pay with card, Apple Pay or bank transfer.")
                }
                DisclosureGroup("Gift cards") {
                    Text("Unavailable for this order.")
                }
                .disabled(true)
            } header: {
                Text("Accordion (iOS)")
            } footer: {
                Text("The native DisclosureGroup with text content in a Form section. The design-system style only colors the chevron.").dsTextFieldFooter()
            }
            .disclosureGroupStyle(.dsAccordion)
            .dsListRowBackground()
        }
        // One-line content would otherwise be padded to the 44 pt minimum row height.
        .dsAccordionList()
        .dsListBackground()
        .navigationTitle("Accordion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckboxPage: View {
    private enum Channel: String, CaseIterable, Hashable { case email = "Email", sms = "Text message", push = "Push" }

    @State private var agreed = false
    @State private var channels: Set<Channel> = [.email]

    var body: some View {
        Form {
            Section {
                Toggle("I agree to the terms", isOn: $agreed)
                    .font(.ds(.body1))
                    .foregroundStyle(DSColor.foregroundPrimary)
            } header: {
                Text("One choice: Toggle (iOS)")
            } footer: {
                Text("iOS has no checkbox. A single yes or no is the system switch.").dsTextFieldFooter()
            }
            .dsListRowBackground()

            Section {
                ForEach(Channel.allCases, id: \.self) { channel in
                    Button {
                        if channels.contains(channel) { channels.remove(channel) } else { channels.insert(channel) }
                    } label: {
                        HStack {
                            Text(LocalizedStringKey(channel.rawValue))
                                .font(.ds(.body1))
                                .foregroundStyle(DSColor.foregroundPrimary)
                            Spacer()
                            if channels.contains(channel) {
                                Image(systemName: "checkmark")
                                    .font(.ds(.body1, .emphasized))
                                    .foregroundStyle(DSColor.actionPrimary)
                            }
                        }
                    }
                    .accessibilityAddTraits(channels.contains(channel) ? .isSelected : [])
                }
            } header: {
                Text("Several choices: checkmark rows")
            } footer: {
                Text("Choose any that apply").dsTextFieldFooter()
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("Checkbox")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RadioPage: View {
    private enum Speed: String, CaseIterable, Hashable { case standard = "Standard", express = "Express", pickup = "Store pickup" }

    @State private var speed: Speed = .standard
    @State private var menuSpeed: Speed = .express

    var body: some View {
        Form {
            Section {
                Picker("Delivery speed", selection: $speed) {
                    ForEach(Speed.allCases, id: \.self) { Text(LocalizedStringKey($0.rawValue)).tag($0) }
                }
                .pickerStyle(.inline)
                .labelsHidden()
                .font(.ds(.body1))
            } header: {
                Text("One of many: Picker (inline)")
            } footer: {
                Text("iOS has no radio button. The inline Picker shows every option with a checkmark on the selected one.").dsTextFieldFooter()
            }
            .dsListRowBackground()

            Section {
                Picker("Delivery speed", selection: $menuSpeed) {
                    ForEach(Speed.allCases, id: \.self) { Text(LocalizedStringKey($0.rawValue)).tag($0) }
                }
                .font(.ds(.body1))
            } header: {
                Text("Compact: Picker (menu)")
            } footer: {
                Text("Choose one").dsTextFieldFooter()
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("Radio")
        .navigationBarTitleDisplayMode(.inline)
    }
}
