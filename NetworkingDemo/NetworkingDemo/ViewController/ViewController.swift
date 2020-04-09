//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetchData(_ sender: Any) {
        ManagerProvider.sharedInstance.movieManager.topRatedMovies { result in
            switch result {
            case .success(let resultValue):
                print("\(String(describing: resultValue))")
            case .failure(let networkError):
                print(networkError.description)
            }
        }

        ManagerProvider.sharedInstance.tvShowManager.credits(tvId: "1", completionBlock: { result in
            switch result {
            case .success(let resultValue):
                print("\(String(describing: resultValue))")
            case .failure(let networkError):
                print(networkError.description)
            }
        })

        ManagerProvider.sharedInstance.downloadManager.download(.start, path: "8ZX18L5m6rH5viSYpRnTSbb9eXh.jpg") { result in
            switch result {
            case .success(let sourceURL):
                DispatchQueue.main.async {
                    if let sourceURL = sourceURL, let imageData = NSData(contentsOf: sourceURL) {
                        let image = UIImage(data: imageData as Data)
                        self.imageView.image = image
                    }
                }
            case .failure(let networkError):
                print(networkError)
            }
        }
    }
}
