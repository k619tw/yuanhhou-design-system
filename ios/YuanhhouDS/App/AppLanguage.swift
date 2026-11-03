import SwiftUI
import YuanhhouDSKit

/// In-app language choice. `.system` follows the device (and the per-app language in Settings);
/// the others override the SwiftUI locale so every `Text` and `LocalizedStringKey` switches instantly.
/// Strings that UIKit draws itself (for example the search bar's Cancel) follow the device language.
nonisolated enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case system, english, japanese

    var id: String { rawValue }

    /// Each language is named in its own language, as the HIG recommends.
    var displayName: LocalizedStringKey {
        switch self {
        case .system: "System"
        case .english: "English"
        case .japanese: "日本語"
        }
    }

    var locale: Locale? {
        switch self {
        case .system: nil
        case .english: Locale(identifier: "en")
        case .japanese: Locale(identifier: "ja")
        }
    }
}

extension View {
    /// Applies the in-app language to this view tree.
    @ViewBuilder
    func appLanguage(_ language: AppLanguage) -> some View {
        if let locale = language.locale {
            environment(\.locale, locale)
        } else {
            self
        }
    }
}
