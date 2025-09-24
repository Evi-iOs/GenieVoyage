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
    func toModel() -> TripModel {
        TripModel(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            startDate: self.startDate ?? Date(),
            endDate: self.endDate ?? Date(),
            days: (self.days as? Set<TripDayEntity>)?.map { $0.toModel() } ?? []
        )
    }

    func update(from model: TripModel, context: NSManagedObjectContext) {
        self.id = model.id
        self.title = model.title
        self.startDate = model.startDate
        self.endDate = model.endDate

        if let existingDays = self.days as? Set<TripDayEntity> {
            for day in existingDays {
                context.delete(day)
            }
        }

        for dayModel in model.days {
            let dayEntity = TripDayEntity(context: context)
            dayEntity.update(from: dayModel, context: context)
            dayEntity.trip = self
            self.addToDays(dayEntity)
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

        if let existingEvents = self.events as? Set<EventEntity> {
            for event in existingEvents {
                context.delete(event)
            }
        }

        for eventModel in model.itineraryEvents {
            let eventEntity = EventEntity(context: context)
            eventEntity.update(from: eventModel)
            eventEntity.day = self
            self.addToEvents(eventEntity)
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
