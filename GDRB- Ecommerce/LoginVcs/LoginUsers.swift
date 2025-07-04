//
//  LoginUsers.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 11/01/23.
//

import Foundation
import UIKit

//loginUsers in Database
class LoginUsers {
    var Username: String = ""
    var password: String = ""
    var id: Int = 0
    
    
    init(Username: String, password: String, id: Int) {
        self.Username = Username
        self.password = password
        self.id = id
    }
    
}

