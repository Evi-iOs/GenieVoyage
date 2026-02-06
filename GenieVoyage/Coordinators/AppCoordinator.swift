//
//  AppCoordinator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 22.08.2025.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow

    private var mainCoordinator: MainCoordinator?
    private let imageStorage: ImageStorageProtocol
    private let storage: CoreDataTripStorage

    init(window: UIWindow) {
        self.window = window
        self.imageStorage = ImageStorage.shared
        self.storage = CoreDataTripStorage(imageStorage: imageStorage)
    }

    func start() {
        let mainCoordinator = MainCoordinator(window: window, storage: storage, imageStorage: imageStorage)
        self.mainCoordinator = mainCoordinator
        mainCoordinator.start()
    }
}
