//
//  CoreDataTripStorageTests.swift
//  GenieVoyageTests
//
//  Created by Evgeniya  Iv on 11.08.2026.
//

import CoreData
import XCTest
@testable import GenieVoyage

final class CoreDataTripStorageTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var sut: CoreDataTripStorage!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.makeInMemoryContext()
        sut = CoreDataTripStorage(context: context, imageStorage: MockImageStorage())
    }
    
    override func tearDown() {
        context = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Basic trip save/load
    
    func test_saveTrip_thenLoadTrips_returnsSavedTrip() async {
        let trip = makeTrip(title: "Rome")
        
        await sut.saveTrip(trip)
        let loaded = await sut.loadTrips()
        
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, trip.id)
        XCTAssertEqual(loaded.first?.title, "Rome")
    }
    
    func test_saveTrip_twiceWithSameID_updatesRatherThanDuplicates() async {
        var trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        
        trip.title = "Rome Updated"
        await sut.saveTrip(trip)
        
        let loaded = await sut.loadTrips()
        XCTAssertEqual(loaded.count, 1, "сохранение с тем же id должно обновлять, а не дублировать")
        XCTAssertEqual(loaded.first?.title, "Rome Updated")
    }
    
    func test_deleteTrip_removesIt() async {
        let trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        
        await sut.deleteTrip(trip)
        let loaded = await sut.loadTrips()
        
        XCTAssertTrue(loaded.isEmpty)
    }
    
    // MARK: - Regression test: saveEvent silently fails if Trip isn't saved first
    
    func test_saveEvent_beforeTripIsSaved_eventIsNotPersisted() async {
        let trip = makeTrip(title: "Rome")
        let event = makeEvent(dateEvent: trip.startDate)
        
        await sut.saveEvent(event, to: trip)
        
        await sut.saveTrip(trip)
        let loadedEvents = await sut.loadEvents(for: trip)
        
        XCTAssertTrue(loadedEvents.isEmpty, "документирует существующее поведение: saveEvent до saveTrip теряет событие")
    }
    
    func test_saveEvent_afterTripIsSaved_eventIsPersisted() async {
        let trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        
        let event = makeEvent(dateEvent: trip.startDate)
        
        await sut.saveEvent(event, to: trip)
        let loadedEvents = await sut.loadEvents(for: trip)
        
        XCTAssertEqual(loadedEvents.count, 1)
        XCTAssertEqual(loadedEvents.first?.id, event.id)
    }
    
    // MARK: - Regression test: events must fall within Trip's actual day range
    
    func test_saveEvent_multipleEventsAcrossDifferentDays_allAreLoaded() async {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 2, to: startDate)!
        let trip = makeTrip(title: "Rome", startDate: startDate, endDate: endDate)
        await sut.saveTrip(trip)
        
        let day1Event = makeEvent(dateEvent: startDate)
        let day2Event = makeEvent(dateEvent: calendar.date(byAdding: .day, value: 1, to: startDate)!)
        let day3Event = makeEvent(dateEvent: endDate)
        
        await sut.saveEvent(day1Event, to: trip)
        await sut.saveEvent(day2Event, to: trip)
        await sut.saveEvent(day3Event, to: trip)
        
        let loadedEvents = await sut.loadEvents(for: trip)
        
        XCTAssertEqual(loadedEvents.count, 3, "все события за все дни трипа должны загружаться")
    }
    
    func test_saveEvent_eventDateOutsideTripRange_stillSavedButOnOwnDay() async {
        let calendar = Calendar.current
        let tripStart = calendar.startOfDay(for: Date())
        let trip = makeTrip(title: "Rome", startDate: tripStart, endDate: tripStart)
        await sut.saveTrip(trip)
        
        let farFutureDate = calendar.date(byAdding: .year, value: 1, to: tripStart)!
        let mismatchedEvent = makeEvent(dateEvent: farFutureDate)
        
        await sut.saveEvent(mismatchedEvent, to: trip)
        let loadedEvents = await sut.loadEvents(for: trip)
        
        XCTAssertEqual(loadedEvents.count, 1, "saveEvent сохраняет событие независимо от диапазона трипа")
    }
    
    func test_loadEvents_onSpecificDate_returnsOnlyThatDaysEvents() async {
        let calendar = Calendar.current
        let day1 = calendar.startOfDay(for: Date())
        let day2 = calendar.date(byAdding: .day, value: 1, to: day1)!
        let trip = makeTrip(title: "Rome", startDate: day1, endDate: day2)
        await sut.saveTrip(trip)
        
        await sut.saveEvent(makeEvent(dateEvent: day1), to: trip)
        await sut.saveEvent(makeEvent(dateEvent: day2), to: trip)
        
        let day1Events = await sut.loadEvents(for: trip, on: day1)
        
        XCTAssertEqual(day1Events.count, 1)
    }
    
    func test_deleteEvent_removesIt() async {
        let trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        let event = makeEvent(dateEvent: trip.startDate)
        await sut.saveEvent(event, to: trip)
        
        await sut.deleteEvent(event)
        let loadedEvents = await sut.loadEvents(for: trip)
        
        XCTAssertTrue(loadedEvents.isEmpty)
    }
    
    // MARK: - loadEvent(byID:) / loadTrip(byID:) — used by TicketsViewModel for source labels
    
    func test_loadEventByID_returnsCorrectEvent() async {
        let trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        let event = makeEvent(dateEvent: trip.startDate, locationName: "Colosseum")
        await sut.saveEvent(event, to: trip)
        
        let loaded = await sut.loadEvent(byID: event.id)
        
        XCTAssertEqual(loaded?.locationName, "Colosseum")
    }
    
    func test_loadEventByID_nonExistentID_returnsNil() async {
        let loaded = await sut.loadEvent(byID: UUID())
        XCTAssertNil(loaded)
    }
    
    func test_loadTripByID_returnsCorrectTrip() async {
        let trip = makeTrip(title: "Rome")
        await sut.saveTrip(trip)
        
        let loaded = await sut.loadTrip(byID: trip.id)
        
        XCTAssertEqual(loaded?.title, "Rome")
    }
    
    // MARK: - Helpers
    
    private func makeTrip(
        title: String,
        startDate: Date = Calendar.current.startOfDay(for: Date()),
        endDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
    ) -> TripModel {
        TripModel(
            id: UUID(),
            title: title,
            description: nil,
            startDate: startDate,
            endDate: endDate,
            coverImage: nil,
            days: []
        )
    }
    
    private func makeEvent(dateEvent: Date, locationName: String? = "Test Location") -> EventModel {
        EventModel(
            id: UUID(),
            dateEvent: dateEvent,
            category: .point,
            time: "10:00",
            startMinutes: 600,
            duration: 60,
            locationName: locationName,
            coordinate: nil
        )
    }
}
