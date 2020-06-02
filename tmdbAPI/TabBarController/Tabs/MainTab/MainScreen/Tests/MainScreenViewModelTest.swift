//
//  MainScreenViewModelTest.swift
//  tmdbAPITests
//
//  Created by João Jacó Santos Abreu on 09/03/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import XCTest
@testable import tmdbAPI

class MainScreenViewModelTest: XCTestCase {

    //Given
    let expectedGenres = GenresList(genres: [Genres(id: 1, name: "Action"), Genres(id: 2, name: "Drama")])
    let serviceSpy = MainScreenServiceSpy()
    lazy var sut = MainScreenViewModel(service: serviceSpy)

    
    func test_whenCallsFetchGenres() {
        //When
        sut.fetchGenres()
        //Then
        XCTAssert(serviceSpy.didCallFetchGenres)
    }
    func test_whenCallsGetGenreName() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchGenres()
        waitForExpectations(timeout: 2, handler: nil)
        //Then
        let genreName = sut.getGenreName(section: 0)
        XCTAssert(genreName == expectedGenres.genres?[0].name)
    }

    func test_whenCallsGetGenresCount() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchGenres()
        waitForExpectations(timeout: 2, handler: nil)
        //Then
        let genreCount = sut.getGenresCount()
        XCTAssert(genreCount == expectedGenres.genres?.count)
    }
    
    func test_whenCallsGetGenreId() {
        //Given
        let expectation = self.expectation(description: "")
        serviceSpy.expectation = expectation
        //When
        sut.fetchGenres()
        waitForExpectations(timeout: 2, handler: nil)
        //Then
        let genreId = sut.getGenreId(indexPathSection: 0)
        XCTAssert(genreId == expectedGenres.genres?[0].id)
    }
    
}

class MainScreenServiceSpy: MainScreenServiceProtocol {
    
    var didCallFetchGenres: Bool = false
    var didCallFetchMoviesByGenre: Bool = false
    var expectation: XCTestExpectation?
    
    func fetchMoviesByGenre(genreID: Int?, completion: @escaping (Result<MovieList, Error>) -> Void) {
        completion(.success(MovieList.init(results: [Movie(id: 1, posterPath: "/testeMovie1"), Movie(id: 2, posterPath: "/testeMovie2")])))
        
        self.didCallFetchMoviesByGenre = true
        expectation?.fulfill()
    }
    
    func fetchGenres(completion: @escaping (Result<GenresList, Error>) -> Void) {
        completion(.success(GenresList(
            genres: [Genres(id: 1, name: "Action"), Genres(id: 2, name: "Drama")])))
        
        self.didCallFetchGenres = true
        expectation?.fulfill()
    }
}





