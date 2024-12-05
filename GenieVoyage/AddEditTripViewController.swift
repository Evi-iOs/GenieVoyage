//
//  AddEditTripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos

class AddEditTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trip: TripModel?
    var onSave: ((TripModel) -> Void)?
    
    //UI elements
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
    private let placesTableView = UITableView()
    private let addPlaceButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Data
    private var places: [String] = []
    
    init(trip: TripModel? = nil, onSave: ((TripModel) -> Void)? = nil) {
        self.trip = trip
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupUI()
        configureUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = trip == nil ? "Add Trip" : "Edit Trip"
        
        titleTextField.placeholder = "Title Trip"
        titleTextField.font = UIFont.systemFont(ofSize: 18)
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .automatic
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addCoverButton.setTitle("Add Cover", for: .normal)
        addCoverButton.addTarget(self, action: #selector(addCoverTapped), for: .touchUpInside)
        addCoverButton.translatesAutoresizingMaskIntoConstraints = false
               
        placesTableView.dataSource = self
        placesTableView.delegate = self
        placesTableView.layer.borderColor = UIColor.gray.cgColor
        placesTableView.layer.borderWidth = 1
        placesTableView.layer.cornerRadius = 10
        placesTableView.translatesAutoresizingMaskIntoConstraints = false
        placesTableView.isScrollEnabled = false
        
        addPlaceButton.setTitle("Add Place", for: .normal)
        addPlaceButton.addTarget(self, action: #selector(addPlaceTapped), for: .touchUpInside)
        addPlaceButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.applyPaperStyleWithGloss(withText: "Cancel")
        
        saveButton.applyPaperStyleWithGloss(withText: "Save")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(startDatePicker)
        contentView.addSubview(endDatePicker)
        contentView.addSubview(coverImageView)
        contentView.addSubview(addCoverButton)
        contentView.addSubview(placesTableView)
        contentView.addSubview(addPlaceButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
    }
    
    private func configureUI() {
        if let trip = trip {
            titleTextField.text = trip.title
            descriptionTextView.text = trip.description
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            if let startDate = dateFormater.date(from: trip.startDate.description) {
                startDatePicker.date = startDate
            }
            if let endDate = dateFormater.date(from: trip.endDate.description) {
                endDatePicker.date = endDate
            }
        }
    }
    
    // MARK: - Setup Scroll View
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        setupConstraintsForScrollView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        setupConstraintsForContentView()
    }
    
    private func setupConstraintsForScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 50),
            
            startDatePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            startDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 10),
            endDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            coverImageView.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coverImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Add Cover Button
            addCoverButton.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10),
            addCoverButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Places Table View
            placesTableView.topAnchor.constraint(equalTo: addCoverButton.bottomAnchor, constant: 20),
            placesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            placesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            placesTableView.heightAnchor.constraint(equalToConstant: 100),

            // Add Place Button
            addPlaceButton.topAnchor.constraint(equalTo: placesTableView.bottomAnchor, constant: 10),
            addPlaceButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Save Button
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 44),

            //Cancel Button
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Enter title Trip")
            return
        }
        let description = descriptionTextView.text ?? ""
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        let newTrip = TripModel(
            id: UUID(), title: title, description: description, startDate: startDate, endDate: endDate, destinations: trip?.destinations ?? [])
        
        onSave?(newTrip)
        //TODO: save CoreData
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addCoverTapped() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        self.openPhotoPicker()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Access to the photo library was denied.")
                    }
                }
            }
            
        case .authorized, .limited:
            openPhotoPicker()
            
        case .denied, .restricted:
            showAlert(message: "Access to the photo library is restricted.")
            
        @unknown default:
            showAlert(message: "Unknown photo library authorization status.")
        }
    }

    private func openPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

        
        @objc private func addPlaceTapped() {
            let mapViewController = MapViewController()
                mapViewController.onPlaceSelected = { place in
                    //self.places.append(place)
                    self.placesTableView.reloadData()
                }
                navigationController?.pushViewController(mapViewController, animated: true)
        }
    
    @objc private func cancelButtonTapped() {
            print("Cancel editing")
            navigationController?.popViewController(animated: true)
        }
        
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                coverImageView.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "PlaceCell")
            cell.textLabel?.text = places[indexPath.row]
            return cell
        }
        
        // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
