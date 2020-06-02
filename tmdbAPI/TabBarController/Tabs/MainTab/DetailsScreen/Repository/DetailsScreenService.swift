//
//  DetailsScreenService.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 07/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol DetailsScreenServiceProtocol {
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetailsEntity, Error>) -> Void)
}

class DetailsScreenService: DetailsScreenServiceProtocol {
    
    var networkDispatcher: NetworkDispatcherProtocol = NetworkDispatcher()
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetailsEntity, Error>) -> Void) {
        
        networkDispatcher.request(url: Urls.getMovieDetailsUrl(with: movieID)) { (result) in
            
            switch result {
            case .success(let data):
                do {
                    let details = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
                    completion(.success(details))
                } catch {
                    completion(.failure(MovieDetailsServiceErro.parseError("Parse Error")))
                }
            case .failure(let err):
                completion(.failure(MovieDetailsServiceErro.networkError(err.localizedDescription)))
            }
        }
    }
    
}

enum MovieDetailsServiceErro: Error {
    case parseError(String)
    case networkError(String)
}
