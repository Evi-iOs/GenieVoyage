//
//  CoreDataStack.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.08.2025.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GenieVoyage")
        
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber,
                               forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber,
                               forKey: NSInferMappingModelAutomaticallyOption)
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save context: \(error)")
            }
        }
    }
}


