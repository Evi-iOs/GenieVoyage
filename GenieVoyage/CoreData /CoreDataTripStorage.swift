//
//  CoreDataTripStorage.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.08.2025.
//

import CoreData
import UIKit

final class CoreDataTripStorage: TripStorage {
   
    private let context: NSManagedObjectContext
    private let imageStorage: ImageStorageProtocol
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context, imageStorage: ImageStorageProtocol) {
        self.context = context
        self.imageStorage = imageStorage
    }
    
    // MARK: - Trips
    
    func saveTrip(_ trip: TripModel) async {
        let context = self.context
        await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
            
            do {
                if let existing = try context.fetch(fetchRequest).first {
                    existing.update(from: trip, context: context)
                } else {
                    let newTrip = TripEntity(context: context)
                    newTrip.update(from: trip, context: context)
                }
                try context.save()
            } catch {
                print("❌ Failed to save trip: \(error)")
            }
        }
    }
    
    func loadTrips() async -> [TripModel] {
        let context = self.context
        let coversDirectory = self.imageStorage.coversDirectory

        return await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            do {
                let entities = try context.fetch(fetchRequest)
                return entities.compactMap { $0.toModel(coversDirectory: coversDirectory) }
            } catch {
                print("❌ Failed to load trips: \(error)")
                return []
            }
        }
    }

    func deleteTrip(_ trip: TripModel) async {
        let context = self.context
        await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
            
            do {
                let trips = try context.fetch(fetchRequest)
                for tripEntity in trips {
                    context.delete(tripEntity)
                }
                try context.save()
            } catch {
                print("❌ Failed to delete trip: \(error)")
            }
        }
    }
    
    // MARK: - Events
    
    func saveEvent(_ event: EventModel, to trip: TripModel) async {
        let context = self.context
        await context.perform {
            do {
                let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
                tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
                guard let tripEntity = try context.fetch(tripRequest).first else {
                    print("❌ TripEntity not found, сначала сохрани Trip")
                    return
                }

                var calendar = Calendar.current
                calendar.timeZone = .current
                let dayStart = calendar.startOfDay(for: event.dateEvent)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let dayRequest: NSFetchRequest<TripDayEntity> = TripDayEntity.fetchRequest()
                dayRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND trip == %@", dayStart as CVarArg, dayEnd as CVarArg, tripEntity)
                let tripDayEntity = (try? context.fetch(dayRequest).first) ?? {
                    let newDay = TripDayEntity(context: context)
                    newDay.date = dayStart
                    newDay.trip = tripEntity
                    return newDay
                }()

                let eventRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
                eventRequest.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)

                let eventEntity = (try? context.fetch(eventRequest).first) ?? EventEntity(context: context)
                eventEntity.update(from: event)

                eventEntity.day = tripDayEntity

                try context.save()
                print("✅ Event \(event.id) saved on day \(tripDayEntity.date ?? Date())")
                let cal = Calendar.current
                print("📅 event local day:", cal.component(.day, from: event.dateEvent))
                print("📦 tripDay local day:", cal.component(.day, from: tripDayEntity.date!))

            } catch {
                print("❌ saveEvent error: \(error)")
            }
        }
    }


    func loadEvents(for trip: TripModel) async -> [EventModel] {
        let context = self.context
        return await context.perform { () -> [EventModel] in
            do {
                let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
                tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
                
                guard let tripEntity = try context.fetch(tripRequest).first else {
                    print("❌ TripEntity not found")
                    return []
                }

                if let dayEntities = tripEntity.days as? Set<TripDayEntity> {
                    for day in dayEntities {
                        if let events = day.events as? Set<EventEntity> {
                            for e in events {
                                let eventModel = e.toModel()
                                print("   ↳ Event \(eventModel.id) at \(eventModel.dateEvent)")
                            }
                        }
                    }
                }

                let dayEntities = tripEntity.days?.allObjects as? [TripDayEntity] ?? []
                let allEvents: [EventModel] = dayEntities.flatMap { day in
                    (day.events?.allObjects as? [EventEntity])?.map { $0.toModel() } ?? []
                }

                return allEvents

            } catch {
                print("❌ loadEvents error: \(error)")
                return []
            }
        }
    }
    
    func loadEvents(for trip: TripModel, on date: Date) async -> [EventModel] {
        let context = self.context
        return await context.perform {
            do {
                let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
                tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
                guard let tripEntity = try context.fetch(tripRequest).first else { return [] }

                let calendar = Calendar.current
                let targetDayStart = calendar.startOfDay(for: date)

                let existingDays = (tripEntity.days?.allObjects as? [TripDayEntity]) ?? []
                guard let dayEntity = existingDays.first(where: { calendar.isDate($0.date ?? Date(), inSameDayAs: targetDayStart) }) else {
                    return []
                }
                return (dayEntity.events?.allObjects as? [EventEntity])?.map { $0.toModel() } ?? []

            } catch {
                print("❌ loadEvents error: \(error)")
                return []
            }
        }
    }
    
    func deleteEvent(_ event: EventModel) async {
        let context = self.context
        await context.perform {
            do {
                let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
                
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    try context.save()
                }
            } catch {
                print("❌ deleteEvent error: \(error)")
            }
        }
    }
}
