//
//  ItineraryViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.01.2025.
//

import Foundation
import UIKit

class TripViewModel {
    
    var days: [DayViewModel] = []
    var onDayChanged: (() -> Void)?
    var onUpdate: (() -> Void)?

    var selectedDayIndex: Int = 0 {
        didSet {
            onDayChanged?()
        }
    }
    
    var trip: TripModel

    init(trip: TripModel) {
        self.trip = trip
        setupData()
    }
    
    func allEvents() -> [EventModel] {
        days.flatMap { $0.events }
    }
    
    // MARK: - Data Setup
    private func setupData() {
        self.days = generateDatesViewModelsArray(from: trip.startDate, to: trip.endDate)
    }
    
    private func generateDatesViewModelsArray(from startDate: Date, to endDate: Date) -> [DayViewModel] {
        var dayViewModels: [DayViewModel] = []
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        var currentDate = normalizedStartDate
        while currentDate <= normalizedEndDate {
            dayViewModels.append(DayViewModel(dateDay: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dayViewModels
    }
}
