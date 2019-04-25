//
//  RSSChannel.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class RSSChannel: Codable, Equatable {
    let url: URL
    var title: String?
    var summary: String?
    var favorite: Bool

    init(url: URL, favorite: Bool = false) {
        self.url = url
        self.favorite = favorite
    }

    static func == (lhs: RSSChannel, rhs: RSSChannel) -> Bool {
        return lhs.url == rhs.url
    }
}
