//
//  SearchMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SearchMoviesViewControllerTests: XCTestCase {
    let searchMoviesVC = SearchMoviesViewController.instantiate()

    override func setUp() {
        super.setUp()

        DispatchQueue.main.async {
            self.searchMoviesVC.movies = []
        }
    }

    func testTableViewDelegateAndDataSourceShouldNotBeNil() {
        searchMoviesVC.viewDidLoad()

        XCTAssertNotNil(searchMoviesVC.moviesTableView.delegate)
        XCTAssertNotNil(searchMoviesVC.moviesTableView.dataSource)
    }

    func testBackgroundColorShouldBeSetCorrectly() {
        searchMoviesVC.viewDidLoad()

        XCTAssertEqual(searchMoviesVC.view.backgroundColor, UIColor.basicBackground)
        XCTAssertEqual(searchMoviesVC.moviesTableView.backgroundColor, UIColor.clear)
    }
    
    func testNumberOfRowsShouldEqualNumberOfMovies() {
        XCTAssertEqual(searchMoviesVC.moviesTableView.numberOfSections, 0)
        let expc = expectation(description: "Setting movies should trigger updating tableView")

        DispatchQueue.main.async {
            self.searchMoviesVC.movies = self.movies
            expc.fulfill()
        }

        wait(for: [expc], timeout: 1)
        XCTAssertEqual(self.searchMoviesVC.moviesTableView.numberOfSections, 2)
    }

    func testCellForRowShouldBeOfTypeSearchMoviesCell() {
        let expc = expectation(description: "Setting movies should trigger updating tableView")

        DispatchQueue.main.async {
            self.searchMoviesVC.movies = self.movies
            expc.fulfill()
        }

        wait(for: [expc], timeout: 1)

        for section in 0..<movies.count {
            let path = IndexPath(row: 0, section: section)
            let cell = searchMoviesVC.moviesTableView.cellForRow(at: path)

            XCTAssert(cell is SearchMoviesCell)
        }
    }

    private let movies: [Movie] = {
        guard let path = Bundle(for: SearchMoviesViewControllerTests.self).path(forResource: "Movie", ofType: "json") else {
            fatalError("Could not load file for resource Movie.json")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let movie = try! JSONDecoder().decode(Movie.self, from: data)
            return [movie, movie]
        } catch let error {
            fatalError("Error while decoding Movie.json: \(error.localizedDescription)")
        }
    }()

}
