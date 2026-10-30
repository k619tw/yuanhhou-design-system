import SwiftUI

extension Color {
    /// Creates a color from a hex value in `0xRRGGBB` or `0xRRGGBBAA` form.
    init(hex: UInt32, hasAlpha: Bool = false) {
        let r, g, b, a: Double
        if hasAlpha {
            r = Double((hex >> 24) & 0xFF) / 255
            g = Double((hex >> 16) & 0xFF) / 255
            b = Double((hex >> 8) & 0xFF) / 255
            a = Double(hex & 0xFF) / 255
        } else {
            r = Double((hex >> 16) & 0xFF) / 255
            g = Double((hex >> 8) & 0xFF) / 255
            b = Double(hex & 0xFF) / 255
            a = 1
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {
    /// Creates a color that resolves to `light` or `dark` depending on the current appearance.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })
        #else
        self.init(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #endif
    }
}

/// Layer 1: raw color primitives from the Figma "Tokens" file. Use `ColorToken` in UI code.
enum ColorPrimitive {
    // MARK: Brand fixed
    static let bluaBrand = Color(hex: 0x0F2460)

    // MARK: Blue
    static let blue100 = Color(hex: 0xF1F8FF)
    static let blue200 = Color(hex: 0x8FC7FF)
    static let blue300 = Color(hex: 0x57ABFF)
    static let blue400 = Color(hex: 0x3A9DFF)
    static let blue500 = Color(hex: 0x0073E5)
    static let blue550 = Color(hex: 0x0069D1)
    static let blue600 = Color(hex: 0x005BBF)
    static let blue700 = Color(hex: 0x003F96)
    static let blue800 = Color(hex: 0x101274)
    static let blue900 = Color(hex: 0x0A0B52)

    // MARK: Neutral
    static let neutral100 = Color(hex: 0xFFFFFF)
    static let neutral200 = Color(hex: 0xF6F4F4)
    static let neutral300 = Color(hex: 0xDDE1E6)
    static let neutral400 = Color(hex: 0xBDC3C9)
    static let neutral500 = Color(hex: 0x6D6D73)
    static let neutral550 = Color(hex: 0x6B717A)
    static let neutral600 = Color(hex: 0x4B5158)
    static let neutral700 = Color(hex: 0x404040)
    static let neutral800 = Color(hex: 0x1A1A1A)
    static let neutral900 = Color(hex: 0x000000)

    // MARK: Green
    static let green100 = Color(hex: 0xE9F9E9)
    static let green200 = Color(hex: 0xD4F8DC)
    static let green300 = Color(hex: 0x9DDD96)
    static let green400 = Color(hex: 0x7ECA6B)
    static let green500 = Color(hex: 0x08872E)
    static let green550 = Color(hex: 0x038229)
    static let green600 = Color(hex: 0x0E6027)
    static let green700 = Color(hex: 0x044317)
    static let green800 = Color(hex: 0x022D0D)
    static let green900 = Color(hex: 0x071908)

    // MARK: Red
    static let red100 = Color(hex: 0xFCE2E2)
    static let red200 = Color(hex: 0xFFCCCC)
    static let red300 = Color(hex: 0xF67A7A)
    static let red400 = Color(hex: 0xE04848)
    static let red500 = Color(hex: 0xC41616)
    static let red550 = Color(hex: 0x9F1853)
    static let red600 = Color(hex: 0xAD1818)
    static let red700 = Color(hex: 0x8F0E0E)
    static let red800 = Color(hex: 0x7A002B)
    static let red900 = Color(hex: 0x330012)

    // MARK: Purple
    static let purple100 = Color(hex: 0xF7F2FC)
    static let purple200 = Color(hex: 0xE8DAFF)
    static let purple300 = Color(hex: 0xDE98FF)
    static let purple400 = Color(hex: 0xB670FA)
    static let purple500 = Color(hex: 0x914CD4)
    static let purple550 = Color(hex: 0x6929C4)
    static let purple600 = Color(hex: 0x491D8B)
    static let purple700 = Color(hex: 0x31135E)
    static let purple800 = Color(hex: 0x1C0F30)
    static let purple900 = Color(hex: 0x120F24)

    // MARK: Orange
    static let orange100 = Color(hex: 0xFEECE1)
    static let orange200 = Color(hex: 0xFDDCB5)
    static let orange300 = Color(hex: 0xFDB487)
    static let orange400 = Color(hex: 0xFB8E4B)
    static let orange500 = Color(hex: 0xEA5E00)
    static let orange550 = Color(hex: 0xB72900)
    static let orange600 = Color(hex: 0x781800)
    static let orange700 = Color(hex: 0x8F6425)
    static let orange800 = Color(hex: 0x570D00)
    static let orange900 = Color(hex: 0x380400)

    // MARK: Alpha / white
    static let alphaWhite10 = Color(hex: 0xF6F4F41A, hasAlpha: true)
    static let alphaWhite20 = Color(hex: 0xF6F4F433, hasAlpha: true)
    static let alphaWhite30 = Color(hex: 0xF6F4F44D, hasAlpha: true)
    static let alphaWhite40 = Color(hex: 0xF6F4F466, hasAlpha: true)
    static let alphaWhite50 = Color(hex: 0xF6F4F480, hasAlpha: true)
    static let alphaWhite60 = Color(hex: 0xF6F4F499, hasAlpha: true)
    static let alphaWhite70 = Color(hex: 0xF6F4F4B2, hasAlpha: true)
    static let alphaWhite80 = Color(hex: 0xF6F4F4CC, hasAlpha: true)
    static let alphaWhite90 = Color(hex: 0xF6F4F4E5, hasAlpha: true)

    // MARK: Alpha / black
    static let alphaBlack10 = Color(hex: 0x1A1A1A1A, hasAlpha: true)
    static let alphaBlack20 = Color(hex: 0x1A1A1A33, hasAlpha: true)
    static let alphaBlack30 = Color(hex: 0x1A1A1A4D, hasAlpha: true)
    static let alphaBlack40 = Color(hex: 0x1A1A1A66, hasAlpha: true)
    static let alphaBlack50 = Color(hex: 0x1A1A1A80, hasAlpha: true)
    static let alphaBlack60 = Color(hex: 0x1A1A1A99, hasAlpha: true)
    static let alphaBlack70 = Color(hex: 0x1A1A1AB2, hasAlpha: true)
    static let alphaBlack80 = Color(hex: 0x1A1A1ACC, hasAlpha: true)
    static let alphaBlack90 = Color(hex: 0x1A1A1AE5, hasAlpha: true)

    // MARK: Alpha / brand
    static let alphaBrand10 = Color(hex: 0x0073E51A, hasAlpha: true)
    static let alphaBrand20 = Color(hex: 0x0073E533, hasAlpha: true)
    static let alphaBrand30 = Color(hex: 0x0073E54D, hasAlpha: true)
    static let alphaBrand40 = Color(hex: 0x0073E566, hasAlpha: true)
    static let alphaBrand50 = Color(hex: 0x0073E580, hasAlpha: true)
    static let alphaBrand60 = Color(hex: 0x0073E599, hasAlpha: true)
    static let alphaBrand70 = Color(hex: 0x0073E5B2, hasAlpha: true)
    static let alphaBrand80 = Color(hex: 0x0073E5CC, hasAlpha: true)
    static let alphaBrand90 = Color(hex: 0x0073E5E5, hasAlpha: true)
}
