//
//  DayViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.04.2025.
//

import Foundation
import UIKit

class DayViewModel {
    
    var dateDay: Date
    var events: [EventModel] = []
    let hours = (0...23).map { String(format: "%02d:00", $0) }
    
    var onUpdate: (() -> Void)?
    
    init(dateDay: Date) {
        self.dateDay = dateDay
    }
    
    func addEvent(_ event: EventModel) {
        if hasEvent(id: event.id) {
            update(event: event)
        } else {
            events.append(event)
            onUpdate?()
        }
    }
    
    func hasEvent(id: UUID) -> Bool {
        return events.contains { $0.id == id }
    }
    
    func hasEvent(at time: String) -> Bool {
        return events.contains { $0.time == time }
    }
    
    func event(at time: String) -> EventModel? {
        return events.first { $0.time == time }
    }
    
    func update(event: EventModel) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            onUpdate?()
        }
    }
    
    func moveEvent(_ id: UUID, byMinutes delta: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].startMinutes += delta
    }

    func resizeEvent(_ id: UUID, toMinutes newDuration: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].duration = newDuration
    }
    
    func removeEvent(_ eventId: EventModel) {
        events.removeAll { $0.id == eventId.id }
        onUpdate?()
    }
    
    func event(withId id: UUID) -> EventModel? {
        return events.first(where: { $0.id == id })
    }
    
    func duplicateEvent(_ event: EventModel) {
        let newId = UUID()
        let newEvent = EventModel(
            id: newId,
            category: event.category,
            icon: event.icon,
            time: event.time,
            startMinutes: event.startMinutes,
            duration: event.duration
        )
        events.append(newEvent)
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
