//
//  TripViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.12.2024.
//

import UIKit
import Photos
import Combine

class TripViewController: UIViewController, UIImagePickerControllerDelegate, SegmentedControlDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var onSave: (() -> Void)?
    var onMapTapped: (() -> Void)?
    var onClose: (() -> Void)?
    
    weak var delegate: TripViewControllerDelegate?
    
    private let viewModel: TripViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let destinationLabel = UILabel()
    private let titleText = UITextView()
    private let stackView = UIStackView()
    
    private let datesLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let coverImageView = UIImageView()
    private let addCoverButton = UIButton(type: .system)
    private var selectedCoverImage: UIImage?
    
    private let saveButton = UIButton(type: .system)
    
    init(viewModel: TripViewModel) {
        self.viewModel = viewModel
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
        
        viewModel.$days
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.daysCollectionView.reloadData()
            }
            .store(in: &cancellables)
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
        
        navigationItem.title = "Trip to \(viewModel.trip.title)"
        
        destinationLabel.text = "DESTINATION"
        destinationLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        destinationLabel.textColor = .systemGray
        destinationLabel.letterSpacing(1.2)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.text = viewModel.trip.title
        titleText.font = UIFont.boldSystemFont(ofSize: 19)
        titleText.isScrollEnabled = false
        titleText.textColor = .black
        titleText.delegate = self
        titleText.textContainer.lineFragmentPadding = 0
        titleText.textContainerInset = .zero
        titleText.backgroundColor = .clear
        titleText.isEditable = true
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleText.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        datesLabel.text = "\(viewModel.trip.startDate.formattedDateWeekDay()) - \(viewModel.trip.endDate.formattedDateWeekDay())"
        datesLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        datesLabel.translatesAutoresizingMaskIntoConstraints = false
        datesLabel.textColor = .systemGray
        
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .automatic
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        coverImageView.layer.cornerRadius = 16
        coverImageView.layer.borderWidth = 1
        coverImageView.layer.borderColor = UIColor(hex: "#EDEDED").cgColor
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addCoverButton.addTarget(self, action: #selector(addCoverTapped), for: .touchUpInside)
        addCoverButton.translatesAutoresizingMaskIntoConstraints = false
        addCoverButton.tintColor = .white
        addCoverButton.isUserInteractionEnabled = true
        addCoverButton.isHidden = false
        addCoverButton.alpha = 1
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        saveButton.backgroundColor = .black
        saveButton.layer.cornerRadius = 8
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setContentHuggingPriority(.required, for: .horizontal)
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
        
        for (index, iconName) in icons.enumerated() {
            let button = createIconButton(iconName: iconName)
            button.tag = index
            button.isUserInteractionEnabled = true
            button.addInteraction(UIDragInteraction(delegate: self))
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
    }
    
    private func configureUI() {
        titleText.text = viewModel.trip.title
        startDatePicker.date = viewModel.trip.startDate
        endDatePicker.date = viewModel.trip.endDate
        
        if let image = viewModel.loadCoverImage() {
            coverImageView.image = image
        } else {
            addCoverButton.setImage(UIImage(named: "addPhoto"), for: .normal)
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
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            coverImageView.widthAnchor.constraint(equalToConstant: 85),
            coverImageView.heightAnchor.constraint(equalToConstant: 85),
            
            addCoverButton.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            addCoverButton.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            addCoverButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            addCoverButton.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            
            saveButton.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 36),
            
            destinationLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            destinationLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            destinationLabel.trailingAnchor.constraint(lessThanOrEqualTo: saveButton.leadingAnchor, constant: -12),
            
            titleText.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 2),
            titleText.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            titleText.trailingAnchor.constraint(lessThanOrEqualTo: saveButton.leadingAnchor, constant: -12),

            datesLabel.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 4),
            datesLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            datesLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -12),
            
            stackView.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 18),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: coverImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            daysCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            daysCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            // MapButton
            floatingMapButton.widthAnchor.constraint(equalToConstant: 60),
            floatingMapButton.heightAnchor.constraint(equalToConstant: 60),
            floatingMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            floatingMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - SegmentControl
    private lazy var segmentedControl = SegmentedControlView(items: [])
    
    // MARK: - Collection View
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private func configureCollectionView() {
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        daysCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")
    }
    
    func reloadItinerary() {
        daysCollectionView.reloadData()
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 20
    }
    
    // MARK: - Actions
    @objc private func saveButtonTapped() {
        guard let title = titleText.text, !title.isEmpty else {
            showAlert(message: "Enter title Trip")
            return
        }
        guard let selectedCoverImage = self.selectedCoverImage else { return }
        
        Task { [weak self] in
            guard let self = self else { return }
            await self.viewModel.saveTrip(coverImage: selectedCoverImage)
            self.onSave?()
        }
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
        onClose?()
    }
    
    @objc private func mapButtonTapped() {
        onMapTapped?()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let titles = self.viewModel.days.map { $0.dateDay.formattedDateWeekDay() }
                self.segmentedControl.updateItems(titles, selectedIndex: self.viewModel.selectedDayIndex)
                
                self.daysCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - MapButton
    
    private let floatingMapButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .light)
        let icon = UIImage(named: "map")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        return button
    }()
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            coverImageView.image = selectedImage
            addCoverButton.imageView?.isHidden = true
            selectedCoverImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index = daysCollectionView.currentPageIndex() {
            segmentedControl.selectSegment(at: index)
        }
    }
    
    func scrollViewDidEndScrollingAnimation (_ scrollView: UIScrollView) {
        if let index = daysCollectionView.currentPageIndex() {
            segmentedControl.selectSegment(at: index)
        }
    }
    
    func didSelectSegment(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        guard indexPath.item < daysCollectionView.numberOfItems(inSection: 0) else {
            print("⚠️ Attempted to scroll to \(indexPath.item), but only \(daysCollectionView.numberOfItems(inSection: 0)) items exist.")
            return
        }
        daysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension TripViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.days[indexPath.item]
        cell.dayCellDelegate = self
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
        let cellWidthIncludingSpacing = daysCollectionView.frame.width * 0.9 + layout.minimumLineSpacing
        
        var index = round((targetContentOffset.pointee.x + scrollView.contentInset.left) / cellWidthIncludingSpacing)
        
        if velocity.x > 0 {
            index = floor((scrollView.contentOffset.x + scrollView.bounds.width / 2) / cellWidthIncludingSpacing) + 1
        } else if velocity.x < 0 {
            index = ceil((scrollView.contentOffset.x + scrollView.bounds.width / 2) / cellWidthIncludingSpacing) - 1
        }
        
        index = max(0, min(index, CGFloat(viewModel.days.count - 1)))
        
        let newOffset = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
        targetContentOffset.pointee = newOffset
    }
}

