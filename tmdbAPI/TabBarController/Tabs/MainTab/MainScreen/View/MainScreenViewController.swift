//
//  ViewController.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 06/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MainScreenViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    //MARK: - MODEL
    
    private var viewModel: MainScreenViewModelProtocol
    
    //MARK: - INITIALIZATION
    
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEWS
    
    private lazy var tableview: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.backgroundColor = #colorLiteral(red: 0.1603999436, green: 0.1644465923, blue: 0.1861866117, alpha: 1)
        return tableView
    }()
}

//MARK: - VIEW CODE

extension MainScreenViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(tableview)
    }
    
    func setupConstraints() {
        tableview.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = #colorLiteral(red: 0.1603999436, green: 0.1644465923, blue: 0.1861866117, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        viewModel.delegate = self
        viewModel.fetchGenres()
    }

}

//MARK: - TABLE VIEW FUNCTIONS

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getGenreName(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getGenresCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(view)
            $0.leading.equalTo(view).offset(15)
        }
        label.text = viewModel.getGenreName(section: section)
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 17)
        view.backgroundColor = #colorLiteral(red: 0.1603999436, green: 0.1644465923, blue: 0.1861866117, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let genreId = viewModel.getGenreId(indexPathSection: indexPath.section)
        
        cell.delegate = self
        cell.setupCell(viewModel: MovieTableViewCellViewModel(genreId: genreId))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension MainScreenViewController: MovieTableViewCellDelegate {
    func showMovieDetails(movie: Movie) {
        if let id = movie.id, let poster = movie.posterPath {
            let vc = DetailsScreenViewController(viewModel: DetailsScreenViewModel(movieInfo: DetailsScreenViewModel.MovieInfo(posterPath: poster, movieId: id)))
            navigationController?.present(vc, animated: true)
        }
    }
}

extension MainScreenViewController: MainScreenViewModelDelegate {
    func reloadData() {
        self.tableview.reloadData()
    }
    
    
}
