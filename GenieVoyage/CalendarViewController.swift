//
//  ViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 25.07.2023.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI

class CalendarViewController: DayViewController, EKEventEditViewDelegate {
    
    private var eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        requestAccessToCalendar()
        subscribeNotifications()
        
        print("\(CoreDataManager.schared.fetchTrips())")
        CoreDataManager.schared.deleteTrip(with: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc private func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: eventStore)
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        return calendarKitEvents
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: nil)
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.ekEvent)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventViewController = EKEventViewController()
        eventViewController.event = ekEvent
        eventViewController.allowsCalendarPreview = true
        eventViewController.allowsEditing = true
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        endEventEditing()
        beginEditing(event: ckEvent, animated: true)
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EKWrapper else {
            return
        }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if originalEvent === editingEvent {
                presentEditingViewForEvent(editingEvent.ekEvent)
            } else {
                try! eventStore.save(editingEvent.ekEvent, span: .thisEvent)
            }
        }
        reloadData()
    }
    
     func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let editingViewController = EKEventEditViewController()
        editingViewController.editViewDelegate = self
        editingViewController.event = ekEvent
        editingViewController.eventStore = eventStore
        present(editingViewController, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        let newEKWrapper = createNewEvent(at: date)
        create(event: newEKWrapper, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func createNewEvent(at date: Date) -> EKWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var oneHourComponents = DateComponents()
        oneHourComponents.hour = 1
        
        let endDate = calendar.date(byAdding: oneHourComponents, to: date)
        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = "New Event"
        
        let newEKWrapper = EKWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }
}

