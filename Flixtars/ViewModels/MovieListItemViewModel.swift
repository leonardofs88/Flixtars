//
//  MovieListItemViewModel.swift
//  Flixtars
//
//  Created by Leonardo Soares on 20/02/23.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class MovieListItemViewModel {
    fileprivate(set) var movie: Movie?
    fileprivate let repository: TMDBRepositoryProtocol?
    fileprivate lazy var disposeBag = DisposeBag()
    
    
    init(movie: Movie, repository: TMDBRepositoryProtocol?) {
        self.movie = movie
        self.repository = repository
    }
    
    func getMovieTitle() -> String {
        movie?.title ?? "No title avalable"
    }
    
    func getMovieDescription() -> String {
        movie?.overview ?? "No description avalable"
    }
    
    func getImage() -> Observable<Data> {
        guard let path = movie?.posterPath,
              let repo = repository else { return Observable.error(AFError.explicitlyCancelled) }
        return repo.getImage(path)
    }
}
