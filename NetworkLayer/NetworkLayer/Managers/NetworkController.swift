//
//  NetworkController.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 02.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

typealias URLRequestResult = Result<URLRequest, NetworkError>
typealias DataCompletionBlock = (Result<Decodable, NetworkError>) -> Void
typealias URLCompletionBlock = (Result<URL?, NetworkError>) -> Void

protocol NetworkControlling {
    func networkRequest<T>(for networkEndPoint: NetworkEndPoint,
                           responseType: T.Type,
                           completionBlock: @escaping DataCompletionBlock) where T: Decodable
    func cancelNetworkRequest()
    func download(_ action: DownloadAction,for networkEndPoint: NetworkEndPoint, completionBlock: @escaping URLCompletionBlock)
    func upload()
}

class NetworkController: NetworkControlling {

    private var dataTask: URLSessionTask?
    private var activeDownloads: [URL: Download] = [:]

    lazy private var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.EndPoint.timeoutIntervalForResource
        return URLSession(configuration: configuration)
    }()

    func networkRequest<T>(for networkEndPoint: NetworkEndPoint,
                           responseType: T.Type,
                           completionBlock: @escaping DataCompletionBlock) where T: Decodable {
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

        dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
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
        
        dataTask?.resume()
    }

    func cancelNetworkRequest() {
        if let dataTask = dataTask {
            dataTask.cancel()
        }
    }

    func download(_ action: DownloadAction,for networkEndPoint: NetworkEndPoint, completionBlock: @escaping URLCompletionBlock) {
        var urlRequest: URLRequest? {
            switch generateRequest(using: networkEndPoint) {
            case .success(let urlRequestValue):
                return urlRequestValue
            case .failure(let networkError):
                completionBlock(.failure(networkError))
                return nil
            }
        }
        
        guard let sourceURL = urlRequest?.url else {
            completionBlock(.failure(.urlMissing))
            return
        }

        switch action {
        case .start:
            startDownload(sourceURL, completionBlock: completionBlock)
        case .resume:
            resumeDownload(sourceURL, completionBlock: completionBlock)
        case .cancel:
            cancelDownload(sourceURL)
        case .pause:
            pauseDownload(sourceURL)
        }
    }

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

        switch networkEndPoint.task {
        case .parameterizedRequest(urlParameters: let urlParameters, bodyParameters: let bodyParameters):
            appendURLParameters(urlParameters, in: &urlRequest)
            appendBodyParameters(bodyParameters, in: &urlRequest)
        default:
            urlRequest.setValue(Constants.EndPoint.ContentType.applicationJson, forHTTPHeaderField: Constants.EndPoint.ContentType.key)
        }
        
        appendHeaders(networkEndPoint.headers, in: &urlRequest)
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

private extension NetworkController {
    func localFileGeneration(sourceURL: URL,
                             temporaryURL: URL?,
                             response: URLResponse?,
                             error: Error?,
                             completionBlock: @escaping URLCompletionBlock) {

        guard let temporaryURL = temporaryURL else { return }

        let download = self.activeDownloads[sourceURL]
        self.activeDownloads[sourceURL] = nil
        let previewURL = self.localFilePath(for: sourceURL)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: previewURL)

        do {
            try fileManager.copyItem(at: temporaryURL, to: previewURL)
            download?.previewURL = previewURL
            download?.downloadState = .finished
            self.activeDownloads[sourceURL] = nil
            completionBlock(.success(previewURL))
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
            //TODO
        }
    }

    func startDownload(_ sourceURL: URL, completionBlock: @escaping URLCompletionBlock) {
        let download = Download(sourceURL: sourceURL)
        download.urlSessionDownloadTask = downloadSession.downloadTask(with: sourceURL, completionHandler: {(temporaryURL, response, error) in
            self.localFileGeneration(sourceURL: sourceURL, temporaryURL: temporaryURL, response: response, error: error, completionBlock: completionBlock)
        })

        download.urlSessionDownloadTask?.resume()
        download.downloadState = .started
        activeDownloads[sourceURL] = download
    }

    func cancelDownload(_ sourceURL: URL) {
        guard let download = activeDownloads[sourceURL] else { return }
        download.urlSessionDownloadTask?.cancel()
        activeDownloads[sourceURL] = nil
    }

    func pauseDownload(_ sourceURL: URL) {
        guard let download = activeDownloads[sourceURL], download.downloadState == .started else { return }
        download.urlSessionDownloadTask?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        download.downloadState = .paused
    }

    func resumeDownload(_ sourceURL: URL, completionBlock: @escaping URLCompletionBlock) {
        guard let download = activeDownloads[sourceURL] else { return }
        if let resumeData = download.resumeData {
            download.urlSessionDownloadTask = downloadSession.downloadTask(withResumeData: resumeData, completionHandler: {(temporaryURL, response, error) in
                self.localFileGeneration(sourceURL: sourceURL, temporaryURL: temporaryURL, response: response, error: error, completionBlock: completionBlock)
            })
        } else {
            download.urlSessionDownloadTask = downloadSession.downloadTask(with: sourceURL, completionHandler: {(temporaryURL, response, error) in
                self.localFileGeneration(sourceURL: sourceURL, temporaryURL: temporaryURL, response: response, error: error, completionBlock: completionBlock)
            })
        }

        download.urlSessionDownloadTask?.resume()
        download.downloadState = .started
    }

    func localFilePath(for url: URL) -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
}
