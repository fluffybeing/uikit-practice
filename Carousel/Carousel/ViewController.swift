//
//  ViewController.swift
//  Carousel
//
//  Created by Rahul Ranjan on 4/28/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


class ProjectPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        dataSource = self
        
        let frameViewController = FrameViewController()
        frameViewController.imageName = imagesNames.first
        
        let viewControllers = [frameViewController]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    
    let imagesNames = ["corgi1", "corgi2", "corgi3"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imagesNames.index(of: currentImageName!)
        
        if currentIndex! < imagesNames.count - 1 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imagesNames[currentIndex! + 1]
            
            return frameViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imagesNames.index(of: currentImageName!)
        
        if currentIndex! > 0 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imagesNames[currentIndex! - 1]
            
            return frameViewController
        }

        
        return nil
    }
    
}


class FrameViewController: UIViewController {
    
    var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName!)
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(imageView)
        
        // Constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: NSLayoutFormatOptions(),metrics: nil, views: ["v0": imageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|",
                                                           options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
    }


}

