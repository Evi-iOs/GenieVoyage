//
//  CreateTripView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.12.2023.
//

import UIKit

class CreateTripView: UIView {
    
    @IBOutlet weak var dateTrip: UIDatePicker!
    
    @IBAction func dateTripPickerAction(_ picker: UIDatePicker) {
        viewModel.dateTrip = picker.date
    }
    
    @IBAction func createNewTrip(_ sender: Any) {
        viewModel.createTripSelected()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    weak var viewModel: CreateNewTripViewModel! {
        didSet {
            configure(with: viewModel)
        }
    }
    
    private func configure(with viewModel: CreateNewTripViewModel) {
        
    }
}
