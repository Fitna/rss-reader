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
    var favorite: Bool = false

    init(url: URL) {
        self.url = url
    }

    static func == (lhs: RSSChannel, rhs: RSSChannel) -> Bool {
        return lhs.url == rhs.url
    }
}
