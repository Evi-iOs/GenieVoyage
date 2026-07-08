//
//  FullScreenRouteMapViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.07.2026.
//

import UIKit
import MapKit

final class FullScreenRouteMapViewController: UIViewController {
    
    private let events: [EventModel]
    private let dayTitle: String
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .custom)
        let cfg = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        b.setImage(UIImage(systemName: "xmark", withConfiguration: cfg), for: .normal)
        b.tintColor = UIColor(hex: "0F172A")
        b.backgroundColor = .white
        b.layer.cornerRadius = 21
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.15
        b.layer.shadowOffset = CGSize(width: 0, height: 3)
        b.layer.shadowRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .bold)
        l.textColor = UIColor(hex: "0F172A")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    init(events: [EventModel], dayTitle: String) {
        self.events = events
        self.dayTitle = dayTitle
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        titleLabel.text = dayTitle
        
        view.addSubview(mapView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 12)
        ])
        
        renderRoute()
    }
    
    private func renderRoute() {
        let coordinates = events.compactMap { $0.coordinate }
        guard !coordinates.isEmpty else { return }
        
        let sortedEvents = events
            .filter { $0.coordinate != nil }
            .sorted { $0.startMinutes < $1.startMinutes }
        
        for (index, event) in sortedEvents.enumerated() {
            guard let coordinate = event.coordinate else { continue }
            let annotation = RoutePointAnnotation(
                coordinate: coordinate,
                title: event.locationName ?? "Stop \(index + 1)",
                order: index + 1
            )
            mapView.addAnnotation(annotation)
        }
        
        if sortedEvents.count > 1 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension FullScreenRouteMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let point = annotation as? RoutePointAnnotation else { return nil }
        let identifier = "RoutePoint"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? RoutePointAnnotationView
        ?? RoutePointAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.annotation = annotation
        view.configure(order: point.order)
        return view
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor(hex: "0F172A")
        renderer.lineWidth = 2
        renderer.lineDashPattern = [4, 4]
        return renderer
    }
}
