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
    private var tripListViewModel: TripListViewModel?
    
    init(navigationController: UINavigationController, storage: TripStorage) {
        self.navigationController = navigationController
        self.storage = storage
    }

    func start() {
        Task { @MainActor in
            tripListViewModel = TripListViewModel(storage: storage)
            guard let tripListViewModel else { return }
            let tripListVC = TripListViewController(viewModel: tripListViewModel)
            self.tripListVC = tripListVC
            
            let image = UIImage.resizedSystemImage(named: "list.bullet.circle", scale: 1.7)
            let selectedImage = UIImage.resizedSystemImage(named: "list.bullet.circle.fill", scale: 1.7)
            
            tripListVC.tabBarItem = UITabBarItem(
                title: "Trips",
                image: image,
                selectedImage: selectedImage
            )
            tripListVC.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
            
            tripListVC.onTripSelected = { [weak self] trip in
                self?.showTripDetail(for: trip)
            }
            tripListVC.startPlanningSelected = { [weak self] in
                self?.startPlanning()
            }
            navigationController.setViewControllers([tripListVC], animated: false)
        }
    }

    private func showTripDetail(for trip: TripModel) {
        let tripCoordinator = TripCoordinator(navigationController: navigationController, trip: trip, storage: storage)
        tripCoordinator.onFinish = { [weak self] in
            self?.childCoordinators.removeAll()
            self?.tripListVC?.reloadTrips()
        }
        addChild(tripCoordinator)
        Task {
             await tripCoordinator.start()
         }
    }
    
    private func startPlanning() {
        if navigationController.viewControllers.contains(where: { $0 is StartPlanningViewController }) {
            return
        }
        guard let tripListViewModel = self.tripListViewModel else {
            fatalError("tripListViewModel should not be nil")
        }
        let startPlanningVC = StartPlanningViewController(tripListViewModel: tripListViewModel)
        startPlanningVC.hidesBottomBarWhenPushed = true
        startPlanningVC.onSave = { [weak self] newTrip in
            self?.tripListVC?.addNewTrip(trip: newTrip)
            self?.showTripDetail(for: newTrip)
        }
        startPlanningVC.onClose = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        self.navigationController.pushViewController(startPlanningVC, animated: true)
        self.navigationController.view.setNeedsLayout()
        self.navigationController.view.layoutIfNeeded()
    }
}
