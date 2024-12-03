//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Evgeniya  Iv on 02.12.2024.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var coverImage: URL?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var titel: String?
    @NSManaged public var destination: NSSet?

}

// MARK: Generated accessors for destination
extension Trip {

    @objc(addDestinationObject:)
    @NSManaged public func addToDestination(_ value: Destination)

    @objc(removeDestinationObject:)
    @NSManaged public func removeFromDestination(_ value: Destination)

    @objc(addDestination:)
    @NSManaged public func addToDestination(_ values: NSSet)

    @objc(removeDestination:)
    @NSManaged public func removeFromDestination(_ values: NSSet)

}
