//
//  NetworkDispatcher.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 07/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol NetworkDispatcherProtocol {
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkDispatcher: NetworkDispatcherProtocol {
    
    private let session = URLSession.shared
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url1 = URL(string: url) else { return }
        session.dataTask(with: url1) { (data, response, error) in
            if let fetchedData = data {
                completion(.success(fetchedData))
            } else {
                if let err = error {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
}
