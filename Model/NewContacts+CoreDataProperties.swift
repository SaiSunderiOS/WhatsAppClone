//
//  NewContacts+CoreDataProperties.swift
//  WhatsApp Clone
//
//  Created by karthikeya on 14/07/24.
//
//

import Foundation
import CoreData


extension NewContacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewContacts> {
        return NSFetchRequest<NewContacts>(entityName: "NewContacts")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var status: String?
    @NSManaged public var profileImg: Data?

}

extension NewContacts : Identifiable {

}
