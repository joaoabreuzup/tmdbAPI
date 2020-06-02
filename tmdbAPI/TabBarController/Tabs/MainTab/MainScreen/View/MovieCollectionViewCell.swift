//
//  MovieCollectionViewCell.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 06/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func setupImageView(completeLink: URL?) {
        imageView.sd_setImage(with: completeLink)
    }
    
}


// MARK: - Code View

extension MovieCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
