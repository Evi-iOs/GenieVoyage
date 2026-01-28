//
//  EventEditorViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//


import UIKit
import MapKit
import QuickLook

final class EventEditorViewController: UIViewController, UITextViewDelegate {

    var preselectedStartMinutes: Int?
    var selectedLocationName: String?
    var selectedCoordinate: CLLocationCoordinate2D?
    var selectedPDFURL: URL?

    private var viewModel: EventEditorConfigurable

    private let headerView = UIView()
    private let saveButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let deleteEventButton = UIButton(type: .system)
    
    private let notesTextView = UITextView()
    private let bookingLinkField = UITextField()
    private let uploadPDFButton = UIButton(type: .custom)
    private let pdfThumbnailView = UIImageView()
    
    private let placeholderText = "Enter notes..."
    
    private let detailsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Details"
        label.textColor = .black
        return label
    }()
    
    private let beginPicker = UIDatePicker()
    private let endPicker = UIDatePicker()

    private let locationTextField = UITextField()
    private let tableView = UITableView()
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()

    var onSave: ((EventModel) -> Void)?
    var onClose: (() -> Void)?
    var onEventDeleted: ((EventModel?) -> Void)?
    
    init(viewModel: EventEditorConfigurable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.locationName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupButtons()
        setupTimePickersPDFButton()
        setupSearchField()
        setupSearch()
        completeIfEditing()
        setupExtraFields()
    }

    // MARK: - Setup UI

    private func setupButtons() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(saveButton)
        headerView.addSubview(closeButton)
        headerView.addSubview(detailsTitleLabel)
        view.addSubview(deleteEventButton)

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.titleLabel?.tintColor = .red

        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.titleLabel?.tintColor = .red
        
        deleteEventButton.setTitle("Delete Event", for: .normal)
        deleteEventButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        deleteEventButton.titleLabel?.tintColor = .red

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        deleteEventButton.translatesAutoresizingMaskIntoConstraints = false
        detailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            saveButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            detailsTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            detailsTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            deleteEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupExtraFields() {
        notesTextView.delegate = self
        notesTextView.font = UIFont.systemFont(ofSize: 17)
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 8
        
        if let text = viewModel.existingEvent?.notes, !text.isEmpty {
            notesTextView.text = text
            notesTextView.textColor = .label
        } else {
            notesTextView.text = placeholderText
            notesTextView.textColor = .lightGray
        }

        bookingLinkField.placeholder = "Booking link (optional)"
        bookingLinkField.borderStyle = .roundedRect
        bookingLinkField.keyboardType = .URL
        bookingLinkField.autocapitalizationType = .none

        let stack = UIStackView(arrangedSubviews: [notesTextView, bookingLinkField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesTextView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == .lightGray {
            notesTextView.text = ""
            notesTextView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notesTextView.text = placeholderText
            notesTextView.textColor = .lightGray
        }
    }

    private func setupTimePickersPDFButton() {
        
        uploadPDFButton.fileButton(systemName: "paperclip")
        uploadPDFButton.addTarget(self, action: #selector(uploadPDFTapped), for: .touchUpInside)
        
        pdfThumbnailView.contentMode = .scaleAspectFit
        pdfThumbnailView.clipsToBounds = true
        pdfThumbnailView.layer.cornerRadius = 8
        pdfThumbnailView.layer.borderColor = UIColor.black.cgColor
        pdfThumbnailView.layer.borderWidth = 0.5
        pdfThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        pdfThumbnailView.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPDFTapped))
        pdfThumbnailView.isUserInteractionEnabled = true
        pdfThumbnailView.addGestureRecognizer(tap)

        let stack = UIStackView(arrangedSubviews: [uploadPDFButton, pdfThumbnailView, beginPicker, endPicker])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        beginPicker.datePickerMode = .time
        beginPicker.preferredDatePickerStyle = .compact

        endPicker.datePickerMode = .time
        endPicker.preferredDatePickerStyle = .compact

        var calendar = Calendar.current
        calendar.timeZone = .current

        if let minutes = preselectedStartMinutes {
            let hour = minutes / 60
            let minute = minutes % 60
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = hour
            components.minute = minute

            if let startDate = calendar.date(from: components),
               let endDate = calendar.date(byAdding: .minute, value: 60, to: startDate) {
                beginPicker.date = startDate
                endPicker.date = endDate
            }
            
        } else {
            let now = Date()
            beginPicker.date = now
            endPicker.date = Calendar.current.date(byAdding: .minute, value: 60, to: now) ?? now.addingTimeInterval(60 * 60)
        }

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupSearchField() {
        locationTextField.placeholder = self.selectedLocationName ?? "Enter location"
        locationTextField.borderStyle = .roundedRect
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.addTarget(self, action: #selector(clearLocationField), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        locationTextField.rightView = clearButton
        locationTextField.rightViewMode = .whileEditing

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

        let stack = UIStackView(arrangedSubviews: [locationTextField, tableView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 100),
            stack.topAnchor.constraint(equalTo: endPicker.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func generatePDFThumbnail(from url: URL, size: CGSize) -> UIImage? {
        guard let pdfDocument = PDFDocument(url: url), let page = pdfDocument.page(at: 0) else { return nil }
        
        let pageRect = page.bounds(for: .mediaBox)
        let scale = min(size.width / pageRect.width, size.height / pageRect.height)
        let thumbnailSize = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        return page.thumbnail(of: thumbnailSize, for: .mediaBox)
    }
    
    @objc private func showPDFTapped() {
        guard selectedPDFURL != nil else { return }
        showPDFPreview()
    }
    
    @objc private func uploadPDFTapped() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    @objc private func clearLocationField() {
        locationTextField.text = ""
        searchResults.removeAll()
        tableView.reloadData()
        tableView.isHidden = true
    }

    private func completeIfEditing() {
        guard let event = viewModel.existingEvent else { return }

        let calendar = Calendar.current
        let now = Date()
        if let start = calendar.date(bySettingHour: event.startMinutes / 60, minute: event.startMinutes % 60, second: 0, of: now) {
            beginPicker.date = start
            endPicker.date = start.addingTimeInterval(TimeInterval(event.duration * 60))
        }

        locationTextField.text = event.locationName
        selectedCoordinate = event.coordinate
        selectedLocationName = event.locationName
        
        notesTextView.text = event.notes ?? ""
        bookingLinkField.text = event.bookingLink?.absoluteString ?? ""

        if let url = event.pdfFileURL {
            selectedPDFURL = url
            if let thumbnail = generatePDFThumbnail(from: url, size: CGSize(width: 50, height: 50)) {
                pdfThumbnailView.image = thumbnail
                pdfThumbnailView.isHidden = false
            }
        }
    }

    // MARK: - Actions

    @objc private func saveTapped() {
        guard validateTimes() else { return }
        if var model = viewModel.buildEvent() {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: beginPicker.date)
            let rawMinutes = Int(beginPicker.date.timeIntervalSince(startOfDay) / 60)
            
            model.dateEvent = startOfDay
            model.startMinutes = rawMinutes
            model.time = String(rawMinutes/60)
            model.duration = Int(endPicker.date.timeIntervalSince(beginPicker.date) / 60)
            model.locationName = locationTextField.text ?? selectedLocationName
            model.coordinate = selectedCoordinate
            
            model.notes = checkNotesTextView()
            model.bookingLink = bookingLinkField.validURL
            model.pdfFileURL = selectedPDFURL ?? viewModel.existingEvent?.pdfFileURL

            onSave?(model)
        }
        dismiss(animated: true)
    }
    
    private func checkNotesTextView() -> String? {
        let textToSave: String?
        
        if notesTextView.textColor == .lightGray {
            textToSave = nil
        } else {
            textToSave = notesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return textToSave
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func deleteTapped() {
        presentDeletionConfirmation { [weak self] in
            self?.onEventDeleted?(self?.viewModel.existingEvent)
        }
    }

    private func validateTimes() -> Bool {
        if beginPicker.date >= endPicker.date {
            let alert = UIAlertController(
                title: "Invalid Time",
                message: "Start time must be earlier than end time.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return false
        }
        return true
    }

    // MARK: - Search

    private func setupSearch() {
        searchCompleter.delegate = self
    }

    @objc private func textFieldDidChange() {
        searchCompleter.queryFragment = locationTextField.text ?? ""
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDelegate & DataSource

extension EventEditorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title + ", " + result.subtitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let request = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, _ in
            guard let self = self, let item = response?.mapItems.first else { return }
            self.selectedCoordinate = item.placemark.coordinate
            self.selectedLocationName = result.title
            self.locationTextField.text = result.subtitle
            self.tableView.isHidden = true
            self.locationTextField.resignFirstResponder()
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension EventEditorViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed: \(error)")
    }
}

// MARK: - UIDocumentPickerDelegate
extension EventEditorViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = documents.appendingPathComponent(url.lastPathComponent)
        
        try? fileManager.removeItem(at: destURL)
        do {
            try fileManager.copyItem(at: url, to: destURL)
            selectedPDFURL = destURL
        } catch {
            print("Error copying file: \(error)")
            selectedPDFURL = url
        }
        
        if let thumbnail = generatePDFThumbnail(from: selectedPDFURL!, size: CGSize(width: 50, height: 50)) {
            pdfThumbnailView.image = thumbnail
            pdfThumbnailView.isHidden = false
        }
    }
}

extension EventEditorViewController: QLPreviewControllerDataSource {
    func showPDFPreview() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true)
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return selectedPDFURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let pdfURL = selectedPDFURL else {
            fatalError("Expected non-nil selectedPDFURL")
        }
        return pdfURL as NSURL
    }
}
