import SwiftUI

/// Catalog of the Figma design system (Platform = iOS). Theme and density are set on the Home screen
/// and apply app-wide.
struct DesignSystemCatalogView: View {
    var body: some View {
        List {
            Section("Foundations") {
                NavigationLink("Colors") { ColorsPage() }
                NavigationLink("Typography") { TypographyPage() }
                NavigationLink("Spacing and radius") { SpacingPage() }
                NavigationLink("Icons") { IconsPage() }
            }
            .dsListRowBackground()
            Section {
                NavigationLink("Button") { ButtonPage() }
                NavigationLink("Icon Button") { IconButtonPage() }
                NavigationLink("Badge") { BadgePage() }
                NavigationLink("Image Card") { ImageCardPage() }
                NavigationLink("Input") { InputPage() }
                NavigationLink("Toggle") { TogglePage() }
                NavigationLink("Checkbox") { CheckboxPage() }
                NavigationLink("Radio") { RadioPage() }
                NavigationLink("Accordion") { AccordionPage() }
            } header: {
                Text("Components")
            } footer: {
                Text("Components use the Figma Tokens library and the iOS typography (SF Pro, Dynamic Type). Change theme and density on the Home screen.")
            }
            .dsListRowBackground()
        }
        .dsListBackground()
        .navigationTitle("yuanhhou - DS")
    }
}

/// Scrolling page with the design-system surface color.
struct DSShowcasePage<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder var content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpace.gapSection) {
                content
            }
            .padding(DSSpace.pageMobile)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(DSColor.backgroundPrimary)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A titled group of examples on a showcase page.
struct DSShowcaseSection<Content: View>: View {
    let title: LocalizedStringKey
    var note: LocalizedStringKey?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpace.gapStack) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .dsTextStyle(.title3, .emphasized)
                    .foregroundStyle(DSColor.foregroundPrimary)
                if let note {
                    Text(note)
                        .font(.ds(.body2))
                        .foregroundStyle(DSColor.foregroundSecondary)
                }
            }
            content
        }
    }
}

#Preview {
    NavigationStack { DesignSystemCatalogView() }
}
