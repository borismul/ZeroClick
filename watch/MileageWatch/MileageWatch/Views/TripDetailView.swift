import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header
                HStack {
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    TripTypeBadge(type: trip.tripType ?? "?")
                }

                // Big distance
                Text(String(format: "%.1f km", trip.distanceKm ?? 0))
                    .font(.system(size: 32, weight: .bold, design: .rounded))

                // Map placeholder (tap to open)
                Button(action: openInMaps) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)

                        VStack(spacing: 4) {
                            Image(systemName: "map.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Open kaart")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .buttonStyle(.plain)

                // Route details
                VStack(alignment: .leading, spacing: 8) {
                    // From
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.green)
                            .padding(.top, 4)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Van")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(trip.fromAddress ?? "Onbekend")
                                .font(.caption)
                                .lineLimit(2)
                        }
                    }

                    // To
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                            .padding(.top, 4)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Naar")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(trip.toAddress ?? "Onbekend")
                                .font(.caption)
                                .lineLimit(2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)

                // Time
                HStack {
                    VStack(spacing: 2) {
                        Text(trip.startTime ?? "?")
                            .font(.system(size: 16, weight: .medium))
                        Text("Start")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)

                    Spacer()

                    VStack(spacing: 2) {
                        Text(trip.endTime ?? "?")
                            .font(.system(size: 16, weight: .medium))
                        Text("Einde")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 8)

                // Business/Private split
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text(String(format: "%.1f", trip.businessKm))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                        Text("Zakelijk")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    VStack(spacing: 2) {
                        Text(String(format: "%.1f", trip.privateKm))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                        Text("Prive")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Sluit") { dismiss() }
            }
        }
    }

    private var formattedDate: String {
        let parts = trip.date.split(separator: "-")
        guard parts.count == 3 else { return trip.date }
        return "\(parts[2])-\(parts[1])-\(parts[0])"
    }

    private func openInMaps() {
        // Open in Apple Maps - watchOS doesn't have direct URL opening
        // This is a placeholder - maps can be viewed in the iOS app
    }
}

#Preview {
    TripDetailView(trip: Trip(
        id: "test",
        date: "2024-01-15",
        startTime: "09:00",
        endTime: "09:30",
        fromAddress: "Thuis",
        toAddress: "Kantoor",
        distanceKm: 25.5,
        tripType: "B",
        businessKm: 25.5,
        privateKm: 0,
        carId: nil
    ))
}
