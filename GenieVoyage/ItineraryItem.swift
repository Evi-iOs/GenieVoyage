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
    let itineraryItems: [ItineraryItem]
}

struct ItineraryItem {
    let time: String
   // let endTime: String?
    let title: String
   // let location: CLLocationCoordinate2D?
    let icon: UIImage?
}

enum ItineraryItemCategory: String {
    case transport, transfer, hotel, point, food
}
