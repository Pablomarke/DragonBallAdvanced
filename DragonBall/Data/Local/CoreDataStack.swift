//
//  CoreDataStack.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 17/10/23.
//

import Foundation
import CoreData

// MARK: - Core Data protocol
protocol HeroAndLocationConvertible {
    associatedtype Model
    func toModel() -> Model?
}

// MARK: - Core Data stack
class CoreDataStack: NSObject {
    static let shared: CoreDataStack = .init()
    private override init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DragonBall")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
// MARK: - Core Data Saving support
    func saveContext () {
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
}
