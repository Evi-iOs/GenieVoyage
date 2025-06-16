//
//  ItineraryDetailViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.12.2024.
//


import UIKit
import CoreLocation

struct DayPlan {
    let date: Date
    var events: [Event]
}

struct Event {
    let title: String
    let time: Date
    let description: String?
    let destination: DestinationModel?
    var files: [URL]
}

struct DestinationModel {
    let id: UUID
    var name: String
    var details: String?
    var date: Date
    var notes: String
    var location: CLLocationCoordinate2D?
    var category: DestinationCategory?
}

enum DestinationCategory: String {
    case food, attraction, hotel, transport, shopping
}

class PlanDayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var onSave: ((DayPlan) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    init(dayPlan: DayPlan) {
        self.dayPlan = dayPlan
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    private let addEventButton = UIButton(type: .system)
    private var dayPlan: DayPlan

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Plan Day \(dayPlan.date.formattedDateWeekDay())"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = backButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        addEventButton.setTitle("Add", for: .normal)
        addEventButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)
        addEventButton.backgroundColor = .darkGray
        addEventButton.setTitleColor(.white, for: .normal)
        addEventButton.layer.cornerRadius = 25
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addEventButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addEventButton.widthAnchor.constraint(equalToConstant: 50),
            addEventButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func configureUI() {
        tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func addEventTapped() {
        let addEventVC = EventViewController()
        addEventVC.onSave = { [weak self] newEvent in
            self?.dayPlan.events.append(newEvent)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @objc private func backButtonAction() {
        onSave?(dayPlan)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayPlan.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = dayPlan.events[indexPath.row]
        cell.textLabel?.text = "\(event.time.formattedTime()) - \(event.title)"
        cell.detailTextLabel?.text = event.description
        if let destination = event.destination {
            cell.imageView?.image = destination.category?.icon()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dayPlan.events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
