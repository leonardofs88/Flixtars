//
//  MovieDetailViewModel.swift
//  Flixtars
//
//  Created by Leonardo Soares on 20/02/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class MovieDetailViewModel {
    fileprivate let movie: Movie?
    fileprivate let repository: TMDBRepositoryProtocol?
    
    init(movie: Movie, repository: TMDBRepositoryProtocol?) {
        self.movie = movie
        self.repository = repository
    }
    
    func getTitle() -> String {
        movie?.title ?? "No title avalable"
    }
    
    func getDescription() -> String {
        movie?.overview ?? "No title avalable"
    }
    func getReleaseDate() -> String {
        guard let date = movie?.releaseDate else { return "No release date available"}
        let dateComponents = date.split(separator: "-")
        return "\(dateComponents[2])/\(dateComponents[1])/\(dateComponents[0])"
    }
    
    func getRating() -> String {
        movie?.isAdult ?? false ? "Adult Movie" : ""
    }
    
    func getImage() -> Observable<Data> {
        guard let path = movie?.posterPath,
              let repo = repository else { return Observable.error(AFError.explicitlyCancelled) }
        return repo.getImage(path)
    }
    
    func getPopularity() -> String {
        guard let popularity = movie?.popularity else { return "" }
        guard let voteCount = movie?.voteCount else { return "" }
        
        return "Overall rating: \(round(popularity / 100))% out of \(voteCount) votes."
    }
}
