//
//  AppCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 22.08.2025.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    
    private var mainCoordinator: MainCoordinator?
    private let imageStorage: ImageStorageProtocol
    private let storage: CoreDataTripStorage
    private var childCoordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.imageStorage = ImageStorage.shared
        self.storage = CoreDataTripStorage(imageStorage: imageStorage)
    }
    
    func start() {
        if !hasSeenOnboarding {
            showOnboarding()
        } else {
            showMain()
        }
    }
    
    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(window: window)
        coordinator.onFinish = { [weak self] in
            guard let self else { return }
            UserDefaults.standard.set(true, forKey: Keys.hasSeenOnboarding)
            self.start()
        }
        childCoordinator = coordinator
        coordinator.start()
    }
    
    private func showMain() {
        let coordinator = MainCoordinator(window: window, storage: storage, imageStorage: imageStorage)
        childCoordinator = coordinator
        coordinator.start()
    }
    
    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
    }
    
    //NEXT Version
//    private func showAuth() {
//        let coordinator = AuthCoordinator(window: window)
//        
//        coordinator.onFinish = { [weak self] in
//            guard let self else { return }
//            UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
//            self.start()
//        }
//        childCoordinator = coordinator
//        coordinator.start()
//    }
//    
//    private var isLoggedIn: Bool {
//        UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
//    }
    
}

private enum Keys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let isLoggedIn = "isLoggedIn"
}
