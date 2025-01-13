//
//  StartPlanningViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 06.01.2025.
//

import UIKit

class StartPlanningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: titleTextField.frame.height))
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
        let trip = TripModel(id: UUID(), title: title, startDate: startDatePicker.date, endDate: endDatePicker.date)
        
        let addTripVC = AddEditTripViewController(trip: trip)

        self.navigationController?.pushViewController(addTripVC, animated: true)
    
        //TODO: save CoreData
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dateView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 50),
            dateView.heightAnchor.constraint(equalToConstant: 120),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            startDateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20),
            startDateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 30),
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 20),
            startDatePicker.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 30),
            
            endDateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 20),
            endDateLabel.leadingAnchor.constraint(equalTo: endDatePicker.leadingAnchor),
            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 20),
            endDatePicker.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -30),
           
            saveButton.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}
