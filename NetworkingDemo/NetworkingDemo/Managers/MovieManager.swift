//
//  MovieManager.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 02.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

typealias MovieListCompletionBlock = (Result<MovieList, NetworkError>) -> Void

protocol MovieManagement {
    func movieList(completionBlock: @escaping MovieListCompletionBlock)
}

final class MovieManager: MovieManagement {

    let networkController: NetworkControlling

    init(networkController: NetworkControlling) {
        self.networkController = networkController
    }

    func movieList(completionBlock: @escaping MovieListCompletionBlock) {
        networkController.networkRequest(for: MovieNetworkEndPoint.topRatedMovies, responseType: MovieList.self) { result in
            switch result {
            case .success(let data):
                let movieList = data as? MovieList
                print(movieList?.movies?[0].overview)
            case .failure(let networkError):
                completionBlock(.failure(networkError))
            }
        }
    }
}