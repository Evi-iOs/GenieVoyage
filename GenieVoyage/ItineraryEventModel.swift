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
    let time: String
    let category: ItineraryItemCategory
    let title: String
    let icon: UIImage?
    let duration: TimeInterval?
    let address: String?
}

enum ItineraryItemCategory: String {
    case transport, transfer, hotel, point, food
}
