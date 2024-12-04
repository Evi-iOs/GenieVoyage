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
    static let shared = CoreDataManager()
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TripPlanner")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Error loading persistent store: \(error)")
                }
            }
            return container
        }()
        
        var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }
}


