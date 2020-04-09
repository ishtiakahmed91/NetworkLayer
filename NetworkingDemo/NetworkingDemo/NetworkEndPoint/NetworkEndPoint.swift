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

// MARK: - Task
enum Task {
    case request
    case parameterizedRequest(urlParameters: Parameters?, bodyParameters: Parameters?)
    case download
    case upload
}

// MARK: - NetworkEndPoint Implementation
protocol NetworkEndPoint {
    var baseURLString: String { get }
    var path: String { get }
    var restMethod: RESTMethod { get }
    var task: Task { get }
    var headers: Headers? { get }
}

// MARK: - Default NetworkEndPoint Implementation
extension NetworkEndPoint {
    /// Default base URL - update base URL when needed
    var baseURLString: String {
        switch ManagerProvider.sharedInstance.networkEnvironment {
        case .qa:
            return Constants.EndPoint.BaseURL.qa
        case .production:
            return Constants.EndPoint.BaseURL.production
        }
    }

    /// Default headers is nil - update header when needed
    var headers: Headers? {
        return nil
    }
}
