//
//  ImageStorage.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 03.02.2026.
//

import Foundation
import UIKit

protocol ImageStorageProtocol {
    var coversDirectory: URL { get }
    func saveCover(_ image: UIImage, tripID: UUID) throws -> URL
    func deleteCover(at url: URL)
    func loadImage(from url: URL) -> UIImage?
}

final class ImageStorage: ImageStorageProtocol {
    
    private let fileManager = FileManager.default
    
    static let shared = ImageStorage()
    private init() {}
    
    var coversDirectory: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir = docs.appendingPathComponent("TripCovers", isDirectory: true)

        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(
                at: dir,
                withIntermediateDirectories: true
            )
        }
        return dir
    }

    func saveCover(_ image: UIImage, tripID: UUID) throws -> URL {
        let fileURL = coversDirectory
            .appendingPathComponent("\(tripID.uuidString).jpg")

        guard let data = image.jpegData(compressionQuality: 0.85) else {
            throw NSError(domain: "ImageEncoding", code: 0)
        }

        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }

    func deleteCover(at url: URL) {
        try? fileManager.removeItem(at: url)
    }
    
    func loadImage(from url: URL) -> UIImage? {
        let exist = FileManager.default.fileExists(atPath: url.path)
        return exist ? UIImage(contentsOfFile: url.path) : nil
    }
}
