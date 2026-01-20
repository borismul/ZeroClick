import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.zeroclick"

    /// Trip lifecycle events (start, end, ping)
    static let trip = Logger(subsystem: subsystem, category: "trip")

    /// GPS/Location updates
    static let location = Logger(subsystem: subsystem, category: "location")

    /// Motion activity detection
    static let motion = Logger(subsystem: subsystem, category: "motion")

    /// Watch connectivity
    static let watch = Logger(subsystem: subsystem, category: "watch")

    /// API calls and responses
    static let api = Logger(subsystem: subsystem, category: "api")

    /// Live Activity updates
    static let activity = Logger(subsystem: subsystem, category: "activity")

    /// General app lifecycle
    static let app = Logger(subsystem: subsystem, category: "app")
}
