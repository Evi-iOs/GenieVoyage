//
//  ItineraryViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.01.2025.
//

import Foundation
import Combine
import UIKit

@MainActor
final class TripViewModel: ObservableObject {
    
    @Published private(set) var events: [EventModel] = []
    @Published private(set) var days: [DayViewModel] = []
    @Published var selectedDayIndex: Int = 0
    @Published var isLoading: Bool = false
        
    var trip: TripModel
    private let storage: TripStorage
    private let imageStorage: ImageStorageProtocol
    private var calendar: Calendar
    
    private var daysCancellables = Set<AnyCancellable>()
    private var modelCancellables = Set<AnyCancellable>()
    
    init(trip: TripModel, storage: TripStorage, imageStorage: ImageStorageProtocol, calendar: Calendar = .current) {
        self.trip = trip
        self.storage = storage
        self.calendar = calendar
        self.imageStorage = imageStorage
        
        Task {
            await loadInitialData()
        }
    }
    
    func saveTrip(coverImage: UIImage?) async {
        if let image = coverImage {
            do {
                let url = try imageStorage.saveCover(image, tripID: trip.id)
                trip.coverImage = url
            } catch {
                print("❌ image save error:", error)
            }
        }
        await storage.saveTrip(trip)
    }
    
    func loadCoverImage() -> UIImage? {
        guard let url = trip.coverImage else { return nil }
        return imageStorage.loadImage(from: url)
    }

    private func loadInitialData() async {
        isLoading = false
        
        let loadedEvents = await storage.loadEvents(for: trip)
        let generatedDays = generateDayViewModels()
        
        events = loadedEvents
        days = generatedDays
        
        distributeEventsToDays()
        isLoading = true
    }
    
    private func generateDayViewModels() -> [DayViewModel] {
        var result: [DayViewModel] = []
        
        calendar.timeZone = .current
        var currentDate = calendar.startOfDay(for: trip.startDate)
        let endDate = calendar.startOfDay(for: trip.endDate)
        
        while currentDate <= endDate {
            result.append(DayViewModel(dateDay: currentDate, calendar: calendar))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return result
    }
    
    private func distributeEventsToDays() {
        for day in days {
            day.setEvents(events)
        }
    }
    
    // MARK: - Public intents from UI
    
    func addEvent(_ event: EventModel) async {
        guard !events.contains(where: { $0.id == event.id }) else { return }
        
        events.append(event)
        normalizeEvents()
        
        await storage.saveEvent(event, to: trip)
        distributeEventsToDays()
    }
    
    func updateEvent(_ event: EventModel) async {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        events[index] = event
        normalizeEvents()
        
        await storage.saveEvent(event, to: trip)
        distributeEventsToDays()
    }
    
    func deleteEvent(_ event: EventModel) async {
        events.removeAll { $0.id == event.id }
        
        await storage.deleteEvent(event)
        distributeEventsToDays()
    }
    
    func moveEvent(_ event: EventModel, byMinutes delta: Int) async {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        events[index].startMinutes += delta
        
        await storage.saveEvent(events[index], to: trip)
        
        normalizeEvents()
        distributeEventsToDays()
    }
    
    func resizeEvent(_ event: EventModel, toMinutes duration: Int) async {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        events[index].duration = duration
        
        await storage.saveEvent(events[index], to: trip)
        normalizeEvents()

        distributeEventsToDays()
    }
    
    func duplicateEvent(_ event: EventModel, to date: Date) async {
        let newEvent = EventModel(
            id: UUID(),
            dateEvent: date,
            category: event.category,
            time: event.time,
            startMinutes: event.startMinutes,
            duration: event.duration,
            locationName: event.locationName,
            coordinate: event.coordinate,
            notes: event.notes,
            bookingLink: event.bookingLink,
            pdfFileURL: event.pdfFileURL
        )
        
        await addEvent(newEvent)
    }
    
    // MARK: - Helpers
    
    private func normalizeEvents() {
        events.sort { $0.startMinutes < $1.startMinutes }
    }
}
