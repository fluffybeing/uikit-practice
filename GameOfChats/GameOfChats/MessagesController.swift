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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // give some delay
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value,
                with: { snapshot in
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        DispatchQueue.main.async {
                            self.navigationItem.title = userDict["name"] as? String
                        }
                    }
                }, withCancel: nil)
        }
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageTableViewController()
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
        present(loginController, animated: true, completion: nil)
    }

}

