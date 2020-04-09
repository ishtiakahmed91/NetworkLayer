//
//  NetworkError.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

enum NetworkError: Error {
    case timeout
    case internetNotReachable
    case client
    case redirection
    case server
    case jsonSerializationFailed
    case encodingFailed
    case requestMissing
    case urlMissing
    case dataMissing
    case unrecognized
    
    var description: String {
        switch self {
        case .timeout:
            return "Request timeout. Please try again."
        case .internetNotReachable:
            return "Internet is not reachable."
        case .client:
            return "Client error"
        case .redirection:
            return "Redirection error"
        case .server:
            return "Server error"
        case .jsonSerializationFailed:
            return "JSON serialization failed"
        case .encodingFailed:
            return "Encoding failed."
        case .requestMissing:
            return "Request missing"
        case .urlMissing:
            return "URL missing"
        case .dataMissing:
            return "Data missing"
        case .unrecognized:
            return "Unrecognized error"
        }
    }
}
