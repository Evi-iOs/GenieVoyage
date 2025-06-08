//
//  MapEventsViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.05.2025.
//

import UIKit
import MapKit
import CoreLocation

class MapEventsViewController: UIViewController {
    
    private let viewModel: TripViewModel
    private var selectedDayIndex = 0
    
    private var isRouteVisible = true
    private let locationManager = CLLocationManager()
    
    init(viewModel: TripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dayTabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(DayTabCell.self, forCellWithReuseIdentifier: DayTabCell.identifier)
        return cv
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.showsUserLocation = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.delegate = self
        view.addSubview(mapView)
        view.addSubview(dayTabsCollectionView)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        view.addSubview(roadButton)
        view.addSubview(locationButton)
        
        mapView.showsUserLocation = true
        
        setupLayout()
        dayTabsCollectionView.selectItem(at: IndexPath(item: selectedDayIndex, section: 0), animated: false, scrollPosition: [])
        updateMapForSelectedDay()
    }
    
    private let roadButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(nil, action: #selector(toggleRouteVisibility), for: .touchUpInside)
        button.mapsButton(image: "point.topleft.down.to.point.bottomright.curvepath")
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.mapsButton(image: "location.fill")
        button.addTarget(self, action: #selector(centerToUserLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.mapsButton(image: "plus")
        button.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        return button
    }()

    private lazy var zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.mapsButton(image: "minus")
        button.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        return button
    }()

    private func setupLayout() {
        dayTabsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayTabsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            dayTabsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dayTabsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dayTabsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -20),
            zoomInButton.widthAnchor.constraint(equalToConstant: 50),
            zoomInButton.heightAnchor.constraint(equalToConstant: 50),

            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomOutButton.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -20),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 50),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.bottomAnchor.constraint(equalTo: roadButton.topAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            
            roadButton.widthAnchor.constraint(equalToConstant: 50),
            roadButton.heightAnchor.constraint(equalToConstant: 50),
            roadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateMapForSelectedDay() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let day = viewModel.days[selectedDayIndex]
        let annotations = day.events.map { event -> MKPointAnnotation in
            let annotation = EventAnnotation(event: event)
            guard let eventCoordinate = event.coordinate else { return annotation }
            annotation.coordinate = eventCoordinate
            annotation.title = event.locationName ?? event.category.displayName
            annotation.subtitle = "🕒 \(event.startTimeEvent) • \(event.duration) min"
            return annotation
        }
        
        if let first = annotations.first {
            let region = MKCoordinateRegion(center: first.coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200)
            mapView.setRegion(region, animated: true)
        }
        
        mapView.addAnnotations(annotations)
        
        if isRouteVisible {
            drawRoutesBetweenEvents(for: day.events)
        }
    }
    
    private func drawRoutesBetweenEvents(for events: [EventModel]) {
        mapView.removeOverlays(mapView.overlays)
        
        let coordinates = events.compactMap { $0.coordinate }
        guard coordinates.count >= 2 else { return }
        
        for i in 0..<coordinates.count - 1 {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i]))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i + 1]))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak self] response, error in
                guard let route = response?.routes.first else { return }
                self?.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    @objc private func toggleRouteVisibility() {
        isRouteVisible.toggle()
        roadButton.backgroundColor = isRouteVisible ? .gray : .black
        updateMapForSelectedDay()
    }
    
    @objc private func centerToUserLocation() {
        guard let coordinate = mapView.userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func zoomIn() {
        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: true)
    }

    @objc private func zoomOut() {
        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapView.setRegion(region, animated: true)
    }
}

  // MARK: - CollectionView Delegate & DataSource

  extension MapEventsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return viewModel.days.count
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayTabCell.identifier, for: indexPath) as! DayTabCell
          cell.configure(with: viewModel.days[indexPath.item].dateDay.formattedDay())
          return cell
      }

      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          selectedDayIndex = indexPath.item
          collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
          updateMapForSelectedDay()
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 80, height: 32)
      }
  }

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
            // self?.reload(updatedEvent)
        }
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
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

extension MapEventsViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationAccessAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    private func showLocationAccessAlert() {
        let alert = UIAlertController(
            title: "Geolocation is disabled",
            message: "To display your location, please allow access in settings.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        })

        present(alert, animated: true)
    }
}

