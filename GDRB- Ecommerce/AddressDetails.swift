//
//  AddressDetails.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 15/07/23.
//
import Foundation
import UIKit
class AddressDetails  {
    var email: String = ""
    var address: String = ""
    var name: String = ""
    var phoneNumber: String = ""
    init(email: String, address: String, name: String, phoneNumber: String) {
        self.email = email
        self.address = address
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

