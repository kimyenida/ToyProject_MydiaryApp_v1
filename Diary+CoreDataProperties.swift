//
//  Diary+CoreDataProperties.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/16/23.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var email: String?
    @NSManaged public var date: String?

}

extension Diary : Identifiable {

}
