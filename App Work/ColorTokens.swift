import SwiftUI

/// Layer 2: semantic color tokens from the Figma "Light - 2.5" and "Dark - 2.5" sections.
/// Each token resolves to its light or dark primitive based on the current appearance.
/// Prefer these over `ColorPrimitive` in UI code.
enum ColorToken {
    private typealias P = ColorPrimitive

    /// Shorthand for an appearance-adaptive token.
    private static func adaptive(_ light: Color, _ dark: Color) -> Color {
        Color(light: light, dark: dark)
    }

    // MARK: - Background

    enum Background {
        static let primary = adaptive(P.neutral100, P.neutral900)
        static let secondary = adaptive(P.neutral200, P.neutral800)
        static let invertedPrimary = adaptive(P.neutral900, P.neutral100)
        static let invertedSecondary = adaptive(P.blue800, P.neutral200)
        static let disabled = adaptive(P.neutral400, P.neutral500)
        static let pressedOverlay = adaptive(P.alphaBlack10, P.alphaWhite20)

        /// Primary/secondary fills for a status, plus their pressed states.
        struct Status {
            let primary: Color
            let secondary: Color
            let primaryPressed: Color
            let secondaryPressed: Color
        }

        // Status backgrounds are identical in light and dark.
        static let brand = Status(
            primary: P.blue500, secondary: P.blue100, primaryPressed: P.blue800, secondaryPressed: P.blue200)
        static let info = Status(
            primary: P.blue500, secondary: P.blue100, primaryPressed: P.blue800, secondaryPressed: P.blue200)
        static let success = Status(
            primary: P.green500, secondary: P.green100, primaryPressed: P.green600, secondaryPressed: P.green300)
        static let warning = Status(
            primary: P.orange300, secondary: P.orange100, primaryPressed: P.orange400, secondaryPressed: P.orange300)
        static let error = Status(
            primary: P.red500, secondary: P.red100, primaryPressed: P.red600, secondaryPressed: P.red300)
        static let promote = Status(
            primary: P.purple500, secondary: P.purple100, primaryPressed: P.purple600, secondaryPressed: P.purple200)
    }

    // MARK: - Foreground

    enum Foreground {
        static let hero = adaptive(P.blue800, P.neutral100)
        static let primary = adaptive(P.neutral900, P.neutral100)
        static let secondary = adaptive(P.neutral500, P.neutral400)
        static let invertedPrimary = adaptive(P.neutral100, P.neutral900)
        static let invertedSecondary = adaptive(P.neutral400, P.neutral700)
        static let disabled = adaptive(P.neutral400, P.neutral500)
        static let onDisabled = adaptive(P.neutral500, P.neutral600)
        static let bupaFixed = P.blue500
        static let bluaFixed = P.bluaBrand

        /// Text/icon color for a status, plus the colors used on its primary/secondary fills.
        struct Status {
            let base: Color
            let onPrimary: Color
            let onSecondary: Color
        }

        static let brand = Status(
            base: adaptive(P.blue550, P.blue300),
            onPrimary: P.neutral100,
            onSecondary: P.blue550)
        static let info = Status(
            base: adaptive(P.blue550, P.blue300),
            onPrimary: P.neutral100,
            onSecondary: P.blue550)
        static let success = Status(
            base: adaptive(P.green550, P.green400),
            onPrimary: P.neutral100,
            onSecondary: adaptive(P.green800, P.green550))
        static let warning = Status(
            base: adaptive(P.orange700, P.orange300),
            onPrimary: P.neutral800,
            onSecondary: P.orange700)
        static let error = Status(
            base: adaptive(P.red500, P.red300),
            onPrimary: P.neutral100,
            onSecondary: adaptive(P.red800, P.red500))
        static let promote = Status(
            base: adaptive(P.purple500, P.purple400),
            onPrimary: adaptive(P.neutral100, P.neutral900),
            onSecondary: adaptive(P.purple600, P.purple100))
    }

    // MARK: - Border

    enum Border {
        static let primary = adaptive(P.neutral300, P.neutral700)
        static let secondary = adaptive(P.neutral400, P.neutral500)
        static let tertiary = adaptive(P.neutral500, P.neutral400)
        static let inverted = adaptive(P.neutral100, P.neutral800)

        struct Status {
            let base: Color
            let pressed: Color
        }

        static let brand = Status(
            base: adaptive(P.blue500, P.blue300), pressed: adaptive(P.blue800, P.blue500))
        static let info = Status(
            base: adaptive(P.blue500, P.blue300), pressed: adaptive(P.blue800, P.blue500))
        static let success = Status(
            base: adaptive(P.green500, P.green400), pressed: adaptive(P.green600, P.green500))
        static let warning = Status(base: P.orange300, pressed: P.orange400)
        static let error = Status(
            base: adaptive(P.red500, P.red300), pressed: P.red500)
        static let promote = Status(
            base: adaptive(P.purple500, P.purple400), pressed: P.purple600)
    }

    // MARK: - Action

    enum Action {
        static let primary = adaptive(P.blue550, P.blue400)
        static let secondary = P.neutral400
    }

    // MARK: - AI

    enum AI {
        // Figma lists light start as "blue555", which doesn't exist in the primitives; blue550 is the nearest match.
        static let gradientStart = adaptive(P.blue550, P.blue400)
        static let gradientEnd = adaptive(P.purple500, P.purple300)
        static let gradient = LinearGradient(
            colors: [gradientStart, gradientEnd], startPoint: .leading, endPoint: .trailing)
    }
}
