//
//  Extensions.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/1/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

extension UIView {
    func addContraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
