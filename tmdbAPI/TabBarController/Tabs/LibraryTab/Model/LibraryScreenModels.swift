//
//  LibraryScreenModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 18/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

class LibraryScreenModel: NSObject, NSCoding {
    
    let movieID: Int
    let posterPath: String
    
    init(movieID: Int, posterPath: String) {
        self.movieID = movieID
        self.posterPath = posterPath
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let movieID = aDecoder.decodeInteger(forKey: "movieID")
        let posterPath = aDecoder.decodeObject(forKey: "posterPath") as! String
        self.init(movieID: Int(movieID), posterPath: posterPath)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(movieID, forKey: "movieID")
        aCoder.encode(posterPath, forKey: "posterPath")
    }
}
