//
//  MainViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 25/04/2019.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.viewControllers?[safe: 1] as? UINavigationController {
            if let fav = nav.viewControllers.first as? FeedViewController {
                fav.mode = .favorites
            }
        }
    }
}
