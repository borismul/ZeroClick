import Foundation
import Security

/// Helper for retrieving tokens from iCloud Keychain (synced from iPhone)
class KeychainHelper {
    static let shared = KeychainHelper()

    private let service = "com.zeroclick.app"
    private let tokenAccount = "authToken"
    private let refreshTokenAccount = "refreshToken"
    private let emailAccount = "userEmail"

    private init() {}

    // MARK: - Access Token

    func getToken() -> String? {
        return get(account: tokenAccount)
    }

    // MARK: - Refresh Token

    func getRefreshToken() -> String? {
        return get(account: refreshTokenAccount)
    }

    // MARK: - Email

    func getEmail() -> String? {
        return get(account: emailAccount)
    }

    // MARK: - Private

    private func get(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            let value = String(data: data, encoding: .utf8)
            print("[Keychain] Got \(account) from iCloud Keychain")
            return value
        }
        print("[Keychain] No \(account) in iCloud Keychain (status: \(status))")
        return nil
    }
}
