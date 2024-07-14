//
//  Messages+CoreDataProperties.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 14/07/24.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Messages> {
        return NSFetchRequest<Messages>(entityName: "Messages")
    }

    @NSManaged public var textMessage: String?
    @NSManaged public var image: Data?
    @NSManaged public var isSender: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var contact: NewContacts?

}

extension Messages : Identifiable {

}
