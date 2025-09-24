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
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Trips
    
    func saveTrip(_ trip: TripModel) async {
        await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
            
            do {
                if let existing = try self.context.fetch(fetchRequest).first {
                    existing.update(from: trip, context: self.context)
                } else {
                    let newTrip = TripEntity(context: self.context)
                    newTrip.update(from: trip, context: self.context)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to save trip: \(error)")
            }
        }
    }
    
    func loadTrips() async -> [TripModel] {
        await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            do {
                let entities = try self.context.fetch(fetchRequest)
                return entities.compactMap { $0.toModel() }
            } catch {
                print("❌ Failed to load trips: \(error)")
                return []
            }
        }
    }
    
    func deleteTrip(_ trip: TripModel) async {
        await context.perform {
            let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
            
            do {
                let trips = try self.context.fetch(fetchRequest)
                for tripEntity in trips {
                    self.context.delete(tripEntity)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to delete trip: \(error)")
            }
        }
    }
    
    // MARK: - Events
    
    func saveEvent(_ event: EventModel, to trip: TripModel) async {
        await context.perform {
            let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
            tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
            
            guard let tripEntity = try? self.context.fetch(tripRequest).first else {
                print("❌ TripEntity not found, сначала сохрани Trip")
                return
            }

            // ищем день в CoreData
            let dayRequest: NSFetchRequest<TripDayEntity> = TripDayEntity.fetchRequest()
            dayRequest.predicate = NSPredicate(format: "date == %@ AND trip == %@", event.dateEvent as CVarArg, tripEntity)
            
            let tripDayEntity = (try? self.context.fetch(dayRequest).first)
                ?? {
                    // создаём новый день, если его нет
                    let newDay = TripDayEntity(context: self.context)
                    newDay.date = event.dateEvent
                    newDay.trip = tripEntity
                    return newDay
                }()

            // ищем / создаём EventEntity
            let eventRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
            eventRequest.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
            
            let eventEntity = (try? self.context.fetch(eventRequest).first) ?? EventEntity(context: self.context)
            eventEntity.update(from: event)

            // привязываем событие к дню
            eventEntity.day = tripDayEntity

            try? self.context.save()
        }
    }

    func loadEvents(for trip: TripModel) async -> [EventModel] {
        await context.perform {
            do {
                let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
                tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
                guard let tripEntity = try self.context.fetch(tripRequest).first else { return [] }
                
                let dayEntities = tripEntity.days?.allObjects as? [TripDayEntity] ?? []
                
                let events = dayEntities.flatMap { day in
                    (day.events?.allObjects as? [EventEntity])?.compactMap { $0.toModel() } ?? []
                }
                return events
            } catch {
                print("❌ loadEvents error: \(error)")
                return []
            }
        }
    }
    
    func loadEvents(for trip: TripModel, on date: Date) async -> [EventModel] {
        await context.perform {
            do {
                let tripRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
                tripRequest.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
                guard let tripEntity = try self.context.fetch(tripRequest).first else { return [] }
                
                let dayDate = Calendar.current.startOfDay(for: date)
                let dayRequest: NSFetchRequest<TripDayEntity> = TripDayEntity.fetchRequest()
                dayRequest.predicate = NSPredicate(format: "trip == %@ AND date == %@", tripEntity, dayDate as CVarArg)
                
                guard let dayEntity = try self.context.fetch(dayRequest).first else { return [] }
                
                return (dayEntity.events?.allObjects as? [EventEntity])?.compactMap { $0.toModel() } ?? []
            } catch {
                print("❌ loadEvents error: \(error)")
                return []
            }
        }
    }
    
    func deleteEvent(_ event: EventModel) async {
        await context.perform {
            do {
                let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
                
                if let entity = try self.context.fetch(request).first {
                    self.context.delete(entity)
                    try self.context.save()
                }
            } catch {
                print("❌ deleteEvent error: \(error)")
            }
        }
    }
}
