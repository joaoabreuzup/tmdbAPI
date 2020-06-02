//
//  Urls.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 06/03/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation


class Urls {
    
    //MARK: - PROPERTIES
    
    static private let tmdbApiKey: String = "305bfe5929d0d3cc96a869e34f6bdc5d"
    
    static private let language: String = "pt_BR"
     
    static private let imgBaseUrl: String = "https://image.tmdb.org/t/p/original"
    
    static private let movieDetailsBaseUrl: String = "https://api.themoviedb.org/3/movie/"
    
    static private let genresBaseUrl: String = "https://api.themoviedb.org/3/genre/movie/list"
    
    static private let moviesByGenreBaseUrl: String = "https://api.themoviedb.org/3/discover/movie"
    
    //MARK: FUNCTIONS
    
    static func getMovieDetailsUrl(with movieID: Int) -> String {
        return "\(movieDetailsBaseUrl)\(movieID)?api_key=\(tmdbApiKey)&language=\(language)"
    }
    
    static func getMoviePosterPath(with posterPath: String) -> String {
        return "\(imgBaseUrl)\(posterPath)"
    }
    
    static func getMovieBackdropPath(with backdropPath: String) -> String {
        return "\(imgBaseUrl)\(backdropPath)"
    }
    
    static func getGenres() -> String {
        return "\(genresBaseUrl)?api_key=\(tmdbApiKey)&language=\(language)"
    }
    
    static func getMoviesByGenre(id: Int) -> String{
        return "\(moviesByGenreBaseUrl)?api_key=\(tmdbApiKey)&language=\(language)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(id)"
    }
    
}
