//
//  FeedCell.swift
//  Facebook Feed
//
//  Created by Rahul Ranjan on 5/1/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


//var imageCache = NSCache<NSString, UIImage>()

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            statusImageView.image = nil
            
            if let statusImageURL = post?.statusImageURL {
                
//                if let image = imageCache.object(forKey: statusImageURL as NSString) {
//                    statusImageView.image = image
//                } else {
                
                    let task = URLSession.shared.dataTask(with: URL(string: statusImageURL)!) { (data, response, error) in
                        
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                            return
                        }
                        
                        let image = UIImage(data: data!)
//                        imageCache.setObject(image!, forKey: statusImageURL as NSString)
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        }
                    }
                    task.resume()
//                }
            }
            
            setupNameLocationStatusAndProfileImage()
        }
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
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
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        
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
    
    let loader: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return activity
    }()
    
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
        
        // Activity View
        self.loader.center = self.statusImageView.center
        self.contentView.addSubview(loader)
        self.loader.startAnimating()
        
        addContraintWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|" , views: profileImageView, nameLabel)
        addContraintWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addContraintWithFormat(format: "H:|[v0]|", views: statusImageView)
        addContraintWithFormat(format: "H:|-12-[v0]|", views: likeCommentsLabel)
        addContraintWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        // Button equal spaced
        addContraintWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addContraintWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addContraintWithFormat(format: "V:|-8-[v0(44)]-4-[v1]", views: profileImageView, statusTextView)
        // the constraint can be separated.
        addContraintWithFormat(format: "V:[v0]-4-[v1(200)]", views: statusTextView, statusImageView)
        addContraintWithFormat(format: "V:[v0]-8-[v1(24)]-8-[v2(0.5)][v3(44)]|", views: statusImageView, likeCommentsLabel, dividerLineView, likeButton)
        addContraintWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addContraintWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
    }
    
    private func setupNameLocationStatusAndProfileImage() {
        if let name = post?.name {
            let attributedString = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
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
            
            nameLabel.attributedText = attributedString
        }
        
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImage = post?.profileImageName {
            profileImageView.image = UIImage(named: profileImage)
        }

    }
    
}
