//
//  TransferEditorViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.05.2025.
//

import Foundation
import UIKit
import CoreLocation

final class TransferEditorViewModel: EventEditorConfigurable {
    var existingEvent: EventModel?
    
    var category: EventCategory = .transfer
    let startDate: Date
    var endDate = Date().addingTimeInterval(3600)
    
    var locationName: String?
    var coordinate: CLLocationCoordinate2D?
    var duration: Int = 0
    
    init(existingEvent: EventModel? = nil, startDate: Date) {
        self.existingEvent = existingEvent
        self.startDate = startDate
    }
    
    func buildEvent() -> EventModel? {
        return EventModel(
            id: existingEvent?.id ?? UUID(),
            dateEvent: startDate,
            category: .transfer,
            time: DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short),
            startMinutes: Int(startDate.timeIntervalSince(Calendar.current.startOfDay(for: startDate)) / 60),
            duration: Int(endDate.timeIntervalSince(startDate)) / 60,
            locationName: locationName,
            coordinate: coordinate
        )
    }
}
