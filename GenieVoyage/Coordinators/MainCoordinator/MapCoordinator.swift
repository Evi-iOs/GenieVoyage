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
        let mapVC = MapLocationViewController()
    }
    
}
