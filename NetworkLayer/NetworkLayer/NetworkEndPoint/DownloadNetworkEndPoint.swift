//
//  DownloadNetworkEndPoint.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 09.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

struct DownloadNetworkEndPoint: NetworkEndPoint {
    var baseURLString = Constants.EndPoint.BaseURL.imageDownload
    var path: String
    var restMethod: RESTMethod = .get
    var task: Task = .download
}
