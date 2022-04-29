//
//  MovieItem.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation


struct MovieItem: Codable {
    var row: Int
    var title : String?
    var overview : String?
    var imageData : Data?
    var isFavourite : Bool?
}
