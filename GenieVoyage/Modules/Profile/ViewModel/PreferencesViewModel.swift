//
//  PreferencesViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import Foundation

enum DistanceUnit: String, CaseIterable {
    case kilometers = "km"
    case miles = "mi"
    
    var displayName: String { self == .kilometers ? "Kilometers" : "Miles" }
}

final class PreferencesViewModel {
    
    static let currencies = ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "CAD"]
    
    private(set) var currency: String {
        didSet { UserDefaults.standard.set(currency, forKey: "preferences.currency") }
    }
    private(set) var distanceUnit: DistanceUnit {
        didSet { UserDefaults.standard.set(distanceUnit.rawValue, forKey: "preferences.units") }
    }
    private(set) var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "preferences.notificationsEnabled") }
    }
    
    init() {
        currency = UserDefaults.standard.string(forKey: "preferences.currency") ?? "USD"
        distanceUnit = DistanceUnit(rawValue: UserDefaults.standard.string(forKey: "preferences.units") ?? "km") ?? .kilometers
        notificationsEnabled = UserDefaults.standard.object(forKey: "preferences.notificationsEnabled") as? Bool ?? true
    }
    
    func updateCurrency(_ currency: String) { self.currency = currency }
    func updateDistanceUnit(_ unit: DistanceUnit) { self.distanceUnit = unit }
    func updateNotifications(_ enabled: Bool) { self.notificationsEnabled = enabled }
}
