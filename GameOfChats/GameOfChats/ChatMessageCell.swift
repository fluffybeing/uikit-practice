//
//  ChatMessageCell.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/9/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
 
    let messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
    
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(messageTextView)
        
        // x, y, width, height
        messageTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
