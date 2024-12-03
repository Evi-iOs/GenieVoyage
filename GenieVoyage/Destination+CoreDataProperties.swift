//
//  Destination+CoreDataProperties.swift
//  
//
//  Created by Evgeniya  Iv on 02.12.2024.
//
//

import Foundation
import CoreData


extension Destination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Destination> {
        return NSFetchRequest<Destination>(entityName: "Destination")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var location: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var trip: Trip?

}
