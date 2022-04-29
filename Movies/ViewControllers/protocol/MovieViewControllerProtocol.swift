//
//  MovieVCProtocol.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation

protocol MovieViewControllerProtocol: AnyObject {
    var viewModel: MovieViewModelType? {get set}
}
