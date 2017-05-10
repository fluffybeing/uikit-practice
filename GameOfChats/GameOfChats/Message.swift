//
//  Message.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/9/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var timestamp: NSNumber?
    var text: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    
    init(dictionary: [String: Any]) {
         super.init()
        
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.text = dictionary["text"] as? String
        
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageHeight =  dictionary["imageHeight"] as? NSNumber
        self.imageWidth =  dictionary["imageWidth"] as? NSNumber

    }
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
