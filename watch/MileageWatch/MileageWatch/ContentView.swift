import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MileageViewModel

    var body: some View {
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
            .task {
                await viewModel.refreshAll()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MileageViewModel())
}
