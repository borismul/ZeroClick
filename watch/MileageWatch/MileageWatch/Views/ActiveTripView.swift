import SwiftUI

struct ActiveTripView: View {
    @EnvironmentObject var viewModel: ZeroClickViewModel

    var body: some View {
        GeometryReader { geometry in
            if let trip = viewModel.activeTrip, trip.active {
                // Active trip - running app style
                VStack(spacing: 4) {
                    // Status indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("ACTIEF")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.green)
                    }

                    Spacer()

                    // Big distance display
                    Text(String(format: "%.1f", trip.distanceKm))
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)

                    Text("KM")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    // Duration
                    if let minutes = trip.durationMinutes {
                        HStack(spacing: 12) {
                            VStack(spacing: 2) {
                                Text(formatDuration(minutes))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Text("DUUR")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }

                            if trip.distanceKm > 0 && minutes > 0 {
                                VStack(spacing: 2) {
                                    Text(String(format: "%.0f", Double(trip.distanceKm) / (Double(minutes) / 60)))
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Text("KM/U")
                                        .font(.system(size: 9))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }

                    Spacer()

                    // Start location
                    if let firstGps = trip.firstGps {
                        Text("Start: \(formatCoord(firstGps.lat, firstGps.lng))")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            } else {
                // No active trip
                VStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)

                    Text("Geen actieve rit")
                        .font(.headline)

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if let error = viewModel.error {
                        Text(error)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        Text("Start een rit om te tracken")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Button(action: {
                        Task { await viewModel.refreshAll() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func formatDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return String(format: "%d:%02d", hours, mins)
        }
        return "\(mins)m"
    }

    private func formatCoord(_ lat: Double, _ lng: Double) -> String {
        return String(format: "%.3f, %.3f", lat, lng)
    }
}

#Preview {
    ActiveTripView()
        .environmentObject(ZeroClickViewModel())
}
