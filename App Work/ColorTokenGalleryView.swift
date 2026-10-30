import SwiftUI

/// Lists every color token (semantic and primitive) with a swatch.
/// Semantic swatches resolve against the environment's color scheme, so the light and dark
/// Figma designs are the same view rendered in each scheme.
struct ColorTokenGalleryView: View {
    private struct Swatch: Identifiable {
        let name: String
        let color: Color
        var id: String { name }
    }

    private struct Section: Identifiable {
        let title: String
        let swatches: [Swatch]
        var id: String { title }
    }

    private typealias T = ColorToken
    private typealias P = ColorPrimitive

    private static let statuses = ["Brand", "Info", "Success", "Warning", "Error", "Promote"]

    private static func backgroundSwatches() -> [Swatch] {
        let list: [Swatch] = [
            Swatch(name: "backgroundPrimary", color: T.Background.primary),
            Swatch(name: "backgroundSecondary", color: T.Background.secondary),
            Swatch(name: "backgroundInvertedPrimary", color: T.Background.invertedPrimary),
            Swatch(name: "backgroundInvertedSecondary", color: T.Background.invertedSecondary),
            Swatch(name: "backgroundDisabled", color: T.Background.disabled),
            Swatch(name: "backgroundPressedOverlay", color: T.Background.pressedOverlay),
        ]
        let status = [T.Background.brand, T.Background.info, T.Background.success,
                      T.Background.warning, T.Background.error, T.Background.promote]
        return list + zip(statuses, status).flatMap { name, s in
            [Swatch(name: "background\(name)Primary", color: s.primary),
             Swatch(name: "background\(name)Secondary", color: s.secondary),
             Swatch(name: "background\(name)PrimaryPressed", color: s.primaryPressed),
             Swatch(name: "background\(name)SecondaryPressed", color: s.secondaryPressed)]
        }
    }

    private static func foregroundSwatches() -> [Swatch] {
        let list: [Swatch] = [
            Swatch(name: "foregroundHero", color: T.Foreground.hero),
            Swatch(name: "foregroundPrimary", color: T.Foreground.primary),
            Swatch(name: "foregroundSecondary", color: T.Foreground.secondary),
            Swatch(name: "foregroundInvertedPrimary", color: T.Foreground.invertedPrimary),
            Swatch(name: "foregroundInvertedSecondary", color: T.Foreground.invertedSecondary),
            Swatch(name: "foregroundDisabled", color: T.Foreground.disabled),
            Swatch(name: "foregroundOnDisabled", color: T.Foreground.onDisabled),
            Swatch(name: "foregroundBupaFixed", color: T.Foreground.bupaFixed),
            Swatch(name: "foregroundBluaFixed", color: T.Foreground.bluaFixed),
        ]
        let status = [T.Foreground.brand, T.Foreground.info, T.Foreground.success,
                      T.Foreground.warning, T.Foreground.error, T.Foreground.promote]
        return list + zip(statuses, status).flatMap { name, s in
            [Swatch(name: "foreground\(name)", color: s.base),
             Swatch(name: "foreground\(name)OnPrimary", color: s.onPrimary),
             Swatch(name: "foreground\(name)OnSecondary", color: s.onSecondary)]
        }
    }

    private static func borderSwatches() -> [Swatch] {
        let list: [Swatch] = [
            Swatch(name: "borderPrimary", color: T.Border.primary),
            Swatch(name: "borderSecondary", color: T.Border.secondary),
            Swatch(name: "borderTertiary", color: T.Border.tertiary),
            Swatch(name: "borderInverted", color: T.Border.inverted),
        ]
        let status = [T.Border.brand, T.Border.info, T.Border.success,
                      T.Border.warning, T.Border.error, T.Border.promote]
        return list + zip(statuses, status).flatMap { name, s in
            [Swatch(name: "border\(name)", color: s.base),
             Swatch(name: "border\(name)Pressed", color: s.pressed)]
        }
    }

    private static func primitiveSection(_ title: String, _ swatches: [(String, Color)]) -> Section {
        Section(title: "Primitives — \(title)", swatches: swatches.map { Swatch(name: $0.0, color: $0.1) })
    }

