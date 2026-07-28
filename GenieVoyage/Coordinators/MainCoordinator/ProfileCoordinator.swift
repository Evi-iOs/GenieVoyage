//
//  SettingsCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let tripStorage: TripStorage
    private let ticketStorage: TicketFileStorage
    
    init(navigationController: UINavigationController, tripStorage: TripStorage, ticketStorage: TicketFileStorage) {
        self.navigationController = navigationController
        self.ticketStorage = ticketStorage
        self.tripStorage = tripStorage
    }
    
    func start() {
        let viewModel = ProfileViewModel(tripStorage: tripStorage, ticketFileStorage: ticketStorage)
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }
}
