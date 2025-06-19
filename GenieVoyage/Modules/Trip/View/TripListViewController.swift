//
//  TripListViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import UIKit

final class TripListViewController: UIViewController {

    var onTripSelected: ((TripModel) -> Void)?
    var startPlanningSelected: (() -> Void)?

    private var trips: [TripModel] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trips"
        view.backgroundColor = .systemBackground

        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrip))
        navigationController?.navigationBar.tintColor = .darkGray
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripCell")
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func addTrip() {
        self.startPlanningSelected?()
    }
    
    func addNewTrip(trip: TripModel) {
        if trips.contains(where: { $0.id == trip.id }) {
            if let index = trips.firstIndex(where: { $0.id == trip.id }) {
                trips[index] = trip
            }
        } else {
            trips.append(trip)
        }
        tableView.reloadData()
    }
    
    func reloadTrips() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TripListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        let trip = trips[indexPath.row]
        cell.textLabel?.text = trip.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TripListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTrip = trips[indexPath.row]
        onTripSelected?(selectedTrip)
    }
}
