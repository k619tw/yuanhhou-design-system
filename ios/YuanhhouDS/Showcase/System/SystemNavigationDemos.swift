import SwiftUI

struct NavigationBarDemo: View {
    @State private var largeTitle = true

    var body: some View {
        List {
            HIGNote("The navigation bar shows the title and lets people go back. Use a large title at the top of a hierarchy and an inline title deeper in.")
            Toggle("Large title", isOn: $largeTitle)
            NavigationLink("Push a detail screen") {
                List { Text("Detail content") }
                    .navigationTitle("Detail")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle("Navigation bar")
        .navigationBarTitleDisplayMode(largeTitle ? .large : .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {}
            }
        }
    }
}

struct ToolbarDemo: View {
    var body: some View {
        List {
            HIGNote("Toolbars hold frequently used actions for the current screen. Use SF Symbols for common actions and keep to a few items.")
            Text("The bottom bar below is a toolbar with three actions.")
        }
        .navigationTitle("Toolbar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {}
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Share", systemImage: "square.and.arrow.up") {}
                Spacer()
                Button("Favorite", systemImage: "heart") {}
                Spacer()
                Button("Delete", systemImage: "trash", role: .destructive) {}
            }
        }
    }
}

struct TabBarDemo: View {
    @State private var showsExample = false

    var body: some View {
        List {
            HIGNote("A tab bar switches between top-level sections. Keep tabs to five or fewer and never use them for actions.")
            Button("Show a tab bar example") { showsExample = true }
        }
        .navigationTitle("Tab bar")
        .fullScreenCover(isPresented: $showsExample) {
            TabBarExample()
        }
    }
}

private struct TabBarExample: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView {
            tab("Home", systemImage: "house")
            tab("Search", systemImage: "magnifyingglass")
            tab("Profile", systemImage: "person")
                .badge(3)
        }
    }

    private func tab(_ title: LocalizedStringKey, systemImage: String) -> some TabContent<Never> {
        Tab(title, systemImage: systemImage) {
            NavigationStack {
                Text(title)
                    .navigationTitle(title)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { dismiss() }
                        }
                    }
            }
        }
    }
}

struct SearchDemo: View {
    @State private var query = ""
    @Environment(\.locale) private var locale

    /// Sample data is shown and searched in the current language.
    private var fruits: [String] {
        let english = ["Apple", "Apricot", "Banana", "Blueberry", "Cherry", "Grape", "Lemon", "Mango", "Orange", "Peach", "Pear", "Plum"]
        let japanese = ["りんご", "あんず", "バナナ", "ブルーベリー", "さくらんぼ", "ぶどう", "レモン", "マンゴー", "オレンジ", "もも", "なし", "すもも"]
        return locale.language.languageCode == .japanese ? japanese : english
    }

    private var results: [String] {
        query.isEmpty ? fruits : fruits.filter { $0.localizedStandardContains(query) }
    }

    var body: some View {
        List {
            ForEach(results, id: \.self) { Text($0) }
        }
        .overlay {
            if results.isEmpty { ContentUnavailableView.search(text: query) }
        }
        .searchable(text: $query, prompt: "Fruits")
        .navigationTitle("Search")
    }
}
