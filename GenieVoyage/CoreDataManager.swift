//
//  CoreDataManager.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.11.2023.
//

import Foundation
import CoreData
import UIKit
import CoreFoundation

final class CoreDataManager {
    
    public static let schared = CoreDataManager()
    private init(){}
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func createNewTrip(_ id: Int16, dateTrip: Date, returnTrip: Date?, destination: String, transferDate: Date?, returnTransferDate: Date?, lodginName: String?, hotelArrivalDate: Date?, hotelDepatureDate: Date?) {
        
        guard let newTripEntityDesription = NSEntityDescription.entity(forEntityName: "NewTrip", in: context) else { return }
        
        let newTrip = NewTrip(entity: newTripEntityDesription, insertInto: context)
        newTrip.id = id
        newTrip.dateTrip = dateTrip
        newTrip.returnTrip = returnTrip
        newTrip.destination = destination
        newTrip.transferDate = transferDate
        newTrip.returnTransfer = returnTransferDate
        newTrip.lodging = lodginName
        newTrip.hotelArriveDate = hotelArrivalDate
        newTrip.hotelDepatureDate = hotelDepatureDate
        
        appDelegate.saveContext()
    }
    
    func fetchTrips() -> [NewTrip] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewTrip")
        do {
            return (try? context.fetch(fetchRequest) as? [NewTrip]) ?? []
        }
    }
    
    func fetchTrip(with id: Int16) -> NewTrip? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewTrip")
        let predicate = NSPredicate(format: "id == %@")
        fetchRequest.predicate = predicate
        do {
            let trips = try? context.fetch(fetchRequest) as? [NewTrip]
            return trips?.first
        }
    }
    
    func updateTrips(with id: Int16, dateTrip: Date?, returnTrip: Date?, destination: String?, transferDate: Date?, returnTransferDate: Date?, lodginName: String?, hotelArrivalDate: Date?, hotelDepatureDate: Date?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewTrip")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let trips = try? context.fetch(fetchRequest) as? [NewTrip],
                  let trip = trips.first else { return }
            trip.dateTrip = dateTrip
            trip.returnTrip = returnTrip
            trip.destination = destination
            trip.transferDate = transferDate
            trip.returnTransfer = returnTransferDate
            trip.lodging = lodginName
            trip.hotelArriveDate = hotelArrivalDate
            trip.hotelDepatureDate = hotelDepatureDate
        }
        appDelegate.saveContext()
    }
    
    func deleteAllTrips() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewTrip")
        do {
            let trips = try? context.fetch(fetchRequest) as? [NewTrip]
            trips?.forEach {context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    func deleteTrip(with idTrip: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewTrip")
        fetchRequest.predicate = NSPredicate(format: "id == %@")
        do {
            guard let trips = try? context.fetch(fetchRequest) as? [NewTrip],
                  let trip = trips.first else { return }
            context.delete(trip)
        }
        appDelegate.saveContext()
    }
}
