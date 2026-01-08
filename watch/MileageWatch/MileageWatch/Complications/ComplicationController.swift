import WidgetKit
import SwiftUI

// MARK: - Complication Provider
struct MileageComplicationProvider: TimelineProvider {
    typealias Entry = MileageComplicationEntry

    func placeholder(in context: Context) -> MileageComplicationEntry {
        MileageComplicationEntry(date: Date(), totalKm: 12345, businessKm: 8765, isActive: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (MileageComplicationEntry) -> Void) {
        let entry = MileageComplicationEntry(date: Date(), totalKm: 12345, businessKm: 8765, isActive: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MileageComplicationEntry>) -> Void) {
        Task {
            do {
                let stats = try await APIClient.shared.getStats()
                let status = try await APIClient.shared.getStatus()

                let entry = MileageComplicationEntry(
                    date: Date(),
                    totalKm: stats.totalKm,
                    businessKm: stats.businessKm,
                    isActive: status.active
                )

                // Refresh every 15 minutes
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                // Use placeholder on error
                let entry = MileageComplicationEntry(date: Date(), totalKm: 0, businessKm: 0, isActive: false)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
                completion(timeline)
            }
        }
    }
}

// MARK: - Entry
struct MileageComplicationEntry: TimelineEntry {
    let date: Date
    let totalKm: Double
    let businessKm: Double
    let isActive: Bool
}

// MARK: - Complication Views
struct MileageComplicationEntryView: View {
    var entry: MileageComplicationProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularView(entry: entry)
        case .accessoryRectangular:
            RectangularView(entry: entry)
        case .accessoryCorner:
            CornerView(entry: entry)
        case .accessoryInline:
            InlineView(entry: entry)
        default:
            CircularView(entry: entry)
        }
    }
}

// MARK: - Circular Complication
struct CircularView: View {
    let entry: MileageComplicationEntry

    var body: some View {
        ZStack {
            if entry.isActive {
                // Show active trip indicator
                VStack(spacing: 0) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                    Text("ACTIEF")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.green)
                }
            } else {
                VStack(spacing: 0) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 12))
                    Text(formatKm(entry.totalKm))
                        .font(.system(size: 12, weight: .semibold))
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func formatKm(_ km: Double) -> String {
        if km >= 1000 {
            return String(format: "%.0fk", km / 1000)
        }
        return String(format: "%.0f", km)
    }
}

// MARK: - Rectangular Complication
struct RectangularView: View {
    let entry: MileageComplicationEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 12))
                    Text("Kilometerstand")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }

                if entry.isActive {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("Actieve rit")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.green)
                    }
                } else {
                    Text(String(format: "%.0f km", entry.totalKm))
                        .font(.system(size: 16, weight: .bold))
                }

                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 4, height: 4)
                        Text(String(format: "%.0f", entry.businessKm))
                            .font(.system(size: 9))
                    }
                }
            }
            Spacer()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Corner Complication
struct CornerView: View {
    let entry: MileageComplicationEntry

    var body: some View {
        VStack {
            if entry.isActive {
                Image(systemName: "car.fill")
                    .foregroundColor(.green)
            } else {
                Text(String(format: "%.0f", entry.totalKm))
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .widgetLabel {
            Text("km")
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Inline Complication
struct InlineView: View {
    let entry: MileageComplicationEntry

    var body: some View {
        if entry.isActive {
            Label("Actieve rit", systemImage: "car.fill")
        } else {
            Label(String(format: "%.0f km", entry.totalKm), systemImage: "car.fill")
        }
    }
}

// MARK: - Widget Configuration
struct MileageComplication: Widget {
    let kind: String = "MileageComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MileageComplicationProvider()) { entry in
            MileageComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Kilometerstand")
        .description("Bekijk je totale kilometers en actieve rit status.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner,
            .accessoryInline
        ])
    }
}

#Preview(as: .accessoryCircular) {
    MileageComplication()
} timeline: {
    MileageComplicationEntry(date: Date(), totalKm: 12345, businessKm: 8765, isActive: false)
    MileageComplicationEntry(date: Date(), totalKm: 12345, businessKm: 8765, isActive: true)
}
