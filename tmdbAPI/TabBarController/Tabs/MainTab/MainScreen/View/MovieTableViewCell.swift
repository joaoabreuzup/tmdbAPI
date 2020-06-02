//
//  MovieTableViewCell.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 17/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieTableViewCellDelegate {
    func showMovieDetails(movie: Movie)
}

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - MODEL
    
    private var viewModel: MovieTableViewCellViewModelProtocol?
    
    var movieList = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    var service = MainScreenService()
    var delegate: MovieTableViewCellDelegate?
    
    //MARK: - VIEWS
    
    private lazy var moviesCollectionView: UICollectionView = createCollection()

    //MARK: - PUBLIC FUNCTIONS
    
    func setupCell(viewModel: MovieTableViewCellViewModelProtocol) {
        setupView()
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        self.viewModel?.fetchMoviesByGenre()
    }
    
    //MARK: - PRIVATE FUNCTIONS

    private func createCollection() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.1603999436, green: 0.1644465923, blue: 0.1861866117, alpha: 1)
        
        collectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        return collectionView
    }

}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getMovieListCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
        if let customCell = cell as? MovieCollectionViewCell {
            customCell.setupImageView(completeLink: viewModel?.getMoviePosterPath(indexPathRow: indexPath.row))
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 2/3, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        delegate?.showMovieDetails(movie: viewModel?.getMovie(indexPathRow: indexPath.row) ?? Movie(id: 0, posterPath: ""))
        
    }
}

extension MovieTableViewCell: ViewCode {
    func buildViewHierarchy() {
        self.addSubview(moviesCollectionView)
    }
    
    func setupConstraints() {
        moviesCollectionView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
}

extension MovieTableViewCell: MovieTableViewCellViewModelDelegate {
    func showError() {
    }
    
    func reloadData() {
        self.moviesCollectionView.reloadData()
    }
    
    
}
