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

class ViewController: UITableViewController {
    
    let databaseReference: FIRDatabaseReference = {
        return FIRDatabase.database().reference(fromURL: "https://game-of-chats-8f25d.firebaseio.com/")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
//        databaseReference.updateChildValues(["SomeValue": "123456"])
    }
    
    func handleLogout() {
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
    }

}

