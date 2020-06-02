//
//  MovieService.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 07/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol MainScreenServiceProtocol {
    func fetchGenres(completion: @escaping (Result<GenresList,Error>) -> Void)
    func fetchMoviesByGenre(genreID: Int?, completion: @escaping (Result<MovieList, Error>) -> Void)
    
}

class MainScreenService: MainScreenServiceProtocol {
    
    var networkDispatcher: NetworkDispatcherProtocol = NetworkDispatcher()
    
    func fetchMoviesByGenre(genreID: Int?, completion: @escaping (Result<MovieList, Error>) -> Void) {
        guard let id = genreID else {return}
        
        networkDispatcher.request(url: Urls.getMoviesByGenre(id: id)) { (result) in
            
            switch result {
            case .success(let data):
                do {
                    let details = try JSONDecoder().decode(MovieList.self, from: data)
                    completion(.success(details))
                } catch {
                    completion(.failure(MovieServiceErro.parseError("Parse Error")))
                }
            case .failure(let err):
                completion(.failure(MovieServiceErro.networkError(err.localizedDescription)))
            }
        }
    }
    
    func fetchGenres(completion: @escaping (Result<GenresList,Error>) -> Void) {
        networkDispatcher.request(url: Urls.getGenres()) { (result) in
            switch result {
            case .success(let data):
                do {
                    let genres = try JSONDecoder().decode(GenresList.self, from: data)
                    completion(.success(genres))
                } catch {
                    completion(.failure(MovieServiceErro.parseError("Parse Error")))
                }
            case .failure(let err):
                completion(.failure(MovieServiceErro.networkError(err.localizedDescription)))
            }
        }
        
    }

}

enum MovieServiceErro: Error {
    case parseError(String)
    case networkError(String)
}
