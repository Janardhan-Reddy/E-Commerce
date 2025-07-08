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


struct AddedToCartResponse: Codable {
    let message: String?
    let status: Bool?
   // let cartDetails: CartDetails?

    enum CodingKeys: String, CodingKey {
        case message
        case status
       // case cartDetails = "cart-details"
    }
}

struct CartDetails: Codable {
    let userId: Int?
    let prdId: String?
    let quantity: String?
    let updatedAt: String?
    let createdAt: String?
    let cardId: Int?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case prdId = "prd_id"
        case quantity
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case cardId = "card_id"
    }
}

struct AddedToWishListResponse: Codable {
    let message: String?
    let status: Bool?
    let cartDetails: WishListDetails?

    enum CodingKeys: String, CodingKey {
        case message
        case status
        case cartDetails = "wishlist-details"
    }
}

struct WishListDetails: Codable {
    let userId: Int?
    let prdId: String?
    let quantity: String?
    let updatedAt: String?
    let createdAt: String?
    let cardId: Int?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case prdId = "prd_id"
        case quantity
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case cardId = "card_id"
    }
}
