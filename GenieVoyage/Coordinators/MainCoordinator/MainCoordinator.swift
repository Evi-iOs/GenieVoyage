//
//  MainCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = UITabBarController()

        let tripNavigation = UINavigationController()
        let tripListCoordinator = TripListCoordinator(navigationController: tripNavigation)
        tripListCoordinator.start()
        addChild(tripListCoordinator)

        let mapNavigation = UINavigationController()
        let mapCoordinator = MapCoordinator(navigationController: mapNavigation)
        mapCoordinator.start()
        addChild(mapCoordinator)

        tabBarController.viewControllers = [tripNavigation, mapNavigation]

        navigationController.viewControllers = [tabBarController]
    }
}


