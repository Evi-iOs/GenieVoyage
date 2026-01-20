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
    
    private let tripViewModel: TripViewModel
    private let event: EventModel?
    private let startMinutes: Int?
    private let selectedLocationName: String?
    private let coordinates: CLLocationCoordinate2D?
    private let date: Date
    private let category: EventCategory?
    
    init(navigationController: UINavigationController, tripViewModel: TripViewModel, event: EventModel?, startMinutes: Int?, selectedLocationName: String?, coordinates: CLLocationCoordinate2D?, date: Date, category: EventCategory?) {
        self.navigationController = navigationController
        self.tripViewModel = tripViewModel
        self.event = event
        self.startMinutes = startMinutes
        self.selectedLocationName = selectedLocationName
        self.date = date
        self.coordinates = coordinates
        self.category = category
    }
    
    @MainActor func start() {
        let editorViewModel: EventEditorConfigurable
        let existingEvent = event
        
        if let event {
            editorViewModel = EventEditorFactory.editViewModel(for: event)
        }
        else  {
            editorViewModel = EventEditorFactory.newViewModel(for: category ?? .point, startDate: date)
        }
        
        let editorVC = EventEditorViewController(viewModel: editorViewModel)
        editorVC.preselectedStartMinutes = startMinutes
        editorVC.selectedLocationName = selectedLocationName
        editorVC.selectedCoordinate = coordinates
        editorVC.selectedPDFURL = existingEvent?.pdfFileURL
        
        editorVC.onClose = { [weak self] in
            self?.dismiss()
        }
        
        editorVC.onSave = { [weak self] newEvent in
            guard let self = self else { return }
            
            Task { @MainActor in
                var updatedEvent = newEvent
                
                if let startMinutes = self.startMinutes {
                    updatedEvent.startMinutes = startMinutes
                }
                
                updatedEvent.dateEvent = self.date
                
                if let name = self.selectedLocationName,
                   let coordinate = self.coordinates {
                    updatedEvent.locationName = name
                    updatedEvent.coordinate = coordinate
                }
                
                if self.event == nil {
                    await self.tripViewModel.addEvent(updatedEvent)
                } else {
                    await self.tripViewModel.updateEvent(updatedEvent)
                }
                self.dismiss()
            }
        }
        
        editorVC.onEventDeleted = { [weak self] deletedEvent in
            guard let self = self, let eventToDelete = deletedEvent else { return }
            
            Task { @MainActor in
                await self.tripViewModel.deleteEvent(eventToDelete)
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
    
    private func dismiss() {
        navigationController.dismiss(animated: true) {
            self.onFinish?()
        }
    }
}
