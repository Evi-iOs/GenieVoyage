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
class DayViewModel {
    
    @Published private(set) var events: [EventModel] = []
    
    var dateDay: Date
    let hours = (0...23).map { String(format: "%02d:00", $0) }
    
    private let storage: TripStorage
    private let trip: TripModel
    
    var onUpdate: (() -> Void)?
    
    init(dateDay: Date, storage: TripStorage, trip: TripModel) {
        self.dateDay = dateDay
        self.storage = storage
        self.trip = trip
        
        Task  {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
            let allEvents = await storage.loadEvents(for: trip)
        events = allEvents.sorted(by: { $0.startMinutes < $1.startMinutes })
        }
    
    func saveEvent(_ event: EventModel) async {
        await storage.saveEvent(event, to: trip)
        
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        } else {
            events.append(event)
        }
        
        await MainActor.run {
            self.onUpdate?()
        }
    }
    
    func deleteEvent(_ event: EventModel) async {
        await storage.deleteEvent(event)
        
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        } else {
            await loadEvents()
        }
        await MainActor.run {
            self.onUpdate?()
        }
    }
    
    func hasEvent(id: UUID) -> Bool {
        return events.contains { $0.id == id }
    }
    
    func hasEvent(at time: String) -> Bool {
        return events.contains { $0.time == time }
    }
    
    func event(withId id: UUID) -> EventModel? {
        events.first { $0.id == id }
    }
    
    func event(at time: String) -> EventModel? {
        return events.first { $0.time == time }
    }
    
    func moveEvent(_ id: UUID, byMinutes delta: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].startMinutes += delta
        let updatedEvent = events[index]
        
        Task {
            await storage.saveEvent(updatedEvent, to: trip)
        }
        onUpdate?()
    }
    
    func resizeEvent(_ id: UUID, toMinutes newDuration: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].duration = newDuration
        
        let updatedEvent = events[index]
        Task {
            await storage.saveEvent(updatedEvent, to: trip)
        }
        onUpdate?()
    }
    
    func duplicateEvent(_ event: EventModel, dateEvent: Date) {
        let newEvent = EventModel(
            id: UUID(),
            dateEvent: dateEvent,
            category: event.category,
            time: event.time,
            startMinutes: event.startMinutes,
            duration: event.duration,
            locationName: event.locationName,
            coordinate: event.coordinate,
            notes: event.notes,
            bookingLink: event.bookingLink,
            pdfFileURL: event.pdfFileURL
        )
        events.append(newEvent)
        Task {
            await storage.saveEvent(newEvent, to: trip)
        }
        onUpdate?()
    }
    
    func showOccupiedSlotAlert() {
        let alert = UIAlertController(
            title: "Time is occupied",
            message: "There is already an event added to this time slot.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        
        if let topController = topMostViewController() {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
            
            if let nav = base as? UINavigationController {
                return topMostViewController(base: nav.visibleViewController)
            }
            
            if let tab = base as? UITabBarController {
                return topMostViewController(base: tab.selectedViewController)
            }
            
            if let presented = base?.presentedViewController {
                return topMostViewController(base: presented)
            }
            return base
        }
    
    func shake(cell: UICollectionViewCell) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-6, 6, -4, 4, -2, 2, 0]
        
        cell.layer.add(animation, forKey: "shake")
    }
}
