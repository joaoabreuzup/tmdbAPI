//
//  MovieTableViewCellViewModelTests.swift
//  tmdbAPITests
//
//  Created by João Jacó Santos Abreu on 10/03/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import XCTest
@testable import tmdbAPI

class MovieTableViewCellViewModelTests: XCTestCase {

    let expectedMovieList = MovieList.init(results: [Movie(id: 1, posterPath: "/testeMovie1"), Movie(id: 2, posterPath: "/testeMovie2")])
    let serviceSpy = MainScreenServiceSpy()
    lazy var sut = MovieTableViewCellViewModel(service: serviceSpy, genreId: 1)
    
    func test_whenCallsFetchMovieByGenre() {
        //When
        sut.fetchMoviesByGenre()
        //Then
        XCTAssert(serviceSpy.didCallFetchMoviesByGenre)
    }
    
    func test_whenCallsGetMovieListCount() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchMoviesByGenre()
        waitForExpectations(timeout: 2, handler: nil)
        //Then
        let movieListCount = sut.getMovieListCount()
        XCTAssert(movieListCount == expectedMovieList.results.count)
    }
    
    func test_whenCallsGetMoviePosterPath() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchMoviesByGenre()
        waitForExpectations(timeout: 1, handler: nil)
        //Then
        guard let expectedMoviePosterPath = URL(string: Urls.getMoviePosterPath(with: expectedMovieList.results[0].posterPath ?? "")) else {return}
        guard let incomingMoviePosterPath = sut.getMoviePosterPath(indexPathRow: 0) else {return}
        XCTAssert(expectedMoviePosterPath == incomingMoviePosterPath)
    }
    
    func test_whenCallsGetMovie() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchMoviesByGenre()
        waitForExpectations(timeout: 1, handler: nil)
        //Then
        let expectedMovie = expectedMovieList.results[0]
        let incomingMovie = sut.getMovie(indexPathRow: 0)
        XCTAssert(expectedMovie == incomingMovie)
        
    }

}

extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id &&
        lhs.posterPath == rhs.posterPath
    }
    
    
}


