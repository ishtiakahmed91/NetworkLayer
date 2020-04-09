//
//  Download.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 08.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

// MARK: - DownloadState

enum DownloadState {
    case notStarted
    case started
    case paused
    case cancelled
    case finished
}

// MARK: - Download

class Download {
    var downloadState: DownloadState = .notStarted
    var progress: Float = 0
    var resumeData: Data?
    var urlSessionDownloadTask: URLSessionDownloadTask?
    var sourceURL: URL?
    var previewURL: URL?

    init(sourceURL: URL){
        self.sourceURL = sourceURL
    }
}
