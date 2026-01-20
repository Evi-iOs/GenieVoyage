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
    var childCoordinators = [Coordinator]()
    
    private var tabBarController = UITabBarController()
    private let window: UIWindow
    private let storage: TripStorage
    
    init(window: UIWindow, storage: TripStorage) {
        self.window = window
        self.navigationController = UINavigationController()
        self.storage = storage
    }
    
    func start() {
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.selectedIndex = 0
        
        let tripNavigation = UINavigationController()
        let mapNavigation = UINavigationController()
        let profileNavigation = UINavigationController()
        
        let tripListCoordinator = TripListCoordinator(navigationController: tripNavigation, storage: storage)
//        let mapCoordinator = MapCoordinator(navigationController: mapNavigation, tripViewModel: nil, storage: storage)
        let settingsCoordinator = SettingsCoordinator(navigationController: profileNavigation)
        
        addChild(tripListCoordinator)
        addChild(settingsCoordinator)
        addChild(settingsCoordinator)
        
        tabBarController.viewControllers = [tripNavigation, mapNavigation, profileNavigation]
        
        navigationController.viewControllers = [tabBarController]
        
        tripListCoordinator.start()
        settingsCoordinator.start()
        settingsCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
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
