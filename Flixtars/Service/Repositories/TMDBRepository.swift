//
//  TMDBRepository.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation

import Alamofire
import RxSwift

protocol TMDBRepositoryProtocol: AnyObject {
    func getPopularMovies(for page: Int) -> Observable<MoviesWrapper>
    func getMovie(_ id: Int) -> Observable<Movie>
    func getImage(_ path: String) -> Observable<Data>
}

class TMDBRepository: TMDBRepositoryProtocol {
    
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func getPopularMovies(for page: Int) -> Observable<MoviesWrapper> {
        service.request(TMDBEndpoinRouter.getPopularMovies(1))
    }
    
    func getMovie(_ id: Int) -> Observable<Movie> {
        service.request(TMDBEndpoinRouter.getMovie(1))
    }
    
    func getImage(_ path: String) -> Observable<Data> {
        service.requestImage(TMDBEndpoinRouter.getImage(path))
    }
}

