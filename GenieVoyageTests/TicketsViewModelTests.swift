//
//  TicketsViewModelTests.swift
//  GenieVoyageTests
//
//  Created by Evgeniya  Iv on 11.08.2026.
//

import XCTest
@testable import GenieVoyage

final class TicketsViewModelTests: XCTestCase {
    
    private var ticketFileStorage: MockTicketFileStorage!
    private var tripStorage: MockTripStorage!
    private var sut: TicketsViewModel!
    
    override func setUp() {
        super.setUp()
        ticketFileStorage = MockTicketFileStorage()
        tripStorage = MockTripStorage()
        sut = TicketsViewModel(ticketFileStorage: ticketFileStorage, tripStorage: tripStorage)
    }
    
    override func tearDown() {
        ticketFileStorage = nil
        tripStorage = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Loading
    
    func test_loadFiles_showsAllFilesWhenSearchIsEmpty() async {
        // given
        ticketFileStorage.files = [
            makeFile(name: "boarding_pass.pdf"),
            makeFile(name: "hotel_confirmation.pdf")
        ]
        
        // when
        await sut.loadFiles()
        
        // then
        XCTAssertEqual(sut.numberOfItems, 2)
    }
    
    // MARK: - Regression test: bug where allItems was never populated,
    // causing the list to go empty after any add/delete/search operation
    
    func test_addFile_doesNotClearExistingFiles() async {
        ticketFileStorage.files = [makeFile(name: "existing.pdf")]
        await sut.loadFiles()
        XCTAssertEqual(sut.numberOfItems, 1, "precondition: одно существующее file")
        
        let newFileURL = URL(fileURLWithPath: "/tmp/new_ticket.pdf")
        await sut.addFile(from: newFileURL)
        
        XCTAssertEqual(sut.numberOfItems, 2, "после addFile список не должен схлопываться до 0/1")
    }
    
    func test_deleteFile_removesOnlyTargetFile_keepsOthers() async {
        ticketFileStorage.files = [
            makeFile(name: "keep_me.pdf"),
            makeFile(name: "delete_me.pdf")
        ]
        await sut.loadFiles()
        XCTAssertEqual(sut.numberOfItems, 2)
        
        let indexToDelete = (0..<sut.numberOfItems).first {
            sut.item(at: $0).file.fileName == "delete_me.pdf"
        }!
        
        // when
        await sut.deleteFile(at: indexToDelete)
        
        XCTAssertEqual(sut.numberOfItems, 1)
        XCTAssertEqual(sut.item(at: 0).file.fileName, "keep_me.pdf")
    }
    
    // MARK: - Search
    
    func test_search_filtersFilesByFileName() async {
        ticketFileStorage.files = [
            makeFile(name: "boarding_pass.pdf"),
            makeFile(name: "hotel_confirmation.pdf")
        ]
        await sut.loadFiles()
        
        sut.updateSearch(query: "boarding")
        
        XCTAssertEqual(sut.numberOfItems, 1)
        XCTAssertEqual(sut.item(at: 0).file.fileName, "boarding_pass.pdf")
    }
    
    func test_search_isCaseInsensitive() async {
        ticketFileStorage.files = [makeFile(name: "Boarding_Pass.pdf")]
        await sut.loadFiles()
        
        sut.updateSearch(query: "BOARDING")
        
        XCTAssertEqual(sut.numberOfItems, 1)
    }
    
    func test_search_noMatch_returnsEmptyList() async {
        ticketFileStorage.files = [makeFile(name: "hotel.pdf")]
        await sut.loadFiles()
        
        sut.updateSearch(query: "nonexistent")
        
        XCTAssertEqual(sut.numberOfItems, 0)
        XCTAssertTrue(sut.isSearchActive)
    }
    
    func test_clearSearch_restoresFullList() async {
        ticketFileStorage.files = [
            makeFile(name: "boarding_pass.pdf"),
            makeFile(name: "hotel_confirmation.pdf")
        ]
        await sut.loadFiles()
        sut.updateSearch(query: "boarding")
        XCTAssertEqual(sut.numberOfItems, 1, "precondition: поиск сузил список")
        
        sut.clearSearch()
        
        XCTAssertEqual(sut.numberOfItems, 2)
        XCTAssertFalse(sut.isSearchActive)
    }
    
    func test_search_thenAddFile_newFileVisibleWhenSearchCleared() async {
        ticketFileStorage.files = [makeFile(name: "existing.pdf")]
        await sut.loadFiles()
        
        sut.updateSearch(query: "existing")
        XCTAssertEqual(sut.numberOfItems, 1)
        
        await sut.addFile(from: URL(fileURLWithPath: "/tmp/new_unrelated.pdf"))
        
        sut.clearSearch()
        
        XCTAssertEqual(sut.numberOfItems, 2, "оба файла должны быть видны после очистки поиска")
    }
    
    // MARK: - Helpers
    
    private func makeFile(name: String, eventID: UUID? = nil, tripID: UUID? = nil) -> TicketFileModel {
        TicketFileModel(
            id: UUID(),
            fileName: name,
            relativePath: "Tickets/\(name)",
            fileType: name.hasSuffix(".pdf") ? "pdf" : "image",
            dateAdded: Date(),
            eventID: eventID,
            tripID: tripID
        )
    }
}
