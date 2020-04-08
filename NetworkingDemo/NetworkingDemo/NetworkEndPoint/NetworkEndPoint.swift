//
//  NetworkEndPoint.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

// MARK: - Headers & Parameters
public typealias Headers = [String: String]
public typealias Parameters = [String: Any]

// MARK: - NetworkEnvironment
enum NetworkEnvironment {
    case qa
    case production
}

// MARK: - RESTMethod
enum RESTMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - NetworkEndPoint Implementation
protocol NetworkEndPoint {
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
        switch ManagerProvider.sharedInstance.networkEnvironment {
        case .qa:
            return Constants.EndPoint.BaseURL.qa
        case .production:
            return Constants.EndPoint.BaseURL.production
        }
    }
}
