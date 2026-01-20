import Foundation
import OSLog

class APIClient {
    static let shared = APIClient()

    private let baseURL = "https://mileage-api-ivdikzmo7a-ez.a.run.app"

    private var userEmail: String {
        return (UserDefaults.standard.string(forKey: "userEmail") ?? "").lowercased()
    }

    // Cached token for performance (avoids repeated Keychain reads)
    private var cachedToken: String?

    private init() {}

    // MARK: - Token Management

    /// Get current access token from cache or Keychain
    private func getAccessToken() -> String? {
        if let cached = cachedToken, !cached.isEmpty {
            return cached
        }
        let token = KeychainHelper.shared.getToken()
        cachedToken = token
        return token
    }

    /// Refresh the access token using the refresh endpoint
    /// Returns the new access token or nil if refresh failed
    private func refreshAccessToken() async -> String? {
        guard let refreshToken = KeychainHelper.shared.getRefreshToken() else {
            Logger.api.debug("No refresh token available")
            return nil
        }

        Logger.api.info("Refreshing access token...")

        guard let url = URL(string: "\(baseURL)/auth/refresh") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["refresh_token": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }

            if httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let newToken = json["access_token"] as? String {
                    Logger.api.info("Token refreshed successfully")
                    cachedToken = newToken
                    // Note: We don't update Keychain here as the Watch can't write to it
                    // The iPhone will update it next time it refreshes
                    return newToken
                }
            } else if httpResponse.statusCode == 401 {
                Logger.api.warning("Refresh token expired/invalid")
                cachedToken = nil
            }
        } catch {
            Logger.api.error("Token refresh error: \(error.localizedDescription)")
        }

        return nil
    }

    // MARK: - Request Handling

    private func makeRequest<T: Decodable>(_ endpoint: String, method: String = "GET", isRetry: Bool = false) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Auth token from cache or iCloud Keychain
        if let token = getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if !userEmail.isEmpty {
            request.setValue(userEmail, forHTTPHeaderField: "X-User-Email")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Handle 401 - try to refresh token and retry once
        if httpResponse.statusCode == 401 && !isRetry {
            Logger.api.info("Got 401, attempting token refresh...")

            // Strategy 1: Try direct API refresh (faster, no need to wake iPhone)
            if let newToken = await refreshAccessToken() {
                Logger.api.debug("Refreshed via API, retrying request...")
                cachedToken = newToken
                return try await makeRequest(endpoint, method: method, isRetry: true)
            }

            // Strategy 2: Request fresh token from iPhone (fallback)
            Logger.api.debug("API refresh failed, requesting from iPhone...")
            if let token = await WatchConnectivityManager.shared.requestFreshToken(forceFromPhone: true) {
                Logger.api.info("Got token from iPhone, retrying request...")
                cachedToken = token
                return try await makeRequest(endpoint, method: method, isRetry: true)
            }

            Logger.api.error("All token refresh attempts failed")
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Clear Cache

    /// Clear the token cache (call after logout or when tokens are updated)
    func clearTokenCache() {
        cachedToken = nil
    }

    // MARK: - Status
    func getStatus() async throws -> ActiveTrip {
        guard !userEmail.isEmpty else {
            throw APIError.invalidURL
        }
        let encoded = userEmail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? userEmail
        return try await makeRequest("/webhook/status?user=\(encoded)")
    }

    // MARK: - Stats
    func getStats(carId: String? = nil) async throws -> Stats {
        let endpoint = carId != nil ? "/stats?car_id=\(carId!)" : "/stats"
        return try await makeRequest(endpoint)
    }

    // MARK: - Trips
    func getTrips(carId: String? = nil, limit: Int = 10) async throws -> [Trip] {
        var endpoint = "/trips?limit=\(limit)"
        if let carId = carId {
            endpoint += "&car_id=\(carId)"
        }
        return try await makeRequest(endpoint)
    }

    // MARK: - Cars
    func getCars() async throws -> [Car] {
        try await makeRequest("/cars")
    }

    func getCarData(carId: String) async throws -> CarData {
        try await makeRequest("/cars/\(carId)/data")
    }

    // MARK: - Account Management

    /// Delete the current user's account and all associated data
    func deleteAccount() async throws {
        let _: EmptyResponse = try await makeRequest("/account", method: "DELETE")
    }
}

/// Empty response type for endpoints that don't return data
struct EmptyResponse: Decodable {}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Ongeldige URL"
        case .invalidResponse: return "Ongeldige response"
        case .httpError(let code): return "HTTP fout: \(code)"
        case .decodingError: return "Data fout"
        }
    }
}
