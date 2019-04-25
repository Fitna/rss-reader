//
//  ViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit
import MWFeedParser
import Nuke

enum FeedViewControllerMode {
    case all, favorites
}

class FeedViewController: UIViewController {
    @IBOutlet weak var cvFeed: UICollectionView!

    var channels: [RSSChannel] = [] { didSet { updateChannels() } }
    var feedItems: [MWFeedItem] = [] { didSet { updateFeedItems() } }
    var mode: FeedViewControllerMode = .all { didSet { updateChannels() } }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Views
    private func setupViews() {
        cvFeed.register(UINib(nibName: RSSFeedCollectionViewCell.className, bundle: nil),
                        forCellWithReuseIdentifier: RSSFeedCollectionViewCell.className)
        self.channels = DefaultsUtils.getChannels()

        InnerNotification.channelsDidChange.startObserve(by: self, selector: #selector(channelsDidChange))
        InnerNotification.channelInfoDidChange.startObserve(by: self, selector: #selector(channelInfoDidChange))
    }

    private func updateChannels() {
        feedItems = []
        for channel in channels {
            if mode == .favorites && !channel.favorite {
                continue
            }

            RSSParcer.parce(channel) { (items, _) in
                self.feedItems.append(contentsOf: items)
            }
        }
    }

    private func updateFeedItems() {
        self.loadViewIfNeeded()
        self.cvFeed.reloadData()
    }

    // MARK: - User actions
    @IBAction func refreshAction(_ sender: Any) {
        updateChannels()
    }

    // MARK: - Data
    @objc private func channelsDidChange(_ notification: Notification) {
        if let channels = notification.object as? [RSSChannel] {
            self.channels = channels
        }
    }

    @objc private func channelInfoDidChange(_ notification: Notification) {
        if let channel = notification.object as? RSSChannel {
            if let index = self.channels.firstIndex(of: channel) {
                self.channels[index] = channel
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let web = segue.destination as? WebViewViewController, let link = sender as? URL {
            web.link = link
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSSFeedCollectionViewCell.className, for: indexPath)
        if let feedCell = cell as? RSSFeedCollectionViewCell, let item = feedItems[safe: indexPath.item] {
            feedCell.feedItem = item
            feedCell.ivImage.image = UIImage(named: "rss60")

            if let imgURL = item.imageURL() {
                Nuke.loadImage(with: imgURL,
                               options: ImageLoadingOptions(failureImage: UIImage(named: "rss60")),
                               into: feedCell.ivImage)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let link = feedItems[safe: indexPath.item]?.link, let url = URL(string: link) {
            self.performSegue(withIdentifier: "toWebView", sender: url)
        }
    }
}
