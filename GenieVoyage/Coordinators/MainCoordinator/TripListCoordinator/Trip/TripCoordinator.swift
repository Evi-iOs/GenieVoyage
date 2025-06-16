//
//  TripCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

class TripCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var onFinish: (() -> Void)?
        
    private let trip: TripModel
    
    init(navigationController: UINavigationController, trip: TripModel) {
        self.navigationController = navigationController
        self.trip = trip
    }
    
    func start() {
        let viewModel = TripViewModel(trip: trip)
        let tripVC = TripViewController(viewModel: viewModel)
        
        tripVC.onSave = { [weak self] updatedTrip in
            viewModel.trip = updatedTrip
            
            self?.navigationController.popToRootViewController(animated: true)
            self?.onFinish?()
        }
        
        tripVC.onMapTapped = { [weak self] in
            self?.showMap(for: viewModel)
        }
        
        navigationController.pushViewController(tripVC, animated: true)
    }
    
    private func showMap(for viewModel: TripViewModel) {
        let mapVC = MapEventsViewController(viewModel: viewModel)
        navigationController.pushViewController(mapVC, animated: true)
    }
}

extension TripCoordinator: TripViewControllerDelegate {
    
    func didRequestOpenEvent(dayViewModel: DayViewModel, event: EventModel) {
        let eventCoordinator = EventCoordinator(navigationController: navigationController, event: event, dayViewModel: dayViewModel, category: nil, startMinutes: nil)
        eventCoordinator.onFinish = { [weak self, weak eventCoordinator] in
            if let coordinator = eventCoordinator {
                self?.removeChild(coordinator)
            }
        }
        addChild(eventCoordinator)
        eventCoordinator.start()
    }
    
    func didDropEvent(dayViewModel: DayViewModel, didDropEventWith category: EventCategory, at startMinutes: Int) {
        let eventCoordinator = EventCoordinator(navigationController: navigationController, event: nil, dayViewModel: dayViewModel, category: category, startMinutes: startMinutes)
        eventCoordinator.onFinish = { [weak self, weak eventCoordinator] in
            if let coordinator = eventCoordinator {
                self?.removeChild(coordinator)
            }
        }
        addChild(eventCoordinator)
        eventCoordinator.start()
    }
}
