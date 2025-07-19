//
//  EachItemViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 08/07/25.
//

import UIKit

class EachItemViewModel{
    let networkManager = NetworkManager.shared
    
    func addProductToCart(prd_id: String, quantity: String, completion: @escaping (AddedToCartResponse?, Error?) -> Void) {
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/cart"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "prd_id": prd_id,
            "quantity": quantity
        ]
        
        networkManager.request(
            urlString: url,
            method: .POST,
            headers: headers,
            parameters: parameters,
            responseType: AddedToCartResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    func addProductToWishList(prd_id: String, quantity: String, completion: @escaping (AddedToWishListResponse?, Error?) -> Void) {
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/wishlist"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "prd_id": prd_id,
            "quantity": quantity
        ]
        
        networkManager.request(
            urlString: url,
            method: .POST,
            headers: headers,
            parameters: parameters,
            responseType: AddedToWishListResponse.self
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

