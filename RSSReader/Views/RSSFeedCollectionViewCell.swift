//
//  RSSFeedCollectionViewCell.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit
import MWFeedParser

class RSSFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    var feedItem: MWFeedItem? { didSet { updateFeedItem() } }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateFeedItem() {
        if let date = feedItem?.date {
            let formatter = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                formatter.dateFormat = "HH:mm"
            } else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
                formatter.dateFormat = "MM/dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
            }
            self.lblTime.text = formatter.string(from: date)
        } else {
            self.lblTime.text = ""
        }

        self.lblTitle.text = feedItem?.title
        self.lblDescription.text = feedItem?.summary
    }
}
