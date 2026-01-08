import Foundation

// MARK: - Active Trip Status
struct ActiveTrip: Codable {
    let active: Bool
    let startTime: String?
    let startOdo: Double?
    let lastOdo: Double?
    let lastOdoChange: String?
    let gpsCount: Int?
    let firstGps: GpsPoint?
    let lastGps: GpsPoint?

    enum CodingKeys: String, CodingKey {
        case active
        case startTime = "start_time"
        case startOdo = "start_odo"
        case lastOdo = "last_odo"
        case lastOdoChange = "last_odo_change"
        case gpsCount = "gps_count"
        case firstGps = "first_gps"
        case lastGps = "last_gps"
    }

    var distanceKm: Double {
        guard let start = startOdo, let last = lastOdo else { return 0 }
        return last - start
    }

    var durationMinutes: Int? {
        guard let startTimeStr = startTime else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let startDate = formatter.date(from: startTimeStr) else {
            // Try without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            guard let startDate = formatter.date(from: startTimeStr) else { return nil }
            return Int(Date().timeIntervalSince(startDate) / 60)
        }
        return Int(Date().timeIntervalSince(startDate) / 60)
    }
}

struct GpsPoint: Codable {
    let lat: Double
    let lng: Double
    let timestamp: String
}

// MARK: - Trip
struct Trip: Codable, Identifiable {
    let id: String
    let date: String
    let startTime: String
    let endTime: String
    let fromAddress: String
    let toAddress: String
    let distanceKm: Double
    let tripType: String // 'B' = Business, 'P' = Private, 'M' = Mixed
    let businessKm: Double
    let privateKm: Double
    let carId: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case startTime = "start_time"
        case endTime = "end_time"
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case distanceKm = "distance_km"
        case tripType = "trip_type"
        case businessKm = "business_km"
        case privateKm = "private_km"
        case carId = "car_id"
    }

    var tripTypeLabel: String {
        switch tripType {
        case "B": return "Zakelijk"
        case "P": return "Privé"
        case "M": return "Gemengd"
        default: return tripType
        }
    }

    var tripTypeColor: String {
        switch tripType {
        case "B": return "blue"
        case "P": return "green"
        case "M": return "orange"
        default: return "gray"
        }
    }
}

// MARK: - Stats
struct Stats: Codable {
    let totalKm: Double
    let businessKm: Double
    let privateKm: Double
    let tripCount: Int

    enum CodingKeys: String, CodingKey {
        case totalKm = "total_km"
        case businessKm = "business_km"
        case privateKm = "private_km"
        case tripCount = "trip_count"
    }
}

// MARK: - Car
struct Car: Codable, Identifiable {
    let id: String
    let name: String
    let brand: String
    let color: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, brand, color
        case isDefault = "is_default"
    }
}

// MARK: - Car Data (live status from vehicle API)
struct CarData: Codable {
    let brand: String
    let odometerKm: Double?
    let batteryLevel: Int?
    let rangeKm: Int?
    let isCharging: Bool
    let isPluggedIn: Bool
    let state: String?
    let fetchedAt: String

    enum CodingKeys: String, CodingKey {
        case brand
        case odometerKm = "odometer_km"
        case batteryLevel = "battery_level"
        case rangeKm = "range_km"
        case isCharging = "is_charging"
        case isPluggedIn = "is_plugged_in"
        case state
        case fetchedAt = "fetched_at"
    }

    var stateLabel: String {
        switch state {
        case "parked": return "Geparkeerd"
        case "driving": return "Rijden"
        case "charging": return "Opladen"
        default: return "Onbekend"
        }
    }
}
