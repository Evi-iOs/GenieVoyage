//
//  Item.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 17.01.2025.
//

import Foundation
import UIKit
import CoreLocation

struct TripDay {
    let date: String
    let itineraryEvents: [ItineraryEventModel]
}

struct ItineraryEventModel {
    let id: UUID
    let category: ItineraryItemCategory
    let icon: UIImage
    let time: String
    let duration: Int
    let location: CLLocationCoordinate2D?
}

enum ItineraryItemCategory: String {
    case transport, transfer, hotel, point, food
}
