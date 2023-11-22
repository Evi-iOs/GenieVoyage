//
//  StartViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.08.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.schared.createNewTrip(1, dateTrip: Date(), returnTrip: Date(), destination: "ssss", transferDate: Date(), returnTransferDate: Date(), lodginName: "dsf", hotelArrivalDate: Date(), hotelDepatureDate: Date())
    }
    
    
 
    
}
