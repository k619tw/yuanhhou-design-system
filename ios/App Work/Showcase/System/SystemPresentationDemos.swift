import SwiftUI

struct AlertDemo: View {
    @State private var showsAlert = false
    @State private var result: LocalizedStringKey = "None"

    var body: some View {
        List {
            HIGNote("Alerts deliver important information that needs a decision. Use them sparingly, keep the title short, and mark destructive actions.")
            Button("Delete draft") { showsAlert = true }
            LabeledContent("Last choice") { Text(result) }
        }
        .navigationTitle("Alert")
        .alert("Delete draft?", isPresented: $showsAlert) {
            Button("Delete", role: .destructive) { result = "Deleted" }
            Button("Cancel", role: .cancel) { result = "Cancelled" }
        } message: {
            Text("This draft will be removed from all your devices.")
        }
    }
}

struct ConfirmationDialogDemo: View {
    @State private var showsDialog = false

    var body: some View {
        List {
            HIGNote("A confirmation dialog (action sheet) offers choices related to an action the person started, such as discarding changes.")
            Button("Discard changes") { showsDialog = true }
        }
        .navigationTitle("Confirmation dialog")
        .confirmationDialog("You have unsaved changes", isPresented: $showsDialog, titleVisibility: .visible) {
            Button("Discard changes", role: .destructive) {}
            Button("Save draft") {}
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct SheetDemo: View {
    @State private var showsSheet = false

    var body: some View {
        List {
            HIGNote("Sheets show a focused task that relates to the current context. Use detents so people can see the content underneath.")
            Button("Show sheet") { showsSheet = true }
        }
        .navigationTitle("Sheet")
        .sheet(isPresented: $showsSheet) {
            NavigationStack {
                List {
                    Text("Drag the grabber to switch between medium and large.")
                }
                .navigationTitle("New reminder")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showsSheet = false } }
                    ToolbarItem(placement: .confirmationAction) { Button("Add") { showsSheet = false } }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

struct FullScreenCoverDemo: View {
    @State private var showsCover = false

    var body: some View {
        List {
            HIGNote("A full-screen cover is for immersive or multi-step tasks, such as onboarding or capturing media. Always give a clear way out.")
            Button("Show full-screen cover") { showsCover = true }
        }
        .navigationTitle("Full-screen cover")
        .fullScreenCover(isPresented: $showsCover) {
            NavigationStack {
                ContentUnavailableView("Welcome", systemImage: "sparkles", description: Text("A full-screen, immersive step."))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) { Button("Done") { showsCover = false } }
                    }
            }
        }
    }
}

struct PopoverDemo: View {
    @State private var showsPopover = false

    var body: some View {
        List {
            HIGNote("Popovers show a small amount of related content. On iPhone they normally become sheets; here the compact popover is requested explicitly.")
            Button("Show popover") { showsPopover = true }
                .popover(isPresented: $showsPopover) {
                    Text("Popover content")
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
        }
        .navigationTitle("Popover")
    }
}

struct MenuDemo: View {
    @State private var sort = "Date"

    var body: some View {
        List {
            HIGNote("Menus reveal a list of actions or options from a button, saving space. Group related items and use SF Symbols.")
            Menu {
                Button("Duplicate", systemImage: "plus.square.on.square") {}
                Button("Rename", systemImage: "pencil") {}
                Divider()
                Button("Delete", systemImage: "trash", role: .destructive) {}
            } label: {
                Label("Actions", systemImage: "ellipsis.circle")
            }
            Picker("Sort by", selection: $sort) {
                ForEach(["Date", "Name", "Size"], id: \.self) { Text(LocalizedStringKey($0)) }
            }
            .pickerStyle(.menu)
        }
        .navigationTitle("Menu")
    }
}

struct ContextMenuDemo: View {
    var body: some View {
        List {
            HIGNote("Context menus give quick access to actions for an item. Touch and hold the rows below. Never put the only way to do something in a context menu.")
            ForEach(["Photo.jpg", "Notes.txt", "Report.pdf"], id: \.self) { file in
                Label(file, systemImage: "doc")
                    .contextMenu {
                        Button("Share", systemImage: "square.and.arrow.up") {}
                        Button("Rename", systemImage: "pencil") {}
                        Button("Delete", systemImage: "trash", role: .destructive) {}
                    }
            }
        }
        .navigationTitle("Context menu")
    }
}
