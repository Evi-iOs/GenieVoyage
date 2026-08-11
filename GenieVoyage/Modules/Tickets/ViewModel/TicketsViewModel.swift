//
//  TicketsViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 05.07.2026.
//

import Foundation

final class TicketsViewModel {
    
    private let ticketFileStorage: TicketFileStorage
    private let tripStorage: TripStorage
    private var allItems: [TicketFileDisplayItem] = []
    
    private(set) var displayItems: [TicketFileDisplayItem] = [] {
        didSet { onItemsUpdated?() }
    }
    
    private var searchQuery: String = ""
    
    var onItemsUpdated: (() -> Void)?
    
    init(ticketFileStorage: TicketFileStorage, tripStorage: TripStorage) {
        self.ticketFileStorage = ticketFileStorage
        self.tripStorage = tripStorage
    }
    
    @MainActor
    func loadFiles() async {
        let files = await ticketFileStorage.loadAllFiles()
        allItems = await resolveSourceLabels(for: files)
        applyFilter()
    }
    
    private func resolveSourceLabels(for files: [TicketFileModel]) async -> [TicketFileDisplayItem] {
        var items: [TicketFileDisplayItem] = []
        for file in files {
            var label: String? = nil
            if let eventID = file.eventID {
                label = (await tripStorage.loadEvent(byID: eventID))?.locationName.map { "Event: \($0)" }
            } else if let tripID = file.tripID {
                label = (await tripStorage.loadTrip(byID: tripID)).map { "Trip: \($0.title)" }
            }
            items.append(TicketFileDisplayItem(file: file, sourceLabel: label))
        }
        return items
    }
    
    // MARK: - Search
    
    func updateSearch(query: String) {
        searchQuery = query
        applyFilter()
    }
    
    func clearSearch() {
        searchQuery = ""
        applyFilter()
    }
    
    private func applyFilter() {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            displayItems = allItems
        } else {
            displayItems = allItems.filter { item in
                item.file.fileName.localizedCaseInsensitiveContains(trimmed) ||
                (item.sourceLabel?.localizedCaseInsensitiveContains(trimmed) ?? false)
            }
        }
    }
    
    var isSearchActive: Bool {
        !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Adding
    
    @MainActor
    func addFile(from url: URL) async {
        guard let saved = await ticketFileStorage.saveFile(from: url, eventID: nil, tripID: nil) else { return }
        let item = TicketFileDisplayItem(file: saved, sourceLabel: nil)
        allItems.insert(item, at: 0)
        applyFilter()
    }
    
    // MARK: - Deleting
    
    @MainActor
    func deleteFile(at index: Int) async {
        guard displayItems.indices.contains(index) else { return }
        let file = displayItems[index].file
        await ticketFileStorage.deleteFile(file)
        allItems.removeAll { $0.file.id == file.id } 
        applyFilter()
    }
    
    var numberOfItems: Int {
        displayItems.count
    }
    
    func item(at index: Int) -> TicketFileDisplayItem {
        displayItems[index]
    }
    
    func fileURL(at index: Int) -> URL {
        ticketFileStorage.absoluteURL(for: displayItems[index].file)
    }
}
