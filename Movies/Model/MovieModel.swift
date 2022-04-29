//
//  MovieModel.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation

struct MovieReseponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let overview: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
    }
    
}

struct MovieDetail: Codable {
    let id:Int
    let productionCompanies:[ProductionCompany]
    
    enum CodingKeys:String, CodingKey{
        case id
        case productionCompanies = "production_companies"
    }
}



struct ProductionCompany:Codable{
    let id:Int
    let logoPath:String?
    let name:String
    let country:String
    
    enum CodingKeys:String, CodingKey{
        case id
        case logoPath = "logo_path"
        case name
        case country = "origin_country"
    }
}




