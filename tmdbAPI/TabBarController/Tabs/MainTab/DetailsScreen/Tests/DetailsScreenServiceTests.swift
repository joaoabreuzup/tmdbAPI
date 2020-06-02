//
//  DetailsScreenServiceTests.swift
//  tmdbAPITests
//
//  Created by João Jacó Santos Abreu on 05/03/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import XCTest
@testable import tmdbAPI

class DetailsScreenServiceTests: XCTestCase {
    
    lazy var sut: DetailsScreenService  = {
        let service = DetailsScreenService()
        service.networkDispatcher = spy
        return service
    }()
    
    private var spy = NetworkDispatcherSpy()
    
    func test_whenJsonIsValid() {
        spy.completionType = .success
        let expectedMovieDetailsEntity = MovieDetailsEntity(posterPath: "/dJ3VPQTg2gST26IKIk75TNHViB0.jpg", releaseDate: "2019-09-17", overview: "Roy McBride é um engenheiro espacial, portador de um leve grau de autismo, que decide empreender a maior jornada de sua vida: viajar para o espaço, cruzar a galáxia e tentar descobrir o que aconteceu com seu pai, um astronauta que se perdeu há vinte anos atrás no caminho para Netuno.", originalTitle: "Ad Astra", backdropPath: "/5BwqwxMEjeFtdknRV792Svo0K1v.jpg", genres: [Genres(id: 878, name: "Ficção científica")])
        
        sut.fetchMovieDetails(movieID: 3) { (result) in
            switch result {
            case .success(let detailsEntity):
                XCTAssert(detailsEntity.backdropPath == expectedMovieDetailsEntity.backdropPath)
            default:
                break
            }
        }
    }
    
    func test_whenJsonIsInvalid_shouldShowParseError() {
        spy.completionType = .parseFailure
        sut.fetchMovieDetails(movieID: 1) { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            case .success:
                XCTFail()
            }
        }
    }
    
    func test_whenNetworkErrorOccurs_shouldShowNetworkError() {
        spy.completionType = .networkFailure
        sut.fetchMovieDetails(movieID: 2) { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            case .success:
                XCTFail()
            }
        }
    }
}


private class NetworkDispatcherSpy: NetworkDispatcherProtocol {
    
    enum CompletionType {
        case success
        case parseFailure
        case networkFailure
    }
    
    var completionType: CompletionType = .success
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        switch completionType {
        case .parseFailure:
            guard let json = """
                {"posterPath": }
            """.data(using: .utf8) else { return }
            completion(.success(json))
        case .networkFailure:
            completion(.failure(MovieDetailsServiceErro.networkError("erouuuuuuu")))
        case .success:
            guard let url = Bundle.main.url(forResource: "data", withExtension: ".json"),
                let data = try? Data(contentsOf: url) else { return }
            completion(.success(data))
        }
    }
}

