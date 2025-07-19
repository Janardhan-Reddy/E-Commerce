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
    

    
    
    
}



