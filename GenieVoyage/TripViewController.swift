//
//  TripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos

class TripViewController: UIViewController, UIImagePickerControllerDelegate, SegmentedControlDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var trip: TripModel?
    var onSave: ((TripModel) -> Void)?
    
    private lazy var viewModel = ItineraryViewModel(trip: trip)
    
    // MARK: UI elements
    private let destinationLabel = UILabel()
    private let titleText = UITextView()
    private let stackView = UIStackView()
    
    private let datesLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
        
    private let saveButton = UIButton(type: .system)
    
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
        configureCollectionView()
        bindViewModel()
        
        segmentedControl.delegate = self
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
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
        
        titleText.text = trip?.title ?? ""
        titleText.font = UIFont.boldSystemFont(ofSize: 18)
        titleText.isScrollEnabled = true
        titleText.textContainer.lineBreakMode = .byWordWrapping
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.delegate = self
        titleText.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
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
        
        addCoverButton.addTarget(self, action: #selector(addCoverTapped), for: .touchUpInside)
        addCoverButton.translatesAutoresizingMaskIntoConstraints = false
        addCoverButton.setImage(UIImage(named: "addPhoto"), for: .normal)
        addCoverButton.tintColor = .white
        addCoverButton.isUserInteractionEnabled = true
        addCoverButton.isHidden = false
        addCoverButton.alpha = 1

        saveButton.bigBlackButtonStyle(text: "Save")
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        view.addSubview(destinationLabel)
        view.addSubview(titleText)
        
        view.addSubview(datesLabel)
        view.addSubview(coverImageView)
        view.addSubview(addCoverButton)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(saveButton)
    }
    
    private func setupIconButtons() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let icons = ["plane", "treinIcon", "hotel", "ticketIcon", "fileIcon"]
        
        for i in icons {
            let button = createIconButton(iconName: i)
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
    }
    
    private func configureUI() {
        if let trip = trip {
            titleText.text = trip.title
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
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(hex: "#DADADA").cgColor
        button.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(imageView) 
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return button
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
            
            titleText.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            titleText.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: datesLabel.leadingAnchor, constant: -20),
            titleText.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            
            datesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            datesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Save Button
            saveButton.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: datesLabel.leadingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 32),
            
            stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 60),
            
            // CollectionView below segmented control
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35)
        ])
    }
    
    // MARK: - SegmentControl
    private lazy var segmentedControl = SegmentedControlView(items: viewModel.days)
    
    // MARK: - Collection View
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    // MARK: - Actions
    @objc private func saveButtonTapped() {
        guard let title = titleText.text, !title.isEmpty else {
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
            addCoverButton.imageView?.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        segmentedControl.selectSegment(at: pageIndex)
    }
    
    func didSelectSegment(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension TripViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.getDay(at: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = collectionView.frame.width * 0.9
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = collectionView.frame.width * 0.9 + layout.minimumLineSpacing
        
        let estimatedIndex = round((targetContentOffset.pointee.x + collectionView.contentInset.left) / cellWidth)
        targetContentOffset.pointee = CGPoint(x: estimatedIndex * cellWidth - collectionView.contentInset.left, y: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}
