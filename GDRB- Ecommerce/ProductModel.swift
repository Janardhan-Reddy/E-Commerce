//
//  ProductModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 04/07/25.
//

import Foundation

// Root Response
struct ProductsResponse: Codable {
    let message: String?
    let status: Bool?
    let count: Int?
    let navbarHeadings: [NavbarHeading]?
    let data: ProductsData?
    
    enum CodingKeys: String, CodingKey {
        case message, status, count, data
        case navbarHeadings = "navbar-headings"
    }
}

// Navbar Heading
struct NavbarHeading: Codable {
    let subName: String?

    enum CodingKeys: String, CodingKey {
        case subName = "sub_name"
    }
}

// Data Container
struct ProductsData: Codable {
    let pagination: Pagination?
    let products: [Product]?
}

// Pagination Info
struct Pagination: Codable {
    let currentPage: Int?
    let lastPage: Int?
    let perPage: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
    }
}

// Product Model
struct Product: Codable {
    let prdId: Int?
    let prdCatId: Int?
    let prdSubCatId: Int?
    let prdBrandId: Int?
    let prdName: String?
    let prdSize: String?
    let stockPrdQuantity: Int?
    let availablePrdQuantity: Int?
    let prdColor: String?
    let prdPrice: String?
    let discount: String?
    let sellingPrice: String?
    let prdDescription: String?
    let createdAt: String?
    let updatedAt: String?
    let images: [String]?
    let firstImage: String?

    enum CodingKeys: String, CodingKey {
        case prdId = "prd_id"
        case prdCatId = "prd_cat_id"
        case prdSubCatId = "prd_sub_cat_id"
        case prdBrandId = "prd_brand_id"
        case prdName = "prd_name"
        case prdSize = "prd_size"
        case stockPrdQuantity = "stock_prd_quantity"
        case availablePrdQuantity = "available_prd_quantity"
        case prdColor = "prd_color"
        case prdPrice = "prd_price"
        case discount
        case sellingPrice = "selling_price"
        case prdDescription = "prd_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case images
        case firstImage = "first_image"
    }
}
