//
//  ExportDataViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import Foundation

final class ExportDataViewModel {
    
    private let tripStorage: TripStorage
    private let ticketFileStorage: TicketFileStorage
    
    init(tripStorage: TripStorage, ticketFileStorage: TicketFileStorage) {
        self.tripStorage = tripStorage
        self.ticketFileStorage = ticketFileStorage
    }
    
    @MainActor
    func generateReport() async -> URL? {
        let trips = await tripStorage.loadTrips()
        let files = await ticketFileStorage.loadAllFiles()
        return PDFReportGenerator.generate(trips: trips, ticketsCount: files.count)
    }
}
