//
//  ItineraryViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.01.2025.
//

import Foundation
import UIKit

class ItineraryViewModel {
    
    // MARK: - Properties
    var days: [String] = []
    
    private var itineraryData: [[ItineraryItem]] = []
    private let trip: TripModel?
    
    var selectedDayIndex: Int = 0 {
        didSet {
            onDayChanged?()
        }
    }
    
    // Callback for updating data when the selected day changes
    var onDayChanged: (() -> Void)?
    
    // MARK: - Initializer
    init(trip: TripModel? = nil) {
        self.trip = trip
        setupData()
    }
    
    // MARK: - Data Setup
    private func setupData() {
        
        configureDays(trip: trip)
        // Example itinerary data
        itineraryData = [
            [
                ItineraryItem(time: "10:00", title: "Fly", icon: UIImage(systemName: "airplane")),
                ItineraryItem(time: "13:00", title: "Hotel", icon: UIImage(systemName: "house")),
                ItineraryItem(time: "14:00", title: "Restaurant", icon: UIImage(systemName: "fork.knife")),
                ItineraryItem(time: "11:00", title: "Shopping", icon: UIImage(systemName: "bag"))
            ],
            [
                ItineraryItem(time: "09:00", title: "Breakfast", icon: UIImage(systemName: "cup.and.saucer")),
                ItineraryItem(time: "10:00", title: "Museo", icon: UIImage(systemName: "mappin")),
                ItineraryItem(time: "15:00", title: "Dinner", icon: UIImage(systemName: "fork.knife"))
            ]
        ]
    }
    
    private func configureDays(trip: TripModel?) {
        guard let trip = trip else {
            days = []
            return
        }
        days = generateDatesArray(from: trip.startDate, to: trip.endDate)
    }
    
    private func generateDatesArray(from startDate: Date, to endDate: Date) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        var currentDate = normalizedStartDate
        while currentDate <= normalizedEndDate {
            let dateString = currentDate.formattedDateWeekDay()
            dates.append(dateString)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    // MARK: - Public Methods
    func numberOfItemsForSelectedDay() -> Int {
        return itineraryData[0].count
       // return itineraryData[selectedDayIndex].count
    }
    
    func itemForIndex(_ index: Int) -> ItineraryItem {
        return itineraryData[0][0]
        //return itineraryData[selectedDayIndex][index]
    }
    
    func numberOfDays() -> Int {
        return days.count
    }
    
    func titleForDay(at index: Int) -> String {
        return days[index]
    }
}
