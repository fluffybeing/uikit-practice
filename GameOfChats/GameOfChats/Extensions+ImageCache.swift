//
//  Extensions+ImageCache.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/6/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        // Image is set to nil because we are using same cell and it
        // shows flashing images while scrolling and so we need to clear the
        // old image it is holding reference to.
        self.image = nil
        
        // check cache image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "Image Download Error")
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        }
        task.resume()
    }
}
