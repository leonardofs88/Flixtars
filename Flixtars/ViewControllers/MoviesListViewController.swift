//
//  MoviesListViewController.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: UITableViewController {
    
    fileprivate var currentPage = 1
    fileprivate let service = Service()
    fileprivate var repository: TMDBRepositoryProtocol?
    var viewModel: MoviesListViewModel?
    fileprivate lazy var disposeBag = DisposeBag()
    
    lazy var indicatorView = UIView()
    lazy var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        repository = TMDBRepository(service: service)
        viewModel = MoviesListViewModel(repository: repository)
        loadData()
        setUpTableView()
        setUpIndicator()
    }
    
    fileprivate func loadData() {
        viewModel?.getMovies(page: currentPage)
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: "MovieListItemView", bundle: nil), forCellReuseIdentifier:  "MovieListItemView")
        
        viewModel?.publishMovies.bind(to: tableView.rx.items(cellIdentifier: "MovieListItemView", cellType: MovieListItemView.self)) { [weak self] (_, movie, cell) in
            cell.viewModel = MovieListItemViewModel(movie: movie, repository: self?.repository)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                
                if offSetY > (contentHeight - self.tableView.frame.size.height - 100),
                   let vm = self.viewModel,
                   !vm.isLoading {
                    self.currentPage += 1
                    self.loadData()
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
                    viewController.viewModel = MovieDetailViewModel(movie: movie, repository: self?.repository)
                    self?.present(viewController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        loadData()
    }
    
    fileprivate func setUpIndicator() {
        indicatorView.frame = view.frame
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        indicator.startAnimating()
        indicatorView.addSubview(indicator)
        tableView.addSubview(indicatorView)
    }
}

extension MoviesListViewController: IndicatorDelegate {
    func startAnimating() {
        indicator.startAnimating()
        indicatorView.isHidden = false
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
        indicatorView.isHidden = true
        tableView.reloadData()
    }
}
