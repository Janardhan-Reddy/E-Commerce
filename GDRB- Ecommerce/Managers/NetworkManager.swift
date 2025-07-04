//
//  NetworkManager.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unknown
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request: URLRequest

        if method == .GET, let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }

        request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method != .GET, let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }

        task.resume()
    }
}
