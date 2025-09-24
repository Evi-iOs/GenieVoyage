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
    private let storage: TripStorage
    
    private var mainCoordinator: MainCoordinator?

    init(window: UIWindow, storage: TripStorage) {
        self.window = window
        self.storage = storage
    }

    func start() {
        let mainCoordinator = MainCoordinator(window: window, storage: storage)
        self.mainCoordinator = mainCoordinator
        mainCoordinator.start()
    }
}
