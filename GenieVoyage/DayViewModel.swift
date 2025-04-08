//
//  DayViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.04.2025.
//

import Foundation

class DayViewModel {
    
    var dateDay: Date
    var events: [String: ItineraryEventModel] = [:]
    let hours = (8...23).map { String(format: "%02d:00", $0) }
    init(dateDay: Date) {
        self.dateDay = dateDay
    }
    
    var onUpdate: (() -> Void)?

    func addEvent(_ event: ItineraryEventModel) {
        events[event.time] = event
        onUpdate?()
    }
}
