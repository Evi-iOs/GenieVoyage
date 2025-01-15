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
    private let destinationLabel = UILabel()
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let stackView = UIStackView()
    
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
    
    private let itineraryLabel = UILabel()
    private let itineraryTableView = UITableView()
    private let addItineraryButton = UIButton(type: .system)
    private var itineraryTableViewHeightConstraint: NSLayoutConstraint!
    
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    lazy var daysView = DaysTripCollectionView(frame: .zero, startDate: trip?.startDate, endDate: trip?.endDate)
    
    // MARK: - Data
    private var itinerary: [DayPlan] = []
    
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
        configureUI()
        setupUI()
        setupIconButtons()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = trip == nil ? "Add Trip" : "Trip to \(trip?.title ?? "Trip")"
        
        destinationLabel.text = "Destination"
        destinationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        destinationLabel.textColor = UIColor.gray
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.placeholder = trip?.title ?? "Title"
        titleTextField.font = UIFont.boldSystemFont(ofSize: 20)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        startDateLabel.text = "\((trip != nil) ? trip!.startDate.formattedDate() : startDatePicker.date.formattedDate()) - \((trip != nil) ? trip!.endDate.formattedDate() : endDatePicker.date.formattedDate())"
        startDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        endDateLabel.text = "End Date Trip"
        endDateLabel.font = UIFont.systemFont(ofSize: 18)
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .automatic
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addCoverButton.applyPaperStyleWithGloss(withText: "Image")
        addCoverButton.addTarget(self, action: #selector(addCoverTapped), for: .touchUpInside)
        addCoverButton.translatesAutoresizingMaskIntoConstraints = false
        
        daysView.translatesAutoresizingMaskIntoConstraints = false
        
        itineraryLabel.text = "Itinerary"
        itineraryLabel.font = UIFont.boldSystemFont(ofSize: 28)
        itineraryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itineraryTableView.dataSource = self
        itineraryTableView.delegate = self
        itineraryTableView.register(ItineraryCell.self, forCellReuseIdentifier: "ItineraryCell")
        itineraryTableView.layer.borderColor = UIColor.gray.cgColor
        itineraryTableView.layer.borderWidth = 1
        itineraryTableView.layer.cornerRadius = 10
        itineraryTableView.translatesAutoresizingMaskIntoConstraints = false
        itineraryTableView.estimatedRowHeight = 44
        itineraryTableView.rowHeight = UITableView.automaticDimension
        itineraryTableView.isScrollEnabled = false
        itineraryTableViewHeightConstraint = itineraryTableView.heightAnchor.constraint(equalToConstant: 0)
        itineraryTableViewHeightConstraint.isActive = true
        
        addItineraryButton.setTitle("Add Day", for: .normal)
        addItineraryButton.addTarget(self, action: #selector(addDayTapped), for: .touchUpInside)
        addItineraryButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.applyPaperStyleWithGloss(withText: "Cancel")
        
        saveButton.applyPaperStyleWithGloss(withText: "Save")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(destinationLabel)
        contentView.addSubview(titleTextField)
       // contentView.addSubview(descriptionTextView)
        
        contentView.addSubview(startDateLabel)
//        contentView.addSubview(endDateLabel)
//        contentView.addSubview(startDatePicker)
//        contentView.addSubview(endDatePicker)
//        
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(addCoverButton)
        
        contentView.addSubview(daysView)
        contentView.addSubview(itineraryLabel)
        contentView.addSubview(itineraryTableView)
        contentView.addSubview(addItineraryButton)
        
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
    }
    
    private func setupIconButtons() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 1...5 {
            let button = createIconButton(iconName: "plane")
            stackView.addArrangedSubview(button)
        }
        contentView.addSubview(stackView)
    }
    
    private func configureUI() {
        if let trip = trip {
            titleTextField.text = trip.title
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
    
    private func updateTableViewHeight() {
        itineraryTableView.layoutIfNeeded()
        itineraryTableViewHeightConstraint.constant = itineraryTableView.contentSize.height
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
            //Cover Image
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 85),
            coverImageView.widthAnchor.constraint(equalToConstant: 85),
            
            //Add Cover Button
            addCoverButton.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            addCoverButton.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            addCoverButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            addCoverButton.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            
            //Title
            destinationLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 20),
            destinationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            titleTextField.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 20),
            
            startDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            startDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            daysView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            daysView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daysView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daysView.heightAnchor.constraint(equalToConstant: 250),

            
//            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
//            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
//            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            descriptionTextView.heightAnchor.constraint(equalToConstant: 50),
            
           
            //Date Label
//            
//            endDateLabel.bottomAnchor.constraint(equalTo: endDatePicker.bottomAnchor),
//            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            
//            //Date Picker
//            startDatePicker.topAnchor.constraint(equalTo: addCoverButton.bottomAnchor, constant: 20),
//            startDatePicker.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
//            
//            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 10),
//            endDatePicker.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
//            
            // Iteinerary Table View
            itineraryLabel.topAnchor.constraint(equalTo: daysView.bottomAnchor, constant: 25),
            itineraryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            itineraryTableView.topAnchor.constraint(equalTo: itineraryLabel.bottomAnchor, constant: 20),
            itineraryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itineraryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addItineraryButton.topAnchor.constraint(equalTo: itineraryTableView.bottomAnchor, constant: 16),
            addItineraryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: addItineraryButton.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            //Cancel Button
            cancelButton.topAnchor.constraint(equalTo: addItineraryButton.bottomAnchor, constant: 20),
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
    
    @objc private func  addCoverTapped() {
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
    
    private func createIconButton(iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
                        
        let icon = UIImage(systemName: iconName) ?? UIImage(systemName: "circle")!
        button.setImage(icon, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }

    private func openPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func addDayTapped() {
        let newDay = DayPlan(date: Date(), events: [])
        itinerary.append(newDay)
        itineraryTableView.reloadData()
        updateTableViewHeight()
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
            return itinerary.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as! ItineraryCell
        let dayPlan = itinerary[indexPath.row]
        cell.configure(with: dayPlan)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dayPlan = itinerary[indexPath.row]
        let planDayVC = PlanDayDetailViewController(dayPlan: dayPlan)
        planDayVC.onSave = { [weak self] dayPlan in
            if let index = self?.itinerary.firstIndex(where: { $0.date == dayPlan.date }){
                self?.itinerary[index] = dayPlan
                self?.itineraryTableView.reloadData()
                self?.updateTableViewHeight()
            }
        }
        navigationController?.pushViewController(planDayVC, animated: true)
    }
        
        // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itinerary.remove(at: indexPath.row)
            itineraryTableView.deleteRows(at: [indexPath], with: .fade)
            itineraryTableView.reloadData()
            updateTableViewHeight()
        }
    }
}
