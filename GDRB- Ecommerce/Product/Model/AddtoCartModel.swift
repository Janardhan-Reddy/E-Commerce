//
//  CartModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//
import UIKit

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
