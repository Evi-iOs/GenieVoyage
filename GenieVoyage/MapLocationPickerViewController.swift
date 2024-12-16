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
    private let confirmButton = UIButton(type: .system)
    private let locationManager = CLLocationManager()
    private var selectedCoordinate: CLLocationCoordinate2D?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupMap()
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
        // Request location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPressed(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    // MARK: - Actions
    @objc private func mapLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let touchPoint = gesture.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)

        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)

        // Save the coordinate
        selectedCoordinate = coordinate
        confirmButton.isEnabled = true
    }

    @objc private func confirmButtonTapped() {
        guard let coordinate = selectedCoordinate else {
            showAlert(message: "Please select a location.")
            return
        }

        // Pass the coordinate back and dismiss
        onLocationSelected?(coordinate)
        navigationController?.popViewController(animated: true)
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

        // Center map on user's location the first time
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation() // Stop further updates
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(message: "Failed to fetch location. Please try again.")
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

