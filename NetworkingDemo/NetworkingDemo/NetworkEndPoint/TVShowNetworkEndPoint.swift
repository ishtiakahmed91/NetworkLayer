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
    case credits(tvId: String)
    case addRating(tvId: String)
    case deleteRating(tvId: String, value: Float)
}

extension TVShowNetworkEndPoint: NetworkEndPoint {
    var path: String {
        switch self {
        case .latestTVShows:
            return Constants.EndPoint.TVShow.Path.latest
        case .credits(let tvId):
            return Constants.EndPoint.TVShow.SemiPath.tv
                .appendPath(tvId)
                .appendPath(Constants.EndPoint.TVShow.SemiPath.credits)
        case .addRating(let tvId), .deleteRating(let tvId, _):
            return Constants.EndPoint.TVShow.SemiPath.tv
            .appendPath(tvId)
            .appendPath(Constants.EndPoint.TVShow.SemiPath.rating)
        }
    }

    var restMethod: RESTMethod {
        switch self {
        case .latestTVShows, .credits:
            return .get
        case .addRating:
            return .post
        case .deleteRating:
            return .delete
        }
    }

    var urlParameters: Parameters? {
        return [Constants.EndPoint.Movie.URLParameter.apiKey: Constants.EndPoint.Movie.URLParameter.apiKeyValue]
    }

    var bodyParameters: Parameters? {
        switch self {
        case .latestTVShows, .credits, .addRating:
            return nil
        case .deleteRating(_, let value):
            return [Constants.EndPoint.TVShow.BodyParameter.valueKey: value]
        }
    }

    var headers: Headers? {
        return nil
    }
}
