//
//  DayViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.04.2025.
//

import Foundation
import Combine
import UIKit

@MainActor
class DayViewModel: ObservableObject {
    
    @Published private(set) var events: [EventModel] = []
    
    let dateDay: Date
    let hours = (0...23).map { String(format: "%02d:00", $0) }
    
    private let calendar: Calendar
        
    init(dateDay: Date, calendar: Calendar = .current) {
        var calendar = calendar
        calendar.timeZone = .current
        self.calendar = calendar
        self.dateDay = dateDay
    }
    
    func setEvents(_ newEvents: [EventModel]) {
        events = newEvents
            .filter { calendar.isDate($0.dateEvent, inSameDayAs: dateDay) }
            .sorted { $0.startMinutes < $1.startMinutes }
    }
    
    func addEvent(_ event: EventModel) {
        guard !events.contains(where: { $0.id == event.id }) else { return }
        events.append(event)
        normalize()
    }
    
    func updateEvent(_ event: EventModel) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
        normalize()
    }
    
    func removeEvent(_ event: EventModel) {
        events.removeAll { $0.id == event.id }
    }
    
    private func normalize() {
        events.sort { $0.startMinutes < $1.startMinutes }
    }
    
    func moveEvent(_ id: UUID, byMinutes delta: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].startMinutes += delta
        events.sort(by: { $0.startMinutes < $1.startMinutes })
    }
}
