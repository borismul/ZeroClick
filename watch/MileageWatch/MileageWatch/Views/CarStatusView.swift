import SwiftUI

struct CarStatusView: View {
    @EnvironmentObject var viewModel: MileageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Car name header
                if let car = viewModel.selectedCar {
                    HStack {
                        Image(systemName: "car.fill")
                            .foregroundColor(Color(hex: car.color) ?? .blue)
                        Text(car.name)
                            .font(.headline)
                    }
                }

                if let carData = viewModel.carData {
                    // Battery & Range
                    BatteryCard(carData: carData)

                    // Odometer
                    if let odo = carData.odometerKm {
                        InfoRow(
                            icon: "gauge",
                            label: "Kilometerstand",
                            value: String(format: "%.0f km", odo)
                        )
                    }

                    // State
                    InfoRow(
                        icon: stateIcon(carData.state),
                        label: "Status",
                        value: carData.stateLabel
                    )

                    // Last updated
                    Text("Bijgewerkt: \(formattedTime(carData.fetchedAt))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                } else if viewModel.selectedCar != nil {
                    VStack(spacing: 8) {
                        Image(systemName: "car.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Geen voertuigdata")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Koppel je auto in de app")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Auto")
    }

    private func stateIcon(_ state: String?) -> String {
        switch state {
        case "parked": return "parkingsign"
        case "driving": return "car.fill"
        case "charging": return "bolt.fill"
        default: return "questionmark.circle"
        }
    }

    private func formattedTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: isoString) else {
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: isoString) else { return "onbekend" }
            return formatRelativeTime(date)
        }
        return formatRelativeTime(date)
    }

    private func formatRelativeTime(_ date: Date) -> String {
        let minutes = Int(-date.timeIntervalSinceNow / 60)
        if minutes < 1 { return "nu" }
        if minutes < 60 { return "\(minutes) min geleden" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours) uur geleden" }
        return "\(hours / 24) dagen geleden"
    }
}

// MARK: - Battery Card
struct BatteryCard: View {
    let carData: CarData

    var body: some View {
        VStack(spacing: 8) {
            // Battery level with icon
            HStack {
                BatteryIcon(level: carData.batteryLevel ?? 0, isCharging: carData.isCharging)
                    .frame(width: 36, height: 18)

                VStack(alignment: .leading) {
                    if let level = carData.batteryLevel {
                        Text("\(level)%")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }

                Spacer()

                if let range = carData.rangeKm {
                    VStack(alignment: .trailing) {
                        Text("\(range)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("km")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Charging status
            if carData.isCharging {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.green)
                    Text("Opladen")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            } else if carData.isPluggedIn {
                HStack {
                    Image(systemName: "powerplug.fill")
                        .foregroundColor(.orange)
                    Text("Aangesloten")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Battery Icon
struct BatteryIcon: View {
    let level: Int
    let isCharging: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Battery outline
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.white, lineWidth: 1.5)
                    .frame(width: geo.size.width - 4, height: geo.size.height)

                // Battery tip
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 3, height: geo.size.height * 0.5)
                    .offset(x: geo.size.width - 4)

                // Fill level
                RoundedRectangle(cornerRadius: 2)
                    .fill(batteryColor)
                    .frame(
                        width: max(0, (geo.size.width - 8) * CGFloat(level) / 100),
                        height: geo.size.height - 4
                    )
                    .padding(.leading, 2)

                // Charging bolt
                if isCharging {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }

    private var batteryColor: Color {
        if level <= 20 { return .red }
        if level <= 40 { return .orange }
        return .green
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(8)
    }
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

#Preview {
    CarStatusView()
        .environmentObject(MileageViewModel())
}
