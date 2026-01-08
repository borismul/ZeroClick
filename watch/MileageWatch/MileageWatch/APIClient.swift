import Foundation

class APIClient {
    static let shared = APIClient()

    private let baseURL = "https://mileage-api-ivdikzmo7a-ez.a.run.app"

    private var userEmail: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }

    private init() {}

    private func makeRequest<T: Decodable>(_ endpoint: String, method: String = "GET") async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !userEmail.isEmpty {
            request.setValue(userEmail, forHTTPHeaderField: "X-User-Email")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Status
    func getStatus() async throws -> ActiveTrip {
        try await makeRequest("/webhook/status")
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
}

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
