//
//  EventEditorViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//

import Foundation
import CoreLocation

protocol EventEditorConfigurable {
    
    var category: ItineraryItemCategory { get }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var duration: Int { get set }

    var locationName: String? { get }
    var coordinate: CLLocationCoordinate2D? { get }

    var existingEvent: ItineraryEventModel? { get }

    func buildEvent() -> ItineraryEventModel?
}

