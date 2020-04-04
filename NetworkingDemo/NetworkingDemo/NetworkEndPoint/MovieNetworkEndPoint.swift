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
              return Constants.API.MovieNetworkEndPoint.Path.latest
          case .nowPlayingMovies:
              return Constants.API.MovieNetworkEndPoint.Path.nowPlaying
          case .popularMovies:
              return Constants.API.MovieNetworkEndPoint.Path.popular
          case .topRatedMovies:
              return Constants.API.MovieNetworkEndPoint.Path.topRated
          case .upcomingMovies:
              return Constants.API.MovieNetworkEndPoint.Path.upcoming
          }
      }

    var restMethod: RESTMethod {
        return .get
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
