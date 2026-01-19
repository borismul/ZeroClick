import SwiftUI

@main
struct ZeroClickWatchApp: App {
    @StateObject private var viewModel = ZeroClickViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
