//
//  StartPlanningViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 06.01.2025.
//

import UIKit
import MapKit
import CoreLocation

class StartPlanningViewController: UIViewController {

    var onSave: ((TripModel) -> Void)?
    var onClose: (() -> Void)?

    var existingTrip: TripModel?
    var template: TripTemplate?

    private var searchCompleter = MKLocalSearchCompleter()
    private var suggestions: [MKLocalSearchCompletion] = []

    private var rangeStartDate: Date?
    private var rangeEndDate: Date?
    private var calendarBaseDate: Date = Calendar.current.date(
        from: Calendar.current.dateComponents([.year, .month], from: Date())
    ) ?? Date()

    private var selectedCoordinate: CLLocationCoordinate2D?
    private var isSelectingSolo = true
    private let locationManager = CLLocationManager()

    private let tripListViewModel: TripListViewModel

    init(tripListViewModel: TripListViewModel) {
        self.tripListViewModel = tripListViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let navBar = UIView()
    private let closeButton = UIButton(type: .system)
    private let navTitleLabel = UILabel()
    private let saveNavButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let whereTitleLabel = UILabel()
    private let destinationTextField = UITextField()
    private let suggestionsTableView = UITableView()
    private let mapContainerView = UIView()
    private let mapSnapshotImageView = UIImageView()
    private let mapPlaceholderLabel = UILabel()

    private let datesTitleLabel = UILabel()
    private let calendarContainerView = UIView()
    private let monthLabel = UILabel()
    private let prevMonthButton = UIButton(type: .system)
    private let nextMonthButton = UIButton(type: .system)
    private let weekdayStackView = UIStackView()
    private let daysGridView = UIView()

    private let createButton = UIButton(type: .system)


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
          let tfFrameInView = destinationTextField.convert(destinationTextField.bounds, to: view)
        suggestionsTableView.frame = CGRect(
            x: tfFrameInView.minX,
            y: tfFrameInView.maxY + 4,
            width: tfFrameInView.width,
            height: 180
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        setupSearchCompleter()
        setupNavBar()
        setupScrollView()
        setupWhereSection()
        setupDatesSection()
        setupCreateButton()
        setupConstraints()

        if let trip = existingTrip {
            destinationTextField.text = trip.title
            rangeStartDate = trip.startDate
            rangeEndDate = trip.endDate
            calendarBaseDate = Calendar.current.date(
                from: Calendar.current.dateComponents([.year, .month], from: trip.startDate)
            ) ?? Date()
        } else {
            setupLocationManager()
        }
        if let tmpl = template {
            destinationTextField.text = tmpl.title
            suggestionsTableView.isHidden = true
            destinationTextField.isEnabled = false
        }

        renderCalendar()
    }

    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }

    private func setupNavBar() {
        navBar.backgroundColor = .white
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        closeButton.setTitle("✕", for: .normal)
        closeButton.tintColor = .black
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        navTitleLabel.text = existingTrip != nil ? "Edit Trip" : "New Trip"
        navTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navTitleLabel.textAlignment = .center
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        saveNavButton.setTitle("Save", for: .normal)
        saveNavButton.tintColor = UIColor.systemBlue
        saveNavButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        saveNavButton.translatesAutoresizingMaskIntoConstraints = false
        saveNavButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        navBar.addSubview(closeButton)
        navBar.addSubview(navTitleLabel)
        navBar.addSubview(saveNavButton)

        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.88, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(separator)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 52),

            closeButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 36),

            navTitleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),

            saveNavButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            saveNavButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20),

            separator.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupWhereSection() {
        whereTitleLabel.text = "Where to?"
        whereTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        whereTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(whereTitleLabel)

        destinationTextField.placeholder = "Destination name"
        destinationTextField.font = UIFont.systemFont(ofSize: 16)
        destinationTextField.backgroundColor = UIColor(white: 0.93, alpha: 1)
        destinationTextField.layer.cornerRadius = 12
        destinationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        destinationTextField.leftViewMode = .always
        destinationTextField.clearButtonMode = .whileEditing
        destinationTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addSubview(destinationTextField)

        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isHidden = true
        suggestionsTableView.layer.cornerRadius = 12
        suggestionsTableView.layer.shadowColor = UIColor.black.cgColor
        suggestionsTableView.layer.shadowOpacity = 0.12
        suggestionsTableView.layer.shadowRadius = 10
        suggestionsTableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        suggestionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(suggestionsTableView)

        mapContainerView.backgroundColor = UIColor(white: 0.93, alpha: 1)
        mapContainerView.layer.cornerRadius = 16
        mapContainerView.clipsToBounds = true
        mapContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapContainerView)

        mapSnapshotImageView.contentMode = .scaleAspectFill
        mapSnapshotImageView.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(mapSnapshotImageView)

        mapPlaceholderLabel.text = "Select a destination"
        mapPlaceholderLabel.font = UIFont.systemFont(ofSize: 14)
        mapPlaceholderLabel.textColor = .systemGray
        mapPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(mapPlaceholderLabel)

        NSLayoutConstraint.activate([
            mapSnapshotImageView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
            mapSnapshotImageView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
            mapSnapshotImageView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor),
            mapSnapshotImageView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor),

            mapPlaceholderLabel.centerXAnchor.constraint(equalTo: mapContainerView.centerXAnchor),
            mapPlaceholderLabel.centerYAnchor.constraint(equalTo: mapContainerView.centerYAnchor)
        ])
    }

    private func setupDatesSection() {
        datesTitleLabel.text = "Select Dates"
        datesTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        datesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datesTitleLabel)

        calendarContainerView.backgroundColor = .white
        calendarContainerView.layer.cornerRadius = 16
        calendarContainerView.layer.shadowColor = UIColor.black.cgColor
        calendarContainerView.layer.shadowOpacity = 0.05
        calendarContainerView.layer.shadowRadius = 8
        calendarContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        calendarContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calendarContainerView)

        prevMonthButton.setTitle("‹", for: .normal)
        prevMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        prevMonthButton.tintColor = .black
        prevMonthButton.translatesAutoresizingMaskIntoConstraints = false
        prevMonthButton.addTarget(self, action: #selector(prevMonthTapped), for: .touchUpInside)

        nextMonthButton.setTitle("›", for: .normal)
        nextMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        nextMonthButton.tintColor = .black
        nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        nextMonthButton.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)

        monthLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false

        calendarContainerView.addSubview(prevMonthButton)
        calendarContainerView.addSubview(monthLabel)
        calendarContainerView.addSubview(nextMonthButton)

        weekdayStackView.axis = .horizontal
        weekdayStackView.distribution = .fillEqually
        weekdayStackView.translatesAutoresizingMaskIntoConstraints = false
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        for day in days {
            let lbl = UILabel()
            lbl.text = day
            lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lbl.textColor = .systemGray
            lbl.textAlignment = .center
            weekdayStackView.addArrangedSubview(lbl)
        }
        calendarContainerView.addSubview(weekdayStackView)

        daysGridView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.addSubview(daysGridView)

        NSLayoutConstraint.activate([
            prevMonthButton.topAnchor.constraint(equalTo: calendarContainerView.topAnchor, constant: 16),
            prevMonthButton.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 16),
            prevMonthButton.widthAnchor.constraint(equalToConstant: 32),
            prevMonthButton.heightAnchor.constraint(equalToConstant: 32),

            monthLabel.centerYAnchor.constraint(equalTo: prevMonthButton.centerYAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: calendarContainerView.centerXAnchor),

            nextMonthButton.centerYAnchor.constraint(equalTo: prevMonthButton.centerYAnchor),
            nextMonthButton.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor, constant: -16),
            nextMonthButton.widthAnchor.constraint(equalToConstant: 32),
            nextMonthButton.heightAnchor.constraint(equalToConstant: 32),

            weekdayStackView.topAnchor.constraint(equalTo: prevMonthButton.bottomAnchor, constant: 12),
            weekdayStackView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 8),
            weekdayStackView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor, constant: -8),
            weekdayStackView.heightAnchor.constraint(equalToConstant: 24),

            daysGridView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor, constant: 8),
            daysGridView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 8),
            daysGridView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor, constant: -8),
            daysGridView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor, constant: -16)
        ])
    }

    private func setupCreateButton() {
        createButton.setTitle("Create Trip", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1)
        createButton.layer.cornerRadius = 14
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(createButton)
    }

    private func setupConstraints() {
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            whereTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            whereTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            destinationTextField.topAnchor.constraint(equalTo: whereTitleLabel.bottomAnchor, constant: 14),
            destinationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            destinationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            destinationTextField.heightAnchor.constraint(equalToConstant: 50),

            mapContainerView.topAnchor.constraint(equalTo: destinationTextField.bottomAnchor, constant: 12),
            mapContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapContainerView.heightAnchor.constraint(equalToConstant: 180),

            datesTitleLabel.topAnchor.constraint(equalTo: mapContainerView.bottomAnchor, constant: 28),
            datesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),

            calendarContainerView.topAnchor.constraint(equalTo: datesTitleLabel.bottomAnchor, constant: 14),
            calendarContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            calendarContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            daysGridView.heightAnchor.constraint(equalToConstant: 240),

            createButton.topAnchor.constraint(equalTo: calendarContainerView.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            createButton.heightAnchor.constraint(equalToConstant: 54),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func renderCalendar() {
        let cal = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: calendarBaseDate)

        daysGridView.subviews.forEach { $0.removeFromSuperview() }

        let components = cal.dateComponents([.year, .month], from: calendarBaseDate)
        guard let firstOfMonth = cal.date(from: components),
              let daysInMonth = cal.range(of: .day, in: .month, for: firstOfMonth)?.count else { return }

        let firstWeekday = (cal.component(.weekday, from: firstOfMonth) - 1 + 7) % 7
        let totalCells = firstWeekday + daysInMonth
        let rows = Int(ceil(Double(totalCells) / 7.0))

        let cellSize: CGFloat = (UIScreen.main.bounds.width - 40 - 16) / 7
        let rowHeight: CGFloat = 40

        for i in 0..<(rows * 7) {
            let dayIndex = i - firstWeekday
            guard dayIndex >= 0 && dayIndex < daysInMonth else { continue }

            let dayNumber = dayIndex + 1
            guard let date = cal.date(bySetting: .day, value: dayNumber, of: firstOfMonth) else { continue }

            let col = i % 7
            let row = i / 7
            let x = CGFloat(col) * cellSize
            let y = CGFloat(row) * rowHeight

            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: cellSize, height: rowHeight)
            btn.setTitle("\(dayNumber)", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.tag = dayNumber
            btn.addTarget(self, action: #selector(dayTapped(_:)), for: .touchUpInside)

            styleDayButton(btn, date: date)
            daysGridView.addSubview(btn)
        }

        let neededHeight = CGFloat(rows) * rowHeight
        for constraint in daysGridView.constraints where constraint.firstAttribute == .height {
            constraint.constant = neededHeight
        }
        if daysGridView.constraints.filter({ $0.firstAttribute == .height }).isEmpty {
            daysGridView.heightAnchor.constraint(equalToConstant: neededHeight).isActive = true
        }
    }

    private func styleDayButton(_ btn: UIButton, date: Date) {
        let cal = Calendar.current
        let isStart = rangeStartDate.map { cal.isDate(date, inSameDayAs: $0) } ?? false
        let isEnd = rangeEndDate.map { cal.isDate(date, inSameDayAs: $0) } ?? false
        let isInRange: Bool = {
            guard let s = rangeStartDate, let e = rangeEndDate else { return false }
            return date > s && date < e
        }()

        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 0

        if isStart || isEnd {
            btn.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 20
        } else if isInRange {
            btn.backgroundColor = UIColor(white: 0.88, alpha: 1)
        }
    }

    // MARK: - Map Snapshot

    private func updateMapSnapshot(for coordinate: CLLocationCoordinate2D) {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        options.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 180)
        options.mapType = .mutedStandard

        mapPlaceholderLabel.isHidden = true
        MKMapSnapshotter(options: options).start { [weak self] snapshot, _ in
            DispatchQueue.main.async {
                self?.mapSnapshotImageView.image = snapshot?.image
            }
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        onClose?()
        dismiss(animated: true)
    }

    @objc private func prevMonthTapped() {
        calendarBaseDate = Calendar.current.date(byAdding: .month, value: -1, to: calendarBaseDate) ?? calendarBaseDate
        renderCalendar()
    }

    @objc private func nextMonthTapped() {
        calendarBaseDate = Calendar.current.date(byAdding: .month, value: 1, to: calendarBaseDate) ?? calendarBaseDate
        renderCalendar()
    }

    @objc private func dayTapped(_ sender: UIButton) {
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month], from: calendarBaseDate)
        guard let firstOfMonth = cal.date(from: components),
              let tappedDate = cal.date(bySetting: .day, value: sender.tag, of: firstOfMonth) else { return }

        if rangeStartDate == nil || (rangeStartDate != nil && rangeEndDate != nil) {
            rangeStartDate = tappedDate
            rangeEndDate = nil
        } else if let start = rangeStartDate {
            if tappedDate < start {
                rangeStartDate = tappedDate
            } else {
                rangeEndDate = tappedDate
            }
        }
        renderCalendar()
    }

    @objc private func saveButtonTapped() {
        guard let title = destinationTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a destination")
            return
        }
        guard let startDate = rangeStartDate else {
            showAlert(message: "Please select a start date")
            return
        }

        let cal = Calendar.current
        let start = cal.startOfDay(for: startDate)
        let end = cal.startOfDay(for: rangeEndDate ?? startDate)

        let days: [TripDay] = remapTemplateDays(template?.days ?? [], to: start, calendar: cal)

        let updatedTrip: TripModel
        if var existing = existingTrip {
            existing.title = title
            existing.startDate = start
            existing.endDate = end
            updatedTrip = existing
        } else {
            updatedTrip = TripModel(
                id: UUID(),
                title: title,
                startDate: start,
                endDate: end,
                coverImage: nil,
                days: days
            )
        }

        Task { [weak self] in
            guard let self else { return }
            await self.tripListViewModel.addTrip(updatedTrip)
            self.onSave?(updatedTrip)
        }
        dismiss(animated: true)
    }
    
    private func remapTemplateDays(_ templateDays: [TripDay], to newStartDate: Date, calendar: Calendar) -> [TripDay] {
        templateDays.enumerated().map { index, templateDay in
            let newDayDate = calendar.date(byAdding: .day, value: index, to: newStartDate) ?? newStartDate
            
            let remappedEvents = templateDay.itineraryEvents.map { event -> EventModel in
                EventModel(
                    id: UUID(),
                    dateEvent: newDayDate,
                    category: event.category,
                    time: event.time,
                    startMinutes: event.startMinutes,
                    duration: event.duration,
                    locationName: event.locationName,
                    coordinate: event.coordinate,
                    notes: event.notes,
                    bookingLink: event.bookingLink,
                    pdfFileURL: nil
                )
            }
            
            return TripDay(date: newDayDate, itineraryEvents: remappedEvents)
        }
    }

    @objc private func textFieldDidChange() {
        guard let text = destinationTextField.text, !text.isEmpty else {
            suggestionsTableView.isHidden = true
            return
        }
        searchCompleter.queryFragment = text
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension StartPlanningViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
        suggestionsTableView.isHidden = suggestions.isEmpty
        suggestionsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StartPlanningViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let s = suggestions[indexPath.row]
        cell.textLabel?.text = [s.title, s.subtitle].filter { !$0.isEmpty }.joined(separator: ", ")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = suggestions[indexPath.row]
        destinationTextField.text = selected.title
        suggestionsTableView.isHidden = true
        destinationTextField.resignFirstResponder()

        let request = MKLocalSearch.Request(completion: selected)
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            DispatchQueue.main.async {
                self?.selectedCoordinate = coordinate
                self?.updateMapSnapshot(for: coordinate)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension StartPlanningViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate,
              selectedCoordinate == nil else { return }
        selectedCoordinate = coordinate
        updateMapSnapshot(for: coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
