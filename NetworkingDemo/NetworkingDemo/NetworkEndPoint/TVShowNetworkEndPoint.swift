//
//  TVShowNetworkEndPoint.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

enum TVShowNetworkEndPoint {
    case latestTVShows
    case popularTVShows
    case reviews(tvId: String)
    case credits(tvId: String)
    case addRating(tvId: String)
    case deleteRating(tvId: String)
}

extension TVShowNetworkEndPoint: NetworkEndPoint {
    var path: String {
        switch self {
        case .latestTVShows:
            return Constants.API.TVShowNetworkEndPoint.Path.latest
        case .popularTVShows:
            return Constants.API.TVShowNetworkEndPoint.Path.popular
        case .credits(let tvId):
            return Constants.API.TVShowNetworkEndPoint.SemiPath.tv
                .appendPath(tvId)
                .appendPath(Constants.API.TVShowNetworkEndPoint.SemiPath.credits)
        case .reviews(let tvId):
            return Constants.API.TVShowNetworkEndPoint.SemiPath.tv
            .appendPath(tvId)
            .appendPath(Constants.API.TVShowNetworkEndPoint.SemiPath.reviews)
        case .addRating(let tvId), .deleteRating(let tvId):
            return Constants.API.TVShowNetworkEndPoint.SemiPath.tv
            .appendPath(tvId)
            .appendPath(Constants.API.TVShowNetworkEndPoint.SemiPath.rating)
        }
    }

    var restMethod: RESTMethod {
        switch self {
        case .latestTVShows, .popularTVShows, .credits, .reviews:
            return .get
        case .addRating:
            return .post
        case .deleteRating:
            return .delete
        }
    }

    var urlParameters: Parameters? {
        return [Constants.API.MovieNetworkEndPoint.URLParameter.apiKey: Constants.API.MovieNetworkEndPoint.URLParameter.apiKeyValue]
    }

    var bodyParameters: Parameters? {
        return nil
    }

    var headers: Headers? {
        return nil
    }
}
