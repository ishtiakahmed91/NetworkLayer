//
//  MovieNetworkEndPoint.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 01.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

enum MovieNetworkEndPoint {
    case latestMovies
    case nowPlayingMovies
    case popularMovies
    case topRatedMovies
    case upcomingMovies

// TODO
// static var responseType = MovieList.self
    var responseTypee: Codable.Type {
         switch self {
         case .latestMovies:
            return Movie.self
         case .nowPlayingMovies:
             return MovieList.self
         case .popularMovies:
             return MovieByPage.self
         case .topRatedMovies:
             return MovieByPage.self
         case .upcomingMovies:
             return MovieList.self
         }
     }
}

extension MovieNetworkEndPoint: NetworkEndPoint {
    var path: String {
          switch self {
          case .latestMovies:
              return Constants.EndPoint.Movie.Path.latest
          case .nowPlayingMovies:
              return Constants.EndPoint.Movie.Path.nowPlaying
          case .popularMovies:
              return Constants.EndPoint.Movie.Path.popular
          case .topRatedMovies:
              return Constants.EndPoint.Movie.Path.topRated
          case .upcomingMovies:
              return Constants.EndPoint.Movie.Path.upcoming
          }
      }

    var restMethod: RESTMethod {
        return .get
    }

    var urlParameters: Parameters? {
        return [Constants.EndPoint.Movie.URLParameter.apiKey: Constants.EndPoint.Movie.URLParameter.apiKeyValue]
    }

    var bodyParameters: Parameters? {
        return nil
    }

    var headers: Headers? {
        return nil
    }
}
