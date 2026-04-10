//
//  TripTemplate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 26.07.2025.
//

import Foundation
import CoreLocation

struct TripStep {
    let icon: String
    let time: String
    let title: String
    let subtitle: String
    let imageName: String?
    let hasImage: Bool
}

struct TripTemplate {
    let id: UUID
    let title: String
    let subtitle: String
    let locationName: String
    let imageName: String
    let days: [TripDay]
    let steps: [TripStep]
    let rating: Double
    var isFavorite: Bool
    
    var durationLabel: String { "\(days.count) Days" }
    var levelLabel: String    { "Advanced" }
    
    static let defaultTemplates: [TripTemplate] = [TripTemplate(
        id: UUID(),
        title: "Three Days of Paris: Three Faces of the City",
        subtitle: "Experience Paris through its history, art, and grandeur",
        locationName: "Paris",
        imageName: "paris",
        days: [
            // Day 1: Historical Paris
            TripDay(
                date: Date(),
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 90,
                        locationName: "Île de la Cité",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8556, longitude: 2.3450),
                        notes: "Explore the heart of Paris where the city was born."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "09:30",
                        startMinutes: 570,
                        duration: 60,
                        locationName: "Notre-Dame Cathedral",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8530, longitude: 2.3499),
                        notes: "Experience the Gothic architecture and history."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 45,
                        locationName: "Sainte-Chapelle",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8554, longitude: 2.3450),
                        notes: "Marvel at the stunning stained-glass windows."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "12:30",
                        startMinutes: 750,
                        duration: 45,
                        locationName: "Berthillon Ice Cream",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8546, longitude: 2.3565),
                        notes: "Taste classic Parisian ice cream on Île Saint-Louis."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "14:00",
                        startMinutes: 840,
                        duration: 60,
                        locationName: "Seine River Walk",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8570, longitude: 2.3500),
                        notes: "Stroll along the banks and absorb the city atmosphere."
                    )
                ]
            ),
            // Day 2: Bohemian Paris
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 90,
                        locationName: "Montmartre",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8867, longitude: 2.3431),
                        notes: "Wander the hill where artists lived and painted."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "10:30",
                        startMinutes: 630,
                        duration: 45,
                        locationName: "Place du Tertre",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8863, longitude: 2.3387),
                        notes: "Experience the open-air artist square."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "11:30",
                        startMinutes: 690,
                        duration: 60,
                        locationName: "Sacré-Cœur Basilica",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8867, longitude: 2.3431),
                        notes: "Enjoy the panoramic view of Paris."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 60,
                        locationName: "Le Bateau-Lavoir",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8865, longitude: 2.3425),
                        notes: "Historic artist workshop where Picasso and others worked."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "15:00",
                        startMinutes: 900,
                        duration: 60,
                        locationName: "Moulin Rouge",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8841, longitude: 2.3324),
                        notes: "Iconic cabaret symbolizing the nightlife of Montmartre."
                    )
                ]
            ),
            // Day 3: Grand and Cultural Paris
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 120,
                        locationName: "Louvre Museum",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3376),
                        notes: "Select a few halls to explore the masterpieces."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "11:30",
                        startMinutes: 690,
                        duration: 60,
                        locationName: "Tuileries Garden",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8635, longitude: 2.3275),
                        notes: "Relax and watch daily Parisian life in the historic gardens."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "12:30",
                        startMinutes: 750,
                        duration: 45,
                        locationName: "Place de la Concorde",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8656, longitude: 2.3212),
                        notes: "Historical square connecting the grandeur of Parisian avenues."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "14:00",
                        startMinutes: 840,
                        duration: 60,
                        locationName: "Arc de Triomphe",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8738, longitude: 2.2950),
                        notes: "View the radiating avenues, Haussmann’s urban design."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "16:00",
                        startMinutes: 960,
                        duration: 90,
                        locationName: "Eiffel Tower",
                        coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
                        notes: "Finish the trip with the symbol of Paris, especially at sunset."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "airplane.departure", time: "09:00", title: "Day 1: Historical Paris", subtitle: "Explore the birth of the city", imageName: "paris", hasImage: true),
            TripStep(icon: "airplane.departure", time: "09:00", title: "Day 2: Bohemian Paris", subtitle: "Follow the paths of artists and dreamers", imageName: nil, hasImage: false),
            TripStep(icon: "airplane.departure", time: "09:00", title: "Day 3: Grand Paris", subtitle: "Experience the monumental and cultural heart of the city", imageName: nil, hasImage: false)
        ],
        rating: 4.7,
        isFavorite: false
    )
    ]
}
