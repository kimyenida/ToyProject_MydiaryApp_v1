//
//  User+CoreDataProperties.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/16/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?

}

extension User : Identifiable {

}
