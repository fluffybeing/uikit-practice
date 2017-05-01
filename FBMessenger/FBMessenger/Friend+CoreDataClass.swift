//
//  Friend+CoreDataClass.swift
//  FBMessenger
//
//  Created by Rahul Ranjan on 5/2/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject {
    
    @NSManaged public var name: String?
    @NSManaged public var profileImageName: String?
    @NSManaged public var messages: NSSet?

}
