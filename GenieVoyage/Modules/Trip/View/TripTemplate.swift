//
//  TripTemplate.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 26.07.2025.
//

import Foundation

struct TripTemplate {
    let title: String
    let imageName: String

    static func sampleTemplates() -> [TripTemplate] {
        return [
            TripTemplate(title: "Romantic Getaway", imageName: "romance"),
            TripTemplate(title: "Family Trip", imageName: "family"),
            TripTemplate(title: "Solo Adventure", imageName: "solo"),
            TripTemplate(title: "Friends Weekend", imageName: "friends")
        ]
    }
}
