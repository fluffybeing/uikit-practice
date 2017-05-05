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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    
    func handleLogout() {
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
    }

}

