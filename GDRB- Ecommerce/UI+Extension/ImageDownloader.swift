//
//  ImageDownloader.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//

import Foundation
import UIKit


extension UIImage {
    static func fetchImage(
        from endpoint: String,
        baseURL: String = "https://gdrbpractice.gdrbtechnologies.com/",
        completion: @escaping (UIImage?) -> Void
    ) {
        // Create full URL string
        let fullURLString: String
        if endpoint.contains("gdrbpractice.gdrbtechnologies.com") {
            fullURLString = endpoint
        } else {
            fullURLString = baseURL + (endpoint.hasPrefix("/") ? String(endpoint.dropFirst()) : endpoint)
        }

      
        if let cachedImage = UIImageCacheManager.shared.get(forKey: fullURLString) {
            completion(cachedImage)
            return
        }

        // Encode and validate the URL
        guard let encodedURLString = fullURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Invalid image URL:", fullURLString)
            completion(nil)
            return
        }

        // Perform the request
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Image fetch error:", error)
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("No image data or failed to decode image.")
                completion(nil)
                return
            }

         
            UIImageCacheManager.shared.set(image, forKey: fullURLString)
            completion(image)
        }

        task.resume()
    }
}


class UIImageCacheManager {
    static let shared = UIImageCacheManager()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
