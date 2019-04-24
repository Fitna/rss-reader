//
//  RSSChannelCollectionViewCell.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class RSSChannelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

    var channel: RSSChannel? { didSet { updateView() } }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
    }
}
