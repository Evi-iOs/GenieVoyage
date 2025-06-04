//
//  MapEventsViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.05.2025.
//

import UIKit
import MapKit

class MapEventsViewController: UIViewController {

    private let mapView = MKMapView()
    private var allEvents: [EventModel]
    private var filteredEvents: [EventModel] = []

    private let filterSegmented = UISegmentedControl(items: ["All"] + EventCategory.allCases.map { $0.displayName })

    init(events: [EventModel]) {
        self.allEvents = events.filter { $0.coordinate != nil }
        super.init(nibName: nil, bundle: nil)
        self.filteredEvents = allEvents
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupMapView()
        setupFilterControl()
        addAnnotations()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupFilterControl() {
        filterSegmented.selectedSegmentIndex = 0
        filterSegmented.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        filterSegmented.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(filterSegmented)
        NSLayoutConstraint.activate([
            filterSegmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterSegmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            filterSegmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    @objc private func filterChanged() {
        let index = filterSegmented.selectedSegmentIndex
        if index == 0 {
            filteredEvents = allEvents
        } else {
            let selectedCategory = EventCategory.allCases[index - 1]
            filteredEvents = allEvents.filter { $0.category == selectedCategory }
        }
        mapView.removeAnnotations(mapView.annotations)
        addAnnotations()
    }

    private func addAnnotations() {
        for event in filteredEvents {
            guard let coordinate = event.coordinate else { continue }

            let annotation = EventAnnotation(event: event)
            annotation.coordinate = coordinate
            annotation.title = event.locationName ?? event.category.displayName
            annotation.subtitle = "🕒 \(event.time) • \(event.duration) min"
            mapView.addAnnotation(annotation)
        }

        if let first = filteredEvents.first?.coordinate {
            let region = MKCoordinateRegion(center: first, latitudinalMeters: 1200, longitudinalMeters: 1200)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapEventsViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let eventAnnotation = annotation as? EventAnnotation else { return nil }

        let identifier = "eventAnnotation"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            let icon = UIImage(systemName: eventAnnotation.event.category.iconSystemName)
            let imageView = UIImageView(image: icon)
            imageView.tintColor = eventAnnotation.event.category.color
            view?.leftCalloutAccessoryView = imageView
        }

        view?.markerTintColor = eventAnnotation.event.category.color
        view?.glyphImage = UIImage(systemName: eventAnnotation.event.category.iconSystemName)
        view?.annotation = annotation
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let eventAnnotation = view.annotation as? EventAnnotation else { return }
        let editorVC = EventEditorViewController(viewModel: EventEditorFactory.editViewModel(for: eventAnnotation.event))
        editorVC.onSave = { [weak self] updatedEvent in
            self?.reload(updatedEvent)
        }
        navigationController?.pushViewController(editorVC, animated: true)
    }

    private func reload(_ updated: EventModel) {
        if let index = allEvents.firstIndex(where: { $0.id == updated.id }) {
            allEvents[index] = updated
        }
        filterChanged()
    }
}

// MARK: - EventAnnotation

class EventAnnotation: MKPointAnnotation {
    let event: EventModel

    init(event: EventModel) {
        self.event = event
        super.init()
    }
}

