//
//  CreateNewTripView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 01.11.2023.
//

import UIKit

class CreateNewTripView: UIView {

    @IBOutlet weak var dateTrip: UIDatePicker!
    @IBOutlet weak var returnTrip: UIDatePicker!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var transferDate: UIDatePicker!
    @IBOutlet weak var returnTransferDate: UIDatePicker!
    @IBOutlet weak var lodgingName: UITextField!
    @IBOutlet weak var hotelArrivalDate: UIDatePicker!
    @IBOutlet weak var hotelDepartureDate: UIDatePicker!
    
    weak var viewModel: CreateNewTripViewModel! {
        didSet {
            configure(with: viewModel)
        }
    }
    
    private func configure(with viewModel: CreateNewTripViewModel) {
        viewModel.dateTrip = dateTrip.date
        viewModel.returnTrip = returnTrip.date
        viewModel.destination = destination.text ?? "Destination"
        viewModel.transferDate = transferDate.date
        viewModel.returnTransferDate = returnTransferDate.date
        viewModel.lodgingName = lodgingName.text
        viewModel.hotelArrivalDate = hotelArrivalDate.date
        viewModel.hotelDepartureDate = hotelDepartureDate.date
    }
}
