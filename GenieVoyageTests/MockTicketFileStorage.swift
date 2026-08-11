//
//  MockTicketFileStorage.swift
//  GenieVoyageTests
//
//  Created by Evgeniya  Iv on 11.08.2026.
//

import XCTest
@testable import GenieVoyage

final class MockTicketFileStorage: TicketFileStorage {
    
    var files: [TicketFileModel] = []
    var deletedFileIDs: [UUID] = []
    
    func saveFile(from sourceURL: URL, eventID: UUID?, tripID: UUID?) async -> TicketFileModel? {
        let file = TicketFileModel(
            id: UUID(),
            fileName: sourceURL.lastPathComponent,
            relativePath: "Tickets/\(sourceURL.lastPathComponent)",
            fileType: sourceURL.pathExtension.lowercased() == "pdf" ? "pdf" : "image",
            dateAdded: Date(),
            eventID: eventID,
            tripID: tripID
        )
        files.append(file)
        return file
    }
    
    func loadAllFiles() async -> [TicketFileModel] {
        files.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func loadFiles(forEventID eventID: UUID) async -> [TicketFileModel] {
        files.filter { $0.eventID == eventID }
    }
    
    func loadFiles(forTripID tripID: UUID) async -> [TicketFileModel] {
        files.filter { $0.tripID == tripID }
    }
    
    func deleteFile(_ file: TicketFileModel) async {
        files.removeAll { $0.id == file.id }
        deletedFileIDs.append(file.id)
    }
    
    func absoluteURL(for file: TicketFileModel) -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent(file.relativePath)
    }
}

final class MockTripStorage: TripStorage {
    
    var events: [UUID: EventModel] = [:]
    var trips: [UUID: TripModel] = [:]
    
    func saveTrip(_ trip: TripModel) async { trips[trip.id] = trip }
    func loadTrips() async -> [TripModel] { Array(trips.values) }
    func deleteTrip(_ trip: TripModel) async { trips[trip.id] = nil }
    
    func saveEvent(_ event: EventModel, to trip: TripModel) async { events[event.id] = event }
    func loadEvents(for trip: TripModel) async -> [EventModel] { Array(events.values) }
    func loadEvents(for trip: TripModel, on date: Date) async -> [EventModel] { [] }
    func deleteEvent(_ event: EventModel) async { events[event.id] = nil }
    
    func loadEvent(byID id: UUID) async -> EventModel? { events[id] }
    func loadTrip(byID id: UUID) async -> TripModel? { trips[id] }
}
