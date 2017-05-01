 //
//  ViewController.swift
//  Facebook Feed
//
//  Created by Rahul Ranjan on 4/30/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

 
class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = Posts()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
               
        navigationItem.title = "Facebook Feed"

        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
        feedCell.feedController = self
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText {
            let rect = NSString(string: statusText).boundingRect(
                with: CGSize(width: view.frame.width, height: 1000),
                options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44 + 1
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 16)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    // Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // When orientations changes draw the layout again
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    var statusImageView: UIImageView?
    let navBarCover = UIView()
    
    func animateWithImageView(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        // This will give absoulte coordinate
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            // hide original image
            statusImageView.alpha = 0
            
            // order matters
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            self.view.addSubview(blackBackgroundView)
            
            
            // navbar
            navBarCover.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCover.backgroundColor = UIColor.black
            navBarCover.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCover)
            }
           
            zoomImageView.backgroundColor = UIColor.green
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            self.view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75) {
                let height = (self.view.frame.width/startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                
                self.navBarCover.alpha = 1
                
            }
        }
        
        
        // Now status image view is relative to controller view
        // which causes it to displace
//        let view = UIView()
//        view.backgroundColor = UIColor.green
//        view.frame = statusImageView.frame
//        self.view.addSubview(view)
    }
    
    func zoomOut() {
        
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            // We want to remove the extra views when we want to
            // restore to original view
            UIView.animate(withDuration: 0.75, animations: {
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCover.alpha = 0
            }, completion: { didCompleted in
                
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCover.removeFromSuperview()
                
                self.statusImageView?.alpha = 1
            })

        }
    }
}

