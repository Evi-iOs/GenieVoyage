//
//  PointEventEditorViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//

import Foundation
import UIKit
import CoreLocation

final class PointEventEditorViewModel: EventEditorConfigurable {
    
    var existingEvent: EventModel?
    let eventID: UUID
    
    var category: EventCategory = .point
    let startDate: Date
    var endDate = Date().addingTimeInterval(3600)
    
    var locationName: String?
    var coordinate: CLLocationCoordinate2D?
    var duration: Int = 0
    
    init(existingEvent: EventModel? = nil, startDate: Date) {
        self.existingEvent = existingEvent
        self.startDate = startDate
        self.eventID = existingEvent?.id ?? UUID()
    }
    
    func buildEvent() -> EventModel? {
        return EventModel(
            id: eventID,
            dateEvent: startDate,
            category: .point,
            time: DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short),
            startMinutes: Int(startDate.timeIntervalSince(Calendar.current.startOfDay(for: startDate)) / 60),
            duration: Int(endDate.timeIntervalSince(startDate) / 60),
            locationName: locationName,
            coordinate: coordinate
        )
    }
}
