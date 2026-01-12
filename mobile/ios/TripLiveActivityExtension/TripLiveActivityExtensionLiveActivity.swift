//
//  TripLiveActivityExtensionLiveActivity.swift
//  TripLiveActivityExtension
//

import ActivityKit
import WidgetKit
import SwiftUI

/// TripActivityAttributes - MUST match Runner/TripActivityAttributes.swift exactly
struct TripActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var distanceKm: Double
        public var durationMinutes: Int
        public var avgSpeed: Double
        public var startTime: Date
        public var isActive: Bool

        public init(distanceKm: Double, durationMinutes: Int, avgSpeed: Double, startTime: Date, isActive: Bool) {
            self.distanceKm = distanceKm
            self.durationMinutes = durationMinutes
            self.avgSpeed = avgSpeed
            self.startTime = startTime
            self.isActive = isActive
        }
    }

    public var tripId: String
    public var carName: String

    public init(tripId: String, carName: String) {
        self.tripId = tripId
        self.carName = carName
    }
}

struct TripLiveActivityExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripActivityAttributes.self) { context in
            // Lock Screen UI
            TripLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "car.fill")
                            .foregroundColor(.green)
                        Text(context.attributes.carName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.durationMinutes) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text(String(format: "%.1f", context.state.distanceKm))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("km")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Label(String(format: "%.0f km/u", context.state.avgSpeed), systemImage: "speedometer")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        if context.state.isActive {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                                Text("Actief")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "car.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text(String(format: "%.1f", context.state.distanceKm))
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
            } minimal: {
                Image(systemName: "car.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

// MARK: - Lock Screen View

struct TripLockScreenView: View {
    let context: ActivityViewContext<TripActivityAttributes>

    var body: some View {
        HStack(spacing: 16) {
            // Car icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "car.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }

            // Distance + duration
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", context.state.distanceKm))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("km")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.green)
                }

                HStack(spacing: 12) {
                    Label("\(context.state.durationMinutes) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Label(String(format: "%.0f km/u", context.state.avgSpeed), systemImage: "speedometer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Status
            if context.state.isActive {
                Text("RIJDEN")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding(16)
        .activityBackgroundTint(Color.black.opacity(0.8))
    }
}

#Preview("Notification", as: .content, using: TripActivityAttributes(tripId: "123", carName: "Audi Q4")) {
    TripLiveActivityExtensionLiveActivity()
} contentStates: {
    TripActivityAttributes.ContentState(distanceKm: 12.5, durationMinutes: 23, avgSpeed: 45, startTime: Date(), isActive: true)
}
