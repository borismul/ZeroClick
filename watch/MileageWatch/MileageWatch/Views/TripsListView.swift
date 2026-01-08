import SwiftUI

struct TripsListView: View {
    @EnvironmentObject var viewModel: MileageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Recente Ritten")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                if viewModel.recentTrips.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "car")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Geen ritten")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.recentTrips) { trip in
                        TripRow(trip: trip)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct TripRow: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Date and type badge
            HStack {
                Text(formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                TripTypeBadge(type: trip.tripType)
            }

            // Distance
            Text(String(format: "%.1f km", trip.distanceKm))
                .font(.headline)
                .fontWeight(.semibold)

            // Route
            HStack(spacing: 4) {
                Text(shortenAddress(trip.fromAddress))
                Image(systemName: "arrow.right")
                    .font(.caption2)
                Text(shortenAddress(trip.toAddress))
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .lineLimit(1)

            // Time
            Text("\(trip.startTime) - \(trip.endTime)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }

    private var formattedDate: String {
        // Parse "2024-01-15" format
        let parts = trip.date.split(separator: "-")
        guard parts.count == 3 else { return trip.date }
        return "\(parts[2])-\(parts[1])"
    }

    private func shortenAddress(_ address: String) -> String {
        // Take first part before comma or limit to 15 chars
        if let commaIndex = address.firstIndex(of: ",") {
            return String(address[..<commaIndex])
        }
        if address.count > 15 {
            return String(address.prefix(15)) + "..."
        }
        return address
    }
}

struct TripTypeBadge: View {
    let type: String

    var body: some View {
        Text(label)
            .font(.system(size: 9, weight: .medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.3))
            .foregroundColor(color)
            .cornerRadius(4)
    }

    private var label: String {
        switch type {
        case "B": return "Z"
        case "P": return "P"
        case "M": return "G"
        default: return type
        }
    }

    private var color: Color {
        switch type {
        case "B": return .blue
        case "P": return .green
        case "M": return .orange
        default: return .gray
        }
    }
}

#Preview {
    TripsListView()
        .environmentObject(MileageViewModel())
}
