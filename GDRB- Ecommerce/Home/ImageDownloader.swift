//
//  ImageDownloader.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//

import Foundation
import UIKit


extension UIImage {
    static let baseURL = "https://gdrbpractice.gdrbtechnologies.com/"

    static func fetchImage(from endpoint: String, completion: @escaping (UIImage?) -> Void) {
        let fullURLString = endpoint.hasPrefix("http")
            ? endpoint
            : baseURL + (endpoint.hasPrefix("/") ? String(endpoint.dropFirst()) : endpoint)

        guard let encodedURLString = fullURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Invalid image URL:", endpoint)
            completion(nil)
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(" Image fetch error:", error)
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print(" No image data or failed to decode image.")
                completion(nil)
                return
            }

            completion(image)
        }

        task.resume()
    }
}
