//
//  CalculateDistance.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.12.2024.
//

import Foundation
import CoreLocation

class CalculateDistance {
    
    func calculateDistance(from: DestinationModel, to: DestinationModel) -> CLLocationDistance? {
    guard let loc1 = from.location, let loc2 = to.location else { return nil }
    let coord1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude)
    let coord2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude)
    return coord1.distance(from: coord2)
}

}
