//
//  NetworkEndPoint.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

public typealias Headers = [String: String]
public typealias Parameters = [String: Any]

enum NetworkEnvironment {
    case qa
    case production
}

public enum RESTMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


// MARK: - NetworkEndPoint Implementation
public protocol NetworkEndPoint {
    var baseURLString: String { get }
    var path: String { get }
    var restMethod: RESTMethod { get }
    var urlParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var headers: Headers? { get }
}

// MARK: - Default NetworkEndPoint Implementation
extension NetworkEndPoint {
    var baseURLString: String {
        switch NetworkManager.networkEnvironment {
        case .qa:
            return Constants.API.BaseURL.qa
        case .production:
            return Constants.API.BaseURL.production
        }
    }
}
