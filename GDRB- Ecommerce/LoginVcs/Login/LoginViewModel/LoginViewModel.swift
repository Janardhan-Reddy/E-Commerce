//
//  LoginViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import UIKit
class LoginViewModel{
    let networkManager = NetworkManager.shared
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
