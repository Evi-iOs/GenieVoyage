//
//  DayCellDelegate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.04.2025.
//



import Foundation

protocol DayCellDelegate: AnyObject {
    func dayCell(didMove event: EventModel, byMinutes delta: Int)
    func dayCell(didResize event: EventModel, toMinutes duration: Int)
    func dayCell(didDuplicate event: EventModel)
    func dayCell(didDelete event: EventModel)
    func dayCell(didRequestOpenEvent event: EventModel)
    func dayCell(_ cell: DayCollectionViewCell, didRequestAddEventAt startMinutes: Int)
    func dayCellDidScroll(upward: Bool)
    func dayCell(didDropEventWith category: EventCategory, dateEvent: Date, at time: String)
}