//MARK: Drag icons
extension TripViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let button = interaction.view as? UIButton else { return [] }
        
        let icon = button.image(for: .normal) ?? UIImage()
        let category = button.itineraryCategory
        
        let event = EventModel(
            id: UUID(),
            dateEvent: Date(),
            category: category,
            time: "",
            startMinutes: 0,
            duration: 60,
            locationName: nil,
            coordinate: nil
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

extension TripViewController: DayCellDelegate {
    func dayCell(didDropEventWith category: EventCategory, dateEvent: Date, at time: String) {
        let date = Date()
        delegate?.didDropCreateEvent(event: nil, category: category, dateEvent: dateEvent, startMinutes: date.getStartMinutes(time: time) ?? 0)
    }
    
    func dayCell(didMove event: EventModel, byMinutes delta: Int) {
        Task {
            await viewModel.moveEvent(event, byMinutes: delta)
        }
    }

    func dayCell(didResize event: EventModel, toMinutes duration: Int) {
        Task {
            await viewModel.resizeEvent(event, toMinutes: duration)
        }
    }

    func dayCell(didDuplicate event: EventModel) {
        Task {
            await viewModel.duplicateEvent(event, to: event.dateEvent)
        }
    }
    
    func dayCell(didDelete event: EventModel) {
        Task {
            await viewModel.deleteEvent(event)
        }
    }

    func dayCell(_ cell: DayCollectionViewCell, didRequestAddEventAt minutes: Int) {
        delegate?.didDropCreateEvent(event: nil, category: .point, dateEvent: cell.viewModel?.dateDay ?? Date(), startMinutes: minutes)
    }

    func dayCell(didRequestOpenEvent event: EventModel) {
        delegate?.didRequestOpenEvent(event: event)
    }

    func dayCellDidScroll(upward: Bool) {
        
    }
}
