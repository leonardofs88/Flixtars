//
//  File.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MovieListItemView: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    fileprivate lazy var disposeBag = DisposeBag()
    
    var viewModel: MovieListItemViewModel? {
        didSet {
            loadInfo()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.isHidden = false
        coverImageView.image = UIImage(systemName: "film")
        titleLabel.text = "No title available"
        descriptionLabel.text = "No description available"
    }
    
    func loadInfo() {
        indicatorView.isHidden = false
        titleLabel.text = viewModel?.getMovieTitle()
        descriptionLabel.text = viewModel?.getMovieDescription()
        
        viewModel?.getImage()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.indicatorView.isHidden = true
                self?.coverImageView.image = UIImage(data: data)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
