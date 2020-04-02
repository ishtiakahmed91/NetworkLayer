//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetchData(_ sender: Any) {
        NetworkManager.sharedInstance.networkRequest(for: MovieNetworkEndPoint.topRatedMovies, type: MovieNetworkEndPoint.responseType.self, completionBlock: { result in
            switch result {
            case .success(let resultValue):
                print("\(String(describing: resultValue))")
            case .failure(let networkError):
                print(networkError.description)
            }
        })
    }
}
