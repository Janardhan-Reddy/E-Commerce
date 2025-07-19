//
//  DataBasehandler.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 17/07/25.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {

    // MARK: - Singleton
    static let shared = DatabaseHandler()
    
    private init() {}

    // MARK: - Core Data Stack
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print(" Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Core Data: Changes saved successfully.")
            } catch {
                let nserror = error as NSError
                print(" Failed to save Core Data context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Saving Support
    func createEntity<T: NSManagedObject>(ofType type: T.Type) -> T? {
          let context = DatabaseHandler.context
          let entityName = String(describing: type)
          guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
              return nil
          }
          return entity
      }
    
    
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type) -> [T] {
          let context = DatabaseHandler.context
          let request = NSFetchRequest<T>(entityName: String(describing: type))
          do {
              let objects = try context.fetch(request)
              print(" Fetched \(objects.count) \(type) entities.")
              return objects
          } catch {
              print(" Failed to fetch: \(error)")
              return []
          }
      }
    
    func deleteEntity<T: NSManagedObject>(_ object: T) {
           let context = DatabaseHandler.context
           context.delete(object)
        DatabaseHandler.saveContext()
           print("🗑️ \(String(describing: T.self)) deleted.")
       }
    
    
    
    


}


struct AddressUpdateModel {
    var fullName: String?
    var phoneNumber: Int16
    var pincode: Int16
    var state: String?
    var city: String?
    var localAddress: String?
    var flatNumber: String?
    var landmark: String?
}

