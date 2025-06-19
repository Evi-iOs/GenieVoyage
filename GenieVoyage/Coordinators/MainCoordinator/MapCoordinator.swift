//
//  MapCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit

class MapCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapVC = MapEventsViewController(viewModel: nil)
        
        let image = UIImage.resizedSystemImage(named: "map", scale: 1.7)
        let selectedImage = UIImage.resizedSystemImage(named: "map.fill", scale: 1.7)
        
        mapVC.tabBarItem = UITabBarItem(
            title: "Map",
            image: image,
            selectedImage: selectedImage
        )
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)

        navigationController.viewControllers = [mapVC]
    }
    
}
