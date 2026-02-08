//
//  AuthCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.02.2026.
//

import Foundation
import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator]
    
    private let window: UIWindow
    var onFinish: (() -> Void)?
    
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = [Coordinator]()
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let signInViewController = SignInViewController()
        
        signInViewController.onLoginSuccess = { [weak self] in
            self?.onFinish?()
        }
        
        window.rootViewController = signInViewController
        window.makeKeyAndVisible()
    }
}
