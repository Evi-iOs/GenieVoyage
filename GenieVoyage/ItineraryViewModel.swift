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
    private(set) var days: [String] = []
    private var itineraryData: [[ItineraryItem]] = []
    
    var selectedDayIndex: Int = 0 {
        didSet {
            onDayChanged?()
        }
    }
    
    // Callback for updating data when the selected day changes
    var onDayChanged: (() -> Void)?
    
    // MARK: - Initializer
    init() {
        setupData()
    }
    
    // MARK: - Data Setup
    private func setupData() {
        // Generate days (e.g., Mon 10/12, Tue 11/12)
        days = generateDatesArray(from: Date(), to: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
        
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
    
    private func generateDatesArray(from startDate: Date, to endDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd/MM"
        
        var dates: [String] = []
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        while currentDate <= normalizedEndDate {
            dates.append(formatter.string(from: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    // MARK: - Public Methods
    func numberOfItemsForSelectedDay() -> Int {
        return itineraryData[selectedDayIndex].count
    }
    
    func itemForIndex(_ index: Int) -> ItineraryItem {
        return itineraryData[selectedDayIndex][index]
    }
    
    func numberOfDays() -> Int {
        return days.count
    }
    
    func titleForDay(at index: Int) -> String {
        return days[index]
    }
}
