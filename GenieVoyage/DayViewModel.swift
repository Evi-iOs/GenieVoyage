//
//  DayViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.04.2025.
//

import Foundation

class DayViewModel {
    var dateDay: Date
    
    init(dateDay: Date) {
        self.dateDay = dateDay
    }
    
    var events: [ItineraryEventModel] = []
    
    var onUpdate: (() -> Void)?

    func addEvent(_ event: ItineraryEventModel) {
        events.append(event)
        onUpdate?()
    }
}
