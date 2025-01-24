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
    private var days: [String]
    private var itineraryData: [[ItineraryItem]] = []
    
    var selectedDayIndex: Int = 0 {
        didSet {
            onDayChanged?()
        }
    }
    
    // Callback for updating data when the selected day changes
    var onDayChanged: (() -> Void)?
    
    // MARK: - Initializer
    init(days: [String]) {
        self.days = days
        setupData()
    }
    
    // MARK: - Data Setup
    private func setupData() {
        
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
    
    // MARK: - Public Methods
    func numberOfItemsForSelectedDay() -> Int {
        return itineraryData[0].count
       // return itineraryData[selectedDayIndex].count
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
