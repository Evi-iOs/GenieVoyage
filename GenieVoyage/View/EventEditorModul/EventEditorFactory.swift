//
//  EventEditorFactory.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//

import Foundation

enum EventEditorFactory {
    
    static func newViewModel(for category: ItineraryItemCategory) -> EventEditorConfigurable {
        switch category {
        case .point:
            return PointEventEditorViewModel()
        case .hotel:
            return HotelEditorViewModel()
        case .transfer:
            return TransferEditorViewModel()
        case .food:
            return FoodEditorViewModel()
        case .transport:
            return TransportEditorViewModel()
        }
    }
    
    static func editViewModel(for event: ItineraryEventModel) -> EventEditorConfigurable {
        switch event.category {
        case .point:
            return PointEventEditorViewModel(existingEvent: event)
        case .hotel:
            return HotelEditorViewModel(existingEvent: event)
        case .transfer:
            return TransferEditorViewModel(existingEvent: event)
        case .food:
            return FoodEditorViewModel(existingEvent: event)
        case .transport:
            return TransportEditorViewModel(existingEvent: event)
        }
    }
}

