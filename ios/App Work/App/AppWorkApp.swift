import SwiftUI

@main
struct AppWorkApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

private enum HomeRoute: String, Hashable {
    case system, designSystem = "ds"
}

/// Home screen: one row for Apple's own components, one for the design system built on top of
/// them, and the app-wide settings (language, theme, density).
struct RootView: View {
    @AppStorage("app.language") private var language: AppLanguage = .system
    @AppStorage("ds.theme") private var theme: DSTheme = .system
    @AppStorage("ds.density") private var density: DSDensity = .system
    @State private var path: [HomeRoute] = []
    /// The device's own settings. RootView sits above the overrides applied below, so these are not affected by them.
    @Environment(\.dynamicTypeSize) private var deviceTextSize
    @Environment(\.locale) private var deviceLocale

    /// "System" is the choice that follows the device, so say what the device currently gives.
    /// The size name is a `Text`, so it is translated with the in-app language like the rest of the row.
    private var systemDensityLabel: LocalizedStringKey {
        let size: Text
        switch deviceTextSize {
        case .xSmall: size = Text("Extra small")
        case .small: size = Text("Small")
        case .medium: size = Text("Medium")
        case .large: size = Text("Large")
        case .xLarge: size = Text("Extra large")
        case .xxLarge: size = Text("Extra extra large")
        case .xxxLarge: size = Text("Extra extra extra large")
        default: size = Text("Accessibility")
        }
        return "System (\(size))"
    }

    private var systemLanguageLabel: LocalizedStringKey {
        let name = deviceLocale.language.languageCode?.identifier == "ja" ? "日本語" : "English"
        return "System (\(name))"
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    NavigationLink(value: HomeRoute.system) {
                        HomeRow(title: "iOS System", subtitle: "Apple's built-in components", systemImage: "iphone")
                    }
                    NavigationLink(value: HomeRoute.designSystem) {
                        HomeRow(title: "yuanhhou - DS", subtitle: "Design system components and tokens", systemImage: "paintpalette")
                    }
                }
                .dsListRowBackground()

                Section {
                    Picker(selection: $language) {
                        ForEach(AppLanguage.allCases) { Text($0 == .system ? systemLanguageLabel : $0.displayName).tag($0) }
                    } label: {
                        Label("Language", systemImage: "globe")
                    }
                    Picker(selection: $theme) {
                        ForEach(DSTheme.allCases) { Text(LocalizedStringKey($0.title)).tag($0) }
                    } label: {
                        Label("Theme", systemImage: "paintbrush")
                    }
                    Picker(selection: $density) {
                        ForEach(DSDensity.allCases) { Text($0 == .system ? systemDensityLabel : LocalizedStringKey($0.title)).tag($0) }
                    } label: {
                        Label("Density", systemImage: "textformat.size")
                    }
                } header: {
                    Text("Settings")
                } footer: {
                    Text("Theme and density apply to the whole app. System follows your device (appearance, text size or language); the other options override it. Language can also be set in Settings > App Work > Language.")
                }
                .dsListRowBackground()
            }
            .dsListBackground()
            .navigationTitle("Home")
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .system: SystemCatalogView()
                case .designSystem: DesignSystemCatalogView()
                }
            }
        }
        // Navigation bar titles and list rows are drawn by UIKit and do not re-resolve when only the locale
        // or the `dsTheme` environment value changes, so rebuild the stack on a language or theme switch
        // (it returns to Home, where the pickers are).
        .id("\(language.rawValue)-\(theme.rawValue)")
        .appLanguage(language)
        .environment(\.dsTheme, theme)
        // Setting the window's color scheme (not just the content's) keeps the navigation bar,
        // title and native controls in step with the theme.
        .preferredColorScheme(theme.colorScheme)
        .dsDensity(density)
        .dsControlTint()
        #if DEBUG
        .onAppear(perform: openDebugStartRoute)
        #endif
    }

    #if DEBUG
    /// Debug builds only: launch with `-startRoute ds` or `-startRoute system` to open that screen
    /// directly (used to check screens from the command line).
    private func openDebugStartRoute() {
        if let raw = UserDefaults.standard.string(forKey: "startRoute"), let route = HomeRoute(rawValue: raw) {
            path = [route]
        }
    }
    #endif
}

private struct HomeRow: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let systemImage: String

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(DSColor.foregroundPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(DSColor.foregroundSecondary)
            }
        } icon: {
            Image(systemName: systemImage)
                .foregroundStyle(DSColor.foregroundBrand)
        }
        .padding(.vertical, 4)
    }
}

extension View {
    /// List container in `background/secondary`, like iOS grouped lists, using the current theme.
    func dsListBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(DSColor.backgroundSecondary)
    }

    /// Rows in `background/primary`. Apply to each `Section` of a themed list.
    func dsListRowBackground() -> some View {
        listRowBackground(Rectangle().fill(DSColor.backgroundPrimary))
    }
}

#Preview {
    RootView()
}
