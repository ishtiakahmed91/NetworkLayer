//
//  MovieNetworkEndPoint.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 01.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

enum MovieNetworkEndPoint {
    case latest
    case nowPlaying
    case popular
    case topRated
    case upcoming
}

extension MovieNetworkEndPoint: NetworkEndPoint {
    var path: String {
        switch self {
        case .latest:
            return Constants.EndPoint.Movie.Path.latest
        case .nowPlaying:
            return Constants.EndPoint.Movie.Path.nowPlaying
        case .popular:
            return Constants.EndPoint.Movie.Path.popular
        case .topRated:
            return Constants.EndPoint.Movie.Path.topRated
        case .upcoming:
            return Constants.EndPoint.Movie.Path.upcoming
        }
    }

    var restMethod: RESTMethod {
        return .get
    }

    var task: Task {
        return .parameterizedRequest(urlParameters: [Constants.EndPoint.Movie.URLParameter.apiKey: Constants.EndPoint.Movie.URLParameter.apiKeyValue],
                                     bodyParameters: nil)
    }
}
