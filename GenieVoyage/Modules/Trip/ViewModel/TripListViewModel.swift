//
//  TripListViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.08.2025.
//

import Foundation

@MainActor
final class TripListViewModel: ObservableObject {
    
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol
    
    @Published private(set) var trips: [TripModel] = []

    init(storage: TripStorage, imageStorage: ImageStorageProtocol) {
        self.storage = storage
        self.imageStorage = imageStorage
    }
        
    func loadTrips() async {
        self.trips = await storage.loadTrips()
    }
    
    func addTrip(_ trip: TripModel) async {
        await storage.saveTrip(trip)
        await loadTrips()
    }
    
    func removeTrip(_ trip: TripModel) async {
        if let url = trip.coverImage {
            imageStorage.deleteCover(at: url)
        }
        await storage.deleteTrip(trip)
        await loadTrips()
    }
    
    func hasTrips() -> Bool {
        return !trips.isEmpty
    }
}
