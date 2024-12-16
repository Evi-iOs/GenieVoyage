//
//  MapLocationPickerViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 10.12.2024.
//

import UIKit
import MapKit
import CoreLocation

class MapLocationPickerViewController: UIViewController {
    // MARK: - Properties
    var onLocationSelected: ((CLLocationCoordinate2D) -> Void)?
    private let mapView = MKMapView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let confirmButton = UIButton(type: .system)
    private let locationManager = CLLocationManager()
    private var selectedCoordinate: CLLocationCoordinate2D?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupMap()
        setupSearch()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Pick a Location"

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        confirmButton.setTitle("Confirm Location", for: .normal)
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPressed(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    private func setupSearch() {
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a place or address"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - Actions
    @objc private func mapLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let touchPoint = gesture.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        addAnnotation(at: coordinate)
    }

    @objc private func confirmButtonTapped() {
        guard let coordinate = selectedCoordinate else {
            showAlert(message: "Please select a location.")
            return
        }

        onLocationSelected?(coordinate)
        navigationController?.popViewController(animated: true)
    }

    private func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)

        selectedCoordinate = coordinate
        confirmButton.isEnabled = true
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapLocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert(message: "Location access is required to pick a location.")
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(message: "Failed to fetch location. Please try again.")
    }
}

// MARK: - UISearchBarDelegate
extension MapLocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchForLocation(named: query)
        searchController.dismiss(animated: true)
    }

    private func searchForLocation(named name: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let response = response else {
                self?.showAlert(message: "Location not found. Please try again.")
                return
            }

            let coordinate = response.mapItems.first?.placemark.coordinate
            if let coordinate = coordinate {
                self.mapView.setRegion(
                    MKCoordinateRegion(
                        center: coordinate,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    ),
                    animated: true
                )
                self.addAnnotation(at: coordinate)
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapLocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "SelectedLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}

