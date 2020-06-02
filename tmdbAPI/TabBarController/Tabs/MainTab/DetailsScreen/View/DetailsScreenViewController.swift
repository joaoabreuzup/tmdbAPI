//
//  DetailsScreenViewController.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 07/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class DetailsScreenViewController: UIViewController {
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reload()
    }
    
    //MARK: - MODEL
    
    var delegate: DetailsScreenViewControllerDelegate?
    
    private var viewModel: DetailsScreenViewModelProtocol
    
    //MARK: - Initialization
    
    init(viewModel: DetailsScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var movieBackdropPath: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var moviePosterPath: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-Bold", size: 25)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var closeButton: UIImageView = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeDetailsScreen))
        let button = UIImageView()
        button.image = UIImage(systemName: "xmark.circle.fill")
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tapGestureRecognizer)
        return button
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let addToFavoritesButton = UIButton()
        addToFavoritesButton.backgroundColor = .black
        addToFavoritesButton.setTitleColor(.white, for: .normal)
        addToFavoritesButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 18)
        addToFavoritesButton.layer.cornerRadius = 5
        
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites(_:)), for: .touchDown)
        
        return addToFavoritesButton
    }()

    
    //MARK: - FUNCTIONS
    
    private func setAddToFavoritesButtonTitle() {
        if viewModel.isSaved() {
            addToFavoritesButton.setTitle("NÃO QUERO ASSISTIR", for: .normal)
        } else {
            addToFavoritesButton.setTitle("QUERO ASSISTIR", for: .normal)
        }
    }
    
    @objc func closeDetailsScreen(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @objc func addToFavorites(_ sender: UITapGestureRecognizer) {
        if addToFavoritesButton.titleLabel?.text == "QUERO ASSISTIR" {
            viewModel.saveData()
            addToFavoritesButton.setTitle("NÃO QUERO ASSISTIR", for: .normal)
            self.dismiss(animated: true)
        } else {
            viewModel.deleteData()
            addToFavoritesButton.setTitle("QUERO ASSISTIR", for: .normal)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - DetailsScreenViewModelDelegate

extension DetailsScreenViewController: DetailsScreenViewModelDelegate {
    func showMovieDetails(details: MovieDetails) {
        moviePosterPath.sd_setImage(with: details.posterPathLink)
        movieBackdropPath.sd_setImage(with: details.backdropPathLink)
        moviePosterPath.contentMode = .scaleToFill
        movieTitleLabel.text = details.title
        movieInfoLabel.text = details.info
        movieOverviewLabel.text = details.overview
    }
    
    func showErrorModel() {
        print("Deu pau")
    }
}

// MARK: - View Code

extension DetailsScreenViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieBackdropPath)
        contentView.addSubview(moviePosterPath)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieInfoLabel)
        contentView.addSubview(movieOverviewLabel)
        view.addSubview(closeButton)
        contentView.addSubview(addToFavoritesButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.bottom.trailing.leading.top.equalTo(view.safeAreaLayoutGuide)
            
        }
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        movieBackdropPath.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.height.equalTo(220)
        }
        moviePosterPath.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(15)
            $0.top.equalTo(movieBackdropPath.snp.bottom).inset(43)
            $0.height.equalTo(197)
            $0.width.equalTo(197 * 2/3)
        }
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(movieBackdropPath.snp.bottom).offset(15)
            $0.leading.equalTo(moviePosterPath.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView).inset(20)
        }
        movieInfoLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(movieTitleLabel.snp.leading)
            $0.trailing.equalTo(movieTitleLabel.snp.trailing)
        }
        movieOverviewLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(moviePosterPath.snp.bottom).offset(40)
            $0.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).inset(15)
            $0.top.greaterThanOrEqualTo(movieInfoLabel.snp.bottom).offset(18)
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalTo(scrollView)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view).offset(15)
            $0.trailing.equalTo(view).inset(15)
            $0.width.height.equalTo(30)
        }
        addToFavoritesButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(movieOverviewLabel.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).offset(10)
            $0.bottom.trailing.equalTo(contentView).inset(10)
            $0.height.equalTo(40)
        }
    }
    
    func setupAdditionalConfiguration() {
        self.view.backgroundColor = .white
        setAddToFavoritesButtonTitle()
        viewModel.delegate = self
        viewModel.fetchMovieDetails()
        
    }
    
    
}
