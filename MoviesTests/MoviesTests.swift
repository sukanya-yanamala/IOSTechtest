//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import XCTest
import Combine
@testable import Movies


class MoviesTests: XCTestCase {
    
   
    private var subscribers = Set<AnyCancellable>()
    
    

    func testGetMovies_Sucess() throws {
        //Given
    let fakeNetworkManager = FakeNetworkManager()
        let data = try getDataFrom(jsonFile: "data")
        fakeNetworkManager.data = data
        var viewModel = MovieViewModel(networkManager: fakeNetworkManager)
        let expectation = expectation(description: "sucess expectation")
        var movies: [Movie] = []
        
        //When
        viewModel.getMovies()
        viewModel
            .$movies
            .sink { result in
                movies = result
                expectation.fulfill()
            }
            .store(in: &subscribers)
        //Then
        
        waitForExpectations(timeout: 2.0)
        XCTAssertEqual(movies.count, 20)
        XCTAssertTrue(movies.first?.title == "The Batman")
    
    
        func setUpWithError() throws {
        viewModel = MovieViewModel(networkManager: fakeNetworkManager)
    }
        
}
   
    private func getDataFrom(jsonFile: String) throws -> Data {
        let bundle = Bundle(for: MoviesTests.self)
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json")
        else { fatalError("url \(jsonFile) could not be loaded") }
        return try Data(contentsOf: url)
    }

}
