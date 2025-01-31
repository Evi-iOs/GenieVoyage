//
//  TripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos

class TripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trip: TripModel?
    var onSave: ((TripModel) -> Void)?
    
    private lazy var viewModel = ItineraryViewModel(trip: trip)
    
    // MARK: UI elements
    private let destinationLabel = UILabel()
    private let titleTextField = UITextField()
    private let stackView = UIStackView()
    
    private let datesLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
    
    private let itineraryLabel = UILabel()
    
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
        
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
        configureUI()
        setupUI()
        setupIconButtons()
        setupHorizontalScrollView()
        configureSegmentedControl()
        configureCollectionView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        underlineViewSegmentControl.frame = CGRect(x: 0, y: segmentedControl.frame.maxY - 2, width: segmentWidth, height: 2)
        
        setupConstraints()
        setupConstraintsForSegmentedControl()
        setupUnderlineViewForSegmentControll()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .darkGray
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = trip == nil ? "Add Trip" : "Trip to \(trip?.title ?? "Trip")"
        
        destinationLabel.text = "Destination"
        destinationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        destinationLabel.textColor = UIColor.gray
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.placeholder = trip?.title ?? "Title"
        titleTextField.font = UIFont.boldSystemFont(ofSize: 20)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        datesLabel.text = "\((trip != nil) ? trip!.startDate.formattedDateWeekDay() : startDatePicker.date.formattedDateWeekDay()) - \((trip != nil) ? trip!.endDate.formattedDateWeekDay() : endDatePicker.date.formattedDateWeekDay())"
        datesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        datesLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        itineraryLabel.text = "Itinerary:"
        itineraryLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        itineraryLabel.textColor = UIColor.darkGray
        itineraryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.applyPaperStyleWithGloss(withText: "Cancel")
        
        saveButton.applyPaperStyleWithGloss(withText: "Save")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        view.addSubview(destinationLabel)
        view.addSubview(titleTextField)
        
        view.addSubview(datesLabel)
        //        contentView.addSubview(startDatePicker)
        //        contentView.addSubview(endDatePicker)
        //
        view.addSubview(coverImageView)
        coverImageView.addSubview(addCoverButton)
        
        view.addSubview(itineraryLabel)
        view.addSubview(collectionView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
    }
    
    private func setupIconButtons() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 1...5 {
            let button = createIconButton(iconName: "airplane")
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
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
        
        let icon = UIImage(systemName: iconName)?.withTintColor(.darkGray)
        button.setImage(icon, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }
    
    // MARK: - Setup Scroll View
    
    private func setupHorizontalScrollView() {
        view.addSubview(horizontalScrollView)
        horizontalScrollView.sizeToFit()
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.contentSize = CGSize(width: 1000, height: horizontalScrollView.frame.height)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //Cover Image
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 85),
            coverImageView.widthAnchor.constraint(equalToConstant: 85),
            
            //Add Cover Button
            addCoverButton.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            addCoverButton.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            addCoverButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            addCoverButton.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            
            //Title
            destinationLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 20),
            destinationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 20),
            
            datesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            datesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            horizontalScrollView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 60),
            
            itineraryLabel.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: 18),
            itineraryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itineraryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
            // CollectionView below segmented control
            collectionView.topAnchor.constraint(equalTo: itineraryLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            //Cancel Button
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - SegmentControl
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control .sizeToFit()
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.tintColor = .clear
        
        control.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 17, weight: .bold)], for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private func setupConstraintsForSegmentedControl() {
        horizontalScrollView.addSubview(segmentedControl)
        horizontalScrollView.contentSize = segmentedControl.frame.size
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private let underlineViewSegmentControl: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private func setupUnderlineViewForSegmentControll() {
        horizontalScrollView.addSubview(underlineViewSegmentControl)
        
        underlineViewSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underlineViewSegmentControl.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 2),
            underlineViewSegmentControl.heightAnchor.constraint(equalToConstant: 2),
            underlineViewSegmentControl.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0 / CGFloat(segmentedControl.numberOfSegments))
        ])
    }
    
    private func configureSegmentedControl() {
        segmentedControl.removeAllSegments()
        for index in 0..<viewModel.numberOfDays() {
            segmentedControl.insertSegment(withTitle: viewModel.titleForDay(at: index), at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Collection View
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: - Actions
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
    
    @objc private func addCoverTapped() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized || status == .limited {
            openPhotoPicker()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    newStatus == .authorized || newStatus == .limited ? self.openPhotoPicker() : self.showAlert(message: "Access to the photo library was denied.")
                }
            }
        } else {
            showAlert(message: "Access to the photo library is restricted.")
        }
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
        
        let selectedIndex = CGFloat(sender.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let selectedSegmentX = segmentWidth * selectedIndex
        
        let offsetX = selectedSegmentX - (horizontalScrollView.frame.width / 2) + (segmentWidth / 2)
        let maxOffsetX = horizontalScrollView.contentSize.width - horizontalScrollView.frame.width
        let offset = min(max(offsetX, 0), maxOffsetX)
        
        if viewModel.days.count > 3 {
            horizontalScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        horizontalScrollView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            let selectedSegmentX = segmentWidth * CGFloat(selectedIndex)
            underlineViewSegmentControl.frame.origin.x = selectedSegmentX + 16
        })
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
}

// MARK: - UICollectionView DataSource & Delegate
extension TripViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDays()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.configure(with: viewModel.getDay(at: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 80)
    }
}
