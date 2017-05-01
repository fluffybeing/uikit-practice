//
//  MessageCell.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


class MessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "charul")
        
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Charul"
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message just arrived, just check it out."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 PM"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "charul")
        
        return imageView
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        self.addContraintWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        self.addContraintWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        // Center the Image
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.addContraintWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        self.addContraintWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        
        addSubview(containerView)
        
        addContraintWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addContraintWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        addContraintWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        addContraintWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        addContraintWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        addContraintWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        addContraintWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}


class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}

