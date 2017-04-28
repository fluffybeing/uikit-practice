//
//  Cell.swift
//  RSSReader
//
//  Created by Rahul Ranjan on 4/29/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder not implemented!")
    }
    
    func setupViews() {}
    
}

class EntryCell: BaseCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let contentSnippetTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return view
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(contentSnippetTextView)
        addSubview(dividerView)
        
        addConstraintWithFormat(format: "H:|-8-[v0]-8-|", views: titleLabel)
        addConstraintWithFormat(format: "H:|-3-[v0]-3-|", views: contentSnippetTextView)
        addConstraintWithFormat(format: "H:|-8-[v0]", views: dividerView)
        
        addConstraintWithFormat(format: "V:|-8-[v0(20)]-8-[v1][v2(0.5)]|", views: titleLabel, contentSnippetTextView, dividerView)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        var newFrame = attr.frame
        self.frame = newFrame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let desiredHeight: CGFloat = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight + 20
        attr.frame = newFrame
        return attr
    }
    
}

class SearchHeader: BaseCell, UITextFieldDelegate {
    
    var searchFeedController: SearchFeedController?
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search For RSS Feeds"
        textField.font = UIFont.systemFont(ofSize: 14)
    
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
       
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    
    override func setupViews() {
        addSubview(searchTextField)
        addSubview(searchButton)
        addSubview(dividerView)
        
        
        addConstraintWithFormat(format: "H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
        addConstraintWithFormat(format: "H:|[v0]|", views: dividerView)
        
        addConstraintWithFormat(format: "V:|[v0]|", views: searchButton)
        addConstraintWithFormat(format: "V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
        
        
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
        searchTextField.delegate = self
        
    }
    
    func search(_ sender: UIButton) {
        searchFeedController?.performSearchForText(text: searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFeedController?.performSearchForText(text: searchTextField.text!)
        return true
    }
    
}


extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
