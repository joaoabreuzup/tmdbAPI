//
//  DetailsScreenViewModelTests.swift
//  tmdbAPITests
//
//  Created by João Jacó Santos Abreu on 04/03/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import XCTest
@testable import tmdbAPI

class DetailsScreenViewModelTests: XCTestCase {

    func testUserDataHelperFunctions() {
        //Given
        let userDataHelperSpy = UserDataHelperCoreDataSpy()
        let viewModel = DetailsScreenViewModel(movieInfo: .init(posterPath: "/blabla", movieId: 123), userDataHelper: userDataHelperSpy)
        
        //When
        viewModel.saveData()
        viewModel.deleteData()
        viewModel.isSaved()
        
        //Then
        XCTAssert(userDataHelperSpy.didCallSaveData)
        XCTAssert(userDataHelperSpy.didCallDeleteData)
        XCTAssert(userDataHelperSpy.didCallIsSaved)
        XCTAssert(userDataHelperSpy.savedDataMovieId.movieID == 123)
        XCTAssert(userDataHelperSpy.savedDataMovieId.posterPath == "/blabla")
        XCTAssert(userDataHelperSpy.deletedDataMovieId == 123)
        XCTAssert(userDataHelperSpy.isSavedMovieId == 123)
    }
    
    func testWhenCallsGetMovieId() {
        // Given
        let expectedMovieId = 123
        var getMovieId: Int
        let viewModel = DetailsScreenViewModel(movieInfo: .init(posterPath: "/blabla", movieId: 123))
        
        // When
        getMovieId = viewModel.getMovieId()
        
        // Then
        XCTAssert(getMovieId == expectedMovieId)
    }
    
    func testWhenCallFetchMovieDetails() {
        // Create an expectation
        let expectation = self.expectation(description: "fetching...")
        
        //Given
        let expectedDetails = MovieDetails(posterPathLink: URL(string: "https://image.tmdb.org/t/p/original/blabla"), backdropPathLink: URL(string: "https://image.tmdb.org/t/p/original/backdropPath"), title: "title", info: "Action \nLançamento: 21 de janeiro de 2011", overview: "overview")
        let serviceSpy = DetailsScreenServiceSpy()
        let viewModel = DetailsScreenViewModel(service: serviceSpy, movieInfo: .init(posterPath: "/blabla", movieId: 123))
        let delegate = DetailsScreenViewModelDelegateSpy()
        viewModel.delegate = delegate
        delegate.expectation = expectation
        
        //When
        
        viewModel.fetchMovieDetails()

        //Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(delegate.didCallShowMovieDetails)
        XCTAssert(123 == serviceSpy.id)
        if let details = delegate.details {
            XCTAssert(details == expectedDetails)
        }
    }
}

extension MovieDetails: Equatable {
    public static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.info == rhs.info &&
            lhs.backdropPathLink == rhs.backdropPathLink &&
            lhs.overview == rhs.overview &&
            lhs.posterPathLink == rhs.posterPathLink &&
            lhs.title == rhs.title
    }
}

class UserDataHelperCoreDataSpy: UserDataHelperCoreDataProtocol {
    var deletedDataMovieId: Int = 0
    var savedDataMovieId = LibraryScreenModel(movieID: 0, posterPath: "")
    var isSavedMovieId: Int = 0
    
    
    var didCallSaveData: Bool = false
    var didCallDeleteData: Bool = false
    var didCallIsSaved: Bool = false
    
    func saveData(libraryMovie: LibraryScreenModel) {
        self.savedDataMovieId = libraryMovie
        didCallSaveData = true
    }
    
    func deleteData(movieID: Int) {
        self.deletedDataMovieId = movieID
        didCallDeleteData = true
    }
    
    func isSaved(movieId: Int) -> Bool {
        self.isSavedMovieId = movieId
        didCallIsSaved = true
        return true
    }
}

private class DetailsScreenServiceSpy: DetailsScreenServiceProtocol {
    var id: Int?
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetailsEntity, Error>) -> Void) {
        self.id = movieID
        completion(.success(MovieDetailsEntity(posterPath: "/posterPathTest", releaseDate: "2011-01-21", overview: "overview", originalTitle: "title", backdropPath: "/backdropPath", genres: [Genres(id: 1, name: "Action")])))
    }
}

class DetailsScreenViewModelDelegateSpy: DetailsScreenViewModelDelegate {
    var expectation: XCTestExpectation?
    var details: MovieDetails?
    var didCallShowMovieDetails: Bool = false
    var didCalledShowErrorModel: Bool = false
    
    func showMovieDetails(details: MovieDetails) {
        self.details = details
        didCallShowMovieDetails = true
        expectation?.fulfill()
    }
    
    func showErrorModel() {
        didCalledShowErrorModel = true
    }
}



