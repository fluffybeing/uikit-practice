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
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
