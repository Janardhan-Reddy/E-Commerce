//
//  RegistrationUsers.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 11/01/23.
//

import Foundation
//RegistrationUsers in Database
class RegistrationUsers {
    var Firstname:String = ""
    var Lastname:String = ""
    var Mobilenumber:String = ""
    var Email:String = ""
    var Password:String = ""
  
    
    
    init(Firstname: String, Lastname: String, Mobilenumber: String, Email: String, Password: String) {
        self.Firstname = Firstname
        self.Lastname = Lastname
        self.Mobilenumber = Mobilenumber
        self.Email = Email
        self.Password = Password
        
    }
}
