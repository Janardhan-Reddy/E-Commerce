//
//  CartViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 05/07/25.
//


import Foundation
class CartViewModel{
    
    let networkManager = NetworkManager.shared
    
    
    func loadCartData(completion: @escaping(CartResponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/cart"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
               "Authorization": "Bearer \(accessToken)"
           ]
        
        networkManager.request(
            urlString: url,
            method: .GET,
            headers: headers,
            responseType: CartResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func deleteRecord(Id:String,completion: @escaping(DeleteReponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/cart/\(Id)"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
               "Authorization": "Bearer \(accessToken)"
           ]
        let id = Int(Id)
        let parameters: [String: Any] = [
            "cartlist_id": id as Any
            ]
        
        networkManager.request(
            urlString: url,
            method: .DELETE,
            headers: headers,
            parameters: parameters,
            responseType: DeleteReponse.self
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

