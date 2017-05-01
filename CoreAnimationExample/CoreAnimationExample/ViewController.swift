//
//  ViewController.swift
//  CoreAnimationExample
//
//  Created by Rahul Ranjan on 5/1/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let zoomImageView = UIView()
    let startingFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Image interaction will not work unless
        // you make below property true
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.frame = startingFrame
        zoomImageView.backgroundColor = UIColor.red
        zoomImageView.contentMode = .scaleAspectFill
        zoomImageView.clipsToBounds = true
        
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(animate)))
        
        view.addSubview(zoomImageView)
    }
    
    
    func animate() {
        UIView.animate(withDuration: 0.75) {
            
            let height = (self.view.frame.width / self.startingFrame.width) * self.startingFrame.height
            
            let y = self.view.frame.height / 2 - height / 2
            
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

