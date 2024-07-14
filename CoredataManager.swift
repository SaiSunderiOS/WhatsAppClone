//
//  CoredataManager.swift
//  WhatsApp Clone
//
//  Created by karthikeya on 14/07/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveTextMessage(_ text: String) {
        let message = Messages(context: context)
        message.textMessage = text
        message.timestamp = Date()
        saveContext()
    }

    func saveImageMessage(_ imageData: Data) {
        let message = Messages(context: context)
        message.image = imageData
        message.timestamp = Date()
        saveContext()
    }
}
