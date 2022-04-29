//
//  HomeViewControllerViewModel.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation
import Combine

protocol MovieViewModelType : AnyObject {
    var publisherMovies: Published<[Movie]>.Publisher { get }
    var publisherImages: Published<[Int: Data]>.Publisher { get }
    var publisherFavourites: Published<[Int]>.Publisher { get }
    
    func getMovies()
    func totalMovies() -> Int
    func getMovie(by row: Int) -> Movie?
    func getImageData(by id: Int) -> Data?
    func search(by searchText: String, onlyFavourites: Bool) -> Void
    func makeFavourite(by id: Int) -> Void
    func removeFavourite(by id: Int) -> Void
    func isFavourite(by id: Int) -> Bool
    func showAllMovies() -> Void
    func showFavouriteMovies() -> Void
    func clearFavourites() -> Void
}


class MovieViewModel : MovieViewModelType {
    var networkManager : NetworkManager
    private var subscribers = Set<AnyCancellable>()
    
    var publisherMovies: Published<[Movie]>.Publisher { $movies }
    var publisherImages: Published<[Int: Data]>.Publisher { $images }
    var publisherFavourites: Published<[Int]>.Publisher { $favourites }
    
    
    @Published private(set) var movies  = [Movie]()
    @Published private(set) var filteredMovies  = [Movie]()
    @Published private(set) var images  = [Int: Data]()
    @Published private(set) var favourites  = [Int]()
    
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getMovies() {
        movies = []
        getMovies(from: NetworkURLs.movieDataUrl)
    }
    
    func search(by searchText: String, onlyFavourites: Bool) -> Void {
        if(!searchText.isEmpty){
            filteredMovies = movies.filter({ (movie: Movie) -> Bool in
                let match = movie.title?.range(of: searchText, options: .caseInsensitive)
                // Return the tuple if the range contains a match.
                return match != nil && (!onlyFavourites || favourites.contains(movie.id!))
            })
        } else {
            filteredMovies = movies.filter({ (movie: Movie) -> Bool in
                // Return the tuple if the range contains a match.
                return !onlyFavourites || favourites.contains(movie.id!)
            })
        }
    }
    
    func getMovies(from url: String) {
        networkManager
            .getModel(MovieReseponse.self, from: url)
            .sink { completion in
            } receiveValue: { [weak self] response in
                let temp = response.results
                for (movie) in temp {
                    if(movie.posterPath != nil) {
                        self?.movies.append(movie)
                        self?.downloadImage(of: movie.posterPath!, at: movie.id!)
                    }
                }
                self?.filteredMovies = self?.movies ?? []
            }
            .store(in: &subscribers)
    }
    
    private func downloadImage(of path:String, at: Int) {
        let group = DispatchGroup()
        let url: String? = NetworkURLs.imageBaseUrl + path
        print(url!)
        if let image = url {
            group.enter()
            networkManager.getData(from: image) { data in
                if let data = data {
                    self.images.updateValue(data, forKey: at)
                }
                group.leave()
            }
        }
    }
    
    func totalMovies() -> Int {
        return filteredMovies.count
    }
    
    func getMovie(by row: Int) -> Movie? {
        return filteredMovies[row]
    }
    
    func getImageData(by id: Int) -> Data? {
        return images[id]
    }
    
    func makeFavourite(by id: Int) -> Void {
        favourites.append(id)
    }
    
    func removeFavourite(by id: Int) -> Void {
        favourites = favourites.filter { $0 != id }
    }
    
    func isFavourite(by id: Int) -> Bool {
        return favourites.contains(id)
    }
    
    func showAllMovies() -> Void {
        filteredMovies = movies
    }
    
    func showFavouriteMovies() -> Void {
        filteredMovies = movies.filter { favourites.contains($0.id!) }
    }
    
    func clearFavourites() {
        favourites = []
    }
}
