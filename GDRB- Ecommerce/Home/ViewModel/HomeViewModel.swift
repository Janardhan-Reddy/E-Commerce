//
//  HomeViewModel.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//

import Foundation
class HomeViewModel{
    
    let networkManager = NetworkManager.shared
    
    
    func loadHomePageItems(completion: @escaping(HomeData?, Error?)-> Void? ){
        let url = "https://gdrbpractice.gdrbtechnologies.com/api/home-page-content"
        networkManager.request(
            urlString: url,
            method: .GET,
            responseType: HomeResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response.data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
}

