//
//  Trip+CoreDataProperties.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.11.2023.
//
//

import Foundation
import CoreData

@objc(NewTrip)
public class NewTrip: NSManagedObject {

}

extension NewTrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewTrip> {
        return NSFetchRequest<NewTrip>(entityName: "NewTrip")
    }

    @NSManaged public var dateTrip: Date?
    @NSManaged public var destination: String?
    @NSManaged public var id: Int16
    @NSManaged public var lodging: String?
    @NSManaged public var returnTransfer: Date?
    @NSManaged public var returnTrip: Date?
    @NSManaged public var transferDate: Date?
    @NSManaged public var relationship: NewTrip?
    @NSManaged public var hotelArriveDate: Date?
    @NSManaged public var hotelDepatureDate: Date?

}

extension NewTrip : Identifiable {

}
