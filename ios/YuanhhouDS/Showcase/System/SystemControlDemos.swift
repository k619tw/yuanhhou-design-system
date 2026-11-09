import SwiftUI
import YuanhhouDSKit

struct ButtonsDemo: View {
    var body: some View {
        List {
            HIGNote("System button styles adapt to Dynamic Type, accessibility settings and the platform. Use a prominent style for the one most likely action.")
            Section("Styles") {
                Button("Glass prominent") {}.buttonStyle(.glassProminent)
                Button("Glass") {}.buttonStyle(.glass)
                Button("Bordered prominent") {}.buttonStyle(.borderedProminent)
                Button("Bordered") {}.buttonStyle(.bordered)
                Button("Borderless") {}.buttonStyle(.borderless)
            }
            Section("Roles and sizes") {
                Button("Delete", role: .destructive) {}.buttonStyle(.bordered)
                Button("Large control") {}.buttonStyle(.borderedProminent).controlSize(.large)
                Button("Small control") {}.buttonStyle(.bordered).controlSize(.small)
                Button("Disabled") {}.buttonStyle(.borderedProminent).disabled(true)
            }
        }
        .navigationTitle("Buttons")
    }
}

struct ToggleDemo: View {
    @State private var wifi = true
    @State private var bluetooth = false

    var body: some View {
        List {
            HIGNote("A toggle switches a setting on or off and takes effect immediately.")
            Toggle("Wi-Fi", systemImage: "wifi", isOn: $wifi)
            Toggle("Bluetooth", systemImage: "antenna.radiowaves.left.and.right", isOn: $bluetooth)
            Toggle("Disabled", isOn: .constant(true)).disabled(true)
        }
        .navigationTitle("Toggle")
    }
}

struct SliderStepperDemo: View {
    @State private var volume = 0.5
    @State private var quantity = 1

    var body: some View {
        List {
            HIGNote("Sliders pick a value from a continuous range; steppers change a value in small, exact steps.")
            Slider(value: $volume) {
                Text("Volume")
            } minimumValueLabel: {
                Image(systemName: "speaker")
            } maximumValueLabel: {
                Image(systemName: "speaker.wave.3")
            }
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
        }
        .navigationTitle("Slider and stepper")
    }
}

struct PickerDemo: View {
    @State private var segment = "Day"
    @State private var flavor = "Vanilla"
    @State private var size = "Medium"

    var body: some View {
        List {
            HIGNote("Pickers choose one value from a list. Use segmented for 2–5 options that switch a view, menu for compact forms, wheel for long ranges.")
            Picker("View", selection: $segment) {
                ForEach(["Day", "Week", "Month"], id: \.self) { Text(LocalizedStringKey($0)) }
            }
            .pickerStyle(.segmented)
            Picker("Flavor", selection: $flavor) {
                ForEach(["Vanilla", "Chocolate", "Strawberry"], id: \.self) { Text(LocalizedStringKey($0)) }
            }
            Picker("Size", selection: $size) {
                ForEach(["Small", "Medium", "Large"], id: \.self) { Text(LocalizedStringKey($0)) }
            }
            .pickerStyle(.wheel)
        }
        .navigationTitle("Picker")
    }
}

struct DatePickerDemo: View {
    @State private var date = Date()

    var body: some View {
        List {
            HIGNote("Date pickers let people choose dates and times. The compact style fits forms; graphical shows a full calendar.")
            DatePicker("Start", selection: $date)
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
        .navigationTitle("Date picker")
    }
}

struct ColorPickerDemo: View {
    @State private var color = Color.blue

    var body: some View {
        List {
            HIGNote("The system color picker includes a grid, spectrum, sliders and an eyedropper.")
            ColorPicker("Tag color", selection: $color)
            RoundedRectangle(cornerRadius: 12).fill(color).frame(height: 60)
        }
        .navigationTitle("Color picker")
    }
}

struct TextInputDemo: View {
    @State private var name = ""
    @State private var password = ""
    @State private var notes = ""

    var body: some View {
        Form {
            HIGNote("Use the right keyboard and content type so autofill and suggestions work.")
            TextField("Name", text: $name)
                .textContentType(.name)
            SecureField("Password", text: $password)
                .textContentType(.password)
            Section("Notes") {
                TextEditor(text: $notes).frame(minHeight: 100)
            }
        }
        .navigationTitle("Text input")
    }
}

struct ProgressDemo: View {
    var body: some View {
        List {
            HIGNote("Show determinate progress when you know how long a task takes; use the spinner only for short, unknown waits.")
            ProgressView(value: 0.6) { Text("Uploading") }
            ProgressView("Loading")
            Gauge(value: 72, in: 0...100) {
                Text("Battery")
            } currentValueLabel: {
                Text("72%")
            }
            Gauge(value: 0.4) { Image(systemName: "thermometer.medium") }
                .gaugeStyle(.accessoryCircular)
        }
        .navigationTitle("Progress and gauge")
    }
}

struct LinkShareDemo: View {
    private static let typographyURL = URL(string: "https://developer.apple.com/design/human-interface-guidelines/typography")!

