//
//  ChatLogController.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/8/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message......"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // constrainsts
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Message
        let sendButton = UIButton(type: UIButtonType.system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleMessageSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        // Constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // TextField
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        Avoid fix width constraints
//        inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleMessageSend() {
        
        if let messageText = inputTextField.text {
            let ref = FIRDatabase.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            
            // Get the user id
            guard let toId = user?.id,
                let fromId = FIRAuth.auth()?.currentUser?.uid else {
                    return
            }
            
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values: [String: Any] = ["text": messageText, "toId": toId, "fromId": fromId, "timestamp": timeStamp]
            childRef.updateChildValues(values, withCompletionBlock: { (error, _) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                // crea te fanout
                let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
                let messageId = childRef.key
                userMessageRef.updateChildValues([messageId: 1])
                
                let recepientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId)
                recepientUserMessageRef.updateChildValues([messageId: 1])
            })
        }
    }
    
    
    // MARK: textField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleMessageSend()
        return true
    }
}
