//
//  FriendsControllerHelper.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let charul = Friend.init(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
            charul.name = "Charul"
            charul.profileImageName = "charul"
            
            let message = Message.init(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
            message.friend = charul
            message.text = "Hello, my name is charul. Nice to meet you...."
            message.date = NSDate()
            
            let rahul = Friend.init(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
            rahul.name = "Rahul"
            rahul.profileImageName = "rahul"
            
            let messageRahul = Message.init(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
            messageRahul.friend = rahul
            messageRahul.text = "Hello, my name is Rahul. Nice to meet you...."
            messageRahul.date = NSDate()
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        loadData()
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest =  NSFetchRequest<Message>(entityName: "Message")
            do {
                messages = try context.fetch(fetchRequest)
            } catch let error {
                print(error.localizedDescription)
            }
            
            try! context.save()
        }

    }
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        // create the delete request for the specified entity
        let fetchDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let deleteMessageRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)
        
        let fetchFriendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        let deleteFriendRequest = NSBatchDeleteRequest(fetchRequest: fetchFriendRequest)

        
        if let context = delegate?.persistentContainer.viewContext {
            do {
                try context.execute(deleteMessageRequest)
                try context.execute(deleteFriendRequest)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
