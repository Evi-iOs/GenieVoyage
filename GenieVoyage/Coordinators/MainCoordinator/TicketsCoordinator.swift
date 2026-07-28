//
//  TicketsCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.04.2026.
//

import Foundation
import UIKit

class TicketsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let tripStorage: TripStorage
    private let ticketFileStorage: CoreDataTicketFileStorage

    init(navigationController: UINavigationController, tripStorage: TripStorage, ticketFileStorage: CoreDataTicketFileStorage) {
        self.navigationController = navigationController
        self.tripStorage = tripStorage
        self.ticketFileStorage = ticketFileStorage
    }
    
    func start() {
        let viewModel = TicketsViewModel(ticketFileStorage: ticketFileStorage, tripStorage: self.tripStorage)
        let vc = TicketsViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }
}
