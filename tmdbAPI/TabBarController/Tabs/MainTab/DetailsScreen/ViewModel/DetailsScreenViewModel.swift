//
//  DetailsScreenViewModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 27/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol DetailsScreenViewModelProtocol {
    func fetchMovieDetails()
    func getMovieId() -> Int
    func isSaved() -> Bool
    func saveData()
    func deleteData()
    var delegate: DetailsScreenViewModelDelegate? { get set }
}

protocol DetailsScreenViewModelDelegate {
    func showMovieDetails(details: MovieDetails)
    func showErrorModel()
}

class DetailsScreenViewModel:  DetailsScreenViewModelProtocol {
    
    // MARK: Model
    
    private var movieDetails: MovieDetailsEntity? {
        didSet {
            DispatchQueue.main.async {
                if let details = self.mapToPresentationModel() {
                    self.delegate?.showMovieDetails(details: details)
                } else {
                    self.delegate?.showErrorModel()
                }
            }
        }
    }
    
    // MARK: Delegate
    
    var delegate: DetailsScreenViewModelDelegate?
    
    // MARK: Dependencies
    
    private let service: DetailsScreenServiceProtocol
    private let userDataHelper: UserDataHelperCoreDataProtocol
    private let dateFormatter = DateFormatter()
    
    private let movieInfo: MovieInfo
    
    struct MovieInfo {
        let posterPath: String
        let movieId: Int
    }
    
    // MARK: Initialization
    
    init(service: DetailsScreenServiceProtocol = DetailsScreenService(), movieInfo: MovieInfo, userDataHelper: UserDataHelperCoreDataProtocol = UserDataHelperCoreData()) {
        self.service = service
        self.movieInfo = movieInfo
        self.userDataHelper = userDataHelper
    }
    
    // MARK: Private Functions
    
    private func mapToPresentationModel() -> MovieDetails? {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard
                let movieTitle = movieDetails?.originalTitle,
                let backdropPath = movieDetails?.backdropPath,
                let releaseDate = movieDetails?.releaseDate,
                let overview = movieDetails?.overview,
                let date = dateFormatter.date(from: releaseDate),
                let movieGenres = movieDetails?.genres?.reduce("", { (str, genre) in
                    if str == "" {
                        return "\(genre.name ?? "")"
                    } else {
                        return "\(str ?? ""),  \(genre.name ?? "")"
                    }
                }) else { return nil }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
        
        let details = MovieDetails(posterPathLink: URL(string: Urls.getMoviePosterPath(with: movieInfo.posterPath)), backdropPathLink: URL(string: Urls.getMovieBackdropPath(with: backdropPath)), title: movieTitle, info: "\(movieGenres) \nLançamento: \(dateFormatter.string(from: date))", overview: overview)
            return details
    }
    
    // MARK: DetailsScreenViewModelProtocol Methods
    
    func fetchMovieDetails() {
        service.fetchMovieDetails(movieID: movieInfo.movieId) {
            switch $0 {
            case .success(let details):
                self.movieDetails = details
            case .failure:
                DispatchQueue.main.async {
                    self.delegate?.showErrorModel()
                }
            }
        }
    }
    
    func getMovieId() -> Int {
        movieInfo.movieId
    }
    
    func saveData() {
        userDataHelper.saveData(libraryMovie: LibraryScreenModel(movieID: movieInfo.movieId, posterPath: movieInfo.posterPath))
    }
    
    func deleteData() {
        userDataHelper.deleteData(movieID: movieInfo.movieId)
    }
    
    
    func isSaved() -> Bool {
        userDataHelper.isSaved(movieId: movieInfo.movieId)
    }
}
