//
//  TestCoreDataStack.swift
//  GenieVoyageTests
//
//  Created by Evgeniya  Iv on 11.08.2026.
//

import CoreData
import XCTest
@testable import GenieVoyage

enum TestCoreDataStack {
    static func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "GenieVoyage")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container.viewContext
    }
}
