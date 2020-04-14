//
//  CastList.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

struct CastList: Codable {
    let cast: [Cast]?
}

struct Cast: Codable {
    let id: Int?
    let character: String?
    let name: String?
}
