//
//  TripStorage.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.08.2025.
//

import UIKit

protocol TripStorage {
    func saveTrip(_ trip: TripModel) async
    func loadTrips() async -> [TripModel]
    func deleteTrip(_ trip: TripModel) async
    
    func saveEvent(_ event: EventModel, to trip: TripModel) async
    func deleteEvent(_ event: EventModel) async
    func loadEvents(for trip: TripModel) async -> [EventModel]
    func loadEvent(byID id: UUID) async -> EventModel?
    func loadTrip(byID id: UUID) async -> TripModel?
}
