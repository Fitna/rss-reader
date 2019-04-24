//
//  ChannelsViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class ChannelsViewController: UIViewController {
    @IBOutlet weak var cvChannels: UICollectionView!

    var channels: [RSSChannel] = [] { didSet { updateChannels() } }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Views
    private func setupViews() {
        self.cvChannels.register(UINib(nibName: RSSChannelCollectionViewCell.className, bundle: nil),
                                 forCellWithReuseIdentifier: RSSChannelCollectionViewCell.className)
        InnerNotification.channelsDidChange.startObserve(by: self, selector: #selector(channelsDidChange))
        InnerNotification.channelInfoDidChange.startObserve(by: self, selector: #selector(channelInfoDidChange))
        self.channels = DefaultsUtils.getChannels()

        for channel in channels where channel.title == nil {
            self.addChannel(with: channel.url)
        }
    }

    private func updateChannels() {
        cvChannels.reloadData()
    }

    // MARK: - User actions
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add RSS Channel", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "URL"
            if let string = UIPasteboard.general.string, let url = URL(string: string) {
                if url.host != nil && url.scheme != nil {
                    textField.text = string
                }
            }
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alert.textFields?.first?.text, let url = URL(string: text) {
                self.addChannel(with: url)
            }
        }
        alert.addAction(addAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
                self.cvChannels.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }

    private func addChannel(with url: URL) {
        guard url.host != nil, url.scheme != nil else {
            self.presentAlert(with: "Invalid URL")
            return
        }

        let channel = RSSChannel(url: url)
        RSSParcer.parce(channel) { _, error in
            if let error = error {
                self.presentAlert(with: error.localizedDescription)
            } else {
                DefaultsUtils.save(channel: channel)
            }
        }
    }
}

extension ChannelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSSChannelCollectionViewCell.className, for: indexPath)
        if let channelCell = cell as? RSSChannelCollectionViewCell {
            channelCell.delegate = self
            channelCell.channel = channels[safe: indexPath.item]
        }
        return cell
    }
}

extension ChannelsViewController: RSSChannelCollectionViewCellDelegate {
    func channelCellDidTapFavorites(_ cell: RSSChannelCollectionViewCell) {
        if let channel = cell.channel {
            channel.favorite = !channel.favorite
            DefaultsUtils.save(channel: channel)
        }
    }

    func channelCellDidTapDelete(_ cell: RSSChannelCollectionViewCell) {
        if let channel = cell.channel {
            DefaultsUtils.remove(channel: channel)
        }
    }
}
