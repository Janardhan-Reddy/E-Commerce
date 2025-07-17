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
        let container = NSPersistentContainer(name: "AddressDataModel")
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

    // MARK: - Core Data Saving Support
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
    
    
    func fetchAddresses() -> [Address] {
        let context = DatabaseHandler.context
        let fetchRequest: NSFetchRequest<Address> = Address.fetchRequest()
        
        do {
            let addresses = try context.fetch(fetchRequest)
            print(" Successfully fetched \(addresses.count) addresses.")
            return addresses
        } catch {
            print(" Failed to fetch addresses: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteAddress(_ address: Address) {
        let context = DatabaseHandler.context
        context.delete(address)
        DatabaseHandler.saveContext()
        print("🗑️ Address deleted.")
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

