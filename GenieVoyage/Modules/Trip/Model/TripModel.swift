//
//  Untitled.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.11.2024.
//

import Foundation
import CoreLocation

struct TripModel {
    var id: UUID
    var title: String
    var description: String?
    var startDate: Date
    var endDate: Date
    var notes: String?
    var coverImage: URL?
    var events: [EventModel]?
}


//TO DO next Version:

// Trip:
// budget: Double? — бюджет поездки.
// travelers: [String] — список участников поездки.
// transportMode: String? — способ передвижения (авиа, авто, поезд).
// isFavorite: Bool — флаг избранной поездки.

// Destination:
// address: String? — полный адрес места.
// images: [URL] — список изображений, связанных с местом.
// cost: Double? — предполагаемые расходы (например, входной билет).
// category: String? — категория места (музей, ресторан, отель).
// visited: Bool — флаг, было ли место посещено.
