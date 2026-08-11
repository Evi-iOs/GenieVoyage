//
//  RouteCardView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.07.2026.
//

import UIKit
import MapKit

final class RouteCardView: UIView {
    
    var onExpandTapped: (() -> Void)?
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.isUserInteractionEnabled = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        mv.isRotateEnabled = false
        mv.isPitchEnabled = false
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    private let emptyMapLabel: UILabel = {
        let l = UILabel()
        l.text = "No locations for this day"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = UIColor(hex: "94A3B8")
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()
    
    private var currentEvents: [EventModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.delegate = self
        
        backgroundColor = UIColor(hex: "F1F5F9")
        layer.cornerRadius = 16
        layer.borderWidth = 1; layer.borderColor = UIColor(hex: "E2E8F0").cgColor
        
        let mapIV = UIImageView(image: UIImage(systemName: "map",
                                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)))
        mapIV.tintColor = UIColor(hex: "0F172A")
        mapIV.setContentHuggingPriority(.required, for: .horizontal)
        
        let title = UILabel(); title.text = "Route Overview"
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        title.textColor = UIColor(hex: "0F172A")
        
        let leftStack = UIStackView(arrangedSubviews: [mapIV, title])
        leftStack.spacing = 6; leftStack.alignment = .center
        
        let expand = UILabel()
        expand.attributedText = NSAttributedString(string: "EXPAND MAP", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(hex: "64748B"), .kern: 1.0])
        expand.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTapped))
        expand.addGestureRecognizer(tap)
        
        let mapTap = UITapGestureRecognizer(target: self, action: #selector(expandTapped))
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(mapTap)
        
        let header = UIStackView(arrangedSubviews: [leftStack, expand])
        header.distribution = .equalSpacing; header.alignment = .center
        header.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        
        addSubview(header)
        addSubview(mapView)
        addSubview(emptyMapLabel)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            mapView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            emptyMapLabel.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            emptyMapLabel.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func expandTapped() {
        onExpandTapped?()
    }
    
    // MARK: - Configure
    
    func configure(with events: [EventModel]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let coordinates = events.compactMap { $0.coordinate }
        
        guard !coordinates.isEmpty else {
            mapView.isHidden = true
            emptyMapLabel.isHidden = false
            return
        }
        
        mapView.isHidden = false
        emptyMapLabel.isHidden = true
        
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
        
        fitMapToAnnotations()
    }
    
    private func fitMapToAnnotations() {
        guard !mapView.annotations.isEmpty else { return }
        
        if mapView.annotations.count == 1, let single = mapView.annotations.first {
            let region = MKCoordinateRegion(
                center: single.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: false)
        } else {
            mapView.showAnnotations(mapView.annotations, animated: false)
        }
    }
}

// MARK: - RoutePointAnnotation

final class RoutePointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let order: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String, order: Int) {
        self.coordinate = coordinate
        self.title = title
        self.order = order
    }
}

extension RouteCardView: MKMapViewDelegate {
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

final class RoutePointAnnotationView: MKAnnotationView {
    private let circleView = UIView()
    private let numberLabel = UILabel()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        centerOffset = CGPoint(x: 0, y: -12)
        
        circleView.frame = bounds
        circleView.backgroundColor = UIColor(hex: "0F172A")
        circleView.layer.cornerRadius = 12
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.white.cgColor
        addSubview(circleView)
        
        numberLabel.frame = bounds
        numberLabel.font = .systemFont(ofSize: 11, weight: .bold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(order: Int) {
        numberLabel.text = "\(order)"
    }
}
