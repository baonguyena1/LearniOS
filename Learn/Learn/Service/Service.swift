//
//  Service.swift
//  Learn
//
//  Created by Bao Nguyen on 7/16/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

enum APIError {
    case serverError
    case invalidData
    case invalidJson
    case returnError
    
    func description() -> String {
        switch self {
        case .serverError:
            return "Server Error"
        case .invalidData:
            return "Invalid Data"
        case .invalidJson:
            return "Invalid Json"
        case .returnError:
            return "Return Error"
        }
    }
}

enum Result<T, E> {
    case success(T)
    case fail(E)
}

struct Service {
    static let shared = Service()
    
    func fetchUsers(_ completion: @escaping ((Result<[JSON], APIError>) -> Void)) {
        let urlString = "http://localhost:8888/user"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            self.parse(data, error: error) { (result) in
                switch result {
                case .success(let data):
                    completion(.success(data as! [JSON]))
                case .fail(let error):
                    completion(.fail(error))
                }
            }
        }
            .resume()
    }
    
    func signin(_ parameters: JSON, completion: @escaping ((Result<JSON, APIError>) -> Void)) {
        let urlString = "http://localhost:8888/user/signin"
        guard  let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            self.parse(data, error: error) { (result) in
                switch result {
                case .success(let data):
                    completion(.success(data as! JSON))
                case .fail(let error):
                    completion(.fail(error))
                }
            }
        }
        .resume()
    }
    
    fileprivate func parse(_ data: Data?, error: Error?, completion: @escaping ((Result<Any, APIError>) -> Void)) {
        if let _ = error {
            completion(.fail(.serverError))
            return
        }
        guard let data = data else {
            completion(.fail(.invalidData))
            return
        }
        do {
            let responseJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
            if responseJson == nil {
                completion(.fail(.invalidJson))
                return
            }
            let status = responseJson!["status"] as! Bool
            if !status {
                completion(.fail(.returnError))
                return
            }
            let result = responseJson!["result"] as Any
            completion(.success(result))
        } catch {
            completion(.fail(.invalidJson))
            return
        }
    }
}
