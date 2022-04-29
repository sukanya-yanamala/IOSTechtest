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
    var row:Int!
    var id: Int!
    
    
    static let identiferCell = "CollectionCell"
    
    var productionImages:[Data?] = []
    var productionNames:[String?] = []
    
    
    func configure(row:Int) {
        self.row = row
    }
    
    func setupViewModel(viewModel: MovieViewModelType){
        self.viewModel = viewModel
        self.id = viewModel.getMovie(by: row)?.id
    }
    
    
    
    lazy var favouriteToggle : UISwitch = {
        let closeButton : UISwitch = UISwitch()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(onToggle), for: .valueChanged)
        
        return closeButton
    }()
    
    var posterImageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.backgroundColor = .blue
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    
    let detailsLabel:UILabel = {
        let label = UILabel()
        label.text = "overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 10
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        
        
        view.addSubview(titleLabel)
        view.addSubview(favouriteToggle)
        view.addSubview(posterImageView)
        view.addSubview(detailsLabel)
        
       
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 10).isActive = true
        
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favouriteToggle.leadingAnchor).isActive = true
        
        
        favouriteToggle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
        favouriteToggle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        favouriteToggle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        
        posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: detailsLabel.leadingAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width / 3).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5).isActive = true
        
        
        detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        detailsLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor).isActive = true
        detailsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        

        
    }
    
    @objc func onToggle(){
        print(favouriteToggle.isOn)
        if(favouriteToggle.isOn){
            viewModel?.makeFavourite(by: id)
        }else{
            viewModel?.removeFavourite(by: id)
        }
    }
}


    
    




