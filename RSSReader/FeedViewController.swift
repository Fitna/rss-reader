//
//  ViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class FeedViewController: UIViewController {
    var channels: [RSSChannel] = [] { didSet { updateChannels }}

    override func viewDidLoad() {
        super.viewDidLoad()
        channels = DefaultsUtils.getChannels()
    }
}
