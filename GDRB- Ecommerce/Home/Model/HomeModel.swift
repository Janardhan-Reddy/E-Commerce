//
//  HomeModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//

import Foundation

struct HomeResponse: Codable {
    let success: Bool?
    let data: HomeData?
}

struct HomeData: Codable {
    let banners: [Banner]?
    let collections: [Collections]?
    let topoffers: [TopOffer]?
}

struct Banner: Codable {
    let id: Int?
    let image_path: String?
    let created_at: String?
    let updated_at: String?
}

struct Collections: Codable {
    let cat_id: Int?
    let name: String?
    let image_path: String?
    let created_at: String?
    let updated_at: String?
}

struct TopOffer: Codable {
    let offer_id: Int?
    let title: String?
    let image_path: String?
    let price: String?
    let status: Int?
    let created_at: String?
    let updated_at: String?
}

