//
//  CreateNewTripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 04.11.2023.
//

import UIKit

class CreateNewTripViewController: UIViewController {
        
    private var createTripView: CreateTripView = .loadNib()
    
    private let coreDataManager = CoreDataManager.shared
    
    lazy var viewModel = CreateNewTripViewModel(coreDataManager: coreDataManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        createTripView.viewModel = viewModel
        self.view = createTripView
    }
    
}
