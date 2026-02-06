//
//  Mapping.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 16.08.2025.
//

import Foundation
import CoreData
import CoreLocation

extension TripEntity {
    func toModel(coversDirectory: URL) -> TripModel {
        let trip = TripModel(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            startDate: self.startDate ?? Date(),
            endDate: self.endDate ?? Date(),
            coverImage: self.coverImage.map { coversDirectory.appendingPathComponent($0)},
            days: (self.days as? Set<TripDayEntity>)?.map { $0.toModel() } ?? []
        )
        return trip
    }
    
    func update(from model: TripModel, context: NSManagedObjectContext) {
        self.id = model.id
        self.title = model.title
        self.startDate = model.startDate
        self.endDate = model.endDate
        if let newCover = model.coverImage?.lastPathComponent {
            self.coverImage = newCover
        }

        var existingDaysByDate: [Date: TripDayEntity] = [:]
        if let existingDays = self.days as? Set<TripDayEntity> {
            for day in existingDays {
                if let date = day.date {
                    existingDaysByDate[date] = day
                }
            }
        }
        
        for dayModel in model.days {
            if let existing = existingDaysByDate[dayModel.date] {
                existing.update(from: dayModel, context: context)
                existingDaysByDate.removeValue(forKey: dayModel.date)
            } else {
                let newDay = TripDayEntity(context: context)
                newDay.update(from: dayModel, context: context)
                newDay.trip = self
                self.addToDays(newDay)
            }
        }
        
        for unused in existingDaysByDate.values {
            context.delete(unused)
        }
    }
}

extension TripDayEntity {
    func toModel() -> TripDay {
        TripDay(
            date: self.date ?? Date(),
            itineraryEvents: (self.events as? Set<EventEntity>)?.map { $0.toModel() } ?? []
        )
    }
    
    func update(from model: TripDay, context: NSManagedObjectContext) {
        self.date = model.date
        
        var existingEventsById: [UUID: EventEntity] = [:]
        if let existingEvents = self.events as? Set<EventEntity> {
            for event in existingEvents {
                if let id = event.id {
                    existingEventsById[id] = event
                }
            }
        }
        
        for eventModel in model.itineraryEvents {
            if let existing = existingEventsById[eventModel.id] {
                existing.update(from: eventModel)
                existingEventsById.removeValue(forKey: eventModel.id)
            } else {
                let newEvent = EventEntity(context: context)
                newEvent.update(from: eventModel)
                newEvent.day = self
                self.addToEvents(newEvent)
            }
        }
        
        for unused in existingEventsById.values {
            context.delete(unused)
        }
    }
}

extension EventEntity {
    func toModel() -> EventModel {
        EventModel(
            id: self.id ?? UUID(),
            dateEvent: self.day?.date ?? Date(),
            category: EventCategory(rawValue: self.category ?? "point") ?? .point,
            time: self.time ?? "",
            startMinutes: Int(self.startMinutes),
            duration: Int(self.duration),
            locationName: self.locationName,
            coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude),
            notes: self.notes,
            bookingLink: self.bookingLink,
            pdfFileURL: self.pdfFileURL
        )
    }

    func update(from model: EventModel) {
        self.id = model.id
        self.category = model.category.rawValue
        self.time = model.time
        self.startMinutes = Int64(model.startMinutes)
        self.duration = Int64(model.duration)
        self.locationName = model.locationName
        self.notes = model.notes
        self.bookingLink = model.bookingLink
        self.pdfFileURL = model.pdfFileURL

        if let coordinate = model.coordinate {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
    }
}
