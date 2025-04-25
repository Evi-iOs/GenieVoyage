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
        
        setValue(CustomTabBar(), forKey: "tabBar")
        setupTabs()
    }
    
    private func setupTabs() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = createTabBarItem(image: "hausSmall", selectedImage: "hausSmall", tag: 0)
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let allTripsVC = AllTripsViewController()
        allTripsVC.tabBarItem = createTabBarItem(image: "calendarSmall", selectedImage: "calendarSmall", tag: 1)
        allTripsVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let mapVC = MapLocationViewController()
        mapVC.tabBarItem = createTabBarItem(image: "mapSmall", selectedImage: "mapSmall", tag: 2)
        mapVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = createTabBarItem(image: "profileSmall", selectedImage: "profileSmall", tag: 3)
        profileVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: allTripsVC),
            UINavigationController(rootViewController: mapVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
    private func createTabBarItem(image: String, selectedImage: String, tag: Int) -> UITabBarItem {
//            let item = UITabBarItem(title: nil,
//                                    image: UIImage(named: image)?.withRenderingMode(.alwaysOriginal),
//                                    selectedImage: UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal))
        let item = UITabBarItem(title: nil,
                                image: UIImage(named: image), tag: tag)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
            return item
        }
}
