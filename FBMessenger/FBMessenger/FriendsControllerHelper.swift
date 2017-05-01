//
//  FriendsControllerHelper.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import CoreData

//class Friend: NSObject {
//    
//    var name: String?
//    var profileImageName: String?
//}
//
//class Message: NSObject {
//    var text: String?
//    var date: NSDate?
//    
//    var friend: Friend?
//}

extension FriendsController {
    
    func setupData() {
        
        let charul = Friend()
        charul.name = "Charul"
        charul.profileImageName = "charul"
        
        let message = Message()
        message.friend = charul
        message.text = "Hello, my name is charul. Nice to meet you...."
        message.date = NSDate()
        
        let rahul = Friend()
        rahul.name = "Rahul"
        rahul.profileImageName = "rahul"
        
        let messageRahul = Message()
        messageRahul.friend = rahul
        messageRahul.text = "Hello, my name is Rahul. Nice to meet you...."
        messageRahul.date = NSDate()

        
        messages = [message, messageRahul]
    }
}
