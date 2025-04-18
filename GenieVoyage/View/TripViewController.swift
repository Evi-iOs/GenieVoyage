//
//  TripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos

class TripViewController: UIViewController, UIImagePickerControllerDelegate, SegmentedControlDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var trip: TripModel
    var onSave: ((TripModel) -> Void)?
    
    private lazy var viewModel = TripViewModel(trip: trip)
    
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
    
    init(trip: TripModel, onSave: ((TripModel) -> Void)? = nil) {
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
        
        viewModel.onUpdate = { [weak self] in
            self?.daysCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        showFloatingMapButton()
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
        
        navigationItem.title = "Trip to \(trip.title)"
        
        destinationLabel.text = "Destination"
        destinationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        destinationLabel.textColor = UIColor.gray
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.text = trip.title
        titleText.font = UIFont.boldSystemFont(ofSize: 18)
        titleText.isScrollEnabled = true
        titleText.textContainer.lineBreakMode = .byWordWrapping
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.delegate = self
        titleText.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        datesLabel.text = "\(trip.startDate.formattedDateWeekDay()) - \(trip.endDate.formattedDateWeekDay())"
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
        view.addSubview(daysCollectionView)
        view.addSubview(saveButton)
        view.addSubview(floatingMapButton)
        
        floatingMapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setupIconButtons() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let icons = ["plane", "treinIcon", "hotel", "point", "eating"]
        
        for i in icons {
            let button = createIconButton(iconName: i)
            button.isUserInteractionEnabled = true
            button.addInteraction(UIDragInteraction(delegate: self))
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
    }
    
    private func configureUI() {
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
    
    private func createIconButton(iconName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(hex: "#DADADA").cgColor
        button.layer.borderWidth = 1
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        guard let image = UIImage(named: iconName), let resized = image.resizedImage(named: iconName, size: CGSize(width: 30, height: 30))
        else { return button }
        button.setImage(resized, for: .normal)
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
            daysCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            daysCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            //MapButton
            floatingMapButton.widthAnchor.constraint(equalToConstant: 64),
            floatingMapButton.heightAnchor.constraint(equalToConstant: 64),
            floatingMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            floatingMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - SegmentControl
    private lazy var segmentedControl = SegmentedControlView(items: viewModel.days.map({ dayViewModel in
        dayViewModel.dateDay.formattedDateWeekDay()
    }))
    
    // MARK: - Collection View
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private func configureCollectionView() {
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        daysCollectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
    }
    
    private let daysCollectionView: UICollectionView = {
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
            id: UUID(), title: title, description: description, startDate: startDate, endDate: endDate, destinations: trip.destinations ?? [])
        
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
    
    @objc private func mapButtonTapped() {
        //TODO: Открывать должна VM
        let vc = MapLocationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addEvent(to dayIndex: Int, event: ItineraryEventModel) {
        viewModel.days[dayIndex].addEvent(event)
        
        let indexPath = IndexPath(item: dayIndex, section: 0)
        daysCollectionView.reloadItems(at: [indexPath])
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onDayChanged = { [weak self] in
            self?.daysCollectionView.reloadData()
        }
    }
    
    //MARK: - MapButton

    private let floatingMapButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .light)
        let icon = UIImage(named: "map")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 32
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    }()

    private func showFloatingMapButton() {
        guard floatingMapButton.alpha != 1 else { return }
        
        floatingMapButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        floatingMapButton.layer.shadowColor = UIColor.gray.cgColor
        floatingMapButton.layer.shadowOpacity = 0.5
        floatingMapButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingMapButton.layer.shadowRadius = 6
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut) {
            self.floatingMapButton.alpha = 1
            self.floatingMapButton.transform = .identity
        }
    }

    private func hideFloatingMapButton() {
        guard floatingMapButton.alpha != 0 else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.floatingMapButton.alpha = 0
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
        daysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        cell.viewModel = viewModel.days[indexPath.item]
        cell.scrollDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = collectionView.frame.width * 0.9
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = daysCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = daysCollectionView.frame.width * 0.9 + layout.minimumLineSpacing
        
        let estimatedIndex = round((targetContentOffset.pointee.x + daysCollectionView.contentInset.left) / cellWidth)
        targetContentOffset.pointee = CGPoint(x: estimatedIndex * cellWidth - daysCollectionView.contentInset.left, y: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}

//MARK: Drag icons
extension TripViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let button = interaction.view as? UIButton else { return [] }
        
        let icon = button.image(for: .normal) ?? UIImage()
        
        let event = ItineraryEventModel(
            id: UUID(),
            category: .transport,
            icon: icon,
            time: "", 
            duration: 60,
            location: nil
        )
        
        let itemProvider = NSItemProvider(object: icon)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = event
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let view = interaction.view else { return nil }
        return UITargetedDragPreview(view: view)
    }
}

extension TripViewController: DayCellScrollDelegate {
    func dayCellDidScroll(upward: Bool) {
        if upward {
            showFloatingMapButton()
        } else {
            hideFloatingMapButton()
        }
    }
}
