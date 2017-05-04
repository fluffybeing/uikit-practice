//
//  Message+CoreDataClass.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    
    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var friend: Friend?
    @NSManaged public var isSender: NSNumber?
}
