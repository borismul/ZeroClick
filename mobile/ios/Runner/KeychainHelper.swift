import Foundation
import Security

/// Helper for storing/retrieving tokens via iCloud Keychain (syncs to Watch automatically)
class KeychainHelper {
    static let shared = KeychainHelper()

    private let service = "com.zeroclick.app"
    private let tokenAccount = "authToken"
    private let refreshTokenAccount = "refreshToken"
    private let emailAccount = "userEmail"

    private init() {}

    // MARK: - Token

    func saveToken(_ token: String) {
        save(value: token, account: tokenAccount)
    }

    func getToken() -> String? {
        return get(account: tokenAccount)
    }

    func deleteToken() {
        delete(account: tokenAccount)
    }

    // MARK: - Refresh Token

    func saveRefreshToken(_ token: String) {
        save(value: token, account: refreshTokenAccount)
    }

    func getRefreshToken() -> String? {
        return get(account: refreshTokenAccount)
    }

    func deleteRefreshToken() {
        delete(account: refreshTokenAccount)
    }

    // MARK: - Email

    func saveEmail(_ email: String) {
        save(value: email, account: emailAccount)
    }

    func getEmail() -> String? {
        return get(account: emailAccount)
    }

    // MARK: - Private

    private func save(value: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }

        // Delete existing item first
        delete(account: account)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrSynchronizable as String: kCFBooleanTrue!, // iCloud sync
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("[Keychain] Save error: \(status)")
        } else {
            print("[Keychain] Saved \(account) to iCloud Keychain")
        }
    }

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
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    private func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]

        SecItemDelete(query as CFDictionary)
    }
}
