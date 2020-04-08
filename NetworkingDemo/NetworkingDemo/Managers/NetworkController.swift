//
//  NetworkController.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 02.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

typealias URLRequestResult = Result<URLRequest, NetworkError>
typealias DataCompletionBlock = (Result<Decodable, NetworkError>) -> Void

protocol NetworkControlling {
    func networkRequest<T>(for networkEndPoint: NetworkEndPoint, responseType: T.Type, completionBlock: @escaping DataCompletionBlock) where T: Decodable
    func download()
    func upload()
}

class NetworkController: NetworkControlling {

    func networkRequest<T>(for networkEndPoint: NetworkEndPoint, responseType: T.Type, completionBlock: @escaping DataCompletionBlock) where T: Decodable {
        guard Reachability().isReachable else {
            completionBlock(.failure(.internetNotReachable))
            return
        }

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.EndPoint.timeoutInterval

        let session = URLSession(configuration: configuration)
        var urlRequest: URLRequest?
        switch generateRequest(using: networkEndPoint) {
        case .success(let urlRequestValue):
            urlRequest = urlRequestValue
        case .failure(let networkError):
            completionBlock(.failure(networkError))
        }

        guard let request = urlRequest else {
            completionBlock(.failure(.requestMissing))
            return
        }

        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse,
                let networkError = self?.networkError(response),
                error != nil {
                completionBlock(.failure(networkError))
            }

            guard let data = data else {
                completionBlock(.failure(.dataMissing))
                return
            }

            do {
                let result = try JSONDecoder().decode(responseType.self, from: data as Data)
                completionBlock(.success(result))
            } catch {
                completionBlock(.failure(.jsonSerializationFailed))
            }
        }
        
        dataTask.resume()
    }

    func download() {}
    func upload() {}
}

// MARK: - Private

private extension NetworkController {
    func generateRequest(using networkEndPoint: NetworkEndPoint) -> URLRequestResult {
        guard let baseURL = URL(string: networkEndPoint.baseURLString) else {
            return .failure(.urlMissing)
        }

        let url = baseURL.appendingPathComponent(networkEndPoint.path)
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: Constants.EndPoint.timeoutInterval)
        urlRequest.httpMethod = networkEndPoint.restMethod.rawValue

        appendHeaders(networkEndPoint.headers, in: &urlRequest)
        appendURLParameters(networkEndPoint.urlParameters, in: &urlRequest)
        appendBodyParameters(networkEndPoint.bodyParameters, in: &urlRequest)

        return .success(urlRequest)
    }

    func networkError(_ response: HTTPURLResponse) -> NetworkError? {
        switch response.statusCode {
        case 200...299: return nil
        case 300...400: return .redirection
        case 401...500: return .client
        case 501...599: return .server
        default: return .unrecognized
        }
    }

    func appendHeaders(_ headers: Headers?, in urlRequest: inout URLRequest) {
        if let headers = headers, !headers.isEmpty {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
    }

    func appendURLParameters(_ urlParameters: Parameters?, in urlRequest: inout URLRequest) {
        if let url = urlRequest.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let urlParameters = urlParameters,
            !urlParameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in urlParameters {
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let urlQueryItem = URLQueryItem(name: key, value: encodedValue)
                urlComponents.queryItems?.append(urlQueryItem)
            }

            urlRequest.url = urlComponents.url

            if urlRequest.value(forHTTPHeaderField: Constants.EndPoint.ContentType.key) == nil {
                urlRequest.setValue(Constants.EndPoint.ContentType.applicationURLEncoded, forHTTPHeaderField: Constants.EndPoint.ContentType.key)
            }
        }
    }

    func appendBodyParameters(_ bodyParameters: Parameters?, in urlRequest: inout URLRequest) {
        if let bodyParameters = bodyParameters,
            !bodyParameters.isEmpty,
            let httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted) {
            urlRequest.httpBody = httpBody

            if urlRequest.value(forHTTPHeaderField: Constants.EndPoint.ContentType.key) == nil {
                urlRequest.setValue(Constants.EndPoint.ContentType.applicationJson, forHTTPHeaderField: Constants.EndPoint.ContentType.key)
            }
        }
    }
}
