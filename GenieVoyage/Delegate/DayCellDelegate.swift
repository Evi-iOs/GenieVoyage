//
//  DayCellDelegate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.04.2025.
//



import Foundation

protocol DayCellDelegate: AnyObject {
    
    func dayCellDidScroll(upward: Bool)
    
    func dayCell(_ cell: DayCollectionViewCell, didDropEventWith category: EventCategory, at time: String)
    
    func dayCell(_ cell: DayCollectionViewCell, didRequestAddEventAt minutes: Int)
    
    func dayCell(_ cell: DayCollectionViewCell, didRequestOpenEvent event: EventModel)
    
    func dayCellDidDeleteEvent(_ cell: DayCollectionViewCell, event: EventModel)
}
