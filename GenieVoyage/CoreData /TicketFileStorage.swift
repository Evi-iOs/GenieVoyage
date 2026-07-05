//
//  TicketFileStorage.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.07.2026.
//

import Foundation

protocol TicketFileStorage {
    func saveFile(from sourceURL: URL, eventID: UUID?, tripID: UUID?) async -> TicketFileModel?
    func loadAllFiles() async -> [TicketFileModel]
    func loadFiles(forEventID eventID: UUID) async -> [TicketFileModel]
    func loadFiles(forTripID tripID: UUID) async -> [TicketFileModel]
    func deleteFile(_ file: TicketFileModel) async
    func absoluteURL(for file: TicketFileModel) -> URL
}

