//
//  MovieTableViewCellViewModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 28/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol MovieTableViewCellViewModelProtocol {
    func fetchMoviesByGenre()
    func getMovieListCount() -> Int
    func getMoviePosterPath(indexPathRow: Int) -> URL?
    func getMovie(indexPathRow: Int) -> Movie
    var delegate: MovieTableViewCellViewModelDelegate? { get set }
}

protocol MovieTableViewCellViewModelDelegate {
    func showError()
    func reloadData()
}

class MovieTableViewCellViewModel: MovieTableViewCellViewModelProtocol {
 
    //MARK: - MODEL
    
    private var movieList: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.reloadData()
            }
        }
    }
    
    //MARK: - DELEGATE
    
    var delegate: MovieTableViewCellViewModelDelegate?
    
    //MARK: - DEPENDENCIES
    
    let service: MainScreenServiceProtocol
    let genreId: Int
    
    //MARK: - INITIALIZATION
    
    init(service: MainScreenServiceProtocol = MainScreenService(), genreId: Int) {
        self.service = service
        self.genreId = genreId
    }
    
    //MARK: - FUNCTIONS
    
    func fetchMoviesByGenre() {
        service.fetchMoviesByGenre(genreID: genreId) {
            switch $0 {
            case .success(let list):
                self.movieList = list.results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getMovieListCount() -> Int {
        return movieList?.count ?? 0
    }
    
    func getMoviePosterPath(indexPathRow: Int) -> URL? {

        return URL(string: Urls.getMoviePosterPath(with: movieList?[indexPathRow].posterPath ?? ""))
    }
    
    func getMovie(indexPathRow: Int) -> Movie {
        return movieList?[indexPathRow] ?? Movie(id: 0, posterPath: "")
    }

}
