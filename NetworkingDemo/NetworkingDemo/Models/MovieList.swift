//
//  MovieList.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

struct MovieList: Codable {
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
