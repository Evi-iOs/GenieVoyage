//
//  CoreDataTicketsStorage.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 05.07.2026.
//

import Foundation
import CoreData

final class CoreDataTicketFileStorage: TicketFileStorage {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    private var ticketsDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir = documents.appendingPathComponent("Tickets", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
    
    // MARK: - Save
    
    @discardableResult
    func saveFile(from sourceURL: URL, eventID: UUID? = nil, tripID: UUID? = nil) async -> TicketFileModel? {
        let context = self.context
        let ticketsDir = self.ticketsDirectory
        
        let destFileName = "\(UUID().uuidString)_\(sourceURL.lastPathComponent)"
        let destURL = ticketsDir.appendingPathComponent(destFileName)
        
        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
        } catch {
            print("❌ Failed to copy ticket file: \(error)")
            return nil
        }
        
        let model = TicketFileModel(
            id: UUID(),
            fileName: sourceURL.lastPathComponent,
            relativePath: "Tickets/\(destFileName)",
            fileType: sourceURL.pathExtension.lowercased() == "pdf" ? "pdf" : "image",
            dateAdded: Date(),
            eventID: eventID,
            tripID: tripID
        )
        
        return await context.perform {
            let entity = TicketFileEntity(context: context)
            entity.update(from: model)
            do {
                try context.save()
                print("✅ TicketFile \(model.id) saved (event: \(eventID?.uuidString ?? "nil"), trip: \(tripID?.uuidString ?? "nil"))")
                return model
            } catch {
                print("❌ Failed to save TicketFile: \(error)")
                return nil
            }
        }
    }
    
    // MARK: - Load
    
    func loadAllFiles() async -> [TicketFileModel] {
        let context = self.context
        return await context.perform {
            let request: NSFetchRequest<TicketFileEntity> = TicketFileEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
            do {
                let entities = try context.fetch(request)
                return entities.compactMap { $0.toModel() }
            } catch {
                print("❌ Failed to load ticket files: \(error)")
                return []
            }
        }
    }
    
    func loadFiles(forEventID eventID: UUID) async -> [TicketFileModel] {
        let context = self.context
        return await context.perform {
            let request: NSFetchRequest<TicketFileEntity> = TicketFileEntity.fetchRequest()
            request.predicate = NSPredicate(format: "eventID == %@", eventID as CVarArg)
            do {
                return try context.fetch(request).compactMap { $0.toModel() }
            } catch {
                print("❌ Failed to load files for event: \(error)")
                return []
            }
        }
    }
    
    func loadFiles(forTripID tripID: UUID) async -> [TicketFileModel] {
        let context = self.context
        return await context.perform {
            let request: NSFetchRequest<TicketFileEntity> = TicketFileEntity.fetchRequest()
            request.predicate = NSPredicate(format: "tripID == %@", tripID as CVarArg)
            do {
                return try context.fetch(request).compactMap { $0.toModel() }
            } catch {
                print("❌ Failed to load files for trip: \(error)")
                return []
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteFile(_ file: TicketFileModel) async {
        let context = self.context
        let url = absoluteURL(for: file)
        try? FileManager.default.removeItem(at: url)
        
        await context.perform {
            let request: NSFetchRequest<TicketFileEntity> = TicketFileEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", file.id as CVarArg)
            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    try context.save()
                }
            } catch {
                print("❌ deleteFile error: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    func absoluteURL(for file: TicketFileModel) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(file.relativePath)
    }
}
