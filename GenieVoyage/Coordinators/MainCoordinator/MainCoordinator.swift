//
//  MainCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator, TabBarControlling {
    
    var navigationController: UINavigationController = UINavigationController()
    
    var childCoordinators = [Coordinator]()

    private var tabBarController = CustomTabBarController()

    private let window: UIWindow
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol

    init(window: UIWindow, storage: TripStorage, imageStorage: ImageStorageProtocol) {
        self.window = window
        self.storage = storage
        self.imageStorage = imageStorage
    }

    func start() {
        let templatesNavigation = UINavigationController()
        let tripNavigation = UINavigationController()
        let profileNavigation = UINavigationController()
        
        let templatesCoordinator = TemplatesCoordinator(navigationController: templatesNavigation)
        let tripListCoordinator = TripListCoordinator(navigationController: tripNavigation, storage: storage, imageStorage: imageStorage)
        let settingsCoordinator = SettingsCoordinator(navigationController: profileNavigation)

        addChild(templatesCoordinator)
        addChild(tripListCoordinator)
        addChild(settingsCoordinator)

        tabBarController.viewControllers = [templatesNavigation, tripNavigation, profileNavigation]

        // FAB action
        tabBarController.onFABTap = {
            tripListCoordinator.startPlanning(template: nil)
        }

        templatesCoordinator.start()
        tripListCoordinator.start()
        settingsCoordinator.start()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func setTabBar(hidden: Bool, animated: Bool) {
        tabBarController.setCustomTabBar(hidden: hidden, animated: animated)
    }
}


