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

    private var tabBarController = CustomTabBarController()

    private let window: UIWindow
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol

    init(window: UIWindow, storage: TripStorage, imageStorage: ImageStorageProtocol) {
        self.window = window
        self.navigationController = UINavigationController()
        self.storage = storage
        self.imageStorage = imageStorage
    }

    func start() {
        let tripNavigation     = UINavigationController()
        let savedNavigation    = UINavigationController()
        let mapNavigation      = UINavigationController()
        let profileNavigation  = UINavigationController()
        
        let tripListCoordinator = TripListCoordinator(
            navigationController: tripNavigation,
            storage: storage,
            imageStorage: imageStorage
        )
        let settingsCoordinator = SettingsCoordinator(navigationController: profileNavigation)

        addChild(tripListCoordinator)
        addChild(settingsCoordinator)

        tabBarController.viewControllers = [
            tripNavigation,
            savedNavigation,
            mapNavigation,
            profileNavigation
        ]

        // FAB action
        tabBarController.onFABTap = {
            tripListCoordinator.startPlanning(template: nil)
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [tabBarController]

        tripListCoordinator.start()
        settingsCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func setTabBar(hidden: Bool, animated: Bool) {
        tabBarController.setCustomTabBar(hidden: hidden, animated: animated)
    }
}


