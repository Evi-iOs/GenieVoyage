//
//  TemplatesCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 25.03.2026.
//

import Foundation
import UIKit

class TemplatesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    var createTrip: ((TripTemplate) -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: TemplateListViewModel = TemplateListViewModel()
        let vc = TemplateListViewController(viewModel: viewModel)
        
        vc.onTemplateSelected = { [weak self] template in
            self?.showPreviewTemplate(template: template)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPreviewTemplate(template: TripTemplate) {
        let vc = PreviewTemplateViewController(trip: template)
        vc.hidesBottomBarWhenPushed = true
        vc.onAddTrip = { [weak self] template in
            self?.createTrip?(template)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
