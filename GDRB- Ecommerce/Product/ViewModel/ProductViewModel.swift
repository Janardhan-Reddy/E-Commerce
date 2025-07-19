//
//  ProductViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 04/07/25.
//

import UIKit



class ProductViewModel{
    let networkManager = NetworkManager.shared

    func getProduct(productName: String, completion: @escaping(ProductsResponse?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/getproducts/\(productName)"
        
        
        networkManager.request(
            urlString: url,
            method: .GET,
            responseType: ProductsResponse.self
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
