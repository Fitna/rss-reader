//
//  ChannelsViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class ChannelsViewController: UIViewController {
    @IBOutlet weak var cvChannels: UICollectionView!

    var channels: [RSSChannel] = [] {
        didSet {
            updateChannels()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.channels = DefaultsUtils.getChannels()
    }

    func setupViews() {
        self.cvChannels.register(UINib(nibName: RSSChannelCollectionViewCell.className, bundle: nil),
                                 forCellWithReuseIdentifier: RSSChannelCollectionViewCell.className)
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

    // MARK: - Views
    func updateChannels() {
        cvChannels.reloadData()
    }

    // MARK: - Data
    func addChannel(with url: URL) {
    }
}

extension ChannelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSSChannelCollectionViewCell.className, for: indexPath)
        if let channelCell = cell as? RSSChannelCollectionViewCell {
            channelCell.channel = channels[safe: indexPath.item]
        }
        return cell
    }
}
