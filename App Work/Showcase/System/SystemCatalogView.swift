import SwiftUI

/// Catalog of native iOS components. Everything here is stock SwiftUI: when the design system needs
/// one of these patterns, use the system component rather than rebuilding it.
struct SystemCatalogView: View {
    var body: some View {
        List {
            Section {
                NavigationLink("Navigation bar") { NavigationBarDemo() }
                NavigationLink("Toolbar") { ToolbarDemo() }
                NavigationLink("Tab bar") { TabBarDemo() }
                NavigationLink("Search") { SearchDemo() }
            } header: {
                Text("Navigation")
            }
            .dsListRowBackground()

            Section {
                NavigationLink("Alert") { AlertDemo() }
                NavigationLink("Confirmation dialog") { ConfirmationDialogDemo() }
                NavigationLink("Sheet") { SheetDemo() }
                NavigationLink("Full-screen cover") { FullScreenCoverDemo() }
                NavigationLink("Popover") { PopoverDemo() }
                NavigationLink("Menu") { MenuDemo() }
                NavigationLink("Context menu") { ContextMenuDemo() }
            } header: {
                Text("Presentation")
            }
            .dsListRowBackground()

            Section {
                NavigationLink("Buttons") { ButtonsDemo() }
                NavigationLink("Toggle") { ToggleDemo() }
                NavigationLink("Slider and stepper") { SliderStepperDemo() }
                NavigationLink("Picker") { PickerDemo() }
                NavigationLink("Selection") { SelectionDemo() }
                NavigationLink("Date picker") { DatePickerDemo() }
                NavigationLink("Color picker") { ColorPickerDemo() }
                NavigationLink("Text input") { TextInputDemo() }
                NavigationLink("Progress and gauge") { ProgressDemo() }
                NavigationLink("Link and share") { LinkShareDemo() }
            } header: {
                Text("Controls")
            }
            .dsListRowBackground()

            Section {
                NavigationLink("List") { ListDemo() }
                NavigationLink("Form") { FormDemo() }
                NavigationLink("Disclosure group") { DisclosureGroupDemo() }
                NavigationLink("Labels and SF Symbols") { LabelsDemo() }
                NavigationLink("Content unavailable") { ContentUnavailableDemo() }
            } header: {
                Text("Content")
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("iOS System")
    }
}

/// Explanation row shown at the top of each system demo: what it is and when the HIG says to use it.
struct HIGNote: View {
    let text: LocalizedStringKey

    init(_ text: LocalizedStringKey) {
        self.text = text
    }

    var body: some View {
        Section {
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack { SystemCatalogView() }
}
