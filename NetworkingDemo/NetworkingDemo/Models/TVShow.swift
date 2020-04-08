//
//  TVShow.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

struct TVShow: Codable {
    let id: Int?
    let firstAirDate: String?
    let lastAirDate: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case name
    }
}
