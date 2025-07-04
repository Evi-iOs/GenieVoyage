//
//  EventCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit
import CoreLocation

class EventCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    var onSave: (() -> Void)?
    
    private var dayViewModel: DayViewModel
    private var event: EventModel?
    private var category: EventCategory?
    private var startMinutes: Int?
    private var selectedLocationName: String?
    private var coordinates: CLLocationCoordinate2D?
    
    init(navigationController: UINavigationController, event: EventModel?, dayViewModel: DayViewModel, category: EventCategory?, startMinutes: Int?, selectedLocationName: String?, coordinates: CLLocationCoordinate2D?) {
        self.navigationController = navigationController
        self.event = event
        self.dayViewModel = dayViewModel
        self.category = category
        self.startMinutes = startMinutes
        self.selectedLocationName = selectedLocationName
        self.coordinates = coordinates
    }
    
    func start() {
        let viewModel: EventEditorConfigurable

        if let event = event {
            viewModel = EventEditorFactory.editViewModel(for: event)
        } else if let category = category {
            viewModel = EventEditorFactory.newViewModel(for: category)
        } else {
            assertionFailure("Invalid coordinator state: either event or category/startMinutes must be set")
            return
        }

        let editorVC = EventEditorViewController(viewModel: viewModel)
        editorVC.preselectedStartMinutes = startMinutes
        editorVC.selectedLocationName = selectedLocationName
        editorVC.selectedCoordinate = coordinates
        editorVC.selectedPDFURL = event?.pdfFileURL

        editorVC.onClose = { [weak self] in
            self?.navigationController.dismiss(animated: true) {
                self?.onFinish?()
            }
        }

        editorVC.onSave = { [weak self] newEvent in
            var updatedEvent = newEvent
            if let startMinutes = self?.startMinutes {
                updatedEvent.startMinutes = startMinutes
            }
            if let selectedLocationName = self?.selectedLocationName, let coordinate = self?.coordinates {
                updatedEvent.locationName = selectedLocationName
                updatedEvent.coordinate = coordinate
            }
            self?.dayViewModel.addEvent(updatedEvent)
            
            self?.onSave?()
            
            self?.navigationController.dismiss(animated: true) {
                self?.onFinish?()
            }
        }
        
        editorVC.onEventDeleted = { [weak self] deleteEvent in
            if let eventToDelete = deleteEvent {
                self?.dayViewModel.removeEvent(eventToDelete)
            }
            self?.navigationController.dismiss(animated: true) {
                self?.onFinish?()
            }
        }
        presentModal(viewController: editorVC)
    }

    private func presentModal(viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }
}

