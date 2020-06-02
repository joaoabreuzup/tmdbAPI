//
//  LibraryScreenViewModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 28/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol LibraryScreenViewModelProtocol {
    func fetchLibrary()
    func getLibraryCount() -> Int
    func getLibraryMoviePosterPath(indexPathRow: Int) -> URL?
    func getLibraryMovie(indexPathRow: Int) -> LibraryScreenModel
    var delegate: LibraryScreenViewModelDelegate? { get set }
}

protocol LibraryScreenViewModelDelegate {
    func reloadData()
}

class LibraryScreenViewModel: LibraryScreenViewModelProtocol {
    
    //MARK: - MODEL
    
    private var libraryModel: [LibraryScreenModel]? {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
    //MARK: - DELEGATE
    
    var delegate: LibraryScreenViewModelDelegate?
    
    //MARK: - DEPENDENCIES
    
    let userDataHelperCoreData: UserDataHelperCoreData
    
    //MARK: - INITIALIZATION
    
    init(userDataHelperCoreData: UserDataHelperCoreData = UserDataHelperCoreData()) {
        self.userDataHelperCoreData = userDataHelperCoreData
    }
    
    //MARK: - FUNCTIONS
    
    func getLibraryMoviePosterPath(indexPathRow: Int) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w780\(libraryModel?[indexPathRow].posterPath ?? "")")
    }
    
    func getLibraryCount() -> Int {
        return libraryModel?.count ?? 0
    }
    
    func fetchLibrary() {
        libraryModel = userDataHelperCoreData.retrieveData()
    }
    
    func getLibraryMovie(indexPathRow: Int) -> LibraryScreenModel {
        return libraryModel?[indexPathRow] ?? LibraryScreenModel(movieID: 0, posterPath: "")
    }
    
}
