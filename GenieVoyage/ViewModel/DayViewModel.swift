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
    var events: [ItineraryEventModel] = []
    let hours = (0...23).map { String(format: "%02d:00", $0) }
    
    var onUpdate: (() -> Void)?
    
    init(dateDay: Date) {
        self.dateDay = dateDay
    }
    
    func addEvent(_ event: ItineraryEventModel) {
        events.append(event)
        onUpdate?()
    }
    
    func hasEvent(at time: String) -> Bool {
        return events.contains { $0.time == time }
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
    
    func makeDropViewController(category: ItineraryItemCategory, time: String, onSave: @escaping (ItineraryEventModel) -> Void) -> UIViewController {
        switch category {
        case .point:
            let pointVC = PointViewController()
            pointVC.preselectedTime = time
            pointVC.selectedCategory = .point
            pointVC.onSave = onSave
            return pointVC
        case .hotel:
            let hotelVC = PointViewController()
            hotelVC.preselectedTime = time
            hotelVC.selectedCategory = .hotel
            hotelVC.onSave = onSave
            return hotelVC
        case .food:
            let foodVC = PointViewController()
            foodVC.preselectedTime = time
            foodVC.selectedCategory = .food
            foodVC.onSave = onSave
            return foodVC
        case .transport:
            let pointVC = PointViewController()
            pointVC.preselectedTime = time
            pointVC.selectedCategory = .transport
            pointVC.onSave = onSave
            return pointVC
        case .transfer:
            let pointVC = PointViewController()
            pointVC.preselectedTime = time
            pointVC.selectedCategory = .transfer
            pointVC.onSave = onSave
            return pointVC
        }
    }
}
