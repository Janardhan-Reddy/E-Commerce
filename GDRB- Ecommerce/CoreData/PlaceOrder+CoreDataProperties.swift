//
//  PlaceOrder+CoreDataProperties.swift
//  
//
//  Created by Pravin Kumar on 18/07/25.
//
//

import Foundation
import CoreData


extension PlaceOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceOrder> {
        return NSFetchRequest<PlaceOrder>(entityName: "PlaceOrder")
    }

    @NSManaged public var productImage: String?
    @NSManaged public var productName: String?
    @NSManaged public var productPrice: Int64
    @NSManaged public var productQuantity: Int64
    @NSManaged public var orderId: Int64

}
