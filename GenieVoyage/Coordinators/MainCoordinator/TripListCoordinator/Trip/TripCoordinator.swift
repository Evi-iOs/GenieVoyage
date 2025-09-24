//
//  TripCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

class TripCoordinator: @preconcurrency Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var onFinish: (() -> Void)?
        
    private let trip: TripModel
    private var tripViewController: TripViewController?
    private let storage: TripStorage
    
    init(navigationController: UINavigationController, trip: TripModel, storage: TripStorage) {
        self.navigationController = navigationController
        self.storage = storage
        self.trip = trip
    }
    
    @MainActor func start() {
        let viewModel = TripViewModel(trip: trip, storage: storage)
        let tripVC = TripViewController(viewModel: viewModel)
        tripVC.hidesBottomBarWhenPushed = true
        tripVC.delegate = self
        self.tripViewController = tripVC
        
//        tripVC.onSave = { [weak self] updatedTrip in
//            viewModel.trip = updatedTrip
//            
//            self?.navigationController.popToRootViewController(animated: true)
//            self?.onFinish?()
//        }
        
        tripVC.onMapTapped = { [weak self] in
            self?.showMap(for: viewModel)
        }
        navigationController.pushViewController(tripVC, animated: true)
    }
    
    private func showMap(for viewModel: TripViewModel) {
        let mapCoordinator = MapCoordinator(navigationController: navigationController, tripViewModel: viewModel, storage: storage)
        mapCoordinator.push = true
        addChild(mapCoordinator)
        
        mapCoordinator.onSave = { [weak self] in
            guard let self = self else { return }
            self.tripViewController?.reloadItinerary()
        }
        mapCoordinator.onFinish = { [weak self, weak mapCoordinator] in
            if let coordinator = mapCoordinator {
                self?.removeChild(coordinator)
            }
        }
        mapCoordinator.start()
    }
}

extension TripCoordinator: @preconcurrency TripViewControllerDelegate {
    
    @MainActor func didRequestOpenEvent(dayViewModel: DayViewModel, event: EventModel) {
        let eventCoordinator = EventCoordinator(navigationController: navigationController, eventID: event.id, dayViewModel: dayViewModel, category: nil, startMinutes: nil, selectedLocationName: nil, coordinates: nil)
        eventCoordinator.onFinish = { [weak self, weak eventCoordinator] in
            if let coordinator = eventCoordinator {
                self?.removeChild(coordinator)
            }
        }
        addChild(eventCoordinator)
        eventCoordinator.start()
    }
    
    @MainActor func didDropEvent(dayViewModel: DayViewModel, didDropEventWith category: EventCategory, at startMinutes: Int) {
        let eventCoordinator = EventCoordinator(navigationController: navigationController, eventID: nil, dayViewModel: dayViewModel, category: category, startMinutes: startMinutes, selectedLocationName: nil, coordinates: nil)
        eventCoordinator.onFinish = { [weak self, weak eventCoordinator] in
            if let coordinator = eventCoordinator {
                self?.removeChild(coordinator)
            }
        }
        addChild(eventCoordinator)
        eventCoordinator.start()
    }
}
