//
//  MoviesListViewModel.swift
//  Flixtars
//
//  Created by Leonardo Soares on 20/02/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol IndicatorDelegate: AnyObject {
    func startAnimating()
    func stopAnimating()
}

class MoviesListViewModel {
    var publishMovies = PublishRelay<[Movie]>()
    var isLoading = false
    fileprivate var repository: TMDBRepositoryProtocol?
    fileprivate lazy var disposeBag = DisposeBag()
    fileprivate var currentMovies: [Movie] = []
    
    weak var delegate: IndicatorDelegate?
    
    init(repository: TMDBRepositoryProtocol?) {
        self.repository = repository
    }
    
    func getMovies(page: Int) {
        isLoading = true
        delegate?.startAnimating()
        repository?.getPopularMovies(for: page)
            .observe(on: MainScheduler.instance)
            .map { $0.results ?? [] }
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.delegate?.stopAnimating()
                self.isLoading = false
                self.currentMovies.append(contentsOf: movies)
                self.publishMovies.accept(self.currentMovies)
            })
            .disposed(by: disposeBag)
    }
}
