//
//  MainScreenViewModel.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 27/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

protocol MainScreenViewModelProtocol {
    func fetchGenres()
    func getGenreName(section: Int) -> String
    func getGenreId(indexPathSection: Int) -> Int
    func getGenresCount() -> Int
    var delegate: MainScreenViewModelDelegate? { get set }
}

protocol MainScreenViewModelDelegate {
    func reloadData()
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    //MARK: - MODEL
    
    private var genresList: GenresList? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.reloadData()
            }
        }
    }
    
    //MARK: - DELEGATE
    
    var delegate: MainScreenViewModelDelegate?
    
    //MARK: - DEPENDENCIES
    
    private let service: MainScreenServiceProtocol
    
    //MARK: - INITIALIZATION
    
    init(service: MainScreenServiceProtocol = MainScreenService()) {
        self.service = service
    }
    
    //MARK: - FUNCTIONS
    
    func fetchGenres(){
        service.fetchGenres {
            switch $0 {
            case .success(let genres):
                self.genresList = genres
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getGenreName(section: Int) -> String{
        return genresList?.genres?[section].name ?? ""
    }
    
    func getGenresCount() -> Int{
        return genresList?.genres?.count ?? 0
    }

    func getGenreId(indexPathSection: Int) -> Int {
        return genresList?.genres?[indexPathSection].id ?? 0
    }
    
}

