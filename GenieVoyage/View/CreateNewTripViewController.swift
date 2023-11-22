//
//  CreateNewTripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.11.2023.
//

import UIKit

class CreateNewTripViewController: UIViewController {

    private let viewModel = CreateNewTripViewModel(dateTrip: Date(), destination: "sgfdgf")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let createNewTripView = CreateNewTripView()
        view.addSubview(createNewTripView)
    }

}
