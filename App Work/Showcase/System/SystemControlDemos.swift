import SwiftUI

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
    var body: some View {
        List {
            HIGNote("Links open URLs in the right app; the share sheet lets people send content anywhere.")
            Link("Human Interface Guidelines", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines")!)
            ShareLink(item: URL(string: "https://developer.apple.com")!) {
                Label("Share a link", systemImage: "square.and.arrow.up")
            }
        }
        .navigationTitle("Link and share")
    }
}
