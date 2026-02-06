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
    var onSave: (() -> Void)?
        
    private let trip: TripModel
    private var tripViewModel: TripViewModel!
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol
    
    init(navigationController: UINavigationController, trip: TripModel, storage: TripStorage, imageStorage: ImageStorageProtocol) {
        self.navigationController = navigationController
        self.storage = storage
        self.imageStorage = imageStorage
        self.trip = trip
    }
    
    @MainActor func start() {
        let viewModel = TripViewModel(trip: trip, storage: storage, imageStorage: imageStorage)
        tripViewModel = viewModel
        
        
        let tripVC = TripViewController(viewModel: viewModel)
        tripVC.hidesBottomBarWhenPushed = true
        tripVC.delegate = self
        
        tripVC.onMapTapped = { [weak self] in
            self?.showMap()
        }
        tripVC.onSave = { [weak self] in
            if let self = self {
                self.onSave?()
            }
        }
        navigationController.pushViewController(tripVC, animated: true)
    }
    
    private func showMap() {
        let mapCoordinator = MapCoordinator(navigationController: navigationController, tripViewModel: tripViewModel, storage: storage)
        mapCoordinator.push = true
        addChild(mapCoordinator)
        
        mapCoordinator.onFinish = { [weak self, weak mapCoordinator] in
            if let coordinator = mapCoordinator {
                self?.removeChild(coordinator)
            }
        }
        mapCoordinator.start()
    }
}

extension TripCoordinator: @MainActor TripViewControllerDelegate {

    @MainActor
    func didRequestOpenEvent(event: EventModel) {
        let coordinator = EventCoordinator(
            navigationController: navigationController,
            tripViewModel: tripViewModel,
            event: event,
            startMinutes: nil,
            selectedLocationName: nil,
            coordinates: nil,
            date: event.dateEvent,
            category: nil
        )

        addChild(coordinator)

        coordinator.onFinish = { [weak self, weak coordinator] in
            if let coordinator {
                self?.removeChild(coordinator)
            }
        }

        coordinator.start()
    }

    @MainActor
    func didDropCreateEvent(event: EventModel?, category: EventCategory, dateEvent: Date, startMinutes: Int) {
        let coordinator = EventCoordinator(
            navigationController: navigationController,
            tripViewModel: tripViewModel,
            event: event ?? nil,
            startMinutes: startMinutes,
            selectedLocationName: nil,
            coordinates: nil,
            date: dateEvent,
            category: category
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

