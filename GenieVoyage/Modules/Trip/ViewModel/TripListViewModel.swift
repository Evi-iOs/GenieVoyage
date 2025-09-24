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
    
    @Published private(set) var trips: [TripModel] = []

    init(storage: TripStorage) {
        self.storage = storage
    }
        
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
