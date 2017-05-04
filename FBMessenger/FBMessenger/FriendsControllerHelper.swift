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
        
        // clear data first
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let charul = createFriendWithTextAndImage(name: "Charul", profileImageName: "charul", context: context)
            let rahul = createFriendWithTextAndImage(name: "Rahul", profileImageName: "rahul", context: context)
            let gandhi = createFriendWithTextAndImage(name: "Mahatama Gandhi", profileImageName: "gandhi", context: context)
            let hillary = createFriendWithTextAndImage(name: "Hillary Clinton", profileImageName: "hillary_profile", context: context)
            
            createMessageWithText(text: "This is Charul Message.", friend: charul, minutesAgo: 0, context: context)
            createMessageWithText(text: "Second Message. Wow this is actually working", friend: charul, minutesAgo: 0, context: context)
            
            // Experimenting with this sections for message view
            createMessageWithText(text: "Good Morning", friend: rahul, minutesAgo: 10, context: context)
            createMessageWithText(text: "Seems like it is great day to meet on the hill side!", friend: rahul, minutesAgo: 9, context: context)
            createMessageWithText(text: "What are you doing? The world seems so gloomy but your presence will make the world around me very happy place. I think you just need to cover over and then we will leave for somw outing and will visit the hill to see the sunset.", friend: rahul, minutesAgo: 8, context: context)
            createMessageWithText(text: "Wait for the winter, because summer is very hot on the hill!", friend: rahul, minutesAgo: 7, context: context, isSender: true)
            createMessageWithText(text: "WHat are you saying?", friend: rahul, minutesAgo: 6, context: context)
            createMessageWithText(text: "I don't mean to hurt your feeling, the idea is to visit the place when the weather is good unless going there does't make sense to me.", friend: rahul, minutesAgo: 5, context: context, isSender: true)
            
            createMessageWithText(text: "Go your point but still we can look into other places nearby. yeah there is a waterfall around 10KM from there. We can go there if yor ready.", friend: rahul, minutesAgo: 4, context: context)

            createMessageWithText(text: "Love, Peace and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            
            createMessageWithText(text: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 60 * 24 * 60 * 7, context: context)
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        loadData()
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        
        let message = Message.init(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo * 60) as NSDate
        message.isSender = NSNumber(value: isSender)
    }
    
    private func createFriendWithTextAndImage(name: String, profileImageName: String, context: NSManagedObjectContext) -> Friend {
        let friend = Friend.init(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
        friend.name = name
        friend.profileImageName = profileImageName
        
        return friend
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                // Loop over each friend and take the last message
                // only
                for friend in friends {
                    let fetchRequest =  NSFetchRequest<Message>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetchedMessages =  try context.fetch(fetchRequest)
                        messages?.append(contentsOf: fetchedMessages)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                messages?.sort() { $0.date?.compare($1.date! as Date) == ComparisonResult.orderedDescending }
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<Friend>(entityName: "Friend")
            
            do {
                return try context.fetch(request)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        return nil
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
