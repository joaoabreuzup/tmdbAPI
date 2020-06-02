//
//  LibraryViewController.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 18/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

protocol DetailsScreenViewControllerDelegate {
    func reload()
}

class LibraryViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchLibrary()
        handleLibraryTitleLabel()
    }
    
    
    //MARK: - MODEL
    
    var viewModel: LibraryScreenViewModelProtocol
    
    //MARK: - INITIALIZATION
    
    init(viewModel: LibraryScreenViewModelProtocol = LibraryScreenViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS

    private lazy var libraryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filmes pra assistir"
        label.font = UIFont(name: "Avenir Next", size: 30)
        label.textColor = .white
        return label
    }()
    
    private lazy var favoritesCollectionView: UICollectionView = createCollection()
    
    
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
    
    private func handleLibraryTitleLabel() {
        if viewModel.getLibraryCount() == 0 {
            libraryTitleLabel.text = "Nenhum filme pra assistir"
        }
        else {
            libraryTitleLabel.text = "Filmes pra assistir"
        }
    }
    
}

//MARK: - VIEW CODE

extension LibraryViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(libraryTitleLabel)
        view.addSubview(favoritesCollectionView)
    }
    
    func setupConstraints() {
        libraryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(view).inset(20)
            $0.height.equalTo(30)
        }
        favoritesCollectionView.snp.makeConstraints {
            $0.top.equalTo(libraryTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view).offset(0)
            $0.trailing.equalTo(view).inset(0)
            $0.height.equalTo(300)
        }
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = #colorLiteral(red: 0.1603999436, green: 0.1644465923, blue: 0.1861866117, alpha: 1)
        viewModel.fetchLibrary()
        viewModel.delegate = self
        handleLibraryTitleLabel()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
    }

}

//MARK: - COLLECTION FUNCTIONS

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func showMovieDetails(libraryMovie: LibraryScreenModel) {
        let vc = DetailsScreenViewController(viewModel: DetailsScreenViewModel(movieInfo: DetailsScreenViewModel.MovieInfo(posterPath: libraryMovie.posterPath, movieId: libraryMovie.movieID)))
        vc.delegate = self
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getLibraryCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
        if let customCell = cell as? MovieCollectionViewCell {
            customCell.setupImageView(completeLink: viewModel.getLibraryMoviePosterPath(indexPathRow: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300 * 2/3, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showMovieDetails(libraryMovie: viewModel.getLibraryMovie(indexPathRow: indexPath.row))
    }
    
}

extension LibraryViewController: DetailsScreenViewControllerDelegate {
    func reload() {
        viewModel.fetchLibrary()
        handleLibraryTitleLabel()
    }
}

extension LibraryViewController: LibraryScreenViewModelDelegate {
    func reloadData() {
        self.favoritesCollectionView.reloadData()
    }
    
    
}
