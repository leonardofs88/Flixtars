//
//  MovieDetailsViewController.swift
//  Flixtars
//
//  Created by Leonardo Soares on 20/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieCoveImageView: UIImageView!
    
    @IBOutlet weak var ratedLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var viewModel: MovieDetailViewModel?
    
    lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    fileprivate func loadData() {
        titleLabel.text = viewModel?.getTitle()
        descriptionTextView.text = viewModel?.getDescription()
        ratedLabel.text = viewModel?.getRating()
        releaseDateLabel.text = viewModel?.getReleaseDate()
        ratingLabel.text = viewModel?.getPopularity()
        
        viewModel?.getImage()
            .observe(on: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.movieCoveImageView.image = UIImage(data: data)
            },onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
