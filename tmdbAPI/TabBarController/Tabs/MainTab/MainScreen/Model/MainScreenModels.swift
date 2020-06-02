//
//  Movie.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 06/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol ConvertPosterLink {
    var posterPath: String? {get}
    var posterURL: URL? {get}
}

extension ConvertPosterLink {
    var posterURL: URL? {
        if let posterPath = self.posterPath?.replacingOccurrences(of: "ˆ/", with: "", options: .regularExpression) {
            return URL(string: posterPath, relativeTo: URL(string: "https://image.tmdb.org/t/p/w342/"))
        }
        return nil
    }
}

struct MovieList: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int?
    let posterPath: String?
    
    init(id: Int?, posterPath: String?) {
        self.id = id
        self.posterPath = posterPath
    }
    
    enum MovieKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)
        
        let id: Int? = try container.decodeIfPresent(Int.self, forKey: .id)
        let posterPath: String? = try container.decodeIfPresent(String.self, forKey: .posterPath)
        
        self.init(id: id, posterPath: posterPath)
    }
}

