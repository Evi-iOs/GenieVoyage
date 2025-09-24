//
//  TripListViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.08.2025.
//

import Foundation

final class TripListViewModel {
    private let storage: TripStorage
    
    init(storage: TripStorage) {
        self.storage = storage
    }
    
    @Published private(set) var trips: [TripModel] = []
    
    func loadTrips() async {
        self.trips = await storage.loadTrips()
    }
    
    func addTrip(_ trip: TripModel) async {
        await storage.saveTrip(trip)
        await loadTrips()
    }
    
    func removeTrip(_ trip: TripModel) async {
        await storage.deleteTrip(trip)
        await loadTrips()
    }
}
