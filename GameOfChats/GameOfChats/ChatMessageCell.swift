//
//  ChatMessageCell.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/9/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
 
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.white
        
        return textView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = ChatMessageCell.blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(bubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        // x, y, width, height
        messageTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //x, y, width, height
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}
