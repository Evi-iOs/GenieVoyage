//
//  TripsViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.11.2024.
//

import Foundation
import UIKit

class AllTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trips: [TripModel] = []
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trips"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripCell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrip))
    }
    
    @objc func addTrip() {
        let startPlanningVC = StartPlanningViewController()
        
        self.navigationController?.pushViewController(startPlanningVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        //let trip = trips[indexPath.row]
        cell.textLabel?.text = trips[indexPath.row].title
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        let tripDetailViewController = TripDetailViewController(trip: trip)
        navigationController?.pushViewController(tripDetailViewController, animated: true)
    }
    
    //Edit Trip
//    //let editTripVC = TripViewController()
//    editTripVC.trip = existingTrip
//    editTripVC.onSave = { updatedTrip in
//        print("Обновлённая поездка: \(updatedTrip)")
//        // Здесь обновите поездку в вашем массиве данных или Core Data
//    }
//    navigationController?.pushViewController(editTripVC, animated: true)
}
