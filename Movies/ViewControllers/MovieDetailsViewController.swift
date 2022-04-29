//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation
import UIKit
import Combine

class MovieDetailsViewController : UIViewController, MovieViewControllerProtocol {
    var viewModel: MovieViewModelType?
    private var row:Int!
    private var id: Int!
    
    static private let identiferCell = "CollectionCell"
    
    private var productionImages:[Data?] = []
    private var productionNames:[String?] = []
    
    func configure(row:Int) {
        self.row = row
    }
    
    func setupViewModel(viewModel: MovieViewModelType){
        self.viewModel = viewModel
        self.id = viewModel.getMovie(by: row)?.id
    }
    
    private lazy var favouriteToggle : UISwitch = {
        let favouriteToggle : UISwitch = UISwitch()
        favouriteToggle.translatesAutoresizingMaskIntoConstraints = false
        favouriteToggle.addTarget(self, action: #selector(onToggle), for: .valueChanged)
        return favouriteToggle
    }()
    
    private var posterImageView:UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        return posterImageView
    }()
    
    private let titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "label"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return titleLabel
    }()
    
    private let detailsLabel:UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.text = "overview"
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.numberOfLines = 10
        return detailsLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let movie = viewModel?.getMovie(by: row)
        let imageData = viewModel?.getImageData(by: (movie?.id)!)
        posterImageView.image = UIImage(data: imageData!)
        titleLabel.text = movie?.title
        detailsLabel.text = movie?.overview
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isFavourite = viewModel!.isFavourite(by: id!)
        favouriteToggle.isOn = isFavourite
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(favouriteToggle)
        view.addSubview(posterImageView)
        view.addSubview(detailsLabel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 10).isActive = true
        
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favouriteToggle.leadingAnchor).isActive = true
        
        favouriteToggle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        favouriteToggle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        favouriteToggle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        
        posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: detailsLabel.leadingAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width / 3).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5).isActive = true
        
        
        detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        detailsLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor).isActive = true
        detailsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
    }
    
    @objc private func onToggle(){
        print(favouriteToggle.isOn)
        if(favouriteToggle.isOn) {
            viewModel?.makeFavourite(by: id)
        } else{
            viewModel?.removeFavourite(by: id)
        }
    }
}
