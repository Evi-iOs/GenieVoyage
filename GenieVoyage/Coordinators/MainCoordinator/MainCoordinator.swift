//
//  MainCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator, TabBarControlling {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private var tabBarController = UITabBarController()


    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.selectedIndex = 0

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
    
    func setTabBar(hidden: Bool, animated: Bool) {
            let tabBar = tabBarController.tabBar
            let height = tabBar.frame.size.height
            let offsetY = hidden ? height : -height
            
            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
                tabBar.alpha = hidden ? 0 : 1
            }
        }
}


