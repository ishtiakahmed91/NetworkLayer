//
//  ManagerProvider.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 02.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

/// Use this provider class to access the core fetures via the shared instance.
protocol ManagerProviding {
    
    /// The only singleton used by the scenes. This instance holds references to the managers.
    static var sharedInstance: ManagerProviding {get}
    
    /// Instance to access MovieManagement
    var movieManager: MovieManagement! { get }
    
    /// Instance to access TVShowManagement
    var tvShowManager: TVShowManagement! { get }
    
    /// Instance of environment
    var networkEnvironment : NetworkEnvironment {get}
    
    /// Clears and recreates manager instances in the manager provider.
    func updateManagers()
}


class ManagerProvider: ManagerProviding {
    static var sharedInstance: ManagerProviding = ManagerProvider()
    var movieManager: MovieManagement!
    var tvShowManager: TVShowManagement!
    var networkEnvironment : NetworkEnvironment = .production
    
    public func updateManagers() {
        movieManager = MovieManager(networkController: NetworkController())
        tvShowManager = TVShowManager(networkController: NetworkController())
        networkEnvironment = .production
    }
    
    init() {
        updateManagers()
    }
}
