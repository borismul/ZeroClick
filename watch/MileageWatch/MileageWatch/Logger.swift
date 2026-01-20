import OSLog

extension Logger {
    private static let subsystem = "com.zeroclick.watch"

    /// API calls and responses
    static let api = Logger(subsystem: subsystem, category: "api")

    /// iPhone-Watch communication sync
    static let sync = Logger(subsystem: subsystem, category: "sync")

    /// UI-related logging
    static let ui = Logger(subsystem: subsystem, category: "ui")

    /// Keychain access
    static let keychain = Logger(subsystem: subsystem, category: "keychain")
}
