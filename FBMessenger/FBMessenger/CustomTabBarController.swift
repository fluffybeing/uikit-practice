//
//  CustomTabBarController.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendsVC = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationVC = UINavigationController(rootViewController: friendsVC)
        navigationVC.tabBarItem.title = "Recent"
        navigationVC.tabBarItem.image = UIImage(named: "recent")
        
        
        
        viewControllers = [navigationVC,
                           createDummyNavControllerWithTitle(title: "Calls", imageName: "calls"),
                           createDummyNavControllerWithTitle(title: "Groups", imageName: "groups"),
                           createDummyNavControllerWithTitle(title: "People", imageName: "people"),
                           createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")
        ]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
