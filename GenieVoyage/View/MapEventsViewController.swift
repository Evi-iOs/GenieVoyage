//
//  MapEventsViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.05.2025.
//

import UIKit
import MapKit

class MapEventsViewController: UIViewController {
    
    private let viewModel: TripViewModel
    private var selectedDayIndex = 0
    
    private var isRouteVisible = true
    
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
        map.layer.cornerRadius = 12
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(dayTabsCollectionView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.delegate = self
        
        view.addSubview(fabButton)
        
        setupLayout()
        dayTabsCollectionView.selectItem(at: IndexPath(item: selectedDayIndex, section: 0), animated: false, scrollPosition: [])
        updateMapForSelectedDay()
    }
    
    private let fabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "point.topleft.down.to.point.bottomright.curvepath"), for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.alpha = 0.7
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(toggleRouteVisibility), for: .touchUpInside)
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
            
            mapView.topAnchor.constraint(equalTo: dayTabsCollectionView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56),
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
        fabButton.backgroundColor = isRouteVisible ? .gray : .black
        updateMapForSelectedDay()
    }
}

  // MARK: - CollectionView Delegate & DataSource

  extension MapEventsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return viewModel.days.count
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayTabCell.identifier, for: indexPath) as! DayTabCell
          cell.configure(with: viewModel.days[indexPath.item].dateDay.formatted())
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
