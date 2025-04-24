//
//  MainTabBarController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 24.04.2025.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        let allTripsVC = AllTripsViewController()
        allTripsVC.tabBarItem = UITabBarItem(title: nil,
                                             image: UIImage(named: "calendar")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "home_selected")?.withRenderingMode(.alwaysOriginal)
        )
        allTripsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        allTripsVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let mapVC = MapLocationViewController()
        mapVC.tabBarItem = UITabBarItem(title: nil,
                                        image: UIImage(named: "map")?.withRenderingMode(.alwaysOriginal),
                                        selectedImage: UIImage(named: "home_selected")?.withRenderingMode(.alwaysOriginal))
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        mapVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil,
                                            image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(named: "home_selected")?.withRenderingMode(.alwaysOriginal))
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        profileVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        viewControllers = [
            UINavigationController(rootViewController: allTripsVC),
            UINavigationController(rootViewController: mapVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
}
