//
//  RegisterViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 03/07/25.
//

import Foundation
import UIKit

class RegisterViewModel{
    let networkManager = NetworkManager.shared
    
    
    func registerUser(registeration: RegistrationDetails?,completion: @escaping(RegisterationResponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/register"
        guard let name = registeration?.name, let email = registeration?.email, let password = registeration?.password, let confirmPassword = registeration?.confirmPassword, let phoneNumber = registeration?.phoneNumber else {
            return
        }
        
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "phone_number": phoneNumber,
            "user_role": 2
            ]
        
        networkManager.request(
            urlString: url,
            method: .POST,
            parameters: parameters,
            responseType: RegisterationResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    func loginUser(login: LoginDetails?,completion: @escaping(LoginResponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/login"
        guard let email = login?.email, let password = login?.password else {
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            ]
        
        networkManager.request(
            urlString: url,
            method: .POST,
            parameters: parameters,
            responseType: LoginResponse.self
        ) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    
}





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

