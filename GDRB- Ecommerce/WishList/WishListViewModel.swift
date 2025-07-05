//
//  WishListViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 05/07/25.
//

import Foundation
class WishListViewModel{
    
    let networkManager = NetworkManager.shared
    
    
    func loadWishlistData(completion: @escaping(WishListResponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/wishlist"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
               "Authorization": "Bearer \(accessToken)"
           ]
        
        networkManager.request(
            urlString: url,
            method: .GET,
            headers: headers,
            responseType: WishListResponse.self
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
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/wishlist/\(Id)"
        let accessToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers = [
               "Authorization": "Bearer \(accessToken)"
           ]
        let id = Int(Id)
        let parameters: [String: Any] = [
            "prd_id": id as Any
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



struct WishListResponse: Decodable {
    let message: String?
    let status: Bool?
    let itemCount: Int?
    let cartItems: [CartItem]?

    enum CodingKeys: String, CodingKey {
        case message
        case status
        case itemCount = "item-count"
        case cartItems = "wishlist-items"
    }
}

struct WishlistItem: Decodable {
    let id: Int?
    let userId: Int?
    let prdId: Int?
    let quantity: Int?
    let createdAt: String?
    let updatedAt: String?
    let product: WishlistProduct?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case prdId = "prd_id"
        case quantity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case product
    }
}

struct WishlistProduct: Decodable {
    let prdId: Int?
    let prdName: String?
    let firstImage: String?
    let otherImages: [String]?
    let prdPrice: String?
    let sellingPrice: String?
    let discount: String?

    enum CodingKeys: String, CodingKey {
        case prdId = "prd_id"
        case prdName = "prd_name"
        case firstImage = "first_image"
        case otherImages = "other_images"
        case prdPrice = "prd_price"
        case sellingPrice = "selling_price"
        case discount
    }
}
