import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: ZeroClickViewModel

    var body: some View {
        List {
            // Active Trip Banner
            if let trip = viewModel.activeTrip, trip.active {
                ActiveTripCard(trip: trip)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            }

            // Stats Summary
            if let stats = viewModel.stats {
                StatsCard(stats: stats)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            }

            // Car selector if multiple cars
            if viewModel.cars.count > 1 {
                CarSelectorRow(
                    cars: viewModel.cars,
                    selectedCar: viewModel.selectedCar
                ) { car in
                    viewModel.selectCar(car)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            }

            // Error message
            if let error = viewModel.error {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)
            }

            // Loading indicator
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Kilometerstand")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.refreshAll() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isLoading)
            }
        }
    }
}

// MARK: - Active Trip Card
struct ActiveTripCard: View {
    let trip: ActiveTrip

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: "car.fill")
                    .foregroundColor(.green)
                Text("Actieve Rit")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            HStack(spacing: 16) {
                VStack {
                    Text(String(format: "%.1f", trip.distanceKm))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("km")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                if let minutes = trip.durationMinutes {
                    VStack {
                        Text("\(minutes)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("min")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                if let gpsCount = trip.gpsCount {
                    VStack {
                        Text("\(gpsCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("GPS")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(10)
        .background(Color.green.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Stats Card
struct StatsCard: View {
    let stats: Stats

    var body: some View {
        VStack(spacing: 8) {
            // Total km
            HStack {
                Text("Totaal")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.0f km", stats.totalKm))
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Divider()

            // Business / Private breakdown
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text("Zakelijk")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(String(format: "%.0f km", stats.businessKm))
                        .font(.caption)
                        .fontWeight(.medium)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("Privé")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                    }
                    Text(String(format: "%.0f km", stats.privateKm))
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }

            // Trip count
            Text("\(stats.tripCount) ritten")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Car Selector Row
struct CarSelectorRow: View {
    let cars: [Car]
    let selectedCar: Car?
    let onSelect: (Car) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(cars) { car in
                    Button(action: { onSelect(car) }) {
                        Text(car.name)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(selectedCar?.id == car.id ? Color.blue : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(ZeroClickViewModel())
}
