//
//  RegisterResponseModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import UIKit

struct RegistrationDetails{
    let name : String?
    let email: String?
    let password: String?
    let confirmPassword: String?
    let phoneNumber : String?
}

struct LoginDetails{
    let email: String?
    let password: String?
}

// MARK: API
struct RegisterationResponse: Codable {
    let message: String?
    let status: Bool?
    let errors: ErrorDetails?
}

struct ErrorDetails: Codable {
    let email: [String]?
}

struct LoginResponse: Codable {
    let message: String?
    let status: Bool?
    let token: String?
    let data: ResponseData?
}

struct ResponseData: Codable {
    let user: User?
}

struct User: Codable {
    let userID: Int?
    let name: String?
    let email: String?
    let userRole: Int?
    
    private enum CodingKeys: String, CodingKey {
        case userID   = "user_id"
        case name
        case email
        case userRole = "user_role"
    }
}

