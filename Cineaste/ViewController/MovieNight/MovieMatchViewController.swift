//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

struct NearbyMovieWithOccurrence {
    var occurances: Int = 1
    var nearbyMovie: NearbyMovie
}

class MovieMatchViewController: UIViewController {
    @IBOutlet weak var matchedMoviesTableView: UITableView! {
        didSet {
            matchedMoviesTableView.dataSource = self
            matchedMoviesTableView.allowsSelection = false
            matchedMoviesTableView.backgroundColor = UIColor.basicBackground

            matchedMoviesTableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }

    fileprivate var nearbyMovieOccurrences: [NearbyMovie: NearbyMovieWithOccurrence] = [:]
    fileprivate var sortedMoviesWithOccurrence = [NearbyMovieWithOccurrence]()
    fileprivate var totalNumberOfPeople: Int = 0

    var storageManager: MovieStorage?

    func configure(with messagesToMatch: [NearbyMessage]) {
        totalNumberOfPeople = messagesToMatch.count
        for message in messagesToMatch {
            for movie in message.movies {
                if nearbyMovieOccurrences[movie] == nil {
                    nearbyMovieOccurrences[movie] = NearbyMovieWithOccurrence(occurances: 1, nearbyMovie: movie)
                } else {
                    nearbyMovieOccurrences[movie]?.occurances += 1
                }
            }
        }

        orderMatchedMoviesByOccurance()
    }

    fileprivate func orderMatchedMoviesByOccurance() {
        let movies = Array(nearbyMovieOccurrences.values)
        sortedMoviesWithOccurrence = movies.sorted { leftSide, rightSide -> Bool in
            leftSide.occurances > rightSide.occurances
        }
    }
}

extension MovieMatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMoviesWithOccurrence.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieMatchCell = tableView.dequeueCell(identifier: MovieMatchCell.identifier)

        cell.configure(with: sortedMoviesWithOccurrence[indexPath.row],
                       amountOfPeople: totalNumberOfPeople,
                       delegate: self)

        return cell
    }
}

extension MovieMatchViewController: MovieMatchTableViewCellDelegate {
    func movieMatchTableViewCell(sender: MovieMatchCell,
                                 didSelectMovie selectedMovie: NearbyMovieWithOccurrence,
                                 withPoster poster: UIImage?) {
        let movieForRequest = Movie(id: selectedMovie.nearbyMovie.id,
                                    title: selectedMovie.nearbyMovie.title)
        Webservice.load(resource: movieForRequest.get) { result in
            switch result {
            case .success(let movie):
                movie.poster = poster

                guard let storageManager = self.storageManager else { return }
                storageManager.insertMovieItem(with: movie, watched: true)

                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
            }
        }
    }
}
