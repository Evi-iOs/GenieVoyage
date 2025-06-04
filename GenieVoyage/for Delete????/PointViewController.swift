//
//  PointViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 26.04.2025.
//

import UIKit
import MapKit

class PointViewController: UIViewController {
    
    private let locationTextField = UITextField()
    private let beginPicker = UIDatePicker()
    private let beginLabel = UILabel()
    private let endPicker = UIDatePicker()
    private let endLabel = UILabel()
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private var tableView = UITableView()
    
    private var selectedCoordinate: CLLocationCoordinate2D?
    private var selectedLocationName: String?
    
    private let headerView = UIView()
    private let saveButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    var preselectedStartMinutes: Int?
    var selectedCategory: EventCategory?
    
    var onSave: ((EventModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTimePickers()
        setupUI()
        setupSearch()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        locationTextField.placeholder = "Add place"
        locationTextField.borderStyle = .roundedRect
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        locationTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        locationTextField.backgroundColor = UIColor.systemGray6
        locationTextField.layer.cornerRadius = 8
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        locationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        locationTextField.leftViewMode = .always
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [locationTextField, tableView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            stack.topAnchor.constraint(equalTo: pickersStack.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.titleLabel?.tintColor = .red
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.titleLabel?.tintColor = .red
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        headerView.addSubview(saveButton)
        headerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    private lazy var pickersStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [beginLabel, beginPicker, endLabel, endPicker])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func setupTimePickers() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
            
        if let minutes = preselectedStartMinutes {
            let hour = minutes / 60
            let minute = minutes % 60
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = hour
            components.minute = minute
            
            if let date = Calendar.current.date(from: components) {
                beginPicker.date = date
                endPicker.date = date
            }
        }

        beginLabel.text = "Begin event:"
        beginLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        beginPicker.datePickerMode = .time
        beginPicker.preferredDatePickerStyle = .compact
        beginPicker.translatesAutoresizingMaskIntoConstraints = false
        
        endLabel.text = "End:"
        endLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        endPicker.datePickerMode = .time
        endPicker.preferredDatePickerStyle = .compact
        endPicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pickersStack)

        NSLayoutConstraint.activate([
            pickersStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            pickersStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pickersStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pickersStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Setup Search
    func setupSearch() {
        searchCompleter.delegate = self
    }
    
    @objc func textFieldDidChange() {
        searchCompleter.queryFragment = locationTextField.text ?? ""
        tableView.isHidden = false
    }
    
    // MARK: - Save Action
    @objc func saveTapped() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: beginPicker.date)
        let rawMinutes = Int(beginPicker.date.timeIntervalSince(startOfDay) / 60)

        guard let address = locationTextField.text, !address.isEmpty, validateTimes() else { return }
        
        let event = EventModel(
            id: UUID(),
            category: selectedCategory ?? .point,
            icon: UIImage(systemName: selectedCategory?.iconSystemName ?? "car") ?? UIImage(),
            time: DateFormatter.localizedString(from: beginPicker.date, dateStyle: .none, timeStyle: .short),
            startMinutes: rawMinutes,
            duration: Int(endPicker.date.timeIntervalSince(beginPicker.date))/60,
            locationName: selectedLocationName,
            coordinate: selectedCoordinate
        )
        onSave?(event)
        dismiss(animated: true)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Validate Time
    private func validateTimes() -> Bool {
        let startTime = beginPicker.date
        let endTime = endPicker.date
        
        if startTime >= endTime {
            showInvalidTimeAlert()
            return false
        }
        return true
    }
   
    private func showInvalidTimeAlert() {
        let alert = UIAlertController(
            title: "Incorrect time",
            message: "Start time must be earlier than end time.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension PointViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title + ", " + result.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let self = self,
                  let mapItem = response?.mapItems.first else { return }
            
            let coordinate = mapItem.placemark.coordinate
            let name = result.title
            
            self.locationTextField.text = result.subtitle
            self.selectedCoordinate = coordinate
            self.selectedLocationName = name
            
            self.tableView.isHidden = true
            self.locationTextField.resignFirstResponder()
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension PointViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error search: \(error.localizedDescription)")
    }
}
