//
//  ViewController.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/5/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessagesController: UITableViewController {
    
    let cellId = "messageCell"
    
    var messages = [Message]()
    var messageDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
//        observeMessages()
        
        // Cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func observerUserMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { snapshot in
            let messageId = snapshot.key
            
            // Now fetch the messages for the corresponding Id's
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { snapshot in
                
                if let messageDict = snapshot.value as? [String: Any] {
                    let message = Message()
                    message.setValuesForKeys(messageDict)
                    
                    // Keep only last messages for a user
                    if let toId = message.toId {
                        self.messageDictionary[toId] = message
                        
                        self.messages = Array(self.messageDictionary.values)
                        self.messages.sort(by: {
                            return ($0.0.timestamp?.intValue)! > ($0.1.timestamp?.intValue)!
                        })
                    }
                    
                    // Need to reload the tableView
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        })
    }
    
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { snapshot in
            
            if let messageDict = snapshot.value as? [String: Any] {
                let message = Message()
                message.setValuesForKeys(messageDict)
                
                // Keep only last messages for a user
                if let toId = message.toId {
                    self.messageDictionary[toId] = message
                 
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: {
                        return ($0.0.timestamp?.intValue)! > ($0.1.timestamp?.intValue)!
                    })
                }
                
                // Need to reload the tableView 
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }, withCancel: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // give some delay
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { snapshot in
                if let userDict = snapshot.value as? [String: AnyObject] {
                    
                    let user = User()
                    // This might crash if key doesn't matches
                    user.setValuesForKeys(userDict)
                    
                    DispatchQueue.main.async {
                        self.setupNavBarWithUser(user: user)
                    }
                }
        }, withCancel: nil)

    }
    
    func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        observerUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        if let profileImageURL  = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
        }
        containerView.addSubview(profileImageView)
        
        // x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        // Label
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        
        // constraints
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        // Call the new controller 
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerWithUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        chatLogController.user = user
        
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageTableViewController()
        
        // pass the message controller reference
        newMessageController.messagesController = self
        
        let navigationContoller = UINavigationController(rootViewController: newMessageController)
        
        present(navigationContoller, animated: true, completion: nil)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error.localizedDescription)
        }
        
        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }
    
    
    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dict)
            self.showChatControllerWithUser(user: user)
        })
    }
    
}

