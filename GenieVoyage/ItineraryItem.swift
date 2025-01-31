//
//  Item.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 17.01.2025.
//

import Foundation
import UIKit

struct TripDay {
    let date: String
    let itineraryItems: [ItineraryItem]
}

struct ItineraryItem {
    let time: String
    let title: String
    let icon: UIImage?
}
