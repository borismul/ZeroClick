import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MileageViewModel

    var body: some View {
        if viewModel.userEmail.isEmpty {
            SettingsView()
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
