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
    let itineraryEvents: [EventModel]
}

struct EventModel {
    let id: UUID
    let category: EventCategory
    let icon: UIImage
    let time: String
    var startMinutes: Int
    var duration: Int
    var locationName: String?
    var coordinate: CLLocationCoordinate2D?
}

let allCases: [EventCategory] = [.transport, .transfer, .hotel, .point, .food]

enum EventCategory: String, CaseIterable {
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
    
    var color: UIColor {
        switch self {
        case .point: return .systemBlue
        case .hotel: return .systemGreen
        case .food: return .systemOrange
        case .transport: return .systemPurple
        case .transfer: return .systemPink
        }
    }
}

extension EventModel {
    var startTimeEvent: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.date(byAdding: .minute, value: startMinutes, to: today)!

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

