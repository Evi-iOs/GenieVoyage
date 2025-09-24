//
//  StartPlanningViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 06.01.2025.
//

import UIKit
import MapKit

class StartPlanningViewController: UIViewController {
    
    var onSave: ((TripModel) -> Void)?
    var onClose: (() -> Void)?
    
    var existingTrip: TripModel?
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var suggestions: [MKLocalSearchCompletion] = []
    private let suggestionsTableView = UITableView()
    
    private let tripListViewModel: TripListViewModel
    
    init(tripListViewModel: TripListViewModel) {
        self.tripListViewModel = tripListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        if let trip = existingTrip {
            titleTextField.text = trip.title
            startDatePicker.date = trip.startDate
            endDatePicker.date = trip.endDate
        }
    }
    
    private let titleTextField = UITextField()
    
    private let dateView = UIView()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let saveButton = UIButton(type: .system)
   
    private func setupUI() {
        view.backgroundColor = .white

        titleTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleTextField.setPlaceholder(text: "Where to go?", color: .gray)
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = 8
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        titleTextField.leftView = paddingView
        titleTextField.leftViewMode = .always
        
        dateView.layer.borderWidth = 0.5
        dateView.layer.borderColor = UIColor.lightGray.cgColor
        dateView.layer.cornerRadius = 8
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        startDateLabel.text = "Start:"
        startDateLabel.font = UIFont.systemFont(ofSize: 18)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        endDateLabel.text = "End:"
        endDateLabel.font = UIFont.systemFont(ofSize: 18)
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .automatic
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.bigBlackButtonStyle(text: "Start planning")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isHidden = true
        suggestionsTableView.layer.borderWidth = 0.5
        suggestionsTableView.layer.borderColor = UIColor.lightGray.cgColor
        suggestionsTableView.layer.cornerRadius = 8
        suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(suggestionsTableView)
        
        view.addSubview(titleTextField)
        
        view.addSubview(dateView)
        dateView.addSubview(startDateLabel)
        dateView.addSubview(startDatePicker)
        dateView.addSubview(endDateLabel)
        dateView.addSubview(endDatePicker)
        
        view.addSubview(saveButton)
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Enter title Trip")
            return
        }

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        let updatedTrip: TripModel

        if var existingTrip = existingTrip {
            existingTrip.title = title
            existingTrip.startDate = startDate
            existingTrip.endDate = endDate
            updatedTrip = existingTrip
        } else {
            updatedTrip = TripModel(
                id: UUID(),
                title: title,
                startDate: startDate,
                endDate: endDate,
                days: [TripDay]()
            )
            existingTrip = updatedTrip
        }
        Task { [weak self] in
            guard let self else { return }
            await self.tripListViewModel.addTrip(updatedTrip)
            self.onSave?(updatedTrip)
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let text = titleTextField.text, !text.isEmpty else {
            suggestionsTableView.isHidden = true
            return
        }
        searchCompleter.queryFragment = text
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            dateView.heightAnchor.constraint(equalToConstant: 120),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            startDateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20),
            startDateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 30),
            
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 20),
            startDatePicker.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 30),
            
            endDateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20),
            endDateLabel.leadingAnchor.constraint(equalTo: endDatePicker.leadingAnchor),
            endDateLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -30),
            
            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 20),
            endDatePicker.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -30),
            
            titleTextField.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 50),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            suggestionsTableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            suggestionsTableView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            suggestionsTableView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            suggestionsTableView.heightAnchor.constraint(equalToConstant: 180),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}

extension StartPlanningViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
        suggestionsTableView.isHidden = suggestions.isEmpty
        suggestionsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

extension StartPlanningViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = suggestion.title + " " + suggestion.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = suggestions[indexPath.row]
        titleTextField.text = selected.title
        suggestionsTableView.isHidden = true
        titleTextField.resignFirstResponder()
    }
}
