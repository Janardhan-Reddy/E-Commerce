//
//  WishListResponse.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import Foundation

struct WishListResponse: Decodable {
    let message: String?
    let status: Bool?
    let itemCount: Int?
    let wishListItems: [WishlistItem]?

    enum CodingKeys: String, CodingKey {
        case message
        case status
        case itemCount = "item-count"
        case wishListItems = "wishlist-items"
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

