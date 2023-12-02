//
//  CreateNewTripViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 01.11.2023.
//

import Foundation

class CreateNewTripViewModel {
    var dateTrip: Date
    var returnTrip: Date?
    var destination: String
    var transferDate: Date?
    var returnTransferDate: Date?
    var lodgingName: String?
    var hotelArrivalDate: Date?
    var hotelDepartureDate: Date?
        
    init(dateTrip: Date, returnTrip: Date? = nil, destination: String, transferDate: Date? = nil, returnTransferDate: Date? = nil, lodgingName: String? = nil, hotelArrivalDate: Date? = nil, hotelDepartureDate: Date? = nil) {
        self.dateTrip = dateTrip
        self.returnTrip = returnTrip
        self.destination = destination
        self.transferDate = transferDate
        self.returnTransferDate = returnTransferDate
        self.lodgingName = lodgingName
        self.hotelArrivalDate = hotelArrivalDate
        self.hotelDepartureDate = hotelDepartureDate
    }
    
    func createTripSelected() {
        
    }

}
