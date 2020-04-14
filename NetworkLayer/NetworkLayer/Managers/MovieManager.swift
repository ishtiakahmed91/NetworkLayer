//
//  MovieManager.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 02.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

typealias MovieListCompletionBlock = (Result<MovieList, NetworkError>) -> Void

protocol MovieManagement {
    func topRatedMovies(completionBlock: @escaping MovieListCompletionBlock)
}

final class MovieManager: MovieManagement {

    let networkController: NetworkControlling

    init(networkController: NetworkControlling) {
        self.networkController = networkController
    }

    func topRatedMovies(completionBlock: @escaping MovieListCompletionBlock) {
        networkController.networkRequest(for: MovieNetworkEndPoint.topRated, responseType: MovieList.self) { result in
            switch result {
            case .success(let data):
                guard let movieList = data as? MovieList else {
                    completionBlock(.failure(.encodingFailed))
                    return
                }
                completionBlock(.success(movieList))
            case .failure(let networkError):
                completionBlock(.failure(networkError))
            }
        }
    }
}
