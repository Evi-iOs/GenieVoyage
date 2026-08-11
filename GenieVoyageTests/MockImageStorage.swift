//
//  File.swift
//  GenieVoyageTests
//
//  Created by Evgeniya  Iv on 11.08.2026.
//

import XCTest
@testable import GenieVoyage

final class MockImageStorage: ImageStorageProtocol {
    var coversDirectory: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("covers")
    }
    func saveCover(_ image: UIImage, tripID: UUID) throws -> URL {
        coversDirectory.appendingPathComponent("\(tripID).jpg")
    }
    func loadImage(from url: URL) -> UIImage? { nil }
    func deleteCover(at url: URL) { }
}
