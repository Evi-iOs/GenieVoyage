//
//  TripListCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

class TripListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
        
    private var tripListVC: TripListViewController?
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol
    private var tripListViewModel: TripListViewModel?
    
    init(navigationController: UINavigationController, storage: TripStorage, imageStorage: ImageStorageProtocol) {
        self.navigationController = navigationController
        self.imageStorage = imageStorage
        self.storage = storage
    }

    func start() {
        Task { @MainActor in
            self.tripListViewModel = TripListViewModel(storage: storage, imageStorage: imageStorage)
            showTripList()
        }
    }
    
    private func showTripList() {
        Task { @MainActor in
            guard let tripListViewModel else { return }
            let tripListVC = TripListViewController(viewModel: tripListViewModel)
            self.tripListVC = tripListVC
            
            tripListVC.onTripSelected = { [weak self] trip in
                self?.showTripDetail(for: trip)
            }
            navigationController.setViewControllers([tripListVC], animated: false)
        }
    }

    private func showTripDetail(for trip: TripModel) {
        let tripCoordinator = TripCoordinator(navigationController: navigationController, trip: trip, storage: storage, imageStorage: imageStorage)
        tripCoordinator.onSave = { [weak self] in
            self?.tripListVC?.reloadTrips()
            
            guard var stack = self?.navigationController.viewControllers else { return }
            stack.removeAll { $0 is StartPlanningViewController }
            self?.navigationController.setViewControllers(stack, animated: false)
        }
        tripCoordinator.onFinish = { [weak self] in
            self?.childCoordinators.removeAll()
            self?.tripListVC?.reloadTrips()
        }
        addChild(tripCoordinator)
        Task {
             await tripCoordinator.start()
         }
    }
    
    func startPlanning(template: TripTemplate?) {
        if navigationController.viewControllers.contains(where: { $0 is StartPlanningViewController }) {
            return
        }
        guard let tripListViewModel = self.tripListViewModel else {
            fatalError("tripListViewModel should not be nil")
        }
        let startPlanningVC = StartPlanningViewController(tripListViewModel: tripListViewModel)
        startPlanningVC.template = template
        
        startPlanningVC.hidesBottomBarWhenPushed = true
        startPlanningVC.onSave = { [weak self] newTrip in
            self?.tripListVC?.addNewTrip(trip: newTrip)
            self?.showTripDetail(for: newTrip)
        }
        startPlanningVC.onClose = { 
            startPlanningVC.dismiss(animated: true)
        }
        
        self.navigationController.present(startPlanningVC, animated: true)
        
        self.navigationController.view.setNeedsLayout()
        self.navigationController.view.layoutIfNeeded()
    }
}
