//
//  MapViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 29.11.2024.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Map"
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        //Add textPin
        let annotation = MKPointAnnotation()
        annotation.title = "Location"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 55.7512, longitude: 37.6156)
        mapView.addAnnotation(annotation)
    }
}
