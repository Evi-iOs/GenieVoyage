//
//  TripViewControllerDelegate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 11.06.2025.
//

import Foundation

protocol TripViewControllerDelegate:  AnyObject {
    
    func didRequestOpenEvent(dayViewModel: DayViewModel, event: EventModel)
    
    func didDropEvent(dayViewModel: DayViewModel, didDropEventWith category: EventCategory, at startMinutes: Int)
}
