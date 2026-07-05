//
//  TicketFileModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.07.2026.
//

import Foundation

struct TicketFileModel: Equatable {
    let id: UUID
    var fileName: String
    var relativePath: String
    var fileType: String
    var dateAdded: Date
    var eventID: UUID?
    var tripID: UUID?
}
