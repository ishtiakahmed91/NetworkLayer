//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Ishtiak Ahmed on 31.03.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetchTopRatedMovies(_ sender: Any) {
        ManagerProvider.sharedInstance.movieManager.topRatedMovies { result in
            switch result {
            case .success(let resultValue):
                print("\(String(describing: resultValue))")
                guard let movies = resultValue.movies else { return }

                let random = Int.random(in: 0 ..< movies.count)
                let movie = movies[random]
                
                self.downloadPoster(path: movie.posterPath!)
                DispatchQueue.main.async {
                    self.movieNameLabel.text = movie.title
                }

            case .failure(let networkError):
                print(networkError.description)
            }
        }
    }

    func downloadPoster(path: String) {
        //"8ZX18L5m6rH5viSYpRnTSbb9eXh.jpg"
        ManagerProvider.sharedInstance.downloadManager.download(.start, path: path) { result in
            switch result {
            case .success(let sourceURL):
                DispatchQueue.main.async {
                    if let sourceURL = sourceURL, let imageData = NSData(contentsOf: sourceURL) {
                        let image = UIImage(data: imageData as Data)
                        self.posterImageView.image = image
                    }
                }
            case .failure(let networkError):
                print(networkError)
            }
        }
    }

    func tvShowCredits(tvID: String) {
        ManagerProvider.sharedInstance.tvShowManager.credits(tvId: tvID, completionBlock: { result in
            switch result {
            case .success(let resultValue):
                print("\(String(describing: resultValue))")
            case .failure(let networkError):
                print(networkError.description)
            }
        })
    }
}
