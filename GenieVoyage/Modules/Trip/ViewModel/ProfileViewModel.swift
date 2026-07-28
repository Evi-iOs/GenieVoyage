//
//  ProfileViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 14.07.2026.
//

import Foundation
import UIKit

final class ProfileViewModel {
    
    private let tripStorage: TripStorage
    private let ticketFileStorage: TicketFileStorage
    
    private(set) var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "profile.userName") }
    }
    
    private(set) var avatarImage: UIImage? {
        didSet { saveAvatar() }
    }
    
    private(set) var tripsCount: Int = 0
    private(set) var daysTraveled: Int = 0
    private(set) var ticketsCount: Int = 0
    
    var onStatsUpdated: (() -> Void)?
    
    init(tripStorage: TripStorage, ticketFileStorage: TicketFileStorage) {
        self.tripStorage = tripStorage
        self.ticketFileStorage = ticketFileStorage
        self.userName = UserDefaults.standard.string(forKey: "profile.userName") ?? "Traveler"
        self.avatarImage = Self.loadAvatarFromDisk()
    }
    
    @MainActor
    func loadStats() async {
        let trips = await tripStorage.loadTrips()
        let files = await ticketFileStorage.loadAllFiles()
        
        tripsCount = trips.count
        daysTraveled = trips.reduce(0) { $0 + Calendar.current.dateComponents([.day], from: $1.startDate, to: $1.endDate).day! + 1 }
        ticketsCount = files.count
        
        onStatsUpdated?()
    }
    
    func updateName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        userName = trimmed
    }
    
    func updateAvatar(_ image: UIImage) {
        avatarImage = image
    }
    
    // MARK: - Avatar persistence
    
    private func saveAvatar() {
        guard let image = avatarImage, let data = image.jpegData(compressionQuality: 0.85) else { return }
        let url = Self.avatarURL()
        try? data.write(to: url)
    }
    
    private static func avatarURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("profile_avatar.jpg")
    }
    
    private static func loadAvatarFromDisk() -> UIImage? {
        UIImage(contentsOfFile: avatarURL().path)
    }
    
    // MARK: - Data management
    
    @MainActor
    func deleteAllData() async {
        let trips = await tripStorage.loadTrips()
        for trip in trips {
            await tripStorage.deleteTrip(trip)
        }
        let files = await ticketFileStorage.loadAllFiles()
        for file in files {
            await ticketFileStorage.deleteFile(file)
        }
        await loadStats()
    }
}
