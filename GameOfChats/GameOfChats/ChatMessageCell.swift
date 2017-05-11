//
//  ChatMessageCell.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/9/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    var chatLogController: ChatLogController?
    var message: Message?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc private func handlePlay() {
        
        if let videoUrl = message?.videoUrl, let url = URL(string: videoUrl) {
            player = AVPlayer(url: url)
            
            // player layer
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            
            player?.play()
            playButton.isHidden = true
            activityIndicatorView.startAnimating()
        }
    }
    
    // it prepares the collectionview/tableView cell
    // to reuse, it provides the cleanup work
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
 
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.white
        textView.isEditable = false
        
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_:))))
        
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
    
    func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    func setupViews() {
        addSubview(bubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        
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
