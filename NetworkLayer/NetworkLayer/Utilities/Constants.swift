//
//  Constants.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

struct Constants {
    
    struct EndPoint {
        static let timeoutInterval = 60.0
        static let timeoutIntervalForResource = 120.0

        struct ContentType {
            static let key = "Content-Type"
            static let applicationJson = "application/json"
            static let applicationURLEncoded = "application/x-www-form-urlencoded; charset=utf-8"
        }
        
        struct BaseURL {
            static let qa = "https://qa.themoviedb.org/3"
            static let production = "https://api.themoviedb.org/3"
            static let imageDownload = "https://image.tmdb.org/t/p/w500"
        }
        
        struct Movie {
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
        
        struct TVShow {
            struct Path {
                static let latest = "tv/latest"
            }
            
            struct SemiPath {
                static let tv = "tv"
                static let credits = "credits"
                static let rating = "rating"
            }
            
            struct URLParameter {
                static let apiKey = "api_key"
                static let apiKeyValue = "112bcb0d3b48ac2f6969a308a96f1dcb"
            }
            
            struct BodyParameter {
                static let valueKey = "value"
            }
        }
    }
}
