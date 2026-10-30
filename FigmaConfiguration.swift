import Foundation

/// Configuration manager for storing Figma API credentials securely
class FigmaConfiguration {
    static let shared = FigmaConfiguration()
    
    private let keychainService = "com.yourapp.figma"
    private let tokenKey = "figmaAPIToken"
    
    private init() {}
    
    /// Store Figma API token securely in Keychain
    func saveAPIToken(_ token: String) throws {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }
    
    /// Retrieve Figma API token from Keychain
    func getAPIToken() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.notFound
        }
        
        return token
    }
    
    /// Delete API token from Keychain
    func deleteAPIToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete
        }
    }
    
    /// Check if API token exists
    func hasAPIToken() -> Bool {
        do {
            _ = try getAPIToken()
            return true
        } catch {
            return false
        }
    }
}

enum KeychainError: LocalizedError {
    case unableToSave
    case notFound
    case unableToDelete
    
    var errorDescription: String? {
        switch self {
        case .unableToSave:
            return "Unable to save to Keychain"
        case .notFound:
            return "Item not found in Keychain"
        case .unableToDelete:
            return "Unable to delete from Keychain"
        }
    }
}

/// Preference keys for storing Figma-related settings
extension UserDefaults {
    private enum Keys {
        static let lastFileKey = "figma.lastFileKey"
        static let favoriteFiles = "figma.favoriteFiles"
    }
    
    var lastFigmaFileKey: String? {
        get { string(forKey: Keys.lastFileKey) }
        set { set(newValue, forKey: Keys.lastFileKey) }
    }
    
    var favoriteFigmaFiles: [String] {
        get { stringArray(forKey: Keys.favoriteFiles) ?? [] }
        set { set(newValue, forKey: Keys.favoriteFiles) }
    }
}
