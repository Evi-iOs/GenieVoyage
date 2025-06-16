//
//  EventViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 10.12.2024.
//

import UIKit
import PhotosUI
import MobileCoreServices
import MapKit
import CoreLocation

class EventViewController: UIViewController {
    
    var onSave: ((Event) -> Void)?
    
    // MARK: - Properties
    var event: Event?
    var destinations: [DestinationModel] = [] // All available destinations
    private var selectedFiles: [URL] = []
    private var selectedDestination: DestinationModel?

    // MARK: - UI Components
    private let titleTextField = UITextField()
    private let timePicker = UIDatePicker()
    private let descriptionTextView = UITextView()
    private let addLocationButton = UIButton()
    private let addFileButton = UIButton()
    private let filesTableView = UITableView()
    private let saveButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI Map
    private let mapView = MKMapView()
    private let selectLocationButton = UIButton(type: .system)
    private var selectedLocation: CLLocationCoordinate2D? {
           didSet {
               updateMap()
           }
       }
    private let locationManager = CLLocationManager()


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScrollView()
        setupConstraints()
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
    
    private func setupConstraintsForScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        titleTextField.placeholder = "Event Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        addLocationButton.setTitle("Go to Map", for: .normal)
        addLocationButton.addTarget(self, action: #selector(addLocationTapped), for: .touchUpInside)
        addLocationButton.darkGrayButtonStyle()
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false

        addFileButton.setTitle("Add File", for: .normal)
        addFileButton.addTarget(self, action: #selector(addFileTapped), for: .touchUpInside)
        addFileButton.darkGrayButtonStyle()
        addFileButton.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.darkGrayButtonStyle()
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        filesTableView.dataSource = self
        filesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FileCell")
        filesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Map View
        mapView.layer.cornerRadius = 8
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.systemGray4.cgColor
        mapView.isHidden = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.mapType = .standard
        
        contentView.addSubview(mapView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(timePicker)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(addLocationButton)
        contentView.addSubview(addFileButton)
        contentView.addSubview(filesTableView)
        contentView.addSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            timePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            descriptionTextView.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            addLocationButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            addLocationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            mapView.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 272),

            addFileButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            addFileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            filesTableView.topAnchor.constraint(equalTo: addFileButton.bottomAnchor, constant: 16),
            filesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filesTableView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: filesTableView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func selectDestinationTapped() {
        let alert = UIAlertController(title: "Select Destination", message: nil, preferredStyle: .actionSheet)
        for destination in destinations {
            alert.addAction(UIAlertAction(title: destination.name, style: .default, handler: { _ in
                self.selectedDestination = destination
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func addLocationTapped() {
        let mapVC = MapLocationViewController()
        mapVC.onLocationSelected = { [weak self] location in
            let newDestination = DestinationModel(
                id: UUID(),
                name: "Custom Location",
                details: nil,
                date: Date(),
                notes: "",
                location: location,
                category: nil
            )
            self?.selectedLocation = location
            self?.updateMap()
        }
        navigationController?.pushViewController(mapVC, animated: true)
    }

    @objc private func addFileTapped() {
        let alert = UIAlertController(title: "Add File", message: "Choose file type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { _ in
            self.presentImagePicker()
        }))
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { _ in
            self.presentDocumentPicker()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }

        let time = timePicker.date
        let description = descriptionTextView.text
        let destination = selectedDestination

        // Save the event
        let newEvent = Event(title: title, time: time, description: description, destination: destination, files: selectedFiles)
        onSave?(newEvent)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func updateMap() {
        guard let coordinate = selectedLocation else {
            mapView.isHidden = true
            return
        }
        
        mapView.isHidden = false
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
   
        view.updateConstraints()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension EventViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }
        result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] url, _ in
            guard let url = url else { return }
            DispatchQueue.main.async {
                self?.selectedFiles.append(url)
                self?.filesTableView.reloadData()
            }
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension EventViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFiles.append(contentsOf: urls)
        filesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath)
        cell.textLabel?.text = selectedFiles[indexPath.row].lastPathComponent
        return cell
    }
}

// MARK: - MKMapViewDelegate
extension EventViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "EventLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
