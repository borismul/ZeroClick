import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ZeroClickViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if viewModel.userEmail.isEmpty {
                SettingsView()
            } else if let trip = viewModel.activeTrip, trip.active {
                // Show full-screen live trip view during active trip
                LiveTripView(trip: trip, onEnd: {
                    // End trip via API would go here
                    Task {
                        await viewModel.refreshAll()
                    }
                })
            } else {
                TabView {
                    DashboardView()
                    TripsListView()
                    CarStatusView()
                    SettingsView()
                }
                .tabViewStyle(.verticalPage)
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.refreshOnAppear()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ZeroClickViewModel())
}
