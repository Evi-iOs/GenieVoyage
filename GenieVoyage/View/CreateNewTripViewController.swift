//
//  CreateNewTripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.11.2023.
//

import UIKit

class CreateNewTripViewController: UIViewController {

    private let viewModel = CreateNewTripViewModel(dateTrip: Date(), destination: "sgfdgf")
    
    private var createTripView: CreateTripView = .loadNib()
    
    let dataManager = CoreDataManager.schared.createNewTrip(id: <#T##Int16#>, dateTrip: <#T##Date#>, returnTrip: <#T##Date?#>, destination: <#T##String#>, transferDate: <#T##Date?#>, returnTransferDate: <#T##Date?#>, lodginName: <#T##String?#>, hotelArrivalDate: <#T##Date?#>, hotelDepatureDate: <#T##Date?#>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view = createTripView
        
        createTripView.viewModel = viewModel
        
    }

}
