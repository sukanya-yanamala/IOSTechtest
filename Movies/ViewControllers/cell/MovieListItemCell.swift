//
//  MovieListItemCell.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import UIKit

class MovieListItemCell : UITableViewCell {
    static let identifier = "movieListItem"
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    lazy var movieImage: UIImageView = {
        let movieImage = UIImageView()
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        //        movieImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        movieImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        movieImage.layer.cornerRadius = 8.0
        movieImage.clipsToBounds = true
        return movieImage
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font =  UIFont.boldSystemFont(ofSize: 15.0)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .left
        return label
    }()
    
    private let favouriteLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let vView   = UIStackView()
        vView.axis  = .vertical
        vView.distribution  = .fill
        vView.alignment = .leading
        vView.spacing   = 5
        
        vView.addArrangedSubview(titleLabel)
        vView.addArrangedSubview(overviewLabel)
        vView.translatesAutoresizingMaskIntoConstraints = false
        
        let hView   = UIStackView()
        hView.axis  = .horizontal
        hView.distribution  = .fill
        hView.alignment = .leading
        hView.spacing   = 5
        hView.addArrangedSubview(movieImage)
        hView.addArrangedSubview(vView)
        hView.addArrangedSubview(favouriteLabel)
        hView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(hView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        // constrain the stack view to all four side of myView
        hView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        hView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5).isActive = true
        hView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        hView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 5).isActive = true
        hView.heightAnchor.constraint(equalToConstant: 100 ).isActive = true
        hView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 30 ).isActive = true
        
        
        
    }
    
    func configure(by movieItem: MovieItem){
        if let data = movieItem.imageData{
            movieImage.image     = UIImage(data: data)
        }
        titleLabel.text = movieItem.title
        overviewLabel.text = movieItem.overview
        
        if(movieItem.isFavourite ?? false){
            favouriteLabel.image =  UIImage(systemName: "star.fill")
        }else {
            favouriteLabel.image =  UIImage(systemName: "star")
        }

    }
}


