//
//  HotelEditorViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.05.2025.
//


import Foundation
import UIKit
import CoreLocation

final class HotelEditorViewModel: EventEditorConfigurable {
    var existingEvent: EventModel?
    
    var category: EventCategory = .hotel
    var startDate = Date()
    var endDate = Date().addingTimeInterval(3600)
    
    var locationName: String?
    var coordinate: CLLocationCoordinate2D?
    var duration: Int = 0
    
    init(existingEvent: EventModel? = nil) {
        self.existingEvent = existingEvent
    }
    
    func buildEvent() -> EventModel? {
        return EventModel(
            id: existingEvent?.id ?? UUID(),
            category: .hotel,
            icon: UIImage(systemName: category.iconSystemName) ?? UIImage(systemName: "questionmark")!,
            time: DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short),
            startMinutes: Int(startDate.timeIntervalSince(Calendar.current.startOfDay(for: startDate)) / 60),
            duration: Int(endDate.timeIntervalSince(startDate)) / 60,
            locationName: locationName,
            coordinate: coordinate
        )
    }
}
