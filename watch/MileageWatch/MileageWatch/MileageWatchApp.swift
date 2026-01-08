import SwiftUI

@main
struct MileageWatchApp: App {
    @StateObject private var viewModel = MileageViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
