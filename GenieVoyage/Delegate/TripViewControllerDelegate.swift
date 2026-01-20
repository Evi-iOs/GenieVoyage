//
//  TripViewControllerDelegate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 11.06.2025.
//

import Foundation

protocol TripViewControllerDelegate:  AnyObject {
    
    func didRequestOpenEvent(event: EventModel)
    
    func didDropCreateEvent(event: EventModel?, category: EventCategory, dateEvent: Date, startMinutes: Int)
}
