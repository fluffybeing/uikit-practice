//
//  Extensions+ImageCache.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/6/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString: String) {
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
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
