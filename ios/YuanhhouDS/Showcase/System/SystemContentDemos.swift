import SwiftUI
import YuanhhouDSKit

struct ListDemo: View {
    @State private var items = ["Inbox", "Drafts", "Sent", "Archive", "Junk"]

    var body: some View {
        List {
            HIGNote("Lists show rows of data. Swipe a row for actions, pull to refresh, and use Edit to reorder.")
            Section("Mailboxes") {
                ForEach(items, id: \.self) { item in
                    Label(LocalizedStringKey(item), systemImage: "tray")
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                items.removeAll { $0 == item }
                            }
                        }
                        .badge(item == "Inbox" ? 12 : 0)
                }
                .onMove { items.move(fromOffsets: $0, toOffset: $1) }
            }
        }
        .refreshable { try? await Task.sleep(for: .seconds(1)) }
        .toolbar { EditButton() }
        .navigationTitle("List")
    }
}

struct FormDemo: View {
    @State private var name = "Yuan"
    @State private var notifications = true
    @State private var frequency = "Daily"

    var body: some View {
        Form {
            HIGNote("Forms group related settings into sections with headers and footers, like the Settings app.")
            Section("Profile") {
                TextField("Name", text: $name)
                LabeledContent("Plan", value: "Pro")
            }
            Section {
                Toggle("Notifications", isOn: $notifications)
                Picker("Summary", selection: $frequency) {
                    ForEach(["Daily", "Weekly", "Never"], id: \.self) { Text(LocalizedStringKey($0)) }
                }
            } header: {
                Text("Notifications")
            } footer: {
                Text("Summaries arrive at 9:00 AM.")
            }
        }
        .navigationTitle("Form")
    }
}

struct DisclosureGroupDemo: View {
    @State private var expanded = true

    var body: some View {
        List {
            HIGNote("Disclosure groups hide and show related content. This is the iOS Accordion: use it as it is, there is no design-system style.")
            DisclosureGroup("Advanced options", isExpanded: $expanded) {
                Toggle("Use cellular data", isOn: .constant(true))
                Toggle("Low data mode", isOn: .constant(false))
            }
        }
        .navigationTitle("Disclosure group")
    }
}

struct LabelsDemo: View {
    private let symbols = ["star.fill", "heart.fill", "bell.badge", "cloud.sun.rain", "folder", "paperplane"]

    var body: some View {
        List {
            HIGNote("SF Symbols match the system font, scale with Dynamic Type and support rendering modes. Prefer them to custom icons.")
            ForEach(symbols, id: \.self) { name in
                Label(name, systemImage: name)
            }
            Section("Rendering modes") {
                HStack(spacing: 24) {
                    Image(systemName: "cloud.sun.rain.fill").symbolRenderingMode(.monochrome)
                    Image(systemName: "cloud.sun.rain.fill").symbolRenderingMode(.hierarchical)
                    Image(systemName: "cloud.sun.rain.fill").symbolRenderingMode(.multicolor)
                }
                .font(.largeTitle)
            }
        }
        .navigationTitle("Labels and SF Symbols")
    }
}

struct ContentUnavailableDemo: View {
    var body: some View {
        ContentUnavailableView {
            Label("No favorites", systemImage: "star")
        } description: {
            Text("Items you mark as favorite appear here.")
        } actions: {
            Button("Browse") {}.buttonStyle(.borderedProminent)
        }
        .navigationTitle("Content unavailable")
    }
}
