//
//  ChatLogController.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "chatId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
//            messages = friend?.messages?.allObjects as? [Message]
//            messages?.sort() { $0.date?.compare($1.date! as Date) == ComparisonResult.orderedAscending }
        }
    }
    
//    var messages: [Message]?
    
    
    let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message....."
        
       return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    var bottomMessageContainerViewContraint: NSLayoutConstraint?
    
    func handleSend() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let message = FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
            
            do {
                try context.save()
                inputTextField.text = nil

//                messages?.append(message)
//                
//                // insert new message
//                let insertIndexPath = IndexPath(item: (messages?.count)! - 1, section: 0)
//                collectionView?.insertItems(at: [insertIndexPath])
//                collectionView?.scrollToItem(at: insertIndexPath, at: .bottom, animated: true)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func simulate() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let message = FriendsController.createMessageWithText(text: "A minute ago message for the simulation...", friend: friend!, minutesAgo: 1, context: context)
        
            do {
                try context.save()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    lazy var fetchResultController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext

        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
       
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            try fetchResultController.performFetch()
            print(123)
        } catch let error {
            print(error.localizedDescription)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        // add the view
        view.addSubview(messageContainerView)
        
        view.addContraintWithFormat(format: "H:|[v0]|", views: messageContainerView)
        view.addContraintWithFormat(format: "V:[v0(48)]", views: messageContainerView)
        
        bottomMessageContainerViewContraint = NSLayoutConstraint(item: messageContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomMessageContainerViewContraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        messageContainerView.addSubview(inputTextField)
        messageContainerView.addSubview(sendButton)
        messageContainerView.addSubview(topBorderView)
        
        messageContainerView.addContraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageContainerView.addContraintWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageContainerView.addContraintWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageContainerView.addContraintWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageContainerView.addContraintWithFormat(format: "V:|[v0(1)]", views: topBorderView)
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomMessageContainerViewContraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { complted in
                if isKeyboardShowing {
//                    let indexPath = IndexPath(item: (self.messages?.count)! - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchResultController.sections?[0].numberOfObjects {
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        // use fetch controller
        let message = fetchResultController.object(at: indexPath) as! Message
        
        cell.messageTextView.text = message.text
        
        if  let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            
            // Set the profile image
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            if !message.isSender!.boolValue {
                
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 4)
                
                cell.profileImageView.isHidden = false
//                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black

            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 8 - 10, y: 0 - 4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 4)
                
                cell.profileImageView.isHidden = true
                
//                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 134/255, blue: 249/255,alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 134/255, blue: 249/255,alpha: 1)
                cell.messageTextView.textColor = UIColor.white
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchResultController.object(at: indexPath) as! Message
        
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}


class ChatLogMessageCell: BaseCell {
    
    static let grayBubbleImage =  UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage =  UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    
    let textBubbleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        
        // Basically it changes the insets of the image
        // use the corner of the image
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
//        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
//        addContraintWithFormat(format: "H:|[v0]|", views: messageTextView)
//        addContraintWithFormat(format: "V:|[v0]|", views: messageTextView)
        
        addContraintWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addContraintWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        addContraintWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        addContraintWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}
