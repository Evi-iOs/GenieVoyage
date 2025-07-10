//
//  SettingsCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProfileViewController()
        navigationController.viewControllers = [vc]
        
        let image = UIImage.resizedSystemImage(named: "person.crop.circle", scale: 1.7)
        let selectedImage = UIImage.resizedSystemImage(named: "person.crop.circle.fill", scale: 1.7)
        
        vc.tabBarItem = UITabBarItem(
            title: "Profile",
            image: image,
            selectedImage: selectedImage
        )
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        
    }
}
