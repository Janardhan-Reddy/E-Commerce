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
            baseURL: String? = nil,
            completion: @escaping (UIImage?) -> Void
        ) {
            // Determine the full URL string
            let fullURLString: String
            if endpoint.hasPrefix("http") {
                fullURLString = endpoint
            } else if let baseURL = baseURL {
                fullURLString = baseURL + (endpoint.hasPrefix("/") ? String(endpoint.dropFirst()) : endpoint)
            } else {
                print("Relative endpoint provided but no baseURL: \(endpoint)")
                completion(nil)
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

                completion(image)
            }

            task.resume()
        }
}
