//
//  SettingsCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.06.2025.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let tripStorage: TripStorage
    private let ticketStorage: TicketFileStorage
    
    init(navigationController: UINavigationController, tripStorage: TripStorage, ticketStorage: TicketFileStorage) {
        self.navigationController = navigationController
        self.ticketStorage = ticketStorage
        self.tripStorage = tripStorage
    }
    
    func start() {
        let viewModel = ProfileViewModel(tripStorage: tripStorage, ticketFileStorage: ticketStorage)
        let vc = ProfileViewController(viewModel: viewModel)
        
        vc.onPersonalInfoTapped = { [weak self] in self?.showPersonalInfo() }
        vc.onPreferencesTapped = { [weak self] in self?.showPreferences() }
        vc.onExportDataTapped = { [weak self] in self?.showExportData() }
        vc.onHelpTapped = { [weak self] in self?.showHelpSupport() }
        vc.onPrivacyPolicyTapped = { [weak self] in self?.showPrivacyPolicy() }
        vc.onTermsTapped = { [weak self] in self?.showTerms() }
        
        navigationController.viewControllers = [vc]
    }
    
    private func showPersonalInfo() {
        let vc = PersonalInfoViewController(viewModel: PersonalInfoViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPreferences() {
        let vc = PreferencesViewController(viewModel: PreferencesViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showExportData() {
        let viewModel = ExportDataViewModel(tripStorage: tripStorage, ticketFileStorage: ticketStorage)
        let vc = ExportDataViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showHelpSupport() {
        let vc = HelpSupportViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPrivacyPolicy() {
        let vc = LegalDocumentViewController(title: "Privacy Policy", content: LegalContent.privacyPolicy)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showTerms() {
        let vc = LegalDocumentViewController(title: "Terms of Use", content: LegalContent.termsOfUse)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}
