//
//  NetworkError.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
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
            return "timeout"
        case .internetNotReachable:
            return "internetNotReachable"
        case .client:
            return "clientError"
        case .redirection:
            return "redirectionError"
        case .server:
            return "serverError"
        case .jsonSerializationFailed:
            return "jsonSerializationFailed"
        case .encodingFailed:
            return "encodingFailed"
        case .requestMissing:
            return "requestMissing"
        case .urlMissing:
            return "urlMissing"
        case .dataMissing:
            return "dataMissing"
        case .unrecognized:
            return "unrecognized"
        }
    }
}
