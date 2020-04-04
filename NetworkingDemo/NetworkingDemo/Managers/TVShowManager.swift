//
//  TVShowManager.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

typealias TVShowsCompletionBlock = (Result<CastList, NetworkError>) -> Void

protocol TVShowManagement {
    func tvShowCredits(tvId: String, completionBlock: @escaping TVShowsCompletionBlock)
}

final class TVShowManager: TVShowManagement {

    let networkController: NetworkControlling

    init(networkController: NetworkControlling) {
        self.networkController = networkController
    }

    func tvShowCredits(tvId: String, completionBlock: @escaping TVShowsCompletionBlock) {
        networkController.networkRequest(for: TVShowNetworkEndPoint.credits(tvId: tvId), responseType: CastList.self) { result in
            switch result {
            case .success(let data):
                guard let castList = data as? CastList else {
                    completionBlock(.failure(.encodingFailed))
                    return
                }
                completionBlock(.success(castList))
            case .failure(let networkError):
                completionBlock(.failure(networkError))
            }
        }
    }
}
