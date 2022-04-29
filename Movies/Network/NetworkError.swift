//
//  NetworkError.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation


enum NetworkError: Error {
    case badURL
    case decodeError(Error)
    case other(Error)
}
