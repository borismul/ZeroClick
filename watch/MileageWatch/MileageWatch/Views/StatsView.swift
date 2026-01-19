import SwiftUI

struct StatsView: View {
    @EnvironmentObject var viewModel: ZeroClickViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Totalen")
                    .font(.headline)

                if let stats = viewModel.stats {
                    // Total KM
                    StatCard(
                        title: "Totaal",
                        value: String(format: "%.0f", stats.totalKm),
                        unit: "km",
                        color: .white
                    )

                    HStack(spacing: 8) {
                        // Business KM
                        StatCard(
                            title: "Zakelijk",
                            value: String(format: "%.0f", stats.businessKm),
                            unit: "km",
                            color: .blue
                        )

                        // Private KM
                        StatCard(
                            title: "Prive",
                            value: String(format: "%.0f", stats.privateKm),
                            unit: "km",
                            color: .green
                        )
                    }

                    // Trip count
                    HStack {
                        Image(systemName: "car.fill")
                            .foregroundColor(.secondary)
                        Text("\(stats.tripCount) ritten")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)

                    // Car selector
                    if viewModel.cars.count > 1 {
                        Divider()

                        Text("Auto")
                            .font(.caption2)
                            .foregroundColor(.secondary)

                        ForEach(viewModel.cars) { car in
                            Button(action: {
                                viewModel.selectCar(car)
                            }) {
                                HStack {
                                    Circle()
                                        .fill(Color(hex: car.color) ?? .gray)
                                        .frame(width: 8, height: 8)
                                    Text(car.name)
                                        .font(.caption)
                                    Spacer()
                                    if viewModel.selectedCar?.id == car.id {
                                        Image(systemName: "checkmark")
                                            .font(.caption2)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Text("Geen data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                Text(unit)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

#Preview {
    StatsView()
        .environmentObject(ZeroClickViewModel())
}
