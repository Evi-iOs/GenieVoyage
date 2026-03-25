//
//  MapCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit
import CoreLocation

final class MapCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var push: Bool = false

    var onFinish: (() -> Void)?

    private let tripViewModel: TripViewModel
    private let storage: TripStorage
        
    init(
        navigationController: UINavigationController,
        tripViewModel: TripViewModel,
        storage: TripStorage
    ) {
        self.navigationController = navigationController
        self.tripViewModel = tripViewModel
        self.storage = storage
    }

    func start() {
        let mapVC = MapEventsViewController(viewModel: tripViewModel)

        mapVC.onAddEventAtCoordinate = { [weak self] coordinate, locationName, date, startMinutes in
            guard let self else { return }
            Task { @MainActor in
                self.showAddEvent(
                    date: date,
                    startMinutes: startMinutes,
                    coordinate: coordinate,
                    locationName: locationName
                )
            }
        }
        
        mapVC.onSelectEvent = { [weak self] event in
            guard let self else { return }
            Task { @MainActor in
                self.showEditEvent(event)
            }
        }
        
        mapVC.onFinish = { [weak self] in
            self?.onFinish?()
        }

        if push {
            navigationController.pushViewController(mapVC, animated: true)
        } else {
            navigationController.viewControllers = [mapVC]
        }
    }
    
    @MainActor private func showEditEvent(_ event: EventModel) {
        let coordinator = EventCoordinator(navigationController: navigationController, tripViewModel: tripViewModel, event: event, startMinutes: nil, selectedLocationName: event.locationName, coordinates: event.coordinate, date: event.dateEvent, category: event.category)

        addChild(coordinator)

        coordinator.onFinish = { [weak self, weak coordinator] in
            if let coordinator {
                self?.removeChild(coordinator)
            }
        }

        coordinator.start()
    }

    // MARK: - Navigation

    @MainActor private func showAddEvent(date: Date, startMinutes: Int?, coordinate: CLLocationCoordinate2D?, locationName: String?) {
        let coordinator = EventCoordinator(navigationController: navigationController, tripViewModel: tripViewModel, event: nil, startMinutes: startMinutes, selectedLocationName: locationName, coordinates: coordinate, date: date, category: nil
        )

        addChild(coordinator)

        coordinator.onFinish = { [weak self, weak coordinator] in
            if let coordinator {
                self?.removeChild(coordinator)
            }
        }

        coordinator.start()
    }
}
