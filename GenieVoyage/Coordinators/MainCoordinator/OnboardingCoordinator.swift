//
//  OnboardingCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.02.2026.
//

import Foundation
import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    var onFinish: (() -> Void)?
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.childCoordinators = [Coordinator]()
        self.window = window
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.onStartTapped = { [weak self] in
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            self?.onFinish?()
        }
        window.rootViewController = onboardingVC
        window.makeKeyAndVisible()
    }
}
