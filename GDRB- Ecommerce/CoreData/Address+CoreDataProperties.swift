//
//  Address+CoreDataProperties.swift
//  
//
//  Created by Pravin Kumar on 17/07/25.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var pincode: Int64
    @NSManaged public var state: String?
    @NSManaged public var city: String?
    @NSManaged public var localAddress: String?
    @NSManaged public var flatNumber: String?
    @NSManaged public var landmark: String?

}
