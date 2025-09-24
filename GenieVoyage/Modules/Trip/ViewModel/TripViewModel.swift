//
//  ItineraryViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.01.2025.
//

import Foundation
import Combine

@MainActor
final class TripViewModel: ObservableObject {
    
    @Published private(set) var days: [DayViewModel] = []
    @Published var selectedDayIndex: Int = 0
    
    private(set) var trip: TripModel
    private let storage: TripStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(trip: TripModel, storage: TripStorage) {
        self.trip = trip
        self.storage = storage
        setupData()
        observeDays()
    }
    
    private func setupData() {
        days = generateDatesViewModelsArray(from: trip.startDate, to: trip.endDate)
    }
    
    private func generateDatesViewModelsArray(from startDate: Date, to endDate: Date) -> [DayViewModel] {
        var models: [DayViewModel] = []
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: startDate)
        let endDate = calendar.startOfDay(for: endDate)
        
        while currentDate <= endDate {
            models.append(DayViewModel(dateDay: currentDate, storage: storage, trip: trip))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return models
    }
    
    private func observeDays() {
        days.forEach { dayVM in
            dayVM.$events
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    func addEvent(_ event: EventModel) async {
        if let dayVM = days.first(where: { Calendar.current.isDate($0.dateDay, inSameDayAs: event.dateEvent) }) {
            await dayVM.saveEvent(event)
        }
    }
}
