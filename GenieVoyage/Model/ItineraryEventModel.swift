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
    let locationName: String?
    let coordinate: CLLocationCoordinate2D?
}

enum ItineraryItemCategory: String {
    case transport, transfer, hotel, point, food
    
    var iconSystemName: String {
        switch self {
        case .point:
            return "mappin"
        case .hotel:
            return "bed.double"
        case .food:
            return "fork.knife"
        case .transport:
            return "airplane"
        case .transfer:
            return "point.topright.arrow.triangle.backward.to.point.bottomleft.filled.scurvepath"
        }
    }
    
    var displayName: String {
        switch self {
        case .point: return "Place"
        case .hotel: return "Hotel"
        case .food: return "Food"
        case .transport: return "Transport"
        case .transfer: return "Transfer"
        }
    }
    
}
