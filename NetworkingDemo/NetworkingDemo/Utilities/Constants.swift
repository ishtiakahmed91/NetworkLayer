//
//  Constants.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

struct Constants {

    struct API {
        static let timeoutInterval = 60.0

        struct ContentType {
            static let key = "Content-Type"
            static let applicationJson = "application/json"
            static let applicationURLEncoded = "application/x-www-form-urlencoded; charset=utf-8"
        }

        struct BaseURL {
            static let qa = "https://qa.themoviedb.org/3"
            static let production = "https://api.themoviedb.org/3"
        }
        
        struct MovieAPIEndPoint {
            struct Path {
                static let latest = "movie/latest"
                static let nowPlaying = "movie/now_playing"
                static let popular = "movie/popular"
                static let topRated = "movie/top_rated"
                static let upcoming = "movie/upcoming"
            }

            struct URLParameter {
                static let apiKey = "api_key"
                static let apiKeyValue = "112bcb0d3b48ac2f6969a308a96f1dcb"
            }
        }
    }
}