    var body: some View {
        List {
            HIGNote("Links open URLs in the right app; the share sheet lets people send content anywhere.")
            Link("Human Interface Guidelines", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines")!)
            ShareLink(item: URL(string: "https://developer.apple.com")!) {
                Label("Share a link", systemImage: "square.and.arrow.up")
            }

            Section {
                ForEach(DSLinkSize.allCases) { size in
                    VStack(alignment: .leading, spacing: DSSpace.gapTight) {
                        Text(verbatim: "\(size.textStyle.figmaName) · .dsLink(.\(size.rawValue))")
                            .font(.ds(.caption1))
                            .foregroundStyle(DSColor.foregroundSecondary)
                        Link("Read the typography guidelines", destination: Self.typographyURL)
                            .dsLink(size)
                            .frame(minHeight: DSSize.minimumHitTarget)
                    }
                }
                Text("Read **[the typography guidelines](https://developer.apple.com/design/human-interface-guidelines/typography)** before you choose a text style.")
                    .font(.ds(.body1))
                    .foregroundStyle(DSColor.foregroundPrimary)
                    .dsLink(.body1)
            } header: {
                Text("Design system link")
            } footer: {
                Text("Native Link with .dsLink: the Emphasized text style in action/primary, no underline. A link on its own line gets a 44 pt hit area.")
            }
            // Links pass 4.5:1 on background/primary in every mode (not on background/secondary in Dark).
            .dsListRowBackground()
        }
        .navigationTitle("Link and share")
    }
}

/// How selection works in SwiftUI. There is no checkbox or radio control: the platform patterns are a
/// switch for a setting, a `Picker` for one-of-many, and a checkmark row (or `List(selection:)`) for many.
struct SelectionDemo: View {
    private enum Speed: String, CaseIterable, Identifiable {
        case standard = "Standard", express = "Express", pickup = "Store pickup"
        var id: Self { self }
    }

    @State private var autoRenew = true
    @State private var speed: Speed = .standard
    @State private var menuSpeed: Speed = .express
    @State private var segment: Speed = .standard
    @State private var toppings: Set<String> = ["Cheese"]
    private let allToppings = ["Cheese", "Mushroom", "Olives", "Basil"]

    var body: some View {
        List {
            HIGNote("SwiftUI has no checkbox or radio control. Use a switch for a setting that applies at once, a Picker to choose one option, and a list with checkmarks to choose several. Selection is always a binding: a single value for one, a Set for many.")

            Section {
                Toggle("Auto-renew", isOn: $autoRenew)
            } header: {
                Text("One setting: Toggle")
            } footer: {
                Text("Bound to a Bool. Takes effect immediately.")
            }

            Section {
                Picker("Delivery speed", selection: $speed) {
                    ForEach(Speed.allCases) { Text(LocalizedStringKey($0.rawValue)).tag($0) }
                }
                .pickerStyle(.inline)
            } header: {
                Text("One of many: inline Picker")
            } footer: {
                Text("The radio-group equivalent: every option is visible and the selected row shows a checkmark. Bound to a single value; tag each option with that value.")
            }

            Section {
                Picker("Delivery speed", selection: $menuSpeed) {
                    ForEach(Speed.allCases) { Text(LocalizedStringKey($0.rawValue)).tag($0) }
                }
                Picker("Delivery speed", selection: $segment) {
                    ForEach(Speed.allCases.prefix(2)) { Text(LocalizedStringKey($0.rawValue)).tag($0) }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("One of many: menu and segmented")
            } footer: {
                Text("Menu keeps a form compact; segmented switches between 2 to 5 short options.")
            }

            Section {
                ForEach(allToppings, id: \.self) { topping in
                    Button {
                        if toppings.contains(topping) { toppings.remove(topping) } else { toppings.insert(topping) }
                    } label: {
                        HStack {
                            Text(LocalizedStringKey(topping)).foregroundStyle(.primary)
                            Spacer()
                            if toppings.contains(topping) {
                                Image(systemName: "checkmark").foregroundStyle(.tint)
                            }
                        }
                    }
                    .accessibilityAddTraits(toppings.contains(topping) ? .isSelected : [])
                }
            } header: {
                Text("Many: checkmark rows")
            } footer: {
                Text("The checkbox equivalent. Bound to a Set; tapping a row adds or removes the value, and VoiceOver reads the Selected trait.")
            }

            Section {
                NavigationLink("Select several rows") { ListSelectionDemo() }
            } header: {
                Text("Many: List(selection:)")
            } footer: {
                Text("A list in edit mode shows the system selection circles. Use it for bulk actions such as delete or move, not for form answers.")
            }
        }
        .navigationTitle("Selection")
    }
}

struct ListSelectionDemo: View {
    @State private var selection: Set<String> = ["Mushroom"]
    private let items = ["Cheese", "Mushroom", "Olives", "Basil"]

    var body: some View {
        List(items, id: \.self, selection: $selection) { item in
            Text(LocalizedStringKey(item))
        }
        .environment(\.editMode, .constant(.active))
        .navigationTitle("List selection")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text("\(selection.count) selected")
            }
        }
    }
}
