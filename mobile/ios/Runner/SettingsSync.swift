import Foundation

@objc class SettingsSync: NSObject {
    static let appGroupID = "group.nl.borism.mileageTracker"

    @objc static func syncSettingsToAppGroup() {
        // Read from Flutter's SharedPreferences (stored in standard UserDefaults with flutter. prefix)
        let standardDefaults = UserDefaults.standard

        // Get the Flutter settings JSON
        if let settingsJson = standardDefaults.string(forKey: "flutter.app_settings") {
            // Write to shared App Group
            if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
                sharedDefaults.set(settingsJson, forKey: "app_settings")
                sharedDefaults.synchronize()
                print("Settings synced to App Group")
            }
        }
    }
}
