//
//  TripDetailViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.11.2024.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    var trip: TripModel
    
    // UI elements
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let datesLabel = UILabel()
    private let destinationTableView = UITableView()
    
    init(trip: TripModel) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.layer.cornerRadius = 30
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray5
        
        let text = "Trip \(trip.startDate) - \(trip.endDate)"
        label.text = text
        label.textAlignment = .center
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        //setup titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        //setup discriptionLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        
        //setup datesLabel
        datesLabel.font = UIFont.italicSystemFont(ofSize: 14)
        datesLabel.textColor = .black
        datesLabel.textAlignment = .center
        
        //setup destinationTableView
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        destinationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DestinationCell")
        destinationTableView.separatorStyle = .singleLine
        destinationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(datesLabel)
        view.addSubview(destinationTableView)
        
        setupConstraints()
    }
    
    private func configureUI() {
        titleLabel.text = trip.title
        descriptionLabel.text = trip.description
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        datesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            datesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            datesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            destinationTableView.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 20),
            destinationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            destinationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            destinationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension TripDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip.destinations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath)
        let destination = trip.destinations?[indexPath.row]
        cell.textLabel?.text = destination?.name
        cell.detailTextLabel?.text = destination?.details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destination = trip.destinations?[indexPath.row]
        printContent("Selected destination: \(destination?.name)")
    }
}
