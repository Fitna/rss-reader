//
//  RSSChannelCollectionViewCell.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

protocol RSSChannelCollectionViewCellDelegate: AnyObject {
    func channelCellDidTapFavorites(_ cell: RSSChannelCollectionViewCell)
    func channelCellDidTapDelete(_ cell: RSSChannelCollectionViewCell)
}

class RSSChannelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

    var channel: RSSChannel? { didSet { updateView() } }

    weak var delegate: RSSChannelCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
        lblName.text = channel?.title
        lblURL.text = channel?.url.absoluteString
    }

    @IBAction func addToFavoritesAction(_ sender: Any) {
        self.delegate?.channelCellDidTapFavorites(self)
    }

    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.channelCellDidTapDelete(self)
    }

    @IBAction func copyToClipboardAction(_ sender: Any) {
        UIPasteboard.general.string = channel?.url.absoluteString
    }
}
