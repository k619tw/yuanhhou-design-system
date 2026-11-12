import SwiftUI
import YuanhhouDSKit

struct ColorsPage: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private var groups: [(String, [DSColor])] {
        let prefixes = ["background", "foreground", "border", "action", "ai"]
        return prefixes.map { prefix in
            (prefix.capitalized, DSColor.all.filter { $0.name.hasPrefix("color/\(prefix)/") })
        }
    }

    var body: some View {
        let mode = theme.mode(for: colorScheme)
        DSShowcasePage(title: "Colors") {
            Text("Mode: \(mode.rawValue). Values come from the Tokens library, collection 02 Semantics.")
                .font(.ds(.body2))
                .foregroundStyle(DSColor.foregroundSecondary)
            ForEach(groups, id: \.0) { group in
                DSShowcaseSection(title: LocalizedStringKey(group.0)) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: DSSpacing.md)], spacing: DSSpacing.md) {
                        ForEach(group.1) { token in
                            ColorSwatch(token: token, hex: token.hex(for: mode))
                        }
                    }
                }
            }
        }
    }
}

private struct ColorSwatch: View {
    let token: DSColor
    let hex: String

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            RoundedRectangle(cornerRadius: DSRadius.sm, style: .continuous)
                .fill(token)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.sm, style: .continuous)
                        .strokeBorder(DSColor.borderPrimary, lineWidth: DSBorderWidth.thin)
                )
            Text(token.name.replacingOccurrences(of: "color/", with: ""))
                .font(.ds(.caption1, .emphasized))
                .foregroundStyle(DSColor.foregroundPrimary)
            Text("#\(hex)")
                .font(.ds(.caption2).monospaced())
                .foregroundStyle(DSColor.foregroundSecondary)
        }
        .accessibilityElement(children: .combine)
    }
}

struct TypographyPage: View {
    var body: some View {
        DSShowcasePage(title: "Typography") {
            Text("SF Pro with Dynamic Type. Sizes below are at the default size (Large); the Density menu previews Compact (Medium) and Loose (xLarge).")
                .font(.ds(.body2))
                .foregroundStyle(DSColor.foregroundSecondary)
            ForEach(DSTextStyle.allCases) { style in
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(verbatim: "\(style.figmaName) · .\(String(describing: style.appleTextStyle)) · \(style.defaultMetrics.size)/\(style.defaultMetrics.lineHeight)")
                        .font(.ds(.caption1))
                        .foregroundStyle(DSColor.foregroundSecondary)
                    Text("Regular: The quick brown fox")
                        .font(.ds(style, .regular))
                    Text("Emphasized: The quick brown fox")
                        .font(.ds(style, .emphasized))
                }
                .foregroundStyle(DSColor.foregroundPrimary)
            }
        }
    }
}

struct SpacingPage: View {
    private let spacing: [(String, CGFloat)] = [
        ("2xs", DSSpacing.xxs), ("xs", DSSpacing.xs), ("sm", DSSpacing.sm), ("md", DSSpacing.md),
        ("lg", DSSpacing.lg), ("xl", DSSpacing.xl), ("2xl", DSSpacing.xxl), ("3xl", DSSpacing.xxxl),
    ]
    /// The semantic radii follow the brand, so they change with the Theme picker on Home.
    @Environment(\.dsShape) private var shape
    private var radii: [(String, CGFloat)] {
        [("control", shape.control), ("card", shape.card), ("dialog", shape.dialog), ("sheet", shape.sheet), ("pill", shape.pill)]
    }

    var body: some View {
        DSShowcasePage(title: "Spacing and radius") {
            DSShowcaseSection(title: "Spacing") {
                ForEach(spacing, id: \.0) { name, value in
                    HStack(spacing: DSSpacing.md) {
                        Text(verbatim: "\(name) · \(Int(value))")
                            .font(.ds(.body2))
                            .foregroundStyle(DSColor.foregroundPrimary)
                            .frame(width: 80, alignment: .leading)
                        Rectangle().fill(DSColor.backgroundBrandPrimary).frame(width: value, height: 16)
                    }
                }
            }
            DSShowcaseSection(title: "Radius") {
                Text("Corners follow the brand: Default is round, EVA is sharp, Heritage Luxury is soft.")
                    .font(.ds(.body2))
                    .foregroundStyle(DSColor.foregroundSecondary)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: DSSpacing.md) {
                    ForEach(radii, id: \.0) { name, value in
                        VStack(spacing: DSSpacing.xs) {
                            DSCornerShape(radius: value)
                                .fill(DSColor.backgroundBrandSecondary)
                                .overlay(DSCornerShape(radius: value).strokeBorder(DSColor.borderBrand))
                                .frame(height: 72)
                            Text(verbatim: "\(name) · \(Int(value))")
                                .font(.ds(.caption1))
                                .foregroundStyle(DSColor.foregroundSecondary)
                        }
                    }
                }
            }
        }
    }
}

struct IconsPage: View {
    var body: some View {
        DSShowcasePage(title: "Icons") {
            Text("Utility Icons are display only. Figma uses Material Symbols Rounded; iOS uses the matching SF Symbol.")
                .font(.ds(.body2))
                .foregroundStyle(DSColor.foregroundSecondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: DSSpacing.md)], spacing: DSSpacing.lg) {
                ForEach(DSIcon.allCases) { icon in
                    VStack(spacing: DSSpacing.xs) {
                        DSUtilityIcon(icon, size: .large)
                            .foregroundStyle(DSColor.foregroundPrimary)
                        Text(icon.materialName)
                            .font(.ds(.caption1, .emphasized))
                            .foregroundStyle(DSColor.foregroundPrimary)
                        Text(icon.systemName)
                            .font(.ds(.caption2))
                            .foregroundStyle(DSColor.foregroundSecondary)
                    }
                    .multilineTextAlignment(.center)
                }
            }
        }
    }
}
