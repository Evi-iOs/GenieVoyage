//
//  DayCellDelegate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.04.2025.
//



import Foundation

protocol DayCellDelegate: AnyObject {
    func dayCellDidScroll(upward: Bool)
    func dayCell(_ cell: DayCell, didDropEventWith category: ItineraryItemCategory, at time: String)
}
