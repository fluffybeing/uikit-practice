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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Facebook Feed"

        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // When orientations changes draw the layout again
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
    

}


class FeedCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let attributedString = NSMutableAttributedString(string: "Mark Zuckerberg", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\nDecember 18  •  San Franscisco  • ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        // Add line spacing in attributed text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        // Attachement for the globe
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "earth")
        attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        attributedString.append(NSAttributedString(attachment: attachment))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.red
        
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the dark side"
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.purple
        // clip pixel which we don't want
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let likeCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes    10.7K Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton: UIButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle(title: "Comment", imageName: "like")
    let shareButton: UIButton = FeedCell.buttonForTitle(title: "Share", imageName: "like")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likeCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        addContraintWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|" , views: profileImageView, nameLabel)
        addContraintWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addContraintWithFormat(format: "H:|[v0]|", views: statusImageView)
        addContraintWithFormat(format: "H:|-12-[v0]|", views: likeCommentsLabel)
        addContraintWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        // Button equal spaced
        addContraintWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)

        addContraintWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addContraintWithFormat(format: "V:|-8-[v0(44)]-4-[v1(30)]", views: profileImageView, statusTextView)
        // the constraint can be separated.
        addContraintWithFormat(format: "V:[v0]-4-[v1]", views: statusTextView, statusImageView)
        addContraintWithFormat(format: "V:[v0]-8-[v1(24)]-8-[v2(0.5)][v3(44)]|", views: statusImageView, likeCommentsLabel, dividerLineView, likeButton)
        addContraintWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addContraintWithFormat(format: "V:[v0(44)]|", views: shareButton)

    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


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
