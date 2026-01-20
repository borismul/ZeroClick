import Foundation
import SwiftUI
import Combine
import OSLog

@MainActor
class ZeroClickViewModel: ObservableObject {
    @Published var activeTrip: ActiveTrip?
    @Published var stats: Stats?
    @Published var recentTrips: [Trip] = []
    @Published var cars: [Car] = []
    @Published var selectedCar: Car?
    @Published var carData: CarData?
    @Published var isLoading = false
    @Published var error: String?

    @AppStorage("userEmail") var userEmail: String = ""

    private var refreshTimer: Timer?
    private var activeRefreshTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Background refresh every 5 minutes, faster refresh only during active trips
        startAutoRefresh()

        // Listen for trip started notification from WatchConnectivity
        NotificationCenter.default.publisher(for: .tripStarted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Logger.ui.info("Received tripStarted notification - refreshing")
                Task { @MainActor in
                    await self?.refreshAll()
                }
            }
            .store(in: &cancellables)
    }

    func startAutoRefresh() {
        refreshTimer?.invalidate()
        activeRefreshTimer?.invalidate()

        // Background refresh every 5 minutes (was 30 seconds)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshAll()
            }
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        activeRefreshTimer?.invalidate()
        activeRefreshTimer = nil
    }

    // Start fast polling only during active trips (30s lightweight status check)
    private func startActiveRefresh() {
        guard activeRefreshTimer == nil else { return }
        activeRefreshTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshActiveTrip()
            }
        }
    }

    private func stopActiveRefresh() {
        activeRefreshTimer?.invalidate()
        activeRefreshTimer = nil
    }

    // Lightweight refresh - only active trip status (1 Firestore read)
    func refreshActiveTrip() async {
        do {
            self.activeTrip = try await APIClient.shared.getStatus()
            if activeTrip?.active != true {
                stopActiveRefresh()
            }
        } catch {
            // Silent fail for status check
        }
    }

    func refreshAll() async {
        guard !userEmail.isEmpty else {
            error = "Configureer email in instellingen"
            return
        }

        isLoading = true
        error = nil

        // Fetch status first - this is public and critical for LiveTripView
        do {
            self.activeTrip = try await APIClient.shared.getStatus()
        } catch {
            Logger.api.error("Status fetch failed: \(error.localizedDescription)")
        }

        do {
            // Fetch cars (requires auth)
            let fetchedCars = try await APIClient.shared.getCars()
            self.cars = fetchedCars

            // Select default car if none selected
            if selectedCar == nil {
                selectedCar = fetchedCars.first(where: { $0.isDefault }) ?? fetchedCars.first
            }

            // Fetch stats and trips for selected car
            let carId = selectedCar?.id
            async let statsTask = APIClient.shared.getStats(carId: carId)
            async let tripsTask = APIClient.shared.getTrips(carId: carId, limit: 5)

            let (fetchedStats, fetchedTrips) = try await (statsTask, tripsTask)
            self.stats = fetchedStats
            self.recentTrips = fetchedTrips

            // Fetch car data if car is selected and has connected API
            if let car = selectedCar {
                do {
                    self.carData = try await APIClient.shared.getCarData(carId: car.id)
                } catch {
                    // Car data is optional, ignore errors
                    self.carData = nil
                }
            }

        } catch {
            self.error = error.localizedDescription
        }

        // Start fast polling only if trip is active, otherwise stop
        if self.activeTrip?.active == true {
            startActiveRefresh()
        } else {
            stopActiveRefresh()
        }

        isLoading = false
    }

    func selectCar(_ car: Car) {
        selectedCar = car
        Task {
            await refreshAll()
        }
    }

    // MARK: - Account Management

    /// Delete the current user's account and all associated data
    func deleteAccount() async {
        isLoading = true
        error = nil

        do {
            try await APIClient.shared.deleteAccount()
            // Clear local data
            userEmail = ""
            activeTrip = nil
            stats = nil
            recentTrips = []
            cars = []
            selectedCar = nil
            carData = nil
            // Clear token cache
            APIClient.shared.clearTokenCache()
        } catch {
            self.error = "Verwijderen mislukt: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
