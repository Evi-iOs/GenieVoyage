//
//  AddEditTripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos

class AddEditTripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trip: TripModel?
    var onSave: ((TripModel) -> Void)?
    
    //UI elements
    private let destinationLabel = UILabel()
    private let titleTextField = UITextField()
    private let stackView = UIStackView()
    
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
    
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let viewModel = ItineraryViewModel()
    
    // MARK: - UI Elements
        private let segmentedControl: UISegmentedControl = {
            let control = UISegmentedControl()
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
        }()
        
        private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
    
    // MARK: - Data
    lazy var days: [String] = generateDatesArray(from: trip?.startDate ?? Date(), to: trip?.endDate ?? Date())
    
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
        configureSegmentedControl()
        configureCollectionView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        contentView.addSubview(collectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(segmentedControl)

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
            
            segmentedControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // CollectionView below segmented control
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            //Cancel Button
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
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
        
        let icon = UIImage(systemName: "airplane")
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
    
    @objc private func cancelButtonTapped() {
        print("Cancel editing")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.selectedDayIndex = sender.selectedSegmentIndex
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.removeAllSegments()
        for index in 0..<viewModel.numberOfDays() {
            segmentedControl.insertSegment(withTitle: viewModel.titleForDay(at: index), at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
        
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItineraryItemCell.self, forCellWithReuseIdentifier: ItineraryItemCell.identifier)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onDayChanged = { [weak self] in
            self?.collectionView.reloadData()
        }
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
    
    //MARK: - Additional func
    private func generateDatesArray(from startDate: Date, to endDate: Date) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        var currentDate = normalizedStartDate
        while currentDate <= normalizedEndDate {
            let dateString = currentDate.formatted()
            dates.append(dateString)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension AddEditTripViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsForSelectedDay()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItineraryItemCell.identifier, for: indexPath) as? ItineraryItemCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.itemForIndex(indexPath.item)
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 80)
    }
}
