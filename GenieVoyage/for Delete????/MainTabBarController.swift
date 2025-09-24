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
        
        let storage = CoreDataTripStorage()
        let tripListViewModel = TripListViewModel(storage: storage)
        let allTripsVC = TripListViewController(viewModel: tripListViewModel)
        allTripsVC.tabBarItem = createTabBarItem(image: "homeSmall", selectedImage: "homeSmall", tag: 0)
        allTripsVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let mapVC = MapLocationViewController()
        mapVC.tabBarItem = createTabBarItem(image: "mapSmall", selectedImage: "mapSmall", tag: 1)
        mapVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let checkListVC = CheckListViewController()
        checkListVC.tabBarItem = createTabBarItem(image: "checkListSmall", selectedImage: "checkListSmall", tag: 2)
        checkListVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = createTabBarItem(image: "profileSmall", selectedImage: "profileSmall", tag: 3)
        profileVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        viewControllers = [
            UINavigationController(rootViewController: allTripsVC),
            UINavigationController(rootViewController: mapVC),
            UINavigationController(rootViewController: checkListVC),
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
