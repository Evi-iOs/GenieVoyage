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
        title: "Three Days of Paris",
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

// MARK: - TripTemplate Extensions for All Categories

extension TripTemplate {

    static let allTemplates: [TripTemplate] = [
        defaultTemplates[0],  // city: Paris
        tokyoTemplate,        // city: Tokyo
        santoriniTemplate,    // beach
        swissAlpsTemplate,    // mountain
        blackForestTemplate,  // forest
        wadiRumTemplate       // desert
    ]

    static func templates(for category: String) -> [TripTemplate] {
        switch category {
        case "city":    return [defaultTemplates[0], tokyoTemplate]
        case "beach":   return [santoriniTemplate]
        case "mountain": return [swissAlpsTemplate]
        case "forest":  return [blackForestTemplate]
        case "desert":  return [wadiRumTemplate]
        default:        return allTemplates
        }
    }

    static let santoriniTemplate = TripTemplate(
        id: UUID(),
        title: "Santorini: Sun, Sea & Sunsets",
        subtitle: "Caldera views, volcanic beaches and whitewashed villages",
        locationName: "Santorini",
        imageName: "santorini",
        days: [
            // Day 1: Arrival & Fira
            TripDay(
                date: Date(),
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .transport,
                        time: "10:00",
                        startMinutes: 600,
                        duration: 60,
                        locationName: "Santorini Airport (JTR)",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3992, longitude: 25.4793),
                        notes: "Arrive at Thira Airport. Take a taxi or bus to Fira."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .hotel,
                        time: "12:00",
                        startMinutes: 720,
                        duration: 60,
                        locationName: "Hotel Check-in, Fira",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4168, longitude: 25.4312),
                        notes: "Check in and freshen up. Choose a hotel with caldera views if possible."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "14:00",
                        startMinutes: 840,
                        duration: 90,
                        locationName: "Fira Town Center",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4168, longitude: 25.4312),
                        notes: "Explore the main town, walk along the caldera edge."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "16:00",
                        startMinutes: 960,
                        duration: 60,
                        locationName: "Museum of Prehistoric Thira",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4160, longitude: 25.4320),
                        notes: "Discover Minoan artifacts from the ancient Akrotiri settlement."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "19:00",
                        startMinutes: 1140,
                        duration: 90,
                        locationName: "Dinner at Caldera Restaurant",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4170, longitude: 25.4305),
                        notes: "Enjoy fresh seafood with a view of the caldera at sunset."
                    )
                ]
            ),
            // Day 2: Oia & Beaches
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .transfer,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 30,
                        locationName: "Bus to Oia",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4617, longitude: 25.3753),
                        notes: "Take the local KTEL bus from Fira to Oia."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "09:30",
                        startMinutes: 570,
                        duration: 120,
                        locationName: "Oia Village",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4617, longitude: 25.3753),
                        notes: "Walk through the iconic blue-domed churches and cave houses."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .food,
                        time: "12:00",
                        startMinutes: 720,
                        duration: 60,
                        locationName: "Lunch in Oia",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4620, longitude: 25.3760),
                        notes: "Try a traditional gyros or fresh grilled octopus at a local taverna."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "14:30",
                        startMinutes: 870,
                        duration: 120,
                        locationName: "Red Beach",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3480, longitude: 25.3960),
                        notes: "Unique volcanic red sand beach near Akrotiri. Bring water shoes."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "19:30",
                        startMinutes: 1170,
                        duration: 60,
                        locationName: "Oia Sunset Viewpoint",
                        coordinate: CLLocationCoordinate2D(latitude: 36.4625, longitude: 25.3745),
                        notes: "The most famous sunset in Greece. Arrive 30 min early for a good spot."
                    )
                ]
            ),
            // Day 3: Perissa & Departure
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 120,
                        locationName: "Perissa Black Sand Beach",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3560, longitude: 25.4760),
                        notes: "Swim and relax on the famous volcanic black sand beach."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "12:00",
                        startMinutes: 720,
                        duration: 90,
                        locationName: "Akrotiri Archaeological Site",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3520, longitude: 25.4030),
                        notes: "Explore the preserved Minoan city buried by the volcanic eruption."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .food,
                        time: "14:30",
                        startMinutes: 870,
                        duration: 60,
                        locationName: "Wine Tasting, Santo Wines",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3900, longitude: 25.4200),
                        notes: "Try local Assyrtiko wine with caldera views."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transport,
                        time: "17:00",
                        startMinutes: 1020,
                        duration: 60,
                        locationName: "Santorini Airport — Departure",
                        coordinate: CLLocationCoordinate2D(latitude: 36.3992, longitude: 25.4793),
                        notes: "Head to the airport. Allow 45 min travel time from Fira."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "beach.umbrella", time: "09:00", title: "Day 1: Arrival & Fira", subtitle: "Settle in and explore the caldera town", imageName: "santorini", hasImage: true),
            TripStep(icon: "beach.umbrella", time: "09:00", title: "Day 2: Oia & Beaches", subtitle: "Blue domes, red sands and the famous sunset", imageName: nil, hasImage: false),
            TripStep(icon: "beach.umbrella", time: "09:00", title: "Day 3: Black Beach & Ancient City", subtitle: "Volcanic shores and Minoan history", imageName: nil, hasImage: false)
        ],
        rating: 4.9,
        isFavorite: false
    )

    // MARK: - Mountain: Swiss Alps

    static let swissAlpsTemplate = TripTemplate(
        id: UUID(),
        title: "Swiss Alps: Peaks & Villages",
        subtitle: "Glaciers, mountain railways and alpine meadows",
        locationName: "Swiss Alps",
        imageName: "swiss_alps",
        days: [
            // Day 1: Interlaken & Grindelwald
            TripDay(
                date: Date(),
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .transport,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 60,
                        locationName: "Interlaken Ost Station",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6863, longitude: 7.8685),
                        notes: "Arrive by train. Interlaken is the gateway to the Bernese Oberland."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .hotel,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 60,
                        locationName: "Hotel Check-in, Grindelwald",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6244, longitude: 8.0411),
                        notes: "Stay in Grindelwald for direct Eiger views."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 120,
                        locationName: "First Mountain Cable Car",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6583, longitude: 8.0521),
                        notes: "Ride to First (2168m). Try the First Flyer zip-line or cliff walk."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "15:30",
                        startMinutes: 930,
                        duration: 90,
                        locationName: "Bachalpsee Lake Hike",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6698, longitude: 8.0633),
                        notes: "Easy 1-hour hike to a mountain lake reflecting the Wetterhorn peak."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "19:00",
                        startMinutes: 1140,
                        duration: 90,
                        locationName: "Dinner: Traditional Swiss Fondue",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6244, longitude: 8.0411),
                        notes: "Cheese fondue at a local Beizli. Order a side of alpine bread."
                    )
                ]
            ),
            // Day 2: Jungfraujoch
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .transport,
                        time: "08:00",
                        startMinutes: 480,
                        duration: 90,
                        locationName: "Jungfraujoch Railway",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5474, longitude: 7.9713),
                        notes: "Take the cogwheel railway from Grindelwald — book tickets in advance."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "10:00",
                        startMinutes: 600,
                        duration: 180,
                        locationName: "Top of Europe (3454m)",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5474, longitude: 7.9713),
                        notes: "Aletsch Glacier view, Ice Palace, Sphinx Observatory. Dress very warm."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .food,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 60,
                        locationName: "Lunch at Crystal Restaurant",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5474, longitude: 7.9713),
                        notes: "Restaurant at the top. Try the rösti — a Swiss classic."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "15:30",
                        startMinutes: 930,
                        duration: 90,
                        locationName: "Kleine Scheidegg Walk",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5850, longitude: 7.9597),
                        notes: "Walk back down to Kleine Scheidegg along the trail under the Eiger north face."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .transfer,
                        time: "18:00",
                        startMinutes: 1080,
                        duration: 45,
                        locationName: "Train back to Grindelwald",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6244, longitude: 8.0411),
                        notes: "Return by train to the village for dinner and rest."
                    )
                ]
            ),
            // Day 3: Lauterbrunnen Valley
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transfer,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 30,
                        locationName: "Train to Lauterbrunnen",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5930, longitude: 7.9080),
                        notes: "Short train ride into the waterfall valley."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "09:30",
                        startMinutes: 570,
                        duration: 90,
                        locationName: "Staubbach Falls",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5930, longitude: 7.9080),
                        notes: "One of Europe's tallest free-falling waterfalls. Walk behind the curtain."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "11:30",
                        startMinutes: 690,
                        duration: 60,
                        locationName: "Trümmelbach Falls",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5645, longitude: 7.9095),
                        notes: "Glacial waterfalls inside the mountain — accessible by lift."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .food,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 60,
                        locationName: "Lunch in Mürren Village",
                        coordinate: CLLocationCoordinate2D(latitude: 46.5593, longitude: 7.8930),
                        notes: "Car-free mountain village with stunning Jungfrau views."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transport,
                        time: "16:00",
                        startMinutes: 960,
                        duration: 60,
                        locationName: "Departure from Interlaken",
                        coordinate: CLLocationCoordinate2D(latitude: 46.6863, longitude: 7.8685),
                        notes: "Take the train back. Book your seat in advance during peak season."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "mountain.2", time: "09:00", title: "Day 1: Grindelwald & First", subtitle: "Cable cars and alpine meadows", imageName: "swiss_alps", hasImage: true),
            TripStep(icon: "mountain.2", time: "08:00", title: "Day 2: Jungfraujoch", subtitle: "Top of Europe at 3454m", imageName: nil, hasImage: false),
            TripStep(icon: "mountain.2", time: "09:00", title: "Day 3: Waterfall Valley", subtitle: "Lauterbrunnen and Mürren", imageName: nil, hasImage: false)
        ],
        rating: 4.8,
        isFavorite: false
    )

    // MARK: - Forest: Black Forest, Germany

    static let blackForestTemplate = TripTemplate(
        id: UUID(),
        title: "Black Forest",
        subtitle: "Ancient woodland, cuckoo clocks and thermal spas",
        locationName: "Black Forest",
        imageName: "black_forest",
        days: [
            // Day 1: Freiburg
            TripDay(
                date: Date(),
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .transport,
                        time: "10:00",
                        startMinutes: 600,
                        duration: 30,
                        locationName: "Freiburg im Breisgau Station",
                        coordinate: CLLocationCoordinate2D(latitude: 47.9974, longitude: 7.8421),
                        notes: "Arrive by train. Gateway to the southern Black Forest."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .hotel,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 30,
                        locationName: "Hotel Check-in, Freiburg",
                        coordinate: CLLocationCoordinate2D(latitude: 47.9990, longitude: 7.8421),
                        notes: "Stay in the old town area for easy access to everything."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "12:00",
                        startMinutes: 720,
                        duration: 90,
                        locationName: "Freiburg Münster",
                        coordinate: CLLocationCoordinate2D(latitude: 47.9954, longitude: 7.8524),
                        notes: "Gothic cathedral with a striking sandstone tower and market square below."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "13:30",
                        startMinutes: 810,
                        duration: 60,
                        locationName: "Lunch at Münstermarkt",
                        coordinate: CLLocationCoordinate2D(latitude: 47.9954, longitude: 7.8524),
                        notes: "Open-air market around the cathedral. Try Flammkuchen and local bread."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "15:00",
                        startMinutes: 900,
                        duration: 120,
                        locationName: "Schlossberg Hike",
                        coordinate: CLLocationCoordinate2D(latitude: 48.0012, longitude: 7.8600),
                        notes: "Walk up to the castle hill for panoramic views of Freiburg and the Rhine plain."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "19:00",
                        startMinutes: 1140,
                        duration: 90,
                        locationName: "Dinner: Black Forest cuisine",
                        coordinate: CLLocationCoordinate2D(latitude: 47.9990, longitude: 7.8421),
                        notes: "Try Schwarzwälder Schinken (ham), Maultaschen, and of course Black Forest cake."
                    )
                ]
            ),
            // Day 2: Deep Forest & Triberg
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .transfer,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 60,
                        locationName: "Drive to Triberg",
                        coordinate: CLLocationCoordinate2D(latitude: 48.1308, longitude: 8.2306),
                        notes: "About 1 hour by car or regional train through forested valleys."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "10:30",
                        startMinutes: 630,
                        duration: 90,
                        locationName: "Triberg Waterfalls",
                        coordinate: CLLocationCoordinate2D(latitude: 48.1308, longitude: 8.2306),
                        notes: "Germany's highest waterfalls. Walk the trail through dense spruce forest."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "12:30",
                        startMinutes: 750,
                        duration: 60,
                        locationName: "World's Largest Cuckoo Clock",
                        coordinate: CLLocationCoordinate2D(latitude: 48.1290, longitude: 8.2350),
                        notes: "Visit the record-breaking clock — a quirky Black Forest must-see."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .food,
                        time: "14:00",
                        startMinutes: 840,
                        duration: 60,
                        locationName: "Lunch in Triberg",
                        coordinate: CLLocationCoordinate2D(latitude: 48.1308, longitude: 8.2306),
                        notes: "Local Gasthof. Order Schwarzwälder Kirschtorte — the original recipe."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "15:30",
                        startMinutes: 930,
                        duration: 120,
                        locationName: "Gutach Open Air Museum",
                        coordinate: CLLocationCoordinate2D(latitude: 48.1702, longitude: 8.2256),
                        notes: "Traditional Black Forest farmhouses moved here from across the region."
                    )
                ]
            ),
            // Day 3: Baden-Baden Spa
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transfer,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 60,
                        locationName: "Train to Baden-Baden",
                        coordinate: CLLocationCoordinate2D(latitude: 48.7606, longitude: 8.2401),
                        notes: "Famous spa town at the northern edge of the Black Forest."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "10:30",
                        startMinutes: 630,
                        duration: 60,
                        locationName: "Lichtentaler Allee Park",
                        coordinate: CLLocationCoordinate2D(latitude: 48.7580, longitude: 8.2450),
                        notes: "Beautiful 2.3km riverside promenade lined with rhododendrons and roses."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "12:00",
                        startMinutes: 720,
                        duration: 180,
                        locationName: "Caracalla Spa",
                        coordinate: CLLocationCoordinate2D(latitude: 48.7645, longitude: 8.2390),
                        notes: "Relax in the thermal baths fed by natural hot springs. Bring a towel."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .food,
                        time: "16:00",
                        startMinutes: 960,
                        duration: 60,
                        locationName: "Café König, Baden-Baden",
                        coordinate: CLLocationCoordinate2D(latitude: 48.7620, longitude: 8.2410),
                        notes: "Historic café serving Black Forest cake since 1948. A perfect farewell treat."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transport,
                        time: "18:00",
                        startMinutes: 1080,
                        duration: 60,
                        locationName: "Departure from Baden-Baden",
                        coordinate: CLLocationCoordinate2D(latitude: 48.7606, longitude: 8.2401),
                        notes: "Train connections to major German cities from Baden-Baden station."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "leaf", time: "10:00", title: "Day 1: Freiburg", subtitle: "Cathedral, market and hillside views", imageName: "black_forest", hasImage: true),
            TripStep(icon: "leaf", time: "09:00", title: "Day 2: Triberg & Waterfalls", subtitle: "Deep forest, cuckoo clocks and falls", imageName: nil, hasImage: false),
            TripStep(icon: "leaf", time: "09:00", title: "Day 3: Baden-Baden", subtitle: "Thermal spas and elegant promenades", imageName: nil, hasImage: false)
        ],
        rating: 4.6,
        isFavorite: false
    )

    // MARK: - Desert: Wadi Rum, Jordan

    static let wadiRumTemplate = TripTemplate(
        id: UUID(),
        title: "Wadi Rum: The Martian Desert",
        subtitle: "Red sandstone canyons, Bedouin camps and star-filled skies",
        locationName: "Wadi Rum",
        imageName: "wadi_rum",
        days: [
            // Day 1: Arrival & Jeep Tour
            TripDay(
                date: Date(),
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .transport,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 120,
                        locationName: "Wadi Rum Visitor Centre",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5765, longitude: 35.4209),
                        notes: "Arrive from Aqaba or Petra. Register at the visitor centre and meet your guide."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .transfer,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 240,
                        locationName: "Half-day Jeep Safari",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5600, longitude: 35.4000),
                        notes: "4x4 jeep tour covering Lawrence's Spring, Khazali Canyon and sand dunes."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 60,
                        locationName: "Khazali Canyon",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5327, longitude: 35.3885),
                        notes: "Narrow siq with ancient Nabataean and Thamudic inscriptions on the rock walls."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .hotel,
                        time: "16:00",
                        startMinutes: 960,
                        duration: 60,
                        locationName: "Bedouin Desert Camp",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Check in to your desert camp. Bubble tents or traditional goat-hair tents."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "19:30",
                        startMinutes: 1170,
                        duration: 90,
                        locationName: "Zarb Dinner at Camp",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Traditional Bedouin underground BBQ. Lamb, chicken and vegetables slow-cooked in sand."
                    )
                ]
            ),
            // Day 2: Climbing & Dunes
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "06:00",
                        startMinutes: 360,
                        duration: 60,
                        locationName: "Sunrise at Um Fruth Rock Bridge",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5450, longitude: 35.4050),
                        notes: "One of the largest natural rock bridges in Wadi Rum. Climb to the top."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .food,
                        time: "08:00",
                        startMinutes: 480,
                        duration: 60,
                        locationName: "Breakfast at Camp",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Traditional Bedouin breakfast — flatbread, hummus, olive oil and sweet tea."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "10:00",
                        startMinutes: 600,
                        duration: 120,
                        locationName: "Burdah Rock Bridge Hike",
                        coordinate: CLLocationCoordinate2D(latitude: 29.6020, longitude: 35.4430),
                        notes: "Challenging 3-hour hike to the highest natural arch in Wadi Rum (35m high)."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "14:00",
                        startMinutes: 840,
                        duration: 90,
                        locationName: "Red Sand Dunes",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5620, longitude: 35.3950),
                        notes: "Sandboarding or simply running down the giant orange dunes."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "20:00",
                        startMinutes: 1200,
                        duration: 60,
                        locationName: "Stargazing in the Desert",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Zero light pollution. Milky Way visible to the naked eye. Bring a warm layer."
                    )
                ]
            ),
            // Day 3: Camel Ride & Departure
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "07:00",
                        startMinutes: 420,
                        duration: 120,
                        locationName: "Camel Ride at Sunrise",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Ride camels across the desert at the most magical light of the day."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .food,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 60,
                        locationName: "Final Breakfast at Camp",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5500, longitude: 35.4100),
                        notes: "Last cup of Bedouin tea with cardamom before departing."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "10:30",
                        startMinutes: 630,
                        duration: 60,
                        locationName: "Lawrence of Arabia's House",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5714, longitude: 35.4190),
                        notes: "The ruins where T.E. Lawrence is said to have stayed during the Arab Revolt."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transport,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 120,
                        locationName: "Departure to Aqaba or Petra",
                        coordinate: CLLocationCoordinate2D(latitude: 29.5765, longitude: 35.4209),
                        notes: "Transfer from the visitor centre. Aqaba is 1h, Petra is 1.5h by car."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "sun.max", time: "09:00", title: "Day 1: Arrival & Jeep Safari", subtitle: "Red canyons and Bedouin camp", imageName: "wadi_rum", hasImage: true),
            TripStep(icon: "sun.max", time: "06:00", title: "Day 2: Rock Bridges & Dunes", subtitle: "Hike, sandboard and stargaze", imageName: nil, hasImage: false),
            TripStep(icon: "sun.max", time: "07:00", title: "Day 3: Camel Ride & Farewell", subtitle: "Sunrise desert ride and departure", imageName: nil, hasImage: false)
        ],
        rating: 4.8,
        isFavorite: false
    )

    // MARK: - City: Tokyo

    static let tokyoTemplate = TripTemplate(
        id: UUID(),
        title: "Tokyo: Ancient Meets Future",
        subtitle: "Temples, neon streets and the world's best food culture",
        locationName: "Tokyo",
        imageName: "tokyo",
        days: [
            // Day 1: Traditional Tokyo
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
                        locationName: "Senso-ji Temple, Asakusa",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7148, longitude: 139.7967),
                        notes: "Tokyo's oldest temple. Arrive early before the crowds."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 60,
                        locationName: "Nakamise Shopping Street",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7145, longitude: 139.7960),
                        notes: "Traditional snacks and souvenirs leading up to the temple gate."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "12:30",
                        startMinutes: 750,
                        duration: 60,
                        locationName: "Ramen at Fuunji, Shinjuku",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6938, longitude: 139.7034),
                        notes: "Famous tsukemen (dipping ramen). Expect a short queue."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "14:30",
                        startMinutes: 870,
                        duration: 90,
                        locationName: "Meiji Shrine",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6763, longitude: 139.6993),
                        notes: "Peaceful Shinto shrine surrounded by a forested park in central Tokyo."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .point,
                        time: "17:00",
                        startMinutes: 1020,
                        duration: 60,
                        locationName: "Harajuku & Takeshita Street",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6702, longitude: 139.7027),
                        notes: "Street fashion, crepe shops and Tokyo's most colourful youth culture."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Date(),
                        category: .food,
                        time: "19:30",
                        startMinutes: 1170,
                        duration: 90,
                        locationName: "Izakaya Dinner, Shinjuku",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6938, longitude: 139.7034),
                        notes: "Order yakitori, edamame and cold Sapporo. Golden Gai area nearby for drinks."
                    )
                ]
            ),
            // Day 2: Modern Tokyo
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "08:30",
                        startMinutes: 510,
                        duration: 60,
                        locationName: "Tsukiji Outer Market",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6654, longitude: 139.7707),
                        notes: "Fresh sushi breakfast and street food. Best in the morning."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "10:30",
                        startMinutes: 630,
                        duration: 90,
                        locationName: "teamLab Planets",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6455, longitude: 139.7853),
                        notes: "Immersive digital art museum. Book tickets online in advance."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .food,
                        time: "13:00",
                        startMinutes: 780,
                        duration: 60,
                        locationName: "Lunch in Odaiba",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6267, longitude: 139.7759),
                        notes: "Futuristic waterfront district. Great view of Rainbow Bridge."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "15:00",
                        startMinutes: 900,
                        duration: 90,
                        locationName: "Shibuya Crossing",
                        coordinate: CLLocationCoordinate2D(latitude: 35.6595, longitude: 139.7004),
                        notes: "World's busiest pedestrian crossing. Go up to Mag's Park for the bird's eye view."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        category: .point,
                        time: "17:00",
                        startMinutes: 1020,
                        duration: 90,
                        locationName: "Tokyo Skytree",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7101, longitude: 139.8107),
                        notes: "634m tower with observation deck. Book sunset slot for city lights."
                    )
                ]
            ),
            // Day 3: Akihabara & Ueno
            TripDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                itineraryEvents: [
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "09:00",
                        startMinutes: 540,
                        duration: 90,
                        locationName: "Ueno Park & Temples",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7156, longitude: 139.7733),
                        notes: "Large park with multiple museums, a zoo and the Toshogu Shrine."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "11:00",
                        startMinutes: 660,
                        duration: 120,
                        locationName: "Akihabara Electric Town",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7023, longitude: 139.7745),
                        notes: "Electronics, anime, manga and retro game shops. A sensory overload."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .food,
                        time: "13:30",
                        startMinutes: 810,
                        duration: 60,
                        locationName: "Tonkatsu lunch, Ueno",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7156, longitude: 139.7733),
                        notes: "Crispy fried pork cutlet with rice, miso soup and cabbage."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .point,
                        time: "15:00",
                        startMinutes: 900,
                        duration: 90,
                        locationName: "Yanaka Old Town",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7256, longitude: 139.7650),
                        notes: "Preserved Edo-era neighbourhood that survived WWII. Cat cafés and craft shops."
                    ),
                    EventModel(
                        id: UUID(),
                        dateEvent: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        category: .transport,
                        time: "18:00",
                        startMinutes: 1080,
                        duration: 90,
                        locationName: "Narita / Haneda Airport",
                        coordinate: CLLocationCoordinate2D(latitude: 35.7720, longitude: 140.3929),
                        notes: "Take the Narita Express or Keikyu Line. Allow 90 min from central Tokyo."
                    )
                ]
            )
        ],
        steps: [
            TripStep(icon: "building.2", time: "09:00", title: "Day 1: Traditional Tokyo", subtitle: "Temples, shrines and izakayas", imageName: "tokyo", hasImage: true),
            TripStep(icon: "building.2", time: "08:30", title: "Day 2: Modern Tokyo", subtitle: "Digital art, Shibuya and the Skytree", imageName: nil, hasImage: false),
            TripStep(icon: "building.2", time: "09:00", title: "Day 3: Akihabara & Old Town", subtitle: "Tech culture and Edo-era streets", imageName: nil, hasImage: false)
        ],
        rating: 4.9,
        isFavorite: false
    )
}
