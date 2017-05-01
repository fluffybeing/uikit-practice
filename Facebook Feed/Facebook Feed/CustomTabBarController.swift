//
//  CustomTabBarController.swift
//  Facebook Feed
//
//  Created by Rahul Ranjan on 5/1/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "earth")
        
        let friendsRequestsController = UIViewController()
        let secondNavigationController = UINavigationController(rootViewController: friendsRequestsController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "like")
        
        viewControllers = [navigationController, secondNavigationController]
        
        // Tabbar appearance
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 234).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
}
