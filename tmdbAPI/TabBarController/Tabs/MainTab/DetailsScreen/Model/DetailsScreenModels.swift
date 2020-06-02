//
//  DetailsScreenModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 07/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation


struct GenresList: Decodable {
    let genres: [Genres]?
    
    init(genres: [Genres]?) {
        self.genres = genres
    }
}

struct Genres: Decodable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

struct MovieDetails {
    let posterPathLink: URL?
    let backdropPathLink: URL?
    let title: String
    let info: String
    let overview: String
}

struct MovieDetailsEntity: Decodable {
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    let originalTitle: String?
    let backdropPath: String?
    let genres: [Genres]?
    
    init(posterPath: String?, releaseDate: String?, overview: String?, originalTitle: String?, backdropPath: String?, genres: [Genres]?) {
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.originalTitle = originalTitle
        self.backdropPath = backdropPath
        self.genres = genres
    }
    
    enum MovieDetailsKeys: String, CodingKey {
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case genres = "genres"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsKeys.self)
        
        let overview: String? = try
            container.decodeIfPresent(String.self, forKey: .overview)
        let posterPath: String? = try container.decodeIfPresent(String.self, forKey: .posterPath)
        let releaseDate: String? = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        let originalTitle: String? = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        let backdropPath: String? = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        let genres: [Genres]? = try container.decodeIfPresent([Genres].self, forKey: .genres)

        
        self.init(posterPath: posterPath, releaseDate: releaseDate, overview: overview, originalTitle: originalTitle, backdropPath: backdropPath, genres: genres)
    }
}
