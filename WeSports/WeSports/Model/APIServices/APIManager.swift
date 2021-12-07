//
//  APIManager.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

final class APIManager {
    static let shared = APIManager()
    private var runningTasks = [UUID: URLSessionDataTask]()
    
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
            let data = try JSONEncoder().encode(params)
            print(String(data: data, encoding: .utf8))
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
    
    func postRequest(url: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    func getRequest(url: String,
                    queryItems: [URLQueryItem]?,
                    completion: @escaping ((Result<Data, APIError>) -> Void)) {
        var urlComps = URLComponents(string: url)
        if let queryItems = queryItems {
            urlComps?.queryItems = queryItems
        }
        
        guard let url = urlComps?.url else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
    
    func getRequest<E: Encodable>(url: String,
                                   params: E,
                                   completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
    
    func loadImageURL(path: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) -> UUID? {
        guard let url = URL(string: path) else { return nil}
        let imageCaches = ImageCacheManager.shared.imagesCache
        let key = NSString(string: path)
        
        if let cachedData = imageCaches.value(for: key) {
            completion(.success(cachedData))
            return nil
        }
        
        let taskID = UUID()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            defer {
                self.runningTasks.removeValue(forKey: taskID)
            }
            
            if let error = error, (error as NSError).code != NSURLErrorCancelled {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.responseError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            imageCaches.insert(image, for: key)
            completion(.success(image))
        }
        task.resume()
        runningTasks[taskID] = task
        return taskID
    }
    
    func cancelTask(with taskID: UUID) {
        runningTasks[taskID]?.cancel()
        runningTasks.removeValue(forKey: taskID)
    }
}
