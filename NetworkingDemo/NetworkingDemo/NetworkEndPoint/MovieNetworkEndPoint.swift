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
//    static var responseType = MovieList.self

//    func responseTypee() -> Codable {
//         switch self {
//         case .latestMovies:
//            return Movie.self
//         case .nowPlayingMovies:
//             return MovieList.self
//         case .popularMovies:
//             return MovieByPage.self
//         case .topRatedMovies:
//             return MovieByPage.self
//         case .upcomingMovies:
//             return MovieList.self
//         }
//     }

}

extension MovieNetworkEndPoint: NetworkEndPoint {
    var path: String {
          switch self {
          case .latestMovies:
              return Constants.API.MovieAPIEndPoint.Path.latest
          case .nowPlayingMovies:
              return Constants.API.MovieAPIEndPoint.Path.nowPlaying
          case .popularMovies:
              return Constants.API.MovieAPIEndPoint.Path.popular
          case .topRatedMovies:
              return Constants.API.MovieAPIEndPoint.Path.topRated
          case .upcomingMovies:
              return Constants.API.MovieAPIEndPoint.Path.upcoming
          }
      }

    var restMethod: RESTMethod {
        return .get
    }

    var bodyParameters: Parameters? {
        return nil
    }

    var headers: Headers? {
        return nil
    }

    var urlParameters: Parameters? {
        return [Constants.API.MovieAPIEndPoint.URLParameter.apiKey: Constants.API.MovieAPIEndPoint.URLParameter.apiKeyValue]
    }

}
