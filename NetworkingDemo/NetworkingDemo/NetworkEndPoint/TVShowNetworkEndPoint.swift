//
//  TVShowNetworkEndPoint.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

enum TVShowNetworkEndPoint {
    case latest
    case credits(tvId: String)
    case addRating(tvId: String)
    case deleteRating(tvId: String, value: Float)
}

extension TVShowNetworkEndPoint: NetworkEndPoint {
    var path: String {
        switch self {
        case .latest:
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
        case .latest, .credits:
            return .get
        case .addRating:
            return .post
        case .deleteRating:
            return .delete
        }
    }

    var task: Task {
        let urlParameters = [Constants.EndPoint.Movie.URLParameter.apiKey: Constants.EndPoint.Movie.URLParameter.apiKeyValue]
        switch self {
        case .latest, .credits, .addRating:
            return .parameterizedRequest(urlParameters: urlParameters, bodyParameters: nil)
        case .deleteRating(_, let value):
            return .parameterizedRequest(urlParameters: urlParameters,
                                         bodyParameters: [Constants.EndPoint.TVShow.BodyParameter.valueKey: value])
        }
      }
}
