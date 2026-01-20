//
//  EventEditorFactory.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//

import Foundation

enum EventEditorFactory {
    
    static func newViewModel(for category: EventCategory, startDate: Date) -> EventEditorConfigurable {
        switch category {
        case .point:
            return PointEventEditorViewModel(startDate: startDate)
        case .hotel:
            return HotelEditorViewModel(startDate: startDate)
        case .transfer:
            return TransferEditorViewModel(startDate: startDate)
        case .food:
            return FoodEditorViewModel(startDate: startDate)
        case .transport:
            return TransportEditorViewModel(startDate: startDate)
        }
    }
    
    static func editViewModel(for event: EventModel) -> EventEditorConfigurable {
        switch event.category {
        case .point:
            return PointEventEditorViewModel(existingEvent: event, startDate: event.dateEvent)
        case .hotel:
            return HotelEditorViewModel(existingEvent: event, startDate: event.dateEvent)
        case .transfer:
            return TransferEditorViewModel(existingEvent: event, startDate: event.dateEvent)
        case .food:
            return FoodEditorViewModel(existingEvent: event, startDate: event.dateEvent)
        case .transport:
            return TransportEditorViewModel(existingEvent: event, startDate: event.dateEvent)
        }
    }
}

