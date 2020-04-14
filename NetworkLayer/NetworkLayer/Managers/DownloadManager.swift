//
//  DownloadManager.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 09.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

enum DownloadAction {
    case start
    case resume
    case cancel
    case pause
}

protocol DownloadManagement {
    func download(_ action: DownloadAction, path: String, completionBlock: @escaping URLCompletionBlock)
}

final class DownloadManager: DownloadManagement {
    let networkController: NetworkControlling

    init(networkController: NetworkControlling) {
        self.networkController = networkController
    }

    func download(_ action: DownloadAction, path: String, completionBlock: @escaping URLCompletionBlock) {
        let downloadNetworkEndPoint = DownloadNetworkEndPoint(path: path)
        networkController.download(.start, for: downloadNetworkEndPoint, completionBlock: completionBlock)
    }
}
