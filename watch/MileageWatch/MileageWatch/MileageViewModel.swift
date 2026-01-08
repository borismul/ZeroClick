import Foundation
import SwiftUI

@MainActor
class MileageViewModel: ObservableObject {
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

    init() {
        // Auto-refresh every 30 seconds when there's an active trip
        startAutoRefresh()
    }

    func startAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshAll()
            }
        }
    }

    func refreshAll() async {
        guard !userEmail.isEmpty else {
            error = "Configureer email in instellingen"
            return
        }

        isLoading = true
        error = nil

        do {
            // Fetch all data in parallel
            async let statusTask = APIClient.shared.getStatus()
            async let carsTask = APIClient.shared.getCars()

            let (status, fetchedCars) = try await (statusTask, carsTask)

            self.activeTrip = status
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

        isLoading = false
    }

    func selectCar(_ car: Car) {
        selectedCar = car
        Task {
            await refreshAll()
        }
    }
}
