//
//  HomeViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import UIKit
import Combine
import CloudKit




class HomeViewController: UIViewController , MovieViewControllerProtocol {
    
    var viewModel: MovieViewModelType?
    private var subscribers = Set<AnyCancellable>()
    
    
    // ---------------- Segment Control --------------------
    private lazy var  segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Movieslist", "Favorites"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    @objc func handleSegmentChange(_ sender: Any){
        showSegments()
        
    }
    func showSegments(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel?.showAllMovies()
            self.movieListView.reloadData()
            break
        case 1:
            viewModel?.showFavouriteMovies()
            self.movieListView.reloadData()
            break
        default:
            break
        }
    }
    
    
    // ---------------- Search Bar --------------------
    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    
    
    // ---------------- Refresh Control --------------------
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero , primaryAction: refreshAction)
        return refresh
    }()
    
    private lazy var refreshAction: UIAction = UIAction { [weak self] _ in
        self?.refreshData()
    }
    
    private func refreshData() {
        print("refreshData")
        viewModel?.getMovies()
    }
    
    
    
    // ---------------- UI Elements --------------------
    
    lazy var usernameView : UILabel = {
        let usernameView = UILabel()
        usernameView.text = "Hello \((UserDefaults.standard.string(forKey: Constants.username)!))"
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        
        return usernameView
    }()
    
    private lazy var movieListView : UITableView = {
        let movieListView = UITableView()
        movieListView.dataSource = self
        movieListView.delegate = self
        movieListView.register(MovieListItemCell.self, forCellReuseIdentifier: MovieListItemCell.identifier)
        movieListView.addSubview(refreshControl)
        movieListView.translatesAutoresizingMaskIntoConstraints = false
        return movieListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        
        setupContollers()
    }
    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.usernameView.text = "Hello \((UserDefaults.standard.string(forKey: Constants.username)!))"
        
//        showSegments()
    }
    
    
    
    
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.titleView = usernameView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(addTapped))
        
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        view.addSubview(movieListView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        movieListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        
        segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        
        searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        
        movieListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        movieListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        movieListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    @objc func addTapped(){
        let editViewController = EditUsernameViewController()
        
        
        editViewController.modalPresentationStyle = .fullScreen
        self.present(editViewController, animated: true, completion:  nil)
    }
    
    func setupViewModel(){
        
        let networkManager = MainNetworkManager()
        self.viewModel = MovieViewModel(networkManager: networkManager)
    }
    
    
    func setupContollers() {
        viewModel?
            .publisherMovies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.movieListView.reloadData()
                self?.showSegments()
            })
            .store(in: &subscribers)
        
        
        // get image data
        viewModel?
            .publisherImages
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.movieListView.reloadData()
            })
            .store(in: &subscribers)
        
        // get Movies from API
        viewModel?.getMovies()
    }
    
    
    
}

extension HomeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel!.search(by: searchText, onlyFavourites: segmentedControl.selectedSegmentIndex == 1)
        movieListView.reloadData()
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalMovies() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: Int = indexPath.row
        
        if let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieListItemCell.identifier, for: indexPath) as? MovieListItemCell {
            var movie = MovieItem(row: row)
            
            if  let viewModel  =  self.viewModel{
                if let movieData:Movie = viewModel.getMovie(by: row){
                    movie.title = movieData.title
                    movie.overview = movieData.overview
                    if let imageData : Data = viewModel.getImageData(by: movieData.id!) {
                        movie.imageData = imageData
                    }
                    movie.isFavourite = viewModel.isFavourite(by: movieData.id!)
                }
                
                movieCell.configure(by: movie )
                return movieCell
            } else {
                return MovieListItemCell()
            }
        }
        
        return UITableViewCell()
        
        
    }
    
    func showMovieDetails(by row: Int){
        let details = MovieDetailsViewController()
        details.configure(row: row)
        details.setupViewModel(viewModel: viewModel!)
//        details.modalPresentationStyle = .fullScreen
       
    
        self.present(details, animated: true)
//        navigationController?.pushViewController(details, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        showMovieDetails(by: indexPath.row)
        return indexPath
    }
    
}
