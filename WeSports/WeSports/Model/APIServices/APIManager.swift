//
//  APIManager.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func postRequest<E: Encodable>(url: String,
                                   params: E,
                                   completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //encode data
        do {
            request.httpBody = try JSONEncoder().encode(params)
        } catch {
            completion(.failure(.encodeError))
        }
        
        //send request
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data else {
                print(response)
                completion(.failure(.responseError))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