    private let sections: [Section] = [
        Section(title: "Colour roles — Background", swatches: Self.backgroundSwatches()),
        Section(title: "Colour roles — Foreground", swatches: Self.foregroundSwatches()),
        Section(title: "Colour roles — Border", swatches: Self.borderSwatches()),
        Section(title: "Colour roles — Action & AI", swatches: [
            Swatch(name: "actionPrimary", color: T.Action.primary),
            Swatch(name: "actionSecondary", color: T.Action.secondary),
            Swatch(name: "aiGradientStart", color: T.AI.gradientStart),
            Swatch(name: "aiGradientEnd", color: T.AI.gradientEnd),
        ]),
        Self.primitiveSection("Blue", [
            ("blue100", P.blue100), ("blue200", P.blue200), ("blue300", P.blue300), ("blue400", P.blue400),
            ("blue500", P.blue500), ("blue550", P.blue550), ("blue600", P.blue600), ("blue700", P.blue700),
            ("blue800", P.blue800), ("blue900", P.blue900), ("bluaBrand", P.bluaBrand)]),
        Self.primitiveSection("Neutral", [
            ("neutral100", P.neutral100), ("neutral200", P.neutral200), ("neutral300", P.neutral300),
            ("neutral400", P.neutral400), ("neutral500", P.neutral500), ("neutral550", P.neutral550),
            ("neutral600", P.neutral600), ("neutral700", P.neutral700), ("neutral800", P.neutral800),
            ("neutral900", P.neutral900)]),
        Self.primitiveSection("Green", [
            ("green100", P.green100), ("green200", P.green200), ("green300", P.green300), ("green400", P.green400),
            ("green500", P.green500), ("green550", P.green550), ("green600", P.green600), ("green700", P.green700),
            ("green800", P.green800), ("green900", P.green900)]),
        Self.primitiveSection("Red", [
            ("red100", P.red100), ("red200", P.red200), ("red300", P.red300), ("red400", P.red400),
            ("red500", P.red500), ("red550", P.red550), ("red600", P.red600), ("red700", P.red700),
            ("red800", P.red800), ("red900", P.red900)]),
        Self.primitiveSection("Purple", [
            ("purple100", P.purple100), ("purple200", P.purple200), ("purple300", P.purple300),
            ("purple400", P.purple400), ("purple500", P.purple500), ("purple550", P.purple550),
            ("purple600", P.purple600), ("purple700", P.purple700), ("purple800", P.purple800),
            ("purple900", P.purple900)]),
        Self.primitiveSection("Orange", [
            ("orange100", P.orange100), ("orange200", P.orange200), ("orange300", P.orange300),
            ("orange400", P.orange400), ("orange500", P.orange500), ("orange550", P.orange550),
            ("orange600", P.orange600), ("orange700", P.orange700), ("orange800", P.orange800),
            ("orange900", P.orange900)]),
        Self.primitiveSection("Alpha white", [
            ("alphaWhite10", P.alphaWhite10), ("alphaWhite20", P.alphaWhite20), ("alphaWhite30", P.alphaWhite30),
            ("alphaWhite40", P.alphaWhite40), ("alphaWhite50", P.alphaWhite50), ("alphaWhite60", P.alphaWhite60),
            ("alphaWhite70", P.alphaWhite70), ("alphaWhite80", P.alphaWhite80), ("alphaWhite90", P.alphaWhite90)]),
        Self.primitiveSection("Alpha black", [
            ("alphaBlack10", P.alphaBlack10), ("alphaBlack20", P.alphaBlack20), ("alphaBlack30", P.alphaBlack30),
            ("alphaBlack40", P.alphaBlack40), ("alphaBlack50", P.alphaBlack50), ("alphaBlack60", P.alphaBlack60),
            ("alphaBlack70", P.alphaBlack70), ("alphaBlack80", P.alphaBlack80), ("alphaBlack90", P.alphaBlack90)]),
        Self.primitiveSection("Alpha brand", [
            ("alphaBrand10", P.alphaBrand10), ("alphaBrand20", P.alphaBrand20), ("alphaBrand30", P.alphaBrand30),
            ("alphaBrand40", P.alphaBrand40), ("alphaBrand50", P.alphaBrand50), ("alphaBrand60", P.alphaBrand60),
            ("alphaBrand70", P.alphaBrand70), ("alphaBrand80", P.alphaBrand80), ("alphaBrand90", P.alphaBrand90)]),
    ]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 32) {
                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(section.title)
                            .font(.title3.bold())
                            .foregroundStyle(ColorToken.Foreground.hero)
                            .padding(.bottom, 8)

                        ForEach(section.swatches) { swatch in
                            HStack(spacing: 16) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(swatch.color)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(ColorToken.Border.primary, lineWidth: 1))
                                Text(swatch.name)
                                    .font(.subheadline)
                                    .foregroundStyle(ColorToken.Foreground.primary)
                            }
                            .padding(.vertical, 6)
                            Divider().overlay(ColorToken.Border.primary)
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(ColorToken.Background.primary)
    }
}

#Preview("Light") {
    ColorTokenGalleryView().preferredColorScheme(.light)
}

#Preview("Dark") {
    ColorTokenGalleryView().preferredColorScheme(.dark)
}
