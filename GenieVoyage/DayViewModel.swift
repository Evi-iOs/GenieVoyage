//
//  DayViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.04.2025.
//

import Foundation

class DayViewModel {
    
    var dateDay: Date
    var events: [ItineraryEventModel] = []
    let hours = (0...23).map { String(format: "%02d:00", $0) }
    
    var onUpdate: (() -> Void)?
    
    init(dateDay: Date) {
        self.dateDay = dateDay
    }
    
    func addEvent(_ event: ItineraryEventModel) {
        //TODO: alert / ask user
       // guard !events.contains(where: { $0.time == event.time }) else { return }
        events.append(event)
        onUpdate?()
    }
    
    func events(at time: String) -> [ItineraryEventModel] {
        return events.filter { $0.time == time }
    }
}
