//
//  MovieByPage.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

struct MoviePage: Codable {
    let page: Int?
    let totalMovies: Int?
    let totalPages: Int?
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalMovies = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

struct Movie: Codable {
    let id: Int?
    let title: String?
    let overview: String?
    let vote: Int?
    let posterPath: String?
    let backDropPath: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case vote = "vote_count"
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
}

