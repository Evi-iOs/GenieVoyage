//
//  MapCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit
import CoreLocation

class MapCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var push: Bool = false
    
    var onFinish: (() -> Void)?
    var onSave: (() -> Void)?

    private let tripViewModel: TripViewModel?
    private var updateAnnotations: (() -> Void)?
    
    init(navigationController: UINavigationController, tripViewModel: TripViewModel?) {
        self.navigationController = navigationController
        self.tripViewModel = tripViewModel
    }
    
    func start() {
        let mapVC = MapEventsViewController(viewModel: tripViewModel)
        
        mapVC.onAddEventAtCoordinate = { [weak self] coordinate, selectedLocationName, dayViewModel in
            self?.showAddEventScreen(at: coordinate, selectedLocationName: selectedLocationName, forDay: dayViewModel)
        }
        mapVC.onFinish = { [weak self] in
            self?.onFinish?()
        }
        let image = UIImage.resizedSystemImage(named: "map", scale: 1.7)
        let selectedImage = UIImage.resizedSystemImage(named: "map.fill", scale: 1.7)
        
        mapVC.tabBarItem = UITabBarItem(
            title: "Map",
            image: image,
            selectedImage: selectedImage
        )
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        
        DispatchQueue.main.async {
            self.updateAnnotations = { [weak mapVC] in
                guard let mapVC = mapVC else { return }
                mapVC.updateMapForSelectedDay()
            }
        }
        if push == false  {
            navigationController.viewControllers = [mapVC]
        } else {
            navigationController.pushViewController(mapVC, animated: true)
        }
    }
    
    private func showAddEventScreen(at coordinate: CLLocationCoordinate2D?, selectedLocationName: String?, forDay dayViewModel: DayViewModel) {
        let eventCoordinator = EventCoordinator(navigationController: navigationController, eventID: nil, dayViewModel: dayViewModel, category: .point, startMinutes: nil, selectedLocationName: selectedLocationName, coordinates: coordinate)
        
        eventCoordinator.onSave = { [weak self]  in
            guard let self = self else { return }
            self.updateAnnotations?()
            self.onSave?()  
        }
    
        eventCoordinator.onFinish = { [weak self, weak eventCoordinator] in
            if let coordinator = eventCoordinator {
                self?.removeChild(coordinator)
            }
        }
        addChild(eventCoordinator)
        eventCoordinator.start()
    }
}
