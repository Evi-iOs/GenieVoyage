//
//  EventCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import Foundation
import UIKit
import CoreLocation

final class EventCoordinator: @preconcurrency Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var onFinish: (() -> Void)?
    var onSave: (() -> Void)?
    
    private let dayViewModel: DayViewModel
    private let eventID: UUID?
    private let category: EventCategory?
    private let startMinutes: Int?
    private let selectedLocationName: String?
    private let coordinates: CLLocationCoordinate2D?
    
    init(navigationController: UINavigationController, eventID: UUID?, dayViewModel: DayViewModel, category: EventCategory?, startMinutes: Int?, selectedLocationName: String?, coordinates: CLLocationCoordinate2D?) {
        self.navigationController = navigationController
        self.eventID = eventID
        self.dayViewModel = dayViewModel
        self.category = category
        self.startMinutes = startMinutes
        self.selectedLocationName = selectedLocationName
        self.coordinates = coordinates
    }
    
    @MainActor func start() {
        let viewModel: EventEditorConfigurable
        var existingEvent: EventModel?
        
        if let id = eventID, let event = dayViewModel.event(withId: id) {
            existingEvent = event
            viewModel = EventEditorFactory.editViewModel(for: event)
        }
        else if let category = category {
            viewModel = EventEditorFactory.newViewModel(for: category)
        }
        else {
            assertionFailure("Invalid coordinator state: either eventID or category must be set")
            return
        }
        
        let editorVC = EventEditorViewController(viewModel: viewModel)
        editorVC.preselectedStartMinutes = startMinutes
        editorVC.selectedLocationName = selectedLocationName
        editorVC.selectedCoordinate = coordinates
        editorVC.selectedPDFURL = existingEvent?.pdfFileURL
        
        editorVC.onClose = { [weak self] in
            self?.navigationController.dismiss(animated: true) {
                self?.onFinish?()
            }
        }
        
        editorVC.onSave = { [weak self] newEvent in
            guard let self = self else { return }
            
            Task { @MainActor in
                var updatedEvent = newEvent
                
                if let startMinutes = self.startMinutes {
                    updatedEvent.startMinutes = startMinutes
                }
                
                if let name = self.selectedLocationName,
                   let coordinate = self.coordinates {
                    updatedEvent.locationName = name
                    updatedEvent.coordinate = coordinate
                }
                
                await self.dayViewModel.saveEvent(updatedEvent)
                
                self.onSave?()
                self.navigationController.dismiss(animated: true) {
                    self.onFinish?()
                }
            }
        }
        
        editorVC.onEventDeleted = { [weak self] deletedEvent in
            guard let self = self, let eventToDelete = deletedEvent else { return }
            
            Task { @MainActor in
                await self.dayViewModel.deleteEvent(eventToDelete)
                self.navigationController.dismiss(animated: true) {
                    self.onFinish?()
                }
            }
        }
        
        presentModal(viewController: editorVC)
    }
    
    // MARK: - Helpers
    private func presentModal(viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }
}
