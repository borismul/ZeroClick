import SwiftUI

/// Full-screen live trip view like Apple Workout app
/// This view is shown when HKWorkoutSession is active and a trip is in progress
struct LiveTripView: View {
    let trip: ActiveTrip
    let onEnd: () -> Void

    @State private var currentTime = Date()
    @State private var showEndConfirmation = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background gradient - green for driving
                LinearGradient(
                    colors: [Color.green.opacity(0.4), Color.black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Status bar with workout indicator
                    HStack {
                        // Workout-style pulsing indicator
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.green.opacity(0.5), lineWidth: 2)
                                    .scaleEffect(1.5)
                            )

                        Text("RIJDEN")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)

                        Spacer()

                        Text(timeString)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 6)

                    Spacer()

                    // Main metric - Distance (large, like Workout app)
                    VStack(spacing: -2) {
                        Text(String(format: "%.1f", trip.distanceKm))
                            .font(.system(size: 68, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        Text("KILOMETER")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                            .tracking(2)
                    }

                    Spacer()

                    // Secondary metrics row
                    HStack(spacing: 24) {
                        // Duration
                        VStack(spacing: 2) {
                            Text(durationString)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text("DUUR")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                                .tracking(1)
                        }

                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 30)

                        // Average speed
                        VStack(spacing: 2) {
                            Text(avgSpeedString)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text("GEM")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                                .tracking(1)
                        }
                    }

                    Spacer()

                    // End button (like Workout app stop button)
                    Button(action: { showEndConfirmation = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("Beëindigen")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.red)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 10)
                }
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .confirmationDialog("Rit beëindigen?", isPresented: $showEndConfirmation, titleVisibility: .visible) {
            Button("Beëindigen", role: .destructive) {
                onEnd()
            }
            Button("Annuleren", role: .cancel) {}
        }
        // Prevent accidental dismissal during workout
        .interactiveDismissDisabled(true)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentTime)
    }

    private var durationString: String {
        guard let minutes = trip.durationMinutes else { return "--:--" }
        let hours = minutes / 60
        let mins = minutes % 60
        return String(format: "%d:%02d", hours, mins)
    }

    private var avgSpeedString: String {
        guard let minutes = trip.durationMinutes, minutes > 0, trip.distanceKm > 0 else {
            return "--"
        }
        let speed = trip.distanceKm / (Double(minutes) / 60.0)
        return String(format: "%.0f", speed)
    }
}

#Preview {
    LiveTripView(
        trip: ActiveTrip(
            active: true,
            startTime: "2024-01-15T09:00:00Z",
            startOdo: 10000,
            lastOdo: 10025.5,
            lastOdoChange: nil,
            gpsCount: 50,
            firstGps: nil,
            lastGps: nil
        ),
        onEnd: {}
    )
}
